#Set wallpaper
mkdir ~/Pictures
cp wallpaper.png ~/Pictures
cp ./set-wallpaper.sh ~/.config 
./set-wallpaper.sh

echo "\$HOME/.config/set-wallpaper.sh" >> .zshrc


#Set the global KDE theme:
mkdir ~/.local/share/plasma
mkdir ~/.local/share/plasma/look-and-feel
mkdir ~/.local/share/icons
mkdir ~/.local/share/color-schemes
mkdir ~/.local/share/plasma/desktoptheme
mkdir ~/.kde4/share/apps
mkdir ~/.kde4/share/apps/color-schemes

tar xf ./kde-theme/Iridescent-round.tar.gz -C ~/.local/share/plasma/desktoptheme
tar xf ./kde-theme/color-schemes.tar.gz -C ~/.local/share/
cp ~/.local/share/color-schemes/IridescentLightly3.colors ~/.kd4/share/apps/color-schemes/
tar xf ./kde-theme/BeautyLine.tar.gz -C ~/.local/share/icons
tar xf ./kde-theme/Iridescent-kvantum.tar.gz -C ~/.local/share/plasma/look-and-feel/
lookandfeeltool -a Iridescent-kvantum

#Add the Konsole color scheme:
cp ./konsole/Shiny-Konsole.colorscheme ~/.local/share/konsole/Shiny-Konsole.colorscheme
cp ./konsole/zopzop.profile ~/.local/share/konsole/zopzop.profile
cp ./konsole/konsolerc ~/.config/konsolerc
