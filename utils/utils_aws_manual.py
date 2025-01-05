import re
import warnings

import boto3
import requests
import urllib3

# Compile once
BUCKET_URL_ENDPOINT = re.compile(r"^.+\.s3\.([a-z0-9-]+\.)?amazonaws\.com$")
BUCKET_WEBSITE_ENDPOINT = re.compile(r"^.+\.s3-website[-.]([a-z0-9-]+\.)?amazonaws\.com$")


def list_hosted_zones_manual_scan():
    session = boto3.Session()
    route53 = session.client("route53")

    hosted_zones_list = []

    paginator_zones = route53.get_paginator("list_hosted_zones")
    pages_zones = paginator_zones.paginate()
    for page_zones in pages_zones:
        hosted_zones = [h for h in page_zones["HostedZones"] if not h["Config"]["PrivateZone"]]

        hosted_zones_list = hosted_zones_list + hosted_zones

    return hosted_zones_list


# Given the bucket's direct URL or S3 website URL, returns True if the bucket does not exist
def bucket_does_not_exist(bucket_url):
    try:
        with warnings.catch_warnings():
            warnings.simplefilter("ignore", urllib3.exceptions.InsecureRequestWarning)
            response = requests.get("https://" + bucket_url, timeout=1, verify=False)  # nosec B501

        # When accessed directly e.g. bucket.s3.amazonaws.com
        if response.status_code == 404 and "<Code>NoSuchBucket</Code>" in response.text:
            return True

        # When accessed through S3 website url e.g. bucket.s3-website-us-east-1.amazonaws.com
        if response.status_code == 404 and "Code: NoSuchBucket" in response.text:
            return True

    except (requests.exceptions.ConnectionError, requests.exceptions.ReadTimeout):
        pass

    return False


# Extracts the origin URL from a CloudFront distribution
def get_cloudfront_origin_url(domain_name):
    boto3_session = boto3.Session()
    cloudfront = boto3_session.client("cloudfront")

    # List CloudFront distributions, find the one with the matching domain name
    paginator = cloudfront.get_paginator("list_distributions")
    pages = paginator.paginate()
    for page in pages:
        for distribution in page["DistributionList"]["Items"]:
            if "Items" not in distribution["Aliases"]:
                continue
            for alias in distribution["Aliases"]["Items"]:
                if alias + "." == domain_name:
                    # We found the right distribution
                    return distribution["Origins"]["Items"][0]["DomainName"]


def is_s3_bucket_url(url):
    # bucket.s3.amazonaws.com or bucket.s3.region.amazonaws.com
    return url and BUCKET_URL_ENDPOINT.match(url)


def is_s3_website_endpoint_url(url):
    # bucket.s3-website-region.amazonaws.com
    return url and BUCKET_WEBSITE_ENDPOINT.match(url)


def vulnerable_cloudfront_s3_manual(domain_name):
    try:
        response = requests.get(f"https://{domain_name}", timeout=1)

        if response.status_code == 404 and "<Code>NotFound</Code>" in response.text:
            bucket_url = get_cloudfront_origin_url(domain_name)
            if not is_s3_bucket_url(bucket_url) and not is_s3_website_endpoint_url(bucket_url):
                return False

            return bucket_does_not_exist(bucket_url)

    except (requests.exceptions.ConnectionError, requests.exceptions.ReadTimeout):
        pass

    return False
