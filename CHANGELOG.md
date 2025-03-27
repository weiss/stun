* Fix types specification

# Version 1.2.15

* Updating fast_tls to version 1.1.22.

# Version 1.2.14

* Updating fast_tls to version 1.1.21.

# Version 1.2.13

* Updating fast_tls to version 1.1.20.
* Updating p1_utils to version 1.0.26.

# Version 1.2.12

* Updating fast_tls to version 1.1.19.

# Version 1.2.11

* Updating fast_tls to version 1.1.18.

# Version 1.2.10

* Improve dialyzer support

# Version 1.2.9

* Allow for specifying white/blacklists for clients and peers separately.

# Version 1.2.8

* Fix expiry of nonces.

# Version 1.2.7

* Handle transport autodetection error gracefully
* Remove unused error handling

# Version 1.2.6

* Updating fast_tls to version 1.1.16.
* Increase receive timeout

# Version 1.2.5

* Hand over error events to callback function.
* Improve TCP/TLS performance if no traffic shaper is configured.

# Version 1.2.4

* Improve handling of invalid `REQUESTED-ADDRESS-FAMILY` value.
* Apply minor logging improvements.
* Reopen listener sockets if they were closed.

# Version 1.2.3

* Don't complain about `proxy_protocol` option.
* Gracefully handle errors while receiving UDP data.
* Reduce log level of errors that may occur during normal operation.
* Restart listeners on failure.

# Version 1.2.2

* Updating fast_tls to version 1.1.15.
* Updating p1_utils to version 1.0.25.

# Version 1.2.1

* Updating fast_tls to version 1.1.14.
* Updating p1_utils to version 1.0.23.
* Include 'SOFTWARE' attribute in responses.
* Use random session IDs.

# Version 1.2.0

* Allow for whitelisting IP addresses/subnets.
* Accept expired credentials for TURN session refreshes.
* Accept additional TLS options/ciphers.

# Version 1.1.0

* Support the HAproxy protocol (v1 and v2).
* Don't close listener if accepting a connection fails.
* Only use new 'socket' backend for multiplexing TCP/TLS listeners.

# Version 1.0.47

* Disable new 'socket' backend for TCP/TLS connections on Windows.

# Version 1.0.46

* Use new 'socket' backend for TCP/TLS connections (on Erlang/OTP 23+).
* Support multiplexing TCP/TLS listeners (on Erlang/OTP 23+).

# Version 1.0.45

* Improve UDP receive performance.
* Reduce risk of UDP packet loss.
* Support multiple passwords to facilitate rollover.

# Version 1.0.44

* Updating fast_tls to version 1.1.13.
* Updating p1_utils to version 1.0.23.
* Switch from using Travis to Github Actions as CI

# Version 1.0.43

* Updating p1_utils to version 1.0.22.
* Updating fast_tls to version 1.1.12.
* stun_test: Start up transitive dependencies

# Version 1.0.42

* Updating fast_tls to version 1.1.11.

# Version 1.0.41

* Never accept Teredo/6to4 addresses as TURN peers.
* Never accept 0.0.0.0/:: addresses as TURN peers.

# Version 1.0.40

* Updating fast_tls to version 1.1.10.
* Updating p1_utils to version 1.0.21.

# Version 1.0.39

* Updating fast_tls to version 1.1.9.
* Exclude from Travis old OTP releases
* Reduce log level for requests from incompatible clients.

# Version 1.0.38

* Always log reason for TCP/TLS connection termination.
* Log relay allocation refreshes at notice level.
* Log duration of TURN sessions.
* Log STUN queries at debug (rather than info) level.
* Hand over more metadata to STUN callback.

# Version 1.0.37

* Updating p1_utils to version 1.0.20.
* Updating fast_tls to version 1.1.8.

# Version 1.0.36

* Log relay (de)allocation rather than authentication at notice level.
* Allow worker processes to perform cleanup tasks on shutdown.
* Support event callbacks.

# Version 1.0.35

* Updating fast_tls to version 1.1.7.
* Add session ID, transport, username, and IP addresses to log output.
* Log number of TURN-relayed bytes and packets.
* Log plain STUN (Binding) responses.
* Log all error responses.

# Version 1.0.34

* Allow for binding listeners to specific IP addresses.
* Use new logging API on Erlang/OTP 22+.

# Version 1.0.33

* Updating fast_tls to version 1.1.6.
* Updating p1_utils to version 1.0.19.
* Fix compatibility issues with Erlang 23
* Add support for ipv6 clients
* Improve compatibilty with clients

# Version 1.0.32

* Updating fast_tls to version 1.1.5.
* Make sure that 'turn\_ip' address is used for communicating with peer.
* Make sure that opened socket uses ipv4.

# Version 1.0.31

* Updating fast_tls to version 1.1.4.
* Updating p1_utils to version 1.0.18.
* Update copyright year

# Version 1.0.30

* Updating fast_tls to version 1.1.3.
* Updating p1_utils to version 1.0.17.

# Version 1.0.29

* Updating fast_tls to version 1.1.2.
* Updating p1_utils to version 1.0.16.

# Version 1.0.28

* Updating fast_tls to version 1.1.1.
* Updating p1_utils to version 1.0.15.

# Version 1.0.27

* Updating fast_tls to version 1.1.0.
* Updating p1_utils to version 1.0.14.
* Add contribution guide

# Version 1.0.26

* Updating fast_tls to version 1.0.26.

# Version 1.0.25

* Updating p1_utils to version 1.0.13.
* Updating fast_tls to version 1.0.25.

# Version 1.0.24

* Updating fast_tls to version f36ea5b74526c2c1c9c38f8d473168d95804f59d.
* Updating p1_utils to version 6ff85e8.

# Version 1.0.23

* Updating fast_tls to version 1.0.23.
* Updating p1_utils to version 1.0.12.
* Use p1\_fsm instead of gen\_fsm
* Remove unused dependency on port compiler

# Version 1.0.22

* Updating fast_tls to version a166f0e.

# Version 1.0.21

* Updating fast_tls to version 1.0.21.
* Updating p1_utils to version 1.0.11.
* Fix compilation with rebar3
* Fix warning about deprecated random
* Fix typo in README

# Version 1.0.20

* Updating fast_tls to version 1.0.20.

# Version 1.0.19

* Updating fast_tls to version 1.0.19.

# Version 1.0.18

* Updating fast_tls to version 71250ae.
* Fix compilation warnings

# Version 1.0.17

* Updating fast_tls to version 1.0.18.

# Version 1.0.16

* Updating fast_tls to version 1.0.17.

# Version 1.0.15

* Updating fast_tls to version 1.0.16.
* Updating p1_utils to version 1.0.10.

# Version 1.0.14

* Updating fast_tls to version 1.0.15.

# Version 1.0.13

* Updating fast_tls to version 1.0.14.
* Make test not crash on R20 (Paweł Chmielowski)

# Version 1.0.12

* Updating fast_tls to version 1.0.13.

# Version 1.0.11

* Update Fast TLS and p1_utils (Christophe Romain)

# Version 1.0.10

* Update Fast TLS and p1_utils (Christophe Romain)

# Version 1.0.9

* Update Fast TLS (Mickaël Rémond)

# Version 1.0.8

* Use p1_utils 1.0.6 (Christophe Romain)
* Update Fast TLS (Mickaël Rémond)

# Version 1.0.7

* Update Fast TLS and p1_utils (Mickaël Rémond)

# Version 1.0.6

* Update Fast TLS (Mickaël Rémond)

# Version 1.0.5

* Update Fast TLS and p1_utils (Mickaël Rémond)

# Version 1.0.4

* Use Fast TLS 1.0.4 (Mickaël Rémond)

# Version 1.0.3

* Use Fast TLS 1.0.3 (Mickaël Rémond)

# Version 1.0.2

* Use Fast TLS 1.0.2 (Mickaël Rémond)

# Version 1.0.1

* Use Fast TLS 1.0.1 (Mickaël Rémond)

# Version 1.0.0

* Prepare release on Hex.pm (Mickaël Rémond)
* Rename application to stun instead of p1_stun (Mickaël Rémond)
* Document usage (Evgeny Khramtsov) 
