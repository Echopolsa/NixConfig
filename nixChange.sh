#!/bin/sh
sudo bash /etc/nixos/configEdit.sh
echo "Successful build? (y)"
read response
if [ "$response" != "y" ]; then
  echo "Skipping git commit."
  exit 1
fi
sudo bash /etc/nixos/updateGit.sh
