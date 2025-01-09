; char * strcpy(char * dst, char * src);
; return value : dst

section .text
	global _ft_strcpy

_ft_strcpy:
	push	rbp
	mov		rbp, rsp
	
	mov		rcx, -1

.loop:
	inc		rcx

	mov		al, BYTE[rsi + rcx]
	mov		BYTE[rdi + rcx], al
	cmp		al, al
	jnz		.loop

.done:
	mov		rax, rdi
	mov		rsp, rbp
	pop		rbp
	ret