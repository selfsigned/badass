FROM frrouting/frr


RUN touch /etc/frr/frr.conf \
    /etc/frr/vtysh.conf \
	/etc/frr/bgpd.conf \
	/etc/frr/ospfd.conf \
	/etc/frr/isisd.conf && \
    chown frr:frr /etc/frr -R && \
	for i in "bgpd" "ospfd" "isisd"; do sed -i "s/^$i=no/$i=yes/" /etc/frr/daemons ; done
