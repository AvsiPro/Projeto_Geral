import React, { useState, useContext, useEffect } from "react";
import {View} from "react-native";

import { SafeAreaView } from "react-native-safe-area-context";

import * as Style from "./styles";

import Sections from "../../components/sections"
import Charts from "../../components/charts"
import Footer from "../../components/footer";

import Popups from "../../modals/popups";

import { AppContext, ThemeContext } from '../../contexts/globalContext';
import NetInfo from "@react-native-community/netinfo";

import { getInitials, capitalize } from "../../utils/nameFormat";
import AsyncStorage from "@react-native-async-storage/async-storage";

export default function Home() {

    const { authDetail, imageProfile, setImageProfile } = useContext(AppContext);
    const { colors } = useContext(ThemeContext);

    const [visiblePopup, setVisiblePopup] = useState(false)
    const [isOnline, setIsOnline] = useState(true);

    const handlePopup = () =>{
        setVisiblePopup(!visiblePopup)
    }

    /** verifica se esta online ou offline **/
    useEffect(() => {
        const unsubscribe = NetInfo.addEventListener((state: any) => {
            setIsOnline(state.isConnected);
        });
        
        return () => {
            unsubscribe();
        };
    }, []);


      /** carrega imagem base64 **/
    useEffect(() => {
        const storageImage = async() => {
            const imageProfile = await AsyncStorage.getItem("imageProfile");

            if (imageProfile !== null) {
            setImageProfile(imageProfile);
            }
        }

        storageImage()
    },[])

    return (<>
        <SafeAreaView
            edges={["top"]}
            style={{ flex: 0, backgroundColor: colors.primary}}
        />
        <Style.SafeContainer>
            <Style.HeaderComponent>
                <View>
                    <Style.TextName size={18}>Olá,</Style.TextName>
                    <Style.TextName size={24}>{capitalize(authDetail.name)}</Style.TextName>
                </View>

                <Style.ProfileButton
                    onPress={handlePopup}
                    activeOpacity={0.4}
                >
                    { imageProfile ? 
                        <Style.ImageProfile source={{ uri: imageProfile }} />
                    :
                        <Style.TextProfileButton>
                            {getInitials(authDetail.name)}
                        </Style.TextProfileButton>
                    }

                </Style.ProfileButton>
            </Style.HeaderComponent>

            { !isOnline &&
                <Style.TextOffLine>
                    offline
                </Style.TextOffLine>
            }

            <Style.ScrollMainContainer>
                <Sections />
                <Charts />
            </Style.ScrollMainContainer>

            <Footer buttomAdd={null} />
        </Style.SafeContainer>

        <Popups 
            getVisible={visiblePopup}
            handlePopup={handlePopup}
            type={'settings'} 
            filter={null}
            message=""
        />
    </>);
}
