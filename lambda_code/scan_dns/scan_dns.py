#!/usr/bin/env python
import json

from utils.utils_aws import get_nameservers_route53
from utils.utils_aws import list_hosted_zones
from utils.utils_aws import publish_to_sns
from utils.utils_dns import get_nameservers_dns_non_recursive


def get_domain_configuration(account_id, account_name, hosted_zone, domain):
    print(f"Checking if hosted zone {domain} is authoritative")

    route53_nameservers = get_nameservers_route53(account_id, account_name, hosted_zone["Id"])
    dns_nameservers = get_nameservers_dns_non_recursive(domain)

    route53_nameservers_set = {ns.lower() for ns in route53_nameservers}
    dns_nameservers_set = {ns.lower() for ns in dns_nameservers}

    return route53_nameservers_set, dns_nameservers_set


def compare_nameservers(route53_nameservers, dns_nameservers, domain):
    if not dns_nameservers:
        return f"No public DNS nameservers for {domain}"

    incorrect_nameservers = 0
    for dns_ns in dns_nameservers:
        if dns_ns not in route53_nameservers:
            incorrect_nameservers += 1

    if incorrect_nameservers > 0:
        return f"One or more public DNS nameservers for {domain} not in Route53"

    if len(route53_nameservers) > len(dns_nameservers):
        return f"Not all Route53 nameservers for {domain} configured in public DNS"

    return None


def lambda_handler(event, context):  # pylint:disable=unused-argument

    global misconfigured_domains
    misconfigured_domains = []

    global json_data
    json_data = {"New": []}

    print(f"Input: {event}")

    account_id = event["Id"]
    account_name = event["Name"]

    print(f"Checking authoritative status of hosted zones in {account_name} AWS account")

    hosted_zones = list_hosted_zones(event)

    for hosted_zone in hosted_zones:
        domain = hosted_zone["Name"]
        domain = domain[:-1] if domain.endswith(".") else domain  # remove trailing dot

        route53_nameservers, dns_nameservers = get_domain_configuration(account_id, account_name, hosted_zone, domain)

        if route53_nameservers == dns_nameservers:
            print(f"hosted zone {domain} is authoritative and correctly configured")

        else:
            issue = compare_nameservers(route53_nameservers, dns_nameservers, domain)

            if issue:
                print(f"hosted zone {domain} misconfigured: {issue}")
                misconfigured_domains.append(domain)
                json_data["Misconfigured"].append({"Account": account_name, "Domain": domain, "Issue": issue})

            else:
                print(f"hosted zone {domain} is not authoritative")
                misconfigured_domains.append(domain)
                json_data["Misconfigured"].append(
                    {"Account": account_name, "Domain": domain, "Issue": "Non-authoritative hosted zone"},
                )

    if len(misconfigured_domains) > 0:
        publish_to_sns(json_data, "Misconfigured domains")
