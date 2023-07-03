import React, { useRef } from 'react';
import * as Style from './styles';

import { PropsCustomers } from '../interfaces';
import { CgcFormat } from '../utils/cgcFormat';
import { ActivityIndicator, FlatList } from 'react-native';

import LottieView from 'lottie-react-native'


export default function customers({customers, handleLoadMore, handleItem, isLoading, isOnline, handleCustomerFinancial} : PropsCustomers){
    
    const animation = useRef(null);


    /** faz a renderizacao do icone de load no final da lista conforme busca mais produtos **/
    const renderFooter = () => {
        if (!isLoading) return null;
        if (!isOnline) return null;
        if (customers.length < 10) return null;

        return (
            <Style.LoadingContent>
                <ActivityIndicator animating size="large" color={'#000'} />
            </Style.LoadingContent>
        );
    };

    return(

        <FlatList
            data={customers}
            showsVerticalScrollIndicator={false}
            renderItem={({ item }: { item: any; }) => (
                <Style.ContainerClietModal
                    style={Style.styleSheet.shadow}
                    onPress={() => handleItem(item)}
                    onLongPress={() => handleCustomerFinancial(item)}
                    activeOpacity={0.4}
                >
                    <Style.NameCustomer>
                        {item.code + ' - ' + item.short_name }
                    </Style.NameCustomer>

                    <Style.BottomCardClientContainer>
                        <Style.BottomCardClientText>
                            {item.name}
                        </Style.BottomCardClientText>

                        <Style.BottomCardClientText>
                            {CgcFormat(item.cnpj)}
                        </Style.BottomCardClientText>
                    </Style.BottomCardClientContainer>
                    
                </Style.ContainerClietModal>
            )}
            keyExtractor={item => item.id}
            ListFooterComponent={renderFooter}
            onEndReached={handleLoadMore}
            onEndReachedThreshold={0.5}
            ListEmptyComponent={
                <Style.EmptyListContProd>
                        { isLoading ?
                            <>
                                <LottieView
                                    autoPlay
                                    loop
                                    ref={animation}
                                    style={{width: 150, height:150}}
                                    source={require('../assets/search.json')}
                                />
                                <Style.EmptyListTextProd>Buscando clientes...</Style.EmptyListTextProd>
                            </>
                            :
                            <>
                                <LottieView
                                    autoPlay
                                    loop
                                    ref={animation}
                                    style={{width: 150, height:150}}
                                    source={require('../assets/emptyList.json')}
                                />
                                <Style.EmptyListTextProd>Nenhum cliente encontrado.</Style.EmptyListTextProd>
                            </>
                        }
                </Style.EmptyListContProd>
            }
        />
    )
}