#!/usr/bin/env bash

apt-get update
apt-get install openjdk-6-jdk
apt-get install subversion
apt-get install git-core
apt-get install libapache2-mod-perl2
apt-get install unzip
apt-get install make
apt-get install gcc
apt-get install flex
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_ajp

adduser smx
# INTERACTIVE: supply password as b@mb00

apt-get install postgresql-9.3 
su - postgres
psql
# INTERACTIVE: alter user postgres with password 'Bamboo_password_01' ; \q
vi /etc/postgresql/9.3/main/pg_hba.conf
# INTERACTIVE: change method for postgres on local from peer to md5
postgresql restart


mkdir /usr/local/morph
cd /usr/local/morph
wget http://sourceforge.net/code-snapshots/svn/a/al/alpheios/code/alpheios-code-4291-morpheus-trunk.zip
unzip alpheios-code-4291-morpheus-trunk.zip

git clone https://github.com/PerseusDL/morpheus
cd morpheus/src
make 
make install
cd ../stemlib/Latin

export PATH=$PATH:../../bin
export MORPHLIB=..
make

cd ../Greek
make

cd /usr/local/morph
git clone 
cd morpheus-wrapper
cd Alpheios
ln -s /usr/local/morph/alpheios-code-4291-morpheus-trunk/dist/bin  morpheus
cd morpheus
ln -s /usr/local/morph/morpheus/stemlib stemlib

cd /var/www
ln -s /usr/local/morph/morpheus-wrapper perl
cp /var/www/perl/morph.conf /etc/apache2/conf-enabled
sudo service apache2 restart

# VERIFY
# http://localhost/morph/greek?word=mou=sa
# http://localhost/morph/latin?word=mare

mkdir /usr/local/BSP_0.9
mkdir /srv/BSP-local-store
chown -R smx:smx /usr/local/BSP_0.9
chown -R smx:smx /srv/BSP-local-store

### add these BSP SETTINGS add .bashrc file for the smx user
## BSP 0.9 SETTINGS ##
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

cd /usr/local/BSP_0.9
wget #LOCATION OF FUSE ESP fuse-esb-full-7.0.0.fuse-061.tar.gz
tar -xzf fuse-esb-full-7.0.0.fuse-061.tar.gz
wget http://mirror.nexcess.net/apache//maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
tar -xzf apache-maven-3.0.5-bin.tar.gz

# replace ${servername} with your server name
echo "org.apache.cxf.servlet.context=/bsp" >> $SERVICEMIX_HOME/etc/org.apache.cxf.osgi.cf
echo org.apache.cxf.servlet.base-address=http://${servername}8181/bsp >> $SERVICEMIX_HOME/etc/org.apache.cxf.osgi.cfg

vi ${SERVICEMIX_HOME}/etc/config.propertiessmx@ip-10-0-0-51:/usr/local/BSP_0.9
# Edit the # OSGi Execution Environment setting to read: org.osgi.framework.executionenvironment=JavaSE-1.6,J2SE-1.5,J2SE-1.4,J2SE-1.3,J2SE-1.2

vi ${SERVICEMIX_HOME}/etc/org.apache.karaf.features.cfg
# Edit the featuresBoot setting by appending ,webconsole,jpa-hibernate

# Comment out all content in ${SERVICEMIX_HOME}/etc/org.ops4j.pax.web.cfg

karaf
# INTERACTIVE
# features:install spring-dm-web
# exit

vi ${M2_HOME}/conf/settings.xml
# Search for "localRepository"
# Replace "/path/to/local/repo" with "/srv/BSP-local-store/mavenRepo/repository"
# Save and close the file
 mvn install
#. Note that this command will report a "Build Failure" (i.e. we did not specify a POM file), but in the process of failing will initialize the Maven repository which is the intent. Note that this may take a while to execute.


# the sourcecode for the bsp and the morpholgoy service is here
cd
svn checkout svn://svn.code.sf.net/p/projectbamboo/code/ projectbamboo-code
# building of the bsp fails
# so as a fallback, used archived last working version of the repo

cd projectbamboo-code/platform-services/bsp/trunk/bsp-ddl/src/main/resources
psql -U postgres -W -f create-BSP_V1.sql
psql -U postgres -W -f person-tables.sql BSP_V1_TEST
psql -U postgres -W -f notification-tables.sql BSP_V1_TEST
psql -U postgres -W -f cache-tables.sql BSP_V1_TEST
psql -U postgres -W -f utility.protected-resource.domain.sql BSP_V1_TEST

vi ${SERVICEMIX_HOME}/etc/org.apache.karaf.features.cfg
#Add mvn:org.projectbamboo/bsp.features.build/0.9.0.-SNAPSHOT/xml/features to the ".\" list of featuresRepositories

# install zip of cached bundles to $SERVICEMIX_HOME data
# install zip of mavenRepo to $BSPLOCALSTORE_MAVEN repo



cd /srv/BSP-local-store
mkdir cache
mkdir cache/BSP
mkdir logs
mkdir logs/security
mkdir policies
cd policies
wget http://svn.code.sf.net/p/projectbamboo/code/platform-services/bsp/trunk/bsp/utility-services/policy-service/policy-service-domain/src/test/resources/policies/PermitAllServices.xml


start
# connect to console
# features:install spring-dm-web
# osgi:list | grep Tufts
# stop and restart if failed


# TODO
# check to see if smx etc changed impact the utf-8 issue (suspect this was spring-dm-web though)
# figure out where to put the legacy fuse and bsp packages
# also note that stem libs built from morpheus on GitHub seem to be different
# than the stemlibs running on services so I suspect we're still using 
# the Alpheios-built libs so need to update the instructions for that
# and make a note to merge the changes from Alpheios into PerseusDL

