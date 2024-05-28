import { CognitoConfig } from '@/config/auth';
import Home from '@/pages/home';
import SignIn from '@/pages/signIn';
import { Amplify } from 'aws-amplify';
import { signIn, getCurrentUser } from 'aws-amplify/auth';
import { useEffect, useState } from 'react';

Amplify.configure(CognitoConfig);

const App = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(true);
  const [username, setUsername] = useState('');

  useEffect(() => {
    getCurrentUser()
      .then((result) => {
        setUsername(result.username);
        console.log(result);
        setIsAuthenticated(true);
        setIsLoading(false);
      })
      .catch(() => {
        setUsername('');
        setIsAuthenticated(false);
        setIsLoading(false);
      });
  }, []);

  const handleSignIn = (username, password) => {
    signIn({ username: 'beth', password: 'Password1.' })
      .then((result) => {
        console.log(result);

        setIsAuthenticated(true);
      })
      .catch(() => {
        setUsername('');
        setIsAuthenticated(false);
      });
  };

  return (
    <div className="h-screen">
      {isAuthenticated ? <Home /> : <SignIn onSignIn={handleSignIn} />}
    </div>
  );
};

export default App;
