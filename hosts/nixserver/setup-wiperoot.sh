#!/usr/bin/env bash

passwd rick
mkdir /persist/etc
cp -r /etc/nixos /persist/etc
cp /etc/passwd /persist/etc/
cp /etc/shadow /persist/etc/
cp /etc/machine-id /persist/etc/
cp /etc/group /persist/etc/
ssh-keygen -A
mkdir /persist/ssh
cp /etc/ssh/ssh_host_rsa_key /persist/ssh
cp /etc/ssh/ssh_host_ed25519_key /persist/ssh

