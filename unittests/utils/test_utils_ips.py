from unittest.mock import patch

from assertpy import assert_that

from utils.utils_ips import is_ip_in_network
from utils.utils_ips import is_ip_in_networks


def test_is_ip_in_network():
    ip = "192.168.1.10"
    network = "192.168.1.0/24"

    result = is_ip_in_network(ip, network)

    assert_that(result).is_true()


def test_is_ip_not_in_network():
    ip = "192.168.2.10"
    network = "192.168.1.0/24"

    result = is_ip_in_network(ip, network)

    assert_that(result).is_false()


@patch("utils.utils_ips.networks", ["192.168.1.0/24", "10.0.0.0/8"])
def test_is_ip_in_networks():
    ip = "192.168.1.10"

    result = is_ip_in_networks(ip)

    assert_that(result).is_true()


@patch("utils.utils_ips.networks", ["192.168.1.0/24", "10.0.0.0/8"])
def test_is_ip_not_in_networks():
    ip = "172.16.1.10"

    result = is_ip_in_networks(ip)

    assert_that(result).is_false()


@patch("utils.utils_ips.networks", [])
def test_is_ip_in_networks_no_networks():
    ip = "192.168.1.10"
    result = is_ip_in_networks(ip)
    assert_that(result).is_false()
