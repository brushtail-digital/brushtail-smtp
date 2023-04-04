# Brushtail Digital SMTP relay

Basic SASL authenticated and TLS-enabled SMTP server, which relays messages to another SMTP server.

Environment variables:

```sh
SERVER_HOST=mail.example.com
RELAY_HOST=smtp.example.net:587
RELAY_AUTH=username:password
CERTBOT_EMAIL=certs@example.com
```

Requires a list of
```
<user1> <domain1> <password1>
<user2> <domain2> <password2>
...
```
to be mounted at `/mail_users`

## Example

Setup the allowed users in `mail_users`:

```sh
foo example.com password1
bar example.net password2
```

Start the server with:

```sh
docker run -p 80:80 -p 587:587 \
    -v mail_users:/mail_users \
    -e SERVER_HOST=mail.example.com \
    -e RELAY_HOST=smtp.example.net:587 \
    -e RELAY_AUTH=username:password \
    -e CERTBOT_EMAIL=certs@example.com \
    ghcr.io/brushtail-digital/brushtail-smtp
```
