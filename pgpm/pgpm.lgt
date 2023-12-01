:- object(package_hook, implements(expanding)).

merge_options([imports(Imports)|Rest], [imports(Imports_)|Rest_]) :-
  list::flatten([extended_relations, standard_inferences, Imports], Imports__),
  list::sort(Imports__, Imports_),
  merge_options(Rest, Rest_).

merge_options([implements(Implements)|Rest], [implements(Implements_)|Rest_]) :-
  list::flatten([package, requires, versioned, Implements], Implements__),
  list::sort(Implements__, Implements_),
  merge_options(Rest, Rest_).

merge_options([Option|Rest], [Option|Rest]).
merge_options([], []).

rename_identifier(Identifier, Identifier_) :-
  Identifier =.. [_|T],
  gensym::gensym('pgpm__package__', PrefixedIdent),
  Identifier_ =.. [PrefixedIdent|T].

term_expansion((:- Package), [(:- Object),
                              ('#directory'(Dir)),
                              ('#basename'(Basename)),
                              ('#source'(Source)),
                              ('#ident'(Ident))
                              ]) :-
  Package =.. [package, Ident|Options],
  (list::memberchk(imports(_), Options) -> Options1 = Options ; Options1 = [imports([extended_relations, standard_inferences])|Options]),
  (list::memberchk(implements(_), Options1) -> Options2 = Options ; Options2 = [implements([package, requires, versioned])|Options1]),
  merge_options(Options2, Options_),
  rename_identifier(Ident, PrefixedIdent),
  Object =.. [object, PrefixedIdent|Options_],
  logtalk_load_context(directory, Dir),
  logtalk_load_context(basename, Basename),
  logtalk_load_context(source, Source) .

term_expansion((:- end_package), (:- end_object)).

:- end_object.

:- object(pgpm).

:- public([load/1, package/1, specific_package/1, latest_package/1]).

load(Dir) :-
  os::directory_exists(Dir),
  !,
  findall(TargetFile,
    (fs::recursive_directory_files(Dir, Path, File),
     os::decompose_file_name(File, _, _, '.lgt'),
     atomic_list_concat([Dir, '/', Path, '/', File], TargetFile)
    ), Files),
  logtalk_load(Files, [hook(hook_set([inherit_hook,package_hook]))]).

load(Path) :-
  \+ os::directory_exists(Path),
  logtalk_load(Path, [hook(package_hook)]).

package(Package) :-
  current_object(Package),
  conforms_to_protocol(Package, package).

specific_package(Package) :-
  package(Package),
  %% has origin
  Package::origin(_),
  ground(Package).

latest_package(Package) :-
 var(Package), !, package(Package),
 latest_package(Package, _).

latest_package(Package) :-
 latest_package(Package, _).

latest_package(Package, Name) :-
  bagof((V, Package), (Package::name(Name), Package::version(V)), Vs),
  list::sort(1, @>, Vs, [(_, Package)|_]).

:- end_object.
