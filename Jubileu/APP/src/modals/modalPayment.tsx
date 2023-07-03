import React, { useState, useEffect, useContext, useRef } from 'react';
import * as Style from './styles';
import { ActivityIndicator, Keyboard, Modal, TextInput } from 'react-native';

import { FontAwesome, AntDesign } from '@expo/vector-icons';

import NetInfo from "@react-native-community/netinfo";
import AsyncStorage from "@react-native-async-storage/async-storage";

import Payment from '../components/payment';

import api from '../services/api';
import { ApiResponse, PropsPaymentModal } from '../interfaces';
import { AppContext, ThemeContext } from '../contexts/globalContext';



export default function modalPayment({getVisible, handleModalPayment, payment, atualizaPagamentos} : PropsPaymentModal){
    
    const { setPaymentSelected } = useContext(AppContext);
    const { colors } = useContext(ThemeContext);
    const searchInputRef = useRef<TextInput>(null);
    
    const [searchQuery, setSearchQuery] = useState<string>('');
    const [isLoading, setIsLoading] = useState<boolean>(false);
    const [page, setPage] = useState(1);
    const [isOnline, setIsOnline] = useState(true);

    const [isLoadSearch, setLoadSearch] = useState<boolean>(false);
    const [search, setSearch] = useState<boolean>(false);


    /** verifica se esta online ou offline **/
    useEffect(() => {
        const unsubscribe = NetInfo.addEventListener((state: any) => {
            setIsOnline(state.isConnected);
        });
      
        return () => {
            unsubscribe();
        };
    }, []);


    /** verifica se esta online. Se tiver, chama a API com pagamentos, se nao, chama os pagamentos que estao salvos no storage **/
    useEffect(() => {
        setSearch(false)
        setSearchQuery('')

        if(isOnline){
            loadItems();

        }else {
            fetchAsyncStorage();
        }
    }, []);


    /** faz a chamada da api com paginacao, grava no estado de pagamento e no storage (online) **/
    const loadItems = async () => {
        setIsLoading(true);

        const response = await api.get(`/WSAPP04?pagesize=100&page=${page}`);
        const json: ApiResponse = response.data;

        if(json.status.code === '#200'){    
            const itemSalva = [...payment, ...json.result];
            
            const uniqueArray = itemSalva.reduce((acc, current) => {
                const x = acc.find((item: { id: any; }) => item.id === current.id);
                return !x ? acc.concat([current]) : acc;
            }, []);

            uniqueArray.sort((a: any, b: any) => a.code.localeCompare(b.code));

            await AsyncStorage.removeItem("payment")
            await AsyncStorage.setItem("payment", JSON.stringify([...payment, ...uniqueArray]));

            atualizaPagamentos(uniqueArray);
            setPage((prevPage) => prevPage + 1);
        }
        
        setIsLoading(false);
    };


    /** faz a chamada no storage e grava no estado de pagamentos (offline) **/
    const fetchAsyncStorage = async () => {
        try {
          const result = await AsyncStorage.getItem('payment');
  
          if (result) {
            const paymentStorage = JSON.parse(result);
              atualizaPagamentos(paymentStorage);
          }

        } catch (error) {
          console.error(error);
        }
    };

    
    /** ao chegar no final da lista, verifica se esta online para chamada da proxima pagina da API **/
    const handleLoadMore = () => {
        if (!isLoading && !searchQuery && isOnline) {
          loadItems();
        }
    };

    /** Seta o pagamento selecionado **/
    const handleItem = (item: any) => {
        setPaymentSelected(item)
        handleModalPayment()
    }


    const handleSearchButton = async() => {
        setLoadSearch(true);
        Keyboard.dismiss();

        if(!searchQuery){
            setLoadSearch(false)
            handleClearSearch();
            return
        }

        if(isOnline){
            const response = await api.get(`/WSAPP04?pagesize=10&page=1&searchKey=${searchQuery}`);
            const json: ApiResponse = response.data;

            atualizaPagamentos(json.result);
            setPage(1);
            setSearch(true)

        }else{
            const result = await AsyncStorage.getItem('payment');

            if (result) {
                const paymentStorage = JSON.parse(result);
                
                const filtered = paymentStorage.filter((pay: any) => pay.description.includes(searchQuery));
                atualizaPagamentos(filtered);
            }
        }
        
        setLoadSearch(false);
    }
    

    const handleClearSearch = () => {
        setSearch(false)
        setSearchQuery('')
        setPage(1)

        if(isOnline){
            loadItems();

        }else {
            fetchAsyncStorage();
        }  
    }

    
    return(
        <Modal 
            transparent
            visible={getVisible}
            animationType='slide'
        >
            <Style.SafeAreaModals>
                <Style.ModalOrderContainer>
                    <Style.TopModalNewOrder>
                        <Style.ContainerSearchModal>
                            <Style.SearchNewOrderModal
                                keyboardType='email-address'
                                ref={searchInputRef}
                                autoCorrect={false}
                                placeholder='Pesquisar'
                                value={searchQuery}
                                autoCapitalize='none'
                                returnKeyType="done"
                                onChangeText={setSearchQuery}
                                onSubmitEditing={handleSearchButton}
                            />


                            <Style.ButtonSearch onPress={() => handleSearchButton()}>
                                { isLoadSearch
                                    ? <ActivityIndicator color={colors.primary} />
                                    : <AntDesign name="search1" size={23} color={colors.primary} />
                                }
                            </Style.ButtonSearch>
                        </Style.ContainerSearchModal>
                        
                        <Style.ButtonCloseModal
                            onPress={handleModalPayment}
                            activeOpacity={0.4}
                        >
                            <FontAwesome name="close" size={30} color="black" />
                        </Style.ButtonCloseModal>
                    </Style.TopModalNewOrder>

                    
                    { !isOnline &&
                        <Style.TextDisconnected>offline</Style.TextDisconnected>
                    }

                    <Style.MiddleModalNewOrder>

                        { search &&
                            <Style.ContainerBadgeSearch>
                                <Style.BadgeSearch onPress={handleClearSearch}>
                                    <Style.IconBadgeSearch name="close" />
                                    <Style.TextBadgeSearch color='#fff'>{searchQuery}</Style.TextBadgeSearch>
                                </Style.BadgeSearch>
                            </Style.ContainerBadgeSearch>
                        }
                        
                        <Payment
                            payment={payment}
                            handleLoadMore={handleLoadMore}
                            handleItem={handleItem}
                            isLoading={isLoading}
                            isOnline={isOnline}
                        />
                    </Style.MiddleModalNewOrder>
                </Style.ModalOrderContainer>
            </Style.SafeAreaModals>
        </Modal>
    )
}