// Used https://dev.to/aws-builders/how-to-use-amazon-cognito-with-reacttypescript-4elj to implement this file.

import { CognitoConfig } from '@/config/auth';
import { Amplify } from 'aws-amplify';
import { createContext, useContext, useEffect, useState } from 'react';
import { signIn, getCurrentUser } from 'aws-amplify/auth';

Amplify.configure(CognitoConfig);

interface UseAuth {
  isLoading: boolean;
  isAuthenticated: boolean;
  username: string;
  signIn: (username: string, password: string) => void;
  signOut: () => void;
}

type Props = {
  children?: React.ReactNode;
};

const authContext = createContext({} as UseAuth);

export const ProvideAuth: React.FC<Props> = ({ children }) => {
  const auth = useProvideAuth();
  return <authContext.Provider value={auth}>{children}</authContext.Provider>;
};

export const useAuth = () => {
  return useContext(authContext);
};

const useProvideAuth = (): UseAuth => {
  const [isLoading, setIsLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [username, setUsername] = useState('');

  useEffect(() => {
    getCurrentUser()
      .then((result) => {
        setUsername(result.username);
        setIsAuthenticated(true);
        setIsLoading(false);
      })
      .catch(() => {
        setUsername('');
        setIsAuthenticated(false);
        setIsLoading(false);
      });
  }, []);

  const signUserIn = async (username: string, password: string) => {
    try {
      const result = await signIn({ username, password });
      setUsername(result.username);
      setIsAuthenticated(true);
      return { success: true, message: '' };
    } catch (error) {
      return {
        success: false,
        message: 'LOGIN FAIL',
      };
    }
  };
  

  signIn({username, password}).then((result) => { console.log(result); });.

  const signOut = async () => {
    try {
      await Auth.signOut();
      setUsername('');
      setIsAuthenticated(false);
      return { success: true, message: '' };
    } catch (error) {
      return {
        success: false,
        message: 'LOGOUT FAIL',
      };
    }
  };

  return {
    isLoading,
    isAuthenticated,
    username,
    signIn,
    signOut,
  };
};
