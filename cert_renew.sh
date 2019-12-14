#!/bin/sh

SHELL_FOLDER=$(cd $(dirname $0);pwd)

sudo certbot renew --force-renewal --no-self-upgrade --manual --preferred-challenges dns \
    --manual-auth-hook "${SHELL_FOLDER}/cert_auth/au.sh python aly add" \
    --manual-cleanup-hook "${SHELL_FOLDER}/cert_auth/au.sh python aly clean" \
    --deploy-hook  "${SHELL_FOLDER}/cert_renew_hook.sh" \
    >> ${SHELL_FOLDER}/certbot_renew.log 2>&1
