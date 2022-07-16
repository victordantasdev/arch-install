ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime
hwclock --systohc

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen
locale-gen

echo KEYMAP=br-abnt2 >>/etc/vconsole.conf

echo arch >>/etc/hostname

echo "passwd"
passwd

useradd -m -g users -G wheel,storage,power -s /bin/bash victor

echo "passwd victor"
passwd victor

pacman -S \
  dosfstools \
  os-prober \
  mtools \
  network-manager-applet \
  networkmanager \
  wpa_supplicant \
  wireless_tools \
  dialog \
  archlinux-keyring

pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

# install GUI
pacman -S \
  xorg \
  mesa \
  xf86-video-intel \
  nvidia \
  nvidia-settings \
  firefox \
  git \
  go \
  htop \
  neofetch

# install Gnome
pacman -S \
  gnome \
  gnome-terminal
