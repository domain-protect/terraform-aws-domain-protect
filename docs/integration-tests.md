# Integration Tests

## Overview

Domain protect uses `pytest` to run unit tests against the code, and will fail the build if any tests fail.  All integration tests live under the `integration_tests` folder in the root of the solution.

Integration tests test a single flow through the application, involving multiple units interacting.  This ensures flows through the application provide the correct results when the units work together.

## Integration Tests - Manual Scans

Integration tests for manual scans have been set up using Mocks to simulate the responses from AWS or CloudFlare. They can therefore easily be run locally.

## Integration Tests - Deployment

Deployment integration tests are set up without using Mocks, as follows:

* plan and apply Terraform within an AWS Account in a test AWS Organization
* create deliberately vulnerable DNS records in AWS
* create deliberately vulnerable DNS records in CloudFlare
* trigger the appropriate Domain Protect Lambda functions
* ensure that the vulnerabilities are detected in the specified timeframe, by querying DynamoDB
* delete the vulnerable DNS records
* ensure the vulnerabilities are marked as fixed within the database.

## Running tests locally

See [Automated Tests](automated-tests.md) for details on how to set up manual scan tests locally.

See the Integration Tests Deployment [README](https://github.com/domain-protect/terraform-aws-domain-protect/tree/main/integration_tests/deployment) for instructions on testing and developing end-to-end tests locally.

## Creating new integration tests

* Integration tests should test a flow through the application, only mocking out external dependencies such as AWS, DNS and CloudFlare.
* Use the mock fixtures (see the mocking section below) to mock out these external dependencies
* Where simple mocks are required to confirm output (such as `my_print`) use the `patch` attribute from `unittest.mock` to inject dependencies into your tests

## Mocking

### Mocking CloudFlare

There is a custom CloudFlare mock in the `integration_tests/mocks` folder.  This mock allows you to set up CloudFlare DNS zones and records in your integration tests that will be used when the code under test calls out to CloudFlare.

```
cloudflare_mock.add_zone("test2.co.uk").add_dns("*.test2.co.uk", "A", "192.168.1.1").build()
```

The CloudFlare mock is set up in a pytest fixture in `integration_tests/conftest.py`, so to use the mock in a test simply add `cloudflare_mock` to your tests parameter list and pytest will pass in an instance of the mock.

### Mocking DNS

There is a custom DNS mock in the` integration_tests/mocks` folder.  This mock allows you to set up responses from DNS that will be returned when the code under test calls `dns.resolver.resolve`.

To set up a DNS response in your test

```
dns_mock.add_lookup("sub.ns.co.uk", "sub.ns.co.uk", content="127.0.0.1")
```

To set up the DNS mock to throw an error:

```
dns_mock.add_lookup("sub.ns.co.uk", "sub.ns.co.uk", exception=dns.resolver.NoNameservers)
```

The DNS mock is set up in a pytest fixture in `integration_tests/conftest.py`, so to use the mock in a test simply add `dns_mock` to your tests parameter list and pytest will pass in an instance of the mock.

### Mocking AWS

We are using the moto python module for mocking out AWS, and setting these up using custom features.  To set up an AWS service for mocking please copy the `moto_route53` function from `integration_tests/conftest.py`, rename it to `moto_[service_name]` and replace the mock inside the function with the moto service you require.

Then in the test you require the mock you can use the function name (e.g. `moto_route53`) as the parameter.  You can then use the mock as if it was the boto3 library to create the resources you need for testing, which will be created in a mocked out aws account.


see also [Automated Tests](automated-tests.md)
