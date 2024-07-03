#!/bin/sh

#tmux new-session -d 'htop'
#tmux split-window -v 'ls'
#tmux split-window -h 'ls'
#tmux new-window 'ls'
#tmux -2 attach-session -d

# https://unix.stackexchange.com/questions/149606/how-do-i-create-a-simple-tmux-conf-that-splits-a-window
# # -t optional here, just to show how we do ...
tmux new-session -s system -n system  -d

# Win1
 tmux rename-window -t system:0 htop
tmux send-keys 'htop' C-j
#tmux split-window -v
#tmux send-keys 'source ~/.bash_profile' C-j
#tmux split-window -h
#tmux send-keys 'sudo openvpn /etc/openvpn/aqn.conf' C-j
#tmux send-keys -t vpn:htop.0 'ls' C-j

# Win2
tmux new-window -n 'ai'
tmux send-keys 'ai' C-j

tmux select-window -t system:ai
tmux attach -t system

