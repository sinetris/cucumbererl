-module(cucumbererl_parser_test).
-define(LEXER,cucumbererl_lexer).
-define(PARSER,cucumbererl_parser).

-include_lib("eunit/include/eunit.hrl").

basic_complete_test() ->
  Result = {ok,[
    {feature,"Feature description",[
      {scenario,"Scenario description",[
        [{given_,"I have a Given"},{given_,"I have an and"}],
        [{when_,"I add a when"}],
        [{then_,"I have a then"}]
      ]}
    ]}
  ]},
  Tokens = [
    {feature_header,1,"Feature description"},
    {scenario_header,2,"Scenario description"},
    {given_step,3,"I have a Given"},
    {and_step,4,"I have an and"},
    {when_step,5,"I add a when"},
    {then_step,6,"I have a then"},
    {'$end',6}
  ],
  Parsed = ?PARSER:parse(Tokens),
  ?assertMatch(Result, Parsed).

error_and_step_in_wrong_place_test() ->
  Tokens = [
    {feature_header,1,"Feature description"},
    {scenario_header,2,"Scenario description"},
    {and_step,3,"I have an and"},
    {given_step,4,"I have a Given"},
    {when_step,5,"I add a when"},
    {then_step,6,"I have a then"},
    {'$end',6}
  ],
  Expect = {
    error,
    {
      3,
      cucumbererl_parser,
      ["unexpected And. Syntax error before: ","I have an and"]
    }
  },
  Result = ?PARSER:parse(Tokens),
  ?assertMatch(Expect, Result).
