import React, { useState, useContext } from 'react';
import * as Style from './styles';
import { useNavigation } from '@react-navigation/native';

import { AntDesign } from '@expo/vector-icons';

import { PropsFooter } from '../interfaces';
import { AppContext, ThemeContext } from '../contexts/globalContext';

import Popups from '../modals/popups';

export default function footer({buttomAdd}: PropsFooter){

    const navigation: any = useNavigation();
    const { itemCart } = useContext(AppContext);

    const [visiblePopup, setVisiblePopup] = useState(false)
    const [message, setMessage] = useState('')

    const { colors } = useContext(ThemeContext);

    const cartContain = itemCart.length > 0

    const handlePopup = () => {
        setVisiblePopup(!visiblePopup)
    }

    const handleCart = () => {
        if(cartContain){
            navigation.navigate('Neworder')
        }else{
            handlePopup()
            setMessage('Não há pedido em aberto.')
        }
    }

    return(<>
        <Style.FooterComponent style={Style.styleSheet.shadow}>
            <Style.ButtonFooter 
                onPress={() => navigation.navigate('Home')}
                activeOpacity={0.4}
            >
                <AntDesign
                    name="home"
                    size={24}
                    color="white"
                />
            </Style.ButtonFooter>

            { buttomAdd ?
                <Style.ButtonAddFooter 
                    style={Style.styleSheet.shadow}
                    activeOpacity={0.4}
                    onPress={() => navigation.navigate('Neworder')}
                >
                    <AntDesign
                        name="pluscircleo"
                        size={55}
                        color={colors.primary}
                    />
                </Style.ButtonAddFooter>
            :   
                <Style.ContainerCartFooter>
                    <Style.ButtonFooter onPress={handleCart}>
                        { cartContain &&
                            <Style.ElipseCartFooter />
                        }
                        <AntDesign
                            name="shoppingcart"
                            size={24}
                            color="white"
                            style={{bottom: cartContain ? 5 : 0}}
                        />
                    </Style.ButtonFooter>

                </Style.ContainerCartFooter>
            }

            <Style.ButtonFooter
                onPress={() => navigation.navigate('Profile')}
                activeOpacity={0.4}
            >
                <AntDesign
                    name="user"
                    size={24}
                    color="white"
                />
            </Style.ButtonFooter>
        </Style.FooterComponent>  

        <Popups 
            getVisible={visiblePopup}
            handlePopup={handlePopup}
            type={'warning'}
            filter={null}
            message={message}
        />      
    </>)
}