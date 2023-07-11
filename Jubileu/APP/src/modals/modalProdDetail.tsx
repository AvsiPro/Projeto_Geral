import React, { useState, useEffect, useContext } from 'react';
import * as Style from './styles';
import { ActivityIndicator, Modal } from 'react-native';

import SliderComponent from '../components/sliderComponent';
import { FontAwesome } from '@expo/vector-icons';

import { PropsProdDetail } from '../interfaces';
import { Ionicons } from '@expo/vector-icons';
import { CurrencyFormat } from '../utils/currencyFormat';
import { ThemeContext } from '../contexts/globalContext';

export default function modalProdDetail({getVisible, handleModalProducts, products} : PropsProdDetail){

    const { colors } = useContext(ThemeContext);
    
    return(
        <Modal 
            transparent
            visible={getVisible}
            animationType='slide'
        >
            <Style.SafeAreaModals>
                <Style.ModalOrderContainer style={{backgroundColor:'#fff'}}>
                    <Style.containerFormModal animation="fadeInUp">
                        <Style.ModalHeader>
                            <Style.TextModalHeader>
                                Detalhes
                            </Style.TextModalHeader>

                            <Style.CloseModal 
                                onPress={() => handleModalProducts()}
                                activeOpacity={0.4}
                            >
                                <FontAwesome
                                    name="close"
                                    size={24}
                                    color="#FF9F47"
                                />
                            </Style.CloseModal>
                        </Style.ModalHeader>

                        {!!products &&
                            <>
                                <SliderComponent code={products.code} />

                                <Style.ModalItensContainer>
                                    <Style.TopCardContainer>
                                        <Style.ContainerChecked>
                                            <Style.CodItemProdModal>{products.code}</Style.CodItemProdModal>
                                        </Style.ContainerChecked>
                                        
                                        <Ionicons
                                            size={20}
                                            name={products.gender === 'M' ? "male" : "female"}
                                            color={products.gender === 'M' ?  "#426AD0" : "#D99BFF"}
                                        />
                                    </Style.TopCardContainer>
                                    
                                    <Style.DscItemProdModal color={products.balance > 0 ? colors.primary : 'tomato'}>
                                        {products.description}
                                    </Style.DscItemProdModal>
            

                                    <Style.MiddleCardContainer mt={10}>
                                        <Style.MiddleCardText>{`Marca: ${products.brand}`}</Style.MiddleCardText>
                                        <Style.MiddleCardText>{`Valor: ${CurrencyFormat(products.price.price)}`}</Style.MiddleCardText>
                                    </Style.MiddleCardContainer>

                                    <Style.MiddleCardContainer mt={4}>
                                        <Style.MiddleCardText>{`Linha: ${products.line}`}</Style.MiddleCardText>
                                        <Style.MiddleCardText>{`Material: ${products.material}`}</Style.MiddleCardText>
                                    </Style.MiddleCardContainer>

                                    <Style.MiddleCardContainer mt={20}>
                                        <Style.MiddleCardText>{`Saldo: ${products.balance}`}</Style.MiddleCardText>
                                    </Style.MiddleCardContainer>
                                </Style.ModalItensContainer>
                            </>
                        }

                    </Style.containerFormModal>
                </Style.ModalOrderContainer>
            </Style.SafeAreaModals>
        </Modal>
    )
}