:- object(version_tests, extends(lgtunit)).

cover(version(_)).

example(positive, '1.2.3', '1.2.3').
example(positive, '1.2.3', '=1.2.3').
example(positive, '1.2', '1.2.0').
example(positive, '1.2', '=1.2.0').
example(positive, '1', '=1.0.0').

example(positive, '1', '>0').
example(positive, '1', '>=1').
example(positive, '1', '>=0').

example(positive, '1', '<2').
example(positive, '1', '<=1').
example(positive, '1', '<=2').

example(positive, '1.1', '>1.0').
example(positive, '1.1.100', '>1.1.50').

example(positive, '1.2.3', '^1').
example(negative, '2.1', '^1').
example(positive, '1.2.3', '^1.2').
example(negative, '2.2.3', '^1.2').
example(positive, '1.2.3', '^1.2.2').
example(positive, '1.2.3', '^1.2.3').
example(negative, '1.2.3', '^1.2.4').

example(positive, '1.2.3', '~1.2.1').
example(negative, '1.2.3', '~1.2.4').
example(negative, '1.3', '~1.2').

test(maj_min_patch) :-
  version('1.2.3')::transform(semver(1,2,3)).

test(maj_min) :-
  version('1.2')::transform(semver(1,2,0)).

test(maj) :-
  version('1')::transform(semver(1,0,0)).

test(positive) :-
  forall(example(positive, V, M), ::assertion(version(V)::match(M))).

test(negative) :-
  forall(example(negative, V, M), ::assertion(\+ version(V)::match(M))).


:- end_object.