# Amazon AWS(VPC)
# Ubuntu 12.04
# security group: perseids-services-group
# created from AMI of services.perseids.org
# so setup steps below aren't complete

# Removed apps from /var/lib/tomcat6/webapps
# TODO remove tomcat all together

# Added proxies to apache for the webapps which moved to services2 and www
# llt, cite_mapper, sg, arethusa-configs

# Notes
# Fuse Web Console
# http://services.perseids.org:8181/system/console/bundles
# Note that if morphology service doesn't start automatically
# upon start of fuse esb, you need to go into the Web Console and stop and
# restart it


## Fuseki
curl -O http://archive.apache.org/dist/jena/binaries/jena-fuseki-1.0.2-distribution.tar.gz
tar xvf jena-fuseki-1.0.2-distribution.tar.gz
sudo mv jena-fuseki-1.0.2 /usr/local
cd /usr/local/jena-fuseki-1.0.2
chmod 755 s-*
cd /etc/init.d
sudo ln -s /usr/local/jena-fuseki-1.0.2/fuseki fuseki
sudo update-rc.d fuseki defaults
sudo update-rc.d fuseki enable
# update perseids-services security group to allow inbound access to 3030 from
# tufts and developer ips
# add /fuseki to apache proxy
# in /etc/conf.d create fuseki.conf wiht
# <Location /fuseki>
#    ProxyPass http://localhost:3030
#    ProxyPassReverse http://localhost:3030
#</Location>

