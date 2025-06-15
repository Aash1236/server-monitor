#!/usr/bin/env bash

source ./utils.sh
check_cpu
check_mem
check_disk
check_docker_stats


echo "# HELP cpu_usage CPU Usage"
echo "# TYPE cpu_usage gauge"
echo "cpu_usage $CPU_USAGE"

echo "# HELP memory_usage Memory Usage"
echo "# TYPE memory_usage gauge"
echo "memory_usage $MEM_USAGE"
