FROM centos:8
COPY . /zabbix
WORKDIR /zabbix
ARG DBHost=localhost

## Install Zabbix server, sed
RUN chmod +x zabbix-pgsql.sh
ENTRYPOINT [ "zabbix-pgsql.sh" ]

# config zabbix-server host and password
RUN sudo sed -i "s/# DBHost=localhost/# DBhost=localhost\n\nDBHost=${DBHost}/" /etc/zabbix/zabbix_server.conf
RUN sudo sed -i 's/# DBPassword=/# DBPassword=\n\nDBPassword=zabbix/' /etc/zabbix/zabbix_server.conf

# SELinux configuration
RUN sudo setsebool -P httpd_can_connect_zabbix on
RUN sudo setsebool -P httpd_can_network_connect_db on

#change selinux from enforce to permissive
RUN sudo setenforce 0
RUN sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/'  /etc/selinux/config

# Start Zabbix server 
RUN sudo systemctl restart zabbix-server
RUN sudo systemctl enable zabbix-server 
