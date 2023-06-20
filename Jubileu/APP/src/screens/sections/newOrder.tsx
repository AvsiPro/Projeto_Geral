import React, { useContext, useState, useRef, useEffect } from 'react';
import { FlatList, View, Platform, Keyboard } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Entypo, AntDesign, FontAwesome, MaterialIcons } from '@expo/vector-icons';
import * as Style from './styles';
import { useNavigation } from '@react-navigation/native';
import { AppContext, ThemeContext } from '../../contexts/globalContext';
import { CurrencyFormat } from '../../utils/currencyFormat';
import NetInfo from "@react-native-community/netinfo";
import LottieView from 'lottie-react-native'
import { PropItemCartContext } from '../../interfaces';

import ModalCustomers from '../../modals/modalCustomers';
import ModalProducts from '../../modals/modalProducts';
import ModalPayment from '../../modals/modalPayment';

export default function Neworder(){
    const navigation: any = useNavigation();
    const animation = useRef(null);
    const { itemCart, setItemCart, customerSelected, setCustomerSelected, paymentSelected, setPaymentSelected } = useContext(AppContext);
    const { colors } = useContext(ThemeContext);
    
    const [visibleModalProducts, setVisibleModalProducts] = useState(false)
    const [visibleModalCustomers, setVisibleModalCustomers] = useState(false)
    const [visibleModalPayment, setVisibleModalPayment] = useState(false)
    const [dataItens, setDataItens] = useState<any>([]);
    const [dataCustomers, setDataCustomers] = useState<any>(null);
    const [dataPayment, setDataPayment] = useState<any>(null);
    const [discountInput, setDiscountInput] = useState<string>('')
    const [products, setProducts] = useState<PropItemCartContext[]>([]);
    const [customers, setCustomers] = useState<any>([]);
    const [payment, setPayment] = useState<any>([]);
    const [keyboardActived, setKeyboardActived] = useState(false)
    const [isOnline, setIsOnline] = useState(true);


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
            
            newData[index] = {
            ...newData[index],
            selected_quantity: newData[index].selected_quantity + 1
            };
  
            return newData;
        }); 
    }


    /** responsavel pelo vlr total **/
    const sumValueTotal = (): number => {
        return itemCart.reduce((total: number, item: any) => total + item.price * item.selected_quantity, 0);
    }


    /** responsavel pela quantidade total **/
    const sumQuantityTotal = (): number => {
        return itemCart.reduce((total: number, item: any) => total + item.selected_quantity, 0);
    }
      

    /** botao de limpar itens do carrinho **/
    const handleClearCart = () => {
        const clonedCart: any = [...itemCart];
      
        clonedCart.forEach((item: any) => {
          atualizaProdutos((prevItems: any) => [...prevItems, item]);
        });
      
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
        setDiscountInput(text);
    };


    return(<>
        <SafeAreaView 
            edges={["top"]}
            style={{ flex: 0, backgroundColor: colors.primary }}
        />
        <Style.SafeContainer style={{backgroundColor: colors.primary}}>
            <Style.NewOrderHeader>
                <Style.ArrowContainer onPress={()=> navigation.goBack()}>
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
                                <Style.DescItemNOrder>{item.description}</Style.DescItemNOrder>
                            </View>

                            <Style.CountContainer>
                                <Style.DescItemNOrder>{CurrencyFormat(item.price * item.selected_quantity)}</Style.DescItemNOrder>
                                <Style.CountItemContainer>
                                    <Style.ButtonCount onPress={() => handleMinus(index)}>
                                        <FontAwesome name="minus" size={14} color="white" />
                                    </Style.ButtonCount>

                                    <Style.TextCountItem>{item.selected_quantity}</Style.TextCountItem>

                                    <Style.ButtonCount onPress={() => handleMore(index)}>
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

                            <Style.ButtonFinishOrder>
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
        />

        <ModalPayment
            getVisible={visibleModalPayment}
            handleModalPayment={handleModalPayment}
            payment={payment}
            atualizaPagamentos={atualizaPagamentos}
        />
    </>)
}