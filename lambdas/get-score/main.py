import json
import boto3

client = boto3.client("dynamodb")


def lambda_handler(event, context):

    try:
        response = client.batch_get_item(
            RequestItems={
                "crossword-scoreboard-db": {
                    "Keys": [{"name": {"S": "Beth"}}, {"name": {"S": "Chloe"}}]
                }
            }
        )["Responses"]["crossword-scoreboard-db"]

        scores = {item["name"]["S"]: item["score"]["N"] for item in response}

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
