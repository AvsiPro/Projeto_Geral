import React, {useState, useEffect} from "react";
import api from "../services/api";

import * as Style from './styles'; 

import Navbar from "../components/navbar";
import Header from "../components/header";
import Table from "../components/table";

import { useMediaQuery } from 'react-responsive';
import { fetchData } from "../services/apiProducts";

interface ApiResponse {
  status: {
    code: string;
    message: string;
  };
  hasNext: boolean;
  result: any;
}

const Products: React.FC = () => {

  const [data, setData] = useState<any>([])
  const [load, setLoad] = useState<boolean>(false)
  const [page, setPage] = useState<number>(1);

  const userData = localStorage.getItem('userdata');
  const user = userData ? JSON.parse(userData) : null;

  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

  useEffect(() => {
    if(page === 1){
      setLoad(true)
    }
      const apiData = async () => {
      
        const returnResult: any = await fetchData(1);

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

  },[page])


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

  const handleSearch = async(searchText: string) => {
    let returnResult: any = []
    let tablePrice: any
    let idTable: string = '001'
    
    const tablePriceData = localStorage.getItem('tableprice');

    if(!!tablePriceData){
        tablePrice = JSON.parse(tablePriceData);
        if(!!tablePrice.id){
          idTable = tablePrice.id
        }
    }

    const response = await api.get(`/WSAPP03?pagesize=9999&page=1&searchKey=${searchText}&codTab=${idTable}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      returnResult = json.result.reduce((acc: any, current: any) => {
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);

      const sortedResult = [...returnResult].sort((a, b) => {
        return a.code.localeCompare(b.code);
      });

      setData(sortedResult);
      
    }else{
      setData([]);
    }
    setPage(1)
  }

  const ToolsTable = () => {
    return(
      <>
      </>
    )
  }

  const fields = (user.type === 'V' || user.type === 'A') ? [
    {field: 'code', headerText: 'Codigo', textAlign: 'Center'  },
    {field: 'description', headerText: 'Descrição', textAlign: 'Left' , width: '300px'},
    {field: 'type', headerText: 'Tipo', textAlign: 'Center' },
    {field: 'line', headerText: 'Linha', textAlign: 'Left' },
    {field: 'brand', headerText: 'Marca', textAlign: 'Left' },
    {field: 'gender', headerText: 'Gênero', textAlign: 'Center' },
    {field: 'price', headerText: 'Preço 1', textAlign: 'Center', width: '80px' },
    {field: 'price2', headerText: 'Preço 2', textAlign: 'Center', width: '80px' },
    {field: 'price3', headerText: 'Preço 3', textAlign: 'Center', width: '80px' },
    {field: 'balance', headerText: 'Saldo', textAlign: 'Center' },
    {field: 'photo', headerText: 'Foto', textAlign: 'Center' }
  ] :
  [
    {field: 'code', headerText: 'Codigo', textAlign: 'Center'  },
    {field: 'description', headerText: 'Descrição', textAlign: 'Left' , width: '300px'},
    {field: 'type', headerText: 'Tipo', textAlign: 'Center' },
    {field: 'line', headerText: 'Linha', textAlign: 'Left' },
    {field: 'brand', headerText: 'Marca', textAlign: 'Left' },
    {field: 'gender', headerText: 'Gênero', textAlign: 'Center' },
    {field: 'price', headerText: 'Preço', textAlign: 'Center', width: '80px' },
    {field: 'photo', headerText: 'Foto', textAlign: 'Center' }
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
              title={'Produtos'}
              handleSearch={handleSearch}
              handleMark={()=>{}}
              load={load}
              ToolsTable={ToolsTable}
            />
          </div>
          
      </Style.Container>
    </Style.CustComponent>
  );
};

export default Products;
