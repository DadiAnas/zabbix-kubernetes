FROM ubuntu:20.04

COPY . /postgres
WORKDIR /postgres

RUN apt update && apt upgrade
RUN apt install wget -y
# Install Zabbix repository 
RUN wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb
RUN dpkg -i zabbix-release_5.0-1+focal_all.deb
RUN apt update 

# install postgresql
RUN apt install postgresql postgresql-contrib -y 

RUN -u postgres createuser zabbix
RUN -u postgres createdb -O zabbix zabbix 
RUN zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | RUN -u zabbix psql zabbix 
