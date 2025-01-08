# libasm

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

## 64비트 리눅스 calling convention의 주요 규칙:

1. 함수 인자 전달 순서: rdi, rsi, rdx, rcx, r8, r9
2. 반환값은 rax에 저장
3. 호출자 저장 레지스터(caller-saved): r10, r11
4. 피호출자 저장 레지스터(callee-saved): rbx, rbp, r12-r15

## 각 레지스터 용도에 따른 재분류

### 시스템콜 실행법
- rax : system call number [링크 참조](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/) 

- rdi, rsi, rdx, r10. r8, r9 : system call 에 들어가는 인자 순서

```
    예시 : sys_write의 경우 rax, 1
    write(1, "asdf", 4)인자가 3개인데
    rdi에 1,
    rsi 에 "asdf"
    rdx 에 4 를 넣고
    syscall 을 적어서 실행
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
    rsi: source index
    rdi: destination index
    rdx: data register
    rsi: Source Index
    rdi: Destination Index
    rbp: base pointer