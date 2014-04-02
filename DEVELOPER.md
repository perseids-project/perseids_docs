# Welcome Perseids Developer
This document will help new Perseids developers to navigate the Perseids source code.
Major features of Perseids should, at a minimum, have source file paths, APIs, and other services they depend on listed.

Included at the end of the document are helpful more general tips and tricks for development and debugging.

# Perseids Features
## CTS Selector aka Publication Selector
Explore publication metadata in an eXist database to select texts available for editing in Perseids.

### Where it's used.
* user/user_dashboard

### Source
* config/applications.rb 
* lib/cts.rb
* app/controllers/cts_proxy_controller.rb
* public/javascripts/perseids-pages.js
* app/views/publication/_cts_selector.haml

### APIs and Services
eXist DB

# Tips and Tricks
## Rails quirks
Want to output to the console from an .rb file inside your lib directory? "puts" doesn't cut it.

	Rails.logger.info "Hey!!! I'm in lib"
