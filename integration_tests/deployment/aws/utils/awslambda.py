import json

import boto3


def invoke_lambda(function_name, payload=json.dumps([{}, {}])):
    client = boto3.client("lambda")
    response = client.invoke(
        FunctionName=function_name,
        InvocationType="Event",
        Payload=payload,
    )
    print(f"Lambda function {function_name} invoked")
    return response
