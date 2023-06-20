import React, { useContext, useState, useEffect } from "react";

import * as Style from './styles';

import { Button } from 'react-bootstrap';

import { fetchData, fetchSearch } from "../services/apiOrders";

import Navbar from "../components/navbar";
import Header from "../components/header";
import Table from "../components/table";
import { AlertComponent } from "../components/alerts";
import ModalComponent from "../components/modal";
import OrdersBodyModal from "../components/orderbodyModal";
import { CartContext } from "../contexts/CartContext";

import { useMediaQuery } from 'react-responsive';

import DeleteOrderPopover from "../popovers/deleteOrderPopover";
import { UserContext } from "../contexts/userContext";

const Orders: React.FC = () => {

  const { setCustomerContext, setPaymentContext, setCartContext, customerContext, paymentContext, cartContext } = useContext(CartContext);
  const { userContext } = useContext(UserContext)

  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

  const [data, setData] = useState<any>([])
  const [load, setLoad] = useState<boolean>(false)
  const [page, setPage] = useState<number>(1)

  const [selected, setSelected] = useState(null)
  const [showAlert, setShowAlert] = useState <boolean>(false)
  const [showModal, setShowModal] = useState <boolean>(false)
  const [fieldsOrders, setFieldsOrders] = useState <any>([
    { 
      id: 'code',
      label: 'Cliente',
      width: 150,
      search: true,
      enabled: true,
      type: 'customers',
      value: ''
    },
    { 
      id: 'branch',
      label: 'Loja',
      width: 80,
      search: false,
      enabled: false,
      type: '',
      value: ''
    },
    { 
      id: 'name',
      label: 'Nome Cliente',
      width: 300,
      search: false,
      enabled: false,
      type: '',
      value: ''
    },
    { 
      id: 'payment',
      label: 'Cond. Pgto',
      width: 80,
      search: true,
      enabled: true,
      type: 'payment',
      value: ''
    },
    { 
      id: 'paymentname',
      label: 'Descrição',
      width: 300,
      search: false,
      enabled: false,
      type: '',
      value: ''
    },
    { 
      id: 'products',
      label: 'Descrição',
      width: 300,
      search: false,
      enabled: false,
      type: 'products',
      value: ''
    }
  ])

  useEffect(() => {
    if(page === 1){
      setLoad(true)
    }
      
    const apiData = async() => {
      const returnResult: any = await fetchData(page, userContext.token)
      
      if(returnResult.length > 0){
        setData((prevData: any) => [...prevData, ...returnResult]);
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
    let returnResult: any = await fetchSearch(searchText, userContext.token)

    if(returnResult.length > 0) {
      setData(returnResult);
    }

    setPage(1)
  }

  const handleMark = (row: any) => {
    const updatedItems = data.map((item: any) => {
        if (item.id === row.id) {
          return { ...item, mark: true };
        }
        return { ...item, mark: false };
    });
    
    row.mark = true
    setSelected(row)
    setData(updatedItems)
  }

  const fields = [
    {field: 'mark', headerText: '', textAlign: 'Center'  },
    {field: 'document', headerText: 'Pedido', textAlign: 'Center'  },
    {field: 'status', headerText: 'Status', textAlign: 'Center'},
    {field: 'customer_name', headerText: 'Cliente', textAlign: 'Left' },
    {field: 'customer_cnpj', headerText: 'CPF/CNPJ', textAlign: 'Center' },
    {field: 'issue_date', headerText: 'Emissão', textAlign: 'Center' },
    {field: 'invoice', headerText: 'Nota', textAlign: 'Center' },
    {field: 'invoice_series', headerText: 'Série', textAlign: 'Center' }
  ]

  const ToolsTable = () => {
    if(cartContext.length > 0) {
      return(
        <div style={{marginTop: isMobile ? 15 : 0}}>
          <Button onClick={() => setShowModal(true)} variant="warning">Continuar Pedido</Button>{' '}
        </div>
      )
    }else{
      return(
        <div style={{marginTop: isMobile ? 15 : 0}}>
          <Button onClick={() => setShowModal(true)} variant="outline-primary">Novo Pedido</Button>{' '}
          <Button onClick={() => {}} variant="outline-primary">Alterar</Button>{' '}
          <Button onClick={() => {}} variant="outline-primary">Visualizar</Button>{' '}
          <Button onClick={() => {}} variant="outline-danger">Excluir</Button>
        </div>
      )
    }
  }

  const handleShowAlert = () => {
    setShowAlert(!showAlert)
  }

  useEffect(() => {
    if(cartContext.length > 0) {
      setShowModal(true)
    }
  },[cartContext])

  useEffect(() =>{
    const auxField = [...fieldsOrders]

    if(!!customerContext){
      auxField.map((_, index) => {
        if(auxField[index].id === 'code'){
          auxField[index].value = customerContext.code

        }else if(auxField[index].id === 'branch'){
          auxField[index].value = customerContext.branch

        }else if(auxField[index].id === 'name'){
          auxField[index].value = customerContext.name
        }
      });

      if(!!paymentContext){
        auxField.map((_, index) => {
          if(auxField[index].id === 'payment'){
            auxField[index].value = paymentContext.code
  
          }else if(auxField[index].id === 'paymentname'){
            auxField[index].value = paymentContext.description
          }
        });
      }
    }

  },[customerContext])


  const handleConfirmSelect = (selected: any) => {
    if(selected.id === 'code'){
      setCustomerContext(selected.selected)
      localStorage.setItem('customer', JSON.stringify(selected.selected));

      const auxField = [...fieldsOrders]

      auxField.map((_, index) => {
        if(auxField[index].id === 'code'){
          auxField[index].value = selected.selected.code

        }else if(auxField[index].id === 'branch'){
          auxField[index].value = selected.selected.branch

        }else if(auxField[index].id === 'name'){
          auxField[index].value = selected.selected.name
        }
      });

      setFieldsOrders(auxField)

    
    }else if(selected.id === 'payment'){
      setPaymentContext(selected.selected)
      localStorage.setItem('payment', JSON.stringify(selected.selected));

      const auxField = [...fieldsOrders]

      auxField.map((_, index) => {
        if(auxField[index].id === 'payment'){
          auxField[index].value = selected.selected.code

        }else if(auxField[index].id === 'paymentname'){
          auxField[index].value = selected.selected.description
        }
      });
    }
  }

  const handleClearCart = (event: string) => {
    if(event === 'yes'){
      setShowModal(false)

      setCustomerContext(null);
      setPaymentContext(null);
      setCartContext([])

      localStorage.setItem('customer', JSON.stringify(null));
      localStorage.setItem('payment', JSON.stringify(null));
      localStorage.setItem('cartdata', JSON.stringify([]));
    }
  }


  const fGeraPedido = () => {
    console.log(cartContext)
    console.log(customerContext)
    console.log(paymentContext)
    setShowAlert(!showAlert)
  }


  const ToolsModal = (
    <>
      <Button variant="" onClick={() => setShowModal(false)}>cancelar</Button>{' '}
      <DeleteOrderPopover handleClick={handleClearCart}/>{' '}
      <Button variant="outline-primary" onClick={fGeraPedido}>Confirmar</Button>{' '}
    </>
  )

  const BodyModal = (
    <OrdersBodyModal
      fieldsOrders={fieldsOrders}
      handleConfirmSelect={handleConfirmSelect}
    />
  )

  return (
    <>
    <Style.OrderComponent>
      
      {/* Menu lateral */
        !isMobile &&
        <Navbar/>
      }
      
      <Style.Container isMobile={isMobile}>
          
        {/* Header */}
        <Header/>

        <AlertComponent
          header='Sucesso'
          body='Pedido criado com sucesso!'
          textButton='Fechar'
          type='success'
          showAlert={showAlert}
          handleShowAlert={handleShowAlert}
        />
        
        {/* Tablea */}
        <div style={{margin: !isMobile ? 50 : 0}}>
          <Table
            data={data}
            fields={fields}
            title={'Pedidos'}
            handleSearch={handleSearch}
            handleMark={handleMark}
            load={load}
            ToolsTable={ToolsTable}
          />
        </div>
          
      </Style.Container>
    </Style.OrderComponent>

    <ModalComponent
        show={showModal}
        onHide={() => setShowModal(false)}
        title='Novo pedido'
        Body={BodyModal}
        Tools={ToolsModal}
      />
    </>
  );
};

export default Orders;
