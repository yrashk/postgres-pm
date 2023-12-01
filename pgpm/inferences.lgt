:- object(origin_artifacts, implements(metadata_store)).

:- dynamic([meta_json/2, readme/2]).
:- public([meta_json/2, readme/2]).

metadata_predicate(meta_json/2).
metadata_predicate(readme/2).

:- end_object.

%% `inferred_package_name` category implements `package::name/1`
%% by inferring the name from the object name.

:- category(inferred_package_name).

:- public([name/1]).

name(Name) :-
  ::'#ident'(Ident),
  functor(Ident, Name, _).

:- end_category.

:- category(readme_inference).

:- use_module(library(readutil)).

:- table(readme/1).

readme(Readme) :-
    config::hermetic_metadata(false),
    ::origin(Origin),
    Origin::downloaded(Path),
    atomic_list_concat([Path, "/README"], ReadmeFile),
    os::file_exists(ReadmeFile),
    read_file_to_string(ReadmeFile, Readme, []),
    origin_artifacts::assertz(readme(Origin, Readme)).

 readme(markdown(Readme)) :-
     config::hermetic_metadata(false),
     ::origin(Origin),
     Origin::downloaded(Path),
     atomic_list_concat([Path, "/README.md"], ReadmeFile),
     os::file_exists(ReadmeFile),
     read_file_to_string(ReadmeFile, Readme, []),
     origin_artifacts::assertz(readme(Origin, markdown(Readme))).

readme(Readme) :-
     config::hermetic_metadata(true),
     ::origin(Origin),
     origin_artifacts::readme(Origin, Readme).

:- end_category.

:- category(meta_json_inferences, implements([package, tagged])).

summary(Summary) :-
    meta_package(json(JSON)),
    list::member(abstract:Abstract, JSON),
    atom_string(Abstract, Summary).

summary(Summary) :-
    meta_package(json(JSON)),
    ::name(Name),
    list::member(provides:Provides, JSON),
    list::member(Name:Details, Provides),
    list::member(abstract:Abstract, Details),
    atom_string(Abstract, Summary).

description(Description) :-
    meta_package(json(JSON)),
    list::member(description:Description_, JSON),
    atom_string(Description_, Description).

description(Description) :-
    meta_package(json(JSON)),
    ::name(Name),
    list::member(provides:Provides, JSON),
    list::member(Name:Details, Provides),
    list::member(description:Description_, Details),
    atom_string(Description_, Description).

tagged(Tag) :-
    meta_package(json(JSON)),
    list::member(tags:Tags, JSON),
    list::member(Tag, Tags).

:- table(meta_package/1).

meta_package(JSON) :-
    config::hermetic_metadata(false),
    ::origin(Origin),
    Origin::downloaded(Path),
    atomic_list_concat([Path, "/META.json"], Meta),
    os::file_exists(Meta),
    json(list, colon, atom)::parse(file(Meta), JSON),
    origin_artifacts::assertz(meta_json(Origin, JSON)).


meta_package(JSON) :-
    config::hermetic_metadata(true),
    ::origin(Origin),
    origin_artifacts::meta_json(Origin, JSON).

:- end_category.


:- category(c_compiler_requirement_inference, implements(requires)).

:- uses(user, [file_name_extension/3]).

requires(c_compiler) :-
  ::origin(Origin),
  Origin::downloaded(Path),
  once((fs::recursive_directory_files(Path, _, File),
       file_name_extension(_, 'c', File))).

:- end_category.

:- category(make_requirement_inference, implements([requires, buildable])).

:- uses(user, [file_name_extension/3]).

requires(make) :-
  ::origin(Origin),
  Origin::downloaded(Path),
  once((fs::recursive_directory_files(Path, '', Makefile),
       list::member(Makefile, ['Makefile', 'makefile']))).

builder(make_builder(Self)) :- self(Self).

:- end_category.

:- category(standard_requirement_inferences,
             extends([c_compiler_requirement_inference, make_requirement_inference])).

:- inherit(requires/1).

:- end_category.

:- category(standard_inferences, extends([inferred_package_name,
                                          meta_json_inferences,
                                          readme_inference,
                                          standard_requirement_inferences])).

:- end_category.