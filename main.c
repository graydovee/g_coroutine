#include <stdio.h>
#include <malloc.h>
#include "coroutine.h"
#include "scheduler.h"

void run1() {
  for (int i = 0; i < 100; ++i) {
    printf("coroutine 1 scheduled, times: %d\n", i);
    co_yield();
  }
}
void run2() {
  for (int i = 0; i < 100; ++i) {
    printf("coroutine 2 scheduled, times: %d\n", i);
    co_yield();
  }
}

void init() {
  co_register(create_coroutine(run1));
  co_register(create_coroutine(run2));
}

int main() {
  init();
  scheduler();
  return 0;
}
