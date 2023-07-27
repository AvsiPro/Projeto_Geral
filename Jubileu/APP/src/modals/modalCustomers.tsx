import React, { useState, useEffect, useContext, useRef } from 'react';
import * as Style from './styles';
import { Modal, TouchableWithoutFeedback, Keyboard, Platform, TextInput, ActivityIndicator } from 'react-native';

import { FontAwesome, AntDesign } from '@expo/vector-icons';

import NetInfo from "@react-native-community/netinfo";

import Customers from '../components/customers';
import UpdateCustomer  from '../components/updateCustomer';
import Financial from '../components/financial';

import { PropsCostumersModal, FormDataCustomer } from '../interfaces';
import { AppContext, ThemeContext } from '../contexts/globalContext';
import { ScrollView } from 'react-native';

import * as yup from "yup";
import { yupResolver } from '@hookform/resolvers/yup';
import { useForm } from 'react-hook-form';
import { apiCustomers, searchCustomers, storageCustomers } from '../services/apiCustomers';
import Popups from './popups';

const schema = yup.object({
    email: yup.string().email("E-mail inválido").required("Informe o e-mail"),
    address: yup.string().required("Informe o endereço"),
    cep: yup.string().required("Informe o CEP"),
    district: yup.string().required("Informe o bairro"),
    city: yup.string().required("Informe a cidade"),
    uf: yup.string().required("Informe a UF"),
    contact: yup.string().required("Informe o contato"),
    phone: yup.string().required("Informe o telefone"),
});

export default function modalCustomers({getVisible, handleModalCustomers, customers, atualizaClientes, handleContinuaOrc} : PropsCostumersModal){
    
    const { customerSelected ,setCustomerSelected } = useContext(AppContext);
    const { colors } = useContext(ThemeContext);
    const searchInputRef = useRef<TextInput>(null);

    const { authDetail } = useContext(AppContext);
    
    const [searchQuery, setSearchQuery] = useState<string>('');
    const [isLoading, setIsLoading] = useState<boolean>(false);
    const [page, setPage] = useState(1);
    const [isOnline, setIsOnline] = useState(true);
    const [updateCustomer, setUpdateCustomer] = useState(false);
    const [financial, setFinancial] = useState(false);
    const [financialCustomer, setFinancialCustomer] = useState('')
    const [visiblePopup, setVisiblePopup] = useState(false)
    const [viewTitle, setViwTitle] = useState(false);
    const [message, setMessage] = useState<string>('');
    const [typeMessage, setTypeMessage] = useState<string>('');

    const [search, setSearch] = useState<boolean>(false);
    const [isLoadSearch, setLoadSearch] = useState<boolean>(false);

    const { control, handleSubmit, formState: { errors }, reset, setValue } = useForm<FormDataCustomer>({
        resolver: yupResolver(schema)
    });


    /** verifica se esta online ou offline **/
    useEffect(() => {
        const unsubscribe = NetInfo.addEventListener((state: any) => {
            setIsOnline(state.isConnected);
        });
      
        return () => {
            unsubscribe();
        };
    }, []);


    /** verifica se esta online. Se tiver, chama a API com clientes, se nao, chama os clientes que estao salvos no storage **/
    useEffect(() => {
        setSearch(false)
        setSearchQuery('')

        if(isOnline){
            loadItems();
        }else {
            fetchAsyncStorage();
        }
    }, []);


    /** faz a chamada da api com paginacao, grava no estado de cliente e no storage (online) **/
    const loadItems = async () => {
        setIsLoading(true);

        const resultApi = await apiCustomers(page, customers, 1, authDetail.token)
        
        if(!!resultApi){
            atualizaClientes(resultApi.returnResult)
            setPage(resultApi.pageResult)
        }
        
        setIsLoading(false);
    };


    /** faz a chamada no storage e grava no estado de clientes (offline) **/
    const fetchAsyncStorage = async () => {
        setIsLoading(true);
        
        const resultApi = await storageCustomers(1)
        
        if(!!resultApi){
            atualizaClientes(resultApi.returnResult)
            setPage(resultApi.pageResult)
        }

        setIsLoading(false);
    };

    
    /** ao chegar no final da lista, verifica se esta online para chamada da proxima pagina da API **/
    const handleLoadMore = () => {
        if (!isLoading && !searchQuery && isOnline) {
          loadItems();
        }
    };


    /** verifica se possui titulo **/
    const handleItem = (item: any) => {

        if(!item.allowed_region){
            setTypeMessage('error')
            setMessage('Cliente não cadastrado em sua região')
            setVisiblePopup(true)

        }else{
            if(item.financial.length > 0) {
                setTypeMessage('error')
                setMessage('Cliente possui títulos em aberto')
                setVisiblePopup(true)

                setFinancialCustomer(item)
                handleFinancial()
    
            } else{
                setCustomer(item)
            }
        }
    }

    /** Seta o cliente selecionado **/
    const setCustomer = (item: any) => {
        reset()
        setValue('name', item.name)
        setValue('short_name', item.short_name)
        setValue('cnpj', item.cnpj)
        setValue('email', item.email)
        setValue('address', item.address)
        setValue('complement', item.complement)
        setValue('cep', item.cep)
        setValue('district', item.district)
        setValue('city', item.city)
        setValue('uf', item.uf)
        setValue('contact', item.contact)
        setValue('phone', item.phone)
        setValue('another_address', item.another_address)
        setValue('another_cep', item.another_cep)
        setValue('another_district', item.another_district)

        setCustomerSelected(item)
        setUpdateCustomer(true) 
    }

    
    /** Botao de atualizar cadastro, faz a comparacao com o cliente da context e atualiza com o preenchimento do formulario **/
    const handleUserRegister = (data: FormDataCustomer) => {
        const updateCustomer = Object.assign({}, customerSelected, data);

        setCustomerSelected(updateCustomer);
        setUpdateCustomer(false)
        handleModalCustomers()
    }
    

    /** Botao cancelar cadastro, fecha o modal de clientes e limpa a o cliente selecionado (forca atualizar o cadastro) **/
    const handleCloseCancel = () => {
        handleModalCustomers()
        setCustomerSelected(null)
        setUpdateCustomer(false)
        handleContinuaOrc()
        setFinancial(false)
    }


    const handleFinancial = () => {
        setFinancial(!financial)
    }


    const handleCustomerFinancial = (item: any) => {
        setViwTitle(false)
        setFinancialCustomer(item)
        handleFinancial()
    }


    const handleSearchButton = async() => {
        setLoadSearch(true);
        Keyboard.dismiss();

        if(!searchQuery){
            setLoadSearch(false)
            handleClearSearch();
            return
        }

        const resultApi = await searchCustomers(searchQuery, isOnline, authDetail.token)

        if(!!resultApi){
            atualizaClientes(resultApi.returnResult)
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

    const handleContinue = () => {
        handleContinuaOrc()
        setCustomer(financialCustomer)
    }

    return(
    
        <Modal 
            transparent
            visible={getVisible}
            animationType='slide'
        >
            <Style.SafeAreaModals>
                <TouchableWithoutFeedback onPress={Keyboard.dismiss}>
                    <Style.KeyBoardFormCustomer
                        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
                        style={Style.styleSheet.shadow}
                        enabled
                    >
                        <Style.ModalOrderContainer>
                            { !updateCustomer && !financial &&
                                <Style.TopModalNewOrder>
                                    <Style.ContainerSearchModal>
                                        <Style.SearchNewOrderModal
                                            ref={searchInputRef}
                                            keyboardType='email-address'
                                            autoCapitalize='none'
                                            placeholder='Pesquisar'
                                            returnKeyType="done"
                                            autoCorrect={false}
                                            onChangeText={setSearchQuery}
                                            onSubmitEditing={handleSearchButton}
                                            value={searchQuery}
                                            editable={!isLoadSearch}
                                        />

                                        <Style.ButtonSearch onPress={() => handleSearchButton()}>
                                            { isLoadSearch
                                                ? <ActivityIndicator color={colors.primary} />
                                                : <AntDesign name="search1" size={20} color={colors.primary} />
                                            }
                                            
                                        </Style.ButtonSearch>
                                    </Style.ContainerSearchModal>
                                    
                                    <Style.ButtonCloseModal
                                        onPress={handleModalCustomers}
                                        activeOpacity={0.4}
                                    >
                                        <FontAwesome name="close" size={30} color="black" />
                                    </Style.ButtonCloseModal>
                                </Style.TopModalNewOrder>
                            }
                            
                            { !isOnline &&
                                <Style.TextDisconnected>offline</Style.TextDisconnected>
                            }

                            <Style.MiddleModalNewOrder>
                                {updateCustomer ?
                                    <Style.containerFormModal animation="fadeInUp">
                                        <ScrollView>
                                            <UpdateCustomer
                                                formSchema={{ 
                                                    control: control,
                                                    handleSubmit: handleSubmit,
                                                    errors: errors 
                                                }}
                                            />
                                        </ScrollView>
                                        
                                        <Style.ContainerButtonSubmit>
                                            <Style.ButtomSubmitLeft
                                                onPress={handleCloseCancel}
                                            >
                                                <Style.ButtomSubmitTitle color='tomato'>
                                                    Cancelar
                                                </Style.ButtomSubmitTitle>
                                            </Style.ButtomSubmitLeft>
                                                                                    
                                            <Style.ButtomSubmitRight
                                                onPress={handleSubmit(handleUserRegister)}
                                            >
                                                <Style.ButtomSubmitTitle color='white'>
                                                    Atualizar cadastro
                                                </Style.ButtomSubmitTitle>
                                            </Style.ButtomSubmitRight>
                                        </Style.ContainerButtonSubmit>
                                    </Style.containerFormModal>
                                :
                                    
                                    !financial ?
                                        <>
                                            { search &&
                                                <Style.ContainerBadgeSearch>
                                                    <Style.BadgeSearch onPress={handleClearSearch}>
                                                        <Style.IconBadgeSearch name="close" />
                                                        <Style.TextBadgeSearch color='#fff'>{searchQuery}</Style.TextBadgeSearch>
                                                    </Style.BadgeSearch>
                                                </Style.ContainerBadgeSearch>
                                            }
                                        
                                            <Customers
                                                customers={customers}
                                                handleLoadMore={handleLoadMore}
                                                handleItem={handleItem}
                                                handleCustomerFinancial={handleCustomerFinancial}
                                                isLoading={isLoading}
                                                isOnline={isOnline}
                                            />
                                        </>
                                    :
                                    
                                        <Financial
                                            customer={financialCustomer}
                                            handleFinancial={handleFinancial}
                                            order={true}
                                            handleContinue={handleContinue}
                                            viewTitle={viewTitle}
                                        />

                                }
                            
                            </Style.MiddleModalNewOrder>
                        </Style.ModalOrderContainer>
                    </Style.KeyBoardFormCustomer>
                </TouchableWithoutFeedback>
            </Style.SafeAreaModals>

            <Popups 
                getVisible={visiblePopup}
                handlePopup={() => setVisiblePopup(!visiblePopup)}
                type={typeMessage}
                filter={null}
                message={message}
            />
        </Modal>

    )
}