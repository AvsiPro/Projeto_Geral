import styled from 'styled-components/native';
import { StyleSheet } from 'react-native';
import {Animated} from 'react-native';

export const styleSheet = StyleSheet.create({
    shadow:{
        shadowOffset: { width: 2, height: 2 },
        shadowColor: 'black',
        shadowOpacity: 0.1,
        elevation: 3,
      }
})

export const FooterComponent = styled.View`
    bottom:40px;
    position: absolute;
    background-color:${(props) => props.theme.colors.primary};
    width:75%;
    height:55px;
    border-radius:40px;
    justify-content:space-around;
    align-items:center;
    flex-direction:row;
`

export const ButtonFooter = styled.TouchableOpacity`
    width:50px;
    height:55px;
    justify-content:center;
    align-items:center;
`

export const ButtonAddFooter = styled.TouchableOpacity`
    bottom:20px;
    background-color:#fff;
    border-radius:100px;
    width:55px;
`

export const ScrollSections = styled.ScrollView`
    height:320px;
    margin-left:15px;
`

export const ItemService = styled.TouchableOpacity<{backgroundColor: string}>`
    height:90%;
    width:220px;
    border-radius:30px;
    padding:30px;
    margin-right:15px;
    align-items:center;
    justify-content:space-between;
    ${({ backgroundColor }) => `background-color:${backgroundColor}`};
`

export const NameService = styled.Text`
    font-size:24px;
    font-weight:600;
`

export const MainIndicatorSections = styled.View`
    flex-direction:row;
    align-items:center;
    margin-left:20px;
    margin-right:20px;
    margin-bottom:10px;
`

export const IndicatorSections = styled(Animated.View)<{backgroundColor: string}>`
    ${({ backgroundColor }) => `background-color:${backgroundColor}`};
    height:8px;
    border-radius:4px;
    margin-left:4px;
    margin-right:4px;
`

export const MainIndicatorGraphics = styled.View`
    flex-direction:row;
    align-items:center;
`

export const IndicatorGraphics = styled(Animated.View)<{backgroundColor: string}>`
    ${({ backgroundColor }) => `background-color:${backgroundColor}`};
    height:8px;
    border-radius:4px;
    margin-left:4px;
    margin-right:4px;
    top:22px;
`

export const GraphicContainer = styled.View<{windowHeight: number}>`
    height:500px;
    ${({ windowHeight }) => `height:${windowHeight}px`};
`

export const GraphicSections = styled.View`
    width:100%;
    align-items:center;
`

export const TitleSection = styled.Text<{margin: number}>`
    font-size:22px;
    font-weight:600;
    ${({ margin }) => `margin:${margin}px`};
`

export const HeaderGraphics = styled.View`
    margin-left:20px;
    margin-right:20px;
`

export const ContainerProdModal = styled.TouchableOpacity`
    background-color:#fff;
    padding:12px;
    border-radius:20px;
    margin-bottom:12px;
    margin-left:20px;
    margin-right:20px;
`

export const ContainerProdModal2 = styled.TouchableOpacity`
    background-color:#fff;
    padding:12px;
    border-radius:20px;
    margin-bottom:12px;
    margin-left:20px;
    margin-right:20px;
    flex-direction:row;
`

export const LeftContainerProdModal = styled.View`
    flex:2;
    width:100%;
`

export const RightContainerProdModal = styled.View`
    flex:1;
    width:100%;
    justify-content:center;
    align-items:center;
`

export const TopCardContainer = styled.View`
    flex-direction:row;
    align-items:center;
    justify-content:space-between;
`

export const CodItemProdModal = styled.Text`
    font-size:18px;
    font-weight:bold;
`

export const DscItemProdModal = styled.Text<{color: string}>`
    font-size:14px;
    font-weight:500;
    ${({ color }) => `color:${color}`};
`

export const MiddleCardContainer = styled.View<{mt: number}>`
    flex-direction:row;
    justify-content:space-between;
    ${({ mt }) => `margin-top:${mt}px`};
`

export const MiddleCardContainer2 = styled.View<{mt: number}>`
    justify-content:space-between;
    ${({ mt }) => `margin-top:${mt}px`};
`

export const MiddleCardText = styled.Text`
    font-size:14px;
    font-weight:500;
`

export const ContainerChecked = styled.View`
    flex-direction:row;
    align-items:center;
    justify-content:space-between;
`

export const EmptyListContProd = styled.View`
    align-items:center;
`

export const EmptyListTextProd = styled.Text`
    font-size:18px;
    font-weight:500;
    margin-top:20px;
    text-align:center;
`

export const ElipseCartFooter = styled.View`
    background-color:tomato;
    width:8px;
    height:8px;
    border-radius:16px;
    top:2px;
    left:10px;
    z-index:9999;
`

export const ContainerCartFooter = styled.View`
`

export const ContainerClietModal = styled.TouchableOpacity`
    background-color:#fff;
    padding:12px;
    border-radius:20px;
    margin-bottom:12px;
    margin-left:20px;
    margin-right:20px;
`

export const ContainerPayModal = styled.TouchableOpacity`
    background-color:#fff;
    padding:12px;
    border-radius:20px;
    margin-bottom:12px;
    margin-left:20px;
    margin-right:20px;
`

export const NameCustomer = styled.Text`
    font-size:18px;
    color:${(props) => props.theme.colors.primary};
    font-weight:bold;
`

export const CodePayment = styled.Text`
    font-size:16px;
    color:${(props) => props.theme.colors.primary};
    font-weight:bold;
`

export const BottomCardClientContainer = styled.View`
    margin-top:15px;
`

export const BottomCardPaymentContainer = styled.View`
    margin-top:10px;
`

export const BottomCardClientText = styled.Text`
    font-size:14px;
    font-weight:600;
`


export const BottomCardPaymentText = styled.Text`
    font-size:14px;
    font-weight:600;
`

export const LoadingContent = styled.View`
    padding-left:20px;
    padding-right:20px;
`

export const ContainerFormCustomer = styled.View`
    flex: 1;
    background-color: #F4F5f6;
    width:100%;
`;


export const ContainerFinancial = styled.View`
    flex:1;
    padding-top:20px;
    padding-bottom:20px;
`

export const HeaderFinancial = styled.View`
    flex-direction:row;
    justify-content:space-between;
    align-items:center;
    padding-left:15px;
    padding-right:15px;
`

export const TitleFinancial = styled.Text`
    font-size:18px;
    font-weight:bold;
    color:${(props) => props.theme.colors.primary};
`

export const SubTitleFinancial = styled.Text`
    font-size:18px;
    font-weight:bold;
    color:#FF932F;
    margin-top:20px;
    margin-bottom:30px;
    padding-left:15px;
    padding-right:15px;
    width:85%;
`

export const ContainerItemFinancial = styled.TouchableOpacity<{backGround: boolean}>`
    padding-left:15px;
    padding-right:15px;
    padding-top:15px;
    padding-bottom:15px;
    background-color:${props => props.backGround ? 'rgba(66, 106, 208, 0.1)' : 'transparent'};
    justify-content:flex-end;
`

export const TitleItemFinancial = styled.Text`
    font-size:14px;
    font-weight:bold;
`

export const TextItemFinancial = styled.Text`
    font-size:13px;
`

export const StatusItemFinancial = styled.Text<{color: string}>`
    font-size:13px;
    color:${(props) => props.color};
`

export const TextButtonFinancial = styled.Text`
    font-size:13px;
    color:white;
    font-weight:500;
`

export const ContainerItensFinancial = styled.View`
    flex-direction:row;
    margin-top:20px;
    justify-content:space-around;
`

export const SectionColumnFinancial = styled.View`
    align-items:center;
`

export const ContainerHorizFinancial = styled.View`
    flex-direction:row;
    width:100%;
    justify-content:space-between;
`

export const ContainerVencFinancial = styled.View`
    flex-direction:row;
`

export const ButtonFinancial = styled.TouchableOpacity`
    background-color:${(props) => props.theme.colors.primary};
    align-items:center;
    justify-content:center;
    padding:6px;
    border-radius:6px;
    margin-left:10px;
`

export const ButtonContinue = styled.TouchableOpacity`
    background-color:${(props) => props.theme.colors.primary};
    align-items:center;
    justify-content:center;
    padding:10px;
    border-radius:6px;
    margin-left:20%;
    margin-right:20%;
    margin-top:20px;
`

export const ButtonContainerFinancial = styled.View`
    flex-direction:row;
    justify-content:flex-end;
    margin-top:20px;
`

export const ImageContainer = styled.View`
    flex: 1;
    align-items: center;
    justify-content: center;
    width:100%;
`

export const ImageArea = styled.Image<{height: number, width: number}>`
    width:${(props) => `${props.width}px`};
    height:${(props) => `${props.height}px`};
    overflow:hidden;
`
