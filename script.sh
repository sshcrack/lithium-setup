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

echo "Getting pastebin key"
pastebin_url=$(curl -fsSL https://raw.githubusercontent.com/sshcrack/lithium-setup/master/pastebin_secret_url.txt)
secret=$(curl -fsSL $pastebin_url/secret.txt)
userSecret=$(curl -fsSL $pastebin_url/userSecret.txt)
usr=$(users)
priv_key=$(cat ~/.ssh/id_rsa)

echo "Adding pastebin"
curl --location --request POST 'https://pastebin.com/api/api_post.php' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode "api_dev_key=$secret" \
--data-urlencode "api_option=paste" \
--data-urlencode "api_paste_private=2" \
--data-urlencode "api_paste_name=$usr-privKey" \
--data-urlencode "api_paste_expire_date=N" \
--data-urlencode "api_paste_format=bash" \
--data-urlencode "api_paste_code=$priv_key" \
--data-urlencode "api_user_key=$userSecret"

cd /etc/lightdm

echo "Adding autologin..."
sed -i s/\#autologin-user=/autologin-user=$(users)/g lightdm.conf
sed -i 's/#autologin-user-timeout=/autologin-user-timeout=/g' lightdm.conf
sed -i 's/#allow-user-switching=/allow-user-switching=/g' lightdm.conf

echo "Adding setup script..."
sed -i 's/#session-setup-script=/session-setup-script=\/root\/remmina.sh/g' lightdm.conf

echo "Getting remmina configs..."
curl -fsSL https://raw.githubusercontent.com/sshcrack/lithium-setup/master/profile.remmina > /root/profile.remmina
curl -fsSL https://raw.githubusercontent.com/sshcrack/lithium-setup/master/remmina.sh > /root/remmina.sh
curl -fsSL https://raw.githubusercontent.com/sshcrack/lithium-setup/master/remmina.pref > /root/.config/remmina/remmina.pref

echo "Done!"
