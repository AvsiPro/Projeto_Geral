import React, { useContext, useState, useRef, useEffect } from 'react';
import { FlatList, View, Platform, Keyboard, Switch } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Entypo, AntDesign, FontAwesome, MaterialIcons } from '@expo/vector-icons';
import * as Style from './styles';
import { useNavigation } from '@react-navigation/native';
import { AppContext, ThemeContext } from '../../contexts/globalContext';
import { CurrencyFormat } from '../../utils/currencyFormat';
import NetInfo from "@react-native-community/netinfo";
import LottieView from 'lottie-react-native'
import { PropItemCartContext } from '../../interfaces';

import ModalObs from '../../modals/modalObs';
import ModalCustomers from '../../modals/modalCustomers';
import ModalProducts from '../../modals/modalProducts';
import ModalPayment from '../../modals/modalPayment';
import Popups from '../../modals/popups';
import api from '../../services/api';

import moment from 'moment';

import AsyncStorage from "@react-native-async-storage/async-storage";

export default function Neworder(){
    const navigation: any = useNavigation();
    const animation = useRef(null);
    
    const { colors } = useContext(ThemeContext);
    const {
        itemCart,
        customerSelected,
        paymentSelected,
        authDetail,
        orcamentoSelected,
        setItemCart,
        setCustomerSelected,
        setPaymentSelected,
        setOrcamentoSelected
    } = useContext(AppContext);

    const [visibleModalProducts, setVisibleModalProducts] = useState(false);
    const [visibleModalCustomers, setVisibleModalCustomers] = useState(false);
    const [visibleModalPayment, setVisibleModalPayment] = useState(false);
    const [visibleModalObs, setVisibleModalObs] = useState(false);
    const [dataItens, setDataItens] = useState<any>([]);
    const [dataCustomers, setDataCustomers] = useState<any>(null);
    const [dataPayment, setDataPayment] = useState<any>(null);
    const [discountInput, setDiscountInput] = useState<string>('');
    const [discountPercent, setDiscountPercent] = useState<number>(0);
    const [products, setProducts] = useState<PropItemCartContext[]>([]);
    const [customers, setCustomers] = useState<any>([]);
    const [payment, setPayment] = useState<any>([]);
    const [keyboardActived, setKeyboardActived] = useState(false);
    const [isOnline, setIsOnline] = useState(true);
    const [visiblePopup, setVisiblePopup] = useState<boolean>(false);
    const [message, setMessage] = useState<string>('');
    const [typeMessage, setTypeMessage] = useState<string>('');
    const [textObs, setTextObs] = useState<string>('');
    const [load, setLoad] = useState<boolean>(false);
    const [continuaOrc, setContinuaOrc] = useState<boolean>(false);
    const [priceRule, setPriceRule] = useState<boolean>(false);

    const toggleSwitch = () => setPriceRule(previousState => !previousState);

    /** verifica se esta online ou offline **/
    useEffect(() => {
        const unsubscribe = NetInfo.addEventListener((state: any) => {
            setIsOnline(state.isConnected);
        });
      
        return () => {
            unsubscribe();
        };
    }, []);   


    /** monitora a abertura do teclado para adequacao de tela na abertura **/
    useEffect(()=>{
        Keyboard.addListener('keyboardDidShow', keyboardDidShow);
        Keyboard.addListener('keyboardDidHide', keyboardDidHide);

    },[]);

    const keyboardDidShow = () => { setKeyboardActived(true) }
    const keyboardDidHide = () => { setKeyboardActived(false) }
    

    /* atualiza o carrinho de acordo com o itemcart da context */
    useEffect(() => {
        const atualizaItensContext = () => {
            setDataItens(itemCart)
            setDataCustomers(customerSelected)
            setDataPayment(paymentSelected)
        }
        atualizaItensContext()
    },[itemCart, customerSelected, paymentSelected])


    /** abrir o modal de produtos e garantir que nao tenha duplicidade de itens **/
    const handleModalProducts = () =>{
        if(products.length > 0){
            const newProducts = products.filter((product) => itemCart.every((item: any) => item.code !== product.code));

            newProducts.sort((a, b) => a.code.localeCompare(b.code));
            
            const uniqueArray = newProducts.reduce((acc: any, current) => {
                const x = acc.find((item: any) => item.code === current.code);
                return !x ? acc.concat([current]) : acc;
            }, []);
            
            setProducts(uniqueArray)
        }

        setVisibleModalProducts(!visibleModalProducts)
    }

    
    /** abrir o modal de clientes **/
    const handleModalCustomers = () =>{

        if(customers.length > 0){
            const newcustomers = customers.filter((customer: any) => itemCart.every((item: any) => item.code !== customer.code));

            newcustomers.sort((a: any, b: any) => a.code.localeCompare(b.code));

            const uniqueArray = newcustomers.reduce((acc: any, current: any) => {
                const x = acc.find((item: any) => item.code === current.code);
                return !x ? acc.concat([current]) : acc;
            }, []);
            
            setCustomers(uniqueArray)
        }

        setVisibleModalCustomers(!visibleModalCustomers)
    }


    /** abrir o modal de condicao de pagamento **/
    const handleModalPayment = () =>{

        if(payment.length > 0){
            const newpayment = payment.filter((customer: any) => itemCart.every((item: any) => item.code !== customer.code));

            newpayment.sort((a: any, b: any) => a.code.localeCompare(b.code));

            const uniqueArray = newpayment.reduce((acc: any, current: any) => {
                const x = acc.find((item: any) => item.code === current.code);
                return !x ? acc.concat([current]) : acc;
            }, []);
            
            setPayment(uniqueArray)
        }

        setVisibleModalPayment(!visibleModalPayment)
    }
    
    
    /** atualiza produtos **/
    const atualizaProdutos = (item: any) => {
        setProducts(item)
    }


    /** atualiza clientes **/
    const atualizaClientes = (item: any) => {
        setCustomers(item)
    }


    /** atualiza clientes **/
    const atualizaPagamentos = (item: any) => {
        setPayment(item)
    }


    /** botao de diminuir item do carrinho, se for zerado sai da lista **/
    const handleMinus = (index: number) => {
        setItemCart((prevState: any) => {
            const newData = [...prevState];
            
            if(newData[index].selected_quantity > 0){
                newData[index] = {
                    ...newData[index],
                    selected_quantity: newData[index].selected_quantity - 1
                };

                if(newData[index].selected_quantity === 0){
                    let itemAux: any = []

                    itemAux.push(newData[index])
                    atualizaProdutos((prevItems: any) => [...prevItems, ...itemAux]);
                    newData.splice(index, 1);
                }
            }
            
            return newData;
        });
    }


    /** botao de aumentar item do carrinho **/
    const handleMore = (index: number) => {

        setItemCart((prevState: any) => {
            const newData = [...prevState];
            
            if(newData[index].balance  >= newData[index].selected_quantity + 1){
                newData[index] = {
                ...newData[index],
                selected_quantity: newData[index].selected_quantity + 1
                };
            }
  
            return newData;
        }); 
    }


    /** responsavel pelo vlr total **/
    const sumValueTotal = (): number => {
        return itemCart.reduce((total: number, item: any) => total + handlePriceRule(item) * item.selected_quantity, 0);
    }


    /** responsavel pela quantidade total **/
    const sumQuantityTotal = (): number => {
        return itemCart.reduce((total: number, item: any) => total + item.selected_quantity, 0);
    }
      

    /** botao de limpar itens do carrinho **/
    const handleClearCart = () => {
        const clonedCart: any = [...itemCart];
      
        clonedCart.forEach((item: any) => {
            item.selected_quantity = 0
            atualizaProdutos((prevItems: any) => [...prevItems, item]);
        });
        
        setContinuaOrc(false);
        setItemCart([]);
        setCustomerSelected(null);
        setPaymentSelected(null);
        setDiscountInput('');
    };


    /** calcula e seta o disconto de acordo com a porcentagem **/
    const sumDiscount = () => {
        let discountValue: number = 0
        const discountAux: number = parseFloat(discountInput.replace(",", "."))

        if(discountAux > 0){
            const vlrTotal = sumValueTotal()
            discountValue = Math.min(((vlrTotal * discountAux) / 100), vlrTotal)
        }

        return discountValue
    }
    

    /** seta o disconto **/
    const handleDiscount = (text: string) => {
        let discountValue: number = 0
        setDiscountInput(text);

        const discountAux: number = parseFloat(text.replace(",", "."))

        if(discountAux > 0){
            discountValue = discountAux
        }

        setDiscountPercent(discountValue)
    };


    /** botao finalizar **/
    const finishOrder = () => {

        if(!customerSelected) {
            setTypeMessage('warning')
            setMessage('Necessário selecionar um cliente')
            setVisiblePopup(true)
            return
        }

        if(!paymentSelected) {
            setTypeMessage('warning')
            setMessage('Necessário selecionar uma condição de pagamento')
            setVisiblePopup(true)
            return
        }

        if(itemCart.length <= 0) {
            setTypeMessage('warning')
            setMessage('Necessário selecionar ao menos um produto')
            setVisiblePopup(true)
            return
        }
        
        if(customerSelected.financial.length > 0) {
            setContinuaOrc(true)
        }

        setVisibleModalObs(true)
    }


    const handleGeraPedido = async(orcamento: string) => {
        setLoad(true)

        const items = itemCart.map((item: any) => {
            return {
                produto: item.code,
                quantidade: item.selected_quantity,
                valor: handlePriceRule(item)
            };
        });

        const sendJson = {
            endereco_entrega: customerSelected.another_address,
            cep_entrega: customerSelected.another_cep,
            bairro_entrega: customerSelected.another_district,
            condpagto: paymentSelected.code,
            desconto: discountPercent,
            numorc: orcamentoSelected,
            orcamento: orcamento,
            observation: textObs,
            token: authDetail.token,
            cliente: {
                filial: customerSelected.branch,
                endereco: customerSelected.address,
                bairro: customerSelected.district,
                cep: customerSelected.cep,
                uf: customerSelected.uf,
                cidade: customerSelected.city,
                tel: customerSelected.phone,
                cnpj: customerSelected.cnpj,
                codigo: customerSelected.code,
                contato: customerSelected.contact,
                email: customerSelected.email,
                nome_fantasia: customerSelected.short_name,
                razao_social: customerSelected.name
            },
            items: items
        }

        try{
            const response = await api.post("/WSAPP12", sendJson);
            const receive = response.data;

            let messageSuccess = ''
            let messageError = ''

            if(orcamento === 'N'){
                messageSuccess = 'Pedido gerado com sucesso '+receive.status.message
                messageError = receive.status.message

            }else {
                messageSuccess = 'Orçamento gerado com sucesso, pedido salvo para edição'
                messageError = 'Erro ao gerar orçamento'

                setOrcamentoSelected('')
            }

            if (receive.status.code === '#200') {
                setItemCart([])
                setCustomerSelected(null)
                setPaymentSelected(null)
                setTypeMessage('success')
                setMessage(messageSuccess)
                
                if(orcamento === 'S'){
                    const currentDate = new Date();
                    const year = currentDate.getFullYear().toString();
                    const month = (currentDate.getMonth() + 1).toString().padStart(2, '0'); // Os meses são indexados em zero
                    const day = currentDate.getDate().toString().padStart(2, '0');

                    const formattedDate = `${year}${month}${day}`;            

                    const orcOld = await AsyncStorage.getItem('@orcamento')
                    let orcNew: any = []
        
                    if (!!orcOld){
                        orcNew = [...JSON.parse(orcOld)]
                    }

                    const sendOrc = {
                        id: receive.status.message,
                        customer: customerSelected,
                        payment: paymentSelected,
                        items: itemCart,
                        orcamento: orcamento,
                        numorc: receive.status.message,
                        emission: formattedDate,
                        timestamp: moment().format('HH:mm:ss')
                    }

                    const orcamentoIndex = orcNew.findIndex((orcamento: any) => orcamento.numorc === orcamentoSelected);

                    if (orcamentoIndex !== -1) {
                        orcNew[orcamentoIndex] = sendOrc;
                    } else {
                        orcNew.push(sendOrc);
                    }
                      
                    await AsyncStorage.setItem('@orcamento', JSON.stringify(orcNew))

                } else {

                    const orcamentosString = await AsyncStorage.getItem('@orcamento');
                    const orcamentos = orcamentosString ? JSON.parse(orcamentosString) : [];
                    const orcamentosAtualizados = orcamentos.filter((orcamento: any) => orcamento.numorc !== orcamentoSelected);

                    await AsyncStorage.setItem('@orcamento', JSON.stringify(orcamentosAtualizados));
                }

                setVisibleModalObs(false)
                setVisiblePopup(true)

            } else {
                setTypeMessage('error')
                setMessage(messageError)
                setVisiblePopup(true)
            }
            
        } catch(error){
            setTypeMessage('error')
            setMessage('Erro na comunicação com o servidor, contate um administrador')
            setVisiblePopup(true)
        }

        setLoad(false)

    }


    const handlePopUp = () => {

        setVisiblePopup(!visiblePopup)

        if(typeMessage === 'success'){
            navigation.navigate('Orders')
        }
        
    }

    const goBack = () => {
        if(!!orcamentoSelected) {
            handleClearCart()
            setOrcamentoSelected('')
        }

        navigation.goBack()
    }


    const handleContinuaOrc = () => {
        setContinuaOrc(!continuaOrc)
    }


    const handlePriceRule = (item: any) => {

        let value = 0
        const quantity = item.selected_quantity
        const price1 = item.price
        const price2 = item.price2
        const price3 = item.price3
    
        if(!priceRule){
            return price1.price
        }
    
        if(price1.max === 0){
          price1.max = 9999
        }
    
        if(price2.max === 0){
          price2.max = 9999
        }
    
        if(price3.max === 0){
          price3.max = 9999
        }
    
        if(quantity >= price1.min && quantity <= price1.max){
            value = price1.price
        }
    
        if(quantity >= price2.min && quantity <= price2.max){
            value = price2.price
        }
    
        if(quantity >= price3.min && quantity <= price3.max){
            value = price3.price
        }
    
        return value
    }

    return(<>
        <SafeAreaView 
            edges={["top"]}
            style={{ flex: 0, backgroundColor: colors.primary }}
        />
        <Style.SafeContainer style={{backgroundColor: colors.primary}}>
            <Style.NewOrderHeader>
                <Style.ArrowContainer onPress={goBack}>
                    <Entypo name="chevron-left" size={30} color="white" />
                </Style.ArrowContainer>

                <Style.TextHeaderNOrder>
                    Novo Pedido
                </Style.TextHeaderNOrder>
            </Style.NewOrderHeader>

            <Style.CliPayHeader onPress={handleModalCustomers}>
                {
                    !!dataCustomers ?
                        <Style.ClienteText>
                            {dataCustomers.short_name}
                        </Style.ClienteText>
                    :
                        <>
                            <Style.ClienteText>
                                Buscar Cliente
                            </Style.ClienteText>
            
                            <AntDesign name="search1" size={20} color="#fff" />
                        </>
                 
                }
            </Style.CliPayHeader>

            <Style.CliPayHeader onPress={handleModalPayment}>
                {
                    !!dataPayment ?
                        <Style.ClienteText>
                            {dataPayment.code + ' - ' + dataPayment.description}
                        </Style.ClienteText>
                    :
                        <>
                            <Style.ClienteText>
                                Condição de Pagamento
                            </Style.ClienteText>
            
                            <AntDesign name="search1" size={20} color="#fff" />
                        </>
                 
                }
            </Style.CliPayHeader>

            <Style.NewOrderContainer animation="fadeInUp">

                { !isOnline &&
                    <Style.TextOffLine>offline</Style.TextOffLine>
                }
            
                <FlatList
                    data={dataItens}
                    showsVerticalScrollIndicator={false}
                    renderItem={({ item, index }: { item: any, index: number}) => (
                        
                        <Style.ItemNOrderContainer>
                            <View>
                                <Style.CodItemNOrder>{item.code}</Style.CodItemNOrder>
                                <Style.DescItemNOrder>{item.description.substring(0,28)}</Style.DescItemNOrder>
                            </View>

                            <Style.CountContainer>
                                <Style.DescItemNOrder>{CurrencyFormat(handlePriceRule(item) * item.selected_quantity)}</Style.DescItemNOrder>
                                
                                <Style.CountItemContainer>

                                    <Style.ButtonCount
                                        onPress={() => handleMinus(index)}
                                        clear={item.selected_quantity === 1}
                                    >
                                        { item.selected_quantity > 1
                                            ? <FontAwesome name="minus" size={14} color="white" />
                                            : <FontAwesome name="trash-o" size={16} color="white" />
                                        }
                                    </Style.ButtonCount>

                                    <Style.TextCountItem>{item.selected_quantity}</Style.TextCountItem>

                                    <Style.ButtonCount
                                        onPress={() => handleMore(index)}
                                        clear={false}
                                    >
                                        <FontAwesome name="plus" size={14} color="white" />
                                    </Style.ButtonCount>
                                </Style.CountItemContainer>
                            </Style.CountContainer>
                        </Style.ItemNOrderContainer>
                        
                    )}
                    keyExtractor={item => item.id}
                    ListEmptyComponent={
                        <Style.EmptyListContProd style={{alignItems:'center'}}>
                            <LottieView
                                autoPlay
                                loop
                                ref={animation}
                                style={{width: 300}}
                                source={require('../../assets/emptyCart.json')}
                            />
                        </Style.EmptyListContProd>
                    }
                />
                { !keyboardActived &&
                    <Style.ContainerAddMore onPress={handleModalProducts}>
                        <FontAwesome name="plus" size={16} color={colors.primary} />
                        <Style.TextAddMore>{
                            dataItens.length > 0
                                ? 'Adicionar mais itens'
                                : 'Adicionar produtos'
                        }</Style.TextAddMore>
                    </Style.ContainerAddMore>
                }
            </Style.NewOrderContainer>

            <Style.KeyboardFoorterArea
                behavior={Platform.OS === 'ios' ? 'padding' : undefined}
                keyboardVerticalOffset={30}
            >
                <Style.FooterOrderContainer>

                    {/*   
                        <Style.ContainerDesconto>
                            <Style.TextFooterOrder color='#000'>Desconto %</Style.TextFooterOrder>
                            <Style.DescontoInput
                                autoCorrect={false}
                                keyboardType='numeric'
                                onChangeText={handleDiscount}
                                value={discountInput}
                            />
                        </Style.ContainerDesconto>

                        <Style.TextFooterOrder color='#FF932F'>{`Vlr. Desconto: ${CurrencyFormat(sumDiscount())}`}</Style.TextFooterOrder>
                    */}

                    
                    <Style.ContainerDesconto>
                        <Style.TextFooterOrder color='#000'>Aplica desconto? </Style.TextFooterOrder>

                        <Switch
                            trackColor={{false: '#000', true: '#FF932F'}}
                            thumbColor={priceRule ? '#f4f3f4' : '#f4f3f4'}
                            ios_backgroundColor='#000'
                            onValueChange={toggleSwitch}
                            value={priceRule}
                            style={{ transform: [{scaleX: 1}, {scaleY: 1}]}}
                            onChange={() => {}}
                        />
                    </Style.ContainerDesconto>

                    {!keyboardActived && <>
                        <Style.TotalsFooterOrder mt={10}>
                            <Style.TextFooterOrder color='#000'>{`Quant.: ${sumQuantityTotal()}`}</Style.TextFooterOrder>
                            <Style.TextFooterOrder color='#000'>{`Vlr. Total: ${CurrencyFormat(sumValueTotal() - sumDiscount())}`}</Style.TextFooterOrder>
                        </Style.TotalsFooterOrder>
                            
                        <Style.TotalsFooterOrder mt={20}>
                            <Style.ButtonClearOrder onPress={handleClearCart}>
                                <MaterialIcons style={{marginRight:6}} name="cleaning-services" size={20} color={colors.primary} />
                                <Style.TextFooterOrder color={colors.primary}>Limpar</Style.TextFooterOrder>
                            </Style.ButtonClearOrder>

                            <Style.ButtonFinishOrder onPress={finishOrder}>
                                <Style.TextFooterOrder color='#fff'>Finalizar</Style.TextFooterOrder>
                            </Style.ButtonFinishOrder>
                        </Style.TotalsFooterOrder>
                    </>}
                </Style.FooterOrderContainer>
            </Style.KeyboardFoorterArea>
        </Style.SafeContainer>

        <SafeAreaView 
            edges={["bottom"]}
            style={{ flex: 0, backgroundColor: "#f9f9f9" }}
        />

        <ModalProducts 
            getVisible={visibleModalProducts}
            handleModalProducts={handleModalProducts}
            products={products}
            atualizaProdutos={atualizaProdutos}
        />

        <ModalCustomers 
            getVisible={visibleModalCustomers}
            handleModalCustomers={handleModalCustomers}
            customers={customers}
            atualizaClientes={atualizaClientes}
            handleContinuaOrc={handleContinuaOrc}
        />

        <ModalPayment
            getVisible={visibleModalPayment}
            handleModalPayment={handleModalPayment}
            payment={payment}
            atualizaPagamentos={atualizaPagamentos}
        />

        <ModalObs
            getVisible={visibleModalObs}
            handleModalObs={() => setVisibleModalObs(!visibleModalObs) }
            changeTextObs={(change) => setTextObs(change)}
            textObs={textObs}
            handleGeraPedido={handleGeraPedido}
            load={load}
            continuaOrc={continuaOrc}
        />

        <Popups 
            getVisible={visiblePopup}
            handlePopup={handlePopUp}
            type={typeMessage}
            filter={null}
            message={message}
        />

    </>)
}