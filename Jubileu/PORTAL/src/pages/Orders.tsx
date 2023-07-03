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
import api from "../services/api";
import { ClipLoader } from "react-spinners";

interface ApiResponse {
  status: {
    code: string;
    message: string;
  };
  hasNext: boolean;
  result: any;
}

const Orders: React.FC = () => {

  const { setCustomerContext, setPaymentContext, setCartContext, customerContext, paymentContext, cartContext } = useContext(CartContext);
  const { userContext } = useContext(UserContext)

  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

  const [data, setData] = useState<any>([])
  const [load, setLoad] = useState<boolean>(false)
  const [loadOrder, setLoadOrder] = useState<boolean>(false)
  const [page, setPage] = useState<number>(1)

  const [headerAlert, setHeaderAlert] = useState <string>('')
  const [bodyAlert, setBodyAlert] = useState <string>('')
  const [typeAlert, setTypeAlert] = useState <string>('')

  const [selected, setSelected] = useState(null)
  const [showAlert, setShowAlert] = useState <boolean>(false)
  const [showModal, setShowModal] = useState <boolean>(false)
  const [financial, setFinancial] = useState <any>(null)

  const [step2, setStep2] = useState <boolean>(false)
  const [inputObsValue, setInputObsValue] = useState('');
  const [inputEndValue, setInputEndValue] = useState('');
  
  const [discountPercent, setDiscountPercent] = useState<number>(0);

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
      const returnResult: any = await fetchData(page, userContext.token, userContext.type)
      
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
    let returnResult: any = await fetchSearch(searchText, userContext.token, userContext.type);

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
    //{field: 'mark', headerText: '', textAlign: 'Center'  },
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
          <Button onClick={handleNovoPedido} variant="outline-primary">Novo Pedido</Button>{' '}
        </div>
      )
    }
  }


  const apiCustomer = async() => {
    let auxResult: any = []
    let returnResult: any = []

    const response = await api.get(`/WSAPP02?pagesize=1&page=1&byId=true&SearchKey=${userContext.code}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      auxResult = json.result.reduce((acc: any, current: any) => {
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);

      auxResult.map((_: any, index: number) =>{
        auxResult[index].mark = false
      })

      returnResult = [...auxResult][0]

    }

    return returnResult
}


  const handleNovoPedido = async() => {

    if (userContext.type === 'C') {
      const custAux = await apiCustomer();

      if (!!custAux) {
        const payment = {
            code: custAux.payment,
            form: custAux.payment_description,
            id: custAux.payment,
            description: custAux.payment_description,
            mark: true
        }

        setPaymentContext(payment)
        setCustomerContext(custAux);

        const auxField = [...fieldsOrders]

        auxField.map((_, index) => {
          auxField[index].enabled = false
          auxField[index].search = false
        })
      }

      if(custAux.financial.length > 0) {
        handleSetFinancial(custAux)
      }

    }else{
      setShowModal(true)
    }
  
  }

  const handleCloseAlert = () => {
    
    if(step2 && typeAlert === 'success') {
      window.location.reload()
    }

    setBodyAlert('')
    setHeaderAlert('')
    setTypeAlert('')
    setShowAlert(false)
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

      const auxField = [...fieldsOrders]

      auxField.map((_, index) => {
        auxField[index].value = ''
      });

      setFieldsOrders(auxField)

      localStorage.setItem('customer', JSON.stringify(null));
      localStorage.setItem('payment', JSON.stringify(null));
      localStorage.setItem('cartdata', JSON.stringify([]));
    }
  }


  const handleStep2 = () => {
    setHeaderAlert('')

    if(!customerContext) {
      setTypeAlert('warning')
      setBodyAlert('Necessário selecionar um cliente')
      setShowAlert(true)
      return
    }

    if(!paymentContext) {
      setTypeAlert('warning')
      setBodyAlert('Necessário selecionar uma condição de pagamento')
      setShowAlert(true)
      return
    }

    if(cartContext.length <= 0) {
      setTypeAlert('warning')
      setBodyAlert('Necessário selecionar ao menos um produto')
      setShowAlert(true)
      return
    }

    setStep2(true)

    /*
    setBodyAlert('Pedido criado com sucesso!')
    setHeaderAlert('Sucesso')
    setTypeAlert('success')
    setShowAlert(!showAlert)
    */
  }


  const fGeraPedido = async() => {
    setLoadOrder(true)
    const items = cartContext.map((item: any) => {
      return {
          produto: item.code,
          quantidade: item.selected_quantity,
          valor: item.price
      };
    });

    const sendJson = {
        endereco_entrega: inputEndValue,
        cep_entrega: customerContext.another_cep,
        bairro_entrega: customerContext.another_district,
        condpagto: paymentContext.code,
        desconto: discountPercent,
        numorc: '',
        orcamento: 'N',
        observation: inputObsValue,
        token: userContext.token,
        cliente: {
            filial: customerContext.branch,
            endereco: customerContext.address,
            bairro: customerContext.district,
            cep: customerContext.cep,
            uf: customerContext.uf,
            cidade: customerContext.city,
            tel: customerContext.phone,
            cnpj: customerContext.cnpj,
            codigo: customerContext.code,
            contato: customerContext.contact,
            email: customerContext.email,
            nome_fantasia: customerContext.short_name,
            razao_social: customerContext.name
        },
        items: items
    }

    try{
      const response = await api.post("/WSAPP12", sendJson);
      const receive = response.data;

      if (receive.status.code === '#200') {
        handleClearCart('yes')
        setBodyAlert('Pedido gerado com sucesso '+receive.status.message)
        setHeaderAlert('Sucesso')
        setTypeAlert('success')
        setShowAlert(!showAlert)

      } else {
        setBodyAlert(receive.status.message)
        setHeaderAlert('Erro')
        setTypeAlert('danger')
        setShowAlert(!showAlert)
      }
      
    } catch(error){
        setBodyAlert('Erro na comunicação com o servidor, contate um administrador')
        setHeaderAlert('Erro')
        setTypeAlert('danger')
        setShowAlert(!showAlert)
    }
    
    setLoadOrder(false)
  }

  const handleVoltarFinancial = () => {
    if(userContext.type === 'C') {
      setShowModal(false)
    }
    setFinancial(null)
  }

  const ToolsModal = (
    <>
      { !!financial ?
        <Button variant="outline-danger" onClick={handleVoltarFinancial}>Fechar</Button>
      
      : !step2 ?
        <>
          <Button variant="" onClick={() => setShowModal(false)}>Cancelar</Button>{' '}
          <DeleteOrderPopover handleClick={handleClearCart}/>{' '}
          <Button variant="outline-primary" onClick={handleStep2}>Confirmar</Button>{' '}
        </>
      :
        <>
          <Button variant="" onClick={() => setStep2(false)}>Voltar</Button>{' '}
          <Button variant="outline-primary" onClick={fGeraPedido}>
             { loadOrder ?
                  <ClipLoader
                    color={'#0d6efd'}
                    loading={loadOrder}
                    size={22}
                  />
                : 'Gerar Pedido'
              }
          
          </Button>{' '}
        </>
      }
    </>
  )

  const handleSetFinancial = (item: any) => {
    setBodyAlert('Cliente possui títulos em aberto')
    setHeaderAlert('Erro')
    setTypeAlert('danger')
    setShowAlert(!showAlert)
    setFinancial(item)
    setShowModal(true)
  }



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
          header={headerAlert}
          body={bodyAlert}
          textButton='Fechar'
          type={typeAlert}
          showAlert={showAlert}
          handleShowAlert={handleCloseAlert}
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
      title={!!financial ? 'Títulos em aberto' : 'Novo pedido'}
      Body={
        <OrdersBodyModal
          fieldsOrders={fieldsOrders}
          handleConfirmSelect={handleConfirmSelect}
          financial={financial}
          setFinancial={(item: any) => handleSetFinancial(item)}
          step2={step2}
          inputObsValue={inputObsValue}
          setInputObsValue={(change) => setInputObsValue(change)}
          inputEndValue={inputEndValue}
          setInputEndValue={(change) => setInputEndValue(change)}
          discountPercent={discountPercent}
          setDiscountPercent={(change) => setDiscountPercent(change)}
        />
      }
      Tools={ToolsModal}
    />
    </>
  );
};

export default Orders;
