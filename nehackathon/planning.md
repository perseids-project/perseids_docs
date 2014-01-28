## Dates

March 3-6, 2014 ([travel info](http://sites.tufts.edu/perseids/march-hackathon-named-entity-annotation/))

## Participants

_Perseus/Perseids_: Bridget Almas, Marie-Claire Beaulieu, Adam Tavares, Monica Lent, Maxim Romanov

_Pelagios_: Elton Barker, Leif Isaksen, Pau deSoto, Simon Rainer

_Pleaides_: Tom Elliot

_DC3_: Ryan Baumann, Hugh Cayless

_HMT_: Chris Blackwell, Neel Smith

## Pre-Hackathon Meetings

* [Doodle Poll](http://doodle.com/bs72sicawgs3k7qw)

## Goals

Perseids, SoSOL, Pelagios and Pleiades that allow people to make contributions (i.e. in the form of annotations), across projects. 


## Possible Integration Points

* Perseids/SoSOL Data Management API (WIP): https://github.com/PerseusDL/perseids_docs/wiki/Data-Management-Module
* Pelagios API?
* Pleiades API?

## Approaches for Integrating Perseids/SoSOL and Pelagios

* Manual: export/import of data by user
    * user exports XML text being edited on Perseids/SoSOL into Pelagios
    * user annotates toponyms in Pelagios
    * user exports OAC from Pelagios and uploads into Perseids/SoSOL

* User focused: common idea of user across both platforms 
    * e.g. user is able to request from Pelagios that their annotations be made available to Perseids and vice-versa
    * requires implementation of IAM components

* Tool-focused: use of Pelagios as front-end tool only with data retained on Perseids/SoSOL
    * e.g. see Alpheios editor integration, uses Perseids dmm_api to get/update annotations
    * current support in Perseids requires use of cxrf-token - future will use OAUTH

## Other integration possibilities

* submission of new place entities and/or corrections to Pleiades?
* ...
