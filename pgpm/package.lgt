
%% `package` protocol defines what's a package

:- protocol(package).

:- public([name/1, version/1, summary/1, description/1, origin/1, readme/1]).

:- end_protocol.