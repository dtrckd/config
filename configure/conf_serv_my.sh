#!/bin/bash

cat >> $HOME/.bashrc << EOF
if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi
EOF

# Reset/Configure firewall
sudo ./snippets/fw.sh restart
sudo systemctl restart docker
sudo ./snippets/fw.sh save
mkdir -p ~/bin
ln -s $(pwd)/snippets/fw.sh ~/bin/fw
ln -s $(pwd)/snippets/fw6.sh ~/bin/fw6

# Reset/Configure ssh
#sudo ./snippets/edit_config_line "PermitRootLogin" "no" /etc/ssh/sshd_config
#sudo ./snippets/edit_config_line "UsePAM" "no" /etc/ssh/sshd_config
#sudo systemctl restart ssh
#sudo systemctl restart sshd

# Reset/Configure Profile
cp -r dotfiles/{.bash_profile,.tmux.conf} ~/
cp dotfiles/.vimshortrc ~/.vimrc
# Delete the matched and the next line (recursive)
awk '/# @LOCAL/ {while (/# @LOCAL/ && getline>0) ; next} 1' ~/.tmux.conf > ~/.tmux.conf.temp && mv ~/.tmux.conf.temp ~/.tmux.conf
awk '/# @LOCAL/ {while (/# @LOCAL/ && getline>0) ; next} 1' ~/.bash_profile > ~/.bash_profile.temp && mv ~/.bash_profile.temp ~/.bash_profile
# Uncomment the next line (recursive)
sed -i '/# @SERVER/{n;s/^.//}' ~/.tmux.conf
sed -i '/# @SERVER/{n;s/^.//}' ~/.bash_profile
# Install plugins
# tmux plugin
[ ! -f ~/.tmux/plugins/tpm/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
