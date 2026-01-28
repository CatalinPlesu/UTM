#!/bin/bash

# Function to print the current time in red
print_red_time() {
    echo -e "\e[31m$(date '+%H:%M:%S')\e[0m"
}

# Start background timer that prints the time every 30 seconds
while true; do
    print_red_time
    sleep 30
done &
TIMER_PID=$!

# Run your MPI program
mpirun --hostfile available_hosts_file lab1_openmpi 4

# Kill the timer process when mpirun completes
kill $TIMER_PID
