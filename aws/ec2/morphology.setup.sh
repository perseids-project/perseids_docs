#!/usr/bin/env bash
# pseudo provisioning script
# for an Ubuntu 14.04 box

### 1. INSTALL DEPENDENCIES FOR MORPHEUS AND MORPHEUS WRAPPER
apt-get update
apt-get install git-core
apt-get install libapache2-mod-perl2
apt-get install unzip
apt-get install make
apt-get install gcc
apt-get install flex
a2enmod proxy
a2enmod proxy_http


### 2. CREATE DIRECTORY TO HOLD SOURCE AND BINARIES 
mkdir /usr/local/morph

### 3. INSTALL ALPHEIOS BINARIES OF MORPHEUS
cd /usr/local/morph
git clone https://github.com/alpheios-project/morpheus.git alpheios-morpheus

### 4. GET PERSEUS VERSION OF MORPHEUS SOURCE CODE
git clone https://github.com/PerseusDL/morpheus perseus-morpheus

### 5. BUILD PERSEUS VERSION OF STEMLIBS ( AND MORPHEUS BECAUSE ITS NEEDED
###    TO BUILD STEMLIBS

cd perseus-morpheus/src
make 
make install
cd ../stemlib/Latin

export PATH=$PATH:../../bin
export MORPHLIB=..
make

cd ../Greek
make

### 6. INSTALL THE MOD_PERL MORPHEUS WRAPPER
cd /usr/local/morph
git clone 
cd morpheus-wrapper

### 7. SETUP THE LINKS TO MORPHEUS AND STEMLIBS 
###    AS EXPECTED BY THE DEFAULT WRAPPER CONF
cd Alpheios
ln -s /usr/local/morph/perseus-morpheus/dist/bin  morpheus
cd morpheus
ln -s /usr/local/morph/perseus-morpheus/stemlib stemlib

### 8. SETUP APACHE TO RUN THE WRAPPER
cd /var/www
ln -s /usr/local/morph/morpheus-wrapper perl
cp /var/www/perl/morph.conf /etc/apache2/conf-enabled
sudo service apache2 restart

### 9. VERIFY IT WORKS
### http://localhost/morph/greek?word=mou=sa
### http://localhost/morph/latin?word=mare

### 10. INSTALL DEPENDENCIES FOR SERVICEMIX AND BSP
apt-get install openjdk-6-jdk
apt-get install subversion
apt-get install postgresql-9.3 
a2enmod proxy_ajp


### 11. ADD USER FOR SERVICEMIX
adduser smx
### INTERACTIVE: supply password as b@mb00


### 12. CONFIGURE POSTGRES
su - postgres
psql
### INTERACTIVE: alter user postgres with password 'Bamboo_password_01' ; \q

vi /etc/postgresql/9.3/main/pg_hba.conf
### INTERACTIVE: change auth method for postgres on local from peer to md5

postgresql restart

### 13. CREATE DIRECTORIES FOR BSP
mkdir /usr/local/BSP_0.9
mkdir /srv/BSP-local-store
mkdir/srv/BSP-local-store/cache
mkdir/srv/BSP-local-store/cache/BSP
mkdir/srv/BSP-local-store/logs
mkdir/srv/BSP-local-store/logs/security
mkdir/srv/BSP-local-store/policies
chown -R smx:smx /usr/local/BSP_0.9
chown -R smx:smx /srv/BSP-local-store

### 14. SETUP PROFILE FOR SMX USER
### INTERACTIVE: add these BSP SETTINGS add .bashrc file for the smx user
export BSP_HOME=/usr/local/BSP_0.9
export HOSTNAME=services.perseids.org
export HOSTNAME_SERVICE_QUALIFIER=
export BSP_READ_ONLY_SERVICE_USER_ID=BSP_READ_ONLY_SERVICE_USER
export BSP_READ_ONLY_SERVICE_USER_PASSWORD=tacm0t-
export BSP_GROUP_SERVICE_USER_ID=BSP_GROUP_SERVICE_USER
export BSP_GROUP_SERVICE_USER_PASSWORD=tacm0t-
export BSPLOCALSTORE_HOME=/srv/BSP-local-store
export GROUPER_VERSION=v2_1_002
export SERVICEMIX_HOME=${BSP_HOME}/fuse-esb-7.0.0.fuse-061
export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-amd64
export M2_HOME=${BSP_HOME}/apache-maven-3.0.5
export MAVEN_OPTS='-Xmx512M -XX:MaxPermSize=512m'
export BSP_DB_NAME=BSP_V1_TEST
export BSP_DB_PASSWORD=Bamboo_password_01
export BSP_DB_USER=postgres
export PATH=${SERVICEMIX_HOME}/bin:${JAVA_HOME}/bin:${M2_HOME}/bin:$PATH

sudo - smx

### 15. INSTALL SERVICEMIX FROM LEGACY PACKAGES
cd /usr/local/BSP_0.9
wget https://www.dropbox.com/s/1ompa969nu0nkyq/fuse-esb-full-7.0.0.fuse-061.tar.gz
tar -xzf fuse-esb-full-7.0.0.fuse-061.tar.gz

### 16. INSTALL MAVEN
wget http://mirror.nexcess.net/apache//maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
tar -xzf apache-maven-3.0.5-bin.tar.gz

### 17. CONFIGURE SERVICEMIX
echo "org.apache.cxf.servlet.context=/bsp" >> $SERVICEMIX_HOME/etc/org.apache.cxf.osgi.cf
echo org.apache.cxf.servlet.base-address=http://`hostname`:8181/bsp >> $SERVICEMIX_HOME/etc/org.apache.cxf.osgi.cfg
vi ${SERVICEMIX_HOME}/etc/config.propertiessmx@ip-10-0-0-51:/usr/local/BSP_0.9
### INTERACTIVE: Edit the # OSGi Execution Environment setting to read: org.osgi.framework.executionenvironment=JavaSE-1.6,J2SE-1.5,J2SE-1.4,J2SE-1.3,J2SE-1.2

vi ${SERVICEMIX_HOME}/etc/org.apache.karaf.features.cfg
### INTERACTIVE: Edit the featuresBoot setting by appending ,webconsole,jpa-hibernate, save and exit

vi ${SERVICEMIX_HOME}/etc/org.ops4j.pax.web.cfg
### INTERACTIVE: Comment out all content save and exit

vi ${SERVICEMIX_HOME}/etc/org.apache.karaf.features.cfg
### INTERACTIVE: #Add mvn:org.projectbamboo/bsp.features.build/0.9.0.-SNAPSHOT/xml/features to the ".\" list of featuresRepositories

### 18. CONFIGURE MAVEN
vi ${M2_HOME}/conf/settings.xml
### INTERACTIVE: Replace "/path/to/local/repo" with "/srv/BSP-local-store/mavenRepo/repository", save and exit

mvn install
### IGNORE FAILURE - EXPECTED

### 18. GET THE SOURCE FOR THE BSP
cd
svn checkout svn://svn.code.sf.net/p/projectbamboo/code/ projectbamboo-code

### 19. MANUALLY CREATE THE POSTGRES DB
cd projectbamboo-code/platform-services/bsp/trunk/bsp-ddl/src/main/resources
psql -U postgres -W -f create-BSP_V1.sql
psql -U postgres -W -f person-tables.sql BSP_V1_TEST
psql -U postgres -W -f notification-tables.sql BSP_V1_TEST
psql -U postgres -W -f cache-tables.sql BSP_V1_TEST
psql -U postgres -W -f utility.protected-resource.domain.sql BSP_V1_TEST

### 20. DEAL WITH LEGACY CODE BUILD FAILURE
###     unfortunately it seems we cannot really rebuild BSP without
###     alot of work so for now we are going to install from backups
###     including the deployed bundles which really is not great
###     and means it's time to write a new API service wrapper for morpheus

cd ${SERVICEMIX_HOME}/data
wget https://www.dropbox.com/s/ubop8mgf9fwo79k/smxcache.tgz
tar -xzf smxcache.tgz

cd ${BSPLOCALSTORE_HOME}/mavenRepo/repository
wget https://www.dropbox.com/s/4nbscfvedx934nw/mavenrepo.tgz
tar -zxf mavenrepo.tgz 

cd ${BSPLOCALSTORE_HOME}/policies
wget http://svn.code.sf.net/p/projectbamboo/code/platform-services/bsp/trunk/bsp/utility-services/policy-service/policy-service-domain/src/test/resources/policies/PermitAllServices.xml


### 21. START SERVICEMIX
${SERVICEMIX_HOME}/bin/start

### 22. INSTALL AND START BUNDLES
ssh -p 8101 smx@localhost
### INTERACTIVE: password smx
### INTERACTIVE: features:install spring-dm-web
### INTERACTIVE: osgi:list | grep Tufts
### INTERACTIVE: osgi:stop and osgi:start for each package 
###              in the Morphology Service. E.g.
###              osgi:stop 368
###              osgi:stop 367
###              osgi:stop 366
###              osgi:start 366
###              osgi:start 367
###              osgi:start 368
### INTERACTIVE: exit

### 23. VERIFY
### http://localhost:8181/bsp/morphologyservice/analysis/word?lang=grc&engine=morpheusgrc&word=καὶ
### http://localhost:8181/bsp/morphologyservice/analysis/word?lang=lat&engine=morpheuslat&word=mare
### http://localhost:8181/bsp/morphologyservice/analysis/word?lang=ara&engine=aramorph&word=mivAl

### 24. ADD APACHE PROXY
### Settings to add to your Apache Config:
### - For AJP Proxy to Service Mix:
###     ProxyIOBufferSize 65536
###     ProxyPass /bsp ajp://localhost:8009/bsp
### - For CORS Access
###      Header set Access-Control-Allow-Origin "*"
###      Header set Access-Control-Allow-Headers "Origin, X-Requested-With, Content-Type, Accept"
###      RewriteEngine On
###      RewriteCond %{REQUEST_METHOD} OPTIONS
###      RewriteRule /bsp/* /index.html [L]

### 25. VERIFY
### http://localhost/bsp/morphologyservice/analysis/word?lang=grc&engine=morpheusgrc&word=καὶ
### http://localhost/bsp/morphologyservice/analysis/word?lang=lat&engine=morpheuslat&word=mare
### http://localhost/bsp/morphologyservice/analysis/word?lang=ara&engine=aramorph&word=mivAl

### NOTES:
###      1. ARABIC
###      The Tufts Morphology Service is configured to call morpheus 
###      from localhost but for the aramorph engine it calls the instance
###      of Buckwalter 2 deployed at http://alpheios.net/perl/aramorph-test
###      The wrapper code for Buckwalter 2 is freely available at 
###      https://github.com/alpheios-project/bama2-wrapper
###      But Alpheios does not have the license rights to redistribute
###      the underlying buckwalter2 libraries. 
###      It must be licensed directly from LDC
###      Reconfiguring the URLS at which the morpholgoy service
###      calls the different engines is possible but requires fiddling with the
###      spring configuration file (see http://svn.code.sf.net/p/projectbamboo/code/platform-services/morphology-service/trunk/morphology-service/service/src/main/resources/META-INF/spring/beans.xml)
###      for the deployed bundles which might not
###      be so fun to do given that we can't easily rebuild and redeploy from
###      scratch.
###
###      2. GREEK
###     The currently live version of the Morphology Service for
###     Perseids uses the Alpheios version of the Greek stemlibs
###     And the Perseus version of the Morpheus stemlibs. The instructions
###     outlined in this script assume that the stemlibs from PerseusDL 
###     will be used for both Greek and Latin
###
