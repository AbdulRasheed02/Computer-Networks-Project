#Example of Wireless networks
#Step 1 initialize variables
#Step 2 - Create a Simulator object
#step 3 - Create Tracing and animation file
#step 4 - topography
#step 5 - GOD - General Operations Director
#step 6 - Create nodes
#Step 7 - Create Channel (Communication PATH)
#step 8 - Position of the nodes (Wireless nodes needs a location)
#step 9 - Any mobility codes (if the nodes are moving)
#step 10 - TCP, UDP Traffic
#run the simulation

#Test Number
set testNo 0

#Varying Parameters
#max bound on window size;
Agent/TCP set window_   20
#packet size used by sender (bytes);             
Agent/TCP set packetSize_ 1000

#bound on Retransmission timeout (seconds);
Agent/TCP set windowOption_ 1               

#initialize the variables
set val(chan)           Channel/WirelessChannel    ;#Channel Type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy/802_15_4            ;# network interface type WAVELAN DSSS 2.4GHz
set val(mac)            Mac/802_15_4                  ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         500                         ;# max packet in ifq
set val(nn)             7                          ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol
set val(x) 200   ;# in metres
set val(y)  100   ;# in metres
#Adhoc OnDemand Distance Vector

#creation of Simulator
set ns [new Simulator]

$ns color 0 Red

#creation of Trace and namfile 
set tracefile [open traceFile.tr w]
$ns trace-all $tracefile

#Creation of Network Animation file
set namfile [open namFile.nam w]
$ns namtrace-all-wireless $namfile $val(x) $val(y)

#create topography
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

#GOD Creation - General Operations Director
create-god $val(nn)

set channel1 [new $val(chan)]

#configure the node
$ns node-config -adhocRouting $val(rp) \
  -llType $val(ll) \
  -macType $val(mac) \
  -ifqType $val(ifq) \
  -ifqLen $val(ifqlen) \
  -antType $val(ant) \
  -propType $val(prop) \
  -phyType $val(netif) \
  -topoInstance $topo \
  -agentTrace ON \
  -macTrace ON \
  -routerTrace ON \
  -movementTrace ON \
  -channel $channel1

for {set i 0} {$i < 7} { incr i } {
  set n($i) [$ns node]
	$n($i) random-motion 0
}

#Radius
set r 100.0

# Position of Sink
$n(0) set X_ 20.0
$n(0) set Y_ 20.0
$n(0) set Z_ 0.0
$n(0) label "Sink"

#Position of Source
$n(1) set X_ [ expr {$r * 0.5} ]
$n(1) set Y_ [ expr {$r * 0.86} ]
$n(1) label "Source"
$n(2) set X_ [ expr {$r * -0.5} ]
$n(2) set Y_ [ expr {$r * 0.86} ]
$n(2) label "Source"
$n(3) set X_ [ expr {$r * -1} ]
$n(3) set Y_ [ expr {$r * 0} ]
$n(3) label "Source"
$n(4) set X_ [ expr {$r * -0.5} ]
$n(4) set Y_ [ expr {$r * -0.86} ]
$n(4) label "Source"
$n(5) set X_ [ expr {$r * 0.5} ]
$n(5) set Y_ [ expr {$r * -0.86} ]
$n(5) label "Source"
$n(6) set X_ [ expr {$r * 1} ]
$n(6) set Y_ [ expr {$r * 0} ]
$n(6) label "Source"

for {set i 1} {$i < 7 } { incr i } {
	$n($i) set Z_ 0
}

for {set i 0} {$i < 7} { incr i } {
	$ns initial_node_pos $n($i) 10
}

#creation of agents
for {set i 1} {$i < 7} {incr i} {
    
    #TCP Connection
    #Setup a TCP connection
    set tcp($i) [new Agent/TCP]
    $ns attach-agent $n($i) $tcp($i)
	  $tcp($i) set class_ 2

    set sink($i) [new Agent/TCPSink]
    $ns attach-agent $n(0) $sink($i)
    $ns connect $tcp($i) $sink($i)
    #$tcp($i) set fid_ $i

    #Setup a FTP over TCP connection
    set ftp($i) [new Application/FTP]
    $ftp($i) attach-agent $tcp($i)
    $ftp($i) set type_ FTP

    # #UDP Connection
    # set udp($i) [new Agent/UDP]
    # set null [new Agent/Null]
    # $ns attach-agent $n(0) $null
    # $ns attach-agent $n($i) $udp($i)
    # $ns connect $udp($i) $null
    # set cbr($i) [new Application/Traffic/CBR]
    # $cbr($i) attach-agent $udp($i)

}

proc finish {} {
  global ns tracefile namfile testNo
  $ns flush-trace
  close $tracefile
  close $namfile
  exec nam namFile.nam &
  exec awk -f awkFiles/pdr.awk traceFile.tr > outputFiles/output_${testNo} &
  exec awk -f awkFiles/throughput.awk traceFile.tr >> outputFiles/output_${testNo} &
  exec awk -f awkFiles/pDropped.awk traceFile.tr >> outputFiles/output_${testNo} &
  exec awk -f awkFiles/e2edelay.awk traceFile.tr >> outputFiles/output_${testNo} &
  exit 0
}

for {set i 1} {$i < 7} {incr i} {
	$ns at 0.0 "$ftp($i) start"
}

for {set i 1} {$i < 7} {incr i} {
	$ns at 50.0 "$ftp($i) stop"
}

$ns at 50.0 "finish"

puts "Starting Simulation"
$ns run