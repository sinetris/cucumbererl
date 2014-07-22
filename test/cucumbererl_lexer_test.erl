-module(cucumbererl_lexer_test).
-define(LEXER,cucumbererl_lexer).

-include_lib("eunit/include/eunit.hrl").

tokenize_feature_header_test() ->
  {ok,Tokens,_} = ?LEXER:string("Feature: Tokenize me"),
  ?assertMatch([{feature_header,1,"Tokenize me"},{'$end',1}], Tokens).

tokenize_scenario_header_test() ->
  {ok,Tokens,_} = ?LEXER:string("Scenario: Tokenize me"),
  ?assertMatch([{scenario_header,1,"Tokenize me"},{'$end',1}], Tokens).

tokenize_given_step_test() ->
  {ok,Tokens,_} = ?LEXER:string("Given a description"),
  ?assertMatch([{given_step,1,"a description"},{'$end',1}], Tokens).

tokenize_when_step_test() ->
  {ok,Tokens,_} = ?LEXER:string("When a description"),
  ?assertMatch([{when_step,1,"a description"},{'$end',1}], Tokens).

tokenize_then_step_test() ->
  {ok,Tokens,_} = ?LEXER:string("Then a description"),
  ?assertMatch([{then_step,1,"a description"},{'$end',1}], Tokens).

tokenize_and_step_test() ->
  {ok,Tokens,_} = ?LEXER:string("And a description"),
  ?assertMatch([{and_step,1,"a description"},{'$end',1}], Tokens).

tokenize_but_step_test() ->
  {ok,Tokens,_} = ?LEXER:string("But a description"),
  ?assertMatch([{but_step,1,"a description"},{'$end',1}], Tokens).

tokenize_text_test() ->
  {ok,Tokens,_} = ?LEXER:string("This is a comment"),
  ?assertMatch([{text,1,"This is a comment"},{'$end',1}], Tokens).

tokenize_complete_feature_test() ->
  Result = [
    {feature_header,1,"Feature description"},
    {text,2,"This is a comment"},
    {scenario_header,3,"Scenario description"},
    {given_step,4,"a given step"},
    {and_step,5,"an and step"},
    {when_step,6,"a when step"},
    {but_step,7,"a but step"},
    {then_step,8,"a then step"},
    {'$end',8}
  ],
  {ok,Tokens,_} = ?LEXER:string("Feature: Feature description
    This is a comment
    Scenario: Scenario description
      Given a given step
      And an and step
      When a when step
      But a but step
      Then a then step"),
  ?assertMatch(Result, Tokens).
