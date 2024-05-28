interface SignInProps {
  onSignIn: (username: string, password: string) => void;
}

const SignIn = ({ onSignIn }: SignInProps) => {
  const handleSubmit = (event: React.FormEvent) => {
    event.preventDefault();
    const username = (event.target as HTMLFormElement).elements.username.value;
    const password = (event.target as HTMLFormElement).elements.password.value;
    onSignIn(username, password);
  };

  return (
    <div className="login">
      <h1>Login</h1>
      <form onSubmit={handleSubmit}>
        <label>Username</label>
        <input type="text" name="username" />
        <label>Password</label>
        <input type="password" name="password" />
        <button type="submit">Login</button>
      </form>
    </div>
  );
};

export default SignIn;
