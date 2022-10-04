import { registerRootComponent } from 'expo';
import {Platform} from 'react-native'

if(Platform.OS === 'android') {
    require('intl');
    require('intl/locale-data/jsonp/en-IN');
  }

import App from './App';


registerRootComponent(App);
