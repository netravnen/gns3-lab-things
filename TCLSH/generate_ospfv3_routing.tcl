# PRE-DEFINED PARAMETRES
set routerID 6
set ospfv3ID 42525
set ospfv3Ar 0

# ENABLE ROUTING PROTOCOLS
set ospfv3UP 1

# OSPFV3 ROUTING
if {$ospfv3UP == 1} {
	set ospfv3Proc "router ospfv3 $ospfv3ID"
	
	ios_config $ospfv3Proc "router-id 203.0.113.$routerID"
	ios_config "interface Loopback0" "ip address 203.0.113.$routerID 255.255.255.255" "ipv6 address 2001:DB8::203:0:113:$routerID/128"
	ios_config "interface Loopback0" "ospfv3 $ospfv3ID ipv6 area 0.0.0.$ospfv3Ar" "ospfv3 $ospfv3ID ipv4 area 0.0.0.$ospfv3Ar"
	ios_config "interface Loopback0" "ospfv3 network point-to-point" "no shut"

	foreach cmd {
		"passive-interface Loopback0"
		"timers lsa arrival 30000"
		"timers pacing flood 50"
		"timers pacing lsa-group 1000"
		"timers pacing retransmission 200"
		"timers throttle lsa 5000"
		"timers throttle spf 12000"
		"queue-depth hello 10000"
		"queue-depth update 10000"
		"graceful-restart helper strict-lsa-checking"
		"event-log size 5000"
		"compatible rfc1587"
		"auto-cost reference-bandwidth 10000"
	} {
		ios_config "$ospfv3Proc" "$cmd"
	}
	
	foreach cmd {
		"area 0 transit"
		"area 7 normal"
		"area 8 normal"
		"log-adjacency-changes detail"
		"maximum-paths 6"
	} {
		foreach family { "ipv4" "ipv6" } { ios_config "$ospfv3Proc" "address-family $family unicast" "$cmd" }
	}
}
	