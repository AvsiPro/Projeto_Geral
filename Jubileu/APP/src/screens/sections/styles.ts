import styled from 'styled-components/native'
import { StyleSheet } from 'react-native';

import * as Animatable from 'react-native-animatable'

export const styleSheet = StyleSheet.create({
    shadow:{
        shadowOffset: { width: 2, height: 2 },
        shadowColor: 'black',
        shadowOpacity: 0.1,
        elevation: 1,
      }
})

export const SafeContainer = styled.SafeAreaView`
    flex:1;
    align-items:center;
`

export const HeaderComponent = styled.View`
    background-color:${(props) => props.theme.colors.primary};
    height:16%;
    border-bottom-left-radius:50px;
    border-bottom-right-radius:50px;
    padding:25px;
    justify-content:flex-end;
    width:100%;
`

export const HeaderContainer = styled.View`
    justify-content:space-between;
    align-items:center;
    flex-direction:row;
`

export const SearchComponent = styled.View`
    background-color:#fff;
    border-radius:30px;
    width:85%;
    align-items:center;
    flex-direction:row;
    justify-content:space-between;
    padding-right:35px;
`

export const InputField = styled.TextInput`
    padding:10px;
    padding-left:20px;
    padding-right:20px;
    height:45px;
    width:100%;
    font-size:16px;
`

export const ButtonFilter = styled.TouchableOpacity`
`

export const ContainerList = styled.View`
    flex:1;
    width:100%;
    max-height:70%;
    margin-top:20px;
`

export const ContainerListProducts = styled.View`
    flex:1;
    width:100%;
    max-height:70%;
    margin-top:20px;
`

export const ContainerListCustomers = styled.View`
    flex:1;
    width:100%;
    max-height:70%;
    margin-top:20px;
`

export const ContainerItemOrder = styled.TouchableOpacity`
    background-color:#fff;
    margin-bottom:10px;
    padding:15px;
    border-radius:30px;
    margin-right:12px;
    margin-left:12px;
`

export const HeaderItemOrder = styled.View`
    flex-direction:row;
    justify-content:space-between;
    align-items:center;
`

export const CodigoOrder = styled.Text`
    color:${(props) => props.theme.colors.primary};
    font-weight:bold;
    font-size:16px;
`

export const DateOrderContainer = styled.View`
    flex-direction:row;
`

export const TextDateOrder = styled.Text<{color: string}>`
    font-size:12px;
    font-weight:500;
    ${({ color }) => `color:${color}`};
`

export const MiddleTextOrder = styled.View`
    width:100%;
    margin-top:12px;
`

export const TextClienteMiddle = styled.Text`
    font-size:14px;
    font-weight:bold;
`

export const TextStatusMiddle = styled.Text`
    font-size:12px;
    font-weight:500;
    color:#FF9F47;
`

export const DownTextOrder = styled.View`
    width:100%;
    margin-top:12px;
    flex-direction:row;
    justify-content:space-between;
`

export const DownOrderContainer = styled.View`
    flex-direction:row;
`

export const TextCgcOrder = styled.Text<{color: string}>`
    font-size:12px;
    font-weight:500;
    ${({ color }) => `color:${color}`};
    opacity:0.9;
`

export const TextOffLine = styled.Text`
    font-size:14px;
    color:tomato;
    font-weight:500;
    margin:5px;
    text-align:center;
`

export const NewOrderHeader = styled.View`
    padding:18px;
    width:100%;
    flex-direction:row;
    align-items:center;
`

export const ArrowContainer = styled.TouchableOpacity`
    flex:1;
`

export const TextHeaderNOrder = styled.Text`
    flex:2;
    color: #fff;
    font-weight:bold;
    font-size:18px;
`

export const CliPayHeader = styled.TouchableOpacity`
    width:90%;
    margin:10px;
    flex-direction:row;
`

export const ClienteText = styled.Text`
    color: #fff;
    font-weight:bold;
    font-size:16px;
    margin-right:5px;
`

export const NewOrderContainer = styled(Animatable.View)`
    background-color:#fff;
    border-top-left-radius:25px;
    border-top-right-radius:25px;
    padding-left:5%;
    padding-right:5%;
    padding:25px;
    width:100%;
    flex:3;
`

export const ItemNOrderContainer = styled.View`
    flex-direction:row;
    justify-content:space-between;
    margin-bottom:30px;
    align-items:center;
`

export const CodItemNOrder = styled.Text`
    font-size:18px;
    font-weight:bold;
`

export const DescItemNOrder = styled.Text`
    font-size:14px;
    font-weight:500;
    color:grey;
`

export const CountContainer = styled.View`
    align-items:center;
`

export const CountItemContainer = styled.View`
    flex-direction:row;
    justify-content:center;
    align-items:center;
`

export const ButtonCount = styled.TouchableOpacity`
    width:30px;
    height:30px;
    border-radius:60px;
    background-color:${(props) => props.theme.colors.primary};
    justify-content:center;
    align-items:center;
`

export const TextCountItem = styled.Text`
    font-size:16px;
    font-weight:bold;
    margin-left:5px;
    margin-right:5px;
`

export const ContainerAddMore = styled.TouchableOpacity`
    flex-direction:row;
    align-items:center;
`

export const TextAddMore = styled.Text`
    color:${(props) => props.theme.colors.primary};
    font-size:16px;
    font-weight:bold;
    margin-left:5px;
`

export const KeyboardFoorterArea = styled.KeyboardAvoidingView`
    width:100%;
    flex:1;
`

export const FooterOrderContainer = styled.View`
    flex:1;
    background-color:#f9f9f9;
    padding-left:5%;
    padding-right:5%;
    padding-bottom:25px;
    padding-top:10px;
    width:100%;
    justify-content:center;
`

export const TextFooterOrder = styled.Text<{color: string}>`
    ${({ color }) => `color:${color}`};
    font-weight:bold;
    font-size:16px;
`

export const TotalsFooterOrder = styled.View<{mt: number}>`
    flex-direction:row;
    justify-content:space-between;
    ${({ mt }) => `margin-top:${mt}px`};
    width:100%;
`

export const ButtonClearOrder = styled.TouchableOpacity`
    flex:1;
    border-width:2px;
    border-color:${(props) => props.theme.colors.primary};
    padding:5px;
    border-radius:12px;
    align-items:center;
    justify-content:center;
    flex-direction:row;
`

export const ButtonFinishOrder = styled.TouchableOpacity`
    flex:2;
    border-width:2px;
    border-color:#000;
    background-color:#000;
    padding:5px;
    border-radius:12px;
    align-items:center;
    justify-content:center;
    margin-left:10px;
`

export const EmptyListContProd = styled.View`
    align-items:center;
`

export const ContainerDesconto = styled.View`
    flex-direction:row;
`

export const DescontoInput = styled.TextInput`
    font-size:16px;
    border-bottom-width:2px;
    width:20%;
    bottom:5px;
    left:5px;
    border-color: #FF932F;
    color: #FF932F;
    text-align:center;
    font-weight:bold;
`

export const SwipeableOrderContainer = styled.TouchableOpacity`
    align-items:center;
    justify-content:center;
    margin-right:15px;
`

export const SwipeableOrderText = styled.Text`
    font-weight:bold;
    margin-top:3px;
`

export const LoadingContent = styled.View`
    padding-left:20px;
    padding-right:20px;
`

export const EmptyListTextProd = styled.Text`
    font-size:18px;
    font-weight:500;
    margin-top:20px;
    text-align:center;
`

export const containerFormModal = styled(Animatable.View)`
`

export const containerFormModal1 = styled.View`
    padding:20px;
`

export const ContainerButtonSubmit = styled.View`
    align-items:center;
    justify-content:space-evenly;
    flex-direction:row;
    margin-top:10px;
`
export const ButtomSubmitLeft = styled.TouchableOpacity`
    padding: 15px;
    align-items: center;
    justify-content: center;
`;

export const ButtomSubmitRight = styled.TouchableOpacity`
    padding: 15px;
    align-items: center;
    justify-content: center;
    background-color: ${(props) => props.theme.colors.primary};
    border-radius: 15px;
`;

export const ButtomSubmitTitle = styled.Text<{color: string}>`
    font-size: 16px;
    ${({ color }) => `color:${color}`};
    font-weight:bold;
`;

export const SafeAreaModals = styled.SafeAreaView`
    flex:1;
    background-color:#00000080;
    justify-content:flex-end;
`

export const ModalOrderContainer = styled.View`
    background-color:#F4F4F4;
    height:100%;
    border-top-right-radius:25px;
    border-top-left-radius:25px;
`

export const KeyBoardFormCustomer = styled.KeyboardAvoidingView`
    background-color:#F4F4F4;
    border-top-right-radius:25px;
    border-top-left-radius:25px;
`