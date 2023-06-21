import React, { useContext, useRef } from 'react';
import * as Style from './styles';

import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';

import { PropItemCartContext, PropsProducts } from '../interfaces';
import { CurrencyFormat } from '../utils/currencyFormat';
import { ActivityIndicator, FlatList } from 'react-native';

import LottieView from 'lottie-react-native'
import { ThemeContext } from 'styled-components';
import ImageComponent from './ImageComponent';

export default function products({products, handleLoadMore, handleItem, isLoadBottom, isOnline, isOrder, handleLongItem} : PropsProducts){

    const animation = useRef(null);
    const { colors } = useContext(ThemeContext);

    /** faz a renderizacao do icone de load no final da lista conforme busca mais produtos **/
    const renderFooter = () => {
        if (!isLoadBottom) return null;
        if (!isOnline) return null;
        if (products.length < 10) return null;

        return (
            <Style.LoadingContent>
                <ActivityIndicator animating size="large" color={'#000'} />
            </Style.LoadingContent>
        );
    };
  
    return(

        <FlatList
            data={products}
            showsVerticalScrollIndicator={false}
            renderItem={({ item, index }: { item: PropItemCartContext; index: number }) => (
                <>
               
                { isOrder ?
                    <Style.ContainerProdModal
                        style={Style.styleSheet.shadow}
                        onPress={() => handleItem(index)}
                        onLongPress={() => handleLongItem(index)}
                        activeOpacity={0.4}
                    >
                        <Style.TopCardContainer>
                            <Style.ContainerChecked>
                                <MaterialCommunityIcons
                                    size={20} 
                                    name={item.marked ? "checkbox-marked-outline" : "checkbox-blank-outline"}
                                    color={item.marked ? "#0CC662" : "black"} 
                                    style={{marginRight:6}}
                                />

                                <Style.CodItemProdModal>{item.code}</Style.CodItemProdModal>
                            </Style.ContainerChecked>
                            
                            <Ionicons
                                size={20}
                                name={item.gender === 'M' ? "male" : "female"}
                                color={item.gender === 'M' ?  "#426AD0" : "#D99BFF"}
                            />
                        </Style.TopCardContainer>
                        
                        <Style.DscItemProdModal color={item.balance > 0 ? colors.primary : 'tomato'}>
                            {item.description}
                        </Style.DscItemProdModal>

                        <Style.MiddleCardContainer mt={10}>
                            <Style.MiddleCardText>{`Marca: ${item.brand}`}</Style.MiddleCardText>
                            <Style.MiddleCardText>{`Valor: ${CurrencyFormat(item.price)}`}</Style.MiddleCardText>
                        </Style.MiddleCardContainer>

                        <Style.MiddleCardContainer mt={4}>
                            <Style.MiddleCardText>{`Linha: ${item.line}`}</Style.MiddleCardText>
                            <Style.MiddleCardText>{`Material: ${item.material}`}</Style.MiddleCardText>
                        </Style.MiddleCardContainer>
                    </Style.ContainerProdModal>
                
                :

                    <Style.ContainerProdModal2
                        style={Style.styleSheet.shadow}
                        onPress={() => handleItem(index)}
                        activeOpacity={0.4}
                    >
                        <Style.LeftContainerProdModal>
                            <Style.CodItemProdModal>{item.code}</Style.CodItemProdModal>

                            <Style.DscItemProdModal color={item.balance > 0 ? colors.primary : 'tomato'}>
                                {item.description}
                            </Style.DscItemProdModal>

                            <Style.MiddleCardContainer2 mt={10}>
                                <Style.MiddleCardText>{`Marca: ${item.brand}`}</Style.MiddleCardText>
                                <Style.MiddleCardText>{`Valor: ${CurrencyFormat(item.price)}`}</Style.MiddleCardText>
                            </Style.MiddleCardContainer2>
                            
                        </Style.LeftContainerProdModal>

                        <Style.RightContainerProdModal>
                            <ImageComponent imageUrl={`https://jubileudistribuidora.com.br/photos/${item.code}.jpg`} />
                        </Style.RightContainerProdModal>
                    </Style.ContainerProdModal2>
                }

                </>
            )}
            keyExtractor={item => item.id}
            ListFooterComponent={renderFooter}
            onEndReached={handleLoadMore}
            onEndReachedThreshold={0.5}
            ListEmptyComponent={
                <Style.EmptyListContProd>
                    { isLoadBottom ?
                        <>
                            <LottieView
                                autoPlay
                                loop
                                ref={animation}
                                style={{width: 150, height:150}}
                                source={require('../assets/search.json')}
                            />
                            <Style.EmptyListTextProd>Buscando produtos...</Style.EmptyListTextProd>
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
                            <Style.EmptyListTextProd>Nenhum produto encontrado.</Style.EmptyListTextProd>
                        </>
                    }
                </Style.EmptyListContProd>
            }
        />
    )
}