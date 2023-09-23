:- initialization((
    logtalk_load(inherit_hook),
	logtalk_load([
	    'extended_relations',
	    'config',
	    'metadata',
	    'version',
	    'env',
	    'selectors',
	    'fs',
	    'postgres',
	    'build',
	    'requirement',
	    'make_builder',
	    'origin',
	    'git_remote',
	    'path',
	    'git_rev',
	    'git',
	    'package',
	    'requirements/loader',
	    'tagged',
	    'inferences',
	    'git_tagged_revision_package',
	    'git_explicit_revision_package',
	    'pgpm'
	], [hook(inherit_hook)])
)).