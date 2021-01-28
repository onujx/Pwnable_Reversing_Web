section .text	; asm의 코드 섹션 시작
global _start	; 전역 수준 선언
_start:		; 링커로 하여금 오류나 추측 방지
xor eax, eax	; eax 레지스터를 지우고 다음 줄을 준비
mov al, 0x46	; syscal 값을 십진수 70(16진수로 46)으로 설정, 한 바이트
xor ebx, ebx	; ebx 레지스터를 지우고 0으로 설정
xor ecx, ecx	; ecx 레지스터를 지우고 0으로 설정
int 0x80		; syscall을 실행하고자 커널 호출
mov al, 0x01	; exit()를 위해 syscall 수를 1로 설정
int 0x80		; syscall을 실행하고자 커널 호출
