#include <stdio.h>
#include "scheduler.h"

#define CO_SIZE 10
struct coroutine_t *co_arr[CO_SIZE];  //coroutine batch
int c = 0;                            //current coroutine

struct coroutine_t *next_co() {
  for (int i = 1; i <= CO_SIZE; ++i) {
    int index = (c + i) % CO_SIZE;
    if (NULL != co_arr[index]) {
      if (co_arr[index]->status != 0) {
        printf("coroutine finished, index: %d, status: %d\n", index, co_arr[index]->status);
        // coroutine finished
        co_arr[index] = NULL;
        continue;
      }
      c = index;
      return co_arr[index];
    }
  }
  return NULL;
}

struct coroutine_t *curr_co() {
  return co_arr[c];
}

int co_register(struct coroutine_t *co) {
  for (int i = 0; i < CO_SIZE; ++i) {
    if (co_arr[i] == NULL) {
      printf("register coroutine: %d\n", i);
      co_arr[i] = co;
      return i;
    }
  }
  return -1;
}


void scheduler() {
  struct coroutine_t *next;
  while (NULL != (next = next_co())) {
    co_run(next);
  }
}