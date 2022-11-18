import React,{useEffect} from 'react';
import {NavigationContainer} from '@react-navigation/native';
import Routes from './src/Routes/routes';
import { LogBox,StatusBar,BackHandler,Platform } from 'react-native';
import CartProvider from './src/Contexts/cart';


if(Platform.OS === 'android') {
  require('intl');
  require('intl/locale-data/jsonp/en-IN');
}

LogBox.ignoreAllLogs();//Ignore all log notifications

export default function App() {

  useEffect(() => {
    BackHandler.addEventListener('backPress', () => true)
    return () => BackHandler.removeEventListener('backPress', () => true)
  }, [])

  return (
      <NavigationContainer>
        <StatusBar hidden={true} />
        <CartProvider>
          <Routes/>
        </CartProvider>
      </NavigationContainer>
  );
}