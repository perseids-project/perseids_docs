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
