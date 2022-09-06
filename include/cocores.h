#pragma once

#include <stdint.h>

typedef void (*coroutine_fun_t)();

struct coroutine_t {
  coroutine_fun_t func;
  void *stack;
  int64_t pc;
  int64_t sp;
  int status;
};

void co_start(struct coroutine_t *co);

void co_save(struct coroutine_t *co);

void co_recovery(struct coroutine_t *co);