#!/bin/sh
git config --global --add safe.directory /etc/nixos
echo "Initializing Git in 'etc/nixos/'" 
sleep 0.7
cd /etc/nixos
sudo git init
echo "Adding 'configuration.nix' to git" 
sleep 0.7
sudo git add -A
echo "Now comitting generation " 
newGen=$(readlink /nix/var/nix/profiles/system | cut -d- -f2)
echo $newGen
echo "The previous version was version "
prevGen=$(($newGen - 1))
echo $prevGen
sleep 0.7
sudo git commit -m "4TB Generation $newGen"
echo "Copy the following username and password:"
echo "Echopolsa"
echo "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"
sudo git push origin main

