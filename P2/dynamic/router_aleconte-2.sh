WAN_IP=10.0.42.2
WAN_CIDR=24
REMOTE_IP=10.0.42.1

VXLAN_IFNAME=vxlan42
VXLAN_IP=10.1.42.2
VXLAN_CIDR=24
MULTICAST_GROUP=239.0.0.1

# Create a bridge type interface and bring it up
ip link add br0 type bridge
ip link set dev br0 up

# Setup eth0 as the WAN interface
ip addr add ${WAN_IP}/${WAN_CIDR} dev eth0

# Setup the vxlan interface on eth0, targeting a multicast group it an ip
ip link add name $VXLAN_IFNAME type vxlan id 10 dev eth0 group $MULTICAST_GROUP dstport 4789
ip addr add ${VXLAN_IP}/${VXLAN_CIDR} dev $VXLAN_IFNAME

# Add eth1 and the vxlan interface to the same bridge domain, effectively tunneling the lan port traffic into the VXLAN
brctl addif br0 eth1
brctl addif br0 $VXLAN_IFNAME

# Bring the vxlan interface up
ip link set dev $VXLAN_IFNAME up