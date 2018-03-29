#!/bin/sh

for i in /home/flag03/writable.d/* ; do
	(ulimit -t 5; bash -x "$i")
	rm -f "$i"

