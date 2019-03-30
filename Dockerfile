FROM java:8-jre-alpine

#RUN sed -i '/jessie-updates/d' /etc/apt/sources.list  # Now archived

# Updating container
#RUN apt-get update && \
#	apt-get upgrade --yes --force-yes && \
#	apt-get clean && \ 
#	rm -rf /var/lib/apt/lists/*

 RUN   apk update \                                                                                                                                                                                                  
  &&   apk add ca-certificates wget \                                                                                                                                                                                                      
  &&   update-ca-certificates
  

# Setting workdir
WORKDIR /minecraft

# Changing user to root
USER root

# Creating user and downloading files
RUN useradd -ms /bin/bash -U minecraft && \
        mkdir -p /minecraft/world && \
        wget -c https://minecraft.curseforge.com/projects/enigmatica2expert/files/2691578/download -O ftb.zip && \
        unzip ftb.zip && \
        rm ftb.zip && \
        chmod u+x ServerStartLinux.sh && \
        echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)." > eula.txt && \
	echo "$(date)" >> eula.txt && \
	echo "eula=TRUE" >> eula.txt && \
        chown -R minecraft:minecraft /minecraft

USER minecraft

# Run install
#RUN /minecraft/FTBInstall.sh

# Expose port
EXPOSE 25565

# Copy server.properties file & white-list
COPY server.properties server.properties
COPY whitelist.json whitelist.json
COPY ops.json ops.json
COPY settings.cfg settings.cfg

# Expose volume
VOLUME ["/minecraft/world", "/minecraft/backups"]

CMD ["/bin/bash", "./ServerStartLinux.sh"]