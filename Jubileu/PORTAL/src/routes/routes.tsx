import React, { useContext } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';

import Login from '../pages/Login';
import Dashboard from '../pages/Dashboard';
import Customers from '../pages/Customers';
import Products from '../pages/Products';
import Orders from '../pages/Orders';

import Home from '../pages/Home';
import FinancialCustomer from '../pages/FinancialCustomer';
import InvoicesCustomer from '../pages/InvoicesCustomer';
import WarrantyCustomer from '../pages/WarrantyCustomer';

import ChangePassWord from '../pages/ChangePassword';
import { UserContext } from '../contexts/userContext';

const RoutesApp: React.FC = () => {

  const { userContext } = useContext(UserContext)

  const checkUserAccess = (route: string): boolean => {

    let userProfile = userContext.type;

    if(!userProfile){
      const userData = localStorage.getItem('userdata');
      const user = userData ? JSON.parse(userData) : null;

      if (!!user){
        userProfile = user.type
      }
    }
  
    if ((
        route === '/dashboard' || 
        route === '/customers' || 
        route === '/orders'
      ) && userProfile !== 'V') {
      return false;
    }
  
    if ((
        route === '/home' ||
        route === '/financialcustomer' ||
        route === '/invoicescustomer'  ||
        route === '/warrantycustomer' 
      ) && userProfile !== 'C') {
      return false;
    }
    
    return true;
  }
  
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/dashboard" element={checkUserAccess('/dashboard') ? <Dashboard /> : <Navigate to="/home" />} />
        <Route path="/customers" element={checkUserAccess('/customers') ? <Customers /> : <Navigate to="/home" />} />
        <Route path="/products" element={checkUserAccess('/products') ? <Products /> : <Navigate to="/home" />} />
        <Route path="/orders" element={checkUserAccess('/orders') ? <Orders /> : <Navigate to="/home" />} />

        <Route path="/home" element={checkUserAccess('/home') ? <Home /> : <Navigate to="/dashboard" />} />
        <Route path="/financialcustomer" element={checkUserAccess('/financialcustomer') ? <FinancialCustomer /> : <Navigate to="/dashboard" />} />
        <Route path="/invoicescustomer" element={checkUserAccess('/invoicescustomer') ? <InvoicesCustomer /> : <Navigate to="/dashboard" />} />
        <Route path="/warrantycustomer" element={checkUserAccess('/warrantycustomer') ? <WarrantyCustomer /> : <Navigate to="/dashboard" />} />

        <Route path="/changepassword" element={ <ChangePassWord /> } />
      </Routes>
    </Router>
  );
};



export default RoutesApp;