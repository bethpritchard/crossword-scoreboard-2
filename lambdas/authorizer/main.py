import jwt

def lambda_handler(event, context):
    print(event)
#     c

#     # Get the JWT token from the event
#     token = event['authorizationToken']
    
#     try:
#         # Verify and decode the JWT token
#         decoded_token = jwt.decode(token, algorithms=['HS256'], options={'verify_signature': False})
        
#         # Perform additional validation if needed
        
#         # Return an IAM policy for the user
#         return generate_policy(decoded_token['sub'], 'Allow', event['methodArn'])
    
#     except jwt.exceptions.InvalidTokenError:
#         # Return an IAM policy denying access
#         return generate_policy(None, 'Deny', event['methodArn'])

# # def generate_policy(principal_id, effect, resource):
#     policy = {
#         'principalId': principal_id,
#         'policyDocument': {
#             'Version': '2012-10-17',
#             'Statement': [
#                 {
#                     'Action': 'execute-api:Invoke',
#                     'Effect': effect,
#                     'Resource': resource
#                 }
#             ]
#         }
#     }
#     return policy