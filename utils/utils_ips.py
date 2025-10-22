import ipaddress
import os

# environment variable NETWORKS can be empty, or with format: "'56.0.0.0/8', '34.77.1.243/32'"
networks_str = os.environ.get("NETWORKS")
networks = networks_str.split(",") if networks_str else []


def is_ip_in_network(ip, network):
    # checks if the given IP address is in the specified network
    ip_obj = ipaddress.ip_address(ip)
    network_obj = ipaddress.ip_network(network, strict=False)
    return ip_obj in network_obj


def is_ip_in_networks(ip):
    # checks if the given IP address is in any of the specified networks
    for network in networks:
        if is_ip_in_network(ip, network):
            return True
    return False
