# Perseids/Pelagios Integration

## Overview

The Perseids SoSOL environment (code in the perseus_shibboleth branch of the SoSOL GitHub repo) currently (Feb 2014) supports annotations in a couple of different ways: 

1. SoSOL model class `cts_oac_identifier`: a single OA RDF/XML document associated with a text managed by the SoSOL instance.  The annotation document contains a set of one or more simple (URIs only) annotations that:
    * are created/updated by multiple annotators
    * target passages within the associated text by CTS URN
    
2. SoSOL model class `commentary_cite_identifier`: these are objects in a CITE collection of commentary objects, where each object 
    * is a single annotation expressed in OAC RDF/XML 
    * the annotation target can be any URI or URIs 
    * the body is embedded in the annotation using the [CntAsText](http://www.openannotation.org/spec/core/core.html#BodyEmbed) formalism
    * an optional maximum length on the body can be enforced at the level of the CITE collection

For the toponym annotations created through the Pelagios API, we would probably want to use the first approach (via the cts_oac_identifier) model class, either mixed in with the rest of the annotations of this type for a text, or in a separate toponym annotation document (the latter would require a little more preparation work on the Perseids/SoSOL side).

## Integration Options

1. via SoSOL RESTful API see (Alpheios Integration)[https://github.com/PerseusDL/perseids_docs/wiki/Data-management-module#wiki-sample-integration-using-csrf-token]

2. via [HTML form POST](http://www.gliffy.com/go/publish/5374746)
