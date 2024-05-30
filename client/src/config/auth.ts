import { USER_POOL_CLIENT_ID, USER_POOL_ID } from '@/config/constants';
import { ResourcesConfig } from 'aws-amplify';

export const CognitoConfig: ResourcesConfig = {
  Auth: {
    Cognito: {
      userPoolClientId: USER_POOL_CLIENT_ID,
      userPoolId: USER_POOL_ID,
    },
  },
};
