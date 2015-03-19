Capitains 
===

## Current state
Capitains most important creation purpose is to serve CTS and expand its usage across DH and specifically in the classicist world. With that in mind, 3 different project's parts have emerged :
- [Capitains-Toolkit](https://github.com/PerseusDL/Capitains-Toolkit) provides both an abstraction in Python of the CTS norms (v3 and 5) and a suite of tools for API deployement (currently through xQuery)
- [Capitains-Sparrow](https://github.com/PerseusDL/Capitains-Sparrow) provides a Javascript abstraction of CTS API Endpoints and CTS, and a reference implementation in the form of jQuery plugins
- [Capitains-Nemo](https://github.com/PerseusDL/Capitains-Nemo) provides an AngularJS app built upon the Capitains Sparrow abstraction to browse (and almost certainly more in the future) CTS API data

## Abstraction, API and Tool questions
Right now, we can see some design issues in the way Capitains has been regrouping different goals in different repositories :
- Capitains-Toolkit contains a deployment tool, xquery files and some python abstraction. In my opinion, this should not be the case and xquery files and abstraction should be separated.
- Capitains-Sparrow contains jQuery plugins as well as javascript abstractions. jQuery plugin then must be updated for every change made in CTS, not caring about versioning, which might be a burden for already legacy plugins such as the jQuery Selector.
- Capitains-Nemo is in a good state for now.

It might be quickly needed to leave PerseusDL repository for a Capitains organization. This would still be labelled Perseus but if we want to build a strong community around those tools, it should be easy to know what is available and exploding repo such as Toolkit and Sparrow will have browsing/discovering consequences.

Comments from @balmas:
- agree with move to a separate repo
- can/should we pull the XQuery for from Capitains-Toolkit from the original source Alpheios repo? (https://github.com/alpheios-project/cts-api) ?  Ideally we would have some release/versioning in place for that as well...

## CTS Addon ?
The project has been enlarged again and again but always with the restriction of being limited by what CTS Specs offer. Through, as Capitains is meant to help convince people that CTS is great, and as use case grow faster than they should, it might be time for a Capitains-CTS-Addon, which would be optional to install, focus on existDB implementations for now, be potentially enlarged with BaseX and be a source of many collaborations.

Unlike the three first Capitains tools, I think this tool (or simply xQuery) will be interesting for other partners to spend technical time. Here are a list of potential functions :

- FullText Search
- Curated references (If this is not done by main CTS specs)
- ?

Comments from @balmas
- do we also want to consider the CTS-X extensions from Perseids, which include read/write features for CTS data (e.g PutPassage)?

## CTS XQuery Wrapper
Another part to work for would be to build an xQuery tunnel application which could take care, in REST manner OR in current ?request= manner, of querying the database, caching and allow enhancement on the scaling front.

