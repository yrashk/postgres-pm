% `requirement` protocol

:- protocol(requirement_satisfier).

:- public([satisfied/2]).

:- end_protocol.

% `requires` protocol

:- protocol(requires).

:- public([requires/1]).

:- end_protocol.

:- object(requirement).

:- public(satisfied/2).

satisfied(Requirement, Satisfactor) :-
  current_object(O), conforms_to_protocol(O, requirement_satisfier),
  O::satisfied(Requirement, Satisfactor).

:- end_object.