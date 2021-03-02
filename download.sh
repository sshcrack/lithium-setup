#!/bin/sh
if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi
curl https://codeload.github.com/sshcrack/lithium-setup/zip/master -o repo.zip
unzip repo.zip
rm repo.zip
cd lithium-setup-master
chmod +x script.sh
#sudo ./script.sh
