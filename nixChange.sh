#!/bin/sh
sudo bash /etc/nixos/configEdit.sh
echo "Successful build? (y)"
read response
if [ $response != "y" ]; then
exit beforeGit
else
sudo bash /etc/nixos/updateGit.sh
fi
