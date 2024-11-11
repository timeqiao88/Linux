#!/bin/bash

# Define the threshold values for CPU, memory, and disk usage (in percentage)
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
# Function to send an alert
send_alert() {
  echo "$(tput setaf 1)ALERT: $1 exceeded threshold! Current value: $2%$(tput sgr0)"
  # You can add your own logic here to send an email or notification to the user
}
# Main function to monitor system resources
monitor_system() {
  while true; do
    # Get CPU usage percentage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    cpu_usage=${cpu_usage%.*} # Convert to integer

    # Get memory usage percentage
    memory_usage=$(free | awk '/Mem/ {printf("%3.1f", ($3/$2) * 100)}')

    # Get disk usage percentage of the root directory
    disk_usage=$(df -h / | awk '/\// {print $(NF-1)}')
    disk_usage=${disk_usage%?} # Remove the % sign

    # Check if any threshold is exceeded
    if ((cpu_usage >= CPU_THRESHOLD)); then
      send_alert "CPU" "$cpu_usage"
    fi

    if ((memory_usage >= MEMORY_THRESHOLD)); then
      send_alert "Memory" "$memory_usage"
    fi

    if ((disk_usage >= DISK_THRESHOLD)); then
      send_alert "Disk Usage" "$disk_usage"
    fi

    # Format and display the output
    clear
    printf "%-15s %s\n" "Resource" "Usage (%)"
    echo "----------------------"
    printf "%-15s %s\n" "CPU Usage" "$cpu_usage"
    printf "%-15s %s\n" "Memory Usage" "$memory_usage"
    printf "%-15s %s\n" "Disk Usage" "$disk_usage"

    sleep 1 # Adjust the interval as per your preference
  done
}
