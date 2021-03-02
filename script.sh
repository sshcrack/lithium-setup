if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi
cat ./sources.list > /etc/apt/sources.list 
apt update
apt upgrade -y
apt dist-upgrade -y
apt install openssh-server -y
apt install openssh-client -y
apt install git-y