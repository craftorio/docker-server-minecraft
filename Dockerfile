FROM craftorio/docker-ubuntu-java:oraclejdk-14
ARG MC_RELEASE_TAG=1.16.5
ARG MC_SERVER_TAG=mohist-1.16.5-845
ARG S3CMD_RELEASE_TAG=1.6.1

RUN adduser --disabled-password --gecos '' minecraft
RUN wget https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_RELEASE_TAG}/s3cmd-${S3CMD_RELEASE_TAG}.zip \
-O /opt/s3cmd-${S3CMD_RELEASE_TAG}.zip \
&& unzip /opt/s3cmd-${S3CMD_RELEASE_TAG}.zip -d /opt/ \
&& rm /opt/s3cmd-${S3CMD_RELEASE_TAG}.zip \
&& ln -s /opt/s3cmd-${S3CMD_RELEASE_TAG}/s3cmd /usr/bin/s3cmd \
&& chmod +x /opt/s3cmd-${S3CMD_RELEASE_TAG}/s3cmd

COPY b2 /usr/local/bin/b2
COPY gotty /usr/local/bin/gotty
COPY gosu /usr/local/bin/gosu
COPY runit/minecraft /etc/service/minecraft/run
COPY runit/gotty /etc/service/gotty/run
COPY runit/sshd /etc/service/sshd/run
COPY init /home/minecraft/init
COPY .s3cfg /home/minecraft/.s3cfg
#COPY authlib/$MC_RELEASE_TAG /home/minecraft/authlib
COPY forge/$MC_RELEASE_TAG /home/minecraft/forge
COPY server/$MC_SERVER_TAG /home/minecraft/server
COPY ultra-core-agent-java8.jar /home/minecraft/server/ultra-core-agent-java8.jar
COPY ultra-core-agent-java14.jar /home/minecraft/server/ultra-core-agent-java14.jar
COPY ultra-core-agent-server.conf /home/minecraft/server/ultra-core-agent-server.conf

RUN chmod +x /usr/local/bin/b2 \
&& chmod +x /etc/service/minecraft/run \
&& chmod +x /etc/service/gotty/run \
&& chmod +x /etc/service/sshd/run

RUN chmod +x /home/minecraft/init/minecraft && ln -s /home/minecraft/init/minecraft /usr/local/bin/minecraft
RUN chown minecraft:minecraft -R /home/minecraft

USER minecraft
WORKDIR /home/minecraft/server
RUN java -jar /home/minecraft/forge/forge-${MC_RELEASE_TAG}-*-installer.jar --installServer --debug

#RUN cd /home/minecraft/authlib \
#&& zip -ur /home/minecraft/server/minecraft_server.${MC_RELEASE_TAG}.jar ./ \
#&& zip -ur /home/minecraft/server/libraries/minecraft_server.${MC_RELEASE_TAG}.jar ./ \
#&& cd -

RUN mkdir -p \
/home/minecraft/mcbackup \
/home/minecraft/server/worlds \
/home/minecraft/server/dynmap \
/home/minecraft/server/mods \
/home/minecraft/server/logs \
/home/minecraft/server/plugins \
/home/minecraft/server/config \
/home/minecraft/server/config-server \
/home/minecraft/server/scripts \
/home/minecraft/server/Flan

USER root

VOLUME ["/home/minecraft/mcbackup", "/home/minecraft/server/dynmap", "/home/minecraft/server/worlds", "/home/minecraft/server/plugins", "/home/minecraft/server/mods", "/home/minecraft/server/config", "/home/minecraft/server/logs", "/home/minecraft/server/config-server", "/home/minecraft/server/scripts", "/home/minecraft/server/Flan"]

# 25565 - MineCraft Server Port
# 8123 - Dynmap Plugin Port
EXPOSE 25565 8123 8080 22

ENV JAVA_HOME=/usr/lib/jvm/jdk-14.0.2
ENV PATH $PATH:$JAVA_HOME/bin

# Enable sshd
RUN rm -f /etc/service/sshd/down
