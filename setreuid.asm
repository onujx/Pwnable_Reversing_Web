section .text	; asm�� �ڵ� ���� ����
global _start	; ���� ���� ����
_start:		; ��Ŀ�� �Ͽ��� ������ ���� ����
xor eax, eax	; eax �������͸� ����� ���� ���� �غ�
mov al, 0x46	; syscal ���� ������ 70(16������ 46)���� ����, �� ����Ʈ
xor ebx, ebx	; ebx �������͸� ����� 0���� ����
xor ecx, ecx	; ecx �������͸� ����� 0���� ����
int 0x80		; syscall�� �����ϰ��� Ŀ�� ȣ��
mov al, 0x01	; exit()�� ���� syscall ���� 1�� ����
int 0x80		; syscall�� �����ϰ��� Ŀ�� ȣ��
