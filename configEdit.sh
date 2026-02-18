#!/bin/sh
echo "Launching configuration.nix in Nano" 
sleep 0.7
sudo vim /etc/nixos/configuration.nix
echo "Running nixos-rebuild switch" 
sleep 0.7
echo "Upgrade? (y)"
read response
if [ $response != "y" ]; then
sudo nixos-rebuild switch --upgrade
else
sudo nixos-rebuild switch
fi
