This document outlines ideas for future directions for Perseids, as of September, 2017.

## Taking Full Advantage of the Collections Service 

We have deployed and integrated the [Perseids Manifold Collections Service](https://github.com/RDACollectionsWG/perseids-manifold) implementation of the [RDA Collections API](https://github.com/RDACollectionsWG/specification) with Perseids.  
Expanding upon this implementation to provide complete support for managing and sharing data produced on Perseids as 
persistently identified, machine-actionable data throughout its lifecycle would be an ideal next step to take advantage of 
the groundwork that has beed laid in this area.

The use of the Collections Service is intended to support management of the data collection lifecylcle on Perseids as 
outlined below:

![Perseids Data Collection Lifecyle](workflows/perseidsdatacollectionlifecycle.png)

With the goal of eventually being able to support the following sorts of queries against all data created on Perseids:

* All data created by User X
* All data approved by Community X
* All treebank data for Homer’s Iliad Book 1 Lines 1-10
* All translation alignments of Homer’s Iliad Book 1, Lines 1-10
* All semantic annotations on Vergil’s Aeneid Book 1
* And so forth….

So far, just the following portion of the lifecycle support is implemented:

![Implemented Workflows](workflows/perseidscollectionsimplemented.png)

The full goal for the Collection Service was to combine it with other RDA outputs, the PID Types API and the 
Data Types Registry, as well as a Handle Service to provide a means for persistent identification of all publications 
produced on Perseids as machine-actionable data objects adhering to standard, community accepted data types. This might 
require an interaction something like the following upon publication creation:

![Perseids With RDA Outputs](workflows/perseidspiddtrcollection_createnewitem.png)

The [RPID Test Bed](https://rpidproject.github.io/rpid/) could be used to experiment with the viability of such an approach.

Another avenue possibly worth pursuing here is leveraging the LDP model we have used for the annotations in the Perseids Manifold Collections service to facilitate their preservation in Fedora, which uses LDP for its collections as well.

