import os
import boto3

dynamodb = boto3.resource("dynamodb")


def lambda_handler(event, context):
    table = dynamodb.Table(os.environ["DB_TABLE_NAME"])

    connection_id = event["requestContext"]["connectionId"]
    try:
        table.delete_item(Key={"connectionId": connection_id})
        return {"statusCode": 200, "body": "Disconnected."}
    except Exception as e:
        return {"statusCode": 501, "body": str(e)}
