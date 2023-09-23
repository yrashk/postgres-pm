%% `git_tagged_revision_package` category

:- category(git_tagged_revision_package(_Version), implements(package)).

:- private([git_repo/1]).

version(Version) :-
  parameter(1, Version),
  nonvar(Version),
  !.
version(Version) :-
  origin(Origin),
  Origin::tag(Tag),
  git::tag_version(Tag, Version).

origin(git_rev(Repo, Tag)) :-
  parameter(1, Version),
  ::git_repo(Repo),
  git_remote(Repo)::tag(_, Tag),
  git::tag_version(Tag, Version).

:- end_category.