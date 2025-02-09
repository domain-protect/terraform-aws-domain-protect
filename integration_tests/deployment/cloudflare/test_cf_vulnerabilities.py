# Cloudflare Python version 3.1.1
import os
from time import sleep

from assertpy import assert_that

from integration_tests.deployment.aws.utils.awslambda import invoke_lambda
from integration_tests.deployment.aws.utils.dynamodb import vulnerability_detected_in_time_period
from integration_tests.deployment.aws.utils.general import random_string
from integration_tests.deployment.cloudflare.utils.cloudflare_dns import create_dns_record
from integration_tests.deployment.cloudflare.utils.cloudflare_dns import delete_dns_record
from integration_tests.deployment.cloudflare.utils.cloudflare_dns import list_dns_records
from integration_tests.deployment.cloudflare.utils.cloudflare_dns import list_dns_zones
from utils.utils_db import db_get_unfixed_vulnerability_found_date_time


def get_cf_zone_id(zone_name):
    zones = list_dns_zones()
    for zone in zones:
        if zone.name == zone_name:
            return zone.id
    return None


def get_cf_record_id(zone_id, zone_name, record_fqdn):
    records = list_dns_records(zone_id, zone_name, record_fqdn)
    if records:
        return records[0].id
    return None


def create_vulnerable_cf_record(zone_id, zone_name, record_name, record_type, record_value):
    create_dns_record(zone_id, zone_name, record_name, record_type, record_value)
    record_fqdn = f"{record_name}.{zone_name}"
    print(f"Created vulnerable {record_type.upper()} record: {record_fqdn} {record_type} {record_value}")


def cf_vulnerability_reported_fixed_in_time_period(update_lambda_name, domain, seconds):
    while seconds > 0:
        invoke_lambda(update_lambda_name)
        if not db_get_unfixed_vulnerability_found_date_time(domain):
            print(f"{domain} vulnerability reported as fixed")
            return True
        sleep(5)
        print(f"{seconds} seconds remaining")
        seconds -= 5

    return False


def test_cf_vulnerabilities_detected():
    project = os.environ["PROJECT"]
    environment = os.environ["ENVIRONMENT"]
    cf_zone_name = os.environ["CLOUDFLARE_ZONE_NAME"]

    cf_zone_id = get_cf_zone_id(cf_zone_name)
    cf_scan_lambda_name = f"{project}-cloudflare-scan-{environment}"
    update_lambda_name = f"{project}-update-{environment}"
    cname_suffix = random_string()
    ns_suffix = random_string()
    cname_record_name = f"vulnerable-{cname_suffix}"
    cname_record_fqdn = f"vulnerable-{cname_suffix}.{cf_zone_name}"
    cname_value = f"{cname_suffix}.trafficmanager.net"
    ns_record_name = f"vulnerable-{ns_suffix}"
    ns_record_fqdn = f"vulnerable-{ns_suffix}.{cf_zone_name}"
    ns_record_value = "ns1.amazon.com"

    # Create vulnerable records in Cloudflare DNS
    create_vulnerable_cf_record(cf_zone_id, cf_zone_name, cname_record_name, "CNAME", cname_value)
    create_vulnerable_cf_record(cf_zone_id, cf_zone_name, ns_record_name, "NS", ns_record_value)

    # Invoke Accounts Lambda function
    invoke_lambda(cf_scan_lambda_name)

    # test if vulnerabilities detected within specified time period
    cname_vulnerability_found = vulnerability_detected_in_time_period(f"{cname_record_fqdn}", 120)
    ns_vulnerability_found = vulnerability_detected_in_time_period(f"{ns_record_fqdn}", 120)

    # Get IDs of vulnerable records
    cname_record_id = get_cf_record_id(cf_zone_id, cf_zone_name, cname_record_fqdn)
    ns_record_id = get_cf_record_id(cf_zone_id, cf_zone_name, ns_record_fqdn)

    # Delete vulnerable records
    delete_dns_record(cf_zone_id, cname_record_id, cname_record_fqdn)
    delete_dns_record(cf_zone_id, ns_record_id, ns_record_fqdn)

    # test if vulnerabilities reported as fixed within specified time period
    cname_vulnerability_reported_fixed = cf_vulnerability_reported_fixed_in_time_period(
        update_lambda_name,
        f"{cname_record_name}.",
        300,
    )
    ns_vulnerability_reported_fixed = cf_vulnerability_reported_fixed_in_time_period(
        update_lambda_name,
        f"{ns_record_name}.",
        300,
    )

    assert_that(cname_vulnerability_found).is_true()
    assert_that(ns_vulnerability_found).is_true()
    assert_that(cname_vulnerability_reported_fixed).is_true()
    assert_that(ns_vulnerability_reported_fixed).is_true()
