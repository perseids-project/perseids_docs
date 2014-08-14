# Overview

The Perseids Platform is a loose coupling of tools and services providing a platform for collaborative editing and annotation of texts.  An overview of the goals, design methodology and status and future plans as of July 2014 can be found [here](https://docs.google.com/presentation/d/1syZDt4CGXqBgvM7grJctldd0krgneTBFr7FaEO_e8YA/pub?start=false&loop=false&delayms=3000).

At the bottom of the Perseids application stack, a Git repository provides versioning support for all documents, annotations and other related objects managed on the platform.  Git forks, branches and merges are used to manage concurrent access to the same documents and related objects by different users and groups.

Next in the stack is the [Son of SUDA Online application (SoSOL)](https://github.com/sosol/sosol), a Ruby on Rails application which serves as a workflow engine on top of Git. It manages interactions with the git repository and provides additional functionality including a user model, document validation, templates for documentation creation, review boards and communities. SoSOLalso uses a relational database to store information about document status and to track the activty of users, boards, communities.

SoSOL uses the [OpenID](http://openid.net/) and [Shibboleth/SAML](https://shibboleth.net/) protocols to delegates responsibility for user authentication to social or institutional identitiy providers. Social identity providers (IdP) are supported through a 3rd party gateway, currently [Janrain Engage](http://janrain.com/).  Shibboleth/SAML providers can be configured on a one-on-one basis, or via agreement with a federation.

The Perseids deployment of SoSOL also delegates some functionality to external databases and services. It calls on an implementation and extension of a [CTS API](https://github.com/alpheios-project/cts-api), deployed in an [eXist-db](http://exist-db.org/) XML repository to support working with document fragments that can be addressed using a canonical citation scheme. It also interacts with helper services for tokenization and retrieval of remote resources. 

The SoSOL application itself provides lightweight user interfaces for creating and editing documents and annotations, but in order to support an open-ended set of different editing and annotation activities, we rely on integrations with external web-based tools for editing and annotating, via RESTful interactions between the tools and the SoSOL application.

# Integrating an External Editor

There are two main approaches supported for integrating an external tool with Perseids SoSOL:

1. directly via the [RESTful APIs](http://en.wikipedia.org/wiki/Representational_state_transfer) of the external tool and SoSOL
2. by deploying the tool as a plugin on the Arethusa framework

Currently user session sharing and management between external tools and SoSOL can supported through the use of CSRF tokens.  Future plans include support for OAuth and/or JWT.

The diagram at [http://www.gliffy.com/go/publish/6058562](http://www.gliffy.com/go/publish/6058562) shows the sequence of interactions between Perseids SoSOL, a Social IdP gateway, a Social IdP and an external Javascript based web application. The Social IdP provides the user with secure access to their credentials, SoSOL manages version history and business logic related to individual documents (e.g. identification of available tools for editing), the Web application provides an editing/annotating UI for a given document type.

Any web application can be integrated with Perseids SoSOL in this method.  However the [Arethusa Framework](https://github.com/latin-language-toolkit/arethusa) which is already integrated with Perseids SoSOL provides an alternate approach. Arethusa core libraries handle the details of interacting with SoSOL for documents and related user data, and custom editing interfaces can be developed as javascript-based plugins for Arethusa.

TODO link to documentation on Arethusa ....

# Supported Document Types

# Adding a Document Type

## Prerequisities

1. identifier scheme
2. access to a "catalog" service for the document
3. validation requirements





