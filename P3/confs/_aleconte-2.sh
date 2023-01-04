# LEAF 1
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
RR_IP=1.1.1.1

vtysh -b
vtysh << EOF
conf t
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
neighbor ${RR_IP} remote-as 1
neighbor ${RR_IP} update-source lo
!
address-family l2vpn evpn
neighbor ${RR_IP} activate
advertise-all-vni
exit-address-family
!
router ospf
!
EOF
