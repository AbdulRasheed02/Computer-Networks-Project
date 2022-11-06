#Create a simulator object
set ns [new Simulator]

#Define different colors for data flows (for NAM)
$ns color 0 Blue
$ns color 1 Red
$ns color 3 green
$ns color 4 cyan
$ns color 5 yellow
$ns color 6 orange

#Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

set all_trace [open all.tr w]
$ns trace-all $all_trace

#Number of Nodes
set N 7

#Define a 'finish' procedure
proc finish {} {
    global ns nf all_trace traffic
    $ns flush-trace
    #Close the trace file
    close $nf
    close $all_trace
    #Execute nam on the trace file
    exec nam out.nam &
	exit 0
}

for {set i 0} {$i < $N} {incr i} {
	set n($i) [$ns node]
}

for {set i 1} {$i < $N} {incr i} {
	$ns duplex-link $n($i) $n(0) 1Mb 10ms DropTail
	$ns queue-limit $n($i) $n(0) 20
	#$ns simplex-link-op $n($i) $n(0) orient right
}


for {set i 1} {$i < $N} {incr i} {

	#Setup a TCP connection
	set tcp($i) [new Agent/TCP]
	$ns attach-agent $n($i) $tcp($i)
	$tcp($i) set class_ 2

	set sink($i) [new Agent/TCPSink]
	$ns attach-agent $n(0) $sink($i)
	$ns connect $tcp($i) $sink($i)
	$tcp($i) set fid_ $i

	#Setup a FTP over TCP connection
	set ftp($i) [new Application/FTP]
	$ftp($i) attach-agent $tcp($i)
	$ftp($i) set type_ FTP

}


for {set i 1} {$i < $N} {incr i} {
	$ns at 0.0 "$ftp($i) start"
	
}
for {set i 1} {$i < $N} {incr i} {
	$ns at 50.0 "$ftp($i) stop"
}

$ns at 50.0 "finish"
#Run the simulation
$ns run