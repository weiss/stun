%%%----------------------------------------------------------------------
%%% File    : stun_listener.erl
%%% Author  : Evgeniy Khramtsov <ekhramtsov@process-one.net>
%%% Purpose : 
%%% Created : 9 Jan 2011 by Evgeniy Khramtsov <ekhramtsov@process-one.net>
%%%
%%%
%%% Copyright (C) 2002-2020 ProcessOne, SARL. All Rights Reserved.
%%%
%%% Licensed under the Apache License, Version 2.0 (the "License");
%%% you may not use this file except in compliance with the License.
%%% You may obtain a copy of the License at
%%%
%%%     http://www.apache.org/licenses/LICENSE-2.0
%%%
%%% Unless required by applicable law or agreed to in writing, software
%%% distributed under the License is distributed on an "AS IS" BASIS,
%%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%% See the License for the specific language governing permissions and
%%% limitations under the License.
%%%
%%%----------------------------------------------------------------------

-module(stun_listener).

-behaviour(gen_server).

%% API
-export([start_link/0, add_listener/3, del_listener/2, start_listener/4]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(TCP_SEND_TIMEOUT, 10000).
-record(state, {listeners = #{}}).

%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add_listener(Port, Transport, Opts) ->
    gen_server:call(?MODULE, {add_listener, Port, Transport, Opts}).

del_listener(Port, Transport) ->
    gen_server:call(?MODULE, {del_listener, Port, Transport}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    {ok, #state{}}.

handle_call({add_listener, Port, Transport, Opts}, _From, State) ->
    case maps:find({Port, Transport}, State#state.listeners) of
	{ok, _} ->
	    Err = {error, already_started},
	    {reply, Err, State};
	error ->
	    {Pid, MRef} = spawn_monitor(?MODULE, start_listener,
					[Port, Transport, Opts, self()]),
	    receive
		{'DOWN', MRef, _Type, _Object, Info} ->
		    Res = {error, Info},
		    format_listener_error(Port, Transport, Opts, Res),
		    {reply, Res, State};
		{Pid, Reply} ->
		    case Reply of
			{error, _} = Err ->
			    format_listener_error(Port, Transport, Opts, Err),
			    {reply, Reply, State};
			ok ->
			    Listeners = maps:put(
					  {Port, Transport}, {MRef, Pid, Opts},
					  State#state.listeners),
			    {reply, ok, State#state{listeners = Listeners}}
		    end
	    end
    end;
handle_call({del_listener, Port, Transport}, _From, State) ->
    case maps:find({Port, Transport}, State#state.listeners) of
	{ok, {MRef, Pid, _Opts}} ->
	    catch erlang:demonitor(MRef, [flush]),
	    catch exit(Pid, kill),
	    Listeners = maps:remove({Port, Transport}, State#state.listeners),
	    {reply, ok, State#state{listeners = Listeners}};
	error ->
	    {reply, {error, notfound}, State}
    end;
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({'DOWN', MRef, _Type, _Pid, Info}, State) ->
    Listeners = maps:filter(
		  fun({Port, Transport}, {Ref, _, _}) when Ref == MRef ->
			  error_logger:error_msg("listener on ~p/~p failed: ~p",
						 [Port, Transport, Info]),
			  false;
		     (_, _) ->
			  true
		  end, State#state.listeners),
    {noreply, State#state{listeners = Listeners}};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
start_listener(Port, Transport, Opts, Owner)
  when Transport == tcp; Transport == tls ->
    {Opts1, SockOpts} = split_opts(Opts),
    OptsWithTLS = case Transport of
		      tls -> [tls|Opts1];
		      tcp -> Opts1
		  end,
    case gen_tcp:listen(Port, [binary,
                               {packet, 0},
                               {active, false},
                               {reuseaddr, true},
                               {nodelay, true},
                               {keepalive, true},
			       {send_timeout, ?TCP_SEND_TIMEOUT},
			       {send_timeout_close, true} | SockOpts]) of
        {ok, ListenSocket} ->
            Owner ! {self(), ok},
	    OptsWithTLS1 = stun:tcp_init(ListenSocket, OptsWithTLS),
            accept(ListenSocket, OptsWithTLS1);
        Err ->
            Owner ! {self(), Err}
    end;
start_listener(Port, udp, Opts, Owner) ->
    {Opts1, SockOpts} = split_opts(Opts),
    case gen_udp:open(Port, [binary,
			     {active, false},
			     {reuseaddr, true} | SockOpts]) of
	{ok, Socket} ->
	    Owner ! {self(), ok},
	    Opts2 = stun:udp_init(Socket, Opts1),
	    udp_recv(Socket, Opts2);
	Err ->
	    Owner ! {self(), Err}
    end.

accept(ListenSocket, Opts) ->
    case gen_tcp:accept(ListenSocket) of
        {ok, Socket} ->
            case {inet:peername(Socket),
                  inet:sockname(Socket)} of
                {{ok, {PeerAddr, PeerPort}}, {ok, {Addr, Port}}} ->
                    error_logger:info_msg("accepted connection: ~s:~p -> ~s:~p",
					  [inet_parse:ntoa(PeerAddr), PeerPort,
					   inet_parse:ntoa(Addr), Port]),
                    case stun:start({gen_tcp, Socket}, Opts) of
                        {ok, Pid} ->
                            gen_tcp:controlling_process(Socket, Pid);
                        Err ->
                            Err
                    end;
                Err ->
                    error_logger:error_msg("unable to fetch peername: ~p", [Err]),
                    Err
            end,
            accept(ListenSocket, Opts);
        Err ->
            Err
    end.

udp_recv(Socket, Opts) ->
    case gen_udp:recv(Socket, 0) of
	{ok, {Addr, Port, Packet}} ->
	    case catch stun:udp_recv(Socket, Addr, Port, Packet, Opts) of
		{'EXIT', Reason} ->
		    error_logger:error_msg("failed to process UDP packet:~n"
					   "** Source: {~p, ~p}~n"
					   "** Reason: ~p~n** Packet: ~p",
					   [Addr, Port, Reason, Packet]),
		    udp_recv(Socket, Opts);
		NewOpts ->
		    udp_recv(Socket, NewOpts)
	    end;
	{error, Reason} ->
	    error_logger:error_msg(
	      "unexpected UDP error: ~s", [inet:format_error(Reason)]),
	    erlang:error(Reason)
    end.

split_opts(Opts) ->
    lists:partition(fun({ip, _Val}) -> false;
		       ({fd, _Val}) -> false;
		       ({backlog, _Val}) -> false;
		       (inet6) -> false;
		       (inet) -> false;
		       (_Opt) -> true
		    end, Opts).

format_listener_error(Port, Transport, Opts, Err) ->
    error_logger:error_msg("failed to start listener:~n"
			   "** Port: ~p~n"
			   "** Transport: ~p~n"
			   "** Options: ~p~n"
			   "** Reason: ~p",
			   [Port, Transport, Opts, Err]).
