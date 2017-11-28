# PRE-DEFINED PARAMETRES
set routerID 4

# ENABLE ROUTING PROTOCOLS
set isisUP 1

# ISIS ROUTING
if {$isisUP == 1} {
	set isisProc "router isis backbone"

	ios_config "$isisProc" "net 49.0000.0000.000$routerID.00"

	foreach cmd {
		"is-type level-2-only"
		"ispf level-2"
		"metric-style wide"
		"fast-flood 10"
		"set-overload-bit on-startup wait-for-bgp"
		"max-lsp-lifetime 65000"
		"spf-interval 5 1 50"
		"prc-interval 5 1 50"
		"lsp-gen-interval 5 1 50"
		"ignore-lsp-errors"
		"log-adjacency-changes"
		"passive-interface Loopback0"
		"ignore-attached-bit"
		"multi-topology"
		"adjacency-check"
		"maximum-paths 6"
		"traffic-share min across-interfaces"
		"mpls ldp sync"
	} {
		ios_config "$isisProc" "$cmd"
	}
}

foreach int {

} {
	ios_config "interface $int" "router isis backbone" "isis network point-to-point" "mpls ip" "cdp enable" "mtu 2000" "dampening" "negotiation auto"
	
	if {[string match "Se*" $int]} {
		ios_config "interface $int" "isis metric 12009000"
	}
	if {[string match "Eth*" $int]} {
		ios_config "interface $int" "isis metric 2502000"
	}
	if {[string match "Fa*" $int]} {
		ios_config "interface $int" "isis metric 500400"
	}
	if {[string match "Gi*" $int]} {
		ios_config "interface $int" "isis metric 100100"
	}
	if {[string match "Te*" $int]} {
		ios_config "interface $int" "isis metric 20032"
	}
}
