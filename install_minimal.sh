timedatectl set-ntp true
echo "------------------------------------------------------------------------"
lsblk
echo "------------------------------------------------------------------------"
echo "Create a main drive as Linux Filesystem and a 4gig swap type partition"
echo "If you are going to be dual booting, take note of your efi partition from the list above"
echo "If you are not dual booting create an efi partition at the start of your drive size 512M"
echo ""
echo "Example for a fresh install partitioning:"
echo "Drive size: 300gb"
echo "EFI partition: 512M"
echo "Linux FileSystem partition: 295.5G"
echo "Swap partition: 4G"
echo ""
echo "Example for a dual boot partitioning"
echo "Drive size: 300gb"
echo "Linux Filesystem parition: 296G"
echo "Swap parition: 4G"
echo ""
read -p "What drive whould you like to install on?" installdrive
cfdisk $installdrive

echo "------------------------------------------------------------------------"
read -p "EFI partition name:" efipart
read -p "Filesystem partition name:" ext4Part
read -p "Swap partition name:" swapPart
echo "------------------------------------------------------------------------"
echo "------------------------------------------------------------------------"
echo "You have chosen:" 
echo "EFI partition: $efipart"
echo "Filesystem partition/ext4 $ext4Part"
echo "Swap partition $swapPart"

echo ""
echo "These partitions will now be overwritten by a new filesystem and get formatted"
read -p "Are you sure you want to continue? (y/N)" formatdisk
echo "------------------------------------------------------------------------"

echo $formatdisk

case $formatdisk in
y|Y|yes|Yes)

    mkfs.ext4 $ext4Part
    mkfs.fat -F 32 $efipart
    mkswap $swapPart
    swapon $swapPart


    mount $ext4Part /mnt

    #Check if they are dual booting. If they are we want to mount their efi partition to /mnt/efi
    mkdir /mnt/efi
    mount $efipart /mnt/efi

    #install base system
    pacstrap /mnt base linux linux-firmware

    #Generate fstab
    genfstab -U /mnt >> /mnt/etc/fstab

    #Create file to run within chroot environment
    #Sync time
    echo "ln -sf /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime" >> /mnt/continue.sh
    echo "hwclock --systohc" >> /mnt/continue.sh
    
    #Set locale
    echo "sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen" >> /mnt/continue.sh
    echo "sed -i -e 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen" >> /mnt/continue.sh
    echo "locale-gen" >> /mnt/continue.sh
    echo "echo \"LANG=EN_US.UTF-8\" > /etc/locale.conf" >> /mnt/continue.sh

    #Create hostname
    echo "echo \"zopzop\" > /etc/hostname" >> /mnt/continue.sh
    echo "echo \"127.0.1.1  zopzop\">> /etc/hosts" >> /mnt/continue.sh

    #Install my need to have applciations and enable internet
    echo "pacman -Sy networkmanager git sudo vim wget --noconfirm" >> /mnt/continue.sh
    echo "systemctl enable NetworkManager" >> /mnt/continue.sh

    #Create new user and add them to the sudoers file along with everyone in the wheel group
    echo "useradd -G wheel -m zopazz" >> /mnt/continue.sh
    echo "sed -i -e ':a;N;\$\!ba;s/## Uncomment to allow members of group wheel to execute any command\n#%wheel ALL=(ALL) ALL/## Uncomment to allow members of group wheel to execute any command\n%wheel ALL=(ALL) ALL/g'" >> /mnt/continue.sh
    
    #Setup grub
    echo "pacman -Sy grub efibootmgr --noconfirm" >> /mnt/continue.sh
    echo "pacman -Sy os-prober --noconfirm" >> /mnt/continue.sh
    echo "echo \"GRUB_DISABLE_OS_PROBER=false\" >> /etc/default/grub" >> /mnt/continue.sh
    echo "grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB" >> /mnt/continue.sh
    echo "grub-mkconfig -o /boot/grub/grub.cfg" >> /mnt/continue.sh

    #Create script that can be run on launch which downloads and runs the configuration I like
    echo "echo \"git clone https://github.com/Mymaqn/archshit\" >> /home/zopazz/configure.sh" >> /mnt/continue.sh
    echo "echo \"cd archshit\" >> /home/zopazz/configure.sh" >> /mnt/continue.sh
    echo "echo \"chmod +x ./configuration.sh\" >> /home/zopazz/configure.sh" >> /mnt/continue.sh
    echo "echo \"./configuration.sh\" >> /home/zopazz/configure.sh" >> /mnt/continue.sh
    
    #Set the root and user password
    echo "echo \"Set user password\"" >> /mnt/continue.sh
    echo "passwd zopazz" >> /mnt/continue.sh
    echo "echo \"Set root password\"" >> /mnt/continue.sh
    echo "passwd" >> /mnt/continue.sh
    echo "exit" >> /mnt/continue.sh
    
    #Now chroot in and execute the above script then remove it, when done
    arch-chroot /mnt /bin/bash -c "chmod +x /continue.sh;/continue.sh"
    rm /mnt/continue.sh
    cat /mnt/continue.sh
    read -p "Press any key to reboot" 
    reboot now
    ;;
*)
    echo "Aborting"
    ;;
esac



