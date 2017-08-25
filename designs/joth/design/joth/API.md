API Draft for Vizualisation
===

## URIs 

data.perseids.org/socialNetwork/rest/network/SmithNetwork/ -> retrieve full graph for network named SmithNetwork

data.perseids.org/socialNetwork/rest/network/SmithNetwork/node/Diomedes-1 -> retrieve sub graph of relationships of Diomedes in graph SmithNetwork

data.perseids.org/socialNetwork/rest/network/SmithNetwork/node/Diomedes-1?getAnnotation


## Graph Network structure

```javascript
{
	"nodes" : [
		{
			"displayName" : "Diomedes",
			"uid" : "Diomedes-1",
			"link" : "http://data.perseus.org/people/smith:Diomedes-1",
			"properties" : {
				"isA" : ["man", "Philosoper"]
			}
		},
		{
			"displayName" : "Tydeus",
			"uid" : "Tydeus-1",
			"link" : "http://data.perseus.org/people/smith:Tydeus-1",
			"properties" : {
				"isA" : ["man"],
				"from" : ["Greece"]
			}
		}
	],
	"relationship" : [
		{
			"source" : "Tydeus-1",
			"target" : "Diomedes-1",
			"type" : ["sonOf"]
		}
	]
}
```

## Annotations informations

```javascript
[
	{
		"cite-urn" : "http://data.perseus.org/collections/urn:cite:perseus:pdlann.141.1/graph#1-rel-1",
		"title" : "Diomedes Article in Smith",
		"text" : "nigdpn bla bla bla"
	}
]

```