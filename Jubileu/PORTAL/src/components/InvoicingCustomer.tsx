import React, { useContext } from "react";

import SyncLoader from "react-spinners/SyncLoader";
import LottieAnimation from "./lottieAnimation";

import animationData from '../assets/emptylist.json'

import * as Style from "./styles"
import { ThemeContext } from "../contexts/ThemeContext";

import { darkTheme, lightTheme } from "../themes";
import { useMediaQuery } from 'react-responsive';

import { SToD } from "../utils/dateFormat";
import { CurrencyFormat } from "../utils/currencyFormat";

import { Accordion, Table } from 'react-bootstrap';
import { WindowDimensionsContext } from "../contexts/WindowDimensionsContext";
import { apiLink } from "../services/api";

interface Props{
    invoices: any
    load: boolean;
}

interface Item {
    id: string;
    product: string;
    unitary_value: number;
    billed_amount: number;
    quantity: number;
    description: string;
  }

const InvoicingCustomer: React.FC <Props> = ({ invoices, load})  => {

    const { theme } = useContext(ThemeContext);
    const { windowDimensions } = useContext(WindowDimensionsContext);
    const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

    const themeAux = theme === 'dark' ? darkTheme : lightTheme;

    const calculateTotal = (items: Item[]): { unitary_value_total: number, billed_amount_total: number, quantity_total: number } => {
        let unitaryValueTotal = 0;
        let billedAmountTotal = 0;
        let quantityTotal = 0;
      
        for (const item of items) {
          unitaryValueTotal += item.unitary_value;
          billedAmountTotal += item.billed_amount;
          quantityTotal += item.quantity;
        }
      
        return {
          unitary_value_total: unitaryValueTotal,
          billed_amount_total: billedAmountTotal,
          quantity_total: quantityTotal
        };
    };
    
    const handleOpenLink = (type: string, item: any) => {
        window.open(`${apiLink}/WSAPP14?cTipo=${type}&cDoc=${item.invoice}&cSerie=${item.invoice_series}&cFilNF=${item.branch_invoice}`, '_blank')
    }
    
    return(
        <Style.CustomersComponent
            id='table'
            windowDimensions={windowDimensions}
            modal={false}
            isMobile={isMobile}
        >
            <Style.TextH3 style={{color:themeAux.primary}}>{'Faturamento'}</Style.TextH3>
            
            <SyncLoader
                color={theme === 'dark' ? darkTheme.primary : lightTheme.primary}
                loading={load}
                size={12}
                style={{display:'flex',justifyContent:'center', marginTop:30}}
            />

            { invoices.map((item: any, index: number) =>
                <Style.InvCustTable key={index} backGround={index % 2 == 0}>

                    <Style.InvCustHorizItens>

                        <Style.InvCustLabel color="#000" bold size={18}>
                            {`Documento: ${item.invoice} / Série: ${item.invoice_series}` }
                        </Style.InvCustLabel>


                        <Style.InvCustLabel color="#000" bold size={18}>
                            Emissão: {SToD(item.emission)}
                        </Style.InvCustLabel>

                    </Style.InvCustHorizItens>

                    <Accordion style={{marginTop:20}}>
                        <Accordion.Item eventKey={index.toString()}>
                            <Accordion.Header>Ver Itens da Nota</Accordion.Header>
                            <Accordion.Body>
                                <Table hover>
                                    <thead>
                                        <tr>
                                            <th>Produto</th>
                                            <th>Descrição</th>
                                            <th>Quantidade</th>
                                            <th>Valor Unitário</th>
                                            <th>Valor Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {item.items.map((subItem: any, subIndex: number) => 
                                            <tr key={subIndex}>
                                                <td>{subItem.product}</td>
                                                <td>{subItem.description}</td>
                                                <td>{subItem.quantity}</td>
                                                <td>{CurrencyFormat(subItem.unitary_value)}</td>
                                                <td>{CurrencyFormat(subItem.billed_amount)}</td>
                                            </tr>
                                        )}

                                        <tr key={9999}>
                                            <td>Total</td>
                                            <td></td>
                                            <td>{calculateTotal(item.items).quantity_total}</td>
                                            <td>{CurrencyFormat(calculateTotal(item.items).unitary_value_total)}</td>
                                            <td>{CurrencyFormat(calculateTotal(item.items).billed_amount_total)}</td>
                                        </tr>
                                    </tbody>
                                </Table>
                            </Accordion.Body>
                        </Accordion.Item>
                    </Accordion>

                    <Style.InvCustTools>
                        <Style.InvCustButTool onClick={() => handleOpenLink('Danfe', item)}>Danfe</Style.InvCustButTool>
                        <Style.InvCustButTool onClick={() => handleOpenLink('Xml', item)}>Xml</Style.InvCustButTool>
                    </Style.InvCustTools>

                    
                </Style.InvCustTable>
            )}

            { invoices.length <= 0 && !load &&
                <Style.InvCustEmptyList>
                    <LottieAnimation
                        animationData={animationData}
                        data={invoices}
                        loop={true}
                        autoplay={true}
                        width={300}
                        height={300}
                    />
                    <Style.InvCustLabel color="#000" bold size={26}>Nenhum documento encontrado</Style.InvCustLabel>

                </Style.InvCustEmptyList>
            }
        </Style.CustomersComponent>
    )
}

export default InvoicingCustomer;