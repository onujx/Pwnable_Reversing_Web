[BITS 32]

global _start

_start:
jmp short call_point	; 1.CALL��  JMP

begin:
pop esi				; 3. ���ڵ��� ����ϰ��� ���ڵ��� ��ġ�� esi�� ����
xor ecx,ecx			; 4. ecx �ʱ�ȭ
mov cl,0x0			; 5. ���ڵ� ũ�⸦ ���� �÷��̽�Ȧ��(0x0)

short_xor:
xor byte[esi],0x0		; 6. esi�� ����Ʈ�� Ű(0x0=�÷��̽�Ȧ��)�� XOR 
inc esi				; 7. esi �����͸� ���� ����Ʈ�� ����
loop short_xor		; 8. ���ڵ尡 ���ڵ�� ������ 6���� �ݺ�
jmp short shellcode	; 9. ���ڵ��� ���ڵ�� ����

call_point:
call begin			; 2. �����ϰ��� CALL�� ���ư�, ���ڵ� ��ġ�� ���ÿ� Ǫ��

shellcode:			; 10. ���ڵ��� ���ڵ� ����
; ���ڵ��� ���ڵ�� �̰���
