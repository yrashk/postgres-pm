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
  MakeGoal = makefile_package::requires(make),
  ::assertion(MakeGoal),
  % and nothing else
  ::assertion((makefile_package::requires(R), \+ (R \= make))).

test(makefile_c_package_requires_make_and_c_compiler) :-
  MakeGoal = makefile_c_package::requires(make),
  CompilerGoal = makefile_c_package::requires(c_compiler),
  ::assertion((MakeGoal, CompilerGoal)).

test(meta_json_inferences) :-
  ::assertion(pgxn_package::summary("Unit testing for PostgreSQL")),
  ::assertion(pgxn_package::description(_)),
  ::assertion(pgxn_package::tagged(_)).


:- end_object.