#
#### CONFIG VRF 'Internet' IN BGP
#

foreach cmd {
	"rd 42525:42525"
	"route-target export 42525:42525"
	"route-target import 42525:42525"
} {
	ios_config "vrf definition Internet" $cmd
}
