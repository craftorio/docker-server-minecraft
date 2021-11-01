# MineCraft Server Docker Image

## Usage (Linux)

####  Install docker:

    $ wget -qO- https://get.docker.com/ | sudo sh

#### Checkout sources

    $ git clone https://github.com/mcstyle/docker-server.git && cd docker-server

#### Build docker image

**1.16.5**

    # mohist-1.16.5-759
    $ docker build --squash --build-arg MC_RELEASE_TAG=1.16.5 --build-arg MC_SERVER_TAG=mohist-1.16.5-845 -t craftorio/docker-server-minecraft:mohist-1.16.5-835 .


**1.12.2**  

    # 2705  
    $ docker build --build-arg MC_RELEASE_TAG=1.12.2 --build-arg MC_SERVER_TAG=1.12.2-2705 -t craftorio/docker-server-minecraft:1.12.2-2705 .
    
    # 2838
    $ docker build --build-arg MC_RELEASE_TAG=1.12.2 --build-arg MC_SERVER_TAG=1.12.2-2838 -t craftorio/docker-server-minecraft:1.12.2-2838 .

**1.10.2**  

    $ docker build --build-arg MC_RELEASE_TAG=1.10.2 --build-arg MC_SERVER_TAG=1.10.2-2281 -t craftorio/docker-server-minecraft:1.10.2 .
    
**1.7.10**

    $ docker build --build-arg MC_RELEASE_TAG=1.7.10 --build-arg MC_SERVER_TAG=1.7.10-1614-thermos -t craftorio/docker-server-minecraft:1.7.10-1614-thermos .

####  Install cli helper:

    $ sudo wget -O /usr/local/bin/mc-docker-run https://raw.githubusercontent.com/craftorio/docker-server-minecraft/1.12.2-2705/mc-docker-run?rand=$(date +%s)
    $ sudo chmod +x /usr/local/bin/mc-docker-run

####  Run the server:

Create data directory  

    $ mkdir -p ~/minecraft-server/myfunnyserver
    
Run docker containers  

    $ mc-docker-run --auth-server-url http://auth.myfunnyserver.com --image minecraft-server:1.10.2 --name myfunnyserver --data ~/minecraft-server/myfunnyserver --port 25565
    
  or
    
    $ export MINECRAFT_AUTH_SERVER_URL="https://auth.craftorio.com"
    $ export CONTAINER_IMAGE="craftorio/docker-server-minecraft:1.12.2-2838"
    $ mc-docker-run -d /opt/minecraft/myfunnyserver -n myfunnyserver -p 25565
    
Define init and max memory, and cpu count at run

    $ MC_CPU_COUNT=2 MC_MAX_MEMORY=4096M MC_INIT_MEMORY=2048M mc-docker-run -d ~/minecraft-server/myfunnyserver -n myfunnyserver -p 25565

#### Connect to MineCraft screen (console)
 
    $ docker exec -it myfunnyserver minecraft screen

*To detach from screen use: Ctrl + A then Ctrl + D*

#### Restart server
 
    $ docker exec -it myfunnyserver minecraft restart
    
#### List all available commands
    $ docker exec -it myfunnyserver minecraft help
