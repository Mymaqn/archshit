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

#Go chroot in
arch-chroot /mnt

#time and locale setup
ln -sf /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime

hwclock --systohc

sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i -e 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen

locale-gen
echo "LANG=EN_US.UTF-8" > /etc/locale.conf

#hostname and hosts file
echo "zopzop" > /etc/hostname
echo "127.0.1.1  zopzop">> /etc/hosts

pacman -Sy networkmanager

#Create user
useradd -G wheel -m zopazz
echo "Set user password"
passwd zopazz

#install grub
pacman -Sy grub efibootmgr
pacman -Sy os-prober

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Set root password"
passwd
exit
reboot now