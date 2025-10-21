import ast
import ipaddress
import os


networks_str = os.environ.get("NETWORKS", "[]")
networks = ast.literal_eval(networks_str)


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
