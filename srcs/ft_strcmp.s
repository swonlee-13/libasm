; int strcmp(const char *s1, const char *s2);
; return value (unsigned int)s1 - (unsigned int)s2

section .text
    global _ft_strcmp

_ft_strcmp:
    push	rbp
    mov		rbp, rsp

	mov		rcx, -1

.loop:
	inc		rcx

	cmp		BYTE[rdi + rcx], BYTE[rsi + rcx]
	jne		.done

	cmp		BYTE[rdi + rcx], 0
	je		.done

	cmp		BYTE[rsi + rcx], 0
	je		.done

	jmp		.loop

.done:
	mov		rax, 0
	add		rax, BYTE[rdi + rcx]
	sub		rax, BYTE[rsi + rcx]

	mov		rsp, rbp
	pop		rbp
	ret