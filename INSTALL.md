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

Download the alpeios database.
It is hosted on dropbox.
Use a gui webbrowser on your work machine to download the zip file and then scp it over.

	https://www.dropbox.com/l/tg0THcAFcsa1xKT0IQvzY9
	scp eXist-alpheios-install.zip [HOST]:~/

	cd ~
	unzip eXist-alpheios-install.zip
	/usr/local/exist/bin/startup.sh &
	/usr/local/exist/bin/backup.sh -u admin -r ~/db/__contents__.xml

Refresh the base install with the latest xquery code from sourceforge.

        svn checkout http://svn.code.sf.net/p/alpheios/code/xml_ctl_files/xquery/trunk xq
        svn checkout http://svn.code.sf.net/p/alpheios/code/xml_ctl_files/xslt/trunk xslt

Using the eXist client, replace the contents of the xq and xslt directories in the eXist db with the contents of the folders checked out from sourceforge.


## Install the data
Currently data for Perseids comes from two sources: the canonical.git repo mounted on sosol.perseids.org and the PerseusDL canonical git repo in GitHub.  Eventually these two sources need to be forks of one common source. This is not yet the case though.  

At the present time, the master repository for all *read-write* data in Perseids is the canonical.git repo on sosol.perseids.org.  A clone of this data is currently required to live on the same server as the SoSOL application.

The master repository for all *read-only* data in Perseids is the PerseusDL/canonical.git repo on GitHub. Text inventories and citable text data from this repository gets loaded in eXist for access by SoSOL.  A small subset of the read-only data also comes from the canonical_protected directory in CVS - this is used for data that is still under copyright and can't be released in GitHub.

### Install the canonical.git repo used by SoSOL

For the read-write data, you need to clone a bare copy of the sosol.perseids.org canonical.git repository: 

	mkdir -p /usr/local/gitrepos
	cd /usr/local/gitrepos
	git clone --bare ubuntu@sosol.perseids.org:/usr/local/gitrepos/canonical.git 
	[ NOTE sshkeys are required for this ]


### Load the read-only data in eXist

Get a local clone of the PerseusDL/canonical.git repo:

	git clone https://github.com/PerseusDL/canonical.git /tmp/canonical
	
And a local copy of the Perseus canonical_protected repository in CVS.

        cvs checkout ....

Using the eXist client, upload the following inventory files from the canonical/CTS_XML_TextInventory directory to eXist in db/repository/inventory:

        epifacs.xml 
        pilots.xml 
        annotsrc.xml 
        
epifacs.xml, pilots.xml are the inventories of texts currently available for editing in Perseids. The corresponding text files do NOT need to be loaded in eXist because they come from the local perseids canonical.git repo.

annotsrc.xml is the inventory of texts available for citing in annotations in Perseids.  The corresponding text files in this inventory DO need to be loaded in eXist.  At the moment, this is not automated at all, you have to extract the paths contained in the @docname attribute of the online elements in the text inventory file and upload the corresponding files from your clone of the PerseusDL/canonical.git repo or the canonical_protected repo.  The directory structure of the files in the git and cvs repos mirrors the directory structure the files need to be loaded into eXist. The base directory for texts in eXist /db/repository corresponds the base directory for texts in the `canonical` and `canonical_protected` repos, which will be either CTS_XML_TEI or CTS_XML_EpiDoc.



## Change the config
This part is of the config needs to be improved.

	cd /usr/local/sosol/config
	cp perseus_application.rb application.rb
	cp environments/perseus_development.rb environments/development.rb

I've tweaked the application config.

	cp perseus_database.yml database.yml

Change RAILS_ENV value to development

## TODO: Run the tests
## Run the bundle commands
	bundle install
	bundle exec cap local externals:setup
	bundle exec rake db:create
	bundle exec rake db:migrate --verbose --trace
	bundle exec rake git:db:canonical:clone
	bundle exec rake test
	bundle exec rails server

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

## TODO: Configure shibboleth

# Running
## Starting The Server
You have to start the existdb and rails

	/usr/local/exist/bin/startup.sh &
	cd /usr/local/sosol;
	bundle exec rails server &
