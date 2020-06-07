#!/bin/sh

for cfg in `ls /home/miner/config`
do
  test -e $cfg || cp /home/miner/config/$cfg ./
done

cp /home/miner/spigot.jar ./

java -Xmx${JVM_MEM} -jar spigot.jar nogui

