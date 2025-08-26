# Slack Webhook (not recommended)

The default Slack setup for Domain Protect is as a [Slack App with OAuth token](slack.md).

However there are two supported methods of using webhooks with Domain Protect, for backwards compatibility:

* Slack webhook app
* legacy Slack webhook

To use either of the Slack webhook methods, set Terraform variable `slack_oauth_app = false`

If using a Slack app, to ensure correct formatting, also set Terraform variable `slack_webhook_type = "app"`

## Slack Webhook app (not recommended)

* in your Slack client menu panel, select More, Apps, App Directory, Build

![Alt text](assets/images/slack-create-app.png?raw=true "Create Slack app")

* press Create an app
* choose From scratch
* name App `Domain Protect`
* choose Slack Workspace for your organisation

![Alt text](assets/images/slack-name-workspace.png?raw=true "Slack app name and workspace")

* press Create App
* select Incoming Webhooks

![Alt text](assets/images/slack-activate-webhook.png?raw=true "Activate Slack webhook")

* move slider to On
* press Add New Webhook to Workspace

![Alt text](assets/images/slack-allow-access.png?raw=true "Allow Slack access")

* select channel
* press Allow

![Alt text](assets/images/slack-webhook-url.png?raw=true "Slack webhook URL")

* copy webhook URL to a safe location
* you'll see Domain Protect in Your Apps

![Alt text](assets/images/slack-your-apps.png?raw=true "Your Slack apps")

* select the Domain Protect app
* scroll down to Display Information
* at description, add `Prevent subdomain takeover`
* add the Domain Protect Slack [App Icon](./assets/slack/domain-protect-icon.png) from this repository
* for background color enter `#2c2d30`

![Alt text](assets/images/slack-app-display.png?raw=true "Slack app display information")

* save changes

### Additional Slack channels
* repeat the above for every channel
* each channel needs its own app and webhook URL
* app names do not have to be unique

![Alt text](assets/images/slack-extra-channel.png?raw=true "Extra Slack channel")

* all apps can be seen in Your Apps

![Alt text](assets/images/slack-your-apps-2.png?raw=true "Your Slack apps")

## Legacy Slack webhook (not recommended)

Using a legacy Slack webhook is not recommended, as it may stop working when the person who created it leaves the organisation.

To create a legacy webhook:

* in your Slack client menu panel, select More, Apps, App Directory
* in the search bar, type `incoming webhook`
* select Incoming WebHooks
* add to Slack
* record the webhook URL

A single legacy Slack webhook can be used for all Slack channels
