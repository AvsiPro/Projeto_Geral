import React, { useContext, useState, useEffect } from "react";

import SyncLoader from "react-spinners/SyncLoader";
import LottieAnimation from "./lottieAnimation";

import animationData from '../assets/emptylist.json'

import * as Style from "./styles"
import { ThemeContext } from "../contexts/ThemeContext";

import { darkTheme, lightTheme } from "../themes";

import { fetchData } from "../services/apiFinancial";

import { apiLink } from "../services/api";

import { SToD } from "../utils/dateFormat";
import { CurrencyFormat } from "../utils/currencyFormat";
import { WindowDimensionsContext } from "../contexts/WindowDimensionsContext";
import { useMediaQuery } from "react-responsive";
import { Badge, Stack } from "react-bootstrap";
import FilterPopover from "../popovers/filterPopover";

interface Props{
    financialCustomer: any;
    type?: string;
}

const FinancialBodyModal: React.FC <Props> = ({financialCustomer , type = ''})  => {

    const { theme } = useContext(ThemeContext);
    const { windowDimensions } = useContext(WindowDimensionsContext);
    const themeAux = theme === 'dark' ? darkTheme : lightTheme;
    const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

    const [financial, setFinancial] = useState<any>([])
    const [load, setLoad] = useState<boolean>(false)

    const [dateEmisStart, setDateEmisStart] = useState("");
    const [dateEmisEnd, setDateEmisEnd] = useState("");
    const [dateVencStart, setDateVencStart] = useState("");
    const [dateVencEnd, setDateVencEnd] = useState("");
  
    const [btnPay, setBtnPay] = useState(false);
    const [btnComing, setBtnComing] = useState(false);
    const [btnRed, setBtnRed] = useState(false);
  
    const handleClickPay = (event: any) => {
      setBtnPay(event);
    };
  
    const handleClickComing = (event: any) => {
      setBtnComing(event);
    };
  
    const handleClickRed = (event: any) => {
      setBtnRed(event);
    };
  
    const handleClickEmis = () => {
      setDateEmisStart("");
      setDateEmisEnd("");
    };
  
    const handleClickVenc = () => {
      setDateVencStart("");
      setDateVencEnd("");
    };



    useEffect(() => {
        loadItems()
    }, [dateEmisStart, dateEmisEnd, dateVencStart, dateVencEnd, btnPay, btnComing, btnRed])


    const loadItems = async () => {
        if(!financialCustomer) return;

        setLoad(true)
        
        const userData = localStorage.getItem('userdata');
        const user = userData ? JSON.parse(userData) : null;

        let seller = ''

        if(!!type){
            seller = user.code
        }

        const filterAux = {
            emissDe: dateEmisStart.replace('-','').replace('-',''),
            emissAt: dateEmisEnd.replace('-','').replace('-',''),
            venctDe: dateVencStart.replace('-','').replace('-',''),
            venctAt: dateVencEnd.replace('-','').replace('-',''),
            pago: btnPay,
            aberto: btnComing,
            atrasado: btnRed
        }
        
        const returnResult: any = await fetchData(
            financialCustomer.cnpj,
            user.token.trim(),
            type,
            seller,
            filterAux
        )

        setFinancial(returnResult);
        setLoad(false)
    };

    const setColorStatus = (status: string) => {
        if(status === 'Pago'){
            return 'green'

        }else if (status === 'Em Aberto'){
            return'orange'
        
        }else if (status === 'Atrasado'){
            return 'tomato'
        
        }else{
            return'grey'
        }
    }

    const handleOpenLink = (type: string, item: any) => {
        window.open(`${apiLink}/WSAPP14?cTipo=${type}&cDoc=${item.document}&cSerie=${item.prefix}&cFilNF=${item.branch_invoice}&cParce=${item.installments}`, '_blank')
    }

    return(
        <Style.financialBodyComponent
            windowDimensions={windowDimensions}
            modal={true}
            isMobile={isMobile}
        >
            { !!financialCustomer &&
                <>
                <Style.TextH4 style={{color:'#000'}}>{financialCustomer.code}</Style.TextH4>
                <Style.TextH3 style={{color:themeAux.primary}}>{financialCustomer.name}</Style.TextH3>
                </>
            }

            <div
                style={{
                    display: "flex",
                    justifyContent: "flex-end",
                    marginBottom: "10px",
                }}
            >
                <FilterPopover
                    setDateEmisStart={setDateEmisStart}
                    setDateEmisEnd={setDateEmisEnd}
                    setDateVencStart={setDateVencStart}
                    setDateVencEnd={setDateVencEnd}
                    handleClickPay={(event: any) => handleClickPay(event)}
                    handleClickComing={(event: any) => handleClickComing(event)}
                    handleClickRed={(event: any) => handleClickRed(event)}
                />
            </div>
            <div
                style={{
                marginBottom: "10px",
                boxSizing: "border-box",
                height: "20px",
                }}
            >
                <Stack direction="horizontal" gap={2}>
                    <Badge
                        onClick={() => handleClickPay(false)}
                        style={{ cursor: "pointer" }}
                        bg="success"
                    >
                        {btnPay ? "Pago" : ""}
                    </Badge>
                    <Badge
                        onClick={() => handleClickRed(false)}
                        style={{ cursor: "pointer" }}
                        bg="danger"
                    >
                        {btnRed ? "Atrasado" : ""}
                    </Badge>
                    <Badge
                        onClick={() => handleClickComing(false)}
                        style={{ cursor: "pointer" }}
                        bg="warning"
                        text="dark"
                    >
                        {btnComing ? "Em Aberto" : ""}
                    </Badge>
                    <Badge
                        onClick={handleClickEmis}
                        style={{ cursor: "pointer" }}
                        bg="dark"
                        text="light"
                    >
                        {!!dateEmisStart && 'Emissão de: '+SToD(dateEmisStart.replace('-','').replace('-',''))}
                    </Badge>
                    <Badge
                        onClick={handleClickEmis}
                        style={{ cursor: "pointer" }}
                        bg="dark"
                        text="light"
                    >
                        {!!dateEmisEnd && 'Emissão Até: '+SToD(dateEmisEnd.replace('-','').replace('-',''))}
                    </Badge>
                    <Badge
                        onClick={handleClickVenc}
                        style={{ cursor: "pointer" }}
                        bg="dark"
                        text="light"
                    >
                        {!!dateVencStart && 'Vencimento de: '+SToD(dateVencStart.replace('-','').replace('-',''))}
                    </Badge>
                    <Badge
                        onClick={handleClickVenc}
                        style={{ cursor: "pointer" }}
                        bg="dark"
                        text="light"
                    >
                        {!!dateVencEnd && 'Emissão Até: '+SToD(dateVencEnd.replace('-','').replace('-',''))}
                    </Badge>
                </Stack>
            </div>
            
            <SyncLoader
                color={theme === 'dark' ? darkTheme.primary : lightTheme.primary}
                loading={load}
                size={12}
                style={{display:'flex',justifyContent:'center', marginTop:30}}
            />

            { financial.map((item: any, index: number) =>
                <Style.BodyFinTable key={index} backGround={index % 2 == 0}>
                    
                    <Style.BodyHorizItens>
                        <Style.BodyFinLabel color="#000" bold size={18}>
                            Número: {item.document}
                        </Style.BodyFinLabel>

                        <Style.BodyFinLabel color="#000" bold size={18}>
                            Vencimento: {SToD(item.expiration)}
                        </Style.BodyFinLabel>
                    </Style.BodyHorizItens>
                    
                    { type === 'v' &&
                        <Style.BodyHorizItens>
                            <Style.BodyFinLabel color={themeAux.primary} bold size={18}>
                                {item.customerName}
                            </Style.BodyFinLabel>
                        </Style.BodyHorizItens>
                    }


                    <Style.BodyFinItens>
                        <Style.BodyFinColumn>
                            <Style.BodyFinLabel color="#000" bold size={16}>Prefixo</Style.BodyFinLabel>
                            <Style.BodyFinLabel color="#000" bold={false} size={16}>{item.prefix}</Style.BodyFinLabel>
                        </Style.BodyFinColumn>

                        <Style.BodyFinColumn>
                            <Style.BodyFinLabel color="#000" bold size={16}>Parcela</Style.BodyFinLabel>
                            <Style.BodyFinLabel color="#000" bold={false} size={16}>{item.installments}</Style.BodyFinLabel>
                        </Style.BodyFinColumn>

                        <Style.BodyFinColumn>
                            <Style.BodyFinLabel color="#000" bold size={16}>Emissão</Style.BodyFinLabel>
                            <Style.BodyFinLabel color="#000" bold={false} size={16}>{SToD(item.emission)}</Style.BodyFinLabel>
                        </Style.BodyFinColumn>

                        <Style.BodyFinColumn>
                            <Style.BodyFinLabel color="#000" bold size={16}>Status</Style.BodyFinLabel>
                            <Style.BodyFinLabel color={setColorStatus(item.status)} bold={true} size={16}>{item.status}</Style.BodyFinLabel>
                        </Style.BodyFinColumn>

                        <Style.BodyFinColumn>
                            <Style.BodyFinLabel color="#000" bold size={16}>Valor</Style.BodyFinLabel>
                            <Style.BodyFinLabel color="#000" bold={false} size={16}>{CurrencyFormat(item.value)}</Style.BodyFinLabel>
                        </Style.BodyFinColumn>
                    </Style.BodyFinItens>


                    <Style.BodyFinTools>
                        <Style.BodyFinButTool onClick={() => handleOpenLink('Boleto', item)}>Boleto</Style.BodyFinButTool>
                        <Style.BodyFinButTool onClick={() => handleOpenLink('Danfe', item)}>Danfe</Style.BodyFinButTool>
                        <Style.BodyFinButTool onClick={() => handleOpenLink('Xml', item)}>Xml</Style.BodyFinButTool>
                    </Style.BodyFinTools>

                    
                </Style.BodyFinTable>
            )}

            { financial.length <= 0 && !load &&
                <Style.BodyEmptyList>
                    <LottieAnimation
                        animationData={animationData}
                        data={financial}
                        loop={true}
                        autoplay={true}
                        width={300}
                        height={300}
                    />
                    <Style.BodyFinLabel color="#000" bold size={26}>Nenhum título encontrado</Style.BodyFinLabel>

                </Style.BodyEmptyList>
            }
        </Style.financialBodyComponent>
    )
}

export default FinancialBodyModal;