import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("crossword-scoreboard-db")


def lambda_handler(event, context):
    try:
        table.update_item(
            Key={"name": event["playerName"]},
            UpdateExpression="set score = :s",
            ExpressionAttributeValues={":s": event["score"]},
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
