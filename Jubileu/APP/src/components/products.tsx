import React, { useContext, useRef } from 'react';
import * as Style from './styles';

import { MaterialCommunityIcons, FontAwesome } from '@expo/vector-icons';

import { PropItemCartContext, PropsProducts } from '../interfaces';
import { CurrencyFormat } from '../utils/currencyFormat';
import { ActivityIndicator, FlatList } from 'react-native';

import LottieView from 'lottie-react-native'
import { ThemeContext } from 'styled-components';
import ImageComponent from './ImageComponent';


export default function products({
    products,
    handleLoadMore,
    handleItem,
    isLoadBottom,
    isOnline,
    isOrder,
    handleLongItem,
    hasBar = false,
    handleMinus = () => {},
    handleMore = () => {}
} : PropsProducts){

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
                    <>
                        <Style.ContainerProdModal
                            style={Style.styleSheet.shadow}
                            onPress={() => handleItem(index)}
                            onLongPress={() => handleLongItem(index)}
                            activeOpacity={0.4}
                        >
                            
                            <Style.LeftContainerProdModal>
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
                                
                            </Style.TopCardContainer>

                                <Style.DscItemProdModal color={item.balance > 0 ? colors.primary : 'tomato'}>
                                    {item.description}
                                </Style.DscItemProdModal>

                                <Style.MiddleCardContainer2 mt={10}>
                                    <Style.MiddleCardText>{`Vlr. Unit.: ${CurrencyFormat(item.price.price)}`}</Style.MiddleCardText>
                                    <Style.MiddleCardText>{`Saldo: ${item.balance}`}</Style.MiddleCardText>
                                </Style.MiddleCardContainer2>

                                <Style.MiddleCardContainer2 mt={10}>
                                    <Style.MiddleCardText>{`Quantidade: ${item.selected_quantity}`}</Style.MiddleCardText>
                                </Style.MiddleCardContainer2>
                                
                            </Style.LeftContainerProdModal>

                            <Style.RightContainerProdModal>
                                <ImageComponent imageUrl={`https://jubileudistribuidora.com.br/photos/${item.code}.jpg`} />
                            </Style.RightContainerProdModal>
                        </Style.ContainerProdModal>

                        <Style.ContainerBotton>
                            <Style.ContainerBottonQtyL
                                style={Style.styleSheet.shadow}
                                onPress={() => handleMinus(item)}
                            >
                                <FontAwesome name="minus" size={20} color="white" />
                            </Style.ContainerBottonQtyL>

                            <Style.ContainerBottonQtyR
                                style={Style.styleSheet.shadow}
                                onPress={() => handleMore(item)}
                            >
                                <FontAwesome name="plus" size={20} color="white" />
                            </Style.ContainerBottonQtyR>
                        </Style.ContainerBotton>
                    </>
                
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
                                <Style.MiddleCardText>{`Valor: ${CurrencyFormat(item.price.price)}`}</Style.MiddleCardText>
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
                            <Style.EmptyListTextProd>{hasBar ? 'Nenhum produto scanneado' : 'Nenhum produto encontrado.'}</Style.EmptyListTextProd>
                        </>
                    }
                </Style.EmptyListContProd>
            }
        />
    )
}