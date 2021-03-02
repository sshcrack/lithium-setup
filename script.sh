if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi
cat ./sources.list > /etc/apt/sources.list 
apt update
apt upgrade -y
apt dist-upgrade -y
apt install openssh-server openssh-client git -y
ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
cd ~/.ssh
cat id_rsa.pub >> authorized_keys
chmod -R 600 .
