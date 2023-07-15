import React, { useContext, useEffect, useRef, useState } from 'react';
import * as Style from './styles';

import { ActivityIndicator, FlatList, TouchableOpacity, Linking } from 'react-native';

import LottieView from 'lottie-react-native'
import { FontAwesome } from '@expo/vector-icons';

import NetInfo from "@react-native-community/netinfo";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { ApiResponse } from '../interfaces';
import api, { apiLink } from '../services/api';

import { SToD } from '../utils/dateFormat';
import { CurrencyFormat } from '../utils/currencyFormat';
import { AppContext } from '../contexts/globalContext';

interface PropsFinancial{
    customer: any;
    handleFinancial: () => void;
    order?: boolean;
    viewTitle?: boolean;
    handleContinue?: () => void;
}


export default function financial({
    customer,
    handleFinancial,
    order = false,
    viewTitle = true,
    handleContinue = () => {}
} : PropsFinancial){
    
    const animation = useRef(null);
    const { authDetail } = useContext(AppContext);

    const [isLoading, setIsLoading] = useState<boolean>(false);
    const [page, setPage] = useState(1);
    const [isOnline, setIsOnline] = useState(true);
    const [financial, setFinancial] = useState<any>([])


    /** verifica se esta online ou offline **/
    useEffect(() => {
        const unsubscribe = NetInfo.addEventListener((state: any) => {
            setIsOnline(state.isConnected);
        });
      
        return () => {
            unsubscribe();
        };
    }, []);


    /** verifica se esta online. Se tiver, chama a API com titulos, se nao, chama os titulos que estao salvos no storage **/
    useEffect(() => {
        if(isOnline){
            if(!!customer){
                loadItems();
            }
        }else {
            fetchAsyncStorage();
        }
    }, []);


    /** faz a chamada da api com paginacao, grava no estado de titulo e no storage (online) **/
    const loadItems = async () => {
        setIsLoading(true);

        const response = await api.get(`/WSAPP05?pagesize=100&page=${page}&customer=${customer.cnpj}&token=${authDetail.token}&type=V`);
        const json: ApiResponse = response.data;

        if(json.status.code === '#200'){    
            const itemSalva = [...financial, ...json.result];
            
            const uniqueArray = itemSalva.reduce((acc, current) => {
                const x = acc.find((item: { id: any; }) => item.id === current.id);
                return !x ? acc.concat([current]) : acc;
            }, []);

            const sorted = [...uniqueArray].sort((a, b) => {
                const expirationComparison = b.expiration.localeCompare(a.expiration);
                if (expirationComparison !== 0) {
                  return expirationComparison;
                }
                const documentComparison = a.document.localeCompare(b.document);
                if (documentComparison !== 0) {
                  return documentComparison;
                }
                return b.installments.localeCompare(a.installments);
            });

            await AsyncStorage.removeItem("financial")
            await AsyncStorage.setItem("financial", JSON.stringify([...financial, ...sorted]));

            setFinancial(sorted);
            setPage((prevPage) => prevPage + 1);
        }
        
        setIsLoading(false);
    };


    /** faz a chamada no storage e grava no estado de titulos (offline) **/
    const fetchAsyncStorage = async () => {
        try {
          const result = await AsyncStorage.getItem('financial');
  
          if (result) {
            const financialStorage = JSON.parse(result);
              setFinancial(financialStorage);
          }

        } catch (error) {
          console.error(error);
        }
    };

    
    /** ao chegar no final da lista, verifica se esta online para chamada da proxima pagina da API **/
    const handleLoadMore = () => {
        if (!isLoading && isOnline) {
          loadItems();
        }
    };


    /** faz a renderizacao do icone de load no final da lista conforme busca mais produtos **/
    const renderFooter = () => {
        if (!isLoading || !isOnline || financial.length < 10) return null;

        return (
            <Style.LoadingContent>
                <ActivityIndicator animating size="large" color={'#000'} />
            </Style.LoadingContent>
        );
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

    const abrirLink = async (type: string, item: any) => {
        const url = `${apiLink}/WSAPP14?cTipo=${type}&cDoc=${item.document}&cSerie=${item.prefix}&cFilNF=${item.branch_invoice}&cParce=${item.installments}`;
        const suportaAbrir = await Linking.canOpenURL(url);
    
        if (suportaAbrir) {
          await Linking.openURL(url);
        } else {
          console.log(`Não é possível abrir o URL: ${url}`);
        }
      };

    return(
        <Style.ContainerFinancial>
            <Style.HeaderFinancial>
                <Style.TitleFinancial>
                    {customer.code}
                </Style.TitleFinancial>
                <TouchableOpacity onPress={handleFinancial}>
                    <FontAwesome name="close" size={30} color="black" />
                </TouchableOpacity>
            </Style.HeaderFinancial>

            <Style.SubTitleFinancial>
                {customer.name}
            </Style.SubTitleFinancial>
            
            <FlatList
                data={financial}
                showsVerticalScrollIndicator={false}
                renderItem={({ item, index }: { item: any; index: number; }) => (
                    <Style.ContainerItemFinancial activeOpacity={1} backGround={index % 2 == 0}>
                        <Style.ContainerHorizFinancial>
                            <Style.ContainerVencFinancial>
                                <Style.TitleItemFinancial>{'Documento: '}</Style.TitleItemFinancial>
                                <Style.TextItemFinancial>{item.document}</Style.TextItemFinancial>                      
                            </Style.ContainerVencFinancial>
                            
                            <Style.ContainerVencFinancial>
                                <Style.TitleItemFinancial>{'Vencimento: '}</Style.TitleItemFinancial>
                                <Style.TextItemFinancial>{SToD(item.expiration)}</Style.TextItemFinancial>                      
                            </Style.ContainerVencFinancial>
                        </Style.ContainerHorizFinancial>


                        <Style.ContainerItensFinancial>
                            <Style.SectionColumnFinancial>
                                <Style.TitleItemFinancial>Prefixo</Style.TitleItemFinancial>
                                <Style.TextItemFinancial>{item.prefix}</Style.TextItemFinancial>
                            </Style.SectionColumnFinancial>

                            <Style.SectionColumnFinancial>
                                <Style.TitleItemFinancial>Parcela</Style.TitleItemFinancial>
                                <Style.TextItemFinancial>{item.installments}</Style.TextItemFinancial>
                            </Style.SectionColumnFinancial>

                            <Style.SectionColumnFinancial>
                                <Style.TitleItemFinancial>Emissão</Style.TitleItemFinancial>
                                <Style.TextItemFinancial>{SToD(item.emission)}</Style.TextItemFinancial>
                            </Style.SectionColumnFinancial>

                            <Style.SectionColumnFinancial>
                                <Style.TitleItemFinancial>Status</Style.TitleItemFinancial>
                                <Style.StatusItemFinancial color={setColorStatus(item.status)}>{item.status}</Style.StatusItemFinancial>
                            </Style.SectionColumnFinancial>

                            <Style.SectionColumnFinancial>
                                <Style.TitleItemFinancial>Valor</Style.TitleItemFinancial>
                                <Style.TextItemFinancial>{CurrencyFormat(item.value)}</Style.TextItemFinancial>
                            </Style.SectionColumnFinancial>
                        </Style.ContainerItensFinancial>

                        <Style.ButtonContainerFinancial>
                            <Style.ButtonFinancial onPress={() => abrirLink('Boleto', item)}>
                                <Style.TextButtonFinancial>Boleto</Style.TextButtonFinancial>
                            </Style.ButtonFinancial>

                            <Style.ButtonFinancial onPress={() => abrirLink('Danfe', item)}>
                                <Style.TextButtonFinancial>Danfe</Style.TextButtonFinancial>
                            </Style.ButtonFinancial>

                            <Style.ButtonFinancial onPress={() => abrirLink('Xml', item)}>
                                <Style.TextButtonFinancial>Xml</Style.TextButtonFinancial>
                            </Style.ButtonFinancial>
                        </Style.ButtonContainerFinancial>
                        
                    </Style.ContainerItemFinancial>
                )}
                keyExtractor={item => item.id}
                ListFooterComponent={renderFooter}
                onEndReached={handleLoadMore}
                onEndReachedThreshold={0.5}
                ListEmptyComponent={
                    <Style.EmptyListContProd>
                        { isLoading ?
                            <>
                                <LottieView
                                    autoPlay
                                    loop
                                    ref={animation}
                                    style={{width: 150, height:150}}
                                    source={require('../assets/search.json')}
                                />
                                <Style.EmptyListTextProd>Buscando títulos...</Style.EmptyListTextProd>
                            </>
                            :
                            <>
                                <LottieView
                                    autoPlay
                                    loop
                                    ref={animation}
                                    style={{width: 150, height:150}}
                                    source={require('../assets/emptyList.json')}
                                />
                                <Style.EmptyListTextProd>Nenhum título encontrado.</Style.EmptyListTextProd>
                            </>
                        }
                    </Style.EmptyListContProd>
                }
            />

            {order && viewTitle &&
                <Style.ButtonContinue onPress={() => handleContinue()}>
                    <Style.TextButtonFinancial>Continuar com orçamento</Style.TextButtonFinancial>
                </Style.ButtonContinue>
            }
            
        </Style.ContainerFinancial>
    )
}