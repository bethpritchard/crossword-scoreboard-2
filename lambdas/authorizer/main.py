import json
import jwt
from jwt import PyJWKClient
import os

# Your Cognito User Pool ID and the region where it's hosted
USER_POOL_ID = os.environ['USER_POOL_ID']
REGION = os.environ['AWS_REGION']
CLIENT_ID = os.environ['CLIENT_ID']

# Construct the URL to get the public keys from your User Pool
JWKS_URL = f'https://cognito-idp.{REGION}.amazonaws.com/{USER_POOL_ID}/.well-known/jwks.json'

def lambda_handler(event, context):
    token = event['headers'].get('Sec-WebSocket-Protocol')
    if not token:
        return {
            'statusCode': 401,
            'body': json.dumps({'message': 'Unauthorized'})
        }
    
    # token = token.split(' ')[1]  # Assuming the token is in the format "Bearer <token>"

    try:
        # Fetch and cache the JWKS
        jwks_client = PyJWKClient(JWKS_URL)
        signing_key = jwks_client.get_signing_key_from_jwt(token)
        
        # Decode the token and verify its signature and expiration
        decoded_token = jwt.decode(
            token,
            signing_key.key,
            algorithms=["RS256"],
            audience=CLIENT_ID,  # Replace with your actual client ID
            issuer=f'https://cognito-idp.{REGION}.amazonaws.com/{USER_POOL_ID}'
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Authorized', 'user': decoded_token})
        }
    except jwt.ExpiredSignatureError:
        return {
            'statusCode': 401,
            'body': json.dumps({'message': 'Token expired'})
        }
    except jwt.InvalidTokenError:
        return {
            'statusCode': 401,
            'body': json.dumps({'message': 'Invalid token'})
        }