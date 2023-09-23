:- package(plpgsql_check(Version), imports([git_tagged_revision_package(Version)])).

git_repo("https://github.com/okbob/plpgsql_check").

% Minor typos fixed
description("The plpgsql_check is PostgreSQL extension with functionality for direct or indirect extra \c
            validation of functions in plpgsql language. It verifies a validity of SQL identifiers used in plpgsql code. \c
            It tries to identify performance issues. Modern versions has integrated profiler. \c
            Table and function dependencies can be displayed.").

:- end_package.