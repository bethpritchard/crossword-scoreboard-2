import React from 'react';
import ReactDOM from 'react-dom/client';
import { ProvideAuth } from '@/hooks/useAuth';

import App from '@/App';

import './globals.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ProvideAuth>
      <App />
    </ProvideAuth>
  </React.StrictMode>,
);
