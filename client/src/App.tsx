import Home from '@/pages/home';
import Login from '@/pages/login';

const isAuthenticated = true;

const App = () => {
  return <div>{isAuthenticated ? <Home /> : <Login />}</div>;
};

export default App;
