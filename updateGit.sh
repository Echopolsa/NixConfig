#!/bin/sh
# Only add the safe.directory entry once, instead of appending a duplicate every run
git config --global --get-all safe.directory | grep -qx /etc/nixos \
  || git config --global --add safe.directory /etc/nixos
cd /etc/nixos || exit 1
echo "Adding changes to git"
sleep 0.7
sudo git add -A
newGen=$(readlink /nix/var/nix/profiles/system | cut -d- -f2)
prevGen=$((newGen - 1))
echo "Now committing generation $newGen (previous was $prevGen)"
sleep 0.7
sudo git commit -m "4TB Generation $newGen"
sudo git push origin main
