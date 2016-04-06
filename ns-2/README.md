# Steps to reproduce ns-2 results of PIE paper

Step 1: Install ns-allinone-2.36.rc1 (Download link: http://www.isi.edu/nsnam/dist/release/rc1/ns-allinone-2.36.rc1.tar.gz)

Step 2: Copy "pie.h" and "pie.cc" from this directory and paste them in ns-allinone-2.36.rc1/ns-2.36.rc1/queue. This will overwrite the existing PIE files.

Step 3: Recompile ns-2

Step 4: Run TCL scripts given in this directory to reproduce the results.

Details about the TCL scripts are as follows:

first-ftp.tcl - simulates light TCP traffic

second-ftp.tcl - simulates heavy TCP traffic

third-mix.tcl - simulates mix TCP and UDP traffic

fourth-cbr.tcl - simulates one UDP flow (max burst = 0ms)

fifth-cbr.tcl - simulates one UDP flow (max burst = 100ms)
