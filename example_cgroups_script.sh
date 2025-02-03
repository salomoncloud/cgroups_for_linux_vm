#!/bin/bash
# This script demonstrates creating and configuring cgroups for CPU and memory limits.
# It then runs a sample command (e.g., 'stress') within these constraints.

# Ensure the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

# Base directories for cgroups (adjust if your distribution mounts these elsewhere)
CGROUP_BASE="/sys/fs/cgroup"
CGROUP_CPU="$CGROUP_BASE/cpu/my_cgroup"
CGROUP_MEM="$CGROUP_BASE/memory/my_cgroup"

# Create cgroup directories if they don't already exist
[ ! -d "$CGROUP_CPU" ] && mkdir "$CGROUP_CPU"
[ ! -d "$CGROUP_MEM" ] && mkdir "$CGROUP_MEM"

# Configure CPU limits:
# The default cpu.shares is typically 1024; a lower value gives the group less CPU relative to others.
echo "Setting CPU shares to 512"
echo 512 > "$CGROUP_CPU/cpu.shares"

# Configure Memory limits:
# Set a memory limit (in bytes). For example, 256 MB.
MEM_LIMIT=$((256 * 1024 * 1024))
echo "Setting memory limit to ${MEM_LIMIT} bytes"
echo $MEM_LIMIT > "$CGROUP_MEM/memory.limit_in_bytes"

# Start a sample process.
# Here we use 'stress' to simulate load (make sure it is installed, or replace with another command).
# This process will run for 60 seconds.
echo "Starting sample process 'stress --cpu 1 --timeout 60'"
stress --cpu 1 --timeout 60 &
PID=$!
echo "Process started with PID: $PID"

# Add the process to the CPU and Memory cgroups by writing its PID to the tasks files.
echo "Adding process $PID to the CPU cgroup"
echo $PID > "$CGROUP_CPU/tasks"

echo "Adding process $PID to the Memory cgroup"
echo $PID > "$CGROUP_MEM/tasks"

echo "Process $PID is now limited to 512 CPU shares and ${MEM_LIMIT} bytes of memory."
