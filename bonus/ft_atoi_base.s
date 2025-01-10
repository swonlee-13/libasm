; int ft_atoi_base(char *str, char *base)
; return : int value

; ft_atoi_base 절차
; 1. 화이트 스페이스 전부 제거
; 2. 부호는 부호가 아닌것이 나올 때까지 확인해서 - 의 갯수가 홀 수이면 음수
; 3. 숫자를 base 에 맞게 판단해서 int 로 변환

; 기수처리 예외조건: 이 때는 0 반환
; ◦ base is empty or size of 1;
; ◦ base contains the same character twice ;
; ◦ base contains + or - or whitespaces;

section .text
    global _ft_atoi_base
    extern _ft_strlen
    extern _ft_write

;rdi: 숫자로 바꿔야 하는 문자열
;rsi: 기수가 되는 문자열
_ft_atoi_base
    push    rbp
    mov     rbp, rsp

    push    rdi             ;푸시
    mov     rdi, rsi
    call    _ft_strlen      ;기수 문자열의 길이 rax 로 반환
    
    ;기수처리 예외 조건 
    cmp     rax, 2
    jl      .finish_with_zero

    mov     rcx, -1

.check_base_string
    inc     rcx
    movzx   rdx, word [rsi + rcx]
    test    rdx, rdx
    jz      .dst_string_prep
    
    cmp     dl, 32
    je      .finish_with_zero
    cmp     dl, 9
    jl      .check_base_string
    cmp     dl, 13
    jle     .finish_with_zero  

.dst_loop_prep
    mov     rcx, -1


; r10: 부호 비트, r11: 0단계는 화이트 스페이스, 1단계는 부호 체크, 2단계는 int 연산단계 플래그
.dst_loop
    inc     rcx
    movzx   rdx, word [rdi + rcx]
    test    rdx, rdx
    jz      .done

    ;부호 찾으면 rcx 를 1 줄여주고 다음 프로세스로 보낸다.
    cmp     dl, 43
    je      .dst_check_sign
    cmp     dl, 45
    je      .dst_check_sign

    ; 화이트 스페이스에 따라 동작을 잡아준다.
    cmp     dl, 32
    je      .dst_loop_white_space
    cmp     dl, 9
    jl      .finish_with_zero
    cmp     dl, 13
    jle     .dst_loop_white_space
    
    ; 조건에 하나도 안맞
    jmp     finish_with_zero

.dst_check_sign_prep




; 부호 비트 반전은 xor a, a 로 초기화하고, xor a, 1 하면 매번 반전된다.
.dst_check_sign
    inc     rcx
    mov     rax, 0
    movzx   rdx, word [rdi + rcx]
    test    rdx, rdx
    xor     r10, r10 ; 임시 레지스터 r10  을 0 으로 초기화
    jz      .finish_with_zero ; 동작이 똑같애서 일로 보냈음
    
    cmp     dl, 43
    je      .dst_check_sign
    
    cmp     dl, 45
    je      .change_sign

    cmp     dl, 

.change_sign
    xor     r10, 1
    jmp     .dst_check_sign


.finish_with_zero
    mov     rax, 0
    jmp     .done

.done
	mov		rsp, rbp
	pop		rbp
	ret