import React, {useState, useEffect} from "react";

import * as Style from './styles'; 

import Navbar from "../components/navbar";
import Header from "../components/header";
import Table from "../components/table";

import { useMediaQuery } from 'react-responsive';
import { fetchData, fetchSearch } from "../services/apiCustomers";

const Customers: React.FC = () => {

  const [data, setData] = useState<any>([])
  const [load, setLoad] = useState<boolean>(false)
  const [page, setPage] = useState<number>(1)
  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

  const userData = localStorage.getItem('userdata');
  const user = userData ? JSON.parse(userData) : null;

  useEffect(() => {
    if(page === 1){
      setLoad(true)
    }
      
    const apiData = async() => {

      const returnResult: any = await fetchData(page, user.token)
      
      if (returnResult.length > 0) {
        const auxData = [...data, ...returnResult]

        const newData = auxData.reduce((acc: any, current: any) => {
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
        }, []);

        setData(newData); 
      }
      
      setLoad(false)
    };

    apiData()

  },[page]);


  useEffect(() => {
    const table = document.getElementById("my-table");

    if (table) {
      table.addEventListener("scroll", handleScroll);
  
      return () => {
        table.removeEventListener("scroll", handleScroll);
      };
    }
  }, []);


  const handleScroll = () => {
    const table = document.getElementById("my-table");
    if (table) {  
      if (table.scrollTop + table.clientHeight >= table.scrollHeight) {
        setPage(prevPage => prevPage + 1);
      }
    }
  };

  const handleSearch = async (searchText: string) => {
      let returnResult: any = await fetchSearch(searchText, user.token)

      setData(returnResult);
      setPage(1)
  }

  const ToolsTable = () => {
    return(
      <>
      </>
    )
  }

  const fields = [
    {field: 'action', headerText: '...', textAlign: 'Center'  },
    {field: 'code', headerText: 'Codigo', textAlign: 'Center' },
    {field: 'branch', headerText: 'Loja', textAlign: 'Center' },
    {field: 'name', headerText: 'Razão Social', textAlign: 'Left', width: '300px'},
    {field: 'short_name', headerText: 'Nome Fantasia', textAlign: 'Left', width: '300px' },
    {field: 'cnpj', headerText: 'CPF/CNPJ', textAlign: 'Center', width: '200px' },
    {field: 'state_regist', headerText: 'Inscrição Estadual', textAlign: 'Center', width: '200px' },
    {field: 'address', headerText: 'Endereço', textAlign: 'Left', width: '300px' },
    {field: 'complement', headerText: 'Complemento', textAlign: 'Left', width: '300px' },
    {field: 'district', headerText: 'Bairro', textAlign: 'Left', width: '200px' },
    {field: 'city', headerText: 'Cidade', textAlign: 'Left', width: '200px' },
    {field: 'cep', headerText: 'CEP', textAlign: 'Center', width: '100px' },
    {field: 'uf', headerText: 'UF', textAlign: 'Center' },
    {field: 'contact', headerText: 'Contato', textAlign: 'Left' },
    {field: 'email', headerText: 'E-Mail', textAlign: 'Left' },
    {field: 'phone', headerText: 'Telefone', textAlign: 'Center' , width: '200px'},
  ]

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
            <Table
              data={data}
              fields={fields}
              title={'Clientes'}
              load={load}
              handleSearch={handleSearch}
              handleMark={()=>{}}
              ToolsTable={ToolsTable}
            />
          </div>
          
      </Style.Container>
    </Style.CustComponent>
  );
};

export default Customers;
