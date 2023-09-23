:- object(make_builder(_Package), implements(builder)).

:- use_module(library(process), [process_create/3]).

:- public(process/2).
:- dynamic(process/2).

build :-
  make(Make),
  parameter(1, Package),
  Package::origin(Origin),
  Origin::downloaded(Path),
  make_pgconfig_arg(Arg1),
  (make_cc_arg(Arg2) *-> true; Arg2 = "CC="),
  Args = [Arg1, Arg2],
  process_create(Make, ["-C",Path|Args], [stdout(pipe(StreamOut)), stderr(pipe(StreamErr)), process(_Pid)]),
  assertz(process((StreamOut, StreamErr), _Pid)).

make_pgconfig_arg(Arg) :-
  postgres(_)::path_to_pg_config(PgConfig),
  format(string(Arg), "PG_CONFIG=~s", [PgConfig]).

make_cc_arg(Arg) :-
  parameter(1, Package),
  Package::requires(c_compiler),
  requirement::satisfied(c_compiler, c_compiler(C_Compiler)),
  format(string(Arg), "CC=~s", [C_Compiler]).

make(Make) :-
  parameter(1, Package),
  R = make(Make),
  Package::requires(R),
  R::satisfied.

:- end_object.