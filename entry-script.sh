#!/bin/bash
sudo yum install httpd-* -y
sleep 1
sudo yum install mod_ssl* -y
sudo systemctl start httpd.service
sleep 1
sudo systemctl enable httpd.service
sleep 3

echo "<h1>Deployed via Terraform with ELB</h1>" | sudo tee /var/www/html/index.html
sudo yum install wget -y
sudo wget https://dl.grafana.com/oss/release/grafana-7.4.5-1.x86_64.rpm
sudo yum install grafana-7.4.5-1.x86_64.rpm -y
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
#sudo service grafana-server start
#sudo service grafana-server enable

sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
cd /etc/yum.repos.d/
sudo touch elastic.repo
echo '[elastic-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md' | sudo tee -a  /etc/yum.repos.d/elastic.repo
sleep 2
cd -
sudo yum install metricbeat -y
sleep 1
sudo systemctl enable metricbeat
sudo systemctl start metricbeat
sleep 2
#sudo systemctl status httpd.service
#sudo systemctl status metricbeat