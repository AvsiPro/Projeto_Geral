import React, {useState, useEffect, useContext} from "react";

import * as Style from './styles'; 

import Navbar from "../components/navbar";
import Header from "../components/header";

import { useMediaQuery } from 'react-responsive';
import InvoicingCustomer from "../components/InvoicingCustomer";

import { fetchData } from "../services/apiInvoices";

const InvoicesCustomer: React.FC = () => {

  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });


  const [invoices, setInvoices] = useState<any>([])
  const [load, setLoad] = useState<boolean>(false)
  const [page, setPage] = useState<number>(1)

  useEffect(() => {
      if(page === 1){
          setLoad(true)
      }

      const loadItems = async () => {

        const userData = localStorage.getItem('userdata');
        const user = userData ? JSON.parse(userData) : null;

          const returnResult: any = await fetchData(page, user.token, 'C')
  
          if(returnResult.length > 0){

              const resultAux = [...invoices, ...returnResult]
            
              const auxResult = resultAux.reduce((acc: any, current: any) => {
                  const x = acc.find((item: { id: any; }) => item.id === current.id);
                  return !x ? acc.concat([current]) : acc;
              }, []);
      
              setInvoices(auxResult);
          }
          
          setLoad(false)
      };

      loadItems()
  }, [page])


  useEffect(() => {
      const table = document.getElementById("table");
      
      if (table) {
        table.addEventListener("scroll", handleScroll);
    
        return () => {
          table.removeEventListener("scroll", handleScroll);
        };
      }
  }, []);


  const handleScroll = () => {
      const table = document.getElementById("table");

      if (table) {  
        if (table.scrollTop + table.clientHeight >= table.scrollHeight) {
          setPage(prevPage => prevPage + 1);
        }
      }
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
            <InvoicingCustomer
              invoices={invoices}
              load={load}
            />
          </div>
          
      </Style.Container>
    </Style.CustComponent>
  );
};

export default InvoicesCustomer;
