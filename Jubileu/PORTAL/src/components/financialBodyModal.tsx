import React, { useContext, useState, useEffect } from "react";

import SyncLoader from "react-spinners/SyncLoader";
import LottieAnimation from "./lottieAnimation";

import animationData from '../assets/emptylist.json'

import * as Style from "./styles"
import { ThemeContext } from "../contexts/ThemeContext";

import { darkTheme, lightTheme } from "../themes";

import { fetchData } from "../services/apiFinancial";

import { SToD } from "../utils/dateFormat";
import { CurrencyFormat } from "../utils/currencyFormat";

interface Props{
    financialCustomer: any;
    type: string;
}

const FinancialBodyModal: React.FC <Props> = ({financialCustomer, type})  => {

    const { theme } = useContext(ThemeContext);
    
    const themeAux = theme === 'dark' ? darkTheme : lightTheme;

    const [financial, setFinancial] = useState<any>([])
    const [load, setLoad] = useState<boolean>(false)

    useEffect(() => {
        const loadItems = async () => {
            if(!financialCustomer) return;

            setLoad(true)
            
            const userData = localStorage.getItem('userdata');
            const user = userData ? JSON.parse(userData) : null;
            
            const returnResult: any = await fetchData(financialCustomer.cnpj, user.token, type)
    
            if(returnResult.length > 0){
                setFinancial(returnResult);
            }
            
            setLoad(false)
        };

        loadItems()
    }, [])

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

    return(
        <>
        { !!financialCustomer &&
            <>
            <Style.TextH4 style={{color:'#000'}}>{financialCustomer.code}</Style.TextH4>
            <Style.TextH3 style={{color:themeAux.primary}}>{financialCustomer.name}</Style.TextH3>
            </>
        }

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
                        <Style.BodyFinLabel color={setColorStatus(item.status)} bold={false} size={16}>{item.status}</Style.BodyFinLabel>
                    </Style.BodyFinColumn>

                    <Style.BodyFinColumn>
                        <Style.BodyFinLabel color="#000" bold size={16}>Valor</Style.BodyFinLabel>
                        <Style.BodyFinLabel color="#000" bold={false} size={16}>{CurrencyFormat(item.value)}</Style.BodyFinLabel>
                    </Style.BodyFinColumn>
                </Style.BodyFinItens>


                <Style.BodyFinTools>
                    <Style.BodyFinButTool onClick={() => {}}>Boleto</Style.BodyFinButTool>
                    <Style.BodyFinButTool onClick={() => {}}>Danfe</Style.BodyFinButTool>
                    <Style.BodyFinButTool onClick={() => {}}>Xml</Style.BodyFinButTool>
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
        </>
    )
}

export default FinancialBodyModal;