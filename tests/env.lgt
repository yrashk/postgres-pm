:- object(env_tests,
	extends(lgtunit)).


cover(env).

test(os) :-
		env::os(OS), ::assertion(OS \= unknown).

test(available_executable) :- env::available_executable(env, _).

test(home_dir) :- env::home_dir(_).

test(application_cache_path) :- env::application_cache_path(testapp, Path), ::assertion(nonvar(Path)).

:- end_object.