#pragma once

#include "coroutine.h"

int co_register(struct coroutine_t *co);

void scheduler();

struct coroutine_t *next_co();

struct coroutine_t *curr_co();