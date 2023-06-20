import React, { useContext, useState, useEffect } from "react";

import * as Style from "./styles";

import { TiMinus, TiPlus } from "react-icons/ti";
import { BsTrash } from "react-icons/bs";

import Table from "../components/table";

import { Button } from "react-bootstrap";
import { CurrencyFormat } from "../utils/currencyFormat";
import { fetchData, fetchSearch } from "../services/apiProducts";

import SearchPopover from "../popovers/searchPopover";
import { WindowDimensionsContext } from "../contexts/WindowDimensionsContext";
import { CartContext } from "../contexts/CartContext";
import { useMediaQuery } from "react-responsive";

interface Props {
  fieldsOrders: any;
  handleConfirmSelect: (selected: any) => void;
}

const OrdersBodyModal: React.FC<Props> = ({
  fieldsOrders,
  handleConfirmSelect,
}) => {
  const { windowDimensions } = useContext(WindowDimensionsContext);
  const { setCartContext, cartContext } = useContext(CartContext);
  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

  const [load, setLoad] = useState<boolean>(false);
  const [data, setData] = useState<any>([]);
  const [selected, setSelected] = useState<any>([]);
  const [itensCart, setItensCart] = useState<any>([]);
  const [showItens, setShowItens] = useState<boolean>(false);
  const [showHeader, setShowHeader] = useState<boolean>(false);


  useEffect(() => {
    if (!load) {
      setLoad(true);
    }

    const apiData = async () => {
      let returnResult: any = [];

      returnResult = await fetchData(1);

      if (returnResult.length > 0) {
        setData((prevData: any) => [...prevData, ...returnResult]);
      }

      setLoad(false);
    };

    if (cartContext.length > 0) {
      setItensCart(cartContext);
      setShowItens(true)
    }

    apiData();
  }, [cartContext]);


  const handleSearch = async (searchText: string) => {
    let returnResult: any = [];

    returnResult = await fetchSearch(searchText);

    setData(returnResult);
  };

  const handleMark = (row: any) => {
    const updatedItems = data.map((item: any) => {
      if (item.id === row.id) {
        return { ...item, mark: !item.mark };
      }
      return item;
    });

    setData(updatedItems);

    let itensSelected: any = [];

    updatedItems.map((item: any) => {
      if (item.mark) {
        itensSelected.push({ ...item });
      }
    });

    setSelected(itensSelected);
  };

  const handleConfirm = () => {
    const newCart = [...cartContext, ...selected]

    const auxUnique = newCart.reduce((acc: any, current: any) => {
      const x = acc.find((item: { id: any; }) => item.id === current.id);
      return !x ? acc.concat([current]) : acc;
    }, []);

    auxUnique.map((_: any, index: number) => {
      auxUnique[index].selected_quantity = 1
    })

    setItensCart((prevItems: any) => [...prevItems, ...auxUnique]);
    setCartContext(auxUnique);
    localStorage.setItem('cartdata', JSON.stringify(auxUnique));
    setSelected([]);
    setData([]);
    setShowItens(true)

  };

  const ToolsTable = () => {
    let selecionado = selected.length > 0

    return (
      <div style={{marginTop: isMobile ? 15 : 0}}>
        <Button onClick={handleConfirm} variant={selecionado ? "outline-primary" : "outline-danger"}>
          {selecionado ? 'Adicionar' : 'Cancelar'}
        </Button>{" "}
      </div>
    );
  };

  const fields = [
    { field: "mark", headerText: "", textAlign: "Center" },
    { field: "code", headerText: "Codigo", textAlign: "Center" },
    { field: "description", headerText: "Descrição", textAlign: "Left" },
    { field: "price", headerText: "Preço", textAlign: "Center" },
    { field: "balance", headerText: "Saldo", textAlign: "Center" },
  ];


  /** botao de diminuir item do carrinho, se for zerado sai da lista **/
  const handleMinus = (index: number) => {

    const newData = [...cartContext]
    let itemAux: any = []

    if(newData[index].selected_quantity > 0){
      newData[index] = {
          ...newData[index],
          selected_quantity: newData[index].selected_quantity - 1
      };
    }

    if(!newData[index].selected_quantity){
      newData.splice(index, 1);
      itemAux.push(newData[index])
      setItensCart((prevItems: any) => [...prevItems, ...itemAux]);
    }

    if(newData.length <= 0){
      setShowItens(false)
    }

    setCartContext(newData);
    localStorage.setItem('cartdata', JSON.stringify(newData));
  }

  /** botao de aumentar item do carrinho **/
  const handleMore = (index: number) => {

    const newData = [...cartContext]
    let itemAux: any = []

    newData[index] = {
      ...newData[index],
      selected_quantity: newData[index].selected_quantity + 1
    };

    itemAux.push(newData[index])

    setCartContext(newData);
    localStorage.setItem('cartdata', JSON.stringify(newData));
    setItensCart((prevItems: any) => [...prevItems, ...itemAux]);
  }

  const handleQuantityChange =(itemId: number, newValue: string) => {    
    const updatedItems = itensCart.map((item: any) => {
      if (item.id === itemId) {
        const newQuantity = Number(newValue);
        
        const updatedItem = { ...item, selected_quantity: newQuantity > 0 ? newQuantity : ''};
        return updatedItem;
      }
      return item;
    });
  
    setItensCart(updatedItems);
    setCartContext(updatedItems);
    localStorage.setItem('cartdata', JSON.stringify(updatedItems));
  }

  const Header = () => {
    return(
      <Style.BodyOrderContainer isMobile={isMobile}>
        {fieldsOrders.map((field: any, index: number) => {
          if (field.type !== "products") {
            return (
              <Style.BodyOrderInputItem key={index} width={field.width}>
                <Style.TextLabel style={{ color: "#000" }}>
                  {field.label}
                </Style.TextLabel>
                <Style.BodyOrderInputWrapper>
                  <Style.BodyOrderInputField
                    id={field.id}
                    type="text"
                    onChange={() => {}}
                    disabled={!field.enabled}
                    value={field.value}
                    
                  />

                  {field.search && (
                    <SearchPopover
                      title={field.label}
                      field={field}
                      handleConfirmSelect={handleConfirmSelect}
                    />
                  )}
                </Style.BodyOrderInputWrapper>
              </Style.BodyOrderInputItem>
            );
          }
        })}
      </Style.BodyOrderContainer>
    )
  }

  return (
    <>
    
      { 
        isMobile &&(
          <div style={{marginBottom:10, paddingLeft:5, paddingRight:5}}>
            { showHeader
              ? <Button onClick={() => setShowHeader(false)} variant="outline-primary">Ocultar Cabeçalho</Button>
              : <Button onClick={() => setShowHeader(true)} variant="outline-primary">Exibir Cabeçalho</Button>
            }
          </div>
        )
      }

      {isMobile && showHeader || !isMobile ? <Header /> : <></>}

      <Style.BodyOrderItensModal
        windowDimensions={windowDimensions} 
        isMobile={isMobile}
      >
        {!showItens ? (
          <Table
            data={data}
            fields={fields}
            title={"Produtos"}
            load={load}
            handleSearch={handleSearch}
            handleMark={handleMark}
            ToolsTable={ToolsTable}
            modal={true}
          />
        ) : (

          <Style.BodyOrderContainerItens isMobile={isMobile}>
          {itensCart.map((item: any, index: number) => {
            if (!item){
              setShowItens(false)
            } else{
              return(
                <Style.BodyOrderProducts key={index}>
                  <Style.BodyOrderProductContainer>
                    <Style.BodyOrderProductCode>
                      {item.code}
                    </Style.BodyOrderProductCode>

                    <Style.BodyOrderProductDesc>
                      {item.description}
                    </Style.BodyOrderProductDesc>
                  </Style.BodyOrderProductContainer>

                  <Style.BodyOrderQtyTools>
                    <Style.BodyOrderQtyPriceTools>
                      <Style.BodyOrderProductPrice>
                        {CurrencyFormat(item.price * item.selected_quantity)}
                      </Style.BodyOrderProductPrice>
                      <Style.BodyOrderButonsQty>
                        <Style.BodyOrderButtonQty
                          onClick={() => handleMinus(index)}
                          delete={!item.selected_quantity || item.selected_quantity === 1}
                        >
                          { !item.selected_quantity || item.selected_quantity === 1 
                            ? <BsTrash color="white" style={{ width: 15, height: 15 }}/>
                            : <TiMinus color="white" style={{ width: 15, height: 15 }}/>
                          }
                          
                        </Style.BodyOrderButtonQty>

                        <Style.BodyOrderInputQty
                            id={item.id}
                            type="number"
  //                          onChange={handleInputChange}
                            value={item.selected_quantity}
                            onChange={(event) => handleQuantityChange(item.id, event.target.value)}
                            disabled={isMobile}
                            isMobile={isMobile}
                        />

                        <Style.BodyOrderButtonQty 
                          onClick={() => handleMore(index)}
                          delete={false}
                        >
                          <TiPlus
                            color="white"
                            style={{ width: 15, height: 15 }}
                          />
                        </Style.BodyOrderButtonQty>
                      </Style.BodyOrderButonsQty>
                    </Style.BodyOrderQtyPriceTools>
                  </Style.BodyOrderQtyTools>
                </Style.BodyOrderProducts>
              )
            }
          })}
          <Style.BodyOrderButtonAddMore onClick={() => {setShowItens(false)}}>
            Adicionar mais produtos
          </Style.BodyOrderButtonAddMore>
        </Style.BodyOrderContainerItens>
          
        )}
      </Style.BodyOrderItensModal>
    </>
  );
};

export default OrdersBodyModal;