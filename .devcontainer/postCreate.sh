
#!/bin/bash
# Update and upgrade all system packages
apt update
apt upgrade -y

  #apt install g++-12 -y
  #echo export CC=gcc-12 CXX=g++-12 >> /etc/profile.d/set-compiler.sh

echo "------------------------------"
echo "Installing missing packages..."
echo "------------------------------"