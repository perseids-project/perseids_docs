# SoSOL Implementation Details for Syriaca.org

## Perseids and SoSOL
The Perseids platform is composed a network of loosely coupled tools and services.  The Syriaca.org/Perseids integration relies only upon 2 of components of the Perseids platform: SoSOL and [Flask GitHub Proxy](flaskgithubproxy.md).

SoSOL is a Ruby on Rails application backed by Git and mySQL that was originally written for the Papyri.info project and extended by Perseids for its own use.  As of the time of this writing, the Perseids main line of development on SoSOL can be found in the ['perseids-production'](https://github.com/sosol/sosol/tree/perseids-production) branch of the SoSOL git repository. Eventually the Perseids changes may be merged back into the master branch. We try to keep the perseids-production branch up to date with the changes made to master to facilitate this eventuality.

For a more complete description of the Perseids Platform architecture and components see Almas, B., (2017). Perseids: Experimenting with Infrastructure for Creating and Sharing Research Data in the Digital Humanities. Data Science Journal. 16, p.19. DOI: [http://doi.org/10.5334/dsj-2017-019](http://doi.org/10.5334/dsj-2017-019).  For background and more information on the SoSOL platform, as originally developed for Papyri.info, see Baumann, R (2013). The Son of Suda Online In: Dunn, S and Mahoney, S eds.  The Digital Classicist 2013. London: The Institute of Classical Studies University of London, pp. 91–106. Offprint from BICS Supplement-122.[http://ryanfb.github.io/papers-BICS/sosol-bics-draft.pdf]([http://ryanfb.github.io/papers-BICS/sosol-bics-draft.pdf).

## Data Model
### Publications and Identifiers
Data publications produced on SoSOL are collections of related data objects of different types. The `Publication` is the container for a collection of data objects belonging to a parent abstract class of ``Identifier`. Different type object types are implemented as derivations of the `Identifier` class, which add type-specific behaviors and properties, such as schema validation rules.

For Syriaca.org we have added 3 new `Identifier` derived classes to SoSOL:

`SyriacaIdentifier` - For Gazetteer Records

`SyriacaPersonIdentifier` - For Biographical Dictionary Records

`SyriacaWorkIdentifier` - For Hagiographic Work Records

The `SyriacaPersonIdentifier` and `SyriacaWorkIdentifier` classes are themselves derivations of the base `Syriaca` class, inheriting all behaviors, overriding only descriptive attributes and the path used when sending data to the remote Syriaca.org GitHub repository.

The class diagram below shows the methods and attributes that the `SyriacaIdentifier` class overrides from the base `Identifier` class. 

![Model Classes](https://github.com/perseids-project/perseids_docs/blob/master/integrations/syriaca/perseidssyriacamodels.png?raw=true)

#### `SyriacaIdentifier` class overrides 

The `XML_VALIDATOR` property is overridden to delegate the process of validating the TEI XML documents to `JRubyXML:SyriacaGazetteerValidator`. This class specifies the location of the RNG schema used to validate the documents and uses a Saxon processor to perform the validation. The RNG schema used to validate the Syriaca documents is used directly from its location on GitHub: https://raw.githubusercontent.com/srophe/srophe-eXist-app/master/srophe-app/documentation/syriaca-tei-main.rng. This allows the Syriaca.org team to update this schema as needed without requiring any update to the Perseids SoSOL environment.

The `identifier_from_content` method is overridden retrieve the id for a Syriaca Identifier class from within the content of the submitted document. (Its retrieved from the idno field in the teiHeader).

The `titleize` and `create_title` methods are overridden to determine how the title of a Syriaca identifier and publication is set. This information is retrieved from the teiHeader of the submitted document.

`to_remote_path` is a method specific to SyriacaIdentifier classes, used to retrieve the path that should be used to store the data in the external srophe GitHub repository. Ideally, this should be retrievable from the submitted document as  well, but for the time being we hardcoded it in each of the SyriacaIdentifier subclasses.

`get_catalog_link` is overridden to produce a link back to the original documents in the Syriaca.org site.

`preprocess_for_finalization` is a method that is called upon Identifers just before they finish the finalization stage. We override this in the SyriacaIdentifier class in order to send the document to an external post-processing service in the Srophe application which is responsible for normalizing the content according to rules specific to Syriaca.org. These rules are subject to ongoing change by the Syriaca.org team, so making an external service call allowed us to decouple this from the SoSOL application.

`update_revision_desc` is a method which gets called upon Identifiers during finalization to insert details of voting comments into the teiHeader of the document. We override this in the SyriacaIdentifier class in order to insert all comments made on a Syriaca publication in SoSOL to be added to the revisionDesc header, rather than the default of just the voting comments.

### Boards and Communities

The SoSOL review workflow is built around two main model classes: `Communities` and `Boards`.  Perseids' enhancements to the core SoSOL functionality have extended the base `Community` class into 3 types of derived classes: `MasterCommunity`, `PassThroughCommunity` and `EndUserCommunity_. Community types differ in what happens to a publication after it has been finalized by the final `Board` in the community. The `MasterCommunity` commits its finalized publications to the master branch of the Git repository that is local to the SoSOL platform.  The `EndUserCommunity` sends its finalized publications to a specified User, who then can edit and submit the publication under their own account. The `PassThroughCommunity` can either send its finalized publications to an external repository, via an HTTP API call, or to another SoSOL community. The Syriaca.org integration with Perseids uses PassThroughCommunities that are setup to send their finalized publications to the external Syriaca.org Git Repository (https://github.com/srophe/srophe-app-data) via the [FlaskGitHub Proxy](flaskgithubproxy.md). 

Communities can be setup to be self-signup communities or closed communities. Closed communities require that an admin assign individual users as members of the community before they can submit publications to it.  Because the list of users who may be submitting to the [Syriaca.org communities](apioauth.md#syriacaorg-communities) is open-ended, the Syriaca.org communities are configured to be self-signup, meaning that any user can submit to them.  

There is only one type of Board model class in SoSOL. A Board has one or more user members and is associated with one or more classes of Identifier.  When a user submits a Publication to a Community it is sent to the lowest ranked Board that is associated with the class of the individual Identifier documents in the publication. Board members submit `Votes` on individual publications by selecting a `Decrees` associated with an `approve` or `reject` action. The Decree has a `tally_method` which can be set to either an absolute number of votes or a percentage of total members. When the tally of votes received for a publication meets the threshold set for a decree it moves to the appropriate next stage in the workflow. (If it's rejected it returns to the submitting user, if it's approved, it moves on to the finalization stage).   

Several new configurable features were added to the Board model class to support the Syriaca.org workflow. These are described below.  All of these features can be configured on Boards by community admin users only.

#### Board Member Assignment 
The default behavior when a publication is sent to a board is that any member of the Board can see and vote on the publication.  A new configurable boolean property added for Syriaca.org, `requires_assignment`, can be used to restrict visibility and voting on Board publications to only those members who have been actively assigned to vote on the publication by a community admin. New user interface elements were added to the boards views to enable community admins to assign and unassign members to publications.   A separate setting, `max_assignable` can be used to set the maximum number of members who can be assigned to vote on an individual publication. This number can be more or less than the number of votes needed to trigger a decree action.  

#### Default Finalizer
When a publication receives enough approve votes to trigger the approval Decree action it moves to the finalization stage. At this stage the publication can receive final edits before it passes out of the control of the Board. The default behavior of the application is to assign a Finalizer at random from among the Board members.  A new property added for Syriaca.org, `finalizer_user_id` enables a community admin to designate a specific Board member to be assigned as the finalizer for all publicatios approved by the Board. (In fact, a placeholder for this feature was already present in the code, it just hadn't been fully implemented before this). 

#### Skip Finalization
In the normal SoSOL workflow, once a Publication has approved by a Board and finalized, all the Identifiers which were under that Board's control are considered complete and no further action can be taken on them in the community (i.e. they go on to the next step as appropriate for the type of community, as described above).  The Syriaca.org workflow required a multi-stage Board approval process, with one Board serving as a gatekeeper to determine an appropriate sub board for an initial vote on a publication, followed by final approval and potential editing before finalization and acceptance back to the Syriaca.org GitHub repository.  To support this we added a new `skip_finalize` boolean property. Once a Publication is approved by a Board with this flag set to true, as long as there is another viable candidate Board for the Publication to go to (i.e one in the same community which is associated with the class of the approved Identifier) then the Publication will not be finalized and instead will just be sent to the next Board.  To further support this, workflow, we added a new `next_board` property on the Publication model class, and the ability for a Voting member to explicitly state which Board the publication should be assigned to next. 

#### Decree Rules
The final new feature we added to the Board functionality for Syriaca.org was the ability for additional `Rules` to be added to Decrees which can be used to force a publication on to the next stage in the workflow even if a Decree action hasn't been fully met. We implemented basic Rules which have two properties: `floor` and an `expire_days`. In ordre for a Rule to apply for a Decree, the publicaiton must have received at least the number of votes for the decree as specified in the Rule `floor` and at least `expire_days` must have passed with no voting activity on the Publication.  For example, if a Decree is set to require 5 votes, with a Rule which has a floor of 2 votes and expire_days set to 30, then the Rule can apply if at least 30 days have passed since the last vote was received and at least 2 votes for the Decree have been made.

However, Rules are not automatically applied. They require an active `ApplyRules` action to be performed by a community admin for the Board.  This can be done through a button on the Boards display, visible only to community admins. It could potentially also be setup to run as a cron job, although it would require an authenticated user session for this to work properly.

### Agents

The Perseids branch of SoSOL uses `Agent` helper classes to communicate with external services.  The Syriaca use of Perseids relies on two differen Agent sub classes: `SropheProcessorAgent` and `GitHubProxyAgent`. Both are initalized at runtime with the configuration in the `agents.yml` file. The `SropheProcessorAgent::post_content` method is called by the `SyriacaIdentifier::preprocess_for_finalization` method to post the contents of the Syriaca documents to the srophe post processing service before being finalized.  The production configuration for this agent is provided below

```
 :srophe_processor:
    :uri_match: "http://syriaca.org/"
    :type: "srophe_processor"
    :post_url: "http://wwwb.library.vanderbilt.edu/exist/apps/srophe-forms/modules/services/sosol-pp.xql"
    :apikey: "<api key provided by syriaca.org to perseids>"
```

The `GitHubProxyAgent::post_content` method is called by the `Publication:send_to_agent` method when a publication owned by a `PassThroughCommunity` promotes its content after completing the review workflow in the community (after finalization by the last board). This action posts to the content to the Flask GitHub Proxy service which forwards it on to the Srophe GitHub repository in a pull request. (Configuration is described in [Flask GitHub Proxy](flaskgithubproxy.md)).

## Controllers and Views

![Controllers and Views](https://github.com/perseids-project/perseids_docs/blob/master/integrations/syriaca/perseidssyriacacontrollerviews.png?raw=true)

Creation of all Syriaca publications in Perseids is done via API calls as described in [apioauth.md](apiauth.md).  The following controller methods are invoked in this interaction:  `Api::V1::XmlItemsController::create` (creates the Identifier
and Publication and populates the xml content). `Api::V1::PublicationsController::update` (used to update the community_id on the Publication) and `Api::V1::PublicationsController::submit` (used to submit the publication to the community for review).

The individual SyriacaIdentifier Model classes do also have create methods on their controllers, but access to these are not exposed in the User Interface. However, other methods of these controller methods are used through the review process.

`SyriacaIdentifiersController::preview` is called to present an HTML representation of the underlying TEI XML document. This view is used in both the preview of the Board copy of the publication and the individual user's copy.  The transformation to HTML is accomplished through XSLT that originates from the srophe_exist_app GitHub Repository but these are  `_not_` retrieved at runtime.  This is a deployment-time dependency. The XSLT is retrieved in the Rake task `exec cap local externals:setup`, and the location and revision of the stylesheets is set in the `externals.yml` configuration file:

```
data/xslt/syriaca:
  :type: git
  :repository: git://github.com/srophe/srophe-eXist-app.git
  :revision: 9f66a7e94fd4b58aaaa0bd3a40b1d118e718f49c
```

`SyriacaIdentifiersController::raw_preview` is called to provide a diff between the representation of the TEI XML document in the master branch of the external srophe GitHub repository and the version being edited in Perseids. This view is used in both the preview of the Board copy of the publication and the individual user's copy.

`SyriacaIdentifiersController::editxml` is called if a publication is returned to a user for revision and they edit it, and when an editor views and edits the final version of the TEI XML document in the finalization stage.

(These methods are also implemented and called in the `SyriacaPersonIdentifiersController` and `SyriacaWorkIdentifiersController` classes.)

`PublicationsController::show` is the controller method called to present the Overview display from which users can resubmit publications.

