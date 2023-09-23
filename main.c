#include <SWI-Prolog.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#define MAXLINE 1024

#define PL_require(x) if(!x) return FALSE

term_t Logtalk(term_t receiver, char *predicate_name, int arity, term_t arg) {
  // create term for the message
  functor_t functor = PL_new_functor(PL_new_atom(predicate_name), arity);
  term_t pred = PL_new_term_ref();
  PL_require(PL_cons_functor(pred, functor, arg));

  // term for ::(receiver, message)
  functor_t send_functor = PL_new_functor(PL_new_atom("::"), 2);
  term_t goal = PL_new_term_ref();
  PL_require(PL_cons_functor(goal, send_functor, receiver, pred));

  return goal;
}

term_t Logtalk_named(char *object_name, char *predicate_name, int arity, term_t arg) {
  // create term for the receiver of the message
  term_t receiver = PL_new_term_ref();
  PL_put_atom_chars(receiver, object_name);

  return Logtalk(receiver, predicate_name, arity, arg);
}

predicate_t call_predicate() {
  static predicate_t pred = NULL;
  if (pred == NULL) {
    pred = PL_predicate("call", 1, NULL);
  }
  return pred;
}

int main(int argc, char **argv) {
  char *program = argv[0];
  char *plav[2];
  int rc = 0;

  /* make the argument vector for Prolog */

  plav[0] = program;
  plav[1] = NULL;

  /* initialise Prolog */

  if (!PL_initialise(1, plav))
    PL_halt(1);

  if (argc < 2) {
    printf("Usage: pgpm <dir|file>\n");
    rc = 1;
    goto done;
  }

  // create term for path
  term_t path_to_dir = PL_new_term_ref();
  PL_put_atom_chars(path_to_dir, argv[1]);

  term_t goal = Logtalk_named("pgpm", "load", 1, path_to_dir);

  qid_t qid = PL_open_query(NULL, PL_Q_NORMAL, call_predicate(), goal);

  bool succeeded = false;
  while (PL_next_solution(qid)) {
    succeeded = true;
  }

  PL_close_query(qid);

  if (!succeeded) {
    printf("Can't load\n");
    rc = 1;
    goto done;
  }

  {
    term_t package = PL_new_term_ref();
    term_t specific_package = Logtalk_named("pgpm", "latest_package", 1, package);

    term_t package_name = PL_new_term_ref();
    term_t name = Logtalk(package, "name", 1, package_name);

    term_t package_version = PL_new_term_ref();
    term_t version = Logtalk(package, "version", 1, package_version);

    functor_t and_functor = PL_new_functor(PL_new_atom(","), 2);
    term_t goal0 = PL_new_term_ref();
    PL_require(PL_cons_functor(goal0, and_functor, specific_package, name));

    term_t goal = PL_new_term_ref();
    PL_require(PL_cons_functor(goal, and_functor, goal0, version));

    qid_t qid = PL_open_query(NULL, PL_Q_NORMAL, call_predicate(), goal);

    while (PL_next_solution(qid)) {
    }

    PL_close_query(qid);
  }

  {
    term_t package = PL_new_term_ref();
    term_t specific_package = Logtalk_named("pgpm", "latest_package", 1, package);

    term_t package_name = PL_new_term_ref();
    term_t name = Logtalk(package, "name", 1, package_name);

    term_t package_version = PL_new_term_ref();
    term_t version = Logtalk(package, "version", 1, package_version);

    functor_t and_functor = PL_new_functor(PL_new_atom(","), 2);
    term_t goal0 = PL_new_term_ref();
    PL_require(PL_cons_functor(goal0, and_functor, specific_package, name));

    term_t goal = PL_new_term_ref();
    PL_require(PL_cons_functor(goal, and_functor, goal0, version));

    qid_t qid = PL_open_query(NULL, PL_Q_NORMAL, call_predicate(), goal);

    while (PL_next_solution(qid)) {
      PL_write_term(Suser_output, package_name, 1200, PL_WRT_PORTRAY | PL_WRT_NEWLINE);
      PL_write_term(Suser_output, package_version, 1200, PL_WRT_PORTRAY | PL_WRT_NEWLINE);
    }

    PL_close_query(qid);
  }

done:
  PL_cleanup(0);

  return rc;
}
