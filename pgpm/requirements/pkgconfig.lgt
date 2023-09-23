:- object(pkgconfig(_Name), implements([requirement_satisfier, versioned])).

:- use_module(library(process)).

satisfied(external_dependency(Name), pkgconfig(Name)) :-
  parameter(1, Name),
  env::available_executable('pkg-config', PkgConfig),
  process_create(PkgConfig, ['--exists', Name], [stdout(null), stderr(null), process(PID)]),
  % If it can't find it, it won't be successful
  process_wait(PID, exit(0)).

:- public(version/1).

:- use_module(library(readutil)).

version(Version) :-
  parameter(1, Name),
  env::available_executable('pkg-config', PkgConfig),
  process_create(PkgConfig, ['--modversion', Name], [stdout(pipe(VersionStream)), stderr(null), process(PID)]),
  read_line_to_string(VersionStream, VersionStr),
  atom_string(Version, VersionStr),
  process_wait(PID, exit(0)).

:- end_object.