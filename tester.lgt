:- initialization((
    % this allows cover(Object) to work
    set_logtalk_flag(debug, on), set_logtalk_flag(source_data, on),
	logtalk_load(lgtunit(loader)),
	logtalk_load(os(loader)),
	logtalk_load(assertions(loader)),
	set_logtalk_flag(report, warnings),
	logtalk_load(loader),
	logtalk_load(hook_flows(loader)),
	Hooks = [assertions(debug), package_hook, lgtunit],
	logtalk_load(['tests/env', 'tests/fs', 'tests/git', 'tests/git_remote', 'tests/inference',
	              'tests/version'],
	             [hook(hook_set(Hooks))]),
	findall(T, (current_object(T), extends_object(T, lgtunit)), Ts),
	lgtunit::run_test_sets(Ts)
)).