FROM centos:8
COPY . /zabbix
WORKDIR /zabbix
ARG DBHost=localhost

## Install Zabbix server, sed
#RUN chmod +x zabbix-pgsql.sh
#ENTRYPOINT [ "./zabbix-pgsql.sh" ]
# Install Zabbix repository 
RUN rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
RUN dnf clean all 

# Install Zabbix server, sed
RUN dnf install zabbix-server-pgsql sed -y

# config zabbix-server host and password
RUN sed -i "s/# DBHost=localhost/# DBhost=localhost\n\nDBHost=${DBHost}/" /etc/zabbix/zabbix_server.conf
RUN sed -i 's/# DBPassword=/# DBPassword=\n\nDBPassword=zabbix/' /etc/zabbix/zabbix_server.conf

# Start Zabbix server 
RUN service zabbix-server restart
RUN service zabbix-server enable
