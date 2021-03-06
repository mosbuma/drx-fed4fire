#source for docker install script:
# https://gist.github.com/EvgenyOrekhov/1ed8a4466efd0a59d73a11d753c0167b

printf "installing exchange frontend & backend\n" > /install-all-log.txt

set -o errexit
set -o nounset

if [[ $EUID -ne 0 ]]; then
    echo "{ \"failed\": true, \"msg\": \"This script should be run using sudo or as the root user\" }" > /install-all-log.txt
    cat /install-all-log.txt
    exit 1
fi

printf "waiting for internet to get enabled\n" >> /install-all-log.txt
while [ ! -f /tmp/internet-enabled ]; do sleep 1; done

if [ -x "$(command -v docker)" ]; then
  printf "remove existing docker installation\n" >> /install-all-log.txt
  sudo apt remove --yes docker-ce docker-ce-cli containerd.io
fi

printf "install docker\n" >> /install-all-log.txt
sudo apt update
sudo apt-get install
sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates software-properties-common software-properties-common
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
printf "* install git-lfs\n" >> /install-all-log.txt
apt-get install git-lfs -y
printf "* clone repository\n" >> /install-all-log.txt
git clone https://github.com/mosbuma/drx-fed4fire.git /drx-fed4fire
cd /drx-fed4fire/
printf "* pull from git lfs\n" >> /install-all-log.txt
git lfs pull

printf "* move frontend files\n" >> /install-all-log.txt
mv /drx-fed4fire/install-shared/exchange-frontend /drx-fed4fire/multi-node/install/exchange/

mkdir -p /drx-fed4fire/multi-node/install/exchange/exchange-backend
chmod -R o+rw /drx-fed4fire/multi-node/install/exchange/exchange-backend
printf "* move jar file\n" >> /install-all-log.txt
mv /drx-fed4fire/install-shared/exchange-backend/clients-0.1.jar /drx-fed4fire/multi-node/install/exchange/exchange-backend/
cd /drx-fed4fire/multi-node/install/exchange/


printf "* execute docker-compose up\n" >> /install-all-log.txt
docker-compose up -d

printf "install drx-fed4fire done\n" >> /install-all-log.txt

#set ready flag for jfed
touch /tmp/all-installed

cat /install-all-log.txt