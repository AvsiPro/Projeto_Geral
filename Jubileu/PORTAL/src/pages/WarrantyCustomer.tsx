import React, {useState, useEffect, useContext} from "react";

import * as Style from './styles'; 

import Navbar from "../components/navbar";
import Header from "../components/header";

import { useMediaQuery } from 'react-responsive';

import WarrantyComponent from "../components/warrantyComponent";

import { fetchData } from "../services/apiWarranty";

const WarrantyCustomer: React.FC = () => {

  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

  const [warranty, setWarranty] = useState<any>([])
  const [load, setLoad] = useState<boolean>(false)

  useEffect(() => {
      loadItems()
  }, [])

  const loadItems = async () => {

    setLoad(true)

    const userData = localStorage.getItem('userdata');
    const user = userData ? JSON.parse(userData) : null;

      const returnResult: any = await fetchData(1, user.token)
      
      if(returnResult.length > 0){
          const resultAux = [...warranty, ...returnResult]

          const auxResult = resultAux.reduce((acc: any, current: any) => {
            const x = acc.find((item: { id: any; }) => item.id === current.id);
            return !x ? acc.concat([current]) : acc;
        }, []);

        const sortedResult = [...auxResult].sort((a, b) => {
          return b.warranty.localeCompare(a.warranty);
        });

        setWarranty(sortedResult);
      }
      
      setLoad(false)
  };



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
            <WarrantyComponent
              warranty={warranty}
              load={load}
              handleLoadItems={loadItems}
            />
          </div>
          
      </Style.Container>
    </Style.CustComponent>
  );
};

export default WarrantyCustomer;
