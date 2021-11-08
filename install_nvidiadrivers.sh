sudo pacman -S nvidia nvidia-utils nvidia-settings xorg-server-devel opencl-nvidia
sudo pacman -S egl-wayland

sudo echo -en "Section \"OutputClass\"\n\tIdentifier \"intel\"\n\tMatchDriver \"i915\"\n\tDriver \"modesetting\"\nEndSection\n\nSection \"OutputClass\"\n\tIdentifier \"nvidia\"\n\tMatchDriver \"nvidia-drm\"\n\tDriver \"nvidia\"\n\tOption \"AllowEmptyInitialConfiguration\"\n\tOption \"PrimaryGPU\" \"yes\"\n\tModulePath \"/usr/lib/nvidia/xorg\"\n\tModulePath \"/usr/lib/xorg/modules\"\nEndSection\n">/etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
sudo echo -en "xrandr --setprovideroutputsource modesetting NVIDIA-0\nxrandr --auto\n">> /usr/share/sddm/scripts/Xsetup
sudo echo -en "options nvidia-drm.modeset=1\n" > /etc/modprobe.d/nvidia-drm-modeset.conf
sudo mkinitcpio -P

echo "Reboot when you are ready"
