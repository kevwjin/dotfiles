#!/bin/zsh

# Only run in interactive shell and not in chezmoi cd
if [[ $- == *i* && $0 != "-zsh" && ! "$PWD" =~ "\.local/share/chezmoi" ]]; then
    while true; do
        # Print options
        echo -n "(1) Local or (2) Remote: "

        # Get single character input without requiring Enter
        read -k choice

        case $choice in
            1)
                if [ -n "$TMUX" ]; then
                    echo "Already in a tmux session"
                else
                    tmux attach || tmux new
                fi
                break
                ;;
            2)
                if [ "$TERM" = "xterm-ghostty" ]; then
                    # For Ghostty terminal
                    TERM=xterm-256color ssh server -t \
                        'zsh -l -c "
                            tmux attach || tmux new
                            exec zsh -l
                        "'
                else
                    # For other terminals
                    ssh server -t \
                        'zsh -l -c "
                            tmux attach || tmux new
                            exec zsh -l
                        "'
                fi
                break
                ;;
            *)
                echo ""
        esac
    done
fi
