#!/usr/bin/env python
from utils.utils_cloudflare_v4 import list_dns_records
from utils.utils_cloudflare_v4 import list_dns_zones
from utils.utils_print import my_print
from utils.utils_print import print_list
from utils.utils_requests import vulnerable_storage


vulnerable_domains = []

if __name__ == "__main__":

    print("Searching for vulnerable subdomains with missing storage buckets")
    i = 0
    zones = list_dns_zones()

    for zone in zones:
        records = list_dns_records(zone.id, zone.name)

        cname_records = [
            r
            for r in records
            if r.type == "CNAME"
            and (
                ("amazonaws.com" in r.content and ".s3" in r.content)
                or "cloudfront.net" in r.content
                or "c.storage.googleapis.com" in r.content
            )
        ]

        for record in cname_records:
            i = i + 1
            result = vulnerable_storage(record.name)

            if result:
                vulnerable_domains.append(record.name)
                my_print(f"{str(i)}. {record.name}", "ERROR")
            else:
                my_print(f"{str(i)}. {record.name}", "SECURE")

    count = len(vulnerable_domains)
    my_print("\nTotal vulnerable subdomains with missing storage buckets: " + str(count), "INFOB")

    if count > 0:
        my_print("Vulnerable subdomains with missing storage buckets:", "INFOB")
        print_list(vulnerable_domains)
