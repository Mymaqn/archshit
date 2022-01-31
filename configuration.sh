#Installation of git
sudo pacman -Sy git --noconfirm

#Installation of Python
sudo pacman -Sy python3 python-pip --noconfirm

#Installation of tools I want
sudo pacman -Syuu --noconfirm
sudo pacman -Sy base-devel net-tools linux-headers libuv mlocate xorg plasma-desktop sddm firefox plasma-nm plasma-pa dolphin konsole kdeplasma-addons kde-gtk-config egl-wayland zsh wget fd gdb pwndbg binwalk virtualbox --noconfirm

#Apply pwndbg config:
echo 'source /usr/share/pwndbg/gdbinit.py' >> ~/.gdbinit

#Install python packages
pip install wheel
pip install pycrypto
pip install pycryptodome
pip install ropper
pip install bs4

#Install yay and AUR packages:
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si --noconfirm
cd ..

yay -Sy python-pwntools --noconfirm

#Install Cutter
sudo mkdir /opt/tools
wget https://github.com/rizinorg/cutter/releases/download/v2.0.5/Cutter-v2.0.5-x64.Linux.AppImage
sudo cp ./Cutter-v2.0.5-x64.Linux.AppImage /opt/tools/Cutter
sudo chmod +x /opt/tools/Cutter

#Get networking running and display manager
sudo systemctl enable NetworkManager
sudo systemctl enable sddm

#Installation of zsh with cool stuff WOOP
zsh /usr/share/zsh/functions/Newuser/zsh-newuser-install -f

#Oh-my-zsh
cd ~
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

#Env variables
echo "export FZF_DEFAULT_COMMAND='fd --type f'" >> .zshrc
echo "export FZF_DEFAULT_OPTS=\"--layout=reverse --inline-info --height=80%\"" >> .zshrc
echo "export LC_ALL=en_US.UTF-8" >> .zshrc
echo "export PYTHONIOENCODING=UTF-8" >> .zshrc
echo "export PATH=\"\$PATH:\$HOME/.local/bin\"" >> .zshrc
echo "export PATH=\"\$PATH:/opt/tools\"" >> .zshrc

#Set plugins and theme
sed -i -e 's/plugins=(git)/plugins=(fzf git history-substring-search colored-man-pages zsh-autosuggestions zsh-syntax-highlighting z)/g' $HOME/.zshrc
sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="juanghurtado"/g' $HOME/.zshrc

echo "Restart when you are ready and the full configuration should work"
