-module(state_manager).

-export([start_link/0, loop/1]).


%% ===================================================================
%% Application callbacks
%% ===================================================================

start_link() ->
	register(state_manager, spawn_link(?MODULE, loop, [[]])).


request_state(AllClients, ExcludeClient) ->
	ExcludeFun = fun(Client) -> Client /= ExcludeClient end,
	Clients = lists:filter(ExcludeFun, AllClients),
	
	%% if there are clients, send the first a state request
	if
		Clients /= [] ->
			[FirstPid|_] = Clients,
			FirstPid ! helper:json_encode([requestState]);
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
		{wantState, _Pid, []} ->
			loop(WaitingClients);
		{wantState, Pid, Clients} ->
			if
				WaitingClients == [] -> request_state(Clients, Pid);
				true -> ok
			end,
			loop(WaitingClients ++ [Pid]);
		{gotState, State} ->
			send_state(WaitingClients, helper:json_encode([state, State])),
			loop([])
	end.
