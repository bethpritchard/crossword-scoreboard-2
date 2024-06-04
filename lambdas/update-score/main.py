import boto3
import os

dynamodb = boto3.resource("dynamodb")


def lambda_handler(event, context):
    table_name = os.environ["DB_TABLE_NAME"]
    table = dynamodb.Table(table_name)
    try:
        table.update_item(
            Key={"name": event["playerName"]},
            UpdateExpression="set score = :s",
            ExpressionAttributeValues={":s": int(event["score"])},
            ReturnValues="UPDATED_NEW",
        )
        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            "body": "Table updated successfully.",
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            "body": str(e),
        }
