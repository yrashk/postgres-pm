:- object(inherit_hook, implements(expanding)).

term_expansion((:- inherit(F/A)),
         [(:- discontiguous(F/A)),
          (T :-
           self(Self),
           reltools::includes_category(Self, C),
           C \= Ident,
           category_property(C, defines(F/A, _)),
           \+ (reltools::includes_category(C, C1), category_property(C1, defines(F/A, _))),
           setup_call_cleanup(create_object(O, [extends(Self), imports(C)], [], []),
                              O::T,
                              abolish_object(O)))]) :-
   logtalk_load_context(entity_identifier, Ident),
   list::length(L, A), T =.. [F|L].

:- end_object.