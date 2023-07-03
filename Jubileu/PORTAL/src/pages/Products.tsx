import React, {useState, useEffect} from "react";
import api from "../services/api";

import * as Style from './styles'; 

import Navbar from "../components/navbar";
import Header from "../components/header";
import Table from "../components/table";

import { useMediaQuery } from 'react-responsive';

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

  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

  useEffect(() => {
    if(page === 1){
      setLoad(true)
    }
      const apiData = async () => {
      
      let returnResult: any = []
  
      const response = await api.get(`/WSAPP03?pagesize=100&page=${page}`);
      const json: ApiResponse = response.data;
  
      if(json.status.code === '#200'){    
  
        returnResult = json.result.reduce((acc: any, current: any) => {
            const x = acc.find((item: { id: any; }) => item.id === current.id);
            return !x ? acc.concat([current]) : acc;
        }, []);

        const sortedResult = [...returnResult].sort((a, b) => {
          return a.code.localeCompare(b.code);
        });

        setData((prevData: any) => [...prevData, ...sortedResult]);
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

    const response = await api.get(`/WSAPP03?pagesize=100&page=1&searchKey=${searchText}`);
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

  const fields = [
    {field: 'code', headerText: 'Codigo', textAlign: 'Center'  },
    {field: 'description', headerText: 'Descrição', textAlign: 'Left' , width: '300px'},
    {field: 'type', headerText: 'Tipo', textAlign: 'Center' },
    {field: 'line', headerText: 'Linha', textAlign: 'Left' },
    {field: 'brand', headerText: 'Marca', textAlign: 'Left' },
    {field: 'gender', headerText: 'Gênero', textAlign: 'Center' },
    {field: 'price', headerText: 'Preço', textAlign: 'Center' },
    {field: 'balance', headerText: 'Saldo', textAlign: 'Center' },
    {field: 'ncm', headerText: 'NCM', textAlign: 'Center' },
    {field: 'ean', headerText: 'EAN', textAlign: 'Center' },
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
