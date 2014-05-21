# Welcome Perseids Developer
This document will help new Perseids developers...

* navigate the Perseids source code.
* learn documentation conventions.
* learn how to better communicate with the development team and our users.

Included at the end of the document are general tips for development and debugging.

# Documentation Guidelines
## Inline documentation of functions
Please document the following for all functions you write.

* arguments/parameters and their types.
* return value and type
* Use: Is there is a certain way a function must be called?
     * Instantiating a new instance of a class with the 'new' keyword or not in Javascript for instance.

see examples below.

    /**
     * Return a timestamp with a UTC offset
     *
     * @param { boolean } _milli include milliseconds
     * @return { string } timestamp with UTC offset
     */
    TimeStamp.prototype.withUtc = function( _milli ) { ... }

    /**
     * Takes TEI xml and creates HTML useable by the bodin plugin
     *
     * Use:
     *   to_bodin = new TeiToBodin( 'xml/tei.xml', 'tei' );
     *
     * @param { string } _url The url to the TEI xml
     * @param { string } _id The id of the DOM object to write HTML output
     * @return { TeiToBodin }
     */
    function TeiToBodin( _url, _id ) { ... }

## 'Feature' documentation
Features are defined as distinct tools within a parent application.
If a feature has its own repository its documentation should be written in README.md in the repository's root.
If a feature does not have its own repository then it should be documented in this file under the heading "Perseids Features".
Documentation must inlclude.

* its official name and any nicknames it has acquired in its lifetime
* its purpose
* views where it is used
* file paths to the source code
* URLs to required APIs
* URLs or paths to required 3rd party software and services

## Install documentation
Install documentation should be considered the first step to a completely automated install script.
Installation documentation should be written in INSTALL.md in the repository's root.
Installation of software through a GUI should be avoided if possible.
All shell commands used in the installation process should be documented and perhaps later edited for simplicity and "copy and pasteability."
If possible install your software on a fresh OS so all software dependencies will be confronted.
Document the preferred OS and specs.
Document all OS and major system specs where the software has been successfully installed.
Keep track of the time required to successfully complete the installation and document it at the top of INSTALL.md.

See INSTALL.md in this repository for an example.

# Issue tracking
We use issue tracking in Github.
If issues belong exclusively to a particular Perseids feature and that feature has its own code repository then use that repository's issue tracker.
If an issue does not belong exclusively to one feature, or that feature does not have its own repository, then use this repository's issue tracker.

There are two kinds of issues.  Developer reported and user reported.  Developer reported issues are usually short reminders to fix a problem you have personally experienced.  That's OK if you plan on fixing the problem yourself.  If you cannot fix the problem yourself you should consider yourself a user, and you need to write a more complete issue report.

When reporting an issue as a user please gather the following information.

* URL
* error message ( if any )
* description of the problem
* screenshot ( if applicable )
* browser & version
* operating system

TODO: How to gather this info on popular platforms

# Perseids Features
## CTS Selector aka Publication Selector
Explore publication metadata in an eXist database to select texts available for editing in Perseids.

### Importance
* Critical

### Where it's used.
* Perseids: user/user_dashboard

### Source
* config/application.rb 
* lib/cts.rb
* app/controllers/cts_proxy_controller.rb
* app/controllers/cts_publications_controller.rb
* public/javascripts/perseids-pages.js
* app/views/publication/_cts_selector.haml
* app/models/repository.rb
* app/models/publication.rb

### Services and APIs
* eXistDB

### Configuration
See INSTALL.md under the heading "Prepare the inventory files".

# Tips
## Simple SQLite Database Interaction
Install sqlite3

	sudo apt-get install sqlite3

Go to the database directory

	cd /usr/local/sosol/db

Open the development or test databases

	sqlite3 development.sqlite3
	sqlite3 test.sqlite3

Some quick and dirty commands

	sqlite> .tables
	sqlite> .dump [table]
	sqlite> .exit

## Logging and Debugging
### Rails quirks
Want to output to the console from an .rb file inside your lib directory? "puts" doesn't cut it.

    Rails.logger.info "Hey!!! I'm in lib"

### Tail your development log

    tail -f /usr/local/sosol/log/development.log

Here's a way of hiding debug output.

    tail -f /usr/local/sosol/log/development.log | awk '/:start:/,/:end:/'

That command will ensure that only text wrapped in :start: and :end: will be displayed.

    Rails.logger.info ':start:'
    Rails.logger.info 'message'
    Rails.logger.info ':end:'

