### VXLAN
VXLAN_IFNAME=vxlan42
VXLAN_BRIDGE=eth0
VNI=10

ip link add br0 type bridge
ip link set dev br0 up
ip link add $VXLAN_IFNAME type vxlan id $VNI dstport 4789
ip link set dev $VXLAN_IFNAME up 
brctl addif br0 $VXLAN_IFNAME
brctl addif br0 $VXLAN_BRIDGE

### BGP
vtysh << EOF
EOF