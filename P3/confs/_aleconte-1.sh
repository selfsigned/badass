# ROUTE REFLECTOR
### BGP
RR_IP=1.1.1.1

vtysh -b
vtysh << EOF
conf t
no ipv6 forwarding

# Setup the spine/route reflector interfaces
interface eth0
ip address 10.1.1.1/30

interface eth1
ip address 10.1.1.5/30

interface eth2
ip address 10.1.1.9/30

# Setup the loopback interface 
interface lo
ip address ${RR_IP}/32

# Setup BGP group for AS 1 with the name ibgp 
router bgp 1
neighbor ibgp peer-group
neighbor ibgp remote-as 1
neighbor ibgp update-source lo
bgp listen range 1.1.1.0/29 peer-group ibgp

# Enable the L2VPN control plane adding all leafs as neighbor and add route-reflector client relation
address-family l2vpn evpn
neighbor ibgp activate
neighbor ibgp route-reflector-client
exit-address-family

router ospf
# Add every addresses to area 0 (backbone)
network 1.0.0.0/8 area 0
network 10.0.0.0/8 area 0

exit
exit

# Save config to configuration files
write integrated
EOF