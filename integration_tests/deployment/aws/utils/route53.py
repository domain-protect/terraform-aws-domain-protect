from integration_tests.deployment.aws.utils.sts import assume_test_role


def create_record_set(route53_account, zone_id, record_name, record_type, record_value):
    boto3_session = assume_test_role(route53_account)
    client = boto3_session.client(service_name="route53")
    response = client.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch={
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": record_name,
                        "Type": record_type,
                        "TTL": 300,
                        "ResourceRecords": [
                            {"Value": record_value},
                        ],
                    },
                },
            ],
        },
    )
    return response


def delete_record_set(route53_account, zone_id, record_name, record_type, record_value):
    boto3_session = assume_test_role(route53_account)
    client = boto3_session.client(service_name="route53")
    response = client.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch={
            "Changes": [
                {
                    "Action": "DELETE",
                    "ResourceRecordSet": {
                        "Name": record_name,
                        "Type": record_type,
                        "TTL": 300,
                        "ResourceRecords": [
                            {"Value": record_value},
                        ],
                    },
                },
            ],
        },
    )
    return response