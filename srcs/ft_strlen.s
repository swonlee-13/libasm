section .text
	global _ft_strlen


_ft_strlen:
	push	rbp
	mov		rbp, rsp

	mov     rcx, -1

.count_loop:
    inc     rcx
    
    cmp     BYTE[rdi + rcx], 0
    jne     .count_loop
    
    mov     rax, rcx
    leave
    ret