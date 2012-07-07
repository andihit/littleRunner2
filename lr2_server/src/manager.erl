-module(manager).

-export([start/0, loop/1]).


%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
	%% {Host, list({Path, Handler, Opts})}
    Dispatch = [{'_', [
        {'_', lr2_handler, []}
    ]}],
    %% Name, NbAcceptors, Transport, TransOpts, Protocol, ProtoOpts
    cowboy:start_listener(ami_ws_dispatcher, 100,
        cowboy_tcp_transport, [{port, 4444}],
        cowboy_http_protocol, [{dispatch, Dispatch}]
    ),
	register(manager, spawn(?MODULE, loop, [dict:new()])).


send_to_others(Clients, Pid, Msg) ->
	F = fun(Client) ->
		if
			Client /= Pid -> Client ! Msg;
			true -> ok
		end
	end,
	lists:foreach(F, dict:fetch_keys(Clients)).


generate_unique_id() ->
	{_MegaSecs, _Secs, MicroSecs} = now(),
	MicroSecs.

new_client(Clients, Pid) ->
	PlayerId = generate_unique_id(),
	lager:info("New client ~p with ID: ~p", [Pid, PlayerId]),
	Pid ! helper:json_encode([id, PlayerId]),
	
	%% if there are clients, send the first a state request
	NumClients = dict:size(Clients),
	if
		NumClients >= 1 ->
			[{FirstPid, _}|_] = dict:to_list(Clients),
			FirstPid ! helper:json_encode([requestState, PlayerId]);
		true -> ok
	end,
	
	%% register new player to others
	send_to_others(Clients, Pid, helper:json_encode([newPlayer, {struct,
																 [{<<"id">>, PlayerId}]
																}])),

	PlayerId.

handle_message(Clients, Pid, Json) ->
	[Type, Data] = helper:json_decode(Json),
	lager:info("Message from ~p: ~p ~p", [Pid, Type, Data]),
	
	case Type of
		<< "state" >> ->
			[PlayerId, State] = Data,
			PlayerPid = helper:find_key(PlayerId, Clients),
			PlayerPid ! helper:json_encode([state, State]);
		<< "keyChange" >> ->
			send_to_others(Clients, Pid, Json)
	end.

loop(Clients) ->
	lager:info("Current Clients: ~p", [dict:to_list(Clients)]),
	
	receive
		{newclient, Pid} ->
			PlayerId = new_client(Clients, Pid),
			loop(dict:store(Pid, PlayerId, Clients));
		{lostclient, Pid} ->
			lager:info("Lost client ~p", [Pid]),
			PlayerPid = dict:fetch(Pid, Clients),
			send_to_others(Clients, Pid, helper:json_encode([lostPlayer, PlayerPid])),
			loop(dict:erase(Pid, Clients));
		{message, Pid, Msg} ->
			handle_message(Clients, Pid, Msg),
			loop(Clients)
	end.
