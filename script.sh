if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi

working_dir = $PWD
cat ./sources.list > /etc/apt/sources.list 
apt update
apt upgrade -y
apt dist-upgrade -y
apt install openssh-server openssh-client git remmina remmina-plugin-rdp net-tools -y

#Setup ssh pubkey
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

cd /etc/lightdm

#Set Autlogin
sed -i s/\#autologin-user=/autologin-user=$(users)/g lightdm.conf
sed -i 's/#autologin-user-timeout=/autologin-user-timeout=/g' lightdm.conf

sed -i 's/#session-setup-script=/session-setup-script=/root/remmina.sh/g' lightdm.conf

cp $working_dir/remmina.sh /root/
cp $working_dir/profile.remmina /root/
