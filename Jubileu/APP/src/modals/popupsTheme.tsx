import React, { useContext, useRef } from 'react';
import * as Style from './styles';
import { Modal, Platform, View } from 'react-native';
import LottieView from 'lottie-react-native'

import { ThemeContext } from '../contexts/globalContext';

interface PropsPopup {
    visible: boolean;
    handlePopupTheme: () => void;
}


export default function PopupsTheme({visible, handlePopupTheme} : PropsPopup){
    
    const animation = useRef(null);
    const { handleColorChange } = useContext(ThemeContext);

    const handleTouchEnd = () => {
        handlePopupTheme()  
    }

    return(
        <Modal 
            transparent
            visible={visible} 
            animationType='fade'
        >
            <Style.SafeAreaPopups
                onTouchEnd={handleTouchEnd}
                center={false}
            >
            
            <Style.Popup 
                style={Style.styleSheet.shadow}
                top={Platform.OS === 'ios' ? 135 : 85}
                right={66}
            >
                <Style.PopupPalette>
                    <LottieView
                        autoPlay
                        loop={false}
                        ref={animation}
                        style={{width: 100, height: 100}}
                        source={require('../assets/popuppalette.json')}
                    />

                    <Style.TextPalette>Selecione a cor do tema</Style.TextPalette>

                    <Style.PalletSections>
                        <Style.PaletteColor onPress={() => handleColorChange('#426AD0')} color='#426AD0' />
                        <Style.PaletteColor onPress={() => handleColorChange('#D04242')} color='#D04242' />
                    </Style.PalletSections>

                    <Style.PalletSections>
                        <Style.PaletteColor onPress={() => handleColorChange('#D08642')} color='#D08642' />
                        <Style.PaletteColor onPress={() => handleColorChange('#212121')} color='#212121' />
                    </Style.PalletSections>
                </Style.PopupPalette>
            </Style.Popup>
        
            </Style.SafeAreaPopups>
        </Modal>
    )
}