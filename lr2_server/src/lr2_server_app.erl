-module(lr2_server_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	%% {Host, list({Path, Handler, Opts})}
    Dispatch = [{'_', [
        {'_', lr2_handler, []}
    ]}],
    %% Name, NbAcceptors, Transport, TransOpts, Protocol, ProtoOpts
    cowboy:start_listener(ami_ws_dispatcher, 100,
        cowboy_tcp_transport, [{port, 4444}],
        cowboy_http_protocol, [{dispatch, Dispatch}]
    ),
	
	state_manager:start_link(),
	manager:start_link(),
	
    lr2_server_sup:start_link().

stop(_State) ->
    ok.
