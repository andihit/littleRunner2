-module(manager).

-export([start_link/0, loop/1]).


%% ===================================================================
%% Application callbacks
%% ===================================================================

start_link() ->
	register(manager, spawn_link(?MODULE, loop, [dict:new()])).


send_to_others(AllClients, ExcludeClient, Msg) ->
	ExcludeFun = fun(Client) -> Client /= ExcludeClient end,
	Clients = lists:filter(ExcludeFun, dict:fetch_keys(AllClients)),

	SendFun = fun(Client) ->
		Client ! Msg
	end,
	lists:foreach(SendFun, Clients).


generate_guest_id(TakenIds) ->
	RandomNumber = list_to_binary(integer_to_list(random:uniform(99) + 1)),
	RandomId = << "Guest", RandomNumber/binary >>,

	case lists:member(RandomId, TakenIds) of
		true -> generate_guest_id(TakenIds);
		false -> RandomId
	end.

new_client(Clients, Pid) ->
	PlayerId = generate_guest_id(helper:dict_values(Clients)),
	lager:info("New client ~p with ID: ~p", [Pid, PlayerId]),
	
	Pid ! helper:json_encode([id, PlayerId]),
	state_manager ! {wantState, Pid, dict:fetch_keys(Clients)},
	
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
			state_manager ! {gotState, Data},
			NewClients = Clients;
		
		<< "keyChange" >> ->
			send_to_others(Clients, Pid, Json),
			NewClients = Clients;
		
		<< "nickChange" >> ->
			[_OldNick,NewNick] = Data,
			send_to_others(Clients, Pid, Json),
			NewClients = dict:store(Pid, NewNick, Clients)
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
