import React, { useState, useEffect, useContext } from 'react';
import * as Style from './styles';
import { Modal } from 'react-native';

import { FontAwesome } from '@expo/vector-icons';

import NetInfo from "@react-native-community/netinfo";
import AsyncStorage from "@react-native-async-storage/async-storage";

import TablePrice from '../components/tablePrice';

import api from '../services/api';
import { ApiResponse, PropsTablePriceModal } from '../interfaces';
import { AppContext } from '../contexts/globalContext';
import PopupsAlterTable from './popupsAlterTable';



export default function modalTablePrice({getVisible, handleModalTablePrice, tablePrice, atualizaTabPreco, atualizaProdutos} : PropsTablePriceModal){
    
    const { setTablePriceSelected, setItemCart, tablePriceSelected } = useContext(AppContext);
    
    const [isLoading, setIsLoading] = useState<boolean>(false);
    const [page, setPage] = useState(1);
    const [isOnline, setIsOnline] = useState(true);
    const [tablePriceAux, setTablePriceAux] = useState(null)

    const [visiblePopupAlterTable, setVisiblePopupAlterTable] = useState(false)
    const [isLoadAlterTable, setLoadAlterTable] = useState<boolean>(false);


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
        if(isOnline){
            loadItems();

        }else {
            fetchAsyncStorage();
        }
    }, []);


    /** faz a chamada da api com paginacao, grava no estado de pagamento e no storage (online) **/
    const loadItems = async () => {
        setIsLoading(true);

        const response = await api.get(`/WSAPP19?pagesize=100&page=${page}`);
        const json: ApiResponse = response.data;

        if(json.status.code === '#200'){    
            const itemSalva = [...tablePrice, ...json.result];
            
            const uniqueArray = itemSalva.reduce((acc, current) => {
                const x = acc.find((item: { id: any; }) => item.id === current.id);
                return !x ? acc.concat([current]) : acc;
            }, []);

            uniqueArray.sort((a: any, b: any) => a.id.localeCompare(b.id));

            await AsyncStorage.removeItem("tablePrice")
            await AsyncStorage.setItem("tablePrice", JSON.stringify([...tablePrice, ...uniqueArray]));

            atualizaTabPreco(uniqueArray);
            setPage((prevPage) => prevPage + 1);
        }
        
        setIsLoading(false);
    };


    /** faz a chamada no storage e grava no estado de pagamentos (offline) **/
    const fetchAsyncStorage = async () => {
        try {
          const result = await AsyncStorage.getItem('tablePrice');
  
          if (result) {
            const tablePriceStorage = JSON.parse(result);
              atualizaTabPreco(tablePriceStorage);
          }

        } catch (error) {
          console.error(error);
        }
    };


    /** Seta o pagamento selecionado **/
    const handleItem = (item: any) => {
        if(tablePriceSelected.id !== item.id){
            setTablePriceAux(item)
            setVisiblePopupAlterTable(!visiblePopupAlterTable)
            
        }
    }

    
    const handlePopupAlterTable = (option: any) => {
        setLoadAlterTable(true)

        if(option === 'sim'){

            setTablePriceSelected(tablePriceAux)
            setItemCart([])
            atualizaProdutos([])
            handleModalTablePrice()
        }

        setVisiblePopupAlterTable(!visiblePopupAlterTable)
        setTablePriceAux(null)
        setLoadAlterTable(false)
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
                        
                        <Style.ButtonCloseModal
                            onPress={handleModalTablePrice}
                            activeOpacity={0.4}
                        >
                            <FontAwesome name="close" size={30} color="black" />
                        </Style.ButtonCloseModal>
                    </Style.TopModalNewOrder>

                    
                    { !isOnline &&
                        <Style.TextDisconnected>offline</Style.TextDisconnected>
                    }

                    <Style.MiddleModalNewOrder>
                        
                        <TablePrice
                            tablePrice={tablePrice}
                            handleItem={handleItem}
                            isLoading={isLoading}
                            isOnline={isOnline}
                        />
                    </Style.MiddleModalNewOrder>
                </Style.ModalOrderContainer>
            </Style.SafeAreaModals>

            <PopupsAlterTable 
                getVisible={visiblePopupAlterTable}
                handlePopup={handlePopupAlterTable}
                load={isLoadAlterTable}
            />
        </Modal>

    )
}