#!/bin/bash

set -o errexit
set -o nounset

NODENAME=singlenode
LOGFILE=/install-$NODENAME.txt

printf "installing node $NODENAME\n" > $LOGFILE

if [[ $EUID -ne 0 ]]; then
    echo "{ \"failed\": true, \"msg\": \"This script should be run using sudo or as the root user\" }" >> $LOGFILE
    cat $LOGFILE
    exit 1
fi

printf "waiting for internet to get enabled\n" >> $LOGFILE
while [ ! -f /tmp/internet-enabled ]; do sleep 1; done

if [ -x "$(command -v docker)" ]; then
  printf "remove existing docker installation\n" >> $LOGFILE
  sudo apt remove --yes docker-ce docker-ce-cli containerd.io
fi

#source for docker install script:
# https://gist.github.com/EvgenyOrekhov/1ed8a4466efd0a59d73a11d753c0167b
printf "install docker\n" >> $LOGFILE
sudo apt update
sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates software-properties-common
wget --quiet --output-document=- https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable"
sudo apt update
sudo apt --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
sudo usermod --append --groups docker "$USER"

# printf 'Waiting after install...\n'
sleep 5

printf "enable docker\n" >> $LOGFILE
sudo systemctl enable docker

printf "\nDocker installed successfully\n" >> $LOGFILE

# printf 'Waiting for Docker to start...\n'
sleep 5

printf "Docker install script done\n" >> $LOGFILE

printf "starting docker-compose install script\n" >> $LOGFILE

if [[ $EUID -ne 0 ]]; then
    echo "{ \"failed\": true, \"msg\": \"This script should be run using sudo or as the root user\" }" > $LOGFILE
    cat $LOGFILE
    exit 1
fi

# Docker Compose
compose_release() {
  curl --silent "https://api.github.com/repos/docker/compose/releases/latest" |
  grep -Po '"tag_name": "\K.*?(?=")'
}

if ! [ -x "$(command -v docker-compose)" ]; then
  printf "install docker compose\n" >> $LOGFILE
  curl -L https://github.com/docker/compose/releases/download/$(compose_release)/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
  printf '\nDocker Compose installed successfully\n' >> $LOGFILE
else
  printf "skip install docker compose - already installed\n" >> $LOGFILE
fi

printf "docker-compose install script done\n" >> $LOGFILE

printf "install drx-fed4fire\n" >> $LOGFILE
printf "* install git-lfs\n" >> $LOGFILE
apt-get install git-lfs -y
printf "* clone repository\n" >> $LOGFILE
git clone https://github.com/mosbuma/drx-fed4fire.git /drx-fed4fire
cd /drx-fed4fire
printf "* pull from git lfs\n" >> $LOGFILE
git lfs pull

# Docker Compose
setup_corda_node() {
  printf "setup corda node $1\n" >> $LOGFILE
  mkdir -p $1/logs
  mkdir -p $1/drivers
  mkdir -p $1/persistence
  chmod -R o+rw $1
}

cd single-node/install

printf "* move frontend files\n" >> /install-all-log.txt
mv /drx-fed4fire/install-shared/exchange-frontend /drx-fed4fire/single-node/install/

printf "* move jar file\n" >> /install-all-log.txt
mv /drx-fed4fire/install-shared/exchange-backend/clients-0.1.jar /drx-fed4fire/single-node/install/exchange-backend/
cd /drx-fed4fire/single-node/install/

setup_corda_node CopyrightDeltaA
setup_corda_node CopyrightDeltaB
setup_corda_node CopyrightDeltaNotary

printf "* execute docker-compose up\n" >> $LOGFILE
docker-compose up -d

 printf "install drx-fed4fire done\n" >> $LOGFILE

#set ready flag for jfed
touch /tmp/all-installed

cat $LOGFILE