# Ruby Build Enviroment for LLT Services
# Ubuntu 14.04
# Amazon AWS EC2 t2.medium
# perseidsservices.pem

sudo apt-get update
sudo apt-get install curl
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source /home/ubuntu/.rvm/scripts/rvm
rvm install jruby
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
# note replace 10.0.0.200 with VPC address for remote server
rake db:prometheus:create[10.0.0.200]
rake db:prometheus:seed[10.0.0.200]

# build war
cd
cd llt
warble

# deploy war
# replace 10.0.0.200 with the VPC address for remote server
curl --upload-file llt.war "http://admin:PASSWORD@http://10.0.0.200:8080/manager/deploy?path=/llt&update=true"


# Install cite_mapper code
cd
git clone https://github.com/PerseusDL/cite_mapper.git
cd cite_mapper
bundle
warble
curl --upload-file cite_mapper.war "http://admin:PASSWORD@10.0.0.200:8080/manager/deploy?path=/cite_mapper&update=true"
