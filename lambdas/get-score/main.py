import json
import boto3
import os

client = boto3.client("dynamodb")


def lambda_handler(event, context):
    table_name = os.environ["DB_TABLE_NAME"]

    try:
        response = client.batch_get_item(
            RequestItems={
                table_name: {
                    "Keys": [{"name": {"S": "Beth"}}, {"name": {"S": "Chloe"}}]
                }
            }
        )["Responses"][table_name]

        scores = {item["name"]["S"]: int(item["score"]["N"]) for item in response}

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            "body": str(e),
        }

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        "body": json.dumps(scores),
    }
