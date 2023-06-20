import React, { useState, useEffect, useContext } from 'react';
import * as Style from './styles';
import { ActivityIndicator, Modal } from 'react-native';

import { FontAwesome, AntDesign, Ionicons } from '@expo/vector-icons';

import NetInfo from "@react-native-community/netinfo";

import debounce from 'lodash/debounce';
import Products from '../components/products';

import api from '../services/api';

import { apiProducts, storageProducts, searchProducts } from '../services/apiProducts';

import { PropItemCartContext, ApiResponse, PropsProductsModal } from '../interfaces';
import { AppContext, ThemeContext } from '../contexts/globalContext';

import { CameraType } from 'expo-camera';


export default function modalProducts({getVisible, handleModalProducts, products, atualizaProdutos} : PropsProductsModal){
    
    const { itemCart, setItemCart } = useContext(AppContext);
    const { colors } = useContext(ThemeContext);
    
    const [searchQuery, setSearchQuery] = useState<string>('');
    const [markedCount, setMarkedCount] = useState<number>(0);
    const [isLoadTop, setLoadTop] = useState<boolean>(false);
    const [isLoadBottom, setLoadBottom] = useState<boolean>(false);
    const [page, setPage] = useState(1);
    const [isOnline, setIsOnline] = useState(true);

    const [scanned, setScanned] = useState(false);
    const [hasCamera, setHasCamera] = useState(false);


    /** verifica se esta online ou offline **/
    useEffect(() => {
        const unsubscribe = NetInfo.addEventListener((state: any) => {
            setIsOnline(state.isConnected);
        });

        return () => {
            unsubscribe();
        };
    }, []);   


    /** verifica se esta online. Se tiver, chama a API com produtos, se nao, chama os produtos que estao salvos no storage **/
    useEffect(() => {
        if(isOnline){
            loadItems();
        }else {
            fetchAsyncStorage();
        }
    }, []);


    /** faz a chamada da api com paginacao, grava no estado de produtos e no storage (online) **/
    const loadItems = async() => {
        setLoadBottom(true);
        
        const resultApi = await apiProducts(page, products, 1)
        
        if(!!resultApi){
            atualizaProdutos(resultApi.returnResult)
            setPage(resultApi.pageResult)
        }
        setLoadBottom(false);
    }


    /** faz a chamada no storage e grava no estado de produtos (offline) **/
    const fetchAsyncStorage = async () => {
        setLoadBottom(true);
        
        const resultApi = await storageProducts(1)
        
        if(!!resultApi){
            atualizaProdutos(resultApi.returnResult)
            setPage(resultApi.pageResult)
        }

        setLoadBottom(false);
    };


    /** ao chegar no final da lista, verifica se esta online para chamada da proxima pagina da API **/
    const handleLoadMore = () => {
        if (!isLoadBottom && !searchQuery && isOnline) {
          loadItems();
        }
    };


    /** grava o state conforme digitacao da pesquisa e faz a chamada do devounced para busca da api **/
    const handleSearch = (text: string) => {
        setSearchQuery(text);
        handleSearchDebounced(text);
    };


    /** faz a chamada da api conforme o usuario vai digitando na pesquisa.
        Tem um atraso de 500 milisegundo para aguardar o fim da digitacao e nao encavalar a chamada de api
    **/
    const handleSearchDebounced = debounce(async (searchQuery: string) => {
        setLoadBottom(true);

        const resultApi = await searchProducts(searchQuery, isOnline)
        
        if(!!resultApi){
            atualizaProdutos(resultApi.returnResult)
            setPage(resultApi.pageResult)
        }
        
        setLoadBottom(false);
    }, 500);


    /** conforme for selecionando os produtos, vai atualizando o item marked de cada objeto do json, para controle de marcacao.
        atualiza tambem a state de count para marcar quantos selecionados
    **/
    const handleItem = (index: number) => {
        atualizaProdutos((prevState: any) => {
          const newData = [...prevState];

          newData[index] = {
            ...newData[index],
            marked: !newData[index].marked
          };

          return newData;
        });

        setMarkedCount(prevCount => {
            return products[index].marked 
                ? prevCount - 1 
                : prevCount + 1;
        });
    };


    /** reseta todo o array marcando todos os marked como false e zera o contador **/
    const resetMarked = () => {
        const newData = products.map((item: { marked: boolean; }) => {
          item.marked = false;
          return item;
        });

        atualizaProdutos(newData);
        setMarkedCount(0);
    };


    /** responsavel por adicionar os itens selecionados no carrinho da context **/
    const handleAddItens = () => {
        let close = false
        let auxItem: PropItemCartContext[] = []
    
        products.forEach((item: PropItemCartContext) => {
            if (item.marked) {
                item.selected_quantity = 1
                auxItem.push(item);
                close = true
            }
        });
    
        if (close){
            const itemSalva = [...itemCart, ...auxItem];
            
            const uniqueArray = itemSalva.reduce((acc, current) => {
                const x = acc.find((item: { id: any; }) => item.id === current.id);
                return !x ? acc.concat([current]) : acc;
            }, []);

            setItemCart(uniqueArray)
            resetMarked()
            handleModalProducts()
        }
    }

    
    const handleHasCamera = () => {
        setHasCamera(!hasCamera)
    }


    const handleBarCodeScanned = async({ type, data }: any) => {

        setScanned(true);
        setLoadTop(true)
        
        const find = findProductIndexByCode(products,data)
        
        if (find !== null){
            if(!products[find].marked){
                handleItem(find)
            }

            setTimeout(() => {
                setScanned(false);
            }, 1000);

        }else{
            const response = await api.get(`/WSAPP03?pagesize=10&page=1&byId=true&searchKey=${data}`);
            const json: ApiResponse = response.data;

            if(json.status.code === '#200'){
                json.result[0].marked = true
                const itemSalva = [...products, ...json.result];
        
                const uniqueArray = itemSalva.reduce((acc, current) => {
                    const x = acc.find((item: { id: any; }) => item.id === current.id);
                    return !x ? acc.concat([current]) : acc;
                }, []);

                atualizaProdutos(uniqueArray)
                setMarkedCount(markedCount+1);
                  
                setTimeout(() => {
                    setScanned(false);
                }, 1000);
            }
        }

        setLoadTop(false)
    }

    const findProductIndexByCode = (prod: any, codeToFind: string): number | null =>{
        const foundProductIndex = prod.findIndex((product: any) => product.code === codeToFind);
        return foundProductIndex !== -1 ? foundProductIndex : null;
    }
      
    return(
        <Modal 
            transparent
            visible={getVisible}
            animationType='slide'
        >
            <Style.SafeAreaModals>
                <Style.ModalOrderContainer style={Style.styleSheet.shadow}>
                    
                    <Style.TopModalNewOrder>
                        <Style.ContainerSearchModal>
                            <Style.SearchNewOrderModal
                                keyboardType='email-address'
                                autoCapitalize='none'
                                autoCorrect={false}
                                placeholder='Pesquisar'
                                onChangeText={handleSearch}
                                value={searchQuery}
                            />

                            <AntDesign name="search1" size={20} color={colors.primary} />
                        </Style.ContainerSearchModal>
                        
                        { markedCount > 0 ? 
                            <Style.ButtomCancelSelect
                                onPress={resetMarked}
                                activeOpacity={0.4}
                            >
                                <FontAwesome name="close" size={24} color="white" />
                                <Style.CountSelectProd>{markedCount}</Style.CountSelectProd>
                            </Style.ButtomCancelSelect>
                        
                        :
                            <Style.ButtonCloseModal
                                onPress={handleModalProducts}
                                activeOpacity={0.4}
                            >
                                <FontAwesome name="close" size={30} color="black" />
                            </Style.ButtonCloseModal>
                            
                        }

                    </Style.TopModalNewOrder>
                    
                    { !isOnline &&
                        <Style.TextDisconnected>offline</Style.TextDisconnected>
                    }

                    <Style.MiddleModalNewOrder>
                        { hasCamera &&
                            <Style.ComponentQRCode>
                                <Style.QRCodeScan
                                    type={CameraType.back}
                                    onBarCodeScanned={scanned ? undefined : handleBarCodeScanned}
                                    style={{flex:1}}
                                >
                                </Style.QRCodeScan>

                                { isLoadTop && 
                                    <Style.LoadingContent>
                                        <ActivityIndicator animating size="large" color={'#000'} />
                                    </Style.LoadingContent>
                                }
                            </Style.ComponentQRCode>
                        }
                        
                        <Style.ComponentProductModal>
                            <Products
                                products={products}
                                handleLoadMore={handleLoadMore}
                                handleItem={handleItem}
                                isLoadBottom={isLoadBottom}
                                isOnline={isOnline}
                                isOrder={true}
                            />
                        </Style.ComponentProductModal>
                    </Style.MiddleModalNewOrder>

                    <Style.BottomModalNewOrder>

                        <Style.TotalsFooterOrder mt={20}>
                            <Style.ButtonClearOrder
                                onPress={handleHasCamera}
                                activeOpacity={0.4}
                            >
                                <Ionicons name={!hasCamera ? "qr-code" : "close"} size={24} color="#fff" />
                            </Style.ButtonClearOrder>

                            <Style.ButtonFinishOrder
                                onPress={handleAddItens}
                                activeOpacity={0.4}
                            >
                                <Style.TextFooterOrder color='#fff'>Adicionar Itens</Style.TextFooterOrder>
                            </Style.ButtonFinishOrder>
                        </Style.TotalsFooterOrder>

                    </Style.BottomModalNewOrder>
                    
                </Style.ModalOrderContainer>
            </Style.SafeAreaModals>
        </Modal>
    )
}