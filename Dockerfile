FROM alpine:latest

RUN apk --no-cache add certbot cyrus-sasl cyrus-sasl-login postfix

COPY ./config/master.cf /etc/postfix/master.cf
COPY ./config/main.cf /etc/postfix/main.cf
COPY ./config/smtpd.conf /etc/sasl2/smtpd.conf

COPY ./scripts/entrypoint.sh /scripts/entrypoint.sh
COPY ./scripts/run.sh /scripts/run.sh

RUN chmod +x /scripts/entrypoint.sh && \
    chmod +x /scripts/run.sh && \
    mkdir /sasl && \
    touch /mail_users

VOLUME [ "/etc/letsencrypt" ]
VOLUME [ "/mail_users" ]

ENTRYPOINT [ "/scripts/entrypoint.sh" ]
CMD [ "/scripts/run.sh" ]
