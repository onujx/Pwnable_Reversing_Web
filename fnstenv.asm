[BITS 32]

global _start

_start:

fabs					;1. �ƹ� �ذ� ���� FPU ��ɾ�
fnstenv [esp-0xc]		;2. FPU ȯ�� ����. ESP-12�� ���
pop edx				;3. eip�� fabs FPU instruction�� ���Ͽ� edx�� ����
add dl, 00			;4. fabs�κ����� ������ -> xor ����
(placeholder)

short_xor_beg:
xor ecx,ecx			;5. ������ ���� ecx �ʱ�ȭ
mov cl, 0x18			;6. xor�� ���̷ε��� ũ��

short_xor_xor:
xor byte [edx], 0x00	;7. xor�� ����Ʈ(Ű �÷��̽� Ȧ��)
inc edx				;8. EDX�� ���� ����Ʈ�� ����
loop short_xor_xor	;9. ��� ���ڵ� ����

shellcode:
; ���ڵ��� ���ڵ尡 �̰��� ��
