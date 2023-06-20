import styled from 'styled-components/native'

export const SafeContainer = styled.SafeAreaView`
    flex:1;
    background-color:#fff;
    align-items:center;
`

export const HeaderContainer = styled.View`
    margin-top:14%;
    margin-bottom:8%;

`

export const HeaderComponent = styled.View`
    background-color:${(props) => props.theme.colors.primary};
    height:32%;
    border-bottom-right-radius:100px;
    padding:25px;
    justify-content:space-between;
    align-items:flex-end;
    width:100%;
`

export const ProfileComponent = styled.View`
    flex:1;
`

export const Profile = styled.TouchableOpacity`
    background-color:#fff;
    border-radius: 45px;
    width:90px;
    height:90px;
    justify-content:center;
    align-items:center;
`

export const ImageProfile = styled.Image`
    border-radius: 100px;
    width:86px;
    height:86px;
`

export const NameComponent = styled.View`
    flex:2;
`

export const HeaderText = styled.Text`
    color:#fff;
    font-size:28px;
    font-weight:bold;
`

export const ProfileText = styled.Text`
    color:${(props) => props.theme.colors.primary};
    font-size:30px;
    font-weight:bold;
`

export const ProfileContainer = styled.View`
    align-items:center;
    flex-direction:row;
`

export const TopHeaderContainer = styled.View`
    width:100%;
    flex-direction:row;
    align-items:center;
    justify-content:space-between;
`

export const IconContainer = styled.TouchableOpacity`
`

export const TextHeaderTop = styled.Text`
    color: #fff;
    font-weight:bold;
    font-size:18px;
    margin-right:30px;
`

export const InfosContainer = styled.View`
    flex:1;
    width:88%;
    margin-top:30px;
`

export const DetailsContainer = styled.View`
    width:100%;
    padding:10px;
    border-color:#ccc;
`

export const LabelText = styled.Text`
    font-size:18px;
    color:#ccc;
    font-weight:500;
`

export const DetailText = styled.Text`
    font-size:22px;
    color:#212121;
    font-weight:bold;
    margin-top:3px;
`

export const Separador = styled.View`
    width: 100%;
    border: 0.5px;
    border-color:#ccc;
    margin-top:15px;
    margin-bottom:15px;
`