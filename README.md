# libasm

---

## 과제 목표
주어진 함수들을 직접 asm 으로 구현하는 것.
◦ ft_strlen (man 3 strlen)
◦ ft_strcpy (man 3 strcpy)
◦ ft_strcmp (man 3 strcmp)
◦ ft_write (man 2 write)
◦ ft_read (man 2 read)
◦ ft_strdup (man 3 strdup, you can call to malloc)

### 보너스
• ft_atoi_base (like the one in the piscine)
• ft_list_push_front (like the one in the piscine) • ft_list_size (like the one in the piscine)
• ft_list_sort (like the one in the piscine)
• ft_list_remove_if (like the one in the piscine)

---

## 컴파일 환경 요구사항
- 64비트 어셈블리 코드로 작성 필수
- 소스 파일은 `.s` 확장자 사용
- NASM(Netwide Assembler)으로 컴파일
- Intel 문법 사용 (AT&T 문법 사용 금지)

---

## Intel x86-64 문법의 특징

1. Intel 문법은 destination, source 순서로 작성
2. AT&T 문법(source, destination)과 반대 순서임을 주의
3. 레지스터 앞에 % 기호를 붙이지 않음 (AT&T와 다름)

## 64비트 환경의 주요 레지스터

1. 범용 레지스터: rax, rbx, rcx, rdx, rsi, rdi, r8-r15
2. 스택 관련: rsp(스택 포인터), rbp(베이스 포인터)

```
eax 와 rax 는 4비트냐 8비트냐의 차이임.
과제에서 스택 관리 등을 할 때는 8바이트인 r 시리즈를 사용하면 된다.
```

## 어셈블리 명령 개요
1. 명령어의 종류 [링크 참조](https://eteo.tistory.com/296)
    - 데이터 이동: mov
    - 산술 연산: inc, dec, add, sub
    - 논리 연산: and, or, xor, not
    - 비교: cmp, test
    - 스택: push, pop
    - 프로시져: call, ret, leave3
    - 시스템 콜:  syscall
2. 어셈블리의 피연산자 [링크 참조](https://eteo.tistory.com/296)
    - WORD: 포인터에서 2바이트 참조
    - DWORD: 포인터에서 4바이트 참조
    - QWORD: 포인터에서 8바이트 참조


## 각 레지스터 용도에 따른 재분류

### 시스템콜 실행법
- rax : system call number [링크 참조](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/) 

- rdi, rsi, rdx, r10. r8, r9 : system call 에 들어가는 인자 순서
- 사용 예시
```
;read(fd, buf, length)
read_example:
        mov     rax, 0          ; sys_read
        mov     rdi, 0          ; stdin
        mov     rsi, buffer     ; 입력 버퍼
        mov     rdx, count      ; 읽을 바이트 수
        syscall

; open(filename, flags, mode)
open_example:
        mov     rax, 2          ; sys_open
        mov     rdi, filename   ; 파일명
        mov     rsi, 0          ; O_RDONLY
        mov     rdx, 0644o      ; 권한 (옵션)
        syscall

; close(fd)
close_example:
        mov     rax, 3          ; sys_close
        mov     rdi, fd         ; 파일 디스크립터
        syscall

; exit(status)
exit_example:
        mov     rax, 60         ; sys_exit
        mov     rdi, status     ; 종료 상태
        syscall
```

### 함수 인자 전달 순서

- calaling convention 참고

### 호출자 지정 레지스터
- 시스템콜 실행법 참고

### 피호출자(callee-saved) 순서
- rbx, rbp, r12, r13, r14,  r15,  rsp

### 임시 계산을 위한 레지스터 사용 추천 순서
- r10, r11, rax(결과값 지정 전 까지 임시 사s용 가능)

### 함수 용도(또는 full name)
- rsi: source index
- rdi: destination index
- rdx: data register
- rsi: Source Index
- rdi: Destination Index
- rbp: base pointer

---

# 섹션 정리
1. .data 섹션
- data 섹션(.data)은 프로그램에서 초기화된 정적 변수를 위한 공간으로, 글로벌 변수와 정적 로컬 변수를 위한 공간이다. 이 섹션의 크기는 런타임에서 변경되지 않는다. data 섹션은 읽기와 쓰기가 가능하나, 읽기 전용을 위한 .rodata 섹션이 존재한다.

    ```nasm
    section .data
        global message        ; 다른 파일에서 접근 가능하도록 global 선언
        message db "Hello", 0 ; message는 데이터 이름, db 는 아래 참조, 0은 아스키로 현재는 '\0'. \n 은 10
        extern malloc ; 외부 함수를 불러올 때 extern 을 이용한다.
        extern free
    ```
- 데이터 크기 정의 예시
    ```nasm
    section .data
        num    dd    42        ; 4바이트 정수
        str    db    "Hi", 0   ; 문자열
        arr    db    1,2,3,4   ; 바이트 배열
        char   db    'A'       ; 단일 문자
    ```
- 내 함수를 외부에서 사용 가능하게 하기 위해서는 global 키워드 사용
- 외부의 함수를 가져오기 위해서는 extern 키워드 사용

2. text 섹션
- 실제 실행 코드가 들어가는 영역.
    ```
    section .text
            global _start
    ```
이렇게 적으면 _start 가 실행 지점이 된다.

3. heap 섹션
- 힙을 관리하는 영역
    ```nasm
    section .heap
        resb 4096           ; 4KB의 힙 공간 예약
    ```
- 힙 영역과 관련된 정보를 저장하고, 관리한다.
- 이런 식으로는 동적인 관리를 할 수 없다.
- 따라서, 이것 보다는 아래와 heap_example 처럼 힙의 시작과 끝, 현재를 관리하고, brk 로 관리하는 것이 더 용이하다.
    ```nasm
    ; 힙을 관리하는 예시 코드
    section .data
        heap_start dd 0       ; 힙 시작 주소
        heap_current dd 0     ; 현재 힙 포인터
        heap_end dd 0         ; 힙 끝 주소
    ```
4. 기타 섹션
- .bss, .stack, .rodata

---

# x86-64 Calling Conventions

예시 컴파일 명령:
```bash
nasm -f elf64 file.s -o file.o
ld file.o -o executable
```

## System V AMD64 ABI

### 스택 관리 책임
1. Caller의 책임:
    - 함수 호출 전 인자를 올바른 순서로 전달
    - 사용된 스택 공간 정리 (cdecl convention 준수)
    - 예시: `add rsp, N` (N은 푸시한 인자의 크기)
    - Caller-saved 레지스터 보존

2. Callee의 책임:
    - 스택 프레임 설정 및 정리
    - Callee-saved 레지스터 값 보존 및 복원
    - 반환 값을 RAX에 저장

### 레지스터 사용 규약

#### 인자 전달용 레지스터 (Parameter Passing)

1. 정수/포인터 타입 인자

    - 순서: RDI, RSI, RDX, RCX, R8, R9
    - 추가 인자는 스택을 통해 전달 (right to left)


2. 부동소수점 인자

    - XMM0 ~ XMM7 레지스터 사용
    - 추가 인자는 스택을 통해 전달

#### 반환값 레지스터

- 정수/포인터: RAX, RDX
- 부동소수점: XMM0, XMM1

#### 레지스터 보존 규칙
- Caller-saved (휘발성): 
  - RAX (반환값)
  - RCX, RDX
  - R8-R11 (특히 R10, R11은 반드시 caller가 저장)
  - RDI, RSI (인자 전달에 사용)
  - XMM0-XMM15

- Callee-saved (비휘발성):
  - RBX
  - RBP (스택 프레임 포인터)
  - RSP (스택 포인터)
  - R12-R15

#### cdecl Convention 특징
- Caller가 스택 정리 책임
- 스택 정리 예시:
  ```nasm
  ; 함수 호출 예시
  push    arg2
  push    arg1
  call    function
  add     rsp, 16    ; 2개 인자를 푸시했으므로 16바이트 정리
  ```

### 스택 프레임 규칙
1. 스택 정렬
   - RSP는 16바이트 경계에 정렬되어야 함
   - 함수 호출 직전에 정렬 필수

2. 프롤로그 (Prologue)
   ```nasm
   push rbp
   mov rbp, rsp
   sub rsp, N  ; N = 필요한 스택 크기 (16의 배수)
   ```

3. 에필로그 (Epilogue)
   ```nasm
   mov rsp, rbp
   pop rbp
   ret
   ```