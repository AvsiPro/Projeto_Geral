import React, { useContext, useState } from "react";

import { ThemeContext } from "../contexts/ThemeContext";
import { Navigate } from 'react-router-dom';

import Button from 'react-bootstrap/Button';

import { BsMoonStarsFill, BsSunFill, BsBoxSeam} from "react-icons/bs"
import { AiOutlineHome, AiOutlineShoppingCart, AiOutlineSafety } from 'react-icons/ai';
import { RiContactsLine, RiLockPasswordLine, RiLogoutBoxLine, RiDashboardLine } from 'react-icons/ri';
import { TbFileInvoice, TbFileDollar } from 'react-icons/tb';
import { useMediaQuery } from 'react-responsive';

import ModalComponent from "./modal";

import { darkTheme, lightTheme } from "../themes";

import * as Style from './styles'; 
import { UserContext } from "../contexts/userContext";

const Navbar: React.FC = () => {

  const { userContext } = useContext(UserContext)
  
  const [navigate, setNavigate] = useState('')
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const [showModal, setShowModal] = useState(false);
  const { theme, toggleTheme } = useContext(ThemeContext);
  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

  const toggleDropdown = () => {
    setIsDropdownOpen(!isDropdownOpen);
  };

  const themeAux = theme === 'dark' ? darkTheme : lightTheme

  if (!!navigate && window.location.pathname !== navigate) {
    return <Navigate to={navigate} />;
  }

  const colorIcon = (link: string) => {
    return window.location.pathname === link ? themeAux.primary :'#fff'
  }

  const navSeller = [
    {
      label: 'HOME',
      pages: [
        {
          title: 'DashBoard',
          link: '/dashboard',
          icon: <RiDashboardLine size={25} color={colorIcon('/dashboard')}/>
        }
      ]
    },
    {
      label: 'CADASTROS',
      pages: [
        {
          title: 'Clientes',
          link: '/customers',
          icon: <RiContactsLine size={20} color={colorIcon('/customers')}/>
        },
        {
          title: 'Produtos',
          link: '/products',
          icon: <BsBoxSeam size={20} color={colorIcon('/products')}/>
        }
      ]
    },
    {
      label: 'MOVIMENTOS',
      pages: [
        {
          title: 'Pedidos',
          link: '/orders',
          icon: <AiOutlineShoppingCart size={22} color={colorIcon('/orders')}/>
        }
      ]
    },
    {
      label: 'UTILITÁRIOS',
      pages: [
        {
          title: 'Trocar Senha',
          link: '/changepassword',
          icon: <RiLockPasswordLine size={20} color={'#fff'}/>
        },
        {
          title: 'Sair',
          link: '/',
          icon: <RiLogoutBoxLine size={20} color={'#fff'}/>
        }
      ]
    }
  ]

  const navCustomer = [
    {
      label: 'HOME',
      pages: [
        {
          title: 'Página Inicial',
          link: '/home',
          icon: <AiOutlineHome size={22} color={colorIcon('/home')}/>
        }
      ]
    },
    {
      label: 'MOVIMENTOS',
      pages: [
        {
          title: 'Produtos',
          link: '/products',
          icon: <BsBoxSeam size={20} color={colorIcon('/products')}/>
        },
        {
          title: 'Títulos',
          link: '/financialcustomer',
          icon: <TbFileDollar size={25} color={colorIcon('/financialcustomer')}/>
        },
        {
          title: 'Faturamento',
          link: '/invoicescustomer',
          icon: <TbFileInvoice size={25} color={colorIcon('/invoicescustomer')}/>
        },
        {
          title: 'Pedidos',
          link: '/orders',
          icon: <AiOutlineShoppingCart size={22} color={colorIcon('/orders')}/>
        }
      ]
    },
    {
      label: 'FORMULÁRIOS',
      pages: [
        {
          title: 'Garantia',
          link: '/warrantycustomer',
          icon: <AiOutlineSafety size={22} color={'#fff'}/>
        }
      ]
    },
    {
      label: 'UTILITÁRIOS',
      pages: [
        {
          title: 'Trocar Senha',
          link: '/changepassword',
          icon: <RiLockPasswordLine size={20} color={'#fff'}/>
        },
        {
          title: 'Sair',
          link: '/',
          icon: <RiLogoutBoxLine size={20} color={'#fff'}/>
        }
      ]
    }
  ]

  const navItems = userContext.type === 'V' ? navSeller : navCustomer

  const handleClickMenu = async(item: any) => {
    if(item.title === 'Sair'){

      const cartData = localStorage.getItem('cartdata');
      const cart = cartData ? JSON.parse(cartData) : [];
      
      if(cart.length > 0){
        setShowModal(true)
      }else{
        setNavigate(item.link)
      }

    }else{
      setNavigate(item.link)
    }
  }

  const fSair = () => {
      setShowModal(false)
      localStorage.clear();
      setNavigate('/')
  }

  const ItensMenu = () => {
    return (
      <>
        {navItems.map((item: any, index: number) => {
          return (
            <Style.NavSubMenuComponent key={index}>
              <Style.NavLabel>{item.label}</Style.NavLabel>
              {item.pages.map((subItem: any, subIndex: number) => {
                return (
                  <Style.NavButtonsContainer key={subIndex}>
                    {subItem.icon}
                    <Style.NavButtonMenu
                      color={
                        window.location.pathname === subItem.link
                          ? themeAux.primary
                          : '#fff'
                      }
                      onClick={() => handleClickMenu(subItem)}
                    >
                      {subItem.title}
                    </Style.NavButtonMenu>
                  </Style.NavButtonsContainer>
                );
              })}
            </Style.NavSubMenuComponent>
          );
        })}
      </>
    );
  };

  const ToogleIcon = () => {
    return(
      <Style.NavBottomSection>
        <Style.NavLabel>LIGHT</Style.NavLabel>
        
        <Style.NavToggleContainer
            onClick={toggleTheme}
            theme={theme}
        >
          <Style.NavToggleIcon theme={theme}>
              { theme === 'light' 
                ? <BsSunFill />
                : <BsMoonStarsFill />
              }
          </Style.NavToggleIcon>
        </Style.NavToggleContainer>

        <Style.NavLabel>DARK</Style.NavLabel>
      </Style.NavBottomSection>
    )
  }

  const BodyModal = (
    <>
    <Style.TextH4 style={{color:'red'}}>Ao sair o pedido em digitação será perdido.</Style.TextH4>
    <Style.TextH4 style={{color:'#212121'}}>Deseja realmente sair?</Style.TextH4>
    </>
  )

  const ToolsModal = (
    <>
      <Button variant="outline-danger" onClick={() => setShowModal(false)}>Cancelar</Button>
      <Button variant="outline-primary" onClick={fSair} >Sair</Button>
    </>
  )
  
  return (
    <>
    
    { isMobile ?
      <>
       <Style.NavMenuIconOpen onClick={toggleDropdown} color={themeAux.text} />
        
        {isDropdownOpen && (
          <Style.NavMobileMenuWrapper>
            <div>
              <Style.NavMenuIconClose onClick={toggleDropdown} color="#fff" />
              <Style.NavMobileMenuContent>
                <ItensMenu />
              </Style.NavMobileMenuContent>
            </div>

            <ToogleIcon />
          </Style.NavMobileMenuWrapper>
        )}
      </>
    :

    <Style.NavContainer>
      <Style.NavTopSection>
        <img
          width={120}
          style={{marginBottom:50, marginTop:10}}
          src={require('../assets/logo.png')}
        />
    
        <ItensMenu />
      </Style.NavTopSection>

      <ToogleIcon />
      
    </Style.NavContainer>

    }

  <ModalComponent
        show={showModal}
        onHide={() => setShowModal(false)}
        title='Atenção'
        Body={BodyModal}
        Tools={ToolsModal}
    />
</>);
};

export default Navbar;
