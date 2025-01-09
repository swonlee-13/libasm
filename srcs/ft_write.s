; write(int fd, const void *buf, size_t n_byte);
; return : buf 의 길이, error 일 때 -1

section .text
    global _ft_write
    extern ___error

_ft_write:
    push	rbp
	mov		rbp, rsp

	mov		rax, 0x2000004
	syscall

	jnc		.done

.error:
	push	rax
	call	___error
	pop		qword [rax]
	mov		rax, -1
	ret
	
.done:
    mov     rsp, rbp
    pop     rbp
    ret