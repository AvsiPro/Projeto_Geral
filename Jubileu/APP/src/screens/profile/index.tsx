import React, { useContext } from "react";

import { SafeAreaView } from "react-native-safe-area-context";

import * as Style from "./styles";

import { AppContext, ThemeContext } from '../../contexts/globalContext';

import { getInitials, capitalize, firstAndLastName, capitalizeNoWarap } from "../../utils/nameFormat";
import { phoneFormat } from "../../utils/phoneFormat";
import { View } from "react-native";

import { Entypo } from '@expo/vector-icons';
import { useNavigation } from "@react-navigation/native";

import * as ImagePicker from 'expo-image-picker';

import AsyncStorage from "@react-native-async-storage/async-storage";

export default function Profile() {

    const { authDetail, imageProfile, setImageProfile } = useContext(AppContext);
    const { colors } = useContext(ThemeContext);
    const navigation: any = useNavigation();

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

    return (<>
        <SafeAreaView
            edges={["top"]}
            style={{ flex: 0, backgroundColor: colors.primary }}
        />
        <Style.SafeContainer>

            <Style.HeaderComponent>
                <Style.TopHeaderContainer>
                    <Style.IconContainer onPress={()=> navigation.goBack()}>
                        <Entypo name="chevron-left" size={30} color="white" />
                    </Style.IconContainer>

                    <Style.TextHeaderTop>
                        Perfil
                    </Style.TextHeaderTop>

                    <View />
                </Style.TopHeaderContainer>


                <Style.ProfileContainer>
                    <Style.ProfileComponent>
                        <Style.Profile onPress={pickImage}>
                            
                            { imageProfile ? 
                                <Style.ImageProfile source={{ uri: imageProfile }} />
                            :
                                <Style.ProfileText>
                                    {getInitials(authDetail.name)}
                                </Style.ProfileText>
                            }
                            
                        </Style.Profile>
                    </Style.ProfileComponent>

                    <Style.NameComponent>
                        <Style.HeaderText>
                            {capitalize(firstAndLastName(authDetail.name))}
                        </Style.HeaderText>
                    </Style.NameComponent>
                </Style.ProfileContainer>
            </Style.HeaderComponent>

            <Style.InfosContainer>
                <Style.DetailsContainer>
                    <Style.LabelText>Telefone: </Style.LabelText>
                    <Style.DetailText>{phoneFormat(authDetail.phone)}</Style.DetailText>
                </Style.DetailsContainer>

                <Style.Separador />

                <Style.DetailsContainer>
                    <Style.LabelText>E-Mail: </Style.LabelText>
                    <Style.DetailText>{authDetail.email}</Style.DetailText>
                </Style.DetailsContainer>

                <Style.Separador />

                <Style.DetailsContainer>
                    <Style.LabelText>Endereço: </Style.LabelText>
                    <Style.DetailText>{capitalizeNoWarap(authDetail.address)}</Style.DetailText>
                </Style.DetailsContainer>
            </Style.InfosContainer>

        </Style.SafeContainer>

        <SafeAreaView
            edges={["bottom"]}
            style={{ flex: 0, backgroundColor: "#fff" }}
        />
    </>);
}
