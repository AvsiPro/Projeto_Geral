import React, { useState, useContext } from 'react';
import { Navigate } from 'react-router-dom';

import * as Style from './styles'
import { useMediaQuery } from 'react-responsive';
import ClipLoader from "react-spinners/ClipLoader";

import { UserContext } from '../contexts/userContext';

import api from '../services/api';
import { AlertComponent } from '../components/alerts';

const Login: React.FC = () => {

  const { setUserContext } = useContext(UserContext)
  
  const [toDashboard, setToDashboard] = useState(false);
  const [user, setUser] = useState('')
  const [pass, setPass] = useState('')
  const [load, setLoad] = useState(false)
  const [showAlert, setShowAlert] = useState(false)
  const [message, setMessage] = useState('')

  const statusMessages: Record<string, string> = {
    emptyuser: 'É necessário preencher o campo de usuário',
    emptypass: 'É necessário preencher o campo de senha',
    invaliduser: 'Usuário inválido',
    invalidpass: 'Senha inválida'
  };

  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

  if (toDashboard === true) {
    return <Navigate to="/dashboard" />;
  }

  const handleAuth = async() => {
    setLoad(true)

    try{
        const response = await api.post("/WSAPP01", {
            user: user,
            pass: pass, 
        });

        const receive = response.data;

        if (receive.status.code === '#200') {
          setToDashboard(true)
          setUserContext(receive.result)
          localStorage.setItem('userdata', JSON.stringify(receive.result));

        } else {
          setMessage(statusMessages[receive.status.message])
          setShowAlert(!showAlert)
        }
    
    } catch(error){
        console.log(error)
        setMessage('Erro ao autenticar, consulte um administrador')
        setShowAlert(!showAlert)

    }
    setLoad(false)
  }

  const handlePasswordChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setPass(event.target.value);
  };

  const handleShowAlert = () => {
    setShowAlert(!showAlert)
  }

  return (
    <Style.LoginBody>
      {isMobile &&
        <img width={180} style={{marginBottom:30}} src={require('../assets/logo.png')} />
      }
      
      <div style={{flexDirection:'row', display:'flex'}}>
        <Style.LoginContainer isMobile={isMobile}>
          <Style.LoginTitle>
            Login
          </Style.LoginTitle>

          <Style.LoginForm>
            <Style.LoginInput onChange={(change)=> setUser(change.target.value)} value={user} type="text" placeholder="Username" autoComplete="username"/>
            <Style.LoginInput onChange={handlePasswordChange} value={pass} type="password" placeholder="Password" autoComplete="current-password"/>
            <Style.LoginButton onClick={handleAuth}>
              { load ?
                  <ClipLoader
                    color={'#fff'}
                    loading={load}
                    size={22}
                  />
                : 'Login'
              }
            </Style.LoginButton>

            <Style.LoginButton2 onClick={() => {}}>Esqueceu a senha?</Style.LoginButton2>
          </Style.LoginForm>
        </Style.LoginContainer>

        { !isMobile &&
          <Style.LoginContainerLogo>
            <img width={220} src={require('../assets/logo.png')} />
          </Style.LoginContainerLogo>
        }
      </div>

      <AlertComponent
        header='Falha na autenticação'
        body={message}
        textButton='Fechar'
        type='danger'
        showAlert={showAlert}
        handleShowAlert={handleShowAlert}
      />
  </Style.LoginBody>
  )
};

export default Login;