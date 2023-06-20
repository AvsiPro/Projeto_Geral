import React, { useState, useEffect, useRef, useContext } from 'react';
import { Navigate } from 'react-router-dom';

import * as Style from './styles'

import Lottie, { AnimationItem } from 'lottie-web';
import animationData from '../assets/changepass.json'
import { useMediaQuery } from 'react-responsive';
import { UserContext } from '../contexts/userContext';
import api from '../services/api';
import { ClipLoader } from 'react-spinners';

const ChangePassWord: React.FC = () => {

  const { userContext, setUserContext } = useContext(UserContext)
  
  const [oldPass, setOldPass] = useState('')
  const [newPass, setNewPass] = useState('')
  const [confirmNewPass, setConfirmNewPass] = useState('')

  const [toLogin, setToLogin] = useState(false);
  const [load, setLoad] = useState(false);
  const [toDashboard, setToDashboard] = useState(false);
  const animationContainer = useRef<HTMLDivElement>(null);
  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

  useEffect(() => {
    const anim: AnimationItem = Lottie.loadAnimation({
      container: animationContainer.current!,
      renderer: 'svg',
      loop: true,
      autoplay: true,
      animationData: animationData,
    });
  
    return () => {
      anim.destroy();
    };
  }, []);


  if (toLogin === true) {
    return <Navigate to="/" />;
  }

  if (toDashboard === true) {
    return <Navigate to="/dashboard" />;
  }

  const handleUpdatePass = () => {

    if(userContext.password === oldPass){

      if(!newPass){
        alert('Digite a nova senha')
        return
      }

      if(!confirmNewPass){
        alert('Confirme a nova senha digitada')
        return
      }

      if(newPass === confirmNewPass) {

        if(newPass.trim() === userContext.password.trim()){
          alert('Nova senha digitada não pode ser a mesma que a anterior')
        }else{
          updatePass()
        }

      }else{
        alert('Confirmação de senha inválida')
      }
      
    }else{
      alert('Senha anterior incorreta')
    }

  }


  const updatePass = async() => {
    setLoad(true)

    try{
        const response = await api.post("/WSAPP06", {
            user: userContext.user,
            pass: userContext.password, 
            newpass: newPass
        });

        const receive = response.data;

        if (receive.status.code === '#200') {
          let userAux = {...userContext}

          userAux.password = newPass
          setUserContext(userAux)

          alert('Senha alterada com sucesso')
          
          setToLogin(true);

        } else {
            /*
            if (statusMessages[receive.status.message]) {
                setMessage(statusMessages[receive.status.message])
            } else {
                setMessage(statusMessages[receive.status.message])
            }

            handlePopup()
            */
        }
    
    } catch(error){
        console.log(error)

    }
    setLoad(false)
  }

  return (
    <Style.ChangePassBody>
      <div style={{flexDirection:'row', display:'flex'}}>
        <Style.ChangePassContainer isMobile={isMobile}>
          <Style.ChangePassTitle>
            Trocar Senha
          </Style.ChangePassTitle>

          <Style.ChangePassForm>
            <Style.ChangePassInput onChange={(change) => {setOldPass(change.target.value)}} type="password" placeholder="Senha anterior" />
            <Style.ChangePassInput onChange={(change) => {setNewPass(change.target.value)}} type="password" placeholder="Nova senha" />
            <Style.ChangePassInput onChange={(change) => {setConfirmNewPass(change.target.value)}} type="password" placeholder="Confirmar nova senha" />
            <Style.ChangePassButton onClick={handleUpdatePass}>
            { load ?
                  <ClipLoader
                    color={'#fff'}
                    loading={load}
                    size={22}
                  />
                : 'Alterar'
              }
            </Style.ChangePassButton>

            <Style.ChangePassButton2 onClick={() => setToDashboard(true) }>Cancelar</Style.ChangePassButton2>
          </Style.ChangePassForm>
        </Style.ChangePassContainer>

        {!isMobile &&        
          <Style.ChangePassContainerLogo>  
            <div ref={animationContainer} style={{ width: '300px', height: '300px' }}></div>
          </Style.ChangePassContainerLogo>
        }
      </div>
  </Style.ChangePassBody>
  )
};

export default ChangePassWord;