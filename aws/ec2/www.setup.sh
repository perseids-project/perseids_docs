# Amazon AWS(VPC)
# Ubuntu 14.04
# M3 medium
# security group: perseids-front-end
# created from AMI of www.perseids.org
# so setup steps below aren't complete
ssh -i ~/.ssh/perseidskey.pem ubuntu@www.perseids.org
sudo hostname www.perseids.org
vi /etc/hostname - edit to www.perseids.org
sudo apt-get update
sudo adduser deployer
sudo su - deployer
mkdir .ssh
chmod 700 .ssh
chmod 600 .ssh/authorized_keys
touch .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
wget http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key
cp openssh-key .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
rm openssh-key
exit

# mount img data vol
sudo mount /dev/xvdf /mnt/imgdata
sudo cp /etc/fstab /etc/fstab.orig
sudo vi /etc/fstab
# insert 
# /dev/xvdf       /imgdata        ext4    defaults,nofail,comment=imgdata 0       2
sudo mount -a



# install depl-help scripts
cd /usr/local
sudo mkdir /usr/local/arethusa
sudo chown -R deployer:deployer /usr/local/arethusa
git clone https://github.com/LFDM/deployment_helpers
sudo chown -R deployer:deployer deployment_helpers
sudo chown -R deployer:deployer /var/www/tools
# setup environment variables
sudo su - deployer
vi .bash_profile
# add
# export DEPLOYMENT_HELPER_TARGET='/var/www/tools'
#export PATH=$PATH:'/usr/local/deployment_helpers'

# install annotation-editor
# (no build script yet)
sudo su - deployer
cd /var/www/tools
git clone https://github.com/PerseusDL/annotation-editor

# make dir and link for arethusa-configs
mkdir /usr/local/arethusa-configs
sudo chown -R deployer:deployer /usr/local/arethusa-configs
sudo su - deployer
cd /var/www/tools
ln -s /usr/local/arethusa-configs/dist arethusa-configs 

# make dir and link for epifacs_demo
mkdir /usr/local/epifacs_demo
chown chown -R deployer:deployer /usr/local/epifacs_demo
cd /var/www/sites
ln -s /usr/local/epifacs_demo/src epifacs

# install JackRDF (shouldn't be necessary but including it as a gemfile in JackSON isn't working)
sudo mkdir /usr/local/JackSON

git clone https://github.com/caesarfeta/JackRDF /var/www/JackRDF
chown -R ubuntu:ubuntu /usr/local/JackRDF
cd /usr/local/JackRDF
rake install

# install JackSON (no build script yet - install as ubuntu user because need sudo access)t submodule update --init
sudo mkdir /usr/local/JackSON
chown -R ubuntu:ubuntu /usr/local/JackSON
sudo ln -s /usr/local/JackSON /var/www/JackSON
git clone https://github.com/caesarfeta/JackSON /var/www/JackSON
cd /var/www/JackSON
git submodule update --init




