import os

from assertpy import assert_that

from integration_tests.deployment.aws.utils.awslambda import invoke_lambda
from integration_tests.deployment.aws.utils.dynamodb import vulnerability_detected_in_time_period
from integration_tests.deployment.aws.utils.general import random_string
from integration_tests.deployment.aws.utils.route53 import create_record_set
from integration_tests.deployment.aws.utils.route53 import delete_record_set


record_type = "NS"
resource_type = "hosted zone"
record_value = "ns1.amazon.com"


def create_vulnerable_ns(record_name, route53_account, zone_id):
    create_record_set(route53_account, zone_id, record_name, record_type, record_value)
    print(f"Created vulnerable NS record: {record_name} {record_type} {record_value}")


def delete_vulnerable_ns(record_name, route53_account, zone_id):
    delete_record_set(route53_account, zone_id, record_name, record_type, record_value)
    print(f"Deleted vulnerable NS record: {record_name} {record_type} {record_value}")


def test_vulnerable_ns():
    project = os.environ["PROJECT"]
    environment = os.environ["ENVIRONMENT"]
    route53_account = os.environ["ROUTE53_ACCOUNT"]
    zone_name = os.environ["ZONE_NAME"]
    zone_id = os.environ["ZONE_ID"]

    accounts_lambda_name = f"{project}-accounts-{environment}"
    suffix = random_string()
    record_name = f"vulnerable-{suffix}.{zone_name}"

    # Create vulnerable NS record in Route53 AWS account
    create_vulnerable_ns(record_name, route53_account, zone_id)

    # Invoke Accounts Lambda function
    invoke_lambda(accounts_lambda_name)

    # test if vulnerability is detected within specified time period
    response = vulnerability_detected_in_time_period(f"{record_name}.", 60)

    # Delete the vulnerable NS record
    delete_vulnerable_ns(record_name, route53_account, zone_id)

    assert_that(response).is_true()

    # TODO: invoke Update lambda function, test if vulnerability detected as fixed
