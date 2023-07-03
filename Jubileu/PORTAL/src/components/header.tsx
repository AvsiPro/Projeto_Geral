import React, { useContext, useState } from "react";
import * as Style from './styles';

import { BiChevronDown } from 'react-icons/bi'
import { AiOutlineShoppingCart, AiOutlineBell } from 'react-icons/ai';

import { Navigate } from 'react-router-dom';

import { ThemeContext } from '../contexts/ThemeContext';
import { darkTheme, lightTheme } from '../themes';

import { getInitials, firstAndLastName } from "../utils/nameFormat";

import ProfilePopover from "../popovers/profilePopover";
import { CartContext } from "../contexts/CartContext";
import { useMediaQuery } from 'react-responsive';

import Navbar from "./navbar";

import { UserContext } from "../contexts/userContext";

const Header: React.FC = () => {
    const { theme } = useContext(ThemeContext);
    
    const { cartContext } = useContext(CartContext);
    const { userContext } = useContext(UserContext)

    const [navigate, setNavigate] = useState('')
    const isMobile = useMediaQuery({ query: '(max-width: 767px)' });
    const themeAux = theme === 'dark' ? darkTheme : lightTheme

    if (!!navigate && window.location.pathname !== navigate) {
        return <Navigate to={navigate} />;
    }

    return (
        <Style.HeaderContainer>

            {isMobile 
                ? <Navbar/>
                : <div></div>
            }
            
            <Style.HeaderRightIcons>
                
                <Style.HeaderButtonCart onClick={() => cartContext.length > 0 && setNavigate('/orders')}>
                    { cartContext.length > 0 &&
                        <Style.HeaderElipseNotify />
                    }

                    <AiOutlineShoppingCart
                        size={22}
                        color={themeAux.text} 
                    />
                </Style.HeaderButtonCart>
                

                <Style.HeaderProfileImg>
                    <Style.HeaderProfileText>
                        {getInitials(firstAndLastName(userContext.name))}
                    </Style.HeaderProfileText>
                </Style.HeaderProfileImg>

                <ProfilePopover/>
                <BiChevronDown
                    style={{width:18, height:18}}
                    color={theme === 'dark' ? darkTheme.text : lightTheme.text}
                />
            </Style.HeaderRightIcons>
        </Style.HeaderContainer>

    );
};

export default Header;
