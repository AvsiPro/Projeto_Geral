import React, { useContext } from "react";

import * as Style from './styles'; 

import Navbar from "../components/navbar";
import Header from "../components/header";

import { useMediaQuery } from 'react-responsive';

import { WindowDimensionsContext } from "../contexts/WindowDimensionsContext";

import FinancialBodyModal from "../components/financialBodyModal";

const FinancialCustomer: React.FC = () => {

  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

  const { windowDimensions } = useContext(WindowDimensionsContext);

  const userData = localStorage.getItem('userdata');
  const user = userData ? JSON.parse(userData) : null;

  const financialCustomer = {
    cnpj: user.type === 'V' ? '' : user.user,
    name: 'Títulos'
  }

  return (
    <Style.CustComponent>
      
      {/* Menu lateral */
      !isMobile &&
        <Navbar/>
      }
      <Style.Container isMobile={isMobile}>
          
          {/* Header */}
          <Header/>

          {/* Tablea */}
          <div style={{margin: !isMobile ? 50 : 0}}>
            <Style.CustomersComponent
                windowDimensions={windowDimensions}
                modal={false}
                isMobile={isMobile}
            >
              <FinancialBodyModal
                financialCustomer={financialCustomer}
                type={user.type !== 'V' ? '' : 'v'}
              />
            </Style.CustomersComponent>
          </div>
          
      </Style.Container>
    </Style.CustComponent>
  );
};

export default FinancialCustomer;
