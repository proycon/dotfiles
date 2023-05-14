#!/bin/sh
while read -r line; do
    nr=$(echo "$line" | cut -d " " -f 1)
    remainder=$(echo "$line" | cut -d " " -f 2-)
    color="#fbf1c7"
    icon="  "
    case "$line" in
        *"Registration request from"*|*"build success"*|*"build fail"*|*Siksleden*|*Corpora-List*|*Nieuwsbrief*|*Newsletter*|*Correspondent*|*Steam*)
            color=gray
            ;;
        *"[PATCH"*)
            color=HotPink
            ;;
        *"TO:"*)
            color=green
            ;;
    esac
    case "$line" in
        *"TO:"*)
            icon=👉
            ;;
        *"frog"*)
            icon=🐸
            ;;
        *"folia"*)
            icon=🥬
            ;;
        *"clam"*)
            icon=🐚
            ;;
        *"sxmo"*)
            icon=📱
            ;;
        *)
            from=$(maddr -h from "$nr")
            spam=$(mhdr -h "X-Rspamd-Action:X-Spam-Status" "$nr")
            case "$spam" in 
                *Yes,*|*reject*|*greylist*)
                    color=black
                    ;;
            esac
            to=$(maddr -h "to:cc" "$nr")
            case "$from $to" in 
                *postmaster@science.ru.nl*|*admin@cls.ru.nl*)
                    icon=🎠
                    ;;
                *knaw.nl*|*@uu.nl*|*@uva.nl*|*@ru.nl*|*.ru.nl*|*ivdnt.nl*)
                    icon=💼
                    ;;
                *anaxotic*|*van-gompel*)
                    icon=👪
                    ;;
                *debian.org*|*alpinelinux.org*)
                    icon=🐧
                    ;;
                *github.com*)
                    color=HotPink
                    icon=🎫
                    ;;
                *sr.ht*)
                    color=HotPink
                    icon=🎫
                    ;;
                *noreply*|*homeautomation*)
                    color=gray
                    ;;
            esac
            ;;
    esac
    echo "$nr <span fgcolor=\"$color\">$remainder</span>" | sed "s/ ICON / $icon /" | sed 's/Re:/<span fgcolor="green">Re:<\/span>/i' | sed 's/Fwd:/<span fgcolor="blue">Fwd:<\/span>/i'
done
