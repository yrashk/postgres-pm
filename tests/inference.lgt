:- package(makefile_package).

origin(path(Path)) :-
  '#directory'(ThisPath),
  atomic_list_concat([ThisPath, '/fixtures/makefile_package'], Path).

:- end_package.

:- package(makefile_c_package).

origin(path(Path)) :-
  '#directory'(ThisPath),
  atomic_list_concat([ThisPath, '/fixtures/makefile_c_package'], Path).

:- end_package.

:- package(pgxn_package).

origin(path(Path)) :-
  '#directory'(ThisPath),
  atomic_list_concat([ThisPath, '/fixtures/pgxn_package'], Path).

:- end_package.

:- object(inference_tests, extends(lgtunit)).

cover(make_requirement_inference).
cover(c_compiler_requirement_inference).
cover(meta_json_inferences).

test(makefile_package_requires_make) :-
  current_object(O), implements_protocol(O, package), O::'#ident'(makefile_package),
  MakeGoal = O::requires(make),
  ::assertion(MakeGoal),
  % and nothing else
  ::assertion((O::requires(R), \+ (R \= make))).

test(makefile_c_package_requires_make_and_c_compiler) :-
  current_object(O), implements_protocol(O, package), O::'#ident'(makefile_c_package),
  MakeGoal = O::requires(make),
  CompilerGoal = O::requires(c_compiler),
  ::assertion((MakeGoal, CompilerGoal)).

test(meta_json_inferences) :-
  current_object(O), implements_protocol(O, package), O::'#ident'(pgxn_package),
  ::assertion(O::summary("Unit testing for PostgreSQL")),
  ::assertion(O::description(_)),
  ::assertion(O::tagged(_)).


:- end_object.