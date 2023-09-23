:- table(git_remote_tag_exec/2).

git_remote_tag_exec(Url, Out) :-
  git(["ls-remote", "--refs", "--tags", Url], [output(Out)]).

:- object(git_remote, implements(metadata_store)).

:- public(git_url_tag/3).
:- dynamic(git_url_tag/3).

metadata_predicate(git_url_tag/3).

:- end_object.

%% `git_remote`
:- object(git_remote(_Url_)).

:- public(tag/2).

:- use_module(library(git)).


tag(Rev, Tag) :-
    config::hermetic_metadata(false),
    {git_remote_tag_exec(_Url_, Out)},
    % Trim newline
    (list::append(TrimmedOut, [10], Out), ! ; TrimmedOut = Out),
    atom_codes(Output, TrimmedOut),
    atomic_list_concat(Lines, '\n', Output),
    list::member(Line, Lines),
    atomic_list_concat(L, '\t', Line),
    list::nth1(1, L, Rev),
    list::last(L, Last),
    atomic_list_concat(TagList, '/', Last),
    list::last(TagList, Tag),

    (\+ git_remote::git_url_tag(_Url_, Rev, Tag) ->
    git_remote::assertz(git_url_tag(_Url_, Rev, Tag)) ; true).

tag(Rev, Tag) :-
    config::hermetic_metadata(true),
    git_remote::git_url_tag(_Url_, Rev, Tag).

:- end_object.