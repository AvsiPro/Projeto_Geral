import React, { useState, useEffect, useContext, useRef } from 'react';
import * as Style from './styles';
import { ActivityIndicator, Keyboard, Modal, TextInput } from 'react-native';

import { FontAwesome, AntDesign, Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';

import NetInfo from "@react-native-community/netinfo";

import Products from '../components/products';

import api from '../services/api';

import { apiProducts, storageProducts, searchProducts } from '../services/apiProducts';

import { PropItemCartContext, ApiResponse, PropsProductsModal } from '../interfaces';
import { AppContext, ThemeContext } from '../contexts/globalContext';

import { CameraType } from 'expo-camera';
import ModalProdDetail from './modalProdDetail';


export default function modalProducts({getVisible, handleModalProducts, products, atualizaProdutos} : PropsProductsModal){
    
    const { itemCart, setItemCart, tablePriceSelected } = useContext(AppContext);
    const { colors } = useContext(ThemeContext);
    const searchInputRef = useRef<TextInput>(null);
    const inputBarCodeRef = useRef<TextInput>(null);
    
    const [searchQuery, setSearchQuery] = useState<string>('');
    const [inputBarCode, setInputBarCode] = useState<string>('');
    const [markedCount, setMarkedCount] = useState<number>(0);
    const [isLoadTop, setLoadTop] = useState<boolean>(false);
    const [isLoadBottom, setLoadBottom] = useState<boolean>(false);
    const [page, setPage] = useState<number>(1);
    const [isOnline, setIsOnline] = useState<boolean>(true);
    const [productDetails, setProductDetails] = useState<any>(null);
    const [showModal, setShowModal] = useState<boolean>(false);

    const [scanned, setScanned] = useState<boolean>(false);
    const [hasCamera, setHasCamera] = useState<boolean>(false);
    const [hasBar, setHasBar] = useState<boolean>(false);

    const [isLoadSearch, setLoadSearch] = useState<boolean>(false);
    const [search, setSearch] = useState<boolean>(false);

    const [itemsBarScanned, setItemsBarScanned] = useState<any>([]);


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
        setInputBarCode('')

        if(isOnline){
            loadItems();

        }else {
            fetchAsyncStorage();
        }
    }, []);


    /** faz a chamada da api com paginacao, grava no estado de produtos e no storage (online) **/
    const loadItems = async() => {
        setLoadBottom(true);
        const resultApi = await apiProducts(page, products, 1, tablePriceSelected)
        
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

    /** conforme for selecionando os produtos, vai atualizando o item marked de cada objeto do json, para controle de marcacao.
        atualiza tambem a state de count para marcar quantos selecionados
    **/
    const handleItem = (index: number) => {
        const auxData = [...products];

        if(auxData[index].balance < 1){

            return auxData
        }

        atualizaProdutos((prevState: any) => {
            const newData = [...prevState];
            const markAux = !newData[index].marked

            newData[index] = {
                ...newData[index],
                marked: markAux,
                selected_quantity: markAux ? 1 : 0
            };

            
            if(hasBar){
                let auxItem: any[] = [];

                const itemSalva = [...itemsBarScanned, ...newData];
        
                const uniqueArray = itemSalva.reduce((acc, current) => {
                    const x = acc.find((item: { id: any; }) => item.id === current.id);
                    return !x ? acc.concat([current]) : acc;
                }, []);

                uniqueArray.forEach((item: PropItemCartContext) => {
                    if (item.marked) {
                        item.selected_quantity = 1
                        auxItem.push(item);
                    }
                });

                handleFocusTextInput();
                setItemsBarScanned(auxItem);
            }

            return newData;
        });

        setMarkedCount(prevCount => {
            return products[index].marked 
                ? prevCount - 1 
                : prevCount + 1;
        });
    };


    /** reseta todo o array marcando todos os marked como false e zera o contador **/
    const resetMarked = (clear?: boolean) => {
        const newData = products.map((item: { marked: boolean, selected_quantity: number }) => {
            item.marked = false,
            item.selected_quantity = clear ? 0 : item.selected_quantity
            return item;
        });

        setItemsBarScanned([]);
        setInputBarCode('')
        atualizaProdutos(newData);
        setMarkedCount(0);
    };


    /** responsavel por adicionar os itens selecionados no carrinho da context **/
    const handleAddItens = () => {
        let close = false
        let auxItem: PropItemCartContext[] = []
    
        products.forEach((item: PropItemCartContext) => {
            if (item.marked) {
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
            resetMarked(false)
            handleModalProducts()
        }
    }

    
    const handleHasCamera = () => {
        setHasCamera(!hasCamera)
        setHasBar(false)
        setInputBarCode('')
    }


    const handleQRCodeScanned = async({ type, data }: any) => {

        setScanned(true);
        setLoadTop(true);
        
        const find = findProductIndexByCode(products,data)
        
        if (find !== null){
            if(!products[find].marked){
                handleItem(find)
            }

            setTimeout(() => {
                setScanned(false);
            }, 1000);

        }else{
            const response = await api.get(`/WSAPP03?pagesize=10&page=1&byId=true&searchKey=${data}&codTab=${tablePriceSelected}`);
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


    const handleBarCodeScanned = async() => {

        if(!inputBarCode){
            return;
        }

        setLoadTop(true);
        
        const find = findProductIndexByCode(products,inputBarCode)
        
        if (find !== null){
            if(!products[find].marked){
                handleItem(find)
            }
        }else{
            const response = await api.get(`/WSAPP03?pagesize=10&page=1&byId=true&searchKey=${inputBarCode}&codTab=${tablePriceSelected}`);
            const json: ApiResponse = response.data;

            if(json.status.code === '#200'){
                json.result[0].marked = true

                const itemSalva = [...products, ...json.result];
        
                const uniqueArray = itemSalva.reduce((acc, current) => {
                    const x = acc.find((item: { id: any; }) => item.id === current.id);
                    return !x ? acc.concat([current]) : acc;
                }, []);


                const itemBarAux = [...itemsBarScanned, ...uniqueArray];

                const uniqueBar = itemBarAux.reduce((acc: any[], current: any) => {
                    const index = acc.findIndex((item: { id: any; marked: boolean }) => item.id === current.id);
                  
                    if (index === -1) {
                      // O objeto não existe no acumulador, então o adicionamos
                      return [...acc, current];
                    } else {
                      // O objeto já existe no acumulador
                      if (acc[index].marked) {
                        // O objeto existente tem marked como true, então o mantemos e não fazemos alterações
                        return acc;
                      } else if (current.marked) {
                        // O objeto atual tem marked como true, então substituímos o objeto existente pelo objeto atual
                        const updatedArray = [...acc];
                        updatedArray[index] = current;
                        return updatedArray;
                      } else {
                        // Ambos os objetos têm marked como false, então não fazemos alterações
                        return acc;
                      }
                    }
                  }, []);


                let auxItem: any[] = [];

                uniqueBar.forEach((item: PropItemCartContext) => {
                    if (item.marked) {
                        item.selected_quantity = 1
                        auxItem.push(item);
                    }
                });

                handleFocusTextInput();
                setItemsBarScanned(auxItem);

                atualizaProdutos(uniqueArray);
                setMarkedCount(markedCount+1);
            }
        }

        setLoadTop(false)
    }
    


    const HandleBarScan = async() => {
        setHasBar(!hasBar);
        setHasCamera(false);
    }

    const findProductIndexByCode = (prod: any, codeToFind: string): number | null =>{
        const foundProductIndex = prod.findIndex((product: any) => product.code === codeToFind);
        return foundProductIndex !== -1 ? foundProductIndex : null;
    }


    const handleLongItem = (index: number) => {
        const newData = [...products];

        setShowModal(true);
        setProductDetails(newData[index])
    }


    const handleSearchButton = async() => {
        setLoadSearch(true);
        Keyboard.dismiss();

        if(!searchQuery){
            setLoadSearch(false)
            handleClearSearch();
            return
        }

        const resultApi = await searchProducts(searchQuery, isOnline, tablePriceSelected)

        if(!!resultApi){

            let auxItem: PropItemCartContext[] = [...resultApi.returnResult]
    
            products.forEach((item: PropItemCartContext) => {
                if (item.marked) {
                    auxItem.push(item);
                }
            });

            const uniqueArray = auxItem.reduce((acc: any[], current: any) => {
                const index = acc.findIndex((item: { id: any; marked: boolean }) => item.id === current.id);
              
                if (index === -1) {
                  // O objeto não existe no acumulador, então o adicionamos
                  return [...acc, current];
                } else {
                  // O objeto já existe no acumulador
                  if (acc[index].marked) {
                    // O objeto existente tem marked como true, então o mantemos e não fazemos alterações
                    return acc;
                  } else if (current.marked) {
                    // O objeto atual tem marked como true, então substituímos o objeto existente pelo objeto atual
                    const updatedArray = [...acc];
                    updatedArray[index] = current;
                    return updatedArray;
                  } else {
                    // Ambos os objetos têm marked como false, então não fazemos alterações
                    return acc;
                  }
                }
              }, []);

            atualizaProdutos(uniqueArray)
            setPage(resultApi.pageResult)
            setSearch(true)
        }
        
        setLoadSearch(false);
    }
    

    const handleClearSearch = async() => {
        setSearch(false)
        setSearchQuery('')
        setInputBarCode('')
        setPage(1)
        setItemsBarScanned([])

        if(isOnline){
            await loadItems();

        }else {
            fetchAsyncStorage();
        }  
    }

    const handleFocusTextInput = () => {
        setInputBarCode('');
        inputBarCodeRef.current?.focus();
    };


    const handleMinus = (item: any) => {
        const index = products.findIndex((product: any) => product.id === item.id);
      
        if (index !== -1) {
          const updatedProducts = [...products]; // Cria uma cópia do array products
          const updatedItem = { ...updatedProducts[index] }; // Cria uma cópia do objeto item dentro do array

          if(updatedItem.selected_quantity === 1){
            setMarkedCount(markedCount - 1);
          }
      
          // Verifica se selected_quantity é maior que 0 antes de subtrair 1
          if (updatedItem.selected_quantity > 0) {
            updatedItem.selected_quantity -= 1;
          }
      
          // Verifica se selected_quantity chegou a 0
          if (updatedItem.selected_quantity === 0) {
            updatedItem.marked = false; // Define marked como false
          }
      
          updatedProducts[index] = updatedItem; // Substitui o objeto atualizado no array

          atualizaProdutos(updatedProducts); // Atualiza o estado com o novo array de produtos
        }
    };
      


    const handleMore = (item: any) => {
        const index = products.findIndex((product: any) => product.id === item.id);
      
        if (index !== -1) {
            const updatedProducts = [...products]; // Cria uma cópia do array products
            const updatedItem = { ...updatedProducts[index] }; // Cria uma cópia do objeto item dentro do array

            if(updatedItem.balance >= updatedItem.selected_quantity + 1){
                if(updatedItem.selected_quantity === 0){
                    setMarkedCount(markedCount + 1);
                }
            
                // Realize as alterações necessárias no updatedItem
                updatedItem.marked = true;
                updatedItem.selected_quantity += 1;
    
                updatedProducts[index] = updatedItem; // Substitui o objeto atualizado no array
            
                atualizaProdutos(updatedProducts); // Atualiza o estado com o novo array de produtos
            }

        }
    };
    
    return(
        <Modal 
            transparent
            visible={getVisible}
            animationType='slide'
        >
            <Style.SafeAreaModals>
                <Style.ModalOrderContainer style={Style.styleSheet.shadow}>
                    
                    {!hasCamera && !hasBar &&
                    
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
                                    editable={!isLoadSearch}
                                />

                                <Style.ButtonSearch onPress={() => handleSearchButton()}>
                                    { isLoadSearch
                                        ? <ActivityIndicator color={colors.primary} />
                                        : <AntDesign name="search1" size={23} color={colors.primary} />
                                    }
                                </Style.ButtonSearch>
                            </Style.ContainerSearchModal>
                            
                            { markedCount > 0 ? 
                                <Style.ButtomCancelSelect
                                    onPress={() => resetMarked(true)}
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
                    }
                    
                    { !isOnline &&
                        <Style.TextDisconnected>offline</Style.TextDisconnected>
                    }

                    <Style.MiddleModalNewOrder>

                        { hasCamera &&
                            <Style.ComponentQRCode>
                                <Style.QRCodeScan
                                    type={CameraType.back}
                                    onBarCodeScanned={scanned ? undefined : handleQRCodeScanned}
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

                        { hasBar &&
                            <Style.BarCodeComponent>
                                <Style.TopBarCodeScan>
                                    <Style.BarCodetext>
                                        BarCode Scan
                                    </Style.BarCodetext>

                                    { markedCount > 0 ? 
                                        <Style.ButtomCancelSelect
                                            onPress={() => resetMarked(true)}
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
                                </Style.TopBarCodeScan>

                                <Style.BarCodeInput
                                    keyboardType='email-address'
                                    ref={inputBarCodeRef}
                                    autoCorrect={false}
                                    value={inputBarCode}
                                    autoCapitalize='none'   
                                    onChangeText={setInputBarCode}
                                    onSubmitEditing={handleBarCodeScanned}
                                />

                                <Style.ButtonBarCodeMore
                                    onPress={handleFocusTextInput}
                                    activeOpacity={0.4}
                                >
                                    <Style.TextFooterOrder color='#fff'>
                                        Ler código de barras
                                    </Style.TextFooterOrder>
                                </Style.ButtonBarCodeMore>

                                { isLoadTop && 
                                    <Style.LoadingContent>
                                        <ActivityIndicator animating size="large" color={'#000'} />
                                    </Style.LoadingContent>
                                }

                            </Style.BarCodeComponent>
                        }
                        
                        <Style.ComponentProductModal>
                            { search &&
                                <Style.ContainerBadgeSearch>
                                    <Style.BadgeSearch onPress={handleClearSearch}>
                                        <Style.IconBadgeSearch name="close" />
                                        <Style.TextBadgeSearch color='#fff'>{searchQuery}</Style.TextBadgeSearch>
                                    </Style.BadgeSearch>
                                </Style.ContainerBadgeSearch>
                            }
                            
                            <Products
                                products={hasBar ? itemsBarScanned : products}
                                handleLoadMore={handleLoadMore}
                                handleItem={handleItem}
                                handleLongItem={handleLongItem}
                                isLoadBottom={isLoadBottom}
                                isOnline={isOnline}
                                isOrder={true}
                                hasBar={hasBar}
                                handleMinus={(item: any) => handleMinus(item)}
                                handleMore={(item: any) => handleMore(item)}
                            />
                        </Style.ComponentProductModal>
                    </Style.MiddleModalNewOrder>

                    <Style.BottomModalNewOrder>

                        <Style.TotalsFooterOrder mt={20}>
                            <Style.ButtonQrCode
                                onPress={handleHasCamera}
                                activeOpacity={0.4}
                            >
                                <Ionicons name={!hasCamera ? "qr-code" : "close"} size={24} color="#fff" />
                            </Style.ButtonQrCode>

                            <Style.ButtonBarCode
                                onPress={HandleBarScan}
                                activeOpacity={0.4}
                            >
                                {!hasBar
                                    ? <MaterialCommunityIcons name={"barcode-scan"} size={24} color="#fff" />
                                    : <Ionicons name={"close"} size={24} color="#fff" />
                                }
                            </Style.ButtonBarCode>

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

            <ModalProdDetail
                getVisible={showModal}
                handleModalProducts={() => setShowModal(!showModal)}
                products={productDetails}
            />
        </Modal>
    )
}