section .text

global co_recovery
global _co_recovery
co_recovery:
_co_recovery:
    ; 1. save this stack
    push rbp
    mov rbp, rsp
    mov rcx, [rdi + 0x18]   ; load old sp
    mov [rdi + 0x18], rsp   ; save stack

    ; 2. switch stack
    mov rbp, rcx
    mov rsp, rcx;
    pop rbp

    ; 3. recovery register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx

    ; 4. jump
    pop rbp
    ret

global co_save
global _co_save
co_save:
_co_save:
    ; stack: retAddr, register, rbp
    ; 1. save pc, sp
    push rbp
    mov rbp, rsp
    mov rax, [rbp + 0x08]
    mov [rdi + 0x10], rax   ; save pc

    ; 2. save register
    push rbx
    push r12
    push r13
    push r14
    push r15
    push rbp

    ; 3. save stack
    mov rcx, [rdi + 0x18]   ; load scheduler sp
    mov [rdi + 0x18], rsp   ; save stack
    mov rbp, rcx            ; switch stack
    mov rsp, rcx

    ; 4. ret
    pop rbp
    ret

global co_start
global _co_start
co_start:
_co_start:
    push rbp
    mov rbp, rsp

    ; save status
    mov rax, [rbp + 0x08]
    mov [rdi + 0x10], rax   ; save pc
    mov [rdi + 0x18], rsp   ; save stack

    ; switch stack and run
    mov rsp, [rdi + 0x08]
    mov rbp, [rdi + 0x08]   ; switch stack
    push rdi                ; push *co
    mov rax, 0
    call [rdi +0x00]        ; run function

    ; recovery
    pop rdi                 ; pop *co
    mov rsp, [rdi +0x18]    ; recovery stack
    mov rbp, [rdi +0x18]

    ; end
    mov eax, 1
    mov [rdi + 0x20], eax   ; set status 1
    pop rbp
    ret