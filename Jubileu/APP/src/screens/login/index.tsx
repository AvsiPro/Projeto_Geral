import React,{ useState, useRef, useContext } from 'react';
import { TextInput, ActivityIndicator } from 'react-native';

import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import { SafeAreaView } from 'react-native-safe-area-context';

import * as Style from './styles';

import api from '../../services/api';
import Popups from '../../modals/popups';

import { version } from '../../../version';
import { AppContext } from '../../contexts/globalContext';

interface Props{
    navigation: any
}

export default function Login({navigation}: Props){

    const { setAuthDetail } = useContext(AppContext);

    const [user, setUser] = useState('')
    const [pass, setPass] = useState('')
    const [message, setMessage] = useState('')
    const [load, setLoad] = useState(false)
    const [visiblePopup, setVisiblePopup] = useState(false)
    
    const passwordInputRef = useRef<TextInput>(null);
    
    const handleUserSubmit = () => {
        passwordInputRef.current?.focus();
    };

    const handlePopup = () =>{
        setVisiblePopup(!visiblePopup)
    }
    
    const statusMessages: Record<string, string> = {
        emptyuser: 'É necessário preencher o campo de usuário',
        emptypass: 'É necessário preencher o campo de senha',
        invaliduser: 'Usuário inválido',
        invalidpass: 'Senha inválida'
    };

    const handleAuth = async() => {
        setLoad(true)
        try{
            const response = await api.post("/WSAPP01", {
                user: user,
                pass: pass, 
            });

            const receive = response.data;

            if (receive.status.code === '#200') {
                setAuthDetail(receive.result)
                navigation.navigate('Home')

            } else {
                setMessage(statusMessages[receive.status.message])
                handlePopup()
            }
        
        } catch(error){
            setMessage('Erro ao logar, contate um administrador')
            handlePopup()
        }
        setLoad(false)
    }

    return(<>
        <SafeAreaView
            edges={["top"]}
            style={{ flex: 0, backgroundColor: "#121214" }}
        />
        <Style.SafeContainer>
            <Style.HeaderContainer
                animation="fadeInLeft"
                delay={500}
            >
                <Style.HeaderText>
                    Bem-vindo
                </Style.HeaderText>
            </Style.HeaderContainer>

            <Style.FormContainer
                animation="fadeInUp"
            >
                <KeyboardAwareScrollView>
                    <Style.InputArea>
                        <Style.InputContainer>
                            <Style.LabelInput>USUÁRIO</Style.LabelInput>
                            <Style.InputField
                                keyboardType='email-address'
                                ref={null as any}
                                autoCorrect={false}
                                autoCapitalize='none'
                                returnKeyType="next"
                                onChangeText={setUser}
                                onSubmitEditing={handleUserSubmit}
                                value={user}
                                style={Style.styleSheet.shadow}
                            >
                            </Style.InputField>
                        </Style.InputContainer>

                        <Style.InputContainer>
                            <Style.LabelInput>SENHA</Style.LabelInput>
                            <Style.InputField
                                ref={passwordInputRef}
                                autoCorrect={false}
                                autoCapitalize='none'
                                returnKeyType="done"
                                onSubmitEditing={handleAuth}
                                onChangeText={setPass}
                                value={pass}
                                secureTextEntry={true}
                                style={Style.styleSheet.shadow}
                            >
                            </Style.InputField>
                        </Style.InputContainer>
                        
                        <Style.ButtonSubmit
                            onPress={() => handleAuth()}
                            style={Style.styleSheet.shadow}
                            activeOpacity={0.8}
                        >
                            { load ?
                                <ActivityIndicator color={'#fff'} />
                            :
                                <Style.TextSubmit>Entrar</Style.TextSubmit>
                            }

                        </Style.ButtonSubmit>

                    </Style.InputArea>
                </KeyboardAwareScrollView>
                
                <Style.ContainerVresion>
                    <Style.LabelVersion>{version}</Style.LabelVersion>
                </Style.ContainerVresion>
                
            </Style.FormContainer>
        </Style.SafeContainer>

        <Popups 
            getVisible={visiblePopup}
            handlePopup={handlePopup}
            type={'error'}
            filter={null}
            message={message}
        />

        <SafeAreaView 
            edges={["bottom"]}
            style={{ flex: 0, backgroundColor: "#fff" }}
        />
    </>)
}