import json
import os
import boto3

WEB_SOCKET_API_ID = os.environ["WEB_SOCKET_API_ID"]
WEBSOCKET_API_STAGE = os.environ["WEBSOCKET_API_STAGE"]
REGION = os.environ["AWS_REGION"]

SCORE_TABLE_NAME = os.environ["DB_TABLE_NAME"]
CONNECTION_TABLE_NAME = os.environ["CONNECTION_TABLE_NAME"]

ENDPOINT_URL = f"https://{WEB_SOCKET_API_ID}.execute-api.{REGION}.amazonaws.com/{WEBSOCKET_API_STAGE}"

dynamodb = boto3.resource("dynamodb")
api_gateway = boto3.client("apigatewaymanagementapi", endpoint_url=ENDPOINT_URL)

def lambda_handler(event, context):
    score_table = dynamodb.Table(
        SCORE_TABLE_NAME
    )
    connection_table = dynamodb.Table(CONNECTION_TABLE_NAME)

    body = json.loads(event["body"])
    player_name = body["playerName"]
    score = body["score"]


    score_table.update_item(
        Key={"name": player_name},
        UpdateExpression="set score = :s",
        ExpressionAttributeValues={":s": int(score)},
        ReturnValues="UPDATED_NEW",
    )

    response = connection_table.scan()
    connections = response.get("Items", [])

    message = {"action": "scoreUpdate", "playerName": player_name, "score": score}

    for connection in connections:
        try:    
            api_gateway.post_to_connection(
                ConnectionId=connection["connectionId"], Data=json.dumps(message)
            )
        except api_gateway.exceptions.GoneException:
            connection_table.delete_item(Key={"connectionId": connection["connectionId"]})


    return {
        'statusCode': 200,
        'body': json.dumps('Score updated and broadcasted.')
    }