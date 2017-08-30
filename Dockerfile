FROM mcstyle/ubuntu
ARG MC_RELEASE_TAG=1.10.2
ARG MC_SERVER_TAG=1.10.2
ARG S3CMD_RELEASE_TAG=1.6.1

RUN adduser --disabled-password --gecos '' minecraft
RUN apt-get update && apt-get install -y vim mc && apt-get clean

COPY b2 /usr/local/bin/b2
COPY gotty /usr/local/bin/gotty
COPY gosu /usr/local/bin/gosu
COPY runit/minecraft /etc/service/minecraft/run
COPY runit/gotty /etc/service/gotty/run
COPY runit/sshd /etc/service/sshd/run
COPY init /home/minecraft/init
COPY .s3cfg /home/minecraft/.s3cfg
COPY authlib/$MC_RELEASE_TAG /home/minecraft/authlib
COPY server/$MC_SERVER_TAG /home/minecraft/server

RUN wget https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_RELEASE_TAG}/s3cmd-${S3CMD_RELEASE_TAG}.zip \
-O /opt/s3cmd-${S3CMD_RELEASE_TAG}.zip \
&& unzip /opt/s3cmd-${S3CMD_RELEASE_TAG}.zip -d /opt/ \
&& rm /opt/s3cmd-${S3CMD_RELEASE_TAG}.zip \
&& ln -s /opt/s3cmd-${S3CMD_RELEASE_TAG}/s3cmd /usr/bin/s3cmd \
&& chmod +x /opt/s3cmd-${S3CMD_RELEASE_TAG}/s3cmd

RUN chmod +x /usr/local/bin/b2 \
&& chmod +x /etc/service/minecraft/run \
&& chmod +x /etc/service/gotty/run \
&& chmod +x /etc/service/sshd/run \
&& ln -s /home/minecraft/init/minecraft /usr/local/bin/minecraft \
&& chown minecraft:minecraft -R /home/minecraft/

USER minecraft

RUN unzip /home/minecraft/server/libraries.zip -d /home/minecraft/server/

RUN cd /home/minecraft/authlib \
&& zip -ur /home/minecraft/server/minecraft_server.${MC_RELEASE_TAG}.jar ./ \
&& cd -

RUN mkdir -p /home/minecraft/mcbackup \
&& mkdir -p /home/minecraft/server/worlds \
&& mkdir -p /home/minecraft/server/dynmap \
&& mkdir -p /home/minecraft/server/mods \
&& mkdir -p /home/minecraft/server/logs \
&& mkdir -p /home/minecraft/server/plugins \
&& mkdir -p /home/minecraft/server/config \
&& mkdir -p /home/minecraft/server/config-server \
&& mkdir -p /home/minecraft/server/scripts \
&& mkdir -p /home/minecraft/server/Flan \
&& chmod +x /home/minecraft/init/minecraft

USER root

VOLUME ["/home/minecraft/mcbackup", "/home/minecraft/server/dynmap", "/home/minecraft/server/worlds", "/home/minecraft/server/plugins", "/home/minecraft/server/mods", "/home/minecraft/server/config", "/home/minecraft/server/logs", "/home/minecraft/server/config-server", "/home/minecraft/server/scripts", "/home/minecraft/server/Flan"]

# 25565 - MineCraft Server Port
# 8123 - Dynmap Plugin Port
EXPOSE 25565 8123 8080 22

# Enable sshd
RUN rm -f /etc/service/sshd/down
