#!/bin/sh

ALY_KEY=""
ALY_TOKEN=""
CRON_EXP=""
CRON_USER=""

# shell folder
SHELL_FOLDER=$(cd $(dirname $0);pwd)

# prepare au.sh
sudo yum install -y git
git clone https://github.com/realcbb/certbot-letencrypt-wildcardcertificates-alydns-au.git
mv certbot-letencrypt-wildcardcertificates-alydns-au cert_auth
sed -i "s/ALY_KEY=\"\"/ALY_KEY=\"${ALY_KEY}\"/" cert_auth/au.sh
sed -i "s/ALY_TOKEN=\"\"/ALY_TOKEN=\"${ALY_TOKEN}\"/" cert_auth/au.sh

echo "${CRON_EXP} ${CRON_USER} sh ${SHELL_FOLDER}/cert_renew.sh" | sudo tee -a /etc/crontab
sudo systemctl restart crond
