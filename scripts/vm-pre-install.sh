#!/bin/bash

loadkeys br-abnt2

mkfs.fat -F32 /dev/vda1
mkfs.ext4 /dev/vda2
mkfs.ext4 /dev/vda3

mount /dev/vda2 /mnt
mkdir -p /mnt/boot/efi /mnt/home
mount /dev/vda2 /mnt/boot/efi
mount /dev/vda3 /mnt/home

pacstrap /mnt base base-devel linux linux-firmware nano vim dhcpcd git wget curl

genfstab -U -p /mnt >>/mnt/etc/fstab
arch-chroot /mnt
