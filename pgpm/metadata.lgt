:- protocol(metadata_store).

:- public(metadata_predicate/1).

:- end_protocol.

:- object(metadata).

:- public([fact/1, record/1]).

:- meta_predicate(fact(0)).

fact(Fact) :-
  current_object(O), conforms_to_protocol(O, metadata_store),
  O::metadata_predicate(F/A),
  list::length(Args, A),
  Fun =.. [F|Args],
  Fact = O::Fun,
  call(Fact).

:- public(save/1).

save(File) :-
  setup_call_cleanup(open(File, write, F),
    forall(::fact(O::T), write_term(F, (:- O::assertz(T)), [nl(true), fullstop(true), quoted(true)])),
    close(F)).

:- end_object.