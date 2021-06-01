#!/bin/sh
apt-get install git-lfs -y
git clone https://github.com/copyrightdelta/drx-fed4fire.git /drx-fed4fire
git lfs pull
mv /drx-fed4fire/install-shared/exchange-backend/clients-0.1.jar /drx-fed4fire/single-node/install/exchange-backend/
cd /drx-fed4fire/single-node/install/
chmod -R o+rw CopyrightDeltaA
chmod -R o+rw CopyrightDeltaB
chmod -R o+rw CopyrightDeltaNotary
docker-compose up -d