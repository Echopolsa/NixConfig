#!/bin/sh
git config --global --add safe.directory /etc/nixos
echo "Initializing Git in 'etc/nixos/'" 
sleep 0.7
cd /etc/nixos
sudo git init
echo "Adding 'configuration.nix' to git" 
sleep 0.7
sudo git add configuration.nix
echo "The previous version was version " 
Gen=$(readlink /nix/var/nix/profiles/system | cut -d- -f2)
echo $Gen
echo "Now commiting generation "
nextGen=$(($Gen + 1))
echo $nextGen
sleep 0.7
sudo git commit -m "Generation $nextGen"

