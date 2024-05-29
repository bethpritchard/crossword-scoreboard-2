import { useAuth } from '@/hooks/useAuth';
import Home from '@/pages/home';
import SignIn from '@/pages/signIn';

const App = () => {
  const auth = useAuth();

  if (auth.isLoading) {
    return <div>Loading...</div>;
  }

  return (
    <div className="h-screen">
      {auth.isAuthenticated ? <Home /> : <SignIn />}
    </div>
  );
};

export default App;
