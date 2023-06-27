import React, { useState, useEffect, useContext, useRef } from 'react';
import { ActivityIndicator, Keyboard, TextInput } from 'react-native';
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
import { ThemeContext } from 'styled-components';

export default function Products(){

    const { colors } = useContext(ThemeContext);
    const searchInputRef = useRef<TextInput>(null);
    
    const [visiblePopup, setVisiblePopup] = useState(false)
    const [filter, setFilter] = useState(1)
    const [disableFooter, setDisableFooter] = useState(false)
    const [isOnline, setIsOnline] = useState(true);
    const [isLoadBottom, setLoadBottom] = useState<boolean>(false);
    const [isLoadSearch, setLoadSearch] = useState<boolean>(false);
    const [products, setProducts] = useState<PropItemCartContext[]>([]);
    const [page, setPage] = useState(1);
    const [searchQuery, setSearchQuery] = useState<string>('');
    const [showModal, setShowModal] = useState<boolean>(false);
    const [productDetails, setProductDetails] = useState<any>(null);
    const [search, setSearch] = useState<boolean>(false);

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
        setSearch(false)
        setSearchQuery('')

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



    const handleSearchButton = async() => {
        setLoadSearch(true);
        Keyboard.dismiss();

        if(!searchQuery){
            setLoadSearch(false)
            handleClearSearch();
            return
        }

        const resultApi = await searchProducts(searchQuery, isOnline)

        if(!!resultApi){
            setProducts(resultApi.returnResult)
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

            <Style.ContainerListProducts>

                { search &&
                    <Style.ContainerBadgeSearch>
                        <Style.BadgeSearch onPress={handleClearSearch}>
                            <Style.IconBadgeSearch name="close" />
                            <Style.TextBadgeSearch color='#fff'>{searchQuery}</Style.TextBadgeSearch>
                        </Style.BadgeSearch>
                    </Style.ContainerBadgeSearch>
                }

                <ProductsComponent
                    products={products}
                    handleLoadMore={handleLoadMore}
                    handleItem={handleItem}
                    handleLongItem={() => {}}
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