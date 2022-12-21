#!/bin/bash
echo "->Setting up wireshark package"
echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections

echo "->Installing xfce and GNSv3 deps"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
	xorg lightdm xfce4 \
	fasttrack-archive-keyring gawk\
        curl gnupg ca-certificates lsb-release software-properties-common \
	git make gcc libc-dev libpcap-dev \
	python3-pip python3-pyqt5 python3-pyqt5.qtsvg python3-pyqt5.qtwebsockets \
	wireshark vim tmux\

echo "->Installing vbox guest additions"
echo "deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-fasttrack main contrib" >> /etc/apt/sources.list
echo "deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-backports-staging main contrib" >> /etc/apt/sources.list
gawk -i inplace '!seen[$0]++' /etc/apt/sources.list
apt-get update
apt-get install -y --no-install-recommends virtualbox-guest-x11

echo "->Installing docker-ce"
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y --no-install-recommends \
	docker-ce docker-ce-cli containerd.io docker-compose-plugin


echo "->Enabling sddm"
dpkg-reconfigure -fnoninteractive lightdm
systemctl enable --now lightdm

echo "->Installing GNSv3"
pip3 install gns3-server gns3-gui

echo "->Installing ubridge"
cd /usr/local/src
git clone https://github.com/GNS3/ubridge
cd /usr/local/src/ubridge && make install

echo "->Installing dynamips"
apt-add-repository non-free
apt-get update
apt-get install -y --no-install-recommends dynamips

echo "->Setup vagrant user"
for i in "video" "docker" "wireshark"; do
	usermod -aG $i vagrant
done
echo -e "vagrant\nvagrant" | passwd vagrant

echo "->Installation finished! login with vagrant:vagrant"

if [ ! -f ~/.first_shutdown ]; then
	touch ~/.first_shutdown
	echo "->Shutting down to finish install, re-run vagrant up"
	poweroff
fi

