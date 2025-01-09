; char * strdup(const char *s1);
; return : 새로할당된 char* 주소
; 에러시 errno 에 ENOMEM 들어가고, NULL 반환

section .text
    global	_ft_strdup
	extern	___error
    extern	malloc
	extern	_ft_strlen
	extern	_ft_strcpy

_ft_strdup:
	push	rbp
	mov		rbp, rsp
	push	rdi
	
	call	_ft_strlen

	inc		rax
	mov		rdi, rax

	call	malloc
	jc		.error

	pop		rsi
	mov		rdi, rax
	call	_ft_strcpy
	jmp		.done

.error:
	call	___error
	mov		[rax], 12
	xor		rax, rax
	pop		rdi

.done:
    mov     rsp, rbp
    pop     rbp
    ret