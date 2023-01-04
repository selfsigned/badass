# ROUTE REFLECTOR
### BGP
RR_IP=1.1.1.1

vtysh -b
vtysh << EOF
conf t
no ipv6 forwarding
!
interface eth0
ip address 10.1.1.1/30
!
interface eth1
ip address 10.1.1.5/30
!
interface eth2
ip address 10.1.1.9/30
!
interface lo
ip address ${RR_IP}/32
!
router bgp 1
neighbor ibgp peer-group
neighbor ibgp remote-as 1
neighbor ibgp update-source lo
bgp listen range 1.1.1.0/29 peer-group ibgp
!
address-family l2vpn evpn
neighbor ibgp activate
neighbor ibgp route-reflector-client
exit-address-family
!
router ospf
network 0.0.0.0/0 area 0
!
line vty
!
exit
exit
write integrated
EOF