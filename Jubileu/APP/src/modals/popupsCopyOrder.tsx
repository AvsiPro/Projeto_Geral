import React, { useContext, useRef, useState } from 'react';
import * as Style from './styles';
import { Modal } from 'react-native';
import LottieView from 'lottie-react-native'

import { PropsPopupCopyOrder } from '../interfaces';

import { ThemeContext } from '../contexts/globalContext';


export default function PopupsCopyOrder({getVisible, handlePopup} : PropsPopupCopyOrder){

    const animation = useRef(null);
    const { colors } = useContext(ThemeContext);


    return(
        <Modal 
            transparent
            visible={getVisible} 
            animationType='fade'
        >
            <Style.SafeAreaPopups center={true}>

                <Style.PopupCopyOrder style={Style.styleSheet.shadow}>
                    <LottieView
                        autoPlay
                        ref={animation}
                        style={{width: 150, height: 150}}
                        source={require('../assets/popupcopy.json')}
                    />
                    <Style.PopupCopyMessage color='#000'>
                        Deseja realizar a cópia completa do pedido?
                    </Style.PopupCopyMessage>

                    <Style.ButtonsPopUpCopy>
                        <Style.ButtonCopyOrderPopup
                            background={'#fff'}
                            onPress={() => handlePopup('nao')}
                        >
                            <Style.PopupCopyMessage color='#000'>Não</Style.PopupCopyMessage>
                        </Style.ButtonCopyOrderPopup>

                        <Style.ButtonCopyOrderPopup
                            background={colors.primary}
                            onPress={() => handlePopup('sim')}
                        >
                            <Style.PopupCopyMessage color='#fff'>Sim</Style.PopupCopyMessage>
                        </Style.ButtonCopyOrderPopup>
                    </Style.ButtonsPopUpCopy>
                    
                </Style.PopupCopyOrder>
                
            </Style.SafeAreaPopups>
        </Modal>
    )
}