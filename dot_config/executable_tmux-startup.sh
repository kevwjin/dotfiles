#!/bin/zsh

source $HOME/.zprofile
source $HOME/.zshrc
while true; do
    echo -n "(1) Local or (2) Remote: "
    read -k choice
    case $choice in
        1)
            if [ -n "$TMUX" ]; then
                echo "Already in a tmux session"
            else
                (tmux attach || tmux new) 2>/dev/null
                exec zsh -l  # continue with a new shell after tmux exits
            fi
            break
            ;;
        2)
            if [ "$TERM" = "xterm-ghostty" ]; then
                # for Ghostty terminal
                TERM=xterm-256color ssh server -t \
                     "(tmux attach || tmux new) 2>/dev/null; exec zsh -l"
            else
                # for other terminals
                ssh server -t \
                    "(tmux attach || tmux new) 2>/dev/null; exec zsh -l"
            fi
            break
            ;;
        *)
            echo ""
    esac
done
exec zsh -l  # fallback to ensure we always get a shell
