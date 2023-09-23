:- object(git_remote_tests,
	extends(lgtunit)).

cover(git_remote(_)).

test(git_tag, exists(git_remote(TempRepo)::tag(_, Tag)), [setup(repo(TempRepo)), cleanup(remove_repo(TempRepo))]) :-
    tag_repo(TempRepo, Tag).

%% Helpers

:- use_module(library(git)).
:- use_module(library(filesex)).

remove_repo(Repo) :-
  delete_directory_and_contents(Repo).

repo(TempRepo) :-
  tmp_file("pgpm_git", TempRepo),
  os::ensure_directory(TempRepo),
  git(['-C',TempRepo, init], []).

tag_repo(TempRepo, Tag) :-
  git(['-C', TempRepo, commit, '--allow-empty', '-m',tagging], []),
  Tags = ['v1.0.0', 'v2.0.0'],
  list::member(Tag, Tags),
  git(['-C', TempRepo, tag, Tag], []).

:- end_object.