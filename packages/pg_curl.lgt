:- package(pg_curl(Version), imports([git_explicit_revision_package(Version)])).

:- inherit(requires/1).

git_repo("https://github.com/RekGRpth/pg_curl").

git_revisions([
       '502217c': '2.1.1',
       'bcde762': '2.1.0',
       '8cb8cfc': '2.0.2'
       % ...older versions omitted for now...
    ]).

requires(when(D := external_dependency(libcurl), version::match(D, '^7'))).

:- end_package.