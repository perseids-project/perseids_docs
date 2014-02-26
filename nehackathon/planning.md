## Dates

March 3-6, 2014 ([travel info](http://sites.tufts.edu/perseids/march-hackathon-named-entity-annotation/))

## Participants

_Perseus/Perseids_: Bridget Almas, Marie-Claire Beaulieu, Adam Tavares, Monica Lent, Maxim Romanov

_Pelagios_: Elton Barker, Leif Isaksen, Pau deSoto, Simon Rainer

_Pleaides_: Tom Elliot

_DC3_: Ryan Baumann, Hugh Cayless

_HMT_: Chris Blackwell (Remote), Neel Smith

[Bios](bios.md)

## Pre-Hackathon Meetings

* 2013-01-28 10am EST/3pm GMT 
* 2014-02-25 9am EST/2pm GMT

## Goals

The primary deliverable goals for the hackathon are:

1. definition of APIs for Perseids/SoSOL, Pelagios and Pleiades
2. documentation of example sequence interactions using those APIs
3. at least one of the documented interactions implemented as working code that  integrates Perseids, SoSOL, Pelagios and Pleiades to allow people to make contributions (i.e. in the form of annotations) across projects. 
4. agreement on provenance metadata requirements for sharing data across these projects

Secondary goals include:

1. addressing code pain points in any of the participating projects as time and resources permit
    1. [Isolated Task List](tasks.md)
2. discussing potential areas of further development of comment interest to all participants
3. making progress on reintegrating Perseids-related changes to SoSOL back into master and/or vice-versa

## Approaches Considered

### Integrating Perseids/SoSOL and Pelagios

1. Manual: export/import of data by user
    * user exports XML text being edited on Perseids/SoSOL into Pelagios
    * user annotates toponyms in Pelagios
    * user exports OAC from Pelagios and uploads into Perseids/SoSOL

2. User focused: common idea of user across both platforms 
    * e.g. user is able to request from Pelagios that their annotations be made available to Perseids and vice-versa
    * requires implementation of IAM components (on timeline for Perseids but not by March)

3. Tool-focused: use of Pelagios as front-end tool only with data retained on Perseids/SoSOL
    * e.g. see Alpheios editor integration, uses Perseids dmm_api to get/update annotations
    * current support in Perseids requires use of cxrf-token - future will use OAUTH

### Integrating with Pleiades

1. submission of new place entities and/or corrections to Pleiades?

## Selected Integration Approach for Hackathon

Per 2013-01-28 teleconference, we will aim for approach #3 for Perseids/SoSOL and Pelagios, the tool-focused integration. The Pelagios front-end uses a JSON-based API to talk to the back-end and Rainer thinks it should be feasible to deploy it on a Perseids server replacing its backend with SoSOL.  

For Pleaides, funding is not available for further API development by March, but we would like to aim for an export of data from Pelagios and Perseids/SoSOL that could be batch-uploaded to Pleiades.

Marie-Claire's Medieval Latin students will be the initial target users for the Pelagios/Perseids integration.

## Other Topics

1. Addressing JSON latency problems with Pleiades (so that awld.js can work without bringing down the site)
2. Addressing problems with POSTs from Pelagios to Pleiades
3. Exploring annotation requirements and implementations
4. Discussing bibliography needs and solutions
5. Enabling Pelatios toponym resolution as a standalone tool?
6. Discussing identifier schemes for epigraphical texts
7. SoSOL UI development strategies
8. ....

See also [Tasks](tasks.md)

## Schedule/Agenda

* Monday (convene at Perseus office: Eaton 134C for coffee @ 9-9:30; meeting starts in Eaton 123 @ 10:00)
    * Intros/Getting Organized Discussion
    * Review and adjustment of Pelagios/Perseids/SoSOL Integration plan
    * Review additional target tasks
    * Pick/assign tasks
    * Epigraphical Text Identifiers
    * Annotation Discussion
    * Elton and Leif in class with Marie-Claire
* Tuesday
    * Coding
    * Bibliography Discussion (~ 4pm)
* Wednesday
    * Regroup, review assignments, progress
    * Coding
    * SoSOL UI Development Strategies
    * Elton and Leif in class with Marie-Claire
    * Group Dinner
* Thursday
    * Regroup, review assignments, progress
    * Coding
    * Wrap-up, next steps discussion


## Completed Action Items
1. Bridget will distribute documentation on current [Alpheios-SoSOL](https://github.com/PerseusDL/perseids_docs/wiki/Alpheios-Integration) integration and current [SoSOL Data Management API](https://github.com/PerseusDL/perseids_docs/wiki/Data-Management-Module)
2. Rainer will review and provide feedback on Pelagios requirements

## Pending Action Items
1. Tom to distribute documentation on Pleiades input formats and provenance metadata requirements
2. Participants to add skill set info to [Bios](bios.md)
3. Participants to add ideas for isolated tasks to [Tasks](tasks.md)

