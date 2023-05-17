FROM alpine:latest

RUN apk update && apk add --no-interactive zsh sudo make git && apk upgrade -a
RUN adduser -u 1000 -G users -D -h /home/proycon -s /bin/zsh proycon && adduser proycon wheel && echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-wheel

USER proycon

WORKDIR /home/proycon

ENV DESKTOP=1

RUN git clone https://git.sr.ht/~proycon/dotfiles && cd dotfiles && make install DESKTOP=$DESKTOP

WORKDIR /home/proycon

ENTRYPOINT ["/bin/zsh","-l"]

