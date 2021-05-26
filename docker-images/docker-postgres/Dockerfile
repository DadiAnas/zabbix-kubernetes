FROM postgres:latest

COPY . /postgres
WORKDIR /postgres

ENV POSTGRES_PASSWORD=zabbix

# Install Zabbix repository 
RUN wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb && \
    dpkg -i zabbix-release_5.0-1+focal_all.deb && \
    apt update && \
    -u postgres createuser zabbix && \
    -u postgres createdb -O zabbix zabbix && \
    zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | RUN -u zabbix psql zabbix 

EXPOSE 3306/TCP