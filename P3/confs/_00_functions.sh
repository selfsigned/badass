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
no ipv6 forwarding
!
interface ${WAN_IFNAME}
ip address ${WAN_IP}/${WAN_CIDR}
ip ospf area 0
!
interface lo
ip address ${LO_IP}/32
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

# Two exits because were lazy and two blocks in
exit
exit
write integrated
EOF
}

## KEEP THE NEWLINE AND APPEND CONFIG FILES AFTER THIS
