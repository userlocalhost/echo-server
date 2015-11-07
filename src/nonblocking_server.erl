-module(nonblocking_server).
-export([start/1, init/1, recv/1, handle_info/2]).

start(Port) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [Port], []).

init([Port]) ->
  case gen_tcp:listen(Port, []) of
  {ok, Socket} ->
    prim_inet:async_accept(Socket, -1)
  end.

recv(Socket) ->
  receive
    {tcp, Socket, Data} ->
      io:format("receive data: ~p~n", [Data]),
      case string:substr(Data, 1, 4) of
        "quit" ->
          close_socket(Socket);
        _ ->
          gen_tcp:send(Socket, "(Response) >> " ++ Data),
          recv(Socket)
      end;
    {tcp_closed, Socket} ->
      close_socket(Socket)
  end.

close_socket(Socket) ->
  io:format("socket close~n"),
  gen_tcp:close(Socket).

handle_info({inet_async, ListSock, _Ref, {ok, Socket}}, _State) ->
  prim_inet:async_accept(ListSock, -1),

  % delegate Socket control to new process
  gen_tcp:controlling_process(Socket,
                              spawn(?MODULE, recv, [Socket])),

  % sync Client Socket options with Server Socket 
  set_sockopt(ListSock, Socket),

  {noreply, 0}.

set_sockopt(ListSock, Socket) ->
  true = inet_db:register_socket(Socket, inet_tcp),
  {ok, Opts} = prim_inet:getopts(ListSock, [active, nodelay, keepalive, delay_send, priority, tos]),
  ok = prim_inet:setopts(Socket, Opts).
