#!/usr/bin/env bash

mkdir /persist/{impermanence,passwd}
mkpasswd > /persist/passwd/rick
cp -r /etc/nixos /persist/impermenance/etc
cp /etc/machine-id /persist/impermenance/etc/
ssh-keygen -A
cp /etc/ssh/ssh_host_*_key{,.pub} /persist/impermenance/etc/ssh

