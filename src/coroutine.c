#include <stdlib.h>
#include <unistd.h>
#include "coroutine.h"

extern struct coroutine_t *next_co();

extern struct coroutine_t *curr_co();

struct coroutine_t *create_coroutine(coroutine_fun_t func) {
  struct coroutine_t
      *co = (struct coroutine_t *)malloc(sizeof(struct coroutine_t));

  co->func = func;

  int pagesize = getpagesize();
  co->stack = malloc(pagesize);
  co->stack += pagesize;

  co->pc = 0;
  co->sp = 0;
  co->status = 0;
  return co;
}

void co_run(struct coroutine_t *co) {
  if (co->pc == 0) {
    co_start(co);
  } else {
    co_recovery(co);
  }
}

void co_yield() {
  co_save(curr_co());
}