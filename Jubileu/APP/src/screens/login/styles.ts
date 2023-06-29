import styled from 'styled-components/native'
import { StyleSheet } from 'react-native';

import * as Animatable from 'react-native-animatable'

interface InputProps {
    ref: any;
  }

export const styleSheet = StyleSheet.create({
    shadow:{
        shadowOffset: { width: 2, height: 2 },
        shadowColor: 'black',
        shadowOpacity: 0.1,
        elevation: 3,
      }
})

export const SafeContainer = styled.SafeAreaView`
    flex:1;
    background-color:#121214;
`

export const HeaderContainer = styled(Animatable.View)`
    margin-top:14%;
    margin-bottom:8%;
    padding-left:5%;

`

export const HeaderText = styled.Text`
    font-size:28px;
    font-weight:bold;
    color:#fff;
`

export const FormContainer = styled(Animatable.View)`
    background-color:#fff;
    flex:1;
    border-top-left-radius:25px;
    border-top-right-radius:25px;
    padding-left:5%;
    padding-right:5%;
`

export const InputContainer = styled.View`
    margin-top:25px;
`

export const InputArea = styled.View`
    margin-top:25px;
`

export const LabelInput = styled.Text`
    font-weight:600;
    font-size:12px;
`

export const InputField = styled.TextInput<InputProps>`
    margin-top:5px;
    background-color:#f2f2f2;
    border-radius:15px;
    padding:15px;
    height:50px;
`

export const ButtonSubmit = styled.TouchableOpacity`
    background-color:#121214;
    margin-left:90px;
    margin-right:90px;
    border-radius:20px;
    padding:10px;
    align-items:center;
    justify-content:center;
    height:45px;
    margin-top:30px;
`

export const TextSubmit = styled.Text`
    color:#fff;
    font-weight:bold;
    font-size:20px;
`

export const ContainerVresion = styled.View`
    width:100%;
    align-items:center;
    justify-content:center;
    margin-bottom:30px;
`

export const LabelVersion = styled.Text`
    font-weight:600;
    font-size:12px;
`