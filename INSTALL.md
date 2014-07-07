Estimated install time: 4 hours

## Base Environment
* Amazon AWS
* m1.small
* Ubuntu 12.04

## Security Group
Make sure your instance's security-group allows TCP traffic over ports 3000 and 8080
Our AWS profile has this security-group preconfigured.

* sosol-rails

# Install system dependencies with apt-get
	sudo apt-get update
	sudo apt-get install build-essential
	sudo apt-get install unzip
	sudo apt-get install zlib1g-dev
	sudo apt-get install git
	sudo apt-get install subversion
	sudo apt-get install openjdk-6-jre
	sudo apt-get install lynx

# Setup shell
	mkdir ~/lib
	git clone http://github.com/caesarfeta/bash_lib ~/lib/bash_lib
	echo 'source ~/lib/bash_lib/profile' >> ~/.profile
	source ~/.profile

# Install rbenv
	git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
	echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
	echo 'eval "$(rbenv init -)"' >> ~/.bashrc
	source ~/.profile

# Install ruby-build
	git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install jruby-1.7.11
	rbenv install jruby-1.7.11
	rbenv global jruby-1.7.11
	rbenv rehash

# Install rails
	gem install rails -v 3.2.3

# Clone sosol project and switch to the rails-3-perseus_merge branch
	sudo chown -R ubuntu /usr/local
	git clone https://github.com/sosol/sosol /usr/local/sosol
	cd /usr/local/sosol
	git checkout -b rails-3-perseus-merge origin/rails-3-perseus-merge

# Install eXist db 1.4.1
Download

	cd ~
	lynx http://sourceforge.net/projects/exist/files/Stable/1.4.1/
		eXist-setup-1.4.1-rev15155.jar [ENTER]
		direct link [ENTER]
		D)ownload
		Save to Disk [ENTER] [ENTER]
		Q)uit [y]

Install

	java -jar eXist-setup-1.4.1-rev15155.jar -p /usr/local/exist
	
TODO - we need to get updated wrapper code from 2.1 install

## Install CTS API and Tools into eXist

Start the eXist server

Launch the eXist client and restore (Tools/Restore)

## Install the Alpheios CTS API into eXist

Download the code as a restorable zip from https://github.com/alpheios-project/cts-api/archive/master.zip

Restore from this zip using the eXist client Tools/Restore

Verify that the basics of the CTS API are working via the following URLS:

http://localhost:8080/exist/rest/db/xq/CTS.xq?request=GetCapabilities
(should return inventory file)

http://localhost:8080/exist/rest/db/xq/CTS.xq?request=GetValidReff&urn=urn:cts:greekLit:tlg0012.tlg001.alpheios-text-grc1
(should return list of valid refs for books in the Iliad)

http://localhost:8080/exist/rest/db/xq/CTS.xq?request=GetPassage&urn=urn:cts:greekLit:tlg0012.tlg001.alpheios-text-grc1:1.1
(should return TEI xml for line 1 of the Iliad)

TODO provide sample output for testing against.

## Install Alpheios edit utils into eXist

Download the code as a restorable zip from https://github.com/alpheios-project/edit-utils/archive/master.zip

Restore from this zip using the eXist client Tools/Restore


## Install the Treebank Editor into eXist

Download the code as a restorable zip from https://github.com/alpheios-project/treebank-editor/archive/master.zip

Edit the following files in the zip to replace instances of localhost with the server name of your deployment environment:

/db/app/treebank-entertext-perseids-test.xml  
/db/app/treebank-editsentence-perseids-test.xml  

Restore from this zip using the eXist client Tools/Restore

TODO Verify that the basics of the editor are working via the following URLS:

## Install the Alignment Editor into eXist
Download the code as a restorable zip from https://github.com/alpheios-project/alignment-editor/archive/master.zip

Edit the following files in the zip to replace instances of localhost with the server name of your deployment environment:

/db/app/align-editsentence-perseids-test.xml  

Restore from this zip using the eXist client Tools/Restore

TODO Verify that the basics of the editor are working via the following URLS:


## Setup Annotation Sources

TODO (this isn't specific to the rails 3 setup so for now just use the annot sources from the live environment see below under application config).

# Install Apache2 and mod_proxy

sudo apt-get install apache2
sudo a2enmod proxy
sudo a2enmod proxy_http

# Install Apache-served tools 

## Annotation Editor

cd /var/www
sudo git clone https://github.com/PerseusDL/annotation-editor

## Arethusa

TODO - see https://github.com/latin-language-toolkit/arethusa-cli


# Prepare the canonical.git repo aka "read-write" data

Note that the default installation instructions for sosol have this as a rake tasks which will install the default papyri.info db (        bundle exec rake git:db:canonical:clone) -- we will skip that step in favor of these for now -- eventually should have a perseids version of this task.

	sudo mkdir -p /usr/local/gitrepos
	cd /usr/local/gitrepos

## for a dev/test environment

	sudo git clone --bare  https://github.com/PerseusDL/perseids_canonical_dev.git canonical.git

## for a production environment

TODO - the perseids repo and the perseusdl repo need to be merged and forked from a common root on github

        git clone --bare ubuntu@sosol.perseids.org:/usr/local/gitrepos/canonical.git 

## change the ownership of the canonical repo

The repo must be read/writeable by the user running the core sosol application. For production environments under tomcat this might be tomcat6:tomcat6. For dev environments it's likely to be your own user id

## create a local clone of the bare repo

It's useful to have a local clone of the canonical repo for file maintenance.

        cd ~
        git clone /usr/local/gitrepos/canonical.git

# Prepare the inventory files
You have to load inventory files and their indices for the Persieds CTS selector to work properly.

## for the dev environmnet

The perseids-dev.xml inventory file can be found in the CTS_XML_TextInventory directory of the perseids_canonical_dev repo.  This needs to be uploaded to the eXist db/repository/inventory directory.

## For the production environment 

TODO this needs to be simplified see above comment about need to merge perseus and perseids canonical repos -- this should be addressed with that

Get a local clone of the PerseusDL/canonical.git repo:

	git clone https://github.com/PerseusDL/canonical.git /tmp/canonical

Copy the inventory xml files.

	mkdir -p /usr/local/exist/webapp/WEB-INF/data/fs/db/repository/inventory
	cp /tmp/canonical/CTS_XML_TextInventory/epifacs.xml ~/db/repository/inventory/epifacs.xml
	cp /tmp/canonical/CTS_XML_TextInventory/pilots.xml ~/db/repository/inventory/pilots.xml

Open ~/db/repository/inventory/__contents__.xml in a text editor.

	vim ~/db/repository/inventory/__contents__.xml

Add the following text inside &lt;collection&gt;&lt;/collection&gt;

	<resource type="XMLResource" name="epifacs.xml" owner="admin" group="dba" mode="755" created="2013-02-15T07:47:23-05:00" modified="2013-02-15T07:47:23-05:00" filename="epifacs.xml" mimetype="text/xml"/>
	<resource type="XMLResource" name="pilots.xml" owner="admin" group="dba" mode="755" created="2013-02-15T07:47:23-05:00" modified="2013-02-15T07:47:23-05:00" filename="pilots.xml" mimetype="text/xml"/>

### Update eXist with the prepared data
Start up eXist and run the backup restore script and point it at the prepared data.

	/usr/local/exist/bin/startup.sh &
	/usr/local/exist/bin/backup.sh -u admin -r ~/db/__contents__.xml

### Copy over the publication XML files referenced in the inventory
Modify the configuration and run.

	/usr/local/sosol/script/existDBImport


## Setup Apache2 Proxies for Tools

TODO Note:  for production environment replace 3000 with 8080/sosol for tomcat deployment, 8080 with 8800 for eXist, and drop the proxies to /cts and /publications and /dmm_api

Add the following in a conf file in /etc/apache2/conf.d and then restart apache

        <IfModule mod_proxy.c>

            ProxyPass /dmm_api http://localhost:3000
            ProxyPassReverse /dmm_api http://localhost:3000

            ProxyPass /cts http://localhost:3000/cts
            ProxyPassReverse /cts http://localhost:3000/cts
            
            ProxyPass /publications http://localhost:3000/publications
            ProxyPassReverse /publications http://localhost:3000/publications
            
            ProxyPass /exist/rest/db/repository !
            ProxyPass /exist http://localhost:8080/exist
            ProxyPassReverse /exist http://localhost:8080/exist

        </IfModule>



# Change the SoSOL application config
This part is of the config needs to be improved.

Currently the configuration files in the rails-3-perseus-merge branch contain the default settings for the perseids dev environment. These can't be merged back into master because they would tromp the papyri.info settings. This will be addressed in a future build of SoSOL but for now I've listed all the settings that can be set in application.rb (or lower in e.g. environments/development.rb) that are specific to the perseids deployment.

The following should be the same for production and dev environments:

         SITE_NAME = 'Perseids'
         SITE_FULL_NAME = 'Perseids'
         SITE_TAG_LINE = 'powered by Son of Suda Online'
         SITE_WIKI_LINK = '<a href="http://sites.tufts.edu/perseids">Perseids Blog</a>
         SITE_LAYOUT = 'perseus'
         SITE_IDENTIFIERS = 'CitationCTSIdentifier,EpiCTSIdentifier,EpiTransCTSIdentifier,OACIdentifier,CTSInventoryIdentifier,CommentaryCiteIdentifier,TreebankCiteIdentifier,AlignmentCiteIdentifier'
         SITE_CATALOG_SEARCH = "View In Catalog"
         SITE_USER_NAMESPACE = "data.perseus.org" 
         SITE_OAC_NAMESPACE = "http://data.perseus.org/perseids/annotations/"
         SITE_CITE_COLLECTION_NAMESPACE = "http://data.perseus.org/collections"
         SITE_EMAIL_FROM = 'admin@perseids.org'
         REPOSITORY_ROOT = "/usr/local/gitrepos"
         XSUGAR_STANDALONE_URL="http://localhost:9999/"
         XSUGAR_STANDALONE_USE_PROXY="true"

The following are specific to the deployment and depend upon the port(s) at which you are running the eXist server or servers.  

         EXIST_STANDALONE_URL="http://localhost:8080"
         EXTERNAL_CTS_REPOS = 'Quotation Sources|http://sosol.perseids.org/exist/rest/db/xq/CTS.xq?inv=annotsrc|http://perseids.org/annotsrc'
 	 SITE_CTS_INVENTORIES = 'pilots|Epi,epifacs|Epi,perseids|Tei,annotsrc|Tei'

EXIST_STANDALONE_URL is the url for the eXist instance that is local to the sosol application (and which has the cts inventories loaded that corresponded to the read/write data in the cnaonical git repo)

EXTERNAL_CTS_REPOS should be set to a list of CTS Repositories at which read-only sources for use in annotation bodies can be retrieved.

SITE_CTS_INVENTORIES should be set to the list of inventory files that correspond to the installed read/write data.

The basic format for this setting is 'key|value,key|value', an array of key value pairs where the key is the inventory file name (minus extension) and the value is the prefix for the type of CtsIdentifier this inventory manages.

For the dev/test environment, this should be set to 

	SITE_CTS_INVENTORIES = 'perseids-dev|Epi'
	
# setup the RPX api key

for development environment  use environments/development_secret.rb
for production environment use environments/production_secret.rb

must contain:

RPX_API_KEY = put secret here - see janrain login details in perseids it inventory doc
RPX_REALM = 'perseus-sosol'

# Update the database.yml

The version of database.yml that is currently in the rails-3-perseus-merge branch works for a dev or test environment.

For a production environment, the database connection url and username and password need to be set to the credentials for the production mysql db. See the Perseis IT Inventory for these details. (They are not for publication here...)

# Update the tools.yml

Edit the tools.yml, replacing instances of localhost with base route to the deployed sosol environment.

# TODO: Configure shibboleth

# Set RAILS_ENV

For a dev environment: Change RAILS_ENV value to development

# TODO: Run the tests


## Run the bundle commands

	bundle install
	bundle exec cap local externals:setup
	bundle exec rake db:create
	bundle exec rake db:migrate --verbose --trace
	bundle exec rake test
	bundle exec rails server

# Deploy on AWS

## Create Elastic IP
console.aws.amazon.com
	> Services
		> EC2
	> Running Instances
	> [Instance]
	> Elastic IP -
	> Allocate New Address
	> Associate Address

## Create DNS Hostname
console.aws.amazon.com
	> Services
		> Route 53
	> Domain Name Table
		> [x] [Domain Name]
	> Go to Record Sets
	> Create Record Set

	Create Record Set
		Name: [whatever].perseids.org
		Type A: IPv4 address
		Value: [Elastic IP]

## Add host to janrain whitelist
https://dashboard.janrain.com/


# Start the Server
You have to start the eXist DB and rails

	/usr/local/exist/bin/startup.sh &
	cd /usr/local/sosol;
	bundle exec rails server &

TODO for a production environment we want to run eXist through wrapper and deploy app war file under tomcat

# The Current Rails3 Development Server
Hosted: AWS EC2
Instance: rails-small2
Domain Name: rails3.perseids.org
If inaccessible check the AWS EC2 Elastic IP configuration and associate rails-small2 instance with the non-coupled IP address in the list.
