#!/usr/bin/env python
from utils.utils_cloudflare import list_dns_records
from utils.utils_cloudflare import list_dns_zones
from utils.utils_dns import firewall_test
from utils.utils_dns import vulnerable_ns
from utils.utils_print import my_print
from utils.utils_print import print_list
from utils.utils_sanitise import filtered_ns_records_cf_v4


def main():
    vulnerable_domains = []

    print("Searching for vulnerable NS subdomains ...")
    i = 0
    zones = list_dns_zones()

    for zone in zones:
        records = list_dns_records(zone.id, zone.name)

        ns_records = filtered_ns_records_cf_v4(records, zone.name)
        for record in ns_records:
            i = i + 1
            result = vulnerable_ns(record.name)

            if result and record.name not in vulnerable_domains:
                vulnerable_domains.append(record.name)
                my_print(f"{str(i)}. {record.name}", "ERROR")

            if not result:
                my_print(f"{str(i)}. {record.name}", "SECURE")

    count = len(vulnerable_domains)
    my_print("\nTotal vulnerable NS subdomains found: " + str(count), "INFOB")

    if count > 0:
        my_print("Vulnerable NS subdomains:", "INFOB")
        print_list(vulnerable_domains)


if __name__ == "__main__":
    firewall_test()
    main()
