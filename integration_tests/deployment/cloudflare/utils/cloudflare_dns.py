# Cloudflare Python version 3.1.1 - DNS Utils
from cloudflare import Cloudflare
from cloudflare import CloudflareError


def create_dns_record(zone_id, zone_name, record_name, record_type, record_value, ttl=60):
    cf = Cloudflare()
    print(f"Creating DNS record {record_name} in Cloudflare DNS zone {zone_name}")

    try:
        cf.dns.records.create(zone_id=zone_id, name=record_name, type=record_type, content=record_value, ttl=ttl)
        print(f"Successfully created DNS record {record_name} in Cloudflare DNS zone {zone_name}")
    except CloudflareError as e:
        print(f"Failed to create DNS record {record_name} in Cloudflare DNS zone {zone_name}")
        print(f"Error: {e}")


def delete_dns_record(zone_id, record_id, record_fqdn):
    cf = Cloudflare()
    print(f"Deleting Cloudflare DNS record {record_fqdn}")

    try:
        cf.dns.records.delete(zone_id=zone_id, dns_record_id=record_id)
        print(f"Successfully deleted Cloudflare DNS record {record_fqdn}")
    except CloudflareError as e:
        print(f"Failed to delete Cloudflare DNS record {record_fqdn}")
        print(f"Error: {e}")


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
