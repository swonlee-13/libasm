; ssize_t read(int fildes, void *buf, size_t nbyte);
; return : 정싱일 때는 읽은 byte, eof 를 읽었으면 0, errno 일 때는 -1

section .text
    global _ft_read
    extern ___error

_ft_read:
    push    rbp
    mov     rbp, rsp
    
    mov     rax, 0x2000003
    syscall
    
    jc     .error
    leave
    ret

.error:
    push    rax
    sub     rsp, 8
    call    ___error
    pop     qword [rax]
    mov     rax, -1
    leave
    ret