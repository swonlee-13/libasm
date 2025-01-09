section .data
    result db "Result: ", 0
    newline db 10, 0    ; 개행문자 (\n)

section .bss
    num_buffer resb 12  ; 숫자를 문자열로 변환할 버퍼

section .text
    global ft_add
    extern write        ; write 함수 사용을 위한 extern 선언

; int to string 변환을 위한 함수
int_to_string:
    push    rbp
    mov     rbp, rsp
    mov     r9, 10     ; 나눗셈을 위한 10
    lea     rsi, [num_buffer + 11] ; 버퍼의 끝에서 시작
    mov     byte [rsi], 0          ; null 종료문자
    dec     rsi
    
    ; 음수 체크
    mov     r10d, eax   ; 원본 숫자 보존
    test    eax, eax
    jns     .convert
    neg     eax         ; 양수로 변환

.convert:
    mov     edx, 0      ; edx를 0으로 초기화 (div 명령어를 위해)
    div     r9d         ; eax를 10으로 나눔
    add     dl, '0'     ; 나머지를 문자로 변환
    mov     [rsi], dl   ; 버퍼에 저장
    dec     rsi
    test    eax, eax    ; eax가 0인지 체크
    jnz     .convert

    ; 음수였다면 - 추가
    test    r10d, r10d
    jns     .done
    mov     byte [rsi], '-'
    dec     rsi

.done:
    inc     rsi         ; 마지막 문자의 시작 위치로
    mov     rax, rsi    ; 문자열의 시작 주소 반환
    mov     rsp, rbp
    pop     rbp
    ret

; 메인 덧셈 함수
ft_add:
    push    rbp
    mov     rbp, rsp
    
    ; 인자 더하기
    mov     eax, edi
    add     eax, esi
    push    rax         ; 결과값 저장

    ; "Result: " 출력
    mov     rdi, 1      ; file descriptor (stdout)
    mov     rsi, result ; 출력할 문자열
    mov     rdx, 8      ; 문자열 길이
    mov     rax, 1      ; syscall number for write
    push    rax         ; 스택 정렬을 위해
    call    write
    pop     rax

    ; 숫자를 문자열로 변환하고 출력
    pop     rax         ; 저장했던 결과값 복구
    call    int_to_string
    mov     r12, rax    ; 변환된 문자열의 주소 저장
    
    ; 변환된 숫자 출력
    mov     rdi, 1      ; stdout
    mov     rsi, r12    ; 출력할 문자열
    mov     rdx, 1      ; 길이는 나중에 계산
    mov     rcx, 0      ; 길이 카운터
.strlen:
    cmp     byte [rsi + rcx], 0
    je      .print
    inc     rcx
    jmp     .strlen
.print:
    mov     rdx, rcx    ; 계산된 길이
    mov     rax, 1      ; write syscall
    push    rax         ; 스택 정렬
    call    write
    pop     rax

    ; 개행 출력
    mov     rdi, 1
    mov     rsi, newline
    mov     rdx, 1
    mov     rax, 1
    push    rax
    call    write
    pop     rax

    mov     rsp, rbp
    pop     rbp
    ret