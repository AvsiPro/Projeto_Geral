import React from 'react';
import {NavigationContainer} from '@react-navigation/native';
import Routes from './src/Routes/routes';
import { LogBox,StatusBar } from 'react-native';
import CartProvider from './src/Contexts/cart';


LogBox.ignoreAllLogs();//Ignore all log notifications


export default function App() {
  return (
      <NavigationContainer>
        <StatusBar hidden={true} />
        <CartProvider>
          <Routes/>
        </CartProvider>
      </NavigationContainer>
  );
}