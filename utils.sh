#!/usr/bin/env bash

check_cpu() {
    export CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)
}

check_mem() {
    MEM_USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')
}

check_disk() {
    DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
}

check_top_processes() {
    TOP_PROCESSES=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6)
}
check_docker_stats() {
  local stats
  stats=$(docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" 2>/dev/null)

  if [[ -z "$stats" ]]; then
    DOCKER_STATS="No active containers running."
  else
    DOCKER_STATS="$stats"
  fi
}

