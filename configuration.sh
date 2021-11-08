#Installation of git
sudo pacman -Sy git

#Installation of Python
sudo pacman -Sy python3

#Installation of KDE
sudo pacman -Syuu
sudo pacman -S xorg
sudo pacman -S plasma-desktop
sudo pacman -S sddm
sudo pacman -S firefox plasma-nm plasma-pa dolphin konsole kdeplasma-addons kde-gtk-config

sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo systemctl enable sddm
sudo systemctl start sddm

#Installation of zsh with cool stuff WOOP
sudo pacman -S zsh
zsh /usr/share/zsh/functions/Newuser/zsh-newuser-install -f

#Oh-my-zsh
cd ~
sudo pacman -Sy wget
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
sudo pacman -Sy fd

echo "export FZF_DEFAULT_COMMAND='fd --type f'" >> .zshrc
echo "export FZF_DEFAULT_OPTS=\"--layout=reverse --inline-info --height=80%" >> .zshrc

#Set plugins and theme
sed -i -e 's/plugins=(git)/plugins=(fzf git history-substring-search colored-man-pages zsh-autosuggestions zsh-syntax-highlighting zsh-z)/g' $HOME/.zshrc
sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="juanghurtado"/g' $HOME/.zshrc
