# Information about the data
This is a very early exploration of how Perseids might serialize the 
data produced by students in Marie-Claire Beaulieu's
Journey of the Hero Class. 

Some of the things that we still need to work out:

1. whether we will use CTS style URIs to identify the targets of the annotations, as I have in this sample right now (e.g. `http://data.perseus.org/citations/urn:cts:pdlrefwk:smith.bio.diomedes-1:1%402.559%5b1%5d`), or if we will retain the OA TextQuoteSelectors as passed by Hypothesis -- whether as-is or converted to operate on the source XML. The OA TextQuoteSelectors look like:
`"selector": [
                {
                    "type": "RangeSelector", 
                    "startContainer": "/div[3]/div[2]/div[3]/div[2]/div[1]/div[1]/p[1]", 
                    "endContainer": "/div[3]/div[2]/div[3]/div[2]/div[1]/div[1]/p[1]", 
                    "startOffset": 614, 
                    "endOffset": 619
                }, 
                {
                    "start": 2237, 
                    "type": "TextPositionSelector", 
                    "end": 2242
                }, 
                {
                    "type": "TextQuoteSelector", 
                    "prefix": "Epidaurus, Aegina, and Mases. (", 
                    "exact": "2.559", 
                    "suffix": ", &c.) In the army of the Greeks"
                }
            ]
`

2. Exact ontology terms for the annotation motivations
3. Exact form and ontologies for the person relationship annotations will take. Per email discussion with Hugh, the target of these annotations should probably be the section of text from Smith's that contains the assertion of the relationship. And the body of the annotation would be a named graph containing the set of statements describing the relationship (e.g. as in the namedgraph.rdf/trig/ttl files in theis directory). 
4. Exact serialization format of the data as stored in Perseids. I think most likely we will actually use JSON-LD for this, rather than RDF/XML.  This should not be crucial to the analysis of how this data needs to be modeled for ingest into GapVis.





