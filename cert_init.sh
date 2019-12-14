#!/bin/sh

DOMAINS=""
CERT_EMAIL=""
ALY_KEY=""
ALY_TOKEN=""
CRON_EXP=""
CRON_USER=""

# shell folder
SHELL_FOLDER=$(cd $(dirname $0);pwd)

# you should enable epel repo first by yourself

# install Certbot
sudo yum install -y certbot

# prepare au.sh
sudo yum install -y git
git clone https://github.com/realcbb/certbot-letencrypt-wildcardcertificates-alydns-au.git
mv certbot-letencrypt-wildcardcertificates-alydns-au cert_auth
sed -i "s/ALY_KEY=\"\"/ALY_KEY=\"${ALY_KEY}\"/" cert_auth/au.sh
sed -i "s/ALY_TOKEN=\"\"/ALY_TOKEN=\"${ALY_TOKEN}\"/" cert_auth/au.sh

# generate cert
sudo certbot certonly -d ${DOMAINS} --manual \
    --preferred-challenges dns \
    -m ${CERT_EMAIL} --no-eff-email \
    --agree-tos --manual-public-ip-logging-ok \
    --manual-auth-hook "${SHELL_FOLDER}/cert_auth/au.sh python aly add" \
    --manual-cleanup-hook "${SHELL_FOLDER}/cert_auth/au.sh python aly clean"

# set crontab
echo "${CRON_EXP} ${CRON_USER} sh ${SHELL_FOLDER}/cert_renew.sh" | sudo tee -a /etc/crontab
sudo systemctl restart crond
