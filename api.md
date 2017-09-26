## Using the API

### Swagger API Description 
The Perseids Swagger API description is at

[https://sosol.perseids.org/sosol/apidocs](https://sosol.perseids.org/sosol/apidocs)

As reported in the swagger docs, the API endpoint is actually at

[https://sosol.perseids.org/sosol/api/v1](https://sosol.perseids.org/sosol/api/v1)

The API itself accepts XML and JSON (depending upon the call), but returns JSON.

Clients calling the API must include at least the following HTTP headers for all requests:

### HTTP Request Headers

Sending JSON:

```
Accept: application/json
Content-Type: application/json
```

Sending XML:

```
Accept: application/json
Content-Type: application/xml
```

The API is protected via OAUTH. The [AuthorizationCodeFlow](http://tools.ietf.org/html/draft-ietf-oauth-v2-22#section-4.1) is the one we’re currently supporting, and using [AccessTokenScopes](http://tools.ietf.org/html/draft-ietf-oauth-v2-22#section-3.3). Clients interactions to POST documents require the "write" scope. (this is specified in the swagger docs)

You'll have to create a user account in Perseids to do your testing -- I think you have to do that first via the UI, and not during the OAUTH authorization interaction, because the first time you login you'll be asked to accept the terms, and I'm not sure if that will disrupt the interaction.

[  I can recommend using the swagger-ui client tool just as a quick way to experiment with the interactions - 
 -- you'll have to change the clientId and clientSecret variables in the index.html though )  I we have a test api client application for that client configured, it assumes you'll be running swagger-ui at `http://localhost/swagger-ui/dist`
 ]

Once you have successfully completed the OAUTH interaction and received a token for use in the Authorization header, then other calls are possible. 

See also the OAUTH Explanation topic later in this document for more details on how this this interaction works.

### Identifiers

#### EpiDoc Translations for EAGLE 

The Perseids API assumes that the client will provide information about the identifier for the item being posted.  The way this is is done is item-type specific.

For the EAGLE translations interaction, a work level cts urn should be supplied in an  element in an `idno` element in `publicationStmt` of the `teiHeader` of the EpiDoc xml that complies with the conventions we've agreed upon for EAGLE.  We currently support only TM or IDEST identifiers as work-level identifiers, and the URN should be composed as follows:

`urn:cts:pdlepi:eagle:tmXXXXX`

or

`urn:cts:pdlepi:eagle:idesXXXXX`

where XXXXX is replaced by the actual TM or ides identifier (the ides identifiers will start with t)

e.g.

`urn:cts:pdlepi:eagle.tm156145`
`urn:cts:pdlepi:eagle.idest00081`

### Posting Content

There are currently 2 ways to submit new EpiDoc translations (for integration with EAGLE):

1. as a JSON document
2. as an XML document

The first approach requires encoding XML as JSON, which isn’t so fun.  The second approach allows you to post the raw XML but you then need to make a 2nd API call to set the Community for the document.

Whichever approach you take, the result of the POST of the content is that it creates 2 new objects in Perseids, an "item" (aka identifier) and a publication to contain the item.  

Subsequent interactions, such as submissions to the EAGLE board, may require the publication_id. It’s a good idea to parse both from the response. 

#### Identifier Types

Regardless of which approach you take, you need to specify the identifier_type for your content.  Currently supported types are:

* EpiTransCTS  
* Syriaca 
* TreebankCite
* AlignmentCite

For EAGLE translations, use EpiTransCTS

#### Sending JSON

use a POST to https://sosol.perseids.org/sosol/api/v1/items, with a subset of the item model object containing the following 3 properties: type, content and publication_community_name

For EAGLE Translations:

"type" should be set to "EpiTransCTS" 
"publication_community_name" (this is project specific - for testing set to "APITests")
"content" should be set to the content of the EpiDoc XML encoded for the JSON property:


#### Sending XML

If encoding the EpiDOC as JSON gives you a headache, you can use the alternative API endpoint for POSTing XML:

`https://sosol.perseids.org/sosol/api/v1/xmlitems/EpiTransCTS`

set the Content-Type header to application/xml (and include the Authorization token, etc. as before)and send your XML document as the body of the request

e.g.

```
curl -X POST --header "Content-Type: application/xml" --header "Accept: application/json" --header "Authorization: Bearer 72563e4c99bd54dedc293bf65183398b60a1794af9eca7e006d6eb21dff48032" -d "<?xml version=\"1.0\" encoding=\"UTF-8\"?>..."
```

#### Response

A successful response from Perseids will be a completed version of the item object model

### Setting the Review Community 

If you use the JSON method to POST your content you identify review community in the create request.  But if you used the XML method, you will need to send a second request.  You will need parse the publication_id from the response of the xmlitem request and then issue a PUT request to 

`https://sosol.perseids.org/sosol/api/v1/publications/`

to update the publication and set the community_name field to the right one (e.g. EagleAPITests)

```
curl -X PUT --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer 72563e4c99bd54dedc293bf65183398b60a1794af9eca7e006d6eb21dff48032" -d "{ \"community_name\" : \"API Tests\" }" "https://sosol.perseids.org/sosol/api/v1/publications/51"
```

If it succeeds, you should get a 200 response confirming the change.

### Submitting to the Review Community

If you want your users to be able to refine the document within the Perseids interface, and submit it to the review community at their leisure, then your client app will not issue this request.  But if you want to submit content directly to the review board on behalf of the user, you can do this via the following API interaction:

A POST to 

`https://sosol.perseids.org/sosol/api/v1/publications/{id}/submit?comment=clientsuppliedsubmitcomment`

where `{id}` is the publication_id  of the document (as parsed from the response received from the initial post of the document to Perseids) and the comment is an explanatory text you want the review board to see along with the submission.

E.g.

```
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer a3430b88785fd704b2fab7ce6b7f873b26e220290cb8e6441be28f9713bfc1de" "https://sosol.perseids.org/sosol/api/v1/publications/13/submit?comment=%22Submitting%22"
```

If successful, you'll just get an empty 200 response.

### Accessing User Information

If you want to display user information about the Perseids user in a client app, you can retrieve that information via a GET to   `https://sosol.perseids.org/api/v1/user` . This is also an OAUTH protected call, with a "Read" scope.

### Important Notes
The API routes on the Perseids side may still change so if possible you should code your client to be able to read the swagger docs for the routes (because if they do change they'll be documented there)
Eventually all of the API interactions will be enforced as being under SSL. Currently you can access all of the API endpoints via both http and https but you can’t mix and match, and the apidocs only report the https urls.

### OAUTH Explanation
The basic OAuth2 flow we're using is this one:

[http://tools.ietf.org/html/draft-ietf-oauth-v2-22#section-4.1](http://tools.ietf.org/html/draft-ietf-oauth-v2-22#section-4.1)

In this diagram, Perseids/SoSOL is the Authorization Server, your app is the Client and the end-user is the Resource Owner. This diagram doesn't show the full picture of the interaction though, because Perseids (SoSOL) is itself delegating authentication via Oauth (or really, OpenID Connect) to an external authentication server.

The interaction we're trying to support here is that client app gets a token from Perseids which allows it to act on behalf of an end user, and then uses that token when it issues the POST of a document to the user's account on Perseids.   The client app doesn't need to know anything about the user's account on Perseids, how they authenticate there, etc. All of that is between Perseids and the end-user.

The steps to accomplish this are as follows:

1. Client app issues a GET request to the oauth/authorize endpoint on Perseids, supplying the client id, the scope requested (in this case 'write' for access to write a new document) and the redirect_uri at the client to which the browser should be sent to after authentication succeeds. A state parameter can be used for extra security, it's not absolutely required (you can find more on that in the doc linked above). E.g.

```
https://sosol.perseids.org/sosol/oauth/authorize?response_type=code&redirect_uri=http%3A%2F%2Flocalhost%2Fswagger-ui%2Fdist%2Fo2c.html&realm=your-realms&client_id=676bee8f0bb6ce65fb1bfdc9cf249bcebf7aa51bc22f7d95d0443bce9b54b0e8&scope=write&state=0.9918786573509284
```

2. Perseids SoSOL, acting as the authorization server, checks to see if the user has an active session (as might be the the case if they had logged in previously directly to Perseids).  If they don't, then they are redirected to a login page. SoSOL keeps in its session state the fact the user signin request was initiated as a result of an oauth interaction, including the client_id and the redirect_uri.  (Before it does this though it makes sure that the redirect_uri is one that is registered for the application with that client id).

3. The user logs in to SoSOL. This actually kicks off a whole separate OAuth chain, between SoSOL and the identity providers (Google, Yahoo, etc.) This isn't really of any concern to the client though.

4. After successful authentication at the identity provider, the browser redirects the user back to SoSOL, and then SoSOL redirects the user back to client app at the redirect_uri supplied in the initial authentication request. Included in the redirect back to the client is an authorization code, supplied in the code query param. 

5. The client app then issues a POST back to Perseids SoSOL, at the oauth tokenURL endpoint, supplying this code, the client_id, the client_secret, grant_type (authorization_code) and the redirect_uri that received the code. E.g.

```
curl 'https://sosol-test.perseids.org/sosol/oauth/token'  -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' --data 'client_id=676bee8f0bb6ce65fb1bfdc9cf249bcebf7aa51bc22f7d95d0443bce9b54b0e8&code=47384aaf2109326e77c064b7d15927a192280b68d5a6aca98996fce93f84a30d&grant_type=authorization_code&redirect_uri=http%3A%2F%2Flocalhost%2Fswagger-ui%2Fdist%2Fo2c.html&client_secret=0c2431329b79402f505adc74437935efdc80798ad50e84a7c3b7be3e15d5b0e6'
```

6. SoSOL verifies that the code was issued for the client that's requesting it, verifies the redirect_uri, client secret is correct, etc. and if all matches, it returns a token that can be used to access the SoSOL to write data on behalf of the authenticated enduser.

7.  At this point, the client app can issue a POST request to the Perseids API endpoint for creating new identifiers (https://sosol.perseids.org/sosol/items). It should supply the token it received in step 6 in an Authorization Header, identifying it as type Bearer:

e.g.

```
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer a3430b88785fd704b2fab7ce6b7f873b26e220290cb8e6441be28f9713bfc1de"  ....
```

SoSOL uses the token to gain access to the user's session and allow the client to operate on the user's behalf.

The Swagger Docs  specify the interaction as follows:

The security property on the \/items route says sosol_auth is the key into the security definitions object of the swagger docs, and that it requires a "write" scope

```

\/items": {
      "post": {
        "description": "Creates a new publication for the supplied data identifier type",
        "operationId": "createByIdentifierType",
        "tags": [
          "identifier"
        ],
        "parameters": [
          {
            "name": "content",
            "in": "body",
            "schema": {
              "$ref": "#\/definitions\/Identifier"
            }
          }
        ],
        "security": [
          {
            "sosol_auth": [
              "write"
            ]
          }
        ],
        "responses": {
          "201": {
            "description": "item create response",
            "schema": {
              "$ref": "#\/definitions\/Identifier"
            }
          },
          "default": {
            "description": "unexpected error",
            "schema": {
              "$ref": "#\/definitions\/ApiError"
            }
          }
        }
      }
    },
```

The sosol_auth key in the Security Definitions object says this is an oauth2 interaction, and provides the urls for the authorizationURL (step 1 above) and the tokenURL (step 5 above)

```
"securityDefinitions": {
    "sosol_auth": {
      "type": "oauth2",
      "authorizationUrl": "https:\/\/sosol.perseids.org\/sosol\/oauth\/authorize",
      "flow": "accessCode",
      "tokenUrl": "https:\/\/sosol.perseids.org\/sosol\/oauth\/token",
      "scopes": {
        "write": "modify identifiers in your account",
        "read": "read your user details"
      }
    }
  },
```
