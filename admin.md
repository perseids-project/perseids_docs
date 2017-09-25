# Perseids User/Community/Board Admin Functionality

## Hidden Administrative Functions

N.B. All of these require that the user account with which you have logged into Perseids already has master admin privileges.

1. List Users

To list all users and their email addresses, access the index_users_by_email User controller view at http://sosol.perseids.org/sosol/user/index_users_by_email

2. Set User Admin Privileges

To add or remove admin privileges from a User account, access the index_user_admins User controller view at 
http://sosol.perseids.org/sosol/user/index_user_admins

3. List/Add/Edit Communities

To get the list of all Communities, and to add, edit and delete communities, access the index Communities controller view at  http://sosol.perseids.org/sosol/communities


## Exposed Administrative Functions

N.B. All of these require that the user account with which you have logged into Perseids already has master admin privileges.

From within the User Interface, if you are an admin user, your dashboard will provide you will buttons which allow you to __Email all Users__ and __Manage Boards__.  _Board Management should only be done through Communities, however_.

### Enabling a new GitHub Pass-Through Community

Pass Through boards can be configured to enable publications in a community to sent to a GitHub repository upon finalization. Enabling this workflow depends upon proper configuration of SoSOL and the helper [Flask Github Proxy](https://github.com/perseids-project/perseids_docs/blob/master/integrations/syriaca/flaskgithubproxy.md) service it uses to communicate with GitHub.  The steps that need to be taken are as follows:

1. Login to GitHub with the __perseids-proxy-user__ id. (Credentials for this GitHub account are kept in the private perseids_private_config repository.)

2. Fork the target GitHub repository into the perseids-proxy-user GitHub account. 

3. Add (and commit/push to GitHub) a new entry in the [Puppet template app.wsgi.eipp](https://github.com/perseids-project/perseids-puppet/blob/master/site-modules/site/templates/profiles/fghproxy/app.wsgi.epp) for the deployed Flask GitHub repository:

    ```
    proxy_name = GithubProxy(
    "/<proxy_path>",
    "perseids-proxy-user/<forked_repo_name>",
    "<target-github-owner>/<target_repo_name>",
    secret="<authentication_secrect_for_communication>",
    token="<perseids-proxy-user-application-authentication-token_from_github>",
    app=application,
    origin_branch="master",
    default_author=Author(
        "Github Proxy",
        "perseids-proxy@github.com"
    )
    ```
4. Add (and commit/push to GitHub) a new entry in the [Puppet template for the Icinga monitoring config file webchecks.cfg](https://github.com/perseids-project/perseids-puppet/blob/master/site-modules/site/files/icinga/webchecks.cfg) to monitor that the proxy end point answers:

    ```
    define service {
      host_name             services
      service_description   github <proxy_name>
      check_command         check_web_response!fgh.perseids.org!"/flask-github-proxy/<proxy_path>/"!dummy:dummy!Nothing!5!10
      use                   every_5_mins
    }
    ```
5. Add (and commit/push to GitHub) a new entry in the [Puppet Template for SoSOL agents.yml.epp](https://github.com/perseids-project/perseids-puppet/blob/master/site-modules/sosol/templates/agents.yml.epp):

    ```
    :<proxy_name>:
      :uri_match: "https://github.com/perseids-project/digital_milliet"
      :type: "github"
      :post_url: "<%= $fgh_proxy_url %>/flask-github-proxy/<proxy_path>/push/<PATH>"
      :timeout: 3600
      :client_secret: "<%= $fgh_client_secret %>"
      :log_message: "<ID> Edited by <USER> via Perseids."
    ```
 6. Once the above changes are committed, pushed to GitHub and deployed via Puppet (which runs every 10 minutes in the production environment), the new Pass Through Community can be setup in the SoSOL admin interface.  The URI for the pass through endpoint should be the value of the :uri_match: property from agents.yml.
 
 For example, assume that the Target GitHub Repository for the finalized publications is __https://github.com/userx/myrepo__. The corresponding entries in the above referenced templates would be as follows:
 
FGH Proxy app.wsgi.epp:
 
    proxy_name = GithubProxy(
    "/userx_myrepo",
    "perseids-proxy-user/myrepo",
    "userx/myrepo",
    secret="<authentication_secret_for_communication>",
    token="<perseids-proxy-user-application-authentication-token_from_github>",
    app=application,
    origin_branch="master",
    default_author=Author(
        "Github Proxy",
        "perseids-proxy@github.com"
    )
    
 (`<authentication_secret_for_communication>` and `<perseids-proxy-user-application-authentication-token_from_github>` are secret keys kept in puppet - just copy what other entries have here)
 
Icinga webchecks.cfg:
 
    define service {
      host_name             services
      service_description   github userx_myrepo
      check_command         check_web_response!fgh.perseids.org!"/flask-github-proxy/userx_myrepo/"!dummy:dummy!Nothing!5!10
      use                   every_5_mins
    }
    
SoSOL agents.yml.epp:
 
    :userx_myrepo:
      :uri_match: "https://github.com/userx/myrepo"
      :type: "github"
      :post_url: "<%= $fgh_proxy_url %>/flask-github-proxy/userx_myrepo/push/<PATH>"
      :timeout: 3600
      :client_secret: "<%= $fgh_client_secret %>"
      :log_message: "<ID> Edited by <USER> via Perseids."
    
 Passthrough Community passthrough uri value: https://github.com/userx/myrepo
 
## Additional Resources

[Video of Admin Functionality Walk-Through](https://github.com/perseids-project/perseids_docs/blob/master/admin.md)
