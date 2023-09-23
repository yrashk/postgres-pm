:- category(extended_relations).

:- public(includes_category/2).

%% while this is not perfect, it ensures we don't get duplicates
:- table(includes_category/2).

includes_category(Entity, Category) :-
  (current_object(Entity) ; current_category(Entity)),
  imports_category(Entity, Category).

includes_category(Entity, Category) :-
  (current_object(Entity) ; current_category(Entity)),
  imports_category(Entity, Category1),
  includes_category(Category1, Category).

includes_category(Category1, Category) :-
  current_category(Category1),
  current_category(Category),
  dif::dif(Category1, Category),
  extends_category(Category1, Category).

includes_category(Category1, Category) :-
  current_category(Category1),
  current_category(Category),
  dif::dif(Category1, Category),
  extends_category(Category1, Category2),
  includes_category(Category2, Category).

:- end_category.

:- object(reltools, imports(extended_relations)).
:- end_object.