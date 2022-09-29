import React,{useState, useContext, useEffect} from 'react';
import {
    SafeAreaView,
    View,
    Text,
    Image,
    TouchableOpacity,
    TextInput,
    FlatList,
    Keyboard,
    ActivityIndicator,
    Alert
} from 'react-native';

import { RadioButton } from 'react-native-paper';

import _ from 'underscore';

import styles from './styles';

import {decode, encode} from 'base-64';

import typeIcons from '../../utils/typeIcons';
import { Ionicons,FontAwesome } from '@expo/vector-icons';

import api from '../../services/api'

import ModFilter from '../../Modal/modFilter';
import ModScan from '../../Modal/modScan';
import ModCart from '../../Modal/modCart';
import ModBack from '../../Modal/modBack';

import {CartContext} from '../../Contexts/cart';

import {BarCodeScanner} from 'expo-barcode-scanner';

if (!global.btoa) { global.btoa = encode }
if (!global.atob) { global.atob = decode }


export default function SalePrd({route,navigation}){

    const { addCart,cart,totalCart,vlrTotalCart,quantCart,qtdTotalCart,dataUser,descontoCart,desconto } = useContext(CartContext)

    const { nameSec,data,filter,dataBack,continuaP,ItensContinua } = route.params;

    const [visibleCart, setVisibleCart] = useState(false);
    const [searchText, setSearchText] = useState('');
    const [searchT,setSearchT] = useState(false);
    const [listSearch,setListSearch] = useState([]);
    const [list, setList] = useState(data);
    const [page, setPage] = useState(2);
    const [checked, setChecked] = useState(filter);
    const [load, setLoad] = useState(false);
    const [selectBenef, setSelectBenef] = useState(false);

    const [visibleFilter, setVisibleFilter] = useState(false);
    const [visibleScan, setVisibleScan] = useState(false);
    const [visibleBack, setVisibleBack] = useState(false);

    const [hasPermission, setHasPermission] = useState(null);
    const [scanned, setScanned] = useState(false);
    const [textScan, setTextScan] = useState('');

    const authBasic = 'YWRtaW46QVZTSTIwMjI';


    useEffect(()=> {askForCameraPermission()},[])
    
    const askForCameraPermission = () =>{
        (async () =>{
            const {status} = await BarCodeScanner.requestPermissionsAsync();
            setHasPermission(status == 'granted')
        })()
    };

    const handleBarCodeScanned = async({type, data}) =>{

        const response = await api.get(`/Products/`,{
            withCredentials: true,
            headers: {
                'Authorization': 'Basic '+authBasic,
                'VENDEDOR': dataUser.cod_vendedor,
                'page': 1,
                'pageSize': 10,
                'CODIGO':data
            } 
        });

        const item = response.data["items"][0]

        if (item.length !== 0){ 
            addProductToCart(item,false,false);
            setTextScan(data+' adicionado ao carrinho!');
            setScanned(true);
        } 
    };

    if (hasPermission === null){
        <View>
            <Text>Requesting for camera permission</Text>
        </View>
    };

    if(hasPermission === false){
        <View>
            <Text style={{margin:10}}>no access to camera</Text>
            <TouchableOpacity onPress={()=> askForCameraPermission()}>
                <Text>Allow Camera</Text>
            </TouchableOpacity>
        </View>
    };


    function buttomSearch(option){
        if(searchT){ loadSec() } else { searchSec(option) }

        Keyboard.dismiss()
    };

    const loadSec = async() =>{
        if (searchT){
            setList(data)
            setSearchT(false)
            setSearchText('')
        }
        
        const response = await api.get(`/${nameSec}/`,{
            withCredentials: true,
            headers: {
                'Authorization': 'Basic '+authBasic,
                'VENDEDOR': dataUser.cod_vendedor,
                'page': page,
                'pageSize': 10
            } 
        })

        const aResult = getNewList(list,response.data["items"])

        setList(aResult)
        setPage(page+1)
    };

    function getNewList(current, data) {
        const newList = {}
        
        const listAux = [...current, ...data]

        listAux.forEach(item => {newList[item.id] = item})

        return Object.values(newList)
    }
    
    const searchSec = async(option) =>{
        if (searchText==='') return;

        setListSearch([])
        setList(data)

        let params = {
            'Authorization': 'Basic '+authBasic,
            'VENDEDOR': dataUser.cod_vendedor,
            'ORIGEMAPP': "S",
            'page': 1,
            'pageSize': 2000,
        };

        let opt_new = option.split(":");
        
        switch (opt_new[0]) {
            case "CODIGO":
                params.codigo = opt_new[1];
                break;
            case "DESCRICAO":
                params.descricao = opt_new[1];
                break;
            case "LINHA":
                params.linha = opt_new[1];
                break;
            case "MARCA":
                params.marca = opt_new[1];
                break;
            case "MATERIAL":
                params.material = opt_new[1];
                break;
            case "GENERO":
                params.genero = opt_new[1];
                break;
            default:
                break;
        }

        let aResult = [];

        try{
            setLoad(true)
            const response = await api.get(`/${nameSec}/`,{headers: params})
            if(_.has(response.data,"Erro")){
                aResult = [];
            }else{
                if(response.data.items){
                    response.data["items"].forEach((element, index) => {
                      aResult.push({index: index, ...element});
                    });
                  }else{
                    aResult.push(response.data);
                }
            }
            
        }catch(error){
            console.log(error)
        }
        
        setListSearch(aResult)
        setSearchT(true)
        setLoad(false)
    };

    function addProductToCart(item,initial,benef){

        if(initial){setVisibleCart(true)}
        
        let vlrTotal = 0

        const copyCart = [...cart];
        const result = copyCart.find((product) => product.id === parseInt(item.id));

        if(!result){

            vlrTotal = parseFloat(item.preco.trim().replace(',', '.'))

            copyCart.push({
                id: parseInt(item.id),
                QUANTIDADE: 1,
                PRODUTO: item.codigo.trim(),
                DESCRICAO: item.descricao.trim(), 
                VALOR: item.preco.trim(),
                TOTAL: vlrTotal,
                BENEF: benef?'B':'N'
            });
            
            const sumall =  vlrTotalCart + parseInt(item.preco)
            totalCart(sumall)

        }else {

            if(result.BENEF === 'B'){
            
                alert('Não é possível incluir mais de 1 item de beneficiamento')
            
            }else{
                copyCart.forEach((list) => { 
                    if(list.id === item.id){ vlrTotal += parseFloat(list.VALOR.replace(',', '.'))}
                });

                result.QUANTIDADE = result.QUANTIDADE + 1;

                if(vlrTotal !== 0){
                    result.TOTAL = vlrTotal * result.QUANTIDADE;
                } else{
                    result.TOTAL = parseFloat(result.VALOR.replace(',', '.')) * result.QUANTIDADE;
                }
    
                const sumall = copyCart.map(item => item.TOTAL).reduce((prev, curr) => prev + curr, 0);
                
                totalCart(sumall)
            }
        };

        addCart(copyCart)

        const sumQtd = copyCart.map(item => item.QUANTIDADE).reduce((prev, curr) => prev + curr, 0);
        quantCart(sumQtd)

        if(benef){setSelectBenef(true)}

    };

    function removeProductToCart(item){

        let vlrTotal = 0
        let lRemove = false

        const copyCart = [...cart];
        const result = copyCart.find((product) => product.id === parseInt(item.id));

        if(result && result.QUANTIDADE > 1){
            result.QUANTIDADE = result.QUANTIDADE - 1
            addCart(copyCart)

        }else {
           showConfirmDialog(item.id)
           lRemove = true
        }

        if(result && result.QUANTIDADE >= 1){
            copyCart.forEach((list) => { 
                if(list.id === item.id){
                    vlrTotal += parseFloat(list.VALOR.replace(',', '.')) 
                }
            });

            if(!lRemove){
                result.TOTAL = vlrTotal * result.QUANTIDADE;
                const totalSub = vlrTotalCart - parseFloat(result.VALOR)

                totalCart(totalSub)

                const quantSub = qtdTotalCart - 1
                quantCart(quantSub)
            }

            if(result.BENEF === 'B'){setSelectBenef(false)}
        }
 
    };

    function clearCart(){
        addCart([])
        totalCart(0)
        quantCart(0)
        descontoCart('')
        setVisibleCart(false)
        setSelectBenef(false)
    };

    function backCart(retorna){

        if(retorna){

            if(!continuaP){
                addCart([])
                totalCart(0)
                quantCart(0)
                descontoCart('')

                navigation.navigate('SaleCli',{
                    nameSec:dataBack[0],
                    data:dataBack[1],
                    filter:dataBack[3],});

            } else{

                navigation.navigate('Detail',{
                    nameSec:dataBack[0],
                    data:dataBack[1],
                    filter:dataBack[2],
                });
            }
        };

        setVisibleBack(false)
    }

    const apiPayment = async() =>{
        
        const response = await api.get(`/CondPgto/`,{
            withCredentials: true,
            headers: {
                'Authorization': 'Basic '+authBasic,
                'VENDEDOR': dataUser.cod_vendedor,
            } 
        })
        
        setVisibleCart(false)

        navigation.navigate('SalePay',{
            data:response.data["items"],
            dataBack: [nameSec,data,filter],
            vendedor:dataUser.cod_vendedor,
            continuaP:continuaP,
            ItensContinua:ItensContinua
        })
    };

    const showConfirmDialog = (idRemove) => {
        return Alert.alert(
          "Atenção",
          "Deseja remover o produto do carrinho?",
          [ 
            {text: "Não"},
            {text: "Sim", onPress: () => {buttomRemoveItem(idRemove)}}
          ]
        );
    };

    function buttomRemoveItem(idRemove){

        let vlrTotal = 0
        
        const copyCart = [...cart];
        const result = copyCart.find((product) => product.id === parseInt(idRemove));
        
        if(result && result.QUANTIDADE == 1){ 
            const arrayFilter = copyCart.filter(product => product.id !== idRemove);
            addCart(arrayFilter)

            copyCart.forEach((list) => { 
                if(list.id === idRemove){
                    vlrTotal += parseFloat(list.VALOR.replace(',', '.')) 
                }
            });

            result.TOTAL = vlrTotal * result.QUANTIDADE;
            const totalSub = vlrTotalCart - parseFloat(result.VALOR)

            totalCart(totalSub)

            const quantSub = qtdTotalCart - 1
            quantCart(quantSub)
        }
    };


    return( 
        <>
        <SafeAreaView edges={["top"]} style={{ flex: 0, backgroundColor: "#175A93" }}/>
        <SafeAreaView
            edges={["left", "right", "bottom"]}
            style={{flex: 1, backgroundColor: "#fff",position: "relative",}}
        >
            <View style={styles.container}>
                <View style={styles.headerSales}>  
                    <TouchableOpacity onPress={()=>{!continuaP?setVisibleBack(true):backCart(true)}}>
                        <Ionicons style={{bottom:5,right:7}} name="arrow-back" size={40} color="white" />
                    </TouchableOpacity>

                    <Text style={{fontSize:24,fontWeight:'bold', color:'#fff'}}>Selecione o Produto</Text>
                </View> 

                <View style={styles.containerInput}>
                    <TextInput
                        style={styles.input}
                        placeholder="Pesquisar..."
                        placeholderTextColor="#888"
                        value={searchText}
                        onChangeText={(t) => setSearchText(t)}
                    />

                    {load ? 
                        <View style={{flex:1,flexDirection:'row',top:5,right:30}}>
                            <ActivityIndicator color={'#000000'} size={30}/>
                        </View>
                        :
                        <TouchableOpacity style={{right:30}} onPress={()=>{buttomSearch(`${checked}:${searchText}`)}}>
                            <Ionicons name={searchT?"close":"search"} size={32} color='#175A93' />
                        </TouchableOpacity>
                    }

                    <TouchableOpacity onPress={() => { setVisibleFilter(true) }}>
                        <Image 
                            style={{resizeMode:'contain', width:30}}
                            source={checked==''?typeIcons[4]:typeIcons[5]}
                        />
                    </TouchableOpacity>
                </View>

                <FlatList
                    data={searchT 
                        ? Array.from(listSearch).sort((a, b) => b.id.localeCompare(a.id))
                        : Array.from(list).sort((a, b) => b.id.localeCompare(a.id))
                    }
                    style={{width:'100%'}}
                    renderItem={({item})=> 
                        <View style={styles.cardP} > 
                            <View style={{flexDirection:'row',justifyContent:'space-between'}}>
                                <Text style={styles.cardTitleP}>{item.codigo.trim()}</Text>

                                <Ionicons
                                    name={item.genero.trim()==='Masculino'?"male":"female"} 
                                    size={24} 
                                    color={item.genero.trim()==='Masculino'?"#2F8BD8":"#ED52DD"}
                                />
                            </View>

                            <Text style={styles.cardDescP}>{item.descricao.trim().substr(0,35)}</Text>
                           
                            <View style={{flexDirection:'row',justifyContent:'space-between'}}>
                                <View>
                                    <Text style={styles.cardSubTitleP}>{'R$ '+item.preco.trim()}</Text>
                                    <Text style={styles.cardSubTitleP}>{'Saldo '+item.saldo.trim()}</Text>
                                    <Text style={styles.cardSubTitleP}>{'Linha: '+item.linha.trim()}</Text>
                                </View>
                                <View>
                                    <Text style={styles.cardSubTitleP}>{'Marca: '+item.marca.trim()}</Text>
                                    <Text style={styles.cardSubTitleP}>{'Material: '+item.material.trim()}</Text>
                                </View>
                            </View>

                            <View style={{
                                flexDirection:'row',
                                justifyContent:'center',
                                marginTop:20,
                            }}>
                                <TouchableOpacity 
                                    style={styles.buttonAddInitial} 
                                    onPress={()=>{addProductToCart(item, true, false)}}
                                >
                                    <Text style={styles.txtAddInitial}>Adicionar +</Text>
                                </TouchableOpacity>

                                { !selectBenef && verifyBenef(item,cart) &&
                                    <TouchableOpacity 
                                    style={{
                                        width: 40,
                                        height: 40,
                                        borderRadius: 40/2,
                                        backgroundColor:'#F4C619',
                                        alignItems:'center',
                                        justifyContent:'center',
                                        marginHorizontal:10
                                      }} 
                                    onPress={()=>{addProductToCart(item, true, true)}}
                                >
                                    <FontAwesome name="bold" size={20} color="black" />
                                </TouchableOpacity>}
                            </View>
                        </View>
                    }

                    onEndReached={!searchT&&loadSec}
                    onEndReachedThreshold={0.1}
                    keyExtractor={(item) => item.id}
                    ListEmptyComponent={
                        <View style={styles.emptyContainer}>
                            <Text style={styles.emptyText}>Registro não encontrado</Text>
                        </View>
                    }
                />

                { !searchT &&
                    <View style={styles.footerContent}>
                        <TouchableOpacity style={styles.imageContent} onPress={()=>{setVisibleCart(true)}}>
                            <Image style={{resizeMode:'contain',width:35}} source={typeIcons[6]}/>
                            <Text style={styles.titleButtom}>Cart</Text>
                        </TouchableOpacity>


                        <TouchableOpacity style={styles.imageContent} onPress={()=>{ setVisibleScan(true) }}>
                            <Image style={{resizeMode:'contain',width:35}} source={typeIcons[7]}/>
                            <Text style={styles.titleButtom}>Scan</Text>
                        </TouchableOpacity>
                    </View>
                }
                
            </View>

            <ModFilter visibleFilter={visibleFilter}>
                <View style={{alignItems: 'center'}}>
                    <View style={{flexDirection:'row',justifyContent:'space-between',width:'100%'}}>
                        <Text style={{ fontSize: 30,color:'#2F8BD8'}}>Filtro</Text>

                        <TouchableOpacity onPress={() => setVisibleFilter(false)}>
                            <Ionicons name="close" size={40} color="black" />
                        </TouchableOpacity>
                    </View>
                </View>
            
                <View style={{flexDirection:'row',justifyContent:'space-between',marginHorizontal:7}}>
                    <View style={{marginVertical:20}}>
                        <View style={{flexDirection:'row',alignItems:'center'}}>
                            <RadioButton
                                value="CODIGO"
                                status={ checked === 'CODIGO' ? 'checked' : 'unchecked' }
                                onPress={() => {setChecked('CODIGO');setVisibleFilter(false)}}
                            />
                            <Text>Código</Text>
                        </View>
                        <View style={{flexDirection:'row',alignItems:'center'}}>
                            <RadioButton
                                value="DESCRICAO"
                                status={ checked === 'DESCRICAO' ? 'checked' : 'unchecked' }
                                onPress={() => {setChecked('DESCRICAO');setVisibleFilter(false)}}
                            />
                            <Text>Descrição</Text>
                        </View>
                        <View style={{flexDirection:'row',alignItems:'center'}}>
                            <RadioButton
                                value="LINHA"
                                color='#000'
                                status={ checked === 'LINHA' ? 'checked' : 'unchecked' }
                                onPress={() => {setChecked('LINHA');setVisibleFilter(false)}}
                            />
                            <Text>Linha</Text>
                        </View>
                    </View>

                    <View style={{marginVertical:20}}>
                        <View style={{flexDirection:'row',alignItems:'center'}}>
                            <RadioButton
                                value="MARCA"
                                status={ checked === 'MARCA' ? 'checked' : 'unchecked' }
                                onPress={() => {setChecked('MARCA');setVisibleFilter(false)}}
                            />
                            <Text>Marca</Text>
                        </View>
                        <View style={{flexDirection:'row',alignItems:'center'}}>
                            <RadioButton
                                value="MATERIAL"
                                status={ checked === 'MATERIAL' ? 'checked' : 'unchecked' }
                                onPress={() => {setChecked('MATERIAL');setVisibleFilter(false)}}
                            />
                            <Text>Material</Text>
                        </View>
                        <View style={{flexDirection:'row',alignItems:'center'}}>
                            <RadioButton
                                value="GENERO"
                                status={ checked === 'GENERO' ? 'checked' : 'unchecked' }
                                onPress={() => {setChecked('GENERO');setVisibleFilter(false)}}
                            />
                            <Text>Gênero</Text>
                        </View>
                    </View>
                </View>
            </ModFilter>


            <ModCart visibleCart={visibleCart}>
                <View style={{flexDirection:'row',justifyContent:'space-between',}}>
                    <View>
                        <Text style={{fontSize:22, fontWeight:'bold'}}>Adicionar Produto</Text>
                    </View>
                    <View>
                        <TouchableOpacity onPress={() => setVisibleCart(false)} style={{bottom:25}}>
                            <Text style={{fontSize:50}}>+</Text>
                        </TouchableOpacity>
                    </View>
                </View>
                
                <FlatList
                    data={cart}
                    renderItem={({item})=> 
                        <View style={{
                            flexDirection:'row',
                            justifyContent:'space-between',
                            marginHorizontal:10,
                            marginBottom:30,
                            alignItems:'center'
                        }}>
                            <View>
                                <Text style={[styles.txtBold, item.BENEF === 'B'&&{color:'#F4B619'}]}>{item.PRODUTO.trim()}</Text>
                                <Text >{item.DESCRICAO.trim().substr(0,19)}</Text>
                                <Text >{item.VALOR.trim()}</Text>
                            </View>


                            <View style={{justifyContent:'center',alignItems:'center'}}>
                                <Text>{item.TOTAL.toLocaleString('pt-br',{style: 'currency', currency: 'BRL'})}</Text>
                                <View style={{flexDirection:'row',alignItems:'center',marginTop:5}}>

                                    <TouchableOpacity 
                                        onPress={()=>{removeProductToCart(item)}} 
                                        style={[styles.buttonQty, item.BENEF === 'B'&&{backgroundColor:'#F4C619'}]}
                                    >
                                        <Text style={styles.txtButtonQty}>-</Text>
                                    </TouchableOpacity>

                                    <Text style={{fontSize:18,fontWeight:'bold',marginHorizontal:5}}>
                                        {item.QUANTIDADE}
                                    </Text>

                                    <TouchableOpacity 
                                        onPress={()=>{item.BENEF !== 'B' && addProductToCart(item, false, false)}} 
                                        style={[styles.buttonQty, item.BENEF === 'B'&&{backgroundColor:'#F4C619'}]}
                                    >
                                        <Text style={styles.txtButtonQty}>+</Text>
                                    </TouchableOpacity>
                                </View>
                            </View> 

                        </View>
                    }
                    onEndReached={null}
                    onEndReachedThreshold={0.1}
                    keyExtractor={(item, index) => String(index)}
                    ListEmptyComponent={ load ? 
                        <ActivityIndicator color={'#000000'} size={50}/>
                        :
                        <TouchableOpacity onPress={()=>{setVisibleCart(false)}} style={{alignItems:'center',marginTop:50}}>
                            <Text style={{fontSize:22,color:'#49BB17',fontWeight:'bold'}}>Adicionar Itens ao Carrinho</Text>
                        </TouchableOpacity>
                    }
                />

                <View style={{marginBottom:25}}>

                    <View style={{flexDirection:'row',marginBottom:30}}>
                        <Text style={{fontWeight:'bold',marginBottom:5,alignItems:'flex-end'}}>Desconto %</Text>
                        
                        <View style={{
                            marginHorizontal:10,
                            borderBottomWidth:2,
                            borderBottomColor:'#2F8BD8',
                            width:'25%',
                            alignItems:'center',
                        }}> 
                            
                            <TextInput style={{width:'100%'}}
                                keyboardType='numeric'
                                value={desconto}
                                onChangeText={(t) => descontoCart(t)}
                            />
                        </View>
                    </View>

                    <View style={{flexDirection:'row',justifyContent:'space-between',marginBottom:10}}>
                        <Text style={{fontWeight:'bold'}}>Quant. Total: </Text>
                        <Text>{qtdTotalCart}</Text>
                    </View>

                    <View style={{flexDirection:'row',justifyContent:'space-between',marginBottom:10}}>
                        <Text style={{fontWeight:'bold'}}>Total Pedido: </Text>
                        <Text>{(vlrTotalCart-(vlrTotalCart*(~~desconto))/100).toLocaleString('pt-br',{style: 'currency', currency: 'BRL'})}</Text>
                    </View>

                    <View style={{flexDirection:'row',justifyContent:'space-between',marginBottom:10}}>
                        <Text style={{fontWeight:'bold', color:'tomato'}}>Vlr Desconto: </Text>
                        <Text style={{color:'tomato'}}>{((vlrTotalCart*(~~desconto)/100)*-1).toLocaleString('pt-br',{style: 'currency', currency: 'BRL'})}</Text>
                    </View>
                </View>
                
                {cart.length !== 0 &&
                    <View style={{flexDirection:'row', marginBottom:10}}>
                        <TouchableOpacity 
                            onPress={()=>{clearCart()}}
                            style={{
                                flex:1,
                                flexDirection:'row',
                                height:40,
                                alignItems:'center',
                                justifyContent:'center',
                                borderWidth:3,
                                borderColor:'#2F8BD8',
                                borderRadius:10,
                            }}
                        >   
                            <Image 
                                style={{resizeMode:'contain', width:20,marginHorizontal:5}}
                                source={typeIcons[8]}
                            />
                            <Text style={{color:'#2F8BD8', fontWeight:'bold', fontSize:16}}>Limpar</Text>
                        </TouchableOpacity>
                        

                        <TouchableOpacity 
                            onPress={()=>{apiPayment()}}
                            style={{
                                flex:2,
                                height:40,
                                justifyContent:'center',
                                alignItems:'center',
                                backgroundColor:'#222020',
                                borderRadius:10,
                                marginLeft:10
                            }}
                        >
                            <Text style={{color:'#fff', fontWeight:'bold', fontSize:16}}>Finalizar</Text>
                        </TouchableOpacity>
                    </View>
                }
            </ModCart>


            <ModScan visibleScan={visibleScan}>
                <View style={{alignItems: 'center'}}>
                    <View style={{flexDirection:'row',justifyContent:'space-between',width:'100%'}}>
                        <Text style={{ fontSize: 30,color:'#2F8BD8'}}>Scan</Text>

                        <TouchableOpacity onPress={() => {setVisibleScan(false),setTextScan(''),setScanned(false)}}>
                            <Ionicons name="close" size={40} color="black" />
                        </TouchableOpacity>
                    </View>
                </View>
                
                <View style={{alignItems:'center',justifyContent:'center'}}>
                    <View style={styles.barCodeBox}>
                        <BarCodeScanner 
                            onBarCodeScanned={scanned?undefined:handleBarCodeScanned}
                            style={styles.scanBox}
                        />
                    </View>

                    <Text style={{color:'tomato',fontWeight:'bold'}}>{textScan}</Text>

                    {scanned && 
                        <TouchableOpacity 
                            onPress={()=> {setScanned(false), setTextScan('')}}
                            style={{
                                height:40,
                                backgroundColor:'#2F8BD8',
                                justifyContent:'center',
                                alignItems:'center',
                                borderRadius:10,
                                width:'55%',
                                marginTop:20
                            }}
                        >
                            <Text style={[styles.txtBold,{color:'#fff'}]}>Scanear outro</Text>
                        </TouchableOpacity>
                    }
                </View>
            </ModScan>


            <ModBack visibleBack={visibleBack}>
                <View style={{alignItems: 'center', marginBottom:26}}>
                    <View style={{flexDirection:'row',justifyContent:'space-between',width:'100%'}}>
                        <Text style={{ fontSize: 26,color:'#F4C619'}}>Atenção</Text>

                        <TouchableOpacity onPress={() => {setVisibleBack(false)}}>
                            <Ionicons name="close" size={40} color="black" />
                        </TouchableOpacity>
                    </View>
                </View>
                
                <Text style={{ fontSize: 18,color:'#000'}}>O carrinho será zerado, deseja realmente voltar?</Text>

                <View style={{flexDirection:'row', justifyContent:'flex-end',marginTop:60}}>
                    <TouchableOpacity 
                        style={styles.buttonBack}
                        onPress={() => {backCart(false)}}
                    >
                        <Text style={{fontWeight:'bold'}}>Não</Text>
                    </TouchableOpacity>

                    <TouchableOpacity 
                        style={[styles.buttonBack,{backgroundColor:'#175A93',marginLeft:10}]}
                        onPress={() => {backCart(true)}}
                    >
                        <Text style={{color:'white', fontWeight:'bold'}}>Sim</Text>
                    </TouchableOpacity>
                </View>
                

            </ModBack>


        </SafeAreaView>
        </>
    )
}


export function verifyBenef(item,cart) {

    let lRet = true

    const copyCart = [...cart];
    const result = copyCart.find((product) => product.id === parseInt(item.id));

    if(result){
        lRet = false
    }
    
    return lRet
}