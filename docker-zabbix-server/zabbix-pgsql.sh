# Install Zabbix repository 
sudo rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
sudo dnf clean all 

# Install Zabbix server, frontend, agent 
sudo dnf install zabbix-server-pgsql sed -y

