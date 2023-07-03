import styled from 'styled-components/native'
import * as Animatable from 'react-native-animatable'

export const SafeContainer = styled.SafeAreaView`
    flex:1;
    background-color: #121214;
    align-items:center;
`

export const LogoContainer = styled(Animatable.View)`
    flex:2;
    width:90%;
    align-items:center;
    justify-content:center;
    background-color: #121214;
`

export const Logo = styled.Image`
    width: 205px;
    height: 125px;
`

export const ContainerForm = styled(Animatable.View)`
    flex:1;
    background-color:#fff;
    width:100%;
    padding:5%;
    border-top-left-radius: 25px;
    border-top-right-radius: 25px;
    align-items:center;
`

export const TextForm = styled.Text`
    font-size:30px;
`

export const TextFormBold = styled.Text`
    font-size:30px;
    font-weight:bold;
`

export const LineTextContainer = styled.View<{mt: number}>`
    flex-direction:row;
    align-items:center;
    justify-content:center;
    ${({mt}) => `margin-top:${mt}px`};
`

export const ButtonAccess = styled.TouchableOpacity`
    position:absolute;
    border-radius:50px;
    padding-left:20px;
    padding-right:20px;
    padding-top:10px;
    padding-bottom:10px;
    background-color: #121214;
    align-self:center;
    align-items:center;
    justify-content:center;
    bottom:20%;
`

export const TextButton = styled.Text`
    color:#fff;
    font-size:18px;
    font-weight:bold;
`