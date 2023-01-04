# LEAF 2
### VXLAN
VXLAN_IFNAME=vxlan42
VXLAN_BRIDGE=eth0
VNI=10

func_setup_vxlan
### BGP
RR_IP=1.1.1.1
LO_IP=1.1.1.3
WAN_IFNAME=eth1
WAN_IP=10.1.1.6
WAN_CIDR=30

func_setup_leaf_bgp