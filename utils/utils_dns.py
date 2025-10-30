import sys

import dns.flags
import dns.message
import dns.query
import dns.rdatatype
from dns import resolver

# Google public DNS servers
nameservers = ["8.8.8.8", "8.8.4.4"]
myresolver = resolver.Resolver()
myresolver.nameservers = nameservers


def vulnerable_ns(domain_name, update_scan=False):

    try:
        # A record lookup detects name servers not configured for domain
        myresolver.resolve(domain_name, "A")

    except resolver.NXDOMAIN:
        # domain does not exist
        return False

    except resolver.NoNameservers:
        # vulnerable domain
        return True

    except resolver.NoAnswer:
        # domain not vulnerable, no A record for domain
        return False

    except resolver.Timeout:
        if update_scan:
            # prevents reporting as fixed when DNS query timeout
            return True

        return False

    except Exception as e:
        # catch any unhandled exceptions in Lambda logs
        if update_scan:
            print(f"Unhandled exception testing DNS for NS records during update scan: {e}")
            return True

        print(f"Unhandled exception testing DNS for NS records during standard scan: {e}")

    return False


def vulnerable_cname(domain_name, update_scan=False):

    try:
        myresolver.resolve(domain_name, "A")
        return False

    except resolver.NXDOMAIN:
        try:
            myresolver.resolve(domain_name, "CNAME")
            return True

        except resolver.NoNameservers:
            return False

    except (resolver.NoAnswer, resolver.NoNameservers):
        return False

    except resolver.Timeout:
        if update_scan:
            return True

        return False

    except Exception as e:

        if update_scan:
            print(f"Unhandled exception testing DNS for CNAME records during update scan: {e}")
            return True

        print(f"Unhandled exception testing DNS for CNAME records during standard scan: {e}")

    return False


def vulnerable_alias(domain_name, update_scan=False):

    try:
        myresolver.resolve(domain_name, "A")
        return False

    except resolver.NoAnswer:
        return True

    except (resolver.NoNameservers, resolver.NXDOMAIN):
        return False

    except resolver.Timeout:
        if update_scan:
            return True

        return False


def dns_deleted(domain_name, record_type="A"):
    # DNS record type examples: A, CNAME, MX, NS

    try:
        myresolver.resolve(domain_name, record_type)

    except (resolver.NoAnswer, resolver.NXDOMAIN):
        print(f"DNS {record_type} record for {domain_name} no longer found")
        return True

    except (resolver.NoNameservers, resolver.NoResolverConfiguration, resolver.Timeout):
        return False

    return False


def updated_a_record(domain_name, ip_address):
    # returns first value only

    try:
        response = myresolver.resolve(domain_name, "A")

        for rdata in response:
            new_ip_address = rdata.to_text()
            if ip_address not in (new_ip_address, "test"):
                print(f"{domain_name} A record updated from {ip_address} to {new_ip_address}")

            return new_ip_address

    except (resolver.NoAnswer, resolver.NXDOMAIN):
        print(f"DNS A record for {domain_name} no longer found")
        return ip_address

    except (resolver.NoNameservers, resolver.NoResolverConfiguration, resolver.Timeout):
        return ip_address

    return ip_address


def get_nameservers_dns_non_recursive(domain_name):
    """
    Returns list of name servers for the given domain using non-recursive DNS query
    Queries parent domain's authoritative nameservers to obtain delegation records
    """
    try:
        # Get the parent domain
        domain_parts = domain_name.split(".")
        if len(domain_parts) < 2:
            print(f"Cannot determine parent domain for {domain_name}")
            return []

        parent_domain = ".".join(domain_parts[1:])

        # Get the authoritative name servers of the parent domain (recursive query)
        parent_nameservers = get_nameservers_dns(parent_domain)
        if not parent_nameservers:
            print(f"No parent nameservers found for {parent_domain}")
            return []

        # Resolve parent nameservers to IP addresses
        parent_nameserver_ips = []
        for ns in parent_nameservers:
            try:
                ns_response = myresolver.resolve(ns, "A")
                for rdata in ns_response:
                    parent_nameserver_ips.append(rdata.to_text())
                    break  # Use first IP address
            except Exception as ns_e:
                print(f"Could not resolve nameserver {ns} to IP: {ns_e}")
                continue

        if not parent_nameserver_ips:
            print(f"Could not resolve any parent nameservers to IP addresses")
            return []

        # Create a non-recursive DNS query for the subdomain
        query_msg = dns.message.make_query(domain_name, "NS")
        query_msg.flags &= ~dns.flags.RD  # Clear recursion desired flag

        nameservers = []

        # Try each parent nameserver IP until response
        for ns_ip in parent_nameserver_ips:
            try:
                response = dns.query.udp(query_msg, ns_ip, timeout=10)

                # Check if answer section received (delegation records)
                if response.answer:
                    for rrset in response.answer:
                        if rrset.rdtype == dns.rdatatype.NS:
                            for rdata in rrset:
                                ns = str(rdata).rstrip(".")
                                nameservers.append(ns)
                    break  # Response received, no need to try other nameservers

                # Check authority section for referrals
                elif response.authority:
                    for rrset in response.authority:
                        if rrset.rdtype == dns.rdatatype.NS and rrset.name.to_text().rstrip(".") == domain_name:
                            for rdata in rrset:
                                ns = str(rdata).rstrip(".")
                                nameservers.append(ns)
                    if nameservers:
                        break

            except dns.query.timeout:
                print(f"Timeout querying parent nameserver {ns_ip} for {domain_name}")
                continue
            except Exception as query_e:
                print(f"Failed to query parent nameserver {ns_ip} for {domain_name}: {query_e}")
                continue

        if not nameservers:
            print(f"No delegation records found for {domain_name} in parent zone")
            return []

        return sorted(nameservers)

    except Exception as e:
        print(f"Unhandled exception in non-recursive NS query for {domain_name}: {e}")
        return []


def get_nameservers_dns(domain_name):
    """
    Returns list of name servers for domain
    """
    try:
        response = myresolver.resolve(domain_name, "NS")
        nameservers = []

        for rdata in response:
            ns = rdata.to_text().rstrip(".")
            nameservers.append(ns)

        return sorted(nameservers)

    except resolver.NXDOMAIN:
        print(f"Domain {domain_name} does not exist")
        return []

    except resolver.NoAnswer:
        print(f"No NS records found for {domain_name}")
        return []

    except resolver.NoNameservers:
        print(f"No name servers available to query {domain_name}")
        return []

    except resolver.Timeout:
        print(f"DNS query timeout for {domain_name}")
        return []

    except Exception as e:
        print(f"Unhandled exception querying NS records for {domain_name}: {e}")
        return []


def firewall_test():
    result = updated_a_record("google.com", "test")

    if result == "test":
        print("No access to Google DNS servers, exiting")

        sys.exit()
