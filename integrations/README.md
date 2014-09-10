# Overview

The Perseids Platform is a loose coupling of tools and services providing a platform for collaborative editing and annotation of texts.  

At the bottom of the Perseids application stack, a [Git](http://git-scm.com/) repository provides versioning support for all documents, annotations and other related objects managed on the platform.  Git forks, branches and merges are used to manage concurrent access to the same documents and related objects by different users and groups.

Next in the stack is the [Son of SUDA Online application (SoSOL)](https://github.com/sosol/sosol), a [Ruby on Rails](http://rubyonrails.org/) application which serves as a workflow engine on top of Git. It manages interactions with the git repository and provides additional functionality including a user model, document validation, templates for documentation creation, review boards and communities. SoSOLalso uses a relational database to store information about document status and to track the activty of users, boards, communities.

SoSOL uses the [OpenID](http://openid.net/) and [Shibboleth/SAML](https://shibboleth.net/) protocols to delegate responsibility for user authentication to social or institutional identitiy providers. Social identity providers (IdP) are supported through a 3rd party gateway, currently [Janrain Engage](http://janrain.com/).  Shibboleth/SAML providers can be configured on a one-on-one basis, or via agreement with a federation.

The Perseids deployment of SoSOL also delegates some functionality to external databases and services. It calls on an implementation and extension of a [CTS API](https://github.com/alpheios-project/cts-api), deployed in an [eXist-db](http://exist-db.org/) XML repository to support working with document fragments that can be addressed using a canonical citation scheme. It also interacts with helper services for tokenization and retrieval of remote resources. 

The SoSOL application itself provides lightweight user interfaces for creating and editing documents and annotations, but in order to support an open-ended set of different editing and annotation activities, we rely on integrations with external web-based tools for editing and annotating, via RESTful interactions between the tools and the SoSOL application.

See Also: [Infrastructure for Digital Humantities - an overview of the Perseids goals, design methodology and status (July 2014)](https://docs.google.com/presentation/d/1syZDt4CGXqBgvM7grJctldd0krgneTBFr7FaEO_e8YA/pub?start=false&loop=false&delayms=3000).

# Use Cases for Integration with/Extension of Perseids

The following are typical scenarios motivating extension of or integration with the Perseids platform:

* support for a new identifier/document type 
* support for a new type of stand-off annotation for an existing identifier/document type
* use of an existing editing or annotating interface with documents managed by the Perseids platform
* use of the SoSOL review workflow component of the Perseids platform with a 3rd party site

Each of these scenarios requires a slightly different set of developer skills and approaches as described further below.

# New Identifiers/Document Types

The Perseids SoSOL deployment currently supports working with the following types of documents:

* Texts and Translations encoded in [EpiDoc](http://www.stoa.org/epidoc/gl/latest/) compliant TEI-XML
* Commentaries on texts and other linkable targets (adhering to the [Open Annotation](http://www.openannotation.org/spec/core/) data model)
* Annotations on texts and other linkable targets (adhering to the [Open Annotation](http://www.openannotation.org/spec/core/) data model)
* Treebank/Morpho-syntactic Annotations adhering the [Perseus Ancient Language Dependency Treebank](http://nlp.perseus.tufts.edu/syntax/treebank/) schema
* Translation Alignment Annotations adhering to the [alpheios.net](http://alpheios.net) [alignment schema](http://sourceforge.net/p/alpheios/code/HEAD/tree/xml_ctl_files/schemas/trunk/aligned-text.xsd).
* Collections of Images

Publications can consist of combinations of one or more of the above types of documents.

Perseids uses [CTS URNs](http://www.homermultitext.org/hmt-docs/specifications/ctsurn/) as stable identifiers for primary source texts and CITE URNs Commentaries, Annotations and Images.

Adding support for additional document types and/or stable identifier types is possible. This requires a clearly defined and consistent stable identifier syntax for the document type and extension of the base Identifier class (in [Ruby](http://rubyonrails.org/)) to implement the business logic for the identifier and document type, including specification of a schema against which the document can be validated, if desired. 

_Developer Skills required:_ Ruby, XML, XSLT, Javascript, RDF 

# Integrating an External Editing/Annotating User Interface

There are two main approaches supported for integrating an external tool with Perseids SoSOL:

1. directly via the [RESTful APIs](http://en.wikipedia.org/wiki/Representational_state_transfer) of the external tool and SoSOL
2. by deploying the tool as a plugin on the Arethusa framework

Currently user session sharing and management between external tools and SoSOL can supported through the use of CSRF tokens.  Future plans include support for OAuth and/or JWT.

### Direct Integration between SoSOL and External Web Application
This [diagram](http://www.gliffy.com/go/publish/6058562) shows the basic sequence of interactions between Perseids SoSOL, a Social IdP gateway, a Social IdP and an external web application. In this example interaction, the Social IdP provides the user with secure access to their credentials, SoSOL manages version history and business logic related to individual documents (e.g. identification of available tools for editing), the Web application provides an editing/annotating UI for a given document type.

See the [Perseids Data Management Apis](https://github.com/PerseusDL/perseids_docs/wiki/Data-management-module) for further details on available API calls for external web applications.

_Developer Skills required:_ Understanding of RESTful APIs, plus whatever knowledge is required for development of the external web application

## Developing a new Arethusa UI Plugin
The [Arethusa Annotation Framework](https://github.com/latin-language-toolkit/arethusa) has been integrated with Perseids SoSOL to provide an alternative, more fluid user experience for working with annotations of multiple types on a single document or set of documents. 

Arethusa is built on the [angular.js](https://angularjs.org/) javascript web application framework and provides a back-end independent plugin infrastructure for accessing texts, annotations, linguistic services from a variety of sources. Arethusa leverages javascript APIs and HTML templates, as well as command line tools for automatic generation of plugin skeletons, to make it very easy for developers with HTML 5 and Javascript skills to customize the platform and add additional features.

Arethusa acts as a broker between the SoSOL Perseids back-end (as well as other back-end datasources) and the front-end annotating and editing tools. Core Arethusa libraries handle the details of interacting with SoSOL for documents and related user data, and custom editing interfaces can be developed as javascript-based plugins.

The work involved in developing of a new Arethusa plugin can be more or less involved, depending upon the circumstance. The simplest type of plugin is an alternate editing interface for an already-supported document/annotation type. This would require developing:

* an HTML 5 template and associated CSS for the layout of the editing interface
* Javascript libraries defining event handlers and other implementation of business logic for the editing interface

A more complex type of plugin is one which provides not only a new editing interface, but also works with a new document type or format.  This would require developing:

* an HTML 5 template and associated CSS for the layout of the editing interface
* Javascript libraries to:
    * define event handlers and other implementation of business logic for the editing interface
    * retrieve annotation tokens and data from the source document(s) and make them accessible to the core Arethusa state object
    * persist annotation tokens and data from the core Arethusa state back into their original representation
    * listen for and react to actions of other components of the annotation environment 

This type of edition to the platform might also require comparable changes on the Perseids back-end, to support a new identifier/document type, as described above.  And it often involves data modeling work to consider implications of cross-document alignment and integration with other types of related resources.

The [Arethusa plugin developer's guide](https://github.com/latin-language-toolkit/arethusa/blob/docs/docs/content/plugin_guide.md) provides developers with detailed guidance on all of the above tasks.  

_Developer Skills required:_ Javascript, HTML5, CSS (Angular experience helpful but not essential), Understanding of RESTful APIs and linked data concepts.


# Integrating an external site with Perseids SoSOL Board/Community Review Workflow

Coming soon...




