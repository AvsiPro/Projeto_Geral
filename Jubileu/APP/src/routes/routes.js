import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';

import Welcome from '../screens/welcome';
import Login from '../screens/login/index'
import Home from '../screens/home/index'
import Orders from '../screens/sections/orders';
import Products from '../screens/sections/products';
import Customers from '../screens/sections/customers';
import Neworder from '../screens/sections/newOrder';
import Profile from '../screens/profile';

const Stack = createStackNavigator();

export default function Routes(){
    return(
        <Stack.Navigator screenOptions={{gestureEnabled: false, headerShown: false}}>
            <Stack.Screen name="Welcome" component={Welcome}/>
            <Stack.Screen name="Login" component={Login}/>
            <Stack.Screen name="Home" component={Home}/>
            <Stack.Screen name="Products" component={Products}/>
            <Stack.Screen name="Customers" component={Customers}/>
            <Stack.Screen name="Orders" component={Orders}/>
            <Stack.Screen name="Neworder" component={Neworder}/>
            <Stack.Screen name="Profile" component={Profile}/>
        </Stack.Navigator>
    )
};