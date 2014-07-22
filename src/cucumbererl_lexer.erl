-module(cucumbererl_lexer).

-export([string/1]).

string(String) ->
  Scan = scan(lines(String), 1),
  {ok, Scan, nil}.

lines(String) ->
  re:split(String,"\n",[{return,list}]).


scan([], TokenLine) -> [{'$end', TokenLine-1}];
scan([Line|Lines], TokenLine) ->
  [tokenize(Line, TokenLine)|scan(Lines, TokenLine+1)].

tokenize(Line, TokenLine) ->
  {ok,MP} = re:compile("\s*(?<A>Feature:|Scenario:)\s?\s*(?<B>.+)?\s*|\s*(?<A>Given|When|Then|And|But)\s+(?<B>.+)\s*", [dupnames]),
  case re:run(Line, MP, [{capture, all_names, list}]) of
    {match, ["Feature:", Description]} ->
      {feature_header,TokenLine, Description};
    {match, ["Scenario:", Description]} ->
      {scenario_header,TokenLine, Description};
    {match, ["Given", Description]} ->
      {given_step,TokenLine, Description};
    {match, ["When", Description]} ->
      {when_step,TokenLine, Description};
    {match, ["Then", Description]} ->
      {then_step,TokenLine, Description};
    {match, ["And", Description]} ->
      {and_step,TokenLine, Description};
    {match, ["But", Description]} ->
      {but_step,TokenLine, Description};
    _ ->
      {text, TokenLine, string:strip(Line)}
  end.
