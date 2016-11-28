FROM mcstyle/ubuntu
ENV "MC_RELEASE_TAG=1.7.10"
ENV "THERMOS_RELEASE_TAG=57"
ENV "FORGE_RELEASE_TAG=1614"
ENV "S3CMD_RELEASE_TAG=1.6.1"

RUN adduser --disabled-password --gecos '' minecraft

COPY b2 /usr/local/bin/b2
COPY runit/minecraft /etc/service/minecraft/run
COPY init /home/minecraft/init
COPY .s3cfg /home/minecraft/.s3cfg
COPY authlib /home/minecraft/authlib

RUN wget https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_RELEASE_TAG}/s3cmd-${S3CMD_RELEASE_TAG}.zip \
-O /opt/s3cmd-${S3CMD_RELEASE_TAG}.zip \
&& unzip /opt/s3cmd-${S3CMD_RELEASE_TAG}.zip -d /opt/ \ 
&& rm /opt/s3cmd-${S3CMD_RELEASE_TAG}.zip \
&& ln -s /opt/s3cmd-${S3CMD_RELEASE_TAG}/s3cmd /usr/bin/s3cmd \
&& chmod +x /opt/s3cmd-${S3CMD_RELEASE_TAG}/s3cmd

RUN chmod +x /usr/local/bin/b2 \
&& chmod +x /etc/service/minecraft/run \
&& ln -s /home/minecraft/init/minecraft /usr/local/bin/minecraft \
&& chown minecraft:minecraft -R /home/minecraft/

USER minecraft

RUN mkdir -p /home/minecraft/server \ 
&& wget https://github.com/CyberdyneCC/Thermos/releases/download/${THERMOS_RELEASE_TAG}/Thermos-${MC_RELEASE_TAG}-${FORGE_RELEASE_TAG}-server.jar \
-O /home/minecraft/server/Thermos-${MC_RELEASE_TAG}-${FORGE_RELEASE_TAG}-server.jar \
&& wget https://github.com/CyberdyneCC/Thermos/releases/download/${THERMOS_RELEASE_TAG}/libraries.zip \
-O /home/minecraft/server/libraries.zip \
&& unzip /home/minecraft/server/libraries.zip -d /home/minecraft/server/ \
&& rm /home/minecraft/server/libraries.zip \
&& cd /home/minecraft/authlib \
&& zip -ur /home/minecraft/server/libraries/net/minecraft/server/${MC_RELEASE_TAG}/server-${MC_RELEASE_TAG}.jar ./ \
&& cd -

RUN mkdir -p /home/minecraft/mcbackup \
&& mkdir -p /home/minecraft/server/worlds \
&& mkdir -p /home/minecraft/server/dynmap \
&& mkdir -p /home/minecraft/server/mods \
&& mkdir -p /home/minecraft/server/logs \
&& mkdir -p /home/minecraft/server/plugins \
&& mkdir -p /home/minecraft/server/config \
&& mkdir -p /home/minecraft/server/config-server \
&& chmod +x /home/minecraft/init/minecraft

USER root

VOLUME ["/home/minecraft/mcbackup", "/home/minecraft/server/dynmap", "/home/minecraft/server/worlds", "/home/minecraft/server/plugins", "/home/minecraft/server/mods", "/home/minecraft/server/config", "/home/minecraft/server/logs", "/home/minecraft/server/config-server"]

# 25565 - MineCraft Server Port
# 8123 - Dynmap Plugin Port
EXPOSE 25565 8123
