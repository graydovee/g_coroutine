cmake_minimum_required(VERSION 3.10)
project(asm_test C ASM)

SET(CMAKE_ASM_NASM_SOURCE_FILE_EXTENSIONS asm)
ENABLE_LANGUAGE(ASM_NASM)

SET(CMAKE_ASM_NASM_FLAGS "-g")

set(CMAKE_C_STANDARD 99)

include_directories(./include)

set(ASM_SOURCES
        src/cocore.asm
        )

set (SOURCES
        main.c
        ${ASM_SOURCES}
        src/coroutine.c include/coroutine.h include/scheduler.h src/scheduler.c)

set_source_files_properties(${ASM_SOURCES} PROPERTIES LANGUAGE ASM_NASM)

add_executable(asm_test ${SOURCES})