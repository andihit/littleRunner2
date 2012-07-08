-module(state_manager).

-export([start_link/0, loop/1]).


%% ===================================================================
%% Application callbacks
%% ===================================================================

start_link() ->
	register(state_manager, spawn_link(?MODULE, loop, [[]])),
	timer:send_interval(5000, manager, {syncState}).


request_state(Client) ->
	Client ! helper:json_encode([requestState]).

request_state(AllClients, ExcludeClient) ->
	Clients = helper:list_filter_value(AllClients, ExcludeClient),
	
	if
		length(Clients) > 0 ->
			[FirstClient|_] = Clients,
			request_state(FirstClient);
		true -> ok
	end.

send_state([], _JsonState) ->
	[];
send_state([Client|WaitingClients], JsonState) ->
	Client ! JsonState,
	send_state(WaitingClients, JsonState).

loop(WaitingClients) ->
	lager:info("Clients waiting for state: ~p", [WaitingClients]),
	
	receive
		{wantState, Pid, Clients} when length(Clients) > 0 ->
			if
				length(WaitingClients) == 0 -> request_state(Clients, Pid);
				true -> ok
			end,
			loop(WaitingClients ++ [Pid]);
		{wantState, _Pid, _Clients} ->
			loop(WaitingClients);
		
		{syncState, AllClients} when length(AllClients) >= 2 ->
			[FirstClient|OtherClients] = AllClients,
			request_state(FirstClient),
			loop(WaitingClients ++ OtherClients);
		{syncState, _AllClients} ->
			loop(WaitingClients);
		
		{gotState, State} ->
			send_state(WaitingClients, helper:json_encode([state, State])),
			loop([]);
		
		Other ->
			lager:error("Unknown message in state_manager: ~p", [Other]),
			loop(WaitingClients)
	end.
