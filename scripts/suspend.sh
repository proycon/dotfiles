/home/proycon/dotfiles/lock.sh &!
sleep 5
while pidof notmuch; do
    sleep 5
done
systemctl suspend
