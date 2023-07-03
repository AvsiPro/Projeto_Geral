import React, { useState, useEffect, useCallback, useContext, useRef } from 'react';
import { ActivityIndicator, FlatList, Keyboard } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { AntDesign, MaterialCommunityIcons, Ionicons } from '@expo/vector-icons';
import * as Style from './styles';

import { useFocusEffect, useNavigation } from '@react-navigation/native';

import Footer from '../../components/footer';

import ModalOrder from "../../modals/modalOrder";
import Popups from '../../modals/popups';
import PopupsCopyOrder from '../../modals/popupsCopyOrder';

import NetInfo from "@react-native-community/netinfo";

import { SToD } from '../../utils/dateFormat';
import { CgcFormat } from '../../utils/cgcFormat';
import { ThemeContext } from 'styled-components';

import { Swipeable } from 'react-native-gesture-handler';

import debounce from 'lodash/debounce';
import { apiOrders, storageOrders, searchOrders, sortOrderList } from '../../services/apiOrders'
import { AppContext } from '../../contexts/globalContext';

import LottieView from 'lottie-react-native'

import { encode } from 'base-64';
import { ApiResponse } from '../../interfaces';
import api from '../../services/api';


export default function Orders(){

    const { colors } = useContext(ThemeContext);
    const { authDetail, setItemCart, setCustomerSelected, setPaymentSelected, setOrcamentoSelected } = useContext(AppContext);
    const navigation: any = useNavigation();

    const [visibleModal, setVisibleModal] = useState(false)
    const [visiblePopup, setVisiblePopup] = useState(false)
    const [visiblePopupCopy, setVisiblePopupCopy] = useState(false)
    const [itemModal, setItemModal] = useState([])
    const [itemCopy, setItemCopy] = useState<any>(null)
    const [filter, setFilter] = useState(4)
    const [disableFooter, setDisableFooter] = useState(false)
    const [isOnline, setIsOnline] = useState(true);

    const [isLoadBottom, setLoadBottom] = useState<boolean>(false);
    const [isLoadCopy, setLoadCopy] = useState<boolean>(false);
    const [orders, setOrders] = useState<any[]>([]);
    const [page, setPage] = useState(1);
    const [searchQuery, setSearchQuery] = useState<string>('');

    const animation = useRef(null);

    useEffect(()=>{
        Keyboard.addListener('keyboardDidShow', keyboardDidShow);
        Keyboard.addListener('keyboardDidHide', keyboardDidHide);

    },[]);

    const keyboardDidShow = () => { setDisableFooter(true) }
    const keyboardDidHide = () => { setDisableFooter(false) }


    /** verifica se esta online ou offline **/
    useEffect(() => {
        const unsubscribe = NetInfo.addEventListener((state: any) => {
            setIsOnline(state.isConnected);
        });
        
        return () => {
            unsubscribe();
        };
    }, []);


    /** verifica se esta online. Se tiver, chama a API com orders, se nao, chama os orders que estao salvos no storage **/
    useFocusEffect(
        useCallback(() => {
            if(isOnline){
                loadItems();
    
            }else {
                fetchAsyncStorage();
            }
          
          return () => {
            // Função de limpeza, se necessário
          };
        }, [])
    );
    


    const loadItems = async() => {
        setLoadBottom(true);
        
        const resultApi = await apiOrders(page, orders, filter, authDetail.token)
        
        if(!!resultApi){
            setOrders(resultApi.returnResult)
            setPage(resultApi.pageResult)
        }
        setLoadBottom(false);
    }


    /** faz a chamada no storage e grava no estado de orders (offline) **/
    const fetchAsyncStorage = async () => {
        setLoadBottom(true);
        
        const resultApi = await storageOrders(filter)
        
        if(!!resultApi){
            setOrders(resultApi.returnResult)
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

        const resultApi = await searchOrders(searchQuery, isOnline)
        
        if(!!resultApi){
            setOrders(resultApi.returnResult)
            setPage(resultApi.pageResult)
        }
        
        setLoadBottom(false);
    }, 500);


    const handleModal = (item: any) =>{
        if(!!item){    
            setItemModal(item)
        }

        setVisibleModal(!visibleModal)
    }

    const handlePopup = (index: any) =>{
        setVisiblePopup(!visiblePopup)
        
        if(!!index){
            setFilter(index)

            const listAux = sortOrderList(index, orders)
            setOrders(listAux)
        }
    }

    const handlePopupCopy = async(option: any) =>{
        setLoadCopy(true)

        if(option === 'sim'){
            let itemCartAux: any = []

            itemCopy.items.map((itemCart: any) => {
                itemCartAux.push({
                    id: encode(`{"SB1","copy","${itemCart.product}","${itemCart.description}"}`),
                    code: itemCart.product,
                    description: itemCart.description,
                    price: itemCart.value_sold,
                    selected_quantity: itemCart.sold_amount,
                    marked: true
                })
            })

            const customerAux = await apiCustomerCopy(itemCopy.customer)

            setItemCart(itemCartAux)
            setCustomerSelected(customerAux[0])
            setPaymentSelected(null)

            navigation.navigate('Neworder')
        }

        setLoadCopy(false)
        setItemCopy(null)
        setVisiblePopupCopy(!visiblePopupCopy)
    }

    const handleCopyButton = (item: any) => {
        setItemCopy(item)
        setVisiblePopupCopy(true)
    }


    const apiCustomerCopy = async(customer: string) => {
        
        let returnObject: any = []

        const response = await api.get(`/WSAPP02?pagesize=100&page=1&byId=true&SearchKey=${customer}`);
        const json: ApiResponse = response.data;
    
        if(json.status.code === '#200'){    
            returnObject = [...json.result];
        }

        return returnObject;  
    }

    const RightActions = (item: any) => {
        return(
            <Style.SwipeableOrderContainer
                onPress={() => {handleCopyButton(item)}}
            >
                <Ionicons
                    name="md-copy"
                    size={24}
                    color="#FF932F"
                />
                <Style.SwipeableOrderText>Copiar</Style.SwipeableOrderText>
            </Style.SwipeableOrderContainer>
        )

    }

    /** faz a renderizacao do icone de load no final da lista conforme busca mais produtos **/
    const renderFooter = () => {
        if (!isLoadBottom) return null;
        if (!isOnline) return null;
        if (orders.length < 10) return null;

        return (
            <Style.LoadingContent>
                <ActivityIndicator animating size="large" color={'#000'} />
            </Style.LoadingContent>
        );
    };


    const handleOrcamento = (item: any) => {
        setItemCart(item.items)
        setCustomerSelected(item.customer)
        setPaymentSelected(item.payment)
        setOrcamentoSelected(item.numorc)
        
        navigation.navigate('Neworder')
    }


    const Order = ({item}: any) => {
        return(
            <Swipeable
                renderRightActions={() => RightActions(item)}
            >
                <Style.ContainerItemOrder 
                    style={Style.styleSheet.shadow}
                    onPress={() => handleModal(item)}
                    activeOpacity={0.4}
                >
                    <Style.HeaderItemOrder>
                        <Style.CodigoOrder>{item.document}</Style.CodigoOrder>
                        <Style.DateOrderContainer>
                            <Style.TextDateOrder color={colors.primary}>
                                {'Emissão: '}
                            </Style.TextDateOrder>

                            <Style.TextDateOrder color={'#000'}>
                                {SToD(item.issue_date)}
                            </Style.TextDateOrder>
                        </Style.DateOrderContainer>
                    </Style.HeaderItemOrder>
                    
                    <Style.MiddleTextOrder>
                        <Style.TextClienteMiddle>
                            {item.customer_name}
                        </Style.TextClienteMiddle>
                        
                        <Style.TextStatusMiddle>
                            {item.status}
                        </Style.TextStatusMiddle>
                    </Style.MiddleTextOrder>

                    <Style.DownTextOrder>
                        <Style.DownOrderContainer>
                            <Style.TextCgcOrder color={colors.primary}>
                                {'CNPJ: '}
                            </Style.TextCgcOrder>

                            <Style.TextCgcOrder color={'#000'}>
                                {CgcFormat(item.customer_cnpj)}
                            </Style.TextCgcOrder>
                        </Style.DownOrderContainer>

                        <Style.DownOrderContainer>
                            { !!item.invoice && <>
                                <Style.TextCgcOrder color={colors.primary}>
                                    {'Nota: '}
                                </Style.TextCgcOrder>

                                <Style.TextCgcOrder color={'#000'}>
                                    {item.invoice + (item.invoice_series && '-' + item.invoice_series)}
                                </Style.TextCgcOrder>
                            </> }
                        </Style.DownOrderContainer>
                    </Style.DownTextOrder>
                </Style.ContainerItemOrder>
            </Swipeable>
        )
    }


    const Orcamento = ({item}: any) => {
        return (
            <Style.ContainerItemOrder 
                style={[Style.styleSheet.shadow, {backgroundColor: 'rgba(66, 106, 208, 0.2)'}]}
                onPress={() => handleOrcamento(item)}
                activeOpacity={0.4}
            >
                <Style.HeaderItemOrder>
                    <Style.CodigoOrder>{item.numorc}</Style.CodigoOrder>

                    <Style.DateOrderContainer>
                        <Style.TextDateOrder color={colors.primary}>
                            {'Emissão: '}
                        </Style.TextDateOrder>

                        <Style.TextDateOrder color={'#000'}>
                            {SToD(item.emission)}
                        </Style.TextDateOrder>
                    </Style.DateOrderContainer>
                </Style.HeaderItemOrder>

                <Style.MiddleTextOrder>
                    <Style.TextClienteMiddle>
                        {item.customer.name}
                    </Style.TextClienteMiddle>
                </Style.MiddleTextOrder>

                <Style.DownTextOrder>
                    <Style.TextStatusMiddle style={{fontSize:20, color:'#000', fontWeight:'bold'}}>
                        Orçamento em digitação
                    </Style.TextStatusMiddle>
                </Style.DownTextOrder>
                
            </Style.ContainerItemOrder>
        )
    }

    return(<>
        <SafeAreaView 
            edges={["top"]}
            style={{ flex: 0, backgroundColor: colors.primary }}
        />
        <Style.SafeContainer>
            <Style.HeaderComponent>
                <Style.HeaderContainer>
                    <Style.SearchComponent>
                        <Style.InputField
                            autoCorrect={false}
                            placeholder='Pesquisar'
                            value={searchQuery}
                            onChangeText={handleSearch}
                        />
                        <AntDesign name="search1" size={20} color="#A0A0A0" />
                    </Style.SearchComponent>
                    
                    <Style.ButtonFilter 
                        onPress={() => handlePopup(null)}
                        activeOpacity={0.4}
                    >
                        <MaterialCommunityIcons name="order-alphabetical-ascending" size={30} color="white" />
                    </Style.ButtonFilter>
                </Style.HeaderContainer>
            </Style.HeaderComponent>
            
            { !isOnline &&
                <Style.TextOffLine>
                    offline
                </Style.TextOffLine>
            }

            <Style.ContainerList>
                <FlatList
                    data={orders}
                    showsVerticalScrollIndicator={false}
                    keyExtractor={item => item.id}
                    renderItem={({item}) => (
                        <>
                            {item.orcamento === 'N'
                                ? <Order item={item} />
                                : <Orcamento item={item} />
                            }
                        </>
                    )}
                    ListFooterComponent={renderFooter}
                    onEndReached={handleLoadMore}
                    onEndReachedThreshold={0.5}
                    ListEmptyComponent={
                        <Style.EmptyListContProd>
                            { isLoadBottom ?
                                <>
                                    <LottieView
                                        autoPlay
                                        loop
                                        ref={animation}
                                        style={{width: 150, height:150}}
                                        source={require('../../assets/search.json')}
                                    />
                                    <Style.EmptyListTextProd>Buscando pedidos...</Style.EmptyListTextProd>
                                </>
                                :
                                <>
                                    <LottieView
                                        autoPlay
                                        loop
                                        ref={animation}
                                        style={{width: 150, height:150}}
                                        source={require('../../assets/emptyList.json')}
                                    />
                                    <Style.EmptyListTextProd>Nenhum pedido encontrado.</Style.EmptyListTextProd>
                                </>
                            }
                        </Style.EmptyListContProd>
                    }
                />
            </Style.ContainerList>
            
            { !disableFooter && <Footer buttomAdd={true} /> }
        </Style.SafeContainer>

        <ModalOrder 
            getVisible={visibleModal}
            handleModal={handleModal}
            itemModal={itemModal}
        />

        <Popups 
            getVisible={visiblePopup}
            handlePopup={handlePopup}
            type='filterOrder'
            filter={filter}
            message=''
        />

        <PopupsCopyOrder 
            getVisible={visiblePopupCopy}
            handlePopup={handlePopupCopy}
            load={isLoadCopy}
        />
    </>)
}