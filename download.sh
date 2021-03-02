#!/bin/sh
curl https://codeload.github.com/sshcrack/lithium-setup/zip/master -o repo.zip
unzip repo.zip
cd lithium-setup-master
chmod +x script.sh
sudo ./script.sh
