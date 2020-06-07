FROM openjdk:8-alpine AS mcs-build

USER 0

RUN apk update
RUN apk add \
    git

ARG SPIGOT_VER=1.15.2
ARG SPIGOT_URL=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

ADD ${SPIGOT_URL} /stuff/BuildTools.jar
WORKDIR /stuff

RUN java -jar BuildTools.jar --rev ${SPIGOT_VER}

FROM openjdk:8-alpine AS mcs-install

ARG SPIGOT_VER=1.15.2
USER 0

RUN adduser --disabled-password --uid 1002 miner
RUN mkdir -p /opt/mcs
RUN chown miner:miner /opt/mcs

RUN apk update
RUN apk add \
    tmux

ADD --chown=miner:miner start.sh /home/miner/start.sh
ADD --chown=miner:miner config /home/miner/config
COPY --from=mcs-build --chown=miner:miner /stuff/spigot-${SPIGOT_VER}.jar /home/miner/spigot.jar

ENV JVM_MEM 1G
USER miner:miner
WORKDIR /opt/mcs

CMD /home/miner/start.sh

