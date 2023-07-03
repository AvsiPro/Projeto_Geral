import styled from 'styled-components/native';
import { StyleSheet } from 'react-native';

import { Camera } from 'expo-camera';

import * as Animatable from 'react-native-animatable'

export const styleSheet = StyleSheet.create({
    shadow:{
        shadowOffset: { width: 2, height: 2 },
        shadowColor: 'black',
        shadowOpacity: 0.1,
        elevation: 3,
      }
})

export const SafeAreaModals = styled.SafeAreaView`
    flex:1;
    background-color:#00000080;
    justify-content:flex-end;
`

export const SafeAreaPopups = styled.SafeAreaView<{center: boolean}>`
    flex:1;

    ${({center}) =>
        center && `
            background-color:#00000030;
            align-items:center;
            justify-content:center;
        `
    }
`

export const Popup = styled.View<{top: number, right: number}>`
    border-radius:20px;
    position:absolute;
    ${({ top }) => `top:${top}px`};
    ${({ right }) => `right:${right}px`};
    padding:15px;
    background-color:#fff;
`

export const PopupContainer = styled.TouchableOpacity<{border: boolean}>`
    flex-direction:row;
    align-items:center;
    border-bottom-width:${props => `${props.border ? 0 : 0.3}px`};
    border-color:grey;
`

export const PopupError = styled.View`
    border-radius:20px;
    padding:40px;
    background-color:#fff;
    align-items:center;
    justify-content:center;
    width:80%;
`

export const PopupCopyOrder = styled.View`
    border-radius:20px;
    padding-left:20px;
    padding-right:20px;
    padding-bottom:20px;
    background-color:#fff;
    align-items:center;
    justify-content:center;
    width:80%;
`

export const PopupErrorMessage = styled.Text`
    font-size:18px;
    text-align:center;
    font-weight:500;
    margin-top:25px;
`

export const PopupCopyMessage = styled.Text<{color: string}>`
    font-size:18px;
    text-align:center;
    font-weight:500;
    color:${(props) => props.color};
`

export const ButtonsPopUpCopy = styled.View`
    flex-direction:row;
    width:100%;
    justify-content:flex-end;
    margin-top:35px;
`

export const ButtonCopyOrderPopup = styled.TouchableOpacity<{background: string}>`
    border-width:2px;
    border-color:${(props) => props.theme.colors.primary};
    background-color:${(props) => props.background};
    border-radius:10px;
    padding:5px;
    padding-left:10px;
    padding-right:10px;
    margin-left:10px;
`

export const TextPopup = styled.Text`
    font-weight:500;
    margin-left:10px;
    margin:15px;
`

export const ModalContainer = styled.View`
    background-color:#fff;
    height:85%;
    border-top-right-radius:25px;
    border-top-left-radius:25px;
`

export const ModalHeader = styled.View`
    margin:22px;
    flex-direction:row;
    justify-content:space-between;
    align-items:center;
`

export const TextModalHeader = styled.Text`
    font-size:26px;
    color:${(props) => props.theme.colors.primary};
    font-weight:bold;
`

export const CloseModal = styled.TouchableOpacity`
    width:80px;
    align-items:flex-end;
`

export const MiddleModalContainer = styled.View`
    padding-left:22px;
    padding-right:22px;
`

export const MiddleModalText = styled.Text`
    font-size:16px;
    font-weight:600;
    color:grey;
`

export const ContainerItemsOrder = styled.View`
    flex:1;
    margin-top:20px;
    max-height:67%;
`

export const ContainerLineItemsOrder = styled.View<{backGround: boolean}>`
    padding-left:22px;
    padding-right:22px;
    padding-top:15px;
    padding-bottom:5px;
    background-color:${props => props.backGround ? 'rgba(66, 106, 208, 0.1)' : '#fff'};
`

export const ItemCodigoOrder = styled.Text`
    font-size:18px;
    color:${(props) => props.theme.colors.primary};
    font-weight:bold;
`

export const ItemDescOrder = styled.Text`
    font-size:16px;
    font-weight:600;
`

export const DropDownListContainer = styled.View`
    margin-top:10px;
    justify-content:space-between;
    align-items:center;
    flex-direction:row;
`

export const DropDownSection = styled.View`
    align-items:center;
`

export const DropDownHeaderSection = styled.Text`
    color:${(props) => props.theme.colors.primary};
    font-weight:600;
    font-size:16px;
`

export const DropDownItemSection = styled.Text`
    font-size:16px;
`

export const DropDownContainer = styled.TouchableOpacity<{backGround: boolean}>`
    justify-content:center;
    align-items:center;
    background-color:${props => props.backGround ? 'rgba(66, 106, 208, 0.1)' : '#fff'};
`

export const ModalContentFooter = styled.View`
    align-items:center;
`

export const FooterModalComponent = styled.View`
    bottom:20px;
    position: absolute;
    background-color:${(props) => props.theme.colors.primary};
    width:75%;
    height:55px;
    border-radius:40px;
    justify-content:space-around;
    align-items:center;
    flex-direction:row;
`

export const TextModalFooter = styled.Text`
    color:#fff;
    font-size:16px;
    font-weight:500;
`

export const ModalOrderContainer = styled.View`
    background-color:#F4F4F4;
    height:90%;
    border-top-right-radius:25px;
    border-top-left-radius:25px;
`

export const ModalCusRegCont = styled.View`
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

export const TopModalNewOrder = styled.View`
    justify-content:space-between;
    align-items:center;
    padding-left:20px;
    padding-right:20px;
    flex-direction:row;
    margin-top:20px;
    margin-bottom:30px;
`

export const ContainerSearchModal = styled.View`
    flex-direction:row;
    flex:1;
    margin-left:15px;
    margin-right:30px;
    justify-content:space-between;
    align-items:center;
    border-bottom-width:2px;
    border-color:${(props) => props.theme.colors.primary};
`

export const SearchNewOrderModal = styled.TextInput`
    font-weight:500;
    flex:1;
    padding:4px;
`

export const ButtonCloseModal = styled.TouchableOpacity`
    margin-left:20px;
    margin-right:10px;
`

export const TextDisconnected = styled.Text`
    font-size:14px;
    color:tomato;
    font-weight:500;
    margin:5px;
    text-align:center;
`

export const MiddleModalNewOrder = styled.View`
    flex:1;
`

export const ButtomCancelSelect = styled.TouchableOpacity`
    background-color:#FF8947;
    padding:5px;
    padding-left:12px;
    padding-right:12px;
    border-radius:12px;
    flex-direction:row;
    align-items:center;
    justify-content:space-around;
`

export const CountSelectProd = styled.Text`
    font-size:18px;
    font-weight:bold;
    color:#fff;
    margin-left:8px;
`

export const ComponentQRCode = styled.View`
    flex:2;
    margin-bottom:20px;
`

export const ComponentProductModal = styled.View`
    flex:1;
`

export const QRCodeScan = styled(Camera)`
    flex:1;
`

export const LoadingContent = styled.View`
    padding-left:20px;
    padding-right:20px;
`

export const BottomModalNewOrder = styled.View`
    padding-left:20px;
    padding-right:20px;
    padding-bottom:20px;
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
    border-color:#000;
    background-color:#000;
    padding:5px;
    border-radius:12px;
    align-items:center;
    justify-content:center;
    flex-direction:row;
`

export const ButtonFinishOrder = styled.TouchableOpacity`
    flex:2;
    border-width:2px;
    border-color:${(props) => props.theme.colors.primary};
    background-color:${(props) => props.theme.colors.primary};
    padding:5px;
    border-radius:12px;
    align-items:center;
    justify-content:center;
    margin-left:10px;
`

export const TextFooterOrder = styled.Text<{color: string}>`
    ${({ color }) => `color:${color}`};
    font-weight:bold;
    font-size:16px;
`

export const containerFormModal = styled(Animatable.View)`
    padding:15px;
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

export const ButtomSubmitLeft2 = styled.TouchableOpacity`
    padding: 15px;
    align-items: center;
    justify-content: center;
    background-color: #FF9F47;
    border-radius: 15px;
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

export const PopupPalette = styled.View`
    width: 150px;
    align-items:center;
`

export const PalletSections = styled.View`
    flex-direction:row;
    width:100%;
    justify-content:space-evenly;
    margin:5px;
`

export const PaletteColor = styled.TouchableOpacity<{color: string}>`
    ${({ color }) => `background-color:${color}`};
    width: 50px;
    height: 50px;
    border-radius:100px;
`

export const TextPalette = styled.Text`
    font-size:18px;
    font-weight:bold;
    margin-top:15px;
    margin-bottom:15px;
    text-align:center;
`

export const TopCardContainer = styled.View`
    flex-direction:row;
    align-items:center;
    justify-content:space-between;
`

export const ContainerChecked = styled.View`
    flex-direction:row;
    align-items:center;
    justify-content:space-between;
`

export const CodItemProdModal = styled.Text`
    font-size:18px;
    font-weight:bold;
`

export const DscItemProdModal = styled.Text<{color: string}>`
    margin-top:10px;
    margin-bottom:15px;
    font-size:14px;
    font-weight:500;
    ${({ color }) => `color:${color}`};
`

export const MiddleCardContainer = styled.View<{mt: number}>`
    flex-direction:row;
    justify-content:space-between;
    ${({ mt }) => `margin-top:${mt}px`};
`

export const MiddleCardText = styled.Text`
    font-size:14px;
    font-weight:500;
`

export const ModalItensContainer = styled.View`
    padding:25px;
`

export const ObservationsInput = styled.TextInput`
    height: 200px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 10px;
    margin: 10px;
`;