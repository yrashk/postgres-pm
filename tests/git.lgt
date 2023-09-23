:- object(git_tests, extends(lgtunit), imports(git_tagged_revision_package(_))).

test(git_tag_version) :-
  ::assertion(git::tag_version('v1.0.0', '1.0.0')).

:- end_object.