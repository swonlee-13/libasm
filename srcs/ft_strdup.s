; char * strdup(const char *s1);
; return : 새로할당된 char* 주소
; 에러시 errno 에 ENOMEM 들어가고, NULL 반환

section .text
    global	_ft_strdup
	extern	___error
    extern	_malloc
	extern	_ft_strlen
	extern	_ft_strcpy
	default rel

_ft_strdup:
	push	rbp
	mov		rbp, rsp
	
	call	_ft_strlen

	push	rdi

	inc		rax
	mov		rdi, rax

	call	_malloc
	jc		.error

	mov		rdi, rax
	pop		rsi
	call	_ft_strcpy
	jmp		.done

.error:
	call	___error
	mov		dword [rax], 12
	xor		rax, rax

.done:
    mov     rsp, rbp
    pop     rbp
    ret