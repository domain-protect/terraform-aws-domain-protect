import ipaddress
import os

# environment variable AWS_IP_ADDRESSES can be empty, or with format: "'3.5.140.1', '3.5.140.128/30'"
networks_str = os.environ.get("AWS_IP_ADDRESSES")
networks = networks_str.replace(" ", "").split(",") if networks_str else []


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
