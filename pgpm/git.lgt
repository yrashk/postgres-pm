%% `git` object
:- object(git).

:- use_module(library(git)).

:- public(tag_version/2).

tag_version(Tag, Version) :-
  atom_chars(Tag, TagChars),
  tag_version_chars(TagChars, Version).

tag_version_chars([v|VersionChars], Version) :-
  atom_chars(Version, VersionChars).

:- end_object.