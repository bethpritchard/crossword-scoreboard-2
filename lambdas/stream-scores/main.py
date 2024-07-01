import json
import os
import boto3

WEBSOCKET_API_ID = os.environ["WEBSOCKET_API_ID"]
WEBSOCKET_API_STAGE = os.environ["WEBSOCKET_API_STAGE"]
REGION = os.environ["AWS_REGION"]

SCORE_TABLE_NAME = os.environ["SCORE_TABLE_NAME"]
CONNECTION_TABLE_NAME = os.environ["CONNECTION_TABLE_NAME"]

ENDPOINT_URL = f"https://{WEBSOCKET_API_ID}.execute-api.{REGION}.amazonaws.com/{WEBSOCKET_API_STAGE}"

dynamodb = boto3.resource("dynamodb")
api_gateway = boto3.client("apigatewaymanagementapi", endpoint_url=ENDPOINT_URL)

def get_details(event):
    body = json.loads(event["body"])
    player_name = body["playerName"]
    score = body["score"]
    return player_name, score

def update_score(player_name, score):
    score_table = dynamodb.Table(SCORE_TABLE_NAME)
    try:
        score_table.update_item(
            Key={"name": player_name},
            UpdateExpression="set score = :s",
            ExpressionAttributeValues={":s": int(score)},
            ReturnValues="UPDATED_NEW",
        )
    except Exception as e:
        print(f"Error updating score for {player_name}: {e}")
        raise e

def lambda_handler(event, context):
    player_name, score = get_details(event)

    update_score(player_name=player_name, score=score)


    try: 
        score_table = dynamodb.Table(
            SCORE_TABLE_NAME
        )
        connection_table = dynamodb.Table(CONNECTION_TABLE_NAME)

        body = json.loads(event["body"])
        player_name = body["playerName"]
        score = body["score"]

        print(f"Updating score for {player_name} to {score}")

        try: 

            score_table.update_item(
                Key={"name": player_name},
                UpdateExpression="set score = :s",
                ExpressionAttributeValues={":s": int(score)},
                ReturnValues="UPDATED_NEW",
            )
        except Exception as e:
            return {
                "statusCode": 500,
                "body": json.dumps(str(e))
            }

        response = connection_table.scan()
        connections = response.get("Items", [])
        print(f"Found {len(connections)} connections")

        message = {"action": "scoreUpdate", "playerName": player_name, "score": score}

        for connection in connections:
            try:    
                api_gateway.post_to_connection(
                    ConnectionId=connection["connectionId"], Data=json.dumps(message)
                )
                print(f"Broadcasted score to {connection['connectionId']}")
            except api_gateway.exceptions.GoneException:
                connection_table.delete_item(Key={"connectionId": connection["connectionId"]})
                print(f"Deleted stale connection {connection['connectionId']}")#



        return {
            'statusCode': 200,
            'body': json.dumps('Score updated and broadcasted.')
        }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(str(e))
        }