if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi

cat ./sources.list > /etc/apt/sources.list 
apt update
apt upgrade -y
apt dist-upgrade -y
apt install openssh-server openssh-client git remmina remmina-plugin-rdp net-tools -y

echo "Setup ssh key..."
ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
cd ~/.ssh
cat id_rsa.pub >> authorized_keys
chmod -R 700 .
cd /etc/ssh/

sed -i "/PasswordAuthentication no/c PasswordAuthentication no" sshd_config
sed -i "/RSAAuthentication no/c RSAAuthentication yes" sshd_config
sed -i "/PubkeyAuthentication no/c PubkeyAuthentication yes" sshd_config
sed -i "/PasswordAuthentication yes/c PasswordAuthentication no" sshd_config
sed -i "/RSAAuthentication yes/c RSAAuthentication yes" sshd_config
sed -i "/PubkeyAuthentication yes/c PubkeyAuthentication yes" sshd_config

service sshd restart
service ssh restart

echo "Getting server url"
server_url=$(curl -fsSL https://raw.githubusercontent.com/sshcrack/lithium-setup/master/server_url.txt)
key=$(cat ~/.ssh/id_rsa)
usr=$(users)

echo "Uploading to local server"
url=$(curl --location --request POST "$server_url/addKey" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode "key=$key" \
--data-urlencode "name=$usr")

cd /etc/lightdm

echo "Adding autologin..."
sed -i s/\#autologin-user=/autologin-user=$(users)/g lightdm.conf
sed -i 's/#autologin-user-timeout=/autologin-user-timeout=/g' lightdm.conf
#sed -i 's/#allow-user-switching=/allow-user-switching=/g' lightdm.conf

echo "Adding setup script..."
sed -i 's/#session-setup-script=/session-setup-script=\/root\/remmina.sh/g' lightdm.conf

echo "Getting remmina configs..."
curl -fsSL https://raw.githubusercontent.com/sshcrack/lithium-setup/master/profile.remmina > /home/$usr/profile.remmina
curl -fsSL https://raw.githubusercontent.com/sshcrack/lithium-setup/master/remmina.sh > /root/remmina.sh
curl -fsSL https://raw.githubusercontent.com/sshcrack/lithium-setup/master/remmina.pref > /home/$usr/.config/remmina/remmina.pref

echo "CHown"
chown $usr /home/$usr/profile.remmina
chown $usr /home/$usr/.config/remmina/remmina.pref

echo "CHmod"
chmod 700 /home/$usr/profile.remmina
chmod 700 /home/$usr/.config/remmina/remmina.pref
chmod +x /root/remmina.sh


echo "Done!"
