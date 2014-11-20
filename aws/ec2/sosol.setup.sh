# Amazon AWS(VPC)
# Ubuntu 12.04
# C3.2 Xlarge
# security group: perseids-app-group
# created from AMI of sosol.perseids.org
# so setup steps below aren't complete
ssh -i ~/.ssh/perseidssosolkey.pem ubuntu@sosol.perseids.org
sudo hostname sosol.perseids.org
vi /etc/hostname - edit to sosol.perseids.org

# removed /usr/local/arethusa
# removed /var/www/tools/arethusa*
# removed /var/lib/tomcat6/webapps/cite* 

# moved eXist to 80GB instance storage volume on /mnt
# moved B. Gorman's eXist repo here
# created copy of eXist-1.4.1 to eXist-1.4.1-unl and running on port 8801
# restored from backup of dbs.perseids.org:8801 
# merged data from dbs.perseids.org:8800 to 8800 here

# modify annotation editor setup a bit
# install annotation-editor
# (no build script yet)
sudo mkdir /usr/local/annotation-editor
sudo chown -R deployer:deployer /usr/local/annotation-editor
sudo ln -s /usr/local/annotation-editor /var/www/tools/annotation-editor
sudo su - deployer
cd /usr/local
git clone https://github.com/PerseusDL/annotation-editor

# mounted git vol
sudo mkdir /gitrepo
sudo mount /dev/xvdg /gitrepo
sudo rm /usr/local/gitrepos
cd /usr/local
sudo ln -s /gitrepo/data gitrepos


# Test Environment Setup
# sosol reconfig
# tools.yml replace services.perseids.org with services2.perseids.org
# tools.yml change path to arethusa and annotation editor
# tools.yml change sosol.perseids.org sosol-rep.perseids.org
# database.yml use test db 

# alpheios input forms:
## switch sosol.perseids.org to sosol-rep.perseids.org
## switch tokenization service to services2
## switch arethusa url to www-rep

# arethusa configs (on www-rep)
# change sosol.perseids.org to sosol-rep.perseids.org
# annotation editor (on www-rep)
# change sosol.perseids.org to sosol-rep.perseids.org
# add www-rep.perseids.org to access control allow in Apache

# change url in imgcollectperseids js

## CODE CHANGES
# Arethusa withCredentials
# Sosol add domain to cookie
# Sosol add X-CSFR-Token to allowed headers in apache config
