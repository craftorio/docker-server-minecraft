# MineCraft Server Docker Image

## Usage (Linux)

Install docker:

    $ wget -qO- https://get.docker.com/ | sudo sh

Get tool:

    $ sudo wget -O /usr/local/bin/mc-docker-run https://raw.githubusercontent.com/mcstyle/docker-server/master/mc-docker-run
    $ sudo chmod +x /usr/local/bin/mc-docker-run
    $ exec $SHELL # reload shell

Run the server:
    
    $ mc-docker-run --auth-server-url http://myfunnyserver.com --image mcstyle/server:1.7.10-1614-57-1 --name myfunnyserver --data /srv/minecraft-server --port 25565
