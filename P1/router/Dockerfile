FROM frrouting/frr

RUN for i in "bgpd" "ospfd" "isisd"; do sed -i "s/^$i=no/$i=yes/" /etc/frr/daemons ; done
