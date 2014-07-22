-module(cucumbererl_test).

-include_lib("eunit/include/eunit.hrl").

empty_test() ->
    ?assert((1+1) =:= 2).
