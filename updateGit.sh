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
  sudo git push origin main

