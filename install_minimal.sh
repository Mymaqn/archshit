pacman -Syuu
timedatectl set-ntp true
lsblk
echo "Create a main drive as Linux Filesystem and a 4gig swap type partition"
echo "If you are going to be dual booting, take note of your efi partition"
read -p "What drive whould you like to install on?" installdrive
cfdisk $installdrive

read -p "Filesystem partition name:" ext4Part
read -p "Swap partition name:" swapPart

mkfs.ext4 $ext4Part
mkswap $swapPart
swapon $swapPart

mount $ext4Part /mnt

#Check if they are dual booting. If they are we want to mount their efi partition to /mnt/efi
mkdir /mnt/efi

read -p "Dual boot? (y/N)" dualboot
case $dualboot in

y|Y|yes|Yes|YES)

read -p "Name of efi partition from Windows" efipart
mount $efipart /mnt/efi
esac

#install base system
pacstrap /mnt base linux linux-firmware

#Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

#Create file to run within chroot environment
echo "ln -sf /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime" >> /mnt/continue.sh
echo "hwclock --systohc" >> /mnt/continue.sh
echo "sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen" >> /mnt/continue.sh
echo "sed -i -e 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen" >> /mnt/continue.sh
echo "locale-gen" >> /mnt/continue.sh
echo "echo \"LANG=EN_US.UTF-8\" > /etc/locale.conf" >> /mnt/continue.sh
echo "echo \"zopzop\" > /etc/hostname" >> /mnt/continue.sh
echo "echo \"127.0.1.1  zopzop\">> /etc/hosts" >> /mnt/continue.sh

echo "pacman -Sy networkmanager" >> /mnt/continue.sh
echo "useradd -G wheel -m zopazz" >> /mnt/continue.sh
echo "echo \"Set user password\"" >> /mnt/continue.sh
echo "passwd zopazz" >> /mnt/continue.sh

echo "pacman -Sy grub efibootmgr" >> /mnt/continue.sh
echo "pacman -Sy os-prober" >> /mnt/continue.sh
echo "grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB" >> /mnt/continue.sh
echo "grub-mkconfig -o /boot/grub/grub.cfg" >> /mnt/continue.sh

echo "echo \"Set root password\"" >> /mnt/continue.sh
echo "passwd" >> /mnt/continue.sh
echo "exit" >> /mnt/continue.sh
echo "reboot now" >> /mnt/continue.sh

#Go chroot in
arch-chroot /mnt /bin/bash -c "chmod +x /continue.sh;/continue.sh"
