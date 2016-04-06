# Steps to reproduce ns-3 results of PIE paper

Step 1: Install ns-3.24 (Clone it from: http://code.nsnam.org/ns-3.24)

Step 2: Copy "pie-queue.h" and "pie-queue.cc" from this directory and paste them in ns-3.24/src/network/utils

Step 3: Copy "pie-queue-test-suite.cc" from this directory and paste it in ns-3.24/src/network/test

Step 4: Copy "wscript" from this directory and paste it in ns-3.24/src/network/ (it will overwrite the existing one)

Step 5: Recompile ns-3

Step 6: Run programs given in this directory to reproduce the results.

Details about the programs are as follows:

first-bulksend.cc - simulates light TCP traffic

second-bulksend.cc - simulates heavy TCP traffic

third-mix.cc - simulates mix TCP and UDP traffic

fourth-onoff.cc - simulates one UDP flow (max burst = 0ms)

fifth-onoff.cc - simulates one UDP flow (max burst = 100ms)
