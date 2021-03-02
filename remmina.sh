#!/bin/sh
usr=$(users)
rm -v /home/$usr/.local/share/keyrings/*
cd /home/$usr
su $usr -c 'sleep 5 && cd /home/$(users) && remmina -c profile.remmina > log.log' &
