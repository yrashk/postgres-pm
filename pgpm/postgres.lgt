:- object(postgres(_Instance_)).

:- public(path_to_pg_config/1).

path_to_pg_config(Path) :-
  parameter(1, Instance),
  var(Instance),
  env::available_executable(pg_config, Path).


:- end_object.