import React from 'react';
import { SafeAreaView } from 'react-native-safe-area-context';

import * as Style from './styles';

interface Props{
    navigation: any
}

export default function Welcome({navigation}: Props){

    return(<>
        <SafeAreaView
            edges={["top"]}
            style={{ flex: 0, backgroundColor: "#121214" }}
        />

        <Style.SafeContainer>
            <Style.LogoContainer animation="flipInY">
                <Style.Logo
                    source={require('../../assets/logo.png')}
                />
            </Style.LogoContainer>

            <Style.ContainerForm delay={600} animation="fadeInUp">
                <Style.LineTextContainer mt={20}>
                    <Style.TextForm>{'For each'}</Style.TextForm>
                    <Style.TextFormBold>{' look'}</Style.TextFormBold>
                </Style.LineTextContainer>

                <Style.LineTextContainer mt={0}>
                    <Style.TextForm>{'a'}</Style.TextForm>
                    <Style.TextFormBold>{' detail'}</Style.TextFormBold>
                </Style.LineTextContainer>

                <Style.ButtonAccess
                    activeOpacity={0.8}
                    onPress={()=> navigation.navigate('Login')}
                >
                    <Style.TextButton>
                        Acessar
                    </Style.TextButton>
                </Style.ButtonAccess>
            </Style.ContainerForm>
        </Style.SafeContainer>


        <SafeAreaView 
            edges={["bottom"]}
            style={{ flex: 0, backgroundColor: "#fff" }}
        />
    </>)
}