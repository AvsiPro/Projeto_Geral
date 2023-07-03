import React, { useContext, useRef, useState } from 'react';
import * as Style from './styles';
import { Modal, Platform, View } from 'react-native';
import { popup, filterOrder, filterProducts, filterCustomers } from '../utils/data';
import { AntDesign, Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import LottieView from 'lottie-react-native'

import { PropsPopup } from '../interfaces';

import PopupsTheme from './popupsTheme';

import { ThemeContext } from '../contexts/globalContext';

import * as ImagePicker from 'expo-image-picker';
import { AppContext } from '../contexts/globalContext';
import AsyncStorage from '@react-native-async-storage/async-storage';

export default function Popups({getVisible, handlePopup, type, filter, message} : PropsPopup){
    
    const { setImageProfile } = useContext(AppContext);
    const navigation: any = useNavigation()
    const animation = useRef(null);


    const [selectColor, setSelectedColor] = useState<boolean>(false)

    const { colors } = useContext(ThemeContext);

    const popupCenter = type === 'error' || type === 'warning' || type === 'success'

    const handleOptionAction = (action: string) => {
        if(action === 'exit'){
            navigation.navigate('Welcome')

        }else if(action === 'profile'){
            navigation.navigate('Profile')

        }else if(action === 'picture'){
            pickImage()

        }else if(action === 'theme'){
            handlePopupTheme()            
        }
    }

    const pickImage = async () => {
        const result = await ImagePicker.launchImageLibraryAsync({
          mediaTypes: ImagePicker.MediaTypeOptions.Images,
          allowsEditing: true,
          base64: true,
          aspect: [4, 3],
          quality: 1,
        });
    
        if (!result.canceled) {
            setImageProfile('data:image/jpeg;base64,' + result.assets[0].base64)
            await AsyncStorage.setItem("imageProfile", 'data:image/jpeg;base64,' + result.assets[0].base64);
        }
    };

    const handleTouchEnd = () => {
        handlePopup(null)
        
    }

    const handlePopupTheme = () => {
        setSelectedColor(!selectColor)
    }

    return(
        <>
        <Modal 
            transparent
            visible={getVisible} 
            animationType='fade'
        >
            <Style.SafeAreaPopups
                onTouchEnd={handleTouchEnd}
                center={popupCenter}
            >
                { !popupCenter &&
                    <Style.Popup 
                        style={Style.styleSheet.shadow}
                        top={Platform.OS === 'ios' ? 135 : 85}
                        right={type === 'settings' ? 66 : 56}
                    >
                        { type === 'settings' &&
                            
                            popup.map((item: any, index: number) =>{
                                return(
                                    <Style.PopupContainer
                                        key={index}
                                        border={(popup.length - 1) === index}
                                        onPress={() => handleOptionAction(item.action)}
                                        activeOpacity={0.4}
                                    >
                                        <AntDesign
                                            name={item.icon}
                                            color={item.color}
                                            size={24}
                                        />

                                        <Style.TextPopup>{item.title}</Style.TextPopup>

                                    </Style.PopupContainer>
                                )
                            })
                        }

                        { type === 'filterOrder' &&
                            filterOrder.map((item: any, index: number) =>{
                                if(!!item){
                                    return(
                                        <Style.PopupContainer
                                            key={index}
                                            border={(popup.length) === index}
                                            onPress={()=> handlePopup(index)}
                                        >   
                                            <Ionicons
                                                name={filter === index ? "radio-button-on" : "radio-button-off"}
                                                size={20}
                                                color={colors.primary}
                                            />
                                            <Style.TextPopup>{item}</Style.TextPopup>
                                        </Style.PopupContainer>
                                    )
                                }
                            })
                        }

                        { type === 'filterProducts' &&
                            filterProducts.map((item: any, index: number) =>{
                                if(!!item){
                                    return(
                                        <Style.PopupContainer
                                            key={index}
                                            border={(popup.length) === index}
                                            onPress={()=> handlePopup(index)}
                                        >   
                                            <Ionicons
                                                name={filter === index ? "radio-button-on" : "radio-button-off"}
                                                size={20}
                                                color={colors.primary}
                                            />
                                            <Style.TextPopup>{item}</Style.TextPopup>
                                        </Style.PopupContainer>
                                    )
                                }
                            })
                        }

                        { type === 'filterCustomers' &&
                            filterCustomers.map((item: any, index: number) =>{
                                if(!!item){
                                    return(
                                        <Style.PopupContainer
                                            key={index}
                                            border={(popup.length) === index}
                                            onPress={()=> handlePopup(index)}
                                        >   
                                            <Ionicons
                                                name={filter === index ? "radio-button-on" : "radio-button-off"}
                                                size={20}
                                                color={colors.primary}
                                            />
                                            <Style.TextPopup>{item}</Style.TextPopup>
                                        </Style.PopupContainer>
                                    )
                                }
                            })
                        }
                    </Style.Popup>
                }

                { type === 'error' &&
                    <Style.PopupError style={Style.styleSheet.shadow}>
                        <LottieView
                            autoPlay
                            speed={2}
                            loop={false}
                            ref={animation}
                            style={{width: 100, height: 100}}
                            source={require('../assets/popuperror.json')}
                        />
                        <Style.PopupErrorMessage>
                            {message}
                        </Style.PopupErrorMessage>
                        
                    </Style.PopupError>
                }

                { type === 'warning' &&
                    <Style.PopupError style={Style.styleSheet.shadow}>
                        <LottieView
                            autoPlay
                            speed={2}
                            loop={false}
                            ref={animation}
                            style={{width: 150, height: 150}}
                            source={require('../assets/popupwarning.json')}
                        />
                        <Style.PopupErrorMessage>
                            {message}
                        </Style.PopupErrorMessage>
                        
                    </Style.PopupError>
                }

                { type === 'success' &&
                    <Style.PopupError style={Style.styleSheet.shadow}>
                        <LottieView
                            autoPlay
                            speed={2}
                            loop={false}
                            ref={animation}
                            style={{width: 150, height: 150}}
                            source={require('../assets/popupsuccess.json')}
                        />
                        <Style.PopupErrorMessage>
                            {message}
                        </Style.PopupErrorMessage>
                        
                    </Style.PopupError>
                }
                

                
            </Style.SafeAreaPopups>
        </Modal>
        
        <PopupsTheme
            handlePopupTheme={handlePopupTheme}
            visible={selectColor}
        />

    </>
    )
}