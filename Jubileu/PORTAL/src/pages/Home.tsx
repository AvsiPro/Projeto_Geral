import React, {useState, useEffect} from "react";

import * as Style from './styles'; 

import Navbar from "../components/navbar";
import Header from "../components/header";

import { useMediaQuery } from 'react-responsive';

const Home: React.FC = () => {

  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });


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

          </div>
          
      </Style.Container>
    </Style.CustComponent>
  );
};

export default Home;
