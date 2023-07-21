import React, { useState, useEffect, useContext, useRef } from 'react';
import { ActivityIndicator, FlatList, Keyboard, TextInput, RefreshControl } from 'react-native';
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
    
    const [refreshing, setRefreshing] = useState(false); 
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
    const [isLoadSearch, setLoadSearch] = useState<boolean>(false);
    const [search, setSearch] = useState<boolean>(false);

    const animation = useRef(null);
    const searchInputRef = useRef<TextInput>(null);
    

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
        React.useCallback(() => {
            setSearch(false)
            setSearchQuery('')
    
            if(isOnline){
                loadItems();
    
            }else {
                fetchAsyncStorage();
            }
    
          return () => {
            // Lógica de limpeza, se necessário
          };
        }, [])
      );


    const loadItems = async() => {
        setLoadBottom(true);
        
        const resultApi = await apiOrders(page, orders, filter, authDetail.token)
        
        if(!!resultApi){

            const returnResult = resultApi.returnResult.reduce((acc: any, current: any) => {
                const x = acc.find((item: { id: any; }) => item.id === current.id);
                return !x ? acc.concat([current]) : acc;
            }, []);

            setOrders(returnResult)
            setPage(resultApi.pageResult)
            setRefreshing(false)
        }
        setLoadBottom(false);
    }


    const onRefresh = () => {
        setRefreshing(true);
        handleClearSearch();
    };

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
            let productsCopy: string = ''
            let virgula: string = ''

            itemCopy.items.map(async(itemCart: any) => {
                productsCopy += virgula+"'"+itemCart.product+"'"
                virgula = ','
            })
            
            
            const productAux = await apiProductsCopy(productsCopy)

            const itemCartAux: any[] = productAux.map((itemNovo: any) => {
                const itemOrigem = itemCopy.items.find((item: any) => item.product === itemNovo.code);
                if (itemOrigem && itemNovo.balance > 0) {
                    return {
                        ...itemNovo,
                        marked: true,
                        selected_quantity: itemNovo.balance >= itemOrigem.sold_amount ? itemOrigem.sold_amount : itemNovo.balance,
                    };
                }                
            }).filter(Boolean);
            
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


    const apiProductsCopy = async(products: string) => {

        let returnObject: any = []

        try {
            const response = await api.get(`/WSAPP03?pagesize=100&page=1&copyItems=${products}`);
            const json: ApiResponse = response.data;
        
            if(json.status.code === '#200'){    
                returnObject = [...json.result];
            }
    
        } catch (error) {
            console.error(error);
        }

        return returnObject;  
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

    const handleSearchButton = async() => {
        setLoadSearch(true);
        Keyboard.dismiss();

        if(!searchQuery){
            setLoadSearch(false)
            handleClearSearch();
            return
        }

        const resultApi = await searchOrders(searchQuery, isOnline)

        if(!!resultApi){

            const returnResult = resultApi.returnResult.reduce((acc: any, current: any) => {
                const x = acc.find((item: { id: any; }) => item.id === current.id);
                return !x ? acc.concat([current]) : acc;
            }, []);

            setOrders(returnResult)
            setPage(resultApi.pageResult)
            setSearch(true)
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
                <Style.HeaderContainer1>
                        <Style.SearchComponent1>
                            <Style.InputField1
                                ref={searchInputRef}
                                autoCorrect={false}
                                placeholder='Pesquisar'
                                value={searchQuery}
                                autoCapitalize='none'
                                returnKeyType="done"
                                onChangeText={setSearchQuery}
                                onSubmitEditing={handleSearchButton}
                                editable={!isLoadSearch}
                            />

                            <Style.ButtonSearch onPress={() => handleSearchButton()}>
                                { isLoadSearch
                                    ? <ActivityIndicator color={'#A0A0A0'} />
                                    : <AntDesign name="search1" size={23} color="#A0A0A0" />
                                }
                                
                            </Style.ButtonSearch>
                        </Style.SearchComponent1>
                        
                        <Style.ButtonFilter
                            onPress={() => handlePopup(null)}
                            activeOpacity={0.4}
                        >
                            <MaterialCommunityIcons name="order-alphabetical-ascending" size={30} color="white" />
                        </Style.ButtonFilter>
                    </Style.HeaderContainer1>
            </Style.HeaderComponent>
            
            { !isOnline &&
                <Style.TextOffLine>
                    offline
                </Style.TextOffLine>
            }

            <Style.ContainerList>

                { search &&
                    <Style.ContainerBadgeSearch>
                        <Style.BadgeSearch onPress={handleClearSearch}>
                            <Style.IconBadgeSearch name="close" />
                            <Style.TextBadgeSearch color='#fff'>{searchQuery}</Style.TextBadgeSearch>
                        </Style.BadgeSearch>
                    </Style.ContainerBadgeSearch>
                }
                
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
                    refreshControl={
                        <RefreshControl
                          refreshing={refreshing}
                          onRefresh={onRefresh}
                        />
                    }
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