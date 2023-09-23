:- object(c_compiler(_Path), implements(requirement_satisfier)).

satisfied(c_compiler, c_compiler(Path)) :- parameter(1, Path), c_compiler(Path).

c_compiler(Path) :-
  env::available_executable('cc', Path).
c_compiler(Path) :-
  env::available_executable('gcc', Path).
c_compiler(Path) :-
  env::available_executable('clang', Path).

:- public([implementation/1, version_banner/1]).

implementation(Implementation) :-
  version_banner(Banner),
  (sub_string(Banner, _, _, _, "GCC") ->  Implementation = gcc;
   (sub_string(Banner, _, _, _, "clang") -> Implementation = clang; true)).

:- table(version_banner/1).

:- use_module(library(process)).

version_banner(Banner) :-
  parameter(1, Path),
  (nonvar(Path) -> true ; c_compiler(Path)),
  process_create(Path, ['--version'], [stdout(pipe(Out))]),
  read_string(Out, _, Banner).

:- end_object.