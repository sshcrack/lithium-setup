#!/bin/sh
rm -v $HOME/.local/share/keyrings/*
cd /etc/profile.d
sudo remmina profile.remmina &
