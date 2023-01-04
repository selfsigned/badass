# LEAF 3
### VXLAN
VXLAN_IFNAME=vxlan42
VXLAN_BRIDGE=eth0
VNI=10

func_setup_vxlan
### BGP
RR_IP=1.1.1.1
LO_IP=1.1.1.4
WAN_IFNAME=eth2
WAN_IP=10.1.1.10
WAN_CIDR=30

func_setup_leaf_bgp