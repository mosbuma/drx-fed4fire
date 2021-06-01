#source for docker install script:
# https://gist.github.com/EvgenyOrekhov/1ed8a4466efd0a59d73a11d753c0167b

set -o errexit
set -o nounset

printf "starting docker-compose install script\n\n" >> /install-docker-compose-log.txt

if [[ $EUID -ne 0 ]]; then
    echo "{ \"failed\": true, \"msg\": \"This script should be run using sudo or as the root user\" }" > /install-docker-compose-log.txt
    cat /install-docker-compose-log.txt
    exit 1
fi

# Docker Compose
compose_release() {
  curl --silent "https://api.github.com/repos/docker/compose/releases/latest" |
  grep -Po '"tag_name": "\K.*?(?=")'
}

if ! [ -x "$(command -v docker-compose)" ]; then
  printf "install docker compose\n\n" > /install-docker-compose-log.txt
  curl -L https://github.com/docker/compose/releases/download/$(compose_release)/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
  printf '\nDocker Compose installed successfully\n\n' > /install-docker-compose-log.txt
else
  printf "skip install docker compose - already installed\n\n" >> /install-docker-compose-log.txt
fi

printf "docker-compose install script done\n\n" >> /install-docker-compose-log.txt
cat /install-docker-compose-log.txt
