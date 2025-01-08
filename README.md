# libasm

## Intel x86-64 문법의 특징

1. Intel 문법은 destination, source 순서로 작성
2. AT&T 문법(source, destination)과 반대 순서임을 주의
3. 레지스터 앞에 % 기호를 붙이지 않음 (AT&T와 다름)

## 64비트 환경의 주요 레지스터

1. 범용 레지스터: rax, rbx, rcx, rdx, rsi, rdi, r8-r15
2. 스택 관련: rsp(스택 포인터), rbp(베이스 포인터)

## 64비트 리눅스 calling convention의 주요 규칙:

1. 함수 인자 전달 순서: rdi, rsi, rdx, rcx, r8, r9
2. 반환값은 rax에 저장
3. 호출자 저장 레지스터(caller-saved): r10, r11
4. 피호출자 저장 레지스터(callee-saved): rbx, rbp, r12-r15