# Information about the data
This is sample data produced by student's in Marie-Claire Beaulieu's
fall 2013 Mythology Class.  Students were asked to follow the instructions
in the [PerseidsDataGuidelinesforTimeMapperSpreadsheets.pdf](https://github.com/PerseusDL/GapVis-eids/raw/master/samples/data/perseids/timelines/PerseidsDataGuidelinesforTimeMapperSpreadsheets.pdf).

# How it might be used in a GapVis visualization
Although the data was originally prepared by the students to support
their timeline projects, the idea behind preserving it in this format
and use of the stable identifiers where possible for the targets and 
bodies of the annotations is that the data itself could live beyond
any particular timeline display and be used to curate and enhance the
resources being targeted.

Not all of the annotations will be easily integratable in a GapVis display.
I think we should focus to start on those which 
target Perseus texts as identified by cts urn in the data.perseus.org urispace.
The Annotation with the id of 
`http://data.perseus.org/collections/urn:cite:perseus:pdlann.141.1#1-1`
in [pdlann.141.1](https://github.com/PerseusDL/GapVis-eids/blob/master/samples/data/perseids/timelines/pdlann.114.1.xml) is an example of such an annotation.  

On their own these annotations may not amount to much of an interesting 
visualization, but a view which aggregates all of the annotations (from this project
as well as others) on any given text passage might be.

I was envisioning that all of these annotations would be loaded into a triple
store and then be queryable by target resource (among other things).  
This is the same type of query that we use right now to present the student
commentaries in Perseus using the [PerseusLD](https://github.com/PerseusDL/perseusld) widget.

The TEI XML for a targeted section of text (i.e. the object of the oa:hasTarget triple)
will be retrievable from a Perseus CTS API endpoint.  Currently the `http://data.perseus.org/citations/urn:cts:..` 
uris are served by by the P4 hopper which is unreliable but for the purposes of this project we should
assume that any text targeted for visualization in GapVis will be available from a
reliable CTS API and will return a valid TEI XML document containing the referenced passage in a manner that adheres to the [CTS 5.0.rc.1 specification](http://www.homermultitext.org/hmt-docs/specifications/cts/).

The resources which are the bodies of the annotations in this timeline dataset vary from timeline to timeline but
include [Pleiades Place URIs](http://pleiades.stoa.org/), images of Artifacts, dates, etc. as 
described in the student instructions.

## Notes
The other thing we have talked about doing here is updating these annotations to also target the 
subject mythological character in the Smiths dictionary, but I will talk about that more under the Smith sample
data sets.





