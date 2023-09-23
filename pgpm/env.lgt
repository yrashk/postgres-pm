:- object(env).

:- public([os/1, available_executable/2, application_cache_path/2, home_dir/1]).

os(windows) :- user:current_predicate(win_exec/2), !.
os(macos) :- user:current_predicate(apple_current_locale_identifier/1), !.
os(unix) :- user:current_predicate(shell/1), !.
os(unknown) :- !.

:- table(available_executable/2).

available_executable(Name, Path) :- absolute_file_name(path(Name), Path, [access([execute])]).

application_cache_path(Application, Path) :-
  os(macos),
  !, % don't need to explore more options
  home_dir(HomeDir),
  atomic_list_concat([HomeDir, "/Library/Caches/", Application], Path).
application_cache_path(Application, Path) :-
  os(unix),
  home_dir(HomeDir),
  (os::environment_variable('XDG_CACHE_HOME', CacheHome) -> atomic_list_concat([CacheHome, '/', Application], Path) ;
    atomic_list_concat([HomeDir, '/.cache/', Application], Path)).
% TODO: non-UNIX support

home_dir(Path) :-
   expand_file_name("~", [Path]).

:- end_object.