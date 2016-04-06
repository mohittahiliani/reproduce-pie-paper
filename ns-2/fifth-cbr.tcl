#==================================================================================
# This script simulates a bursty UDP traffic for PIE evaluation (max burst = 100ms)		     
# Authors: Shravya K.S, Smriti Murali and Mohit P. Tahiliani 
# Wireless Information Networking Group (WiNG)			     
# NITK Surathkal, Mangalore, India
# Tool used: NSG2.1			     
#==================================================================================

#===================================
#     Simulation parameters setup
#===================================
set val(stop)   1.2                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

set tracefile [open fifth-cbr.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open fifth-cbr.nam w]
$ns namtrace-all $namfile

#===================================
#	PIE Parameter Settings
#===================================
Queue/PIE set queue_in_bytes_ false
Queue/PIE set a_ 0.125
Queue/PIE set b_ 1.25
Queue/PIE set sUpdate_ 0ms
Queue/PIE set tUpdate_ 30ms
Queue/PIE set dq_threshold_ 10000
Queue/PIE set mean_pktsize_ 1000
Queue/PIE set setbit_ false
Queue/PIE set prob_ 0
Queue/PIE set curq_ 0
Queue/PIE set mark_p_ 0.1
Queue/PIE set use_mark_p_ true
Queue/PIE set qdelay_ref_ 0.02
Queue/PIE set burst_allowance_ 0.1
Queue/PIE set bytes_ true
Queue/PIE set qd_ 0
Queue/PIE set dropcount_ 0

#===================================
#        Nodes Definition        
#===================================
#Create 8 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes
$ns duplex-link $n0 $n1 50.0Mb 5ms DropTail
$ns queue-limit $n0 $n1 50
$ns duplex-link $n2 $n3 50.0Mb 5ms DropTail
$ns queue-limit $n2 $n3 50
$ns duplex-link $n1 $n2 10.0Mb 50ms PIE
$ns queue-limit $n1 $n2 100

#Give node position (for NAM)
$ns duplex-link-op $n0 $n1 orient right-down
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient right-up

#===================================
#        Agents Definition        
#===================================
#Setup a UDP connection
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0
$ns connect $udp0 $null0

#===================================
#        Applications Definition        
#===================================
#Setup a CBR Application over UDP connection
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 25.0Mb
$ns at 1.0 "$cbr0 start"
$ns at 1.2 "$cbr0 stop"

set trace_file_main tmp-fifth-cbr.tr
set trace_file_pie tmp-pie-fifth-cbr.tr
$ns trace-queue $n1 $n2 [open $trace_file_main w]
set pie [[$ns link $n1 $n2] queue]
$pie trace curq_
$pie trace prob_
$pie trace dropcount_
$pie attach [open $trace_file_pie w]

#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam fifth-cbr.nam &
    exit 0
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
