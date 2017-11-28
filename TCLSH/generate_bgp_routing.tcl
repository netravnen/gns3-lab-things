# PRE-DEFINED PARAMETRES
set routerID 1

set bgpASN 42525

# ENABLE ROUTING PROTOCOLS
set bgpUP 1

# BGP ROUTING
if {$bgpUP == 1} {
	ios_config "interface Loopback0" "ip address 203.0.113.$routerID 255.255.255.255" "ipv6 address 2001:DB8::203:0:113:$routerID/128" "no shut"

	# GLOBAL BGP CONFIG
	ios_config "router bgp $bgpASN" "bgp default local-preference 200"
	ios_config "router bgp $bgpASN" "bgp consistency-checker auto-repair"
	ios_config "router bgp $bgpASN" "bgp log-neighbor-changes"
	ios_config "router bgp $bgpASN" "bgp transport path-mtu-discovery"
	ios_config "router bgp $bgpASN" "bgp graceful-restart restart-time 120"
	ios_config "router bgp $bgpASN" "bgp graceful-restart stalepath-time 360"
	
	ios_config "router bgp $bgpASN" "no bgp fast-external-fallover"
	ios_config "router bgp $bgpASN" "no bgp default ipv4-unicast"
	
	# BGP CONFIG IN ADDRESS FAMILY V4 AND V6
	foreach ipProtocol {
		"ipv4"
		"ipv6"
	} {
		# BGP CONFIG IN ADDRESS FAMILY
		ios_config "router bgp $bgpASN" "address-family $ipProtocol" "bgp suppress-inactive"
		ios_config "router bgp $bgpASN" "address-family $ipProtocol" "maximum-paths ibgp 6"
		ios_config "router bgp $bgpASN" "address-family $ipProtocol" "maximum-paths 6"
		ios_config "router bgp $bgpASN" "address-family $ipProtocol" "redistribute connected"
		ios_config "router bgp $bgpASN" "address-family $ipProtocol" "redistribute static"
		ios_config "router bgp $bgpASN" "address-family $ipProtocol" "distance bgp 199 200 200"
		ios_config "router bgp $bgpASN" "address-family $ipProtocol" "no auto-summary"

		# CONFIGURE PEER-GROUP: 'internal'
		ios_config "router bgp $bgpASN" "neighbor internal peer-group"
		ios_config "router bgp $bgpASN" "neighbor internal remote-as $bgpASN"
		ios_config "router bgp $bgpASN" "neighbor internal update-source loopback 0"
		ios_config "router bgp $bgpASN" "neighbor internal fall-over"
		ios_config "router bgp $bgpASN" "neighbor internal ha-mode graceful-restart"
		ios_config "router bgp $bgpASN" "neighbor internal version 4"

		ios_config "router bgp $bgpASN" "address-family $ipProtocol" "neighbor internal maximum-prefix 2000 90 restart 30"

		# CONFIGURE PEER-GROUP: 'external'
		ios_config "router bgp $bgpASN" "neighbor external peer-group"
		ios_config "router bgp $bgpASN" "neighbor external ebgp-multihop 5"
		ios_config "router bgp $bgpASN" "neighbor external version 4"
		
		ios_config "router bgp $bgpASN" "address-family $ipProtocol" "neighbor external next-hop-self"
		ios_config "router bgp $bgpASN" "address-family $ipProtocol" "neighbor external send-community both"
	}
}
