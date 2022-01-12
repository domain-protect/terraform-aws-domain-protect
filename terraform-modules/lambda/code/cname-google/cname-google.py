#!/usr/bin/env python
import json
import requests

from utils_aws import (
    list_accounts,
    list_hosted_zones,
    list_resource_record_sets,
    publish_to_sns,
)


def vulnerable_cname_storage(domain_name):

    try:
        response = requests.get(f"http://{domain_name}", timeout=1)
        if "NoSuchBucket" in response.text:
            return True

    except (requests.exceptions.ConnectionError, requests.exceptions.ReadTimeout):
        pass

    return False


def lambda_handler(event, context):  # pylint:disable=unused-argument

    vulnerable_domains = []
    json_data = {"Findings": []}

    accounts = list_accounts()
    for account in accounts:
        account_id = account["Id"]
        account_name = account["Name"]

        hosted_zones = list_hosted_zones(account)

        for hosted_zone in hosted_zones:
            print(f"Searching for CNAME records for Google Cloud Storage in hosted zone {hosted_zone['Name']}")

            record_sets = list_resource_record_sets(account_id, account_name, hosted_zone["Id"])

            record_sets = [
                r
                for r in record_sets
                if r["Type"] in ["CNAME"] and "c.storage.googleapis.com" in r["ResourceRecords"][0]["Value"]
            ]

            for record in record_sets:
                print(f"checking if {record['Name']} is vulnerable to takeover")
                result = vulnerable_cname_storage(record["Name"])
                if result:
                    print(f"{record['Name']} in {account_name} is vulnerable")
                    vulnerable_domains.append(record["Name"])
                    json_data["Findings"].append(
                        {"Account": account_name, "AccountID": str(account_id), "Domain": record["Name"]}
                    )

    if len(hosted_zones) == 0:
        print(f"No hosted zones found in {account_name} account")

    print(json.dumps(json_data, sort_keys=True, indent=2))

    if len(vulnerable_domains) > 0:
        publish_to_sns(json_data, "CNAME for missing Google Cloud Storage bucket in Amazon Route53")