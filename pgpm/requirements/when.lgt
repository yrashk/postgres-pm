:- object(when, implements(requirement_satisfier)).

:- meta_predicate(satisfied(^, *)).

satisfied(when(Name := Req, Goal), Satisfier) :-
  Name = Satisfier,
  requirement::satisfied(Req, Satisfier),
  call(Goal).

:- end_object.