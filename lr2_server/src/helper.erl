-module(helper).

-export([destruct/1, json_encode/1, json_decode/1, find_key/2]).


%% @doc Flatten {struct, [term()]} to [term()] recursively.
destruct({struct, L}) ->
    destruct(L);
destruct([H | T]) ->
    [destruct(H) | destruct(T)];
destruct({K, V}) ->
    {K, destruct(V)};
destruct(Term) ->
    Term.

%% @doc Shortcut functions for JSON en- and decoding
json_encode(Json) ->
	iolist_to_binary(mochijson2:encode(Json)).

json_decode(Json) ->
	mochijson2:decode(Json).

%% @doc dict: find key by value
find_key(Value, Dict) ->
	{Key, _Value} = lists:keyfind(Value, 2, dict:to_list(Dict)),
	Key.
