section .data
    heap_start dd 0       ; 힙 시작 주소
    heap_current dd 0     ; 현재 힙 포인터
    heap_end dd 0         ; 힙 끝 주소

section .text
    global _start
    extern malloc
    extern free

; 힙 초기화
init_heap:
    push ebp
    mov ebp, esp
    
    ; sbrk(0)로 현재 프로그램 break 얻기
    mov eax, 45          ; sys_brk
    xor ebx, ebx         ; 인자 0
    int 0x80
    
    mov [heap_start], eax    ; 힙 시작 주소 저장
    mov [heap_current], eax  ; 현재 포인터 초기화
    
    ; 초기 힙 크기 할당 (예: 4KB)
    add eax, 4096
    mov ebx, eax
    mov eax, 45          ; sys_brk
    int 0x80
    
    mov [heap_end], eax  ; 힙 끝 주소 저장
    
    pop ebp
    ret

; 메모리 할당 (size: [ebp+8])
my_malloc:
    push ebp
    mov ebp, esp
    
    ; 요청된 크기 확인
    mov ecx, [ebp+8]     ; 요청된 크기
    
    ; 남은 공간 확인
    mov eax, [heap_end]
    sub eax, [heap_current]
    cmp eax, ecx
    jl extend_heap       ; 공간 부족하면 힙 확장
    
allocate:
    mov eax, [heap_current]  ; 현재 위치 반환
    add [heap_current], ecx  ; 포인터 이동
    
    pop ebp
    ret

; 힙 확장
extend_heap:
    push ecx            ; 요청 크기 저장
    
    mov eax, [heap_end]
    add eax, 4096       ; 4KB 단위로 확장
    mov ebx, eax
    mov eax, 45         ; sys_brk
    int 0x80
    
    mov [heap_end], eax
    
    pop ecx
    jmp allocate

; 메모리 해제 (ptr: [ebp+8])
my_free:
    ; 이 간단한 구현에서는 실제로 메모리를 해제하지 않음
    ; 실제 구현에서는 메모리 블록을 관리하고 재사용해야 함
    push ebp
    mov ebp, esp
    pop ebp
    ret

; 메인 함수
_start:
    ; 힙 초기화
    call init_heap
    
    ; 테스트: 100 바이트 할당
    push 100
    call my_malloc
    add esp, 4
    
    ; 프로그램 종료
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; 상태 코드 0
    int 0x80