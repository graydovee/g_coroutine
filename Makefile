BUILD=./build
LIB=lib
INCLUDE=./include
$(shell mkdir -p build/lib)

FLAG_INCLUDE=-I${INCLUDE}
FLAG_LIB=-L${BUILD}/${LIB}
FLAG_OPTIMIZATION=-O3

FLAG=${FLAG_LIB} ${FLAG_INCLUDE}

${BUILD}/cocore.o: src/cocore.asm
	nasm -f elf64 $< -o $@

${BUILD}/coroutine.o: src/coroutine.c
	gcc -c $< -o $@ ${FLAG_INCLUDE} ${FLAG_OPTIMIZATION}

${BUILD}/scheduler.o: src/scheduler.c
	gcc -c $< -o $@ ${FLAG_INCLUDE} ${FLAG_OPTIMIZATION}

${BUILD}/${LIB}/libco.a: ${BUILD}/cocore.o ${BUILD}/coroutine.o ${BUILD}/scheduler.o
	ar cr $@ $^

lib: ${BUILD}/${LIB}/libco.a

build: ${BUILD}/${LIB}/libco.a
	gcc main.c -o ${BUILD}/main.exe ${FLAG} -lco ${FLAG_OPTIMIZATION}

.PHONY: run
run: build
	${BUILD}/main.exe

.PHONY: clean
clean:
	rm -rf build