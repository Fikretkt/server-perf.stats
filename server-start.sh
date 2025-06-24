#!/bin/bash

# =======================
# Server Performance Stats
# =======================

echo "====================================="
echo "📊 Server Performance Statistics"
echo "====================================="

# OS and Uptime Information (Stretch Goal)
echo -e "\n🖥️  OS Version: $(cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f2 | tr -d '\"')"
echo "⏱️  Uptime: $(uptime -p)"
echo "📈 Load Average: $(uptime | awk -F'load average: ' '{print $2}')"
echo "👤 Logged In Users: $(who | wc -l)"

# CPU Usage
echo -e "\n🔥 CPU Usage:"
top -bn1 | grep "%Cpu(s)" | \
  awk '{printf "   User: %.1f%%, System: %.1f%%, Idle: %.1f%%\n", $2, $4, $8}'

# Memory Usage
echo -e "\n🧠 Memory Usage:"
free -m | awk 'NR==2 {
    total=$2; used=$3; free=$4;
    printf "   Total: %d MB, Used: %d MB, Free: %d MB (%.1f%% Used)\n", total, used, free, used/total*100
}'

# Disk Usage
echo -e "\n💾 Disk Usage (Root '/'):"
df -h / | awk 'NR==2 {
    printf "   Total: %s, Used: %s, Available: %s (Used: %s)\n", $2, $3, $4, $5
}'

# Top 5 processes by CPU usage
echo -e "\n🔝 Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6 | awk '{printf "   PID: %s  CMD: %-20s CPU: %s%% MEM: %s%%\n", $1, $2, $3, $4}'

# Top 5 processes by Memory usage
echo -e "\n🧠 Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6 | awk '{printf "   PID: %s  CMD: %-20s CPU: %s%% MEM: %s%%\n", $1, $2, $3, $4}'

# Stretch Goal: Failed Login Attempts (last 24h, needs root for full logs)
echo -e "\n🔐 Failed SSH Login Attempts (last 24h):"
grep "Failed password" /var/log/auth.log 2>/dev/null | grep "$(date --date='1 day ago' '+%b %e')" | wc -l || echo "   Unable to access /var/log/auth.log"

echo -e "\n✅ Report generated on: $(date)"
echo "====================================="

