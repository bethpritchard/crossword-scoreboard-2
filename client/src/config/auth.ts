export const CognitoConfig = {
  Auth: {
    Cognito: {
      userPoolClientId: process.env.REACT_APP_AWS_USER_POOL_WEB_CLIENT_ID!,
      userPoolId: process.env.REACT_APP_AWS_USER_POOL_ID!,
    },
  },
};
