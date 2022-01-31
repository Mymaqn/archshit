#Set wallpaper
cp wallpaper.png ~/Pictures
./set-wallpaper.sh


#Set the global KDE theme:
tar xf ./kde-theme/Iridescent-kvantum.tar.gz -C ~/.local/share/plasma/look-and-feel/
lookandfeeltool -a Iridescent-kvantum

#Add the Konsole color scheme:
cp ./konsole/Shiny-Konsole.colorscheme ~/.local/share/konsole/Shiny-Konsole.colorscheme
cp ./zopzop.profile ~/.local/share/konsole/zopzop.profile
cp ./konsole/konsolerc ~/.config/konsolerc
