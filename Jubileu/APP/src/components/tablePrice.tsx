import React, { useRef } from 'react';
import * as Style from './styles';

import { PropsTablePrice } from '../interfaces';
import { ActivityIndicator, FlatList } from 'react-native';

import LottieView from 'lottie-react-native'


export default function tablePrice({tablePrice, handleItem, isLoading, isOnline} : PropsTablePrice){
    
    const animation = useRef(null);

    /** faz a renderizacao do icone de load no final da lista conforme busca mais produtos **/
    const renderFooter = () => {
        if (!isLoading) return null;
        if (!isOnline) return null;
        if (tablePrice.length < 10) return null;

        return (
            <Style.LoadingContent>
                <ActivityIndicator animating size="large" color={'#000'} />
            </Style.LoadingContent>
        );
    };

    return(

        <FlatList
            data={tablePrice}
            showsVerticalScrollIndicator={false}
            renderItem={({ item }: { item: any; }) => (
                <Style.ContainerPayModal
                    style={Style.styleSheet.shadow}
                    onPress={() => handleItem(item)}
                    activeOpacity={0.4}
                >
                    <Style.CodePayment>
                        Tabela: {item.id}
                    </Style.CodePayment>

                    <Style.BottomCardPaymentContainer>
                        <Style.BottomCardPaymentText>
                            Descrição: {item.description}
                        </Style.BottomCardPaymentText>
                    </Style.BottomCardPaymentContainer>
                    
                </Style.ContainerPayModal>
            )}
            keyExtractor={item => item.id}
            ListFooterComponent={renderFooter}
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
                                <Style.EmptyListTextProd>Buscando tabelas de preço...</Style.EmptyListTextProd>
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
                                <Style.EmptyListTextProd>Nenhuma tabela de preço encontrada.</Style.EmptyListTextProd>
                            </>
                        }
                </Style.EmptyListContProd>
            }
        />
    )
}