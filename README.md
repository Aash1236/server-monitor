
# 🚀 Advanced Linux Server Monitoring System

> A full-featured Linux shell scripting project that monitors system health, Docker containers, sends Slack alerts, exports Prometheus metrics for Grafana, and implements a Jenkins CI/CD pipeline.

---

## 📌 Project Overview

This project is designed for Linux systems to monitor:

- 🧠 CPU usage  
- 🧮 Memory consumption  
- 💽 Disk usage  
- 🐳 Docker container metrics  

It sends alerts via Slack if thresholds are breached, generates Prometheus-compatible metrics for Grafana dashboards, supports dry-runs, and automates deployment using a Jenkins CI/CD pipeline. Everything is written using advanced Bash scripting practices.

---

## ✅ Features

- 🔍 Real-time system health monitoring (CPU, RAM, Disk)
- 🐳 Docker container monitoring
- 📡 Slack Webhook integration for alerts
- 📈 Prometheus-compatible metric output
- 🧪 Dry-run mode for safe testing
- 🛠️ Jenkins Pipeline for full CI/CD automation
- 🕒 Cron-compatible for automated execution
- 📦 Clean, modular and production-ready script architecture

---

## 📁 Project Structure

```bash
server-monitor/
├── monitor.sh               # Main monitoring script
├── docker_monitor.sh        # Docker container metrics script
├── prometheus_exporter.sh   # Prometheus metrics exporter
├── slack_alert.sh           # Slack Webhook integration
├── jenkins-pipeline.groovy  # Jenkins CI/CD configuration
├── README.md                # Full documentation
```

---

## ▶️ Usage Instructions

### 🔧 Manual Execution

```bash
./monitor.sh
```

### 🧪 Dry Run Mode

```bash
./monitor.sh --dry-run
```

### 🕒 Schedule via Cron (Every 5 Minutes)

Edit your crontab:

```bash
crontab -e
```

Add the following line:

```cron
*/5 * * * * /path/to/server-monitor/monitor.sh >> /var/log/server-monitor.log 2>&1
```

---

## 📊 Sample Output

```bash
===== Health Summary (2025-06-15) =====
CPU Usage   : 100%
Memory Usage: 5%
Disk Usage  : 1%

Top 5 Processes:
    PID    PPID CMD                         %MEM %CPU
    297       1 /usr/bin/dockerd -H fd:// -  0.5  0.2
    254       1 /usr/bin/containerd          0.3  0.0
    122       1 snapfuse /var/lib/snapd/sna  0.0  0.0
      1       0 /sbin/init                   0.0  0.0
    212       1 /usr/lib/snapd/snapd         0.3  0.0

Docker Container Stats:
NAME             CPU %     MEM USAGE / LIMIT
test-container   0.00%     7.148MiB / 14.61GiB
```

---

## 📡 Slack Webhook Alert

When thresholds are breached, a Slack message like below is sent:

```bash
🚨 [ALERT] Server Health Degradation Detected

===== Health Summary (2025-06-15) =====
CPU Usage   : 100%
Memory Usage: 5%
Disk Usage  : 1%

Top 5 Processes:
    PID    PPID CMD                         %MEM %CPU
    297       1 /usr/bin/dockerd -H fd:// -  0.5  0.2
    254       1 /usr/bin/containerd          0.3  0.0
    122       1 snapfuse /var/lib/snapd/sna  0.0  0.0
      1       0 /sbin/init                   0.0  0.0
    212       1 /usr/lib/snapd/snapd         0.3  0.0

Docker Container Stats:
NAME             CPU %     MEM USAGE / LIMIT
test-container   0.00%     7.148MiB / 14.61GiB

📅 Timestamp: 2025-06-15T14:22:08Z
```

---

## 📈 Prometheus Metrics Output

Prometheus-compatible output is generated to be scraped by Prometheus:

```bash
# HELP cpu_usage CPU usage
# TYPE cpu_usage gauge
cpu_usage 100

# HELP memory_usage Memory usage
# TYPE memory_usage gauge
memory_usage 5

# HELP disk_usage Disk usage
# TYPE disk_usage gauge
disk_usage 1
```

Make sure this output is exposed via an HTTP server on a known port like 9100 for Prometheus scraping.

---

## ⚙️ Prometheus Configuration

Add the following in your Prometheus config file:

```yaml
scrape_configs:
  - job_name: 'server-monitor'
    static_configs:
      - targets: ['localhost:9100']
```

Restart Prometheus after changes.

---

## 📊 Grafana Dashboard Setup

1. Add Prometheus as a data source in Grafana.
2. Create a new dashboard.
3. Add panels for:
   - `cpu_usage`
   - `memory_usage`
   - `disk_usage`
4. Set refresh to 5s or as needed.
5. Customize with thresholds, colors, and alerts.

---

## 🔄 CI/CD Setup with Jenkins

This project supports integration with Jenkins for complete automation:

- Lint scripts with ShellCheck
- Run in dry-run mode
- Export metrics to Node Exporter directory
- Deploy updated scripts to target systems

Make sure:

- Jenkins has permission to run scripts
- Docker and shellcheck are installed on Jenkins agent
- `rsync` or `scp` is available for deployment step

Trigger builds via:

- Webhook (push)
- Scheduled (cron trigger)

---

## 🧱 Requirements

Install the following on your server before starting:

```bash
sudo apt update && sudo apt install -y \
    curl docker.io python3 shellcheck rsync
```

Start Docker:

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

Give execute permission to scripts:

```bash
chmod +x *.sh
```

---

## 🔐 Security Best Practices

- 🛑 Do **not** commit your Slack Webhook URL to Git
- ✅ Run scripts as a user with restricted privileges
- 🔐 Protect Prometheus exporters behind a reverse proxy with authentication
- 🧯 Monitor logs regularly and use fail2ban for brute-force protection

---

## 💻 GitHub Setup (Push from Linux)

### Create SSH Key (if not already created)

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Add the public key (`~/.ssh/id_ed25519.pub`) to your GitHub [SSH Keys](https://github.com/settings/keys)

### Clone & Push Project

```bash
git clone git@github.com:yourusername/server-monitor.git
cd server-monitor
git add .
git commit -m "Initial commit"
git push -u origin main
```

---

## 👨‍💻 Author

**Ashutosh Fase**  
📍 Mumbai, India  
🔗 [LinkedIn](https://linkedin.com/in/ashutosh-fase)

---

## 📝 License

Licensed under the [MIT License](LICENSE)

---

> 🧠 _“Monitor smart. Alert fast. Visualize beautifully.”_

