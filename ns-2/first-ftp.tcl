#============================================================
# This script simulates light TCP traffic for PIE evaluation		     
# Authors: Shravya K.S, Smriti Murali and Mohit P. Tahiliani 
# Wireless Information Networking Group			     
# NITK Surathkal, Mangalore, India
# Tool used: NSG2.1			     
#============================================================

#===================================
#     Simulation parameters setup
#===================================
set val(stop)   100.0                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Open the NS trace file
set tracefile [open first-ftp.tr w]
$ns trace-all $tracefile
	 
#Open the NAM trace file
set namfile [open first-ftp.nam w]
$ns namtrace-all $namfile

#===================================
#	PIE Parameter Settings
#===================================
Queue/PIE set queue_in_bytes_ true
Queue/PIE set a_ 0.125
Queue/PIE set b_ 1.25
Queue/PIE set sUpdate_ 0ms
Queue/PIE set tUpdate_ 30ms
Queue/PIE set dq_threshold_ 10000
Queue/PIE set mean_pktsize_ 1000
Queue/PIE set setbit_ false
Queue/PIE set prob_ 0
Queue/PIE set curq_ 0
Queue/PIE set qd_ 0
Queue/PIE set mark_p_ 0.1
Queue/PIE set use_mark_p_ true
Queue/PIE set qdelay_ref_ 0.02
Queue/PIE set burst_allowance_ 0.1
Queue/PIE set bytes_ true
Queue/PIE set dropcount_ 0

#===================================
#        Nodes Definition        
#===================================
#Create 8 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes
$ns duplex-link $n0 $n5 10.0Mb 5ms DropTail
$ns queue-limit $n0 $n5 50
$ns duplex-link $n1 $n5 10.0Mb 5ms DropTail
$ns queue-limit $n1 $n5 50
$ns duplex-link $n2 $n5 10.0Mb 5ms DropTail
$ns queue-limit $n2 $n5 50
$ns duplex-link $n3 $n5 10.0Mb 5ms DropTail
$ns queue-limit $n3 $n5 50
$ns duplex-link $n4 $n5 10.0Mb 5ms DropTail
$ns queue-limit $n4 $n5 50
$ns duplex-link $n6 $n7 10.0Mb 5ms DropTail
$ns queue-limit $n6 $n7 50
$ns duplex-link $n5 $n6 10.0Mb 50ms PIE
$ns queue-limit $n5 $n6 200

#Give node position (for NAM)
$ns duplex-link-op $n0 $n5 orient right-down
$ns duplex-link-op $n1 $n5 orient right-down
$ns duplex-link-op $n2 $n5 orient right
$ns duplex-link-op $n3 $n5 orient right-up
$ns duplex-link-op $n4 $n5 orient right-up
$ns duplex-link-op $n6 $n7 orient right
$ns duplex-link-op $n5 $n6 orient right

#===================================
#        Agents Definition        
#===================================

Agent/TCP set packetSize_ 1000

#Setup a TCP/Newreno connection
set tcp0 [new Agent/TCP/Newreno]
$ns attach-agent $n0 $tcp0
set sink5 [new Agent/TCPSink]
$ns attach-agent $n7 $sink5
$ns connect $tcp0 $sink5

#Setup a TCP/Newreno connection
set tcp1 [new Agent/TCP/Newreno]
$ns attach-agent $n1 $tcp1
set sink6 [new Agent/TCPSink]
$ns attach-agent $n7 $sink6
$ns connect $tcp1 $sink6

#Setup a TCP/Newreno connection
set tcp2 [new Agent/TCP/Newreno]
$ns attach-agent $n2 $tcp2
set sink7 [new Agent/TCPSink]
$ns attach-agent $n7 $sink7
$ns connect $tcp2 $sink7

#Setup a TCP/Newreno connection
set tcp3 [new Agent/TCP/Newreno]
$ns attach-agent $n3 $tcp3
set sink8 [new Agent/TCPSink]
$ns attach-agent $n7 $sink8
$ns connect $tcp3 $sink8

#Setup a TCP/Newreno connection
set tcp4 [new Agent/TCP/Newreno]
$ns attach-agent $n4 $tcp4
set sink9 [new Agent/TCPSink]
$ns attach-agent $n7 $sink9
$ns connect $tcp4 $sink9

#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP/Newreno connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 0.0 "$ftp0 start"
$ns at 99.0 "$ftp0 stop"

#Setup a FTP Application over TCP/Newreno connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 0.0 "$ftp1 start"
$ns at 99.0 "$ftp1 stop"

#Setup a FTP Application over TCP/Newreno connection
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns at 0.0 "$ftp2 start"
$ns at 99.0 "$ftp2 stop"

#Setup a FTP Application over TCP/Newreno connection
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$ns at 0.0 "$ftp3 start"
$ns at 99.0 "$ftp3 stop"

#Setup a FTP Application over TCP/Newreno connection
set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp4
$ns at 0.0 "$ftp4 start"
$ns at 99.0 "$ftp4 stop"

set trace_file_main tmp-main-first-ftp.tr
set trace_file_pie tmp-pie-first-ftp.tr

$ns trace-queue $n5 $n6 [open $trace_file_main w]
set pie [[$ns link $n5 $n6] queue]
$pie trace curq_ 
$pie trace prob_
$pie trace qd_
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
    exec nam first-ftp.nam &
    exit 0
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
