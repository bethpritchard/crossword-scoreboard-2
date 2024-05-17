import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("crossword-scoreboard-db")  # Give this to the lambda


def lambda_handler(event, context):

    try:

        table.update_item(
            Key={"name": event["playerName"]},
            UpdateExpression="set score = :s",
            ExpressionAttributeValues={":s": event["score"]},
            ReturnValues="UPDATED_NEW",
        )

    except Exception as e:
        return {"statusCode": 500, "body": str(e)}

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": "Table updated successfully.",
    }
