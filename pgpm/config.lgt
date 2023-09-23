:- object(config).

:- public([set_hermetic_metadata/1, hermetic_metadata/1, set_hermetic/1, hermetic/1]).

set_hermetic_metadata(Hermetic) :-
  type::check(boolean, Hermetic),
  user::nb_setval(pgpm_hermetic_metadata, Hermetic).

hermetic_metadata(true) :- hermetic(true), !.
hermetic_metadata(Hermetic) :-
  user::nb_current(pgpm_hermetic_metadata, Hermetic).
hermetic_metadata(false) :-
  \+ user::nb_current(pgpm_hermetic_metadata, _).

set_hermetic(Hermetic) :-
  type::check(boolean, Hermetic),
  user::nb_setval(pgpm_hermetic, Hermetic).

hermetic(Hermetic) :-
  user::nb_current(pgpm_hermetic, Hermetic) -> true ; Hermetic = false.

:- public([set_metadata/1, metadata/1]).

set_metadata(Sink) :-
  user::nb_setval(pgpm_metadata, Sink).

metadata(Source) :-
  user::nb_current(pgpm_metadata, Source).

:- end_object.