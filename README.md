What is this?
=============

This repository has a couple of implementations of echo server, simply responds user sending data, written in [Erlang](http://www.erlang.org/). `generic` implementation uses gen_tcp module to receive data from client. Another implenetation, named `nonblocking`, uses prim_inet module for nonblocking connection. 

Building
========
You need Erlang run-time environment on your machine to execute this program. Please see the [Installation Guide](http://www.erlang.org/doc/installation_guide/INSTALL.html).

To build each servers, you just execute make command on the top directory of this repository like following.
```bash
user@host:~$ cd echo-server/
user@host:~/echo-server$ make
```

How to use?
===========
In what follows describes the way to execute each servers.

Generic
-------
### SERVER
You should start Erlang Emulator using `erl` command, then type 'generic_server:start(<port-number>).'. The `<port-number>` is arbitrary number which describes TCP port number. If you specify well-known port number, root privilege is needed.

Here is an execution example.
```
user@host:~/echo-server$ erl -pa ebin
Erlang/OTP 18 [erts-7.1] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Eshell V7.1  (abort with ^G)
1> generic_server:start(4000).
```

After entering command, the Generic Echo Server listens for connections from client.

### CLIENT
To connect the Generic Echo Server, you would do well to use `telnet` command like following.
```bash
user@host:~$ telnet localhost 4000
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
hoge
(Response) >> hoge
fuga
(Response) >> fuga
quit
Connection closed by foreign host.
user@host:~$
```
When you send a message, that is shown in the server-side screen. And you may get message that you sent. `quit` message makes connection closed.

Nonblocking
-----------
### SERVER
The wey to execute Nonblocking Echo Server is almost same with Generic Echo Server. you type `nonblocking_server:start(<port-number>).` like following.
```bash
user@host:~/echo-server$ erl -pa ebin/
Erlang/OTP 18 [erts-7.1] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Eshell V7.1  (abort with ^G)
1> nonblocking_server:start(4000).
{ok,<0.35.0>}
2> 
```
The difference between Generic Echo Server and this is state of server. Nonblocking Echo Server literally doesn't stop current processing by waiting user request.

### CLIENT
This is same with the other hand.
