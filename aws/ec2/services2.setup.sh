# Amazon AWS(VPC)
# Ubuntu 14.04
# R3.large
# perseidsservices.pem
# assign services2.perseids.org to instance in Route 53
# security group: perseids-services
ssh -i ~/.ssh/perseidsservices.pem ubuntu@services2.perseids.org
sudo hostname services.perseids.org
vi /etc/hostname - edit to services.perseids.org
sudo apt-get update
sudo apt-get install tomcat6
sudo apt-get install tomcat6-admin
sudo vi /var/lib/tomcat6/conf/tomcat-users.xml
# insert
# <user username="admin" password="PASSWORD" roles="manager-script,manager-gui"/>
sudo vi /etc/tomcat6
# add XmX Xms MaxPerm settings to catalina_sh
# JAVA_OPTS="-Djava.awt.headless=true -Xmx12288m -Xms12288m -XX:MaxPermSize=1024m"


sudo apt-get install apache2
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod headers
sudo service apache2 restart
sudo apt-get install postgresql

sudo su postgres
psql
create user prometheus with password 'admin';
alter user prometheus with createdb;
\q
exit
cd /etc/postgresql/9.3/main
sudo vi pg_hba.conf
# insert 
# IPv4 local connections:
#host    all             all             10.0.0.0/16            md5
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

#Header set Access-Control-Allow-Origin "*"
#Header set Access-Control-Allow-Headers: "Origin, X-Requested-With, Content-Type, Accept"


