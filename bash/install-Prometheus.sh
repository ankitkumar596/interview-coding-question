#!/usr/bin/env bash

# Set default values
UNINSTALL=false

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --uninstall)
      UNINSTALL=true
      shift
      ;;
    *)
      shift
      ;;
  esac
done

# Function to install Prometheus
install_prometheus() {
  echo "Starting Prometheus installation..."

  # Update the system
  sudo yum update -y

  # Download and extract Prometheus
  curl -LO https://github.com/prometheus/prometheus/releases/download/v2.22.0/prometheus-2.22.0.linux-amd64.tar.gz
  tar -xvf prometheus-2.22.0.linux-amd64.tar.gz
  mv prometheus-2.22.0.linux-amd64 prometheus-files

  # Create a Prometheus user
  sudo useradd --no-create-home --shell /bin/false prometheus

  # Create necessary directories
  sudo mkdir /etc/prometheus
  sudo mkdir /var/lib/prometheus
  sudo chown prometheus:prometheus /etc/prometheus
  sudo chown prometheus:prometheus /var/lib/prometheus

  # Copy binaries to /usr/local/bin
  sudo cp prometheus-files/prometheus /usr/local/bin/
  sudo cp prometheus-files/promtool /usr/local/bin/
  sudo chown prometheus:prometheus /usr/local/bin/prometheus
  sudo chown prometheus:prometheus /usr/local/bin/promtool

  # Copy console files to /etc/prometheus
  sudo cp -r prometheus-files/consoles /etc/prometheus
  sudo cp -r prometheus-files/console_libraries /etc/prometheus
  sudo chown -R prometheus:prometheus /etc/prometheus/consoles
  sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

  # Create Prometheus config file
  cat <<EOL | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
EOL

  sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

  # Create systemd service file for Prometheus
  cat <<EOL | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOL

  # Reload systemd and start Prometheus service
  sudo systemctl daemon-reload
  sudo systemctl start prometheus
  sudo systemctl enable prometheus

  echo "Prometheus installation completed."
}

# Function to uninstall Prometheus
uninstall_prometheus() {
  echo "Starting Prometheus uninstallation..."

  # Stop the Prometheus service
  sudo systemctl stop prometheus

  # Disable Prometheus service from starting on boot
  sudo systemctl disable prometheus

  # Remove systemd service file
  sudo rm -f /etc/systemd/system/prometheus.service

  # Remove Prometheus binaries
  sudo rm -f /usr/local/bin/prometheus
  sudo rm -f /usr/local/bin/promtool

  # Remove Prometheus directories and files
  sudo rm -rf /etc/prometheus
  sudo rm -rf /var/lib/prometheus

  # Remove the Prometheus user
  sudo userdel prometheus

  echo "Prometheus uninstallation completed."
}

# Perform installation or uninstallation based on argument
if [ "$UNINSTALL" = true ]; then
  uninstall_prometheus
else
  install_prometheus
fi
