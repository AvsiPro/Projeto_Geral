import styled from 'styled-components/native'

export const SafeContainer = styled.SafeAreaView`
    flex:1;
    background-color:#fff;
    align-items:center;
`

export const HeaderComponent = styled.View`
    background-color:${(props) => props.theme.colors.primary};
    height:16%;
    border-bottom-left-radius:50px;
    border-bottom-right-radius:50px;
    padding:25px;
    justify-content:space-between;
    align-items:flex-end;
    flex-direction:row;
    width:100%;
`

export const TextName = styled.Text<{size: number}>`
    color:#fff;
    ${({ size }) => `font-size:${size}px`};
    font-weight: ${props => props.size === 24 ? 500 : 200};
`

export const ProfileButton = styled.TouchableOpacity`
    border-radius:100px;
    height:50px;
    width:50px;
    background-color:#fff;
    justify-content:center;
    align-items:center;
`

export const ImageProfile = styled.Image`
    border-radius:100px;
    height:48px;
    width:48px;
`

export const TextProfileButton = styled.Text`
    font-weight:bold;
    font-size:16px;
`

export const ScrollMainContainer = styled.ScrollView`
    max-height:70%;
`

export const TextOffLine = styled.Text`
    color:tomato;
    font-weight:600;
    margin-top:5px;
`