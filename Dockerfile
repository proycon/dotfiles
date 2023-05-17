FROM alpine:latest

RUN apk update && apk add --no-interactive zsh sudo make git && apk upgrade -a
RUN adduser -u 1000 -G users -D -h /home/proycon -s /bin/zsh proycon && adduser proycon wheel && echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-wheel

COPY . /home/proycon/dotfiles/

USER proycon

RUN cd /home/proycon/dotfiles && make install

WORKDIR /home/proycon

ENTRYPOINT ["/bin/zsh","-l"]

