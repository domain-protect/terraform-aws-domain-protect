import os
from time import sleep

from assertpy import assert_that

from integration_tests.deployment.aws.utils.awslambda import invoke_lambda
from integration_tests.deployment.aws.utils.dynamodb import vulnerability_detected_in_time_period
from integration_tests.deployment.aws.utils.general import random_string
from integration_tests.deployment.aws.utils.route53 import create_record_set
from integration_tests.deployment.aws.utils.route53 import delete_record_set
from utils.utils_db import db_get_unfixed_vulnerability_found_date_time


ns_record_details = {
    "record_value": "ns1.amazon.com",
    "record_type": "NS",
    "resource_type": "hosted zone",
}

cname_prefix = random_string(10)

cname_record_details = {
    "record_value": f"{cname_prefix}.trafficmanager.net",
    "record_type": "CNAME",
    "resource_type": "hosted_zone",
}


def create_vulnerable_record(record_name, record_details, route53_account, zone_id):
    record_value = record_details["record_value"]
    record_type = record_details["record_type"]

    create_record_set(route53_account, zone_id, record_name, record_type, record_value)
    print(f"Created vulnerable {record_type.upper()} record: {record_name} {record_type} {record_value}")


def delete_vulnerable_record(record_name, record_details, route53_account, zone_id):
    record_value = record_details["record_value"]
    record_type = record_details["record_type"]

    delete_record_set(route53_account, zone_id, record_name, record_type, record_value)
    print(f"Deleted vulnerable NS record: {record_name} {record_type} {record_value}")


def vulnerability_reported_fixed_in_time_period(update_lambda_name, domain, seconds):
    while seconds > 0:
        invoke_lambda(update_lambda_name)
        if not db_get_unfixed_vulnerability_found_date_time(domain):
            print(f"{domain} vulnerability reported as fixed")
            return True
        sleep(5)
        print(f"{seconds} seconds remaining")
        seconds -= 5

    return False


def test_vulnerabilities_detected():
    project = os.environ["PROJECT"]
    environment = os.environ["ENVIRONMENT"]
    route53_account = os.environ["ROUTE53_ACCOUNT"]
    zone_name = os.environ["ZONE_NAME"]
    zone_id = os.environ["ZONE_ID"]

    accounts_lambda_name = f"{project}-accounts-{environment}"
    update_lambda_name = f"{project}-update-{environment}"
    cname_suffix = random_string()
    ns_suffix = random_string()
    cname_record_name = f"vulnerable-{cname_suffix}.{zone_name}"
    ns_record_name = f"vulnerable-{ns_suffix}.{zone_name}"

    # Create vulnerable records in Route53 AWS account
    create_vulnerable_record(cname_record_name, cname_record_details, route53_account, zone_id)
    create_vulnerable_record(ns_record_name, ns_record_details, route53_account, zone_id)

    # Invoke Accounts Lambda function
    invoke_lambda(accounts_lambda_name)

    # test if vulnerabilities detected within specified time period
    cname_vulnerability_found = vulnerability_detected_in_time_period(f"{cname_record_name}.", 120)
    ns_vulnerability_found = vulnerability_detected_in_time_period(f"{ns_record_name}.", 120)

    # Delete vulnerable records
    delete_vulnerable_record(cname_record_name, cname_record_details, route53_account, zone_id)
    delete_vulnerable_record(ns_record_name, ns_record_details, route53_account, zone_id)

    # test if vulnerabilities reported as fixed within specified time period
    cname_vulnerability_reported_fixed = vulnerability_reported_fixed_in_time_period(
        update_lambda_name,
        f"{cname_record_name}.",
        300,
    )
    ns_vulnerability_reported_fixed = vulnerability_reported_fixed_in_time_period(
        update_lambda_name,
        f"{ns_record_name}.",
        300,
    )

    assert_that(cname_vulnerability_found).is_true()
    assert_that(ns_vulnerability_found).is_true()
    assert_that(cname_vulnerability_reported_fixed).is_true()
    assert_that(ns_vulnerability_reported_fixed).is_true()
