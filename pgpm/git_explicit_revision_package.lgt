%% `git_explicit_revision_package` category

:- category(git_explicit_revision_package(_Version), implements(package)).

:- private([git_repo/1, git_revisions/1]).

origin(git_rev(Repo, Rev)) :-
  ::git_repo(Repo),
  ::git_revisions(Versions),
  parameter(1, Version),
  list::member(Rev: Version, Versions).

version(Version) :-
 parameter(1, Version),
 ::git_revisions(Versions),
 list::member(_Rev: Version, Versions).

:- end_category.