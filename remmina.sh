#!/bin/sh
usr=$(users)
rm -v /home/$usr/.local/share/keyrings/*
su $usr -c 'sleep 5 && cd ~ && remmina -c profile.remmina' &
