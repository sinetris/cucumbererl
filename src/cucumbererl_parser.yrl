Nonterminals grammar features scenarios scenario steps givens whens thens
and_but.

Terminals feature_header scenario_header given_step when_step then_step
and_step but_step.

Rootsymbol grammar.

%% There are 9 shift/reduce conflicts coming from the thrown errors
Expect 9.

Endsymbol '$end'.

%% operator precedence

%% grammer rules

grammar   -> features                 : ['$1'].
grammar   -> grammar features         : ['$1'|'$2'].
features  -> feature_header scenarios : build_feature('$1', '$2').
scenarios -> '$empty'                 : nil.
scenarios -> scenario                 : ['$1'].
scenarios -> scenarios scenario       : ['$1'|'$2'].
scenario  -> scenario_header steps    : build_scenario('$1', '$2').
steps     -> '$empty'                 : nil.
steps     -> givens whens thens       : ['$1', '$2', '$3'].
givens    -> given_step               : build_steps('given_', ['$1']).
givens    -> given_step and_but       : build_steps('given_', ['$1'|'$2']).
whens     -> when_step                : build_steps('when_', ['$1']).
whens     -> when_step and_but        : build_steps('when_', ['$1'|'$2']).
thens     -> then_step                : build_steps('then_', ['$1']).
thens     -> then_step and_but        : build_steps('then_', ['$1'|'$2']).
and_but   -> and_step                 : ['$1'].
and_but   -> but_step                 : ['$1'].
and_but   -> and_but and_step         : ['$1'|'$2'].
and_but   -> and_but but_step         : ['$1'|'$2'].

%% Throw more descriptive errors

givens    -> and_but given_step       : throw_misplaced_and('$1').
whens     -> and_but when_step        : throw_misplaced_and('$1').
thens     -> and_but then_step        : throw_misplaced_and('$1').

Erlang code.

value_of(Token) ->
  element(3, Token).
line_of(Token) ->
  element(2, Token).

build_feature({feature_header, _Line, Description}, Scenario) ->
  {feature, Description, Scenario}.

build_scenario({scenario_header, _Line, Description}, Steps) ->
  {scenario, Description, Steps}.

build_steps(_Name, []) -> [];
build_steps(Name, [H|T]) ->
  [build_step(Name, H)|build_steps(Name, T)].

build_step(Name, {_Name, _Line, Description}) ->
  {Name, Description}.

%% Errors functions

throw(Line, Error, Token) ->
  return_error(Line, [Error, Token]).

throw_misplaced_and([Token|_]) ->
  throw(line_of(Token), "unexpected And. Syntax error before: ",
    value_of(Token)).
