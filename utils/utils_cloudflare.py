# Cloudflare Python version 4.0.0 - DNS Utils
from cloudflare import Cloudflare
from cloudflare import CloudflareError


def list_dns_records(zone_id, zone_name, record_fqdn=None):
    cf = Cloudflare()
    print(f"Listing DNS records in Cloudflare DNS zone {zone_name}")

    try:
        records = cf.dns.records.list(zone_id=zone_id, name=record_fqdn).result
        print(f"Successfully listed DNS records in Cloudflare DNS zone {zone_name}")
        return records
    except CloudflareError as e:
        print(f"Failed to list DNS records in Cloudflare DNS zone {zone_name}")
        print(f"Error: {e}")
        return None


def list_dns_zones():
    cf = Cloudflare()
    print("Listing DNS zones in Cloudflare")

    try:
        zones = cf.zones.list().result
        print("Successfully listed DNS zones in Cloudflare")
        return zones
    except CloudflareError as e:
        print("Failed to list DNS zones in Cloudflare")
        print(f"Error: {e}")
        return None


def convert_cf_records_to_dict(cf_records):
    records = []

    for cf_record in cf_records:
        records.append(
            {"Name": cf_record.name, "Type": cf_record.type, "Value": cf_record.content},
        )

    return records
