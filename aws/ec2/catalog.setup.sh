# smal instance
# services group

sudo apt-get update
sudo apt-get install git

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source /home/ubuntu/.rvm/scripts/rvm
rvm install ruby-2.0
sudo apt-get install tomcat6


# install repos
git clone https://github.com/PerseusDL/cite_collection_rails
git clone https://github.com/PerseusDL/cite_collections_rails
git clone https://github.com/PerseusDL/catalog_pending
git clone https://github.com/PerseusDL/catalog_data

sudo apt-get install mysql-server


  24  gem install rails
   25  gem install bundler
   26  gem install extelib
   27  gem install extlib
   28  gem install autoparse
   29  gem install byebug -v 2.3.1
   30  gem install multipart-post -v 1.2.0
   31  getm install faraday -v 0.8.8
   32  gem install faraday -v 0.8.8
   33  gem install jwt -v 0.1.8
   34  getm install jwt -v 0.1.8
   35  gem install launchy -v 2.4.2
   36  gem install signet -v 0.4.5
   37  gem install uuidtools -v 2.1.4
   38  gem install google-api-client -v 0.6.4
   39  cd ../cite_collections_rails
   40  ls
   41  cd config
   42  ls
   43  cp database.yml.sample database.yml
   44  vi database.yml
   45  ls
   46  cp config.yml.sample config.yml
   47  vi config.yml
   48  ls
   49  vi config.yml
   50  ls
   51  cd ../
   52  ls
   53  gem install mysql
   54  gem install ruby-mysql

cd cite_collection_rails
bundle install


mkdir ~/catalog_errors
##########

update procedure

cd cite_collections_rails
rake catalog_pending_import type="all" [ first load ]
rake catalog_pending_import type="latest" [ subsequent ]


cd perseus_catalog
bundle exec rake parse_records file_type='atom' rec_file='/home/ubuntu/FRBR.feeds.20150608'

#TO TEST
curl http://localhost:8080/solr-4.5.1/db/dataimport?command=full-import&clean=false

# dump mysql
# reload on catalog0.perseus.tufts.edu
# rerun solr import on catalog0.perseus.tufts.edu
# atom feeds


