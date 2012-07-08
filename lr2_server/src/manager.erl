-module(manager).

-export([start_link/0, loop/1]).


%% ===================================================================
%% Application callbacks
%% ===================================================================

start_link() ->
	register(manager, spawn_link(?MODULE, loop, [dict:new()])).


send_to_others(Clients, Pid, Msg) ->
	F = fun(Client) ->
		if
			Client /= Pid -> Client ! Msg;
			true -> ok
		end
	end,
	lists:foreach(F, dict:fetch_keys(Clients)).


generate_guest_id() ->
	RandomNumber = list_to_binary(integer_to_list(random:uniform(99) + 1)),
	<< "Guest", RandomNumber/binary >>.

new_client(Clients, Pid) ->
	PlayerId = generate_guest_id(),
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
																 [{<<"id">>, PlayerId}, {<<"score">>, 0}]
																}])),

	PlayerId.

handle_message(Clients, Pid, Json) ->
	[Type, Data] = helper:json_decode(Json),
	lager:info("Message from ~p: ~p ~p", [Pid, Type, Data]),
	
	case Type of
		<< "state" >> ->
			[PlayerId, State] = Data,
			PlayerPid = helper:find_key(PlayerId, Clients),
			PlayerPid ! helper:json_encode([state, State]),
			NewClients = Clients;
		<< "keyChange" >> ->
			send_to_others(Clients, Pid, Json),
			NewClients = Clients;
		<< "nickChange" >> ->
			[_OldNick,NewNick] = Data,
			NewClients = dict:store(Pid, NewNick, Clients),
			send_to_others(NewClients, Pid, Json)
	end,
	NewClients.

loop(Clients) ->
	lager:info("Current Clients: ~p", [dict:to_list(Clients)]),
	
	receive
		{newclient, Pid} ->
			PlayerId = new_client(Clients, Pid),
			loop(dict:store(Pid, PlayerId, Clients));
		{message, Pid, Msg} ->
			NewClients = handle_message(Clients, Pid, Msg),
			loop(NewClients);
		{lostclient, Pid} ->
			lager:info("Lost client ~p", [Pid]),
			PlayerPid = dict:fetch(Pid, Clients),
			send_to_others(Clients, Pid, helper:json_encode([lostPlayer, PlayerPid])),
			loop(dict:erase(Pid, Clients))
	end.
