FROM alpine:3.10

COPY entrypoint.sh /root/

ENTRYPOINT ["/root/entrypoint.sh"]
