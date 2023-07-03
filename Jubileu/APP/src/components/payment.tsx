import React, { useRef } from 'react';
import * as Style from './styles';

import { PropsPayment } from '../interfaces';
import { ActivityIndicator, FlatList } from 'react-native';

import LottieView from 'lottie-react-native'


export default function payment({payment, handleLoadMore, handleItem, isLoading, isOnline} : PropsPayment){
    
    const animation = useRef(null);

    /** faz a renderizacao do icone de load no final da lista conforme busca mais produtos **/
    const renderFooter = () => {
        if (!isLoading) return null;
        if (!isOnline) return null;
        if (payment.length < 10) return null;

        return (
            <Style.LoadingContent>
                <ActivityIndicator animating size="large" color={'#000'} />
            </Style.LoadingContent>
        );
    };

    return(

        <FlatList
            data={payment}
            showsVerticalScrollIndicator={false}
            renderItem={({ item }: { item: any; }) => (
                <Style.ContainerPayModal
                    style={Style.styleSheet.shadow}
                    onPress={() => handleItem(item)}
                    activeOpacity={0.4}
                >
                    <Style.CodePayment>
                        {item.code + ' - '+ item.description }
                    </Style.CodePayment>

                    <Style.BottomCardPaymentContainer>
                        <Style.BottomCardPaymentText>
                            {item.form}
                        </Style.BottomCardPaymentText>
                    </Style.BottomCardPaymentContainer>
                    
                </Style.ContainerPayModal>
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
                                <Style.EmptyListTextProd>Buscando condições de pagamentos...</Style.EmptyListTextProd>
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
                                <Style.EmptyListTextProd>Nenhuma condição de pagamento encontrada.</Style.EmptyListTextProd>
                            </>
                        }
                </Style.EmptyListContProd>
            }
        />
    )
}