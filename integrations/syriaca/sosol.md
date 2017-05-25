# SoSOL Implementation Details for Syriaca.org

## Perseids and SoSOL
The Perseids platform is composed a network of loosely coupled tools and services.  The Syriaca.org/Perseids integration relies only upon 2 of components of the Perseids platform: SoSOL and [Flask GitHub Proxy](flaskgithubproxy.md).

SoSOL is a Ruby on Rails application backed by Git and mySQL that was originally written for the Papyri.info project and extended by Perseids for its own use.  As of the time of this writing, the Perseids main line of development on SoSOL can be found in the ['perseids-production'](https://github.com/sosol/sosol/tree/perseids-production) branch of the SoSOL git repository. Eventually the Perseids changes may be merged back into the master branch. We try to keep the perseids-production branch up to date with the changes made to master to facilitate this eventuality.

For a more complete description of the Perseids Platform architecture and components see Almas, B., (2017). Perseids: Experimenting with Infrastructure for Creating and Sharing Research Data in the Digital Humanities. Data Science Journal. 16, p.19. DOI: [http://doi.org/10.5334/dsj-2017-019](http://doi.org/10.5334/dsj-2017-019).

## Data Model
### Publications and Identifiers
Data publications produced on SoSOL are collections of related data objects of different types. The _Publication_ is the container for a collection of data objects belonging to a parent abstract class of _Identifier_. Different type object types are implemented as derivations of the _Identifier_ class, which add type-specific behaviors and properties, such as schema validation rules.

For Syriaca.org we have added 3 new _Identifier_ derived classes to SoSOL:

_SyriacaIdentifier_ - For Gazetteer Records

_SyriacaPersonIdentifier_ - For Biographical Dictionary Records

_SyriacaWorkIdentifier_ - For Hagiographic Work Records

The _SyriacaPersonIdentifier_ and _SyriacaWorkIdentifier_ classes are themselves derivations of the base _Syriaca_ class, inheriting all behaviors, overriding only descriptive attributes and the path used when sending data to the remote Syriaca.org GitHub repository.

The class diagram below shows the methods and attributes that the _SyriacaIdentifier_ class overrides from the base _Identifier_ class. 

![Model Classes](https://github.com/perseids-project/perseids_docs/blob/master/integrations/syriaca/perseidssyriacamodels.png?raw=true)

The _SyriacaIdentifier_ class delegates the process of validating the TEI XML documents to JRubyXML:SyriacaGazetteerValidator. This class specifies the location of the RNG schema used to validate the documents and uses a Saxon processor to perform the validation. 

### Boards and Communities

### Agents

## Controllers and Views

![Controllers and Views](https://github.com/perseids-project/perseids_docs/blob/master/integrations/syriaca/perseidssyriacacontrollerviews.png?raw=true)

## Deployment External Dependencies
* XSLT

## Runtime External Dependencies
* RNG Schema
* Srophe Post Processing Service
* Flask GitHub Proxy
