#
#### DEFAULT PREFIX LISTS ADDRESS FAMILY V4 ###
#
ios_config "ip prefix-list DEFAULT-OUT seq 5 permit 0.0.0.0/0"
ios_config "ip prefix-list DEFAULT-IN seq 5 permit 0.0.0.0/0"
ios_config "ip prefix-list ANY seq 5 permit 0.0.0.0/0 ge 8 le 32"
ios_config "ip prefix-list ANY-LE24 seq 5 permit 0.0.0.0/0 ge 8 le 24"
ios_config "ip prefix-list LINKNET seq 5 permit 0.0.0.0/0 ge 29 le 31"
ios_config "ip prefix-list ANY-GE16-LE24 seq 5 permit 0.0.0.0/0 ge 16 le 24"

foreach prefixListRFC1918Subnet {
    "10.0.0.0/8 le 32"
    "172.16.0.0/12 le 32"
    "192.168.0.0/16 le 32"
} {
    ios_config "ip prefix-list RFC1918-PERMIT permit $prefixListRFC1918Subnet"
    ios_config "ip prefix-list RFC1918-DENY deny $prefixListRFC1918Subnet"
}

ios_config "no ip prefix-list BOGON-DENY"
foreach teamCymruBogonAsnNonagg {
    "0.0.0.0/8"
    "10.0.0.0/8 le 32"
    "100.64.0.0/10 le 32"
    "127.0.0.0/8 le 32"
    "169.254.0.0/16 le 32"
    "172.16.0.0/12 le 32"
    "192.0.0.0/24 le 32"
    "192.0.2.0/24 le 32"
    "192.168.0.0/16 le 32"
    "198.18.0.0/15 le 32"
    "198.51.100.0/24 le 32"
    "203.0.113.0/24 le 32"
    "224.0.0.0/4 le 32"
    "240.0.0.0/4 le 32"
} {
    ios_config "ip prefix-list BOGON-DENY deny $teamCymruBogonAsnNonagg"
}

#
#### DEFAULT PREFIX LISTS ADDRESS FAMILY V6 ###
#

#
#### ROUTER MAPS ###
#
set i 10
ios_config "route-map CHECK-NEXTHOP permit $i" "match ip address prefix-list FILTER25"

ios_config "route-map CHECK-NBR permit $i" "match ip address prefix-list FILTER28"
