import { useAuth } from '@/hooks/useAuth';
import { useState } from 'react';

const SignIn = () => {
  const auth = useAuth();

  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const result = await auth.handleSignIn(username, password);
    if (!result.success) {
      setError(result.message);
    }
  };

  return (
    <div className="h-full flex flex-col justify-evenly items-center">
      <form className="" onSubmit={handleSubmit}>
        <div className="md:flex md:flex-col md:items-center mb-6">
          <h1>Sign In</h1>
          {error && <p>{error}</p>}
        </div>
        <div className="md:flex md:items-center mb-6">
          <div className="md:w-1/3">
            <label className="block text-gray-500 font-bold md:text-right mb-1 md:mb-0 pr-4">
              Username
            </label>
          </div>
          <div className="md:w-2/3">
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
            />
          </div>
        </div>
        <div className="md:flex md:items-center mb-6">
          <div className="md:w-1/3">
            <label className="block text-gray-500 font-bold md:text-right mb-1 md:mb-0 pr-4">
              Password
            </label>
          </div>
          <div className="md:w-2/3">
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </div>
        </div>
        <div className="md:flex md:items-center">
          <div className="md:w-1/3"></div>
          <div className="md:w-2/3">
            <button type="submit">Sign In</button>
          </div>
        </div>
      </form>
    </div>
  );
};

export default SignIn;
