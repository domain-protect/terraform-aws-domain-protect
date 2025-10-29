import datetime
import json
import os

import boto3
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

from utils.utils_dates import calc_prev_month_start


oauth_secret_arn = os.environ["OAUTH_SECRET_ARN"]
slack_channels = os.environ["SLACK_CHANNELS"]
slack_username = os.environ["SLACK_USERNAME"]
slack_emoji = os.environ["SLACK_EMOJI"]
slack_fix_emoji = os.environ["SLACK_FIX_EMOJI"]
slack_new_emoji = os.environ["SLACK_NEW_EMOJI"]


def get_slack_token():
    """Get Slack OAuth token from AWS Secrets Manager"""

    client = boto3.client("secretsmanager")
    return client.get_secret_value(SecretId=oauth_secret_arn)["SecretString"]


def findings_message(json_data):

    try:
        findings = json_data["Findings"]

        slack_message = {"fallback": "A new message", "fields": [{"title": "Vulnerable domains"}]}

        for finding in findings:

            if finding["Account"] == "Cloudflare":
                message = f"{finding['Domain']} in Cloudflare"

            else:
                message = f"{finding['Domain']} in {finding['Account']} AWS Account"

            print(message)
            slack_message["fields"].append({"value": message, "short": False})

        return slack_message

    except KeyError:

        return None


def takeovers_message(json_data):

    try:
        takeovers = json_data["Takeovers"]

        slack_message = {"fallback": "A new message", "fields": [{"title": "Domain takeover status"}]}

        for takeover in takeovers:

            success_message = (
                f"{takeover['ResourceType']} {takeover['TakeoverDomain']} "
                f"successfully created in {takeover['TakeoverAccount']} AWS account "
                f"to protect {takeover['VulnerableDomain']} domain in {takeover['VulnerableAccount']} account"
            )

            failure_message = (
                f"{takeover['ResourceType']} {takeover['TakeoverDomain']} creation "
                f"failed in {takeover['TakeoverAccount']} AWS account to protect {takeover['VulnerableDomain']} "
                f"domain in {takeover['VulnerableAccount']} account"
            )

            if takeover["TakeoverStatus"] == "success":
                print(success_message)
                slack_message["fields"].append(
                    {
                        "value": success_message,
                        "short": False,
                    },
                )

            if takeover["TakeoverStatus"] == "failure":
                print(failure_message)
                slack_message["fields"].append(
                    {
                        "value": failure_message,
                        "short": False,
                    },
                )

        return slack_message

    except KeyError:

        return None


def resources_message(json_data):

    try:
        stacks = json_data["Resources"]

        slack_message = {"fallback": "A new message", "fields": [{"title": "Resources preventing hostile takeover"}]}
        resource_name = resource_type = takeover_account = vulnerable_account = vulnerable_domain = ""

        for tags in stacks:

            for tag in tags:

                if tag["Key"] == "ResourceName":
                    resource_name = tag["Value"]

                elif tag["Key"] == "ResourceType":
                    resource_type = tag["Value"]

                elif tag["Key"] == "TakeoverAccount":
                    takeover_account = tag["Value"]

                elif tag["Key"] == "VulnerableAccount":
                    vulnerable_account = tag["Value"]

                elif tag["Key"] == "VulnerableDomain":
                    vulnerable_domain = tag["Value"]

            message = (
                f"{resource_type} {resource_name} in {takeover_account} AWS account protecting "
                f"{vulnerable_domain} domain in {vulnerable_account} Account"
            )

            print(message)

            slack_message["fields"].append(
                {
                    "value": message,
                    "short": False,
                },
            )

        slack_message["fields"].append(
            {
                "value": "After fixing DNS issues, delete resources and CloudFormation stacks",
                "short": False,
            },
        )

        return slack_message

    except KeyError:

        return None


def fixed_message(json_data):

    try:
        fixes = json_data["Fixed"]

        slack_message = {"fallback": "A new message", "fields": [{"title": "Vulnerable domains fixed or taken over"}]}

        for fix in fixes:

            if fix["Account"] == "Cloudflare":
                message = f"{fix['Domain']} in Cloudflare"

            else:
                message = f"{fix['Domain']} in {fix['Account']} AWS Account"

            print(message)
            slack_message["fields"].append(
                {
                    "value": message,
                    "short": False,
                },
            )

        return slack_message

    except KeyError:

        return None


def current_message(json_data):

    try:
        vulnerabilities = json_data["Current"]

        slack_message = {
            "fallback": "A new message",
            "fields": [{"title": "Domains currently vulnerable to takeover"}],
        }

        for vulnerability in vulnerabilities:

            if vulnerability["Account"] == "Cloudflare":
                message = (
                    f"{vulnerability['Domain']} {vulnerability['VulnerabilityType']} "
                    f"record in Cloudflare DNS with {vulnerability['ResourceType']} resource"
                )

            else:
                message = (
                    f"{vulnerability['Domain']} {vulnerability['VulnerabilityType']} record in "
                    f"{vulnerability['Account']} AWS Account with {vulnerability['ResourceType']} resource"
                )

            print(message)
            slack_message["fields"].append(
                {
                    "value": message,
                    "short": False,
                },
            )

        return slack_message

    except KeyError:

        return None


def misconfigured_message(json_data):

    try:
        misconfigurations = json_data["Misconfigured"]

        slack_message = {
            "fallback": "A new message",
            "fields": [{"title": "Misconfigured domains"}],
        }

        for misconfiguration in misconfigurations:

            message = (
                f"{misconfiguration['Domain']} misconfigured in {misconfiguration['Account']} AWS Account "
                f"{misconfiguration['Issue']}"
            )

            print(message)
            slack_message["fields"].append(
                {
                    "value": message,
                    "short": False,
                },
            )

        return slack_message

    except KeyError:

        return None


def new_message(json_data):

    try:
        vulnerabilities = json_data["New"]

        slack_message = {
            "fallback": "A new message",
            "fields": [{"title": "New vulnerable domains"}],
        }

        for vulnerability in vulnerabilities:

            try:
                if vulnerability["Bugcrowd"] and vulnerability["Bugcrowd"] != "N/A":
                    bugbounty_notification = ":bugcrowd: Bugcrowd issue created"

                elif not vulnerability["Bugcrowd"]:
                    bugbounty_notification = ":bugcrowd: Bugcrowd issue creation failed"

                elif vulnerability["HackerOne"] and vulnerability["HackerOne"] != "N/A":
                    bugbounty_notification = ":hackerone: HackerOne issue created"

                elif not vulnerability["HackerOne"]:
                    bugbounty_notification = ":hackerone: HackerOne issue creation failed"

                if vulnerability["Account"] == "Cloudflare":
                    message = (
                        f"{vulnerability['Domain']} {vulnerability['VulnerabilityType']} "
                        f"record in Cloudflare DNS with {vulnerability['ResourceType']} resource "
                        f"{bugbounty_notification}"
                    )

                else:
                    message = (
                        f"{vulnerability['Domain']} {vulnerability['VulnerabilityType']} record in "
                        f"{vulnerability['Account']} AWS Account with {vulnerability['ResourceType']} resource "
                        f"{bugbounty_notification}"
                    )

            except KeyError:
                if vulnerability["Account"] == "Cloudflare":
                    message = (
                        f"{vulnerability['Domain']} {vulnerability['VulnerabilityType']} "
                        f"record in Cloudflare DNS with {vulnerability['ResourceType']} resource"
                    )

                else:
                    message = (
                        f"{vulnerability['Domain']} {vulnerability['VulnerabilityType']} record in "
                        f"{vulnerability['Account']} AWS Account with {vulnerability['ResourceType']} resource"
                    )

            print(message)
            slack_message["fields"].append(
                {
                    "value": message,
                    "short": False,
                },
            )

        return slack_message

    except KeyError:

        return None


def build_markdown_block(text):
    return {"type": "section", "text": {"type": "mrkdwn", "text": text}}


def monthly_stats_message(json_data):
    last_month = calc_prev_month_start(datetime.datetime.now())
    last_month_year_text = last_month.strftime("%B %Y")
    last_year_text = last_month.strftime("%Y")

    try:
        blocks = [
            build_markdown_block(f"Total new findings for {last_month_year_text}: *{json_data['LastMonth']}*"),
            build_markdown_block(f"Total new findings for {last_year_text}: *{json_data['LastYear']}*"),
            build_markdown_block(f"Total findings all time: *{json_data['Total']}*"),
        ]
        return {"blocks": blocks}
    except KeyError:
        return None


def lambda_handler(event, context):  # pylint:disable=unused-argument
    slack_message = {}
    subject = event["Records"][0]["Sns"]["Subject"]

    # Base message parameters - always use the app's configured icon
    text = subject
    icon_emoji = slack_emoji  # This stays as the app's configured icon
    attachments = []

    message = event["Records"][0]["Sns"]["Message"]
    json_data = json.loads(message)

    if findings_message(json_data) is not None:
        slack_message = findings_message(json_data)

    elif takeovers_message(json_data) is not None:
        slack_message = takeovers_message(json_data)

    elif resources_message(json_data) is not None:
        slack_message = resources_message(json_data)

    elif current_message(json_data) is not None:
        slack_message = current_message(json_data)
        text = f"{slack_emoji} {subject}"

    elif misconfigured_message(json_data) is not None:
        slack_message = misconfigured_message(json_data)
        text = f"{slack_emoji} {subject}"

    elif new_message(json_data) is not None:
        slack_message = new_message(json_data)
        text = f"{slack_new_emoji} {subject}"
        # Keep the app's configured icon, emoji is already inline in text

    elif fixed_message(json_data) is not None:
        slack_message = fixed_message(json_data)
        text = f"{slack_fix_emoji} {subject}"
        # Keep the app's configured icon, emoji is already inline in text

    elif monthly_stats_message(json_data) is not None:
        slack_message = monthly_stats_message(json_data)
        # Keep the app's configured icon for stats messages

    if len(slack_message) > 0:
        attachments.append(slack_message)

    # Set up WebClient with the Slack OAuth token
    client = WebClient(token=get_slack_token())

    # Send message to channels
    channel_list = slack_channels.replace(" ", "").split(",")

    for channel in channel_list:
        try:
            # Use the proper slack_sdk WebClient method
            if "blocks" in slack_message:
                # For messages with blocks (like monthly stats)
                response = client.chat_postMessage(
                    channel=channel.strip(),
                    text=text,
                    username=slack_username,
                    icon_emoji=icon_emoji,
                    **slack_message,
                )
            else:
                # For messages with attachments
                response = client.chat_postMessage(
                    channel=channel.strip(),
                    text=text,
                    username=slack_username,
                    icon_emoji=icon_emoji,
                    attachments=attachments,
                )

            if response["ok"]:
                print(f"Message sent to {channel.strip()} Slack channel")
            else:
                print(f"Failed to send message to {channel.strip()}: {response['error']}")

        except SlackApiError as e:
            print(f"Slack API error sending message to {channel.strip()}: {e.response['error']}")
        except Exception as e:
            print(f"Error sending message to {channel.strip()}: {str(e)}")
