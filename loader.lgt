:- initialization((
	logtalk_load([
	    dif(loader),
	    types(loader),
	    os(loader),
	    meta(loader),
	    json(loader),
	    coroutining(loader),
	    hook_flows(loader),
	    gensym(loader),
	    'pgpm/loader'
	], [
	])
)).