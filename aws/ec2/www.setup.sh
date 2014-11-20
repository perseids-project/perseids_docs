# Amazon AWS(VPC)
# Ubuntu 14.04
# M3 medium
# security group: perseids-front-end
# created from AMI of www.perseids.org
# so setup steps below aren't complete
ssh -i ~/.ssh/perseidskey.pem ubuntu@www.perseids.org
sudo hostname www.perseids.org
vi /etc/hostname - edit to www.perseids.org
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

sudo apt-get update

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


