$(shell mkdir -p build/lib)

cocore:
	nasm -f elf64 src/cocore.asm -o build/cocore.o

coroutine:
	gcc -c src/coroutine.c -o build/coroutine.o -I./include

scheduler:
	gcc -c src/scheduler.c -o build/scheduler.o -I./include

.PHONY: clean
clean:
	rm -rf build

.PHONY: lib
lib: cocore coroutine scheduler
	ar cr build/lib/libcoroutine.a build/cocore.o build/coroutine.o build/scheduler.o

.PHONY: build
build: lib
	gcc main.c -o build/main.exe -Lbuild/lib -lcoroutine -I./include

.PHONY: run
run: build
	./build/main.exe
