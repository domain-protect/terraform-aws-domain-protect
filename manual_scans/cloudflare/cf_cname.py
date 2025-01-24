#!/usr/bin/env python
from utils.utils_cloudflare_v4 import list_dns_records
from utils.utils_cloudflare_v4 import list_dns_zones
from utils.utils_dns import firewall_test
from utils.utils_dns import vulnerable_cname
from utils.utils_print import my_print
from utils.utils_print import print_list


vulnerable_domains = []
vulnerability_list = ["azure", ".cloudapp.net", "core.windows.net", "elasticbeanstalk.com", "trafficmanager.net"]

if __name__ == "__main__":

    firewall_test()

    print("Searching for vulnerable CNAMEs ...")
    i = 0
    zones = list_dns_zones()

    for zone in zones:
        records = list_dns_records(zone.id, zone.name)

        cname_records = [
            r
            for r in records
            if r.type == "CNAME" and any(vulnerability in r.content for vulnerability in vulnerability_list)
        ]
        for record in cname_records:
            i = i + 1
            result = vulnerable_cname(record.name)

            if result:
                vulnerable_domains.append(record.name)
                my_print(f"{str(i)}. {record.name}", "ERROR")
            else:
                my_print(f"{str(i)}. {record.name}", "SECURE")

    count = len(vulnerable_domains)
    my_print("\nTotal vulnerable CNAMEs found: " + str(count), "INFOB")

    if count > 0:
        my_print("Vulnerable CNAMEs:", "INFOB")
        print_list(vulnerable_domains)
