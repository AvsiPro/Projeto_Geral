import React, { useState, useEffect, useContext } from 'react';
import { Keyboard } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { AntDesign, MaterialCommunityIcons } from '@expo/vector-icons';
import * as Style from './styles';

import Footer from '../../components/footer';
import Popups from '../../modals/popups';
import ModalProdDetail from '../../modals/modalProdDetail';

import NetInfo from "@react-native-community/netinfo";

import { PropItemCartContext } from '../../interfaces';
import ProductsComponent from '../../components/products';
import { apiProducts, storageProducts, searchProducts, sortProductsList } from '../../services/apiProducts'
import debounce from 'lodash/debounce';
import { ThemeContext } from 'styled-components';

export default function Products(){

    const { colors } = useContext(ThemeContext);
    
    const [visiblePopup, setVisiblePopup] = useState(false)
    const [filter, setFilter] = useState(1)
    const [disableFooter, setDisableFooter] = useState(false)
    const [isOnline, setIsOnline] = useState(true);
    const [isLoadBottom, setLoadBottom] = useState<boolean>(false);
    const [products, setProducts] = useState<PropItemCartContext[]>([]);
    const [page, setPage] = useState(1);
    const [searchQuery, setSearchQuery] = useState<string>('');
    const [showModal, setShowModal] = useState<boolean>(false);
    const [productDetails, setProductDetails] = useState<any>(null);

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


    /** verifica se esta online. Se tiver, chama a API com produtos, se nao, chama os produtos que estao salvos no storage **/
    useEffect(() => {
        if(isOnline){
            loadItems();

        }else {
            fetchAsyncStorage();
        }
    }, []);

    
    const loadItems = async() => {
        setLoadBottom(true);
        
        const resultApi = await apiProducts(page, products, filter)
        
        if(!!resultApi){
            setProducts(resultApi.returnResult)
            setPage(resultApi.pageResult)
        }
        setLoadBottom(false);
    }


    const handlePopup = (index: any) =>{
        setVisiblePopup(!visiblePopup)
        
        if(!!index){
            setFilter(index)

            const listAux = sortProductsList(index, products)
            setProducts(listAux)
        }
    }

    /** faz a chamada no storage e grava no estado de produtos (offline) **/
    const fetchAsyncStorage = async () => {
        setLoadBottom(true);
        
        const resultApi = await storageProducts(filter)
        
        if(!!resultApi){
            setProducts(resultApi.returnResult)
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


    const handleItem = (index: number) => {
        const newData = [...products];

        setShowModal(true);
        setProductDetails(newData[index])
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
            setProducts(resultApi.returnResult)
            setPage(resultApi.pageResult)
        }
        
        setLoadBottom(false);
    }, 500);


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

            <Style.ContainerListProducts>
                <ProductsComponent
                    products={products}
                    handleLoadMore={handleLoadMore}
                    handleItem={handleItem}
                    isLoadBottom={isLoadBottom}
                    isOnline={isOnline}
                    isOrder={false}
                />
            </Style.ContainerListProducts>
            
            { !disableFooter && <Footer buttomAdd={false} /> }
        </Style.SafeContainer>

        <Popups 
            getVisible={visiblePopup}
            handlePopup={handlePopup}
            type={'filterProducts'}
            filter={filter}
            message=''
        />

        <ModalProdDetail
            getVisible={showModal}
            handleModalProducts={() => setShowModal(!showModal)}
            products={productDetails}
        />
    </>)
}