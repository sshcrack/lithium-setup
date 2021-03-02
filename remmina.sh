#!/bin/sh
usr=$(users)
rm -v /home/$usr/.local/share/keyrings/*
su $usr -c 'cd ~ && remmina -c profile.remmina'
