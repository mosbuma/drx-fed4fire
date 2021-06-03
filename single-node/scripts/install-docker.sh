#source for docker install script:
# https://gist.github.com/EvgenyOrekhov/1ed8a4466efd0a59d73a11d753c0167b

set -o errexit
set -o nounset

printf "starting docker install script\n\n" > /install-docker-log.txt

if [[ $EUID -ne 0 ]]; then
    echo "{ \"failed\": true, \"msg\": \"This script should be run using sudo or as the root user\" }" > /install-docker-log.txt
    cat /install-docker-log.txt
    exit 1
fi

if [ -x "$(command -v docker)" ]; then
  printf "remove existing docker installation\n\n" >> /install-docker-log.txt
  sudo apt remove --yes docker-ce docker-ce-cli containerd.io
fi

printf "install docker\n\n" >> /install-docker-log.txt
sudo apt update
sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates software-properties-common
wget --quiet --output-document=- https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable"
sudo apt update
sudo apt --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
sudo usermod --append --groups docker "$USER"

# printf 'Waiting after install...\n\n'
sleep 5

printf "enable docker\n\n" >> /install-docker-log.txt
sudo systemctl enable docker

printf "\nDocker installed successfully\n\n" >> /install-docker-log.txt

# printf 'Waiting for Docker to start...\n\n'
sleep 5

printf "Docker install script done\n\n" >> /install-docker-log.txt
cat /install-docker-log.txt
