#!/bin/bash

set -o errexit
set -o nounset

NODENAME=$1
LOGFILE=/install-$1.txt

printf "starting docker install script\n" > $LOGFILE

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
cat $LOGFILE
