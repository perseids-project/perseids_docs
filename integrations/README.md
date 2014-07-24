# Overview

The Perseids Platform is built on a loose coupling of tools and services to provide a platform for collaborative editing and annotation of texts.  An overview of the goals, design methodology and status and future plans as of July 2014 can be found [here](https://docs.google.com/presentation/d/1syZDt4CGXqBgvM7grJctldd0krgneTBFr7FaEO_e8YA/pub?start=false&loop=false&delayms=3000).

A git repository sits at the bottom of the Perseids application stack. Git provides versioning support for all documents, annotations and other related objects managed on the platform.  Git forks, branches and merges are used to manage concurrent access to the same documents and related objects by different users and groups.

Next is in the stack is the Son of SUDA Online application (SoSOL), a Ruby on Rails application which serves as a workflow engine on top of Git. It manages interactions with the git repository and provides additional functionality, including a user model, document validation, templates for documentation creation, review boards and communities. SoSOL uses a relational database to store information about document status and to track the activty of users, boards, communities.

SoSOL uses the OpenID and Shibboleth/SAML protocols to delegates responsibility for user authentication to social or institutional identitiy providers. Social identity providers are supported through a 3rd party service, Janrain Engage.  Shibboleth/SAML providers can be configured on a one-on-one basis, or via agreement with a federation.

The Perseids deployment of SoSOL also delegates some functionality to external databases and services. It calls on an implementation and extension of a CTS API, deployed in the eXist-db XML repository to support working with document fragments that can be addressed using a canonical citation scheme. It also interacts with helper services for tokenization and retrieval of remote resources. 

The SoSOL application itself provides lightweight user interfaces for creating and editing documents and annotations, but in order to support an open-ended set of different editing and annotation activities, we rely on integrations with external web-based tools for editing and annotating, via RESTful interactions between the tools and the SoSOL application.

There are two main approaches supported for integrating an external tool with SoSOL:

1. directly via the RESTful APIs of the external tool and SoSOL
2. by deploying the tool as a plugin on the Arethusa framework

Currently user session sharing and management between external tools and SoSOL can supported through the use of CSRF tokens.  Future plans include support for OAuth and/or JWT.

# Supported Document Types

# Adding a Document Type

## Prerequisities

1. identifier scheme
2. access to a "catalog" service for the document
3. validation requirements


# Integrating an External Editor


