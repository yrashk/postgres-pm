:- object(git_rev(_Repo, _Rev), implements(origin)).

:- info([comment is 'Git origin']).

:- public([repo/1, rev/1, tag/1, commit/1]).

:- use_module(library(git)).

repo(Repo) :- parameter(1, Repo).
rev(Rev) :- parameter(2, Rev).

tag(Tag) :-
    commit(_Commit, Tag).

commit(Commit) :-
    commit(Commit, _).

commit(Commit, Tag) :-
    repo(Repo),
    rev(Tag),
    git_remote(Repo)::tag(Commit, Tag).


downloaded(Path) :-
  repo(Repo), rev(Rev),
  fs::valid_filename(Repo, RepoFilename),
  fs::valid_filename(Rev, RevFilename),
  env::application_cache_path(pgpm, Cache),
  format(atom(Path),"~s/git-~s-~s", [Cache,RepoFilename,RevFilename]),
  ({exists_directory(Path)}, ! ;
  config::hermetic(false),
  git(["clone", Repo, Path], []),
  git(["checkout", Rev],[directory(Path)])).


:- end_object.
