section .text
    global ft_strlen      ; 함수를 외부에서 사용할 수 있도록 선언

ft_strlen:
    push    rbp          ; 스택 프레임 설정
    mov     rbp, rsp

    mov     rax, -1      ; 카운터를 -1로 초기화 (첫 증가에서 0이 되도록)
    
.count_loop:
    inc     rax          ; 카운터 증가
    cmp     BYTE [rdi + rax], 0  ; 현재 문자가 널 종료자(0)인지 확인
    jne     .count_loop  ; 널 종료자가 아니면 계속 반복
    
    mov     rsp, rbp     ; 스택 프레임 복원
    pop     rbp
    ret                  ; rax에 문자열 길이가 들어있는 상태로 반환