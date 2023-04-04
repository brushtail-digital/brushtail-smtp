#!/bin/sh
set -e

if [ -z "${SERVER_HOST}" ]; then
    echo 'SERVER_HOST not specified' >&2
    exit 1
fi

if [ -z "${RELAY_HOST}" ]; then
    echo 'RELAY_HOST not specified' >&2
    exit 1
fi

if [ -z "${RELAY_AUTH}" ]; then
    echo 'RELAY_AUTH not specified' >&2
    exit 1
fi

if [ -z "${CERTBOT_EMAIL}" ]; then
    echo 'CERTBOT_EMAIL not specified' >&2
    exit 1
fi

# Setup certbot
echo "#!/bin/sh" > /etc/periodic/daily/certbot.sh
echo "certbot renew" >> /etc/periodic/daily/certbot.sh
chmod +x /etc/periodic/daily/certbot.sh

# Substitute environment variables into config
sed -i 's/{{HOST}}/'"${SERVER_HOST}"'/g' /etc/postfix/main.cf
sed -i 's/{{RELAY}}/'"${RELAY_HOST}"'/g' /etc/postfix/main.cf
sed -i 's/{{RELAY_AUTH}}/'"${RELAY_AUTH}"'/g' /etc/postfix/main.cf

# Populate sasldb and sender login map
args="$@"
while IFS= read -r line <&3; do
    if [ -n "$line" ]; then
        set -- $line
        sasl_login="$1"
        sasl_domain="$2"
        sasl_password="$3"
        echo "$sasl_password" | saslpasswd2 -f /sasl/sasldb2 -c -p -u "$sasl_domain" "$sasl_login"
        echo "@$sasl_domain $sasl_login@$sasl_domain" >> /etc/postfix/controlled_envelope_senders
    fi
done 3< "/mail_users"
chown postfix /sasl/sasldb2

exec "$args"
