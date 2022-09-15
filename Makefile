BUILD=./build
LIB=lib
INCLUDE=./include
$(shell mkdir -p build/lib)

FLAG_INCLUDE=-I${INCLUDE}
FLAG_LIB=-L${BUILD}/${LIB}
FLAG_OPTIMIZATION=-O2
FLAG_DEBUG=-g

FLAG=${FLAG_LIB} ${FLAG_INCLUDE}

MOD?=debug

ifeq (${MOD}, debug)
	BUILD_FLAG=${FLAG_OPTIMIZATION} ${FLAG_DEBUG}
else
	BUILD_FLAG=${FLAG_OPTIMIZATION}
endif

${BUILD}/cocore.o: src/cocore.asm
	nasm -f elf64 $< -o $@ ${BUILD_FLAG}

${BUILD}/coroutine.o: src/coroutine.c
	gcc -c $< -o $@ ${FLAG_INCLUDE} ${BUILD_FLAG}

${BUILD}/scheduler.o: src/scheduler.c
	gcc -c $< -o $@ ${FLAG_INCLUDE} ${BUILD_FLAG}

${BUILD}/${LIB}/libco.a: ${BUILD}/cocore.o ${BUILD}/coroutine.o ${BUILD}/scheduler.o
	ar cr $@ $^

lib: ${BUILD}/${LIB}/libco.a

build: ${BUILD}/${LIB}/libco.a
	gcc main.c -o ${BUILD}/main.exe ${FLAG} -lco ${BUILD_FLAG}

.PHONY: rebuild
rebuild: clean
	make build

.PHONY: run
run: build
	${BUILD}/main.exe

.PHONY: dev
dev: rebuild
	${BUILD}/main.exe

.PHONY: clean
clean:
	rm -rf build