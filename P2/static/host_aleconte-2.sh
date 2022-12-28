# Add static ip to eth1 and use the vxlan bridge on the router as gateway
ip addr add 30.1.42.2/24 dev eth1
ip route add default via 10.1.42.2