function func_setup_vxlan() {
    ip link add br0 type bridge
    ip link set dev br0 up
    ip link add $VXLAN_IFNAME type vxlan id $VNI dstport 4789
    ip link set dev $VXLAN_IFNAME up 
    brctl addif br0 $VXLAN_IFNAME
    brctl addif br0 $VXLAN_BRIDGE
}

function func_setup_leaf_bgp() {
    vtysh -b
    vtysh << EOF
conf t

#disable ipv6
no ipv6 forwarding

# Setup the TopOfRack interface and add it to the OSPF backbone (area 0)
!
interface ${WAN_IFNAME}
ip address ${WAN_IP}/${WAN_CIDR}
ip ospf area 0
!

# Setup the loopback interface and add it to the OSPF backbone
interface lo
ip address ${LO_IP}/32
ip ospf area 0
!

# Setup BGP AS 1, specifying the Route Reflector as neighbor, using the loopback interface as source
router bgp 1
neighbor ${RR_IP} remote-as 1
neighbor ${RR_IP} update-source lo
!

# Enable the L2VPN control plane adding the route reflector as neighbor and publish our VNI
address-family l2vpn evpn
neighbor ${RR_IP} activate
advertise-all-vni
exit-address-family
!

# Enable OSPF routing
router ospf
!

# Two exits because were lazy and two blocks in
exit
exit
write integrated
EOF
}

## KEEP THE NEWLINE AND APPEND CONFIG FILES AFTER THIS
