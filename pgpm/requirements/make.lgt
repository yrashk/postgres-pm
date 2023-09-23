:- object(make(_Path), implements(requirement_satisfier)).

satisfied(make, make(Path)) :- parameter(1, Path), make(Path).

make(Path) :-
  env::available_executable('make', Path).
make(Path) :-
  env::available_executable('gmake', Path).

:- end_object.