FROM centos:8

# Set up base packages that are expected
RUN dnf -y install openssh-server crontabs NetworkManager firewalld selinux-policy
RUN systemctl mask dev-mqueue.mount dev-hugepages.mount \
    systemd-remount-fs.service sys-kernel-config.mount \
    sys-kernel-debug.mount sys-fs-fuse-connections.mount \
    graphical.target systemd-logind.service \
    NetworkManager.service systemd-hostnamed.service
STOPSIGNAL SIGRTMIN+3


COPY . /postgres
WORKDIR /postgres

# Install Zabbix repository 
RUN rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
RUN dnf clean all 

# install postgresql
RUN dnf module list postgresql
RUN dnf module enable postgresql:12 -y
RUN dnf install postgresql-server -y
RUN postgresql-setup --initdb

# Give permissions to postgresdb
RUN sed -i 's/local   all             all                                     peer/local   all             all                                     trust/' /var/lib/pgsql/data/pg_hba.conf
RUN sed -i 's/host    all             all             127.0.0.1\/32            ident/host    all             all             127.0.0.1\/32            trust/' /var/lib/pgsql/data/pg_hba.conf
RUN sed -i 's/host    all             all             ::1\/128                 ident/host    all             all             ::1\/128                 trust/' /var/lib/pgsql/data/pg_hba.conf

# Create initial database
RUN systemctl start postgresql
RUN -u postgres createuser zabbix
RUN -u postgres createdb -O zabbix zabbix
RUN zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | RUN -u zabbix psql zabbix
