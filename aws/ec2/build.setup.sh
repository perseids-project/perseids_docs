# Perseids Build Enviroment for
#  LLT Services
#  Arethusa
#  Arethusa Configs
#  Cite Collection Manager
#  Cite Collection Service
# Ubuntu 14.04
# Amazon AWS EC2 t2.medium
# perseidsservices.pem

sudo apt-get update
sudo apt-get install curl
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source /home/ubuntu/.rvm/scripts/rvm
rvm install jruby
rvm install ruby-2.0.0-p594
vi ~/.bash_profile
# insert jruby 2.0 settings
# export JRUBY_OPTS=--2.0

sudo apt-get install git
# needed for llt db rake tasks
sudo apt-get install postgresql

# use jruby
rvm use jruby

# Install LLT code
git clone https://github.com/latin-language-toolkit/llt
cd llt
bundle
gem install llt

# Install warbler
gem install warble

# Install LLT db handler
cd  
git clone https://github.com/latin-language-toolkit/llt-db_handler
cd llt-db_handler

# Setup db on remote server
# note replace www-rep.perseids.org with VPC address for remote server
rake db:prometheus:create[www.perseids.org]
rake db:prometheus:seed[www.perseids.org]

# build war
cd
cd llt
warble

# deploy war
# replace www-rep.perseids.org with the VPC address for remote server
curl --upload-file llt.war "http://admin:PASSWORD@http://services2.perseids.org:8080/manager/deploy?path=/llt&update=true"


# Install cite_mapper code
cd
git clone https://github.com/PerseusDL/cite_mapper.git
cd cite_mapper
bundle
warble
curl --upload-file cite_mapper.war "http://admin:PASSWORD@services2.perseids.org:8080/manager/deploy?path=/cite_mapper&update=true"

sudo apt-get install gradle
sudo apt-get install mercurial

# get private google api keys
git clone https://github.com/PerseusDL/perseids_private_config

# Install Cite Fusion Coll code
hg clone https://balmas@bitbucket.org/balmas/citefusioncoll
cd citefusioncoll
cp gradle.properties-dist gradle.properties
# edit and set API key (copy from perseids_private_config/googleapis/apikey)
cd src/main/webapp/configs
wget -O capabilities.xml https://raw.githubusercontent.com/PerseusDL/cite_collections/master/src/capabilities/capabilities-gf-pub.xml
cd ../../../../
gradle war
curl --upload-file build/libs/citefusioncoll-0.2.0.war "http://admin:PASSWORD@services2.perseids.org:8080/manager/deploy?path=/citefusioncoll-0.2.0&update=true"


# install cite collection editor and manager
git clone https://github.com/balmas/cite-collection-manager
cd cite-collection-manager
cp ~/perseids_private_config/googleapis/client_secrets.json src/main/resources
cd src/main/webapp/cite-collection-editor/capabilities
wget https://raw.githubusercontent.com/PerseusDL/cite_collections/master/src/capabilities/capabilities-gf-pub.xml
cd ../../../../../
gradle war
curl --upload-file build/libs/cite-collection-manager-0.0.1.war  "http://admin:PASSWORD@services2.perseids.org:8080/manager/deploy?path=/cite-collection-manager-0.0.1&update=true"

# install arethusa-cli tool
cd
git clone https://github.com/latin-language-toolkit/arethusa-cli
cd arethusa-cli
rvm use 2.0
gem install arethusa-cli

# install arethusa
cd
git clone https://github.com/latin-language-toolkit/arethusa

# install node.js and npm
sudo apt-get install node
sudo apt-get install npm
sudo npm install grunt-cli -g
sudo npm install bower -g
npm install
grunt install

# build and deploy arethusa
rvm use 2.0
arethusa build
arethusa deploy deployer@www.perseids.org /usr/local/arethusa -co "-i ~/.ssh/perseidskey.pem" -e prod

#install arethusa-configs
cd
git clone https://github.com/latin-language-toolkit/arethusa-configs
cd arethusa-configs
rake build
rsync -av -e "ssh -i ~/.ssh/perseidskey.pem" dist deployer@www.perseids.org:/usr/local/arethusa-configs

# update specific branches
cd
cd arethusa-configs
git checkout gcelano
git pull
rake build
scp -i ~/.ssh/perseidskey.pem dist/smyth3.json deployer@www.perseids.org:/usr/local/arethusa-configs/dist

git checkout harrington_tag_set
git pull
rake build
scp -i ~/.ssh/perseidskey.pem dist/harrington.json deployer@www.perseids.org:/usr/local/arethusa-configs/dist

# epifacs_demo
cd
git clone https://github.com/PerseusDL/epifacs_demo
rsync -av -e "ssh -i /home/ubuntu/.ssh/perseidskey.pem" src deployer@www.perseids.org:/usr/local/epifacs_demo

