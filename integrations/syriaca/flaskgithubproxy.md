# Flask GitHub Proxy

Authors:
* Thibault Clérice @PonteIneptique
* Bridget Almas @balmas

## Overview

The [Flask Github Proxy](https://github.com/PonteIneptique/flask-github-proxy) (FGP) is a middleware service  that offers a simple  means to transmit data from a web application to a GitHub data repository. FGP takes advantage of traditional distributed git workflows, enabling human verification of proposed changes made to a mirror repository through pull requests. 

FGP is designed for use with third party applications that operate on data and want to be able to contribute or return that data to GitHub repositories without being granted write privileges.  The FGP provides a simple API through which applications can submit data via RESTful requests, and FGP handles the more complex interactions with the GitHub API. The FGP provides a technical benefit by reducing the effort needed for client applications wishing to take advantage of complex GitHub workflows.

Coupled with an application like Perseids that provides a full editorial board-based review workflow, it allows for a variety of different data life cycles. Teams of scholars can work collaboratively on proposed changes to data, or new data sets.,Once agreement is reached, Perseids uses the FGP to send data to GitHub repositories where the data curator or web maintainer can then control the regularity of data change by approving the third-party upgrade. 

![FGH Sequence](https://github.com/perseids-project/perseids_docs/blob/master/integrations/syriaca/flaskgithubproxy.png?raw=true)

FGP is meant to be used as a web service behind firewalls, ie. FGP should never be accessible by the public but instead  act as an hidden service behind multiple applications. The application is built as a Flask extension and blueprint creator, Flask being a popular light python web framework that enables rapid development of  web applications. It has the simplest input data model possible and offers a strong error handling system reproducing messages that can arise from github API communications. It has built in methods that allow for direct communication with GitHub which per se allows for other development. It can also operate directly on the target repository if the mirror repository workflow is not needed. 

## Configuration for Syriaca and Perseids

Perseids currently runs FGH in production through the Apache mod_wsgi module. The configuration used (excluding private keys and local paths) is provided below.

app.wsgi
```
import os
import sys

sys.path.append('<path_to_root_of_deployed_fgh_application_code>')

from flask import Flask
from flask_github_proxy import GithubProxy
from flask_github_proxy.models import Author

application = Flask("name")
proxy = GithubProxy(
    "/perseids_syriaca",
    "perseids-proxy-user/srophe-app-data",  # /perseids/push/path/to/file
    "srophe/srophe-app-data",
    secret="<secret_key_exchanged_between_perseids_and_fgh>",
    token="<private_github_api_oauth_key_for_PerseidsProxy_github_user>",
    app=application,
    origin_branch="master",
    default_author=Author(
        "Github Proxy",
        "perseids-proxy@github.com"
    )
)
```

Apache config

```
<VirtualHost *:80>
  ServerName fgh.perseids.org

  ## Vhost docroot
  DocumentRoot "<path_to_root_of_deployed_fgh_app.wsgi>"

    <Directory "<path_to_root_of_deployed_fgh_app.wsgi>">
    AllowOverride None
    Require all granted
  </Directory>

  ## Logging
  ErrorLog "/var/log/apache2/fgh-gh_error.log"
  ServerSignature Off
  CustomLog "/var/log/apache2/fgh-gh_access.log" combined

  ## Header rules
  ## as per http://httpd.apache.org/docs/2.2/mod/mod_headers.html#header
  Header set Access-Control-Allow-Origin '*'
  Header set Access-Control-Allow-Headers 'Origin, X-Requested-With, Content-Type, Accept'
  WSGIDaemonProcess fgh python-path=<path_to_python_virtual_env_directory_with_fgh_code_and_deps>/lib/python3.4/site-packages
  WSGIProcessGroup fgh
  WSGIScriptAlias /flask-github-proxy "<path_to_root_of_deployed_fgh_app.wsgi>/app.wsgi"
</VirtualHost>                            
```

Perseids configuration in agents.yml

```
:agents
 :syriaca_github:
    :uri_match: "https://github.com/srophe/srophe-app-data"
    :type: "github"
    :post_url: "http://fgh.perseids.org/flask-github-proxy/perseids_syriaca/push/<PATH>"
    :timeout: 3600
    :client_secret: "<secret_key_exchanged_between_perseids_and_fgh>"
    :log_message: "<ID> Edited by <USER> via Perseids."
```

## Future Directions
A desireable enhancement to FGP would be to further enable its reuse, by enhancing the documentation and the ease with which it can be configured. Currently, each time a project needs to be added to the FGP system, an administrator or a developer must make a change to the python driver code. We want to remove this limitation by backing FGP with a small database system allowing for repositories to be managed using its own API.

For example,  a department might host FGP as a microservice for a set of its own web applications. Right now, adding a new destination repository requires touching code and restarting the service. What we propose is that each client application can, through secured methods, add or delete target data repositories to FGP through a simple API.

For sustainability, we need to ensure that the code works through the use of unit tests and workflow tests. If wished for, it could be accompanied by a simple client library to reuse FGP in the context of Python (web) applications..
