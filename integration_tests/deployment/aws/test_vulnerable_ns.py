import os
from time import sleep

from assertpy import assert_that

from integration_tests.deployment.aws.utils.awslambda import invoke_lambda
from integration_tests.deployment.aws.utils.dynamodb import vulnerability_detected_in_time_period
from integration_tests.deployment.aws.utils.general import random_string
from integration_tests.deployment.aws.utils.route53 import create_record_set
from integration_tests.deployment.aws.utils.route53 import delete_record_set
from utils.utils_db import db_get_unfixed_vulnerability_found_date_time


record_type = "NS"
resource_type = "hosted zone"
record_value = "ns1.amazon.com"


def create_vulnerable_record(record_name, route53_account, zone_id):
    create_record_set(route53_account, zone_id, record_name, record_type, record_value)
    print(f"Created vulnerable NS record: {record_name} {record_type} {record_value}")


def delete_vulnerable_record(record_name, route53_account, zone_id):
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


def test_vulnerable_ns():
    project = os.environ["PROJECT"]
    environment = os.environ["ENVIRONMENT"]
    route53_account = os.environ["ROUTE53_ACCOUNT"]
    zone_name = os.environ["ZONE_NAME"]
    zone_id = os.environ["ZONE_ID"]

    accounts_lambda_name = f"{project}-accounts-{environment}"
    update_lambda_name = f"{project}-update-{environment}"
    suffix = random_string()
    record_name = f"vulnerable-{suffix}.{zone_name}"

    # Create vulnerable NS record in Route53 AWS account
    create_vulnerable_record(record_name, route53_account, zone_id)

    # Invoke Accounts Lambda function
    invoke_lambda(accounts_lambda_name)

    # test if vulnerability is detected within specified time period
    vulnerability_found = vulnerability_detected_in_time_period(f"{record_name}.", 120)

    # Delete the vulnerable record
    delete_vulnerable_record(record_name, route53_account, zone_id)

    # test if vulnerability reported as fixed within specified time period
    vulnerability_reported_fixed = vulnerability_reported_fixed_in_time_period(
        update_lambda_name,
        f"{record_name}.",
        300,
    )

    assert_that(vulnerability_found).is_true()
    assert_that(vulnerability_reported_fixed).is_true()
