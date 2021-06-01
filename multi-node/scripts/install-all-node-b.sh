#source for docker install script:
# https://gist.github.com/EvgenyOrekhov/1ed8a4466efd0a59d73a11d753c0167b

set -o errexit
set -o nounset

if [[ $EUID -ne 0 ]]; then
    echo "{ \"failed\": true, \"msg\": \"This script should be run using sudo or as the root user\" }" > /install-all-log.txt
    cat /install-all-log.txt
    exit 1
fi

printf "starting docker install script\n" > /install-all-log.txt

printf "sleeping for a while to allow internet to get enabled first\n" >> /install-all-log.txt

sleep 15

printf "awake again\n" >> /install-all-log.txt

printf "test internet ping\n" >> /install-all-log.txt
echo ping -c 1 nu.nl >> /install-all-log.txt

if [ -x "$(command -v docker)" ]; then
  printf "remove existing docker installation\n" >> /install-all-log.txt
  sudo apt remove --yes docker-ce docker-ce-cli containerd.io
fi

printf "install docker\n" >> /install-all-log.txt
sudo apt update
sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates
wget --quiet --output-document=- https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable"
sudo apt update
sudo apt --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
sudo usermod --append --groups docker "$USER"

# printf 'Waiting after install...\n'
sleep 5

printf "enable docker\n" >> /install-all-log.txt
sudo systemctl enable docker

printf "\nDocker installed successfully\n" >> /install-all-log.txt

# printf 'Waiting for Docker to start...\n'
sleep 5

printf "Docker install script done\n" >> /install-all-log.txt

printf "starting docker-compose install script\n" >> /install-all-log.txt

if [[ $EUID -ne 0 ]]; then
    echo "{ \"failed\": true, \"msg\": \"This script should be run using sudo or as the root user\" }" > /install-all-log.txt
    cat /install-all-log.txt
    exit 1
fi

# Docker Compose
compose_release() {
  curl --silent "https://api.github.com/repos/docker/compose/releases/latest" |
  grep -Po '"tag_name": "\K.*?(?=")'
}

if ! [ -x "$(command -v docker-compose)" ]; then
  printf "install docker compose\n" >> /install-all-log.txt
  curl -L https://github.com/docker/compose/releases/download/$(compose_release)/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
  printf '\nDocker Compose installed successfully\n' >> /install-all-log.txt
else
  printf "skip install docker compose - already installed\n" >> /install-all-log.txt
fi

printf "docker-compose install script done\n" >> /install-all-log.txt

printf "install drx-fed4fire\n" >> /install-all-log.txt
apt-get install git-lfs -y
git clone https://github.com/mosbuma/drx-fed4fire.git /drx-fed4fire
cd /drx-fed4fire
git lfs pull
cd multi-node/install
printf "set permissions for docker node\n" >> /install-all-log.txt
chmod -R o+rw CopyrightDeltaB
cd CopyrightDeltaB

docker-compose up -d

printf "install drx-fed4fire done\n" >> /install-all-log.txt
cat /install-all-log.txt