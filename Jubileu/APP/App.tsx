import React, { useContext, useEffect } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import Routes from './src/routes/routes';
import { AppProvider } from './src/contexts/globalContext';
import { LogBox, StatusBar, BackHandler, Platform } from 'react-native';
import { BarCodeScanner } from 'expo-barcode-scanner';

import * as Updates from "expo-updates";

import 'react-native-reanimated'
import 'react-native-gesture-handler'

if(Platform.OS === 'android') {
  require('intl');
  require('intl/locale-data/jsonp/en-IN');
}

LogBox.ignoreAllLogs();//Ignore all log notifications
LogBox.ignoreLogs(['Warning: ...']); // Ignore log notification by message

const App: React.FC = () => {

  useEffect(() => {
    const getBarCodeScannerPermissions = async () => {
      await BarCodeScanner.requestPermissionsAsync();
    };

    getBarCodeScannerPermissions();
  }, []);


  useEffect(() => {
    async function updateApp() {
      const { isAvailable } = await Updates.checkForUpdateAsync();
      if (isAvailable) {
        await Updates.fetchUpdateAsync();
        await Updates.reloadAsync();
      }
    }
    updateApp();
  }, []);

  
  useEffect(() => {
    BackHandler.addEventListener('hardwareBackPress', () => true)
    return () => BackHandler.removeEventListener('hardwareBackPress', () => true)
  }, [])

  return (
    <AppProvider>
      <NavigationContainer>
        <StatusBar translucent backgroundColor={'#121214'} />
          <Routes/>
      </NavigationContainer>
    </AppProvider>
  );
};


export default App;