import React, { useState, useEffect, useContext } from 'react';
import { Keyboard, TouchableOpacity, Text, ScrollView, Modal, Platform } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { AntDesign, MaterialCommunityIcons } from '@expo/vector-icons';
import * as Style from './styles';

import Footer from '../../components/footer';
import Popups from '../../modals/popups';
import CustomersComponent from '../../components/customers';

import { apiCustomers, searchCustomers, storageCustomers, sortCustomerList } from '../../services/apiCustomers';

import NetInfo from "@react-native-community/netinfo";
import debounce from 'lodash/debounce';
import { AppContext, ThemeContext } from '../../contexts/globalContext';

import * as yup from "yup";
import { yupResolver } from '@hookform/resolvers/yup';
import { useForm } from 'react-hook-form';
import { FormDataCustomer } from '../../interfaces';

import UpdateCustomer from '../../components/updateCustomer';
import Financial from '../../components/financial';
import api from '../../services/api';


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


export default function Customers(){

    const { colors } = useContext(ThemeContext);
    const { authDetail } = useContext(AppContext);

    const [showModal, setShowModal] = useState(false)
    const [visiblePopup, setVisiblePopup] = useState(false)
    const [filter, setFilter] = useState(1)
    const [disableFooter, setDisableFooter] = useState(false)
    const [isOnline, setIsOnline] = useState(true);
    const [customers, setCustomers] = useState<any>([]);
    const [searchQuery, setSearchQuery] = useState<string>('');
    const [isLoading, setIsLoading] = useState<boolean>(false);
    const [page, setPage] = useState(1);
    const [financialCustomer, setFinancialCustomer] = useState('')
    const [financial, setFinancial] = useState(false);
    const [visiblePopupCust, setVisiblePopupCust] = useState<boolean>(false);
    const [message, setMessage] = useState<string>('');
    const [typeMessage, setTypeMessage] = useState<string>('');

    const { control, handleSubmit, formState: { errors }, reset, setValue } = useForm<FormDataCustomer>({
        resolver: yupResolver(schema)
    });

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


    const handlePopup = (index: any) =>{
        setVisiblePopup(!visiblePopup)
        
        if(!!index){
            setFilter(index)

            const listAux = sortCustomerList(index, customers)
            setCustomers(listAux)
        }
    }

    /** verifica se esta online. Se tiver, chama a API com clientes, se nao, chama os clientes que estao salvos no storage **/
    useEffect(() => {
        if(isOnline){
            loadItems();
        }else {
            fetchAsyncStorage();
        }
    }, []);


    const loadItems = async() => {
        setIsLoading(true);
        
        const resultApi: any = await apiCustomers(page, customers, filter)
        
        if(!!resultApi){
            setCustomers(resultApi.returnResult)
            setPage(resultApi.pageResult)
        }
        setIsLoading(false);
    }


    /** faz a chamada no storage e grava no estado de clientes (offline) **/
    const fetchAsyncStorage = async () => {
        setIsLoading(true);
        
        const resultApi = await storageCustomers(filter)
        
        if(!!resultApi){
            setCustomers(resultApi.returnResult)
            setPage(resultApi.pageResult)
        }

        setIsLoading(false);
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
        setIsLoading(true);

        const resultApi = await searchCustomers(searchQuery, isOnline)
        
        if(!!resultApi){
            setCustomers(resultApi.returnResult)
            setPage(resultApi.pageResult)
        }
        
        setIsLoading(false);
    }, 500);


    /** ao chegar no final da lista, verifica se esta online para chamada da proxima pagina da API **/
    const handleLoadMore = () => {
        if (!isLoading && !searchQuery && isOnline) {
            loadItems();
        }
    };


    /** Seta o cliente selecionado **/
    const handleItem = (item: any) => {
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
        
        setShowModal(true)
    }


    const handleFinancial = () => {
        setFinancial(!financial)
        setShowModal(!showModal)
    }


    const handleCustomerFinancial = (item: any) => {
        setFinancialCustomer(item)
        handleFinancial()
    }

    /** Botao de atualizar cadastro, faz a comparacao com o cliente da context e atualiza com o preenchimento do formulario **/
    const handleUserRegister = async(data: FormDataCustomer) => {
        data.token = authDetail.token
        await apiUpdateCustomer(data)
        setShowModal(false)
    }

    
    /** api para atualizacao de cadastro **/
    const apiUpdateCustomer = async(data: any) => {
        try{
            const response = await api.post("/WSAPP13", data);
            const receive = response.data;

            if (receive.status.code === '#200') {
                setCustomers([])
                setSearchQuery('')
                setPage(1)
                
                setTypeMessage('success')
                setMessage(receive.status.message)
                setVisiblePopupCust(true)

            } else {
                setTypeMessage('danger')
                setMessage(receive.status.message)
                setVisiblePopupCust(true)
            }
        
        } catch(error){
            setTypeMessage('danger')
            setMessage('Erro na comunicação com o servidor, contate um administrador')
            setVisiblePopupCust(true)
        }
    }


    /** Botao cancelar cadastro, fecha o modal de clientes e limpa a o cliente selecionado (forca atualizar o cadastro) **/
    const handleCloseCancel = () => {
        setShowModal(false)
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
                            onChangeText={handleSearch}
                            value={searchQuery}
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

            <Style.ContainerListCustomers>
                <CustomersComponent
                    customers={customers}
                    handleLoadMore={handleLoadMore}
                    handleItem={handleItem}
                    isLoading={isLoading}
                    isOnline={isOnline}
                    handleCustomerFinancial={handleCustomerFinancial}
                />
            </Style.ContainerListCustomers>
            
            { !disableFooter && <Footer buttomAdd={false} /> }
        </Style.SafeContainer>

        <Modal 
            transparent
            visible={showModal}
            animationType='slide'
        >
            <Style.SafeAreaModals>
                <Style.KeyBoardFormCustomer
                    behavior={Platform.OS === 'ios' ? 'padding' : undefined}
                    style={Style.styleSheet.shadow}
                    enabled
                >

                    <Style.ModalOrderContainer>
                        <Style.containerFormModal animation="fadeInUp">
                            <ScrollView>
                            { financial ?
                                <Financial
                                    customer={financialCustomer}
                                    handleFinancial={handleFinancial}
                                />
                            :
                                <Style.containerFormModal1>
                                    <UpdateCustomer
                                        formSchema={{ 
                                            control: control,
                                            handleSubmit: handleSubmit,
                                            errors: errors 
                                        }}
                                    />

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
                                    
                                </Style.containerFormModal1>
                            }
                            </ScrollView>
                        
                        </Style.containerFormModal>
                    </Style.ModalOrderContainer>
                    
                    
                </Style.KeyBoardFormCustomer>
            </Style.SafeAreaModals>
        </Modal>

        <Popups 
            getVisible={visiblePopup}
            handlePopup={handlePopup}
            type={'filterCustomers'}
            filter={filter}
            message=''
        />

        <Popups 
            getVisible={visiblePopupCust}
            handlePopup={() => setVisiblePopupCust(false)}
            type={typeMessage}
            filter={null}
            message={message}
        />
    </>)
}