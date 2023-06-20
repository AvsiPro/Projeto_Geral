import React from 'react';
import './App.css';

import RoutesApp from './routes/routes';
import ThemeProvider from "./components/ThemeProvider";

import { WindowDimensionsProvider } from './contexts/WindowDimensionsContext';
import { CartProvider } from './contexts/CartContext';
import { UserProvider } from './contexts/userContext';

const App: React.FC = () => {

  return (
    <React.StrictMode>
    <ThemeProvider>
      <UserProvider>
        <CartProvider>
          <WindowDimensionsProvider>
            <RoutesApp />
          </WindowDimensionsProvider>
        </CartProvider>
      </UserProvider>
    </ThemeProvider>
  </React.StrictMode>
  );
};

export default App;
