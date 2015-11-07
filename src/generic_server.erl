-module(generic_server).
-export([start/1, init/1, recv/1]).

start(Port) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [Port], []).

init([Port]) ->
  case gen_tcp:listen(Port, []) of
  {ok, Socket} ->
    wait_connect(Socket, 0)
  end.

wait_connect(ListenSocket, Count) ->
  {ok, Socket} = gen_tcp:accept(ListenSocket),

  % delegate Socket control to new process
  gen_tcp:controlling_process(Socket,
                              spawn(?MODULE, recv, [Socket])),

  wait_connect(ListenSocket, Count + 1).

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
