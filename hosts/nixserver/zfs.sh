#!/usr/bin/env bash
sudo zpool create rpool $1
sudo zfs set mountpoint=none rpool
sudo zfs set compression=on rpool
sudo zfs create -o mountpoint=none rpool/local
sudo zfs create -o mountpoint=none rpool/safe
sudo zfs create -o mountpoint=legacy -o acltype=posixacl -o xattr=sa rpool/local/root
sudo zfs create -o mountpoint=legacy -o atime=off rpool/local/nix
sudo zfs create -o mountpoint=legacy rpool/safe/persist 
# uncomment for home on root drive
#sudo zfs create -o mountpoint=legacy rpool/safe/home
sudo zfs snapshot -r rpool@blank
sudo mount -t zfs rpool/local/root /mnt
sudo mkdir /mnt/{boot,nix,persist,home}
sudo mount -t zfs rpool/local/nix /mnt/nix
sudo mount -t zfs rpool/safe/persist /mnt/persist

echo "Create and mount home drive on /mnt/home"
echo "Remember to mount the boot parition on /mnt/boot"
