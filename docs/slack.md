# Slack

By default, Domain Protect delivers notifications to Slack using an App with OAuth token authentication.

The Slack OAuth token is stored as an AWS Secret.

For backwards compatibility, [legacy Slack webhook configurations](slack-webhook.md) are also supported, but not recommended.

## Create Slack app

* Log in to your Slack workspace
* Open [https://api.slack.com/apps](https://api.slack.com/apps)

![Alt text](assets/images/slack-oauth-create-app.png?raw=true "Create Slack app")

* press Create new app
* choose From scratch
* name App `Domain Protect` for production or `Domain Protect dev` for development
* choose Slack Workspace for your organisation

![Alt text](assets/images/slack-oauth-choose-workspace.png?raw=true "Slack app name and workspace")

* press Create App
* from Features, select OAuth & Permissions
* scroll down to Scopes

![Alt text](assets/images/slack-oauth-no-scopes.png?raw=true "Slack OAuth initial scopes")

* under Bot Token Scopes, click "Add an OAuth Scope" to add `chat:write` `chat:write.customize` `chat:write.public`

![Alt text](assets/images/slack-oauth-scopes.png?raw=true "Slack OAuth scopes")

* scroll up to the top of OAuth & Permissions

![Alt text](assets/images/slack-oauth-install.png?raw=true "Install to workspace")

* press Install to workspace

![Alt text](assets/images/slack-oauth-approve.png?raw=true "Approve app install")

* press Allow
* a Bot User OAuth token will now be generated

![Alt text](assets/images/slack-oauth-token.png?raw=true "Slack OAuth Token")

* open the AWS console for the account to which Domain Protect is installed
* In AWS Secrets Manager, select the Domain Protect Slack OAuth Secret
* overwrite the `dummy-value` Secret value
* press Save
* at Basic Information, scroll down to Display Information
* at description, add `Prevent subdomain takeover`
* add the Domain Protect Slack [App Icon](./assets/slack/domain-protect-icon.png) from this repository
* for background color enter `#2c2d30`

![Alt text](assets/images/slack-oauth-display-info.png?raw=true "Slack app display information")

* save changes
