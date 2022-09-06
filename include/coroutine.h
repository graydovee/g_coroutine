#pragma once

#include "cocores.h"

struct coroutine_t *create_coroutine(coroutine_fun_t func);

void co_run(struct coroutine_t *co);

void co_yield();