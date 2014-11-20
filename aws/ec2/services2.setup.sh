# Amazon AWS(VPC)
# Ubuntu 14.04
# R3.large
# security group: perseids-services
ssh -i ~/.ssh/perseidsservices.pem ubuntu@services2.perseids.org
sudo hostname services.perseids.org
vi /etc/hostname - edit to services.perseids.org
sudo apt-get update
sudo apt-get install apache2
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod headers
sudo service apache2 restart
sudo apt-get install postgresql
sudo apt-get install tomcat6
sudo apt-get install tomcat6-admin

# Setup Tomcat
sudo vi /var/lib/tomcat6/conf/tomcat-users.xml
# insert user from github.com/PerseusDL/perseids_private_config/aws/services2/tomcat-users.xml
sudo vi /etc/tomcat6
# add XmX Xms MaxPerm settings to catalina_sh - should be done in an env setting
# JAVA_OPTS="-Djava.awt.headless=true -Xmx12288m -Xms12288m -XX:MaxPermSize=1024m"


# Setup Postgres
sudo su postgres
psql
create user prometheus with password 'admin';
alter user prometheus with createdb;
\q
exit
cd /etc/postgresql/9.3/main
sudo vi pg_hba.conf
# insert IPv4 local connections:
#host    all             all             10.0.0.0/16            md5
#host    all             all             10.0.0.0/16            md5
# insert IPv4 host connections for services.perseids.org
# services.perseids.org
#host    all             all             54.208.196.174/32       md5
# services-rep.perseids.org
#host    all             all             54.173.152.119/32       md5

sudo vi postgresql.conf
# add listen_addresses = '*'
sudo service postgresql restart

# edit apache conf to proxy tomcat and setup CORS
vi /etc/apache2/conf-enabled/tomcat.conf
# insert
# ProxyPass /llt http://localhost:8080/llt
# ProxyPassReverse /llt http://localhost:8080/llt
# ProxyPass /cite_mapper http://localhost:8080/cite_mapper
# ProxyPassReverse /cite_mapper http://localhost:8080/cite_mapper
# ProxyPass /sg http://localhost:8080/sg
# ProxyPassReverse /sg http://localhost:8080/sg
# ProxyPass /ccm http://localhost:8080/cite-collection-manager-0.0.1
# ProxyPassReverse /ccm http://localhost:8080/cite-collection-manager-0.0.1
# ProxyPass /collections http://localhost:8080/citefusioncoll-0.2.0
# ProxyPassReverse /collections http://localhost:8080/citefusioncoll-0.2.0
#Header set Access-Control-Allow-Origin "*"
#Header set Access-Control-Allow-Headers: "Origin, X-Requested-With, Content-Type, Accept"


