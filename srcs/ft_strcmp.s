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

	movzx	eax, BYTE[rdi + rcx]
	movzx	edx, BYTE[rsi + rcx]
	cmp		al, dl
	jne		.done

	cmp		BYTE[rdi + rcx], 0
	je		.done

	cmp		BYTE[rsi + rcx], 0
	je		.done

	jmp		.loop

.done:
	sub		eax, edx
	leave
	ret