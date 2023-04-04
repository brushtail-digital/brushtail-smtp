#!/bin/sh

crond -f &
if [ -f "/etc/letsencrypt/renewal/${SERVER_HOST}.conf" ]; then
    certbot renew &
else
    certbot certonly --standalone -d "$SERVER_HOST" --agree-tos -m "$CERTBOT_EMAIL" &
fi
postfix start-fg
