import React, { useContext, useRef, useState } from 'react';
import * as Style from './styles';
import { ActivityIndicator, Modal } from 'react-native';
import LottieView from 'lottie-react-native'

import { PropsPopupCopyOrder } from '../interfaces';

import { ThemeContext } from '../contexts/globalContext';


export default function PopupsAlterTable({getVisible, handlePopup, load} : PropsPopupCopyOrder){

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
                        source={require('../assets/popupwarning.json')}
                    />
                    <Style.PopupCopyMessage color='#000'>
                        Ao alterar a Tabela de Preços o carrinho será limpo, deseja realmente prosseguir com a mudança?
                    </Style.PopupCopyMessage>

                    <Style.ButtonsPopUpCopy>
                        <Style.ButtonCopyOrderPopup
                            background={'#fff'}
                            onPress={() => !load && handlePopup('sim')}
                        >   
                            { load
                                ? <ActivityIndicator animating size="small" color={'#fff'} />
                                : <Style.PopupCopyMessage color='#000'>Sim</Style.PopupCopyMessage>
                            }
                        </Style.ButtonCopyOrderPopup>

                        <Style.ButtonCopyOrderPopup
                            background={colors.primary}
                            onPress={() => !load && handlePopup('nao')}
                        >
                            <Style.PopupCopyMessage color='#fff'>Não</Style.PopupCopyMessage>
                        </Style.ButtonCopyOrderPopup>
                    </Style.ButtonsPopUpCopy>
                </Style.PopupCopyOrder>
                
            </Style.SafeAreaPopups>
        </Modal>
    )
}