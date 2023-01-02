### VXLAN
VXLAN_IFNAME=vxlan42
VXLAN_BRIDGE=eth1
VNI=10

ip link add br0 type bridge
ip link set dev br0 up
ip link add $VXLAN_IFNAME type vxlan id $VNI dstport 4789
ip link set dev $VXLAN_IFNAME up 
brctl addif br0 $VXLAN_IFNAME
brctl addif br0 $VXLAN_BRIDGE

### BGP
vtysh << EOF
configure terminal
no ipv6 forwarding 
!
interface eth0
ip address 10.1.1.2/30
ip ospf area 0
!
interface lo
ip address 1.1.1.2/32
ip ospf area 0
!
router bgp 1
neighbor 1.1.1.1 remote-as 1
neighbor 1.1.1.1 update-source lo
!
address-family l2vpn evpn
neighbor 1.1.1.1 activate
advertise-all-vni
exit-address-family
!
router ospf
!
EOF