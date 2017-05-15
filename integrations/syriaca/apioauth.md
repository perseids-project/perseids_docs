# Srophe-Perseids API Exchanges

The Perseids API uses the [Swagger.io](swagger.io) protocol (aka OpenAPI 2.0) to provide machine-actionable documentation of its API functionality.

## Swagger API Description 
The Perseids Swagger API description is deployed at:

[https://sosol.perseids.org/sosol/apidocs](https://sosol.perseids.org/sosol/apidocs)

The soure for the controller code in the Perseids SoSOL application code for the swagger API documentation can be found at [https://github.com/sosol/sosol/blob/perseids-production/app/controllers/apidocs_controller.rb](https://github.com/sosol/sosol/blob/perseids-production/app/controllers/apidocs_controller.rb).

As reported in the swagger docs, the API endpoint against which operations occur is at:

[https://sosol.perseids.org/sosol/api/v1](https://sosol.perseids.org/sosol/api/v1)

[The source for the controller code for this version of the Perseids SoSOL api is at https://github.com/sosol/sosol/tree/perseids-production/app/controllers/api/v1](https://github.com/sosol/sosol/tree/perseids-production/app/controllers/api/v1). (See also the class diagram and discussion at [sosol.md](sosol.md).

## Syriaca.org Srophe client interactions with the Perseids SoSOL API

The swagger-ui [swagger-ui client tool](https://github.com/swagger-api/swagger-ui) offers a quick way to experiment with the interactions.  Perseids is setup to allow testing using a locally deployed version of the swagger-ui tool at `http://localhost/swagger-ui/dist`. To use this tool you will need to update the `clientId` and `clientSecret` variables set in the index.html.  You can get these from the Perseids site administrator.

### Prerequisites

#### OAuth2 Client
Most Perseids SoSOL API operations are protected via OAuth2. Your API Client must include OAuth2 Client support for the [AuthorizationCodeFlow](http://tools.ietf.org/html/draft-ietf-oauth-v2-22#section-4.1),  using [AccessTokenScopes](http://tools.ietf.org/html/draft-ietf-oauth-v2-22#section-3.3). Client interactions to POST documents to to the Perseids SoSOL API require the "write" scope, as specified in the swagger docs.

See also the OAuth2 Explanation topic later in this document for more details on how this this interaction works.

#### SSL
You should deploy your API client code at a SSL/TLS protected address.  SSL support is required for use of the Perseids API. (A temporary exception was made for Syriaca.org but this hole should be closed).

#### Register Perseids OAuth Client Application 
When you're ready to begin testing interactions with your own client application, you need to contact a Perseids site adminitsrator to register a new OAuth client application with Perseids. You will need to provide the address for your `authorize` callback at which time you will be given an API Client Id and API Client Secret. 

The addresses currently registered for the Syriaca.org Srophe Client Application are:

```
http://wwwb.library.vanderbilt.edu/exist/apps/srophe-admin/oauth   
http://wwwb.library.vanderbilt.edu/exist/apps/srophe-forms/oauth
```

(Perseids SoSOL uses the [Ruby Doorkeeper Gem](https://github.com/doorkeeper-gem/doorkeeper) to support its OAuth2 functionality. Doorkeeper adds controller routes under the /oauth prefix. (See also the class diagram and discussion at [sosol.md](sosol.md). This functionality is currently restricted to users with admin access.)

### Create a Perseids User Account

Create at least one user account in Perseids SoSOL to do your development and testing.

### Create Communities

TODO describe the syriaca communities and setup procedures.

#### HTTP Request Headers

The API accepts both application/xml and application/json (depending upon the call), but always returns application/json.

Clients calling the API must include at least the following HTTP headers for all requests:


Sending application/json:

```
Accept: application/json
Content-Type: application/json
```

Sending application/xml:

```
Accept: application/json
Content-Type: application/xml
```

### Operations

1. Posting Content

Srophe uses `api/v1/xmlitems` API operation for POSTing the XML of documents to be reviewed and edited in Perseids.

`https://sosol.perseids.org/sosol/api/v1/xmlitems/{IdentifierType}`

The following are the supported values for the `IdentifierType` url parameter for Syriaca.org documents:

* Syriaca 
* SyriacaPerson
* SyriacaWork


The `Content-Type` header must be set to `application/xml` and the `Authorization` to the value of the Oauth2 Bearer Authorization Token. The XML document is sent as the body of the request. 

e.g.

```
curl -X POST --header "Content-Type: application/xml" --header "Accept: application/json" --header "Authorization: Bearer 72563e4c99bd54dedc293bf65183398b60a1794af9eca7e006d6eb21dff48032" -d "<?xml version=\"1.0\" encoding=\"UTF-8\"?>..."
```

If successful, Perseids returns the newly created item object model, as described in the swagger documents. E.g.

```
{
  "id": 9999999,
  "type": "Syriaca",
  "mimetype": "application/xml",
  "content": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>...",
  "publication": 10101010,
  "publication_community_name": ""
}
```

2. Setting the Review Community 

Because Srophe uses the `xmlitems` operation to create a new publication in Perseids, only document content can be posted and additional metadata must be set through a second API request.  Setting the metadata is necessary to set the name of the community to which a particular publication belongs so that it gets submitted to the right set of Syriaca editorial boards. 

The Srophe application parses the `publication` id from the response of the `xmlitems` request and then issues a PUT request to the `publications` PUT operation at:

`https://sosol.perseids.org/sosol/api/v1/publications/`

to update the publication and set the community_name field to the right one.

```
curl -X PUT --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer 72563e4c99bd54dedc293bf65183398b60a1794af9eca7e006d6eb21dff48032" -d "{ \"community_name\" : \"API Tests\" }" "https://sosol.perseids.org/sosol/api/v1/publications/51"
```

If successful, Perseids will return an empty response with the HTTP 200 status code to confirm the change.

3. Submitting to the Review Community

The Syriaca workflow currently calls for the Srophe app to submit the document on behalf of the user directly to the Syriaca community boards upon creation of a new publication in Perseids.  The initial editing/creation of the document is done solely in the Srophe app. This requires a 3rd API interaction, to submit the publication, via the following API interaction:

A POST to 

`https://sosol.perseids.org/sosol/api/v1/publications/{id}/submit?comment=clientsuppliedsubmitcomment`

where `{id}` is the publication_id  of the document (as parsed from the response received from the initial post of the document to Perseids) and the comment is an explanatory text the review board sees along with the submission.

E.g.

```
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer a3430b88785fd704b2fab7ce6b7f873b26e220290cb8e6441be28f9713bfc1de" "https://sosol.perseids.org/sosol/api/v1/publications/13/submit?comment=%22Submitting%22"
```

If successful, it returns an empty 200 response.

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

## Configuration Details

TODO - description of how the oauth credentials for the exchange are managed.
