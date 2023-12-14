FROM alpine:3.17

RUN apk update && apk add --no-cache curl

RUN curl -L https://github.com/portainer/portainer/releases/download/2.18.4/portainer-2.18.4-linux-amd64.tar.gz -o portainer.tar.gz \
    && tar -xvf portainer.tar.gz \
    && mv portainer /usr/local/bin/ \
    && rm portainer.tar.gz

CMD ["/usr/local/bin/portainer/portainer"]
