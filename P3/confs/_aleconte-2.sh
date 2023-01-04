# LEAF 1
### VXLAN
VXLAN_IFNAME=vxlan42
VXLAN_BRIDGE=eth1
VNI=10

func_setup_vxlan
### BGP
RR_IP=1.1.1.1
LO_IP=1.1.1.2
WAN_IFNAME=eth0
WAN_IP=10.1.1.2
WAN_CIDR=30

func_setup_leaf_bgp