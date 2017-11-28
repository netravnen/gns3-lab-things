# PRE-DEFINED PARAMETRES
set systemHostname as1
set autoLogoutAfterXMinutes 60
set sshKeyMinLength 2048

# ENABLE OR DISABLE THINGS
set changeHostname 1
set enableThisIsALab 0
set enableRouting 0
set enableV6Routing 0

# CCNP Switch lab work BASE.CFG
set vlan499ipv4addr "192.0.2.4 255.255.255.255"
set vlan499ipv6addr "2001:db8:c000:2::4/128"

######################################################################*

# TIMESTAMPS
ios_config "service timestamps debug datetime msec localtime show-timezone"
ios_config "service timestamps log datetime msec localtime show-timezone"
ios_config "clock timezone MET 1 0"
ios_config "clock summer-time MET-DST recurring last Sun Mar 2:00 last Sun Oct 3:00"

# Change hostname
if { $changeHostname == 1 } {
    ios_config "hostname $systemHostname"
}

# ENABLE IPV6
if { $enableV6Routing == 1 } {
    ios_config "ipv6 unicast-routing"
}

# ENABLE CEF
if { $enableRouting == 1 } {
    ios_config "ip cef"
}

if { $enableV6Routing == 1 } {
    ios_config "ipv6 cef"
}

# PREVENT DNS LOOKUPS
ios_config "no ip domain-lookup"

# RATELIMITING PARAMS
ios_config "ip tcp synwait 5"

if {$enableThisIsALab == 1} {
    ios_config "no ip icmp rate-limit unreachable"
} else {
    ios_config "ip icmp rate-limit unreachable 100 log"
}

# CONSOLE, VTY, AUX LINES
if { $enableThisIsALab == 1 } {
    ios_config "line con 0" "no login"
}
ios_config "line con 0" "logging synchronous" "stopbits 1" "exec-timeout $autoLogoutAfterXMinutes 0" "privilege level 15"
ios_config "line aux 0" "logging synchronous" "stopbits 1" "exec-timeout $autoLogoutAfterXMinutes 0"
ios_config "line vty 0 4" "logging synchronous" "stopbits 1" "exec-timeout $autoLogoutAfterXMinutes 0"
ios_config "line vty 5 15" "logging synchronous" "stopbits 1" "exec-timeout $autoLogoutAfterXMinutes 0"

# ROUTING
if { $enableRouting == 1 } {
    ios_config "ip subnet-zero"
    ios_config "ip classless"
    ios_config "ip routering"
}

# DISABLE WEB SERVER
ios_config "no ip http server"
ios_config "no ip http secure-server"

# CONTROL PLANE
if { $enableRouting == 1 } {
    ios_config "control-plane"
}

# DISABLE LOGGING TO CONSOLE I/O
ios_config "no logging console"
ios_config "logging buffered 40960"
ios_config "logging buffered notifications"
ios_config "password logging"

# STRONG PASSWORD CIPHER
ios_config "password encryption aes"

# ENABLE CDP
ios_config "cdp run"
ios_config "cdp advertise-v2"
ios_config "cdp tlv app"
ios_config "cdp log mismatch duplex"

# CREATE CERT AND SET SSH PARAMS
ios_config "ip domain-name cisco.tld"
ios_config "crypto key generate rsa modulus $sshKeyMinLength"
ios_config "ip ssh logging events"
ios_config "ip ssh version 2"
ios_config "ip ssh dh min size $sshKeyMinLength"
ios_config "ip ssh authentication-retries 3"
ios_config "ip ssh dscp 56"

#
ios_config "service password-encryption"
ios_config "service counters max age 10"
ios_config "ip forward-protocol nd"

#
#
# CCNP Switch lab work BASE.CFG
ip domain-name CCNP.NET
no ip domain lookup
interface range f0/1-24 , g0/1-2
shutdown
exit
vtp mode transparent
line con 0
no exec-timeout
logging synchronous
exit

# Open Certain ports for mgmt purpose
vlan 499
 name vlan499
exit
int vlan499
 ip address "$vlan499ipv4addr"
exit
int ran fa0/19-24
 switchport mode access
 switchport access vlan 499
 cdp enable
 no vtp
 no shut
exit

end
