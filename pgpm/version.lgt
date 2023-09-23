:- object(version(_Version_)).

:- public([transform/1, major/1, minor/1, patch/1]).

:- public([match/1]).

:- use_module(library(dcg/basics), [integer//1]).
:- use_module(library(clpfd)).


version(semver(Major, Minor, Patch)) -->
    integer(Major), ".", integer(Minor), ".", integer(Patch), !.
version(semver(Major, Minor, 0)) -->
    integer(Major), ".", integer(Minor), !.
version(semver(Major, 0, 0)) -->
    integer(Major).
version(C) -->
   { list::member(Constraint, ['^', '~', '>', '<', '>=', '<=', '=']),
     atom_codes(Constraint, Codes),
     C =.. [Constraint, V]},
   Codes, version(V).


parse(V, Codes) :- phrase(version(V), Codes).

transform(V) :-
  parameter(1, Version),
  atom(Version),
  string_codes(Version, Codes),
  parse(V, Codes).

transform(V):-
  parameter(1, Version),
  var(Version),
  parse(V, Codes),
  atom_codes(Version, Codes).

match(Version1) :-
   atom(Version1) ,
   version(Version1)::transform(Version1_),
   match(Version1_).

match('='(semver(Major1, Minor1, Patch1))) :-
   match(semver(Major1, Minor1, Patch1)).

match(semver(Major1, Minor1, Patch1)) :-
   parameter(1, Version), ground(Version),
   transform(semver(Major, Minor, Patch)),
   Major #= Major1, Minor #= Minor1, Patch #= Patch1.

match('<'(semver(Major1, Minor1, Patch1))) :-
   parameter(1, Version), ground(Version),
   transform(semver(Major, Minor, Patch)),
   (Major #< Major1) #\/
   (Major #= Major1 #/\ Minor #< Minor1) #\/
   (Major #= Major1 #/\ Minor #= Minor1 #/\ Patch #< Patch1).

match('<='(semver(Major1, Minor1, Patch1))) :-
   parameter(1, Version), ground(Version),
   transform(semver(Major, Minor, Patch)),
   (Major #< Major1) #\/
   (Major #= Major1 #/\ Minor #< Minor1) #\/
   (Major #= Major1 #/\ Minor #= Minor1 #/\ Patch #=< Patch1).

match('>'(semver(Major1, Minor1, Patch1))) :-
   parameter(1, Version), ground(Version),
   transform(semver(Major, Minor, Patch)),
   (Major #> Major1) #\/
   (Major #= Major1 #/\ Minor #> Minor1) #\/
   (Major #= Major1 #/\ Minor #= Minor1 #/\ Patch #> Patch1).

match('>='(semver(Major1, Minor1, Patch1))) :-
   parameter(1, Version), ground(Version),
   transform(semver(Major, Minor, Patch)),
   (Major #> Major1) #\/
   (Major #= Major1 #/\ Minor #> Minor1) #\/
   (Major #= Major1 #/\ Minor #= Minor1 #/\ Patch #>= Patch1).

match('~'(semver(Major1, Minor1, Patch1))) :-
   parameter(1, Version), ground(Version),
   transform(semver(Major, Minor, Patch)),
   % If Minor1 is unspecified, it includes all versions within the same major version
    ( atom(Minor1) ->
        Major #= Major1
    ;
    % If Patch1 is unspecified, it includes all versions with the same major and minor version
      atom(Patch1) ->
        (Major #= Major1) #/\
        (Minor #= Minor1)
    ;
    % Regular tilde range
        (Major #= Major1) #/\
        (Minor #= Minor1) #/\
        (Patch #>= Patch1) #/\
        (Minor #< Minor1 + 1)
    ).

match('^'(semver(Major1, Minor1, Patch1))) :-
   parameter(1, Version), ground(Version),
   transform(semver(Major, Minor, Patch)),
       ((Major #> 0) #==>
           ((Major #= Major1) #/\
            ((Minor #> Minor1) #\/
             ((Minor #= Minor1) #/\
              (Patch #>= Patch1))))),
       ((Major #= 0 #/\ Minor #> 0) #==>
           ((Minor #= Minor1) #/\
            ((Patch #> Patch1) #\/
             (Patch #= Patch1)))),
       ((Major #= 0 #/\ Minor #= 0 #/\ Patch #> 0) #==>
           ((Patch #= Patch1) #/\ (Major1 #= 0) #/\ (Minor1 #= 0))).
:- end_object.

:- protocol(versioned).

:- public(version/1).

:- end_protocol.

:- object(version).

:- public(match/2).

match(X, Y) :-
  conforms_to_protocol(X, versioned),
  X::version(V),
  version(V)::match(Y).

:- end_object.