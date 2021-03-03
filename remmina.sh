#!/bin/sh
usr=$(users)
xset s off -dpms
rm -v /home/$usr/.local/share/keyrings/*
cd /home/$usr
su $usr -c 'xset s off -dpms && cd /home/$(users) && remmina -c profile.remmina > log.log' &
