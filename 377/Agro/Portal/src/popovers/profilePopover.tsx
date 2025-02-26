import React, { useContext, useState } from 'react';
import { OverlayTrigger } from 'react-bootstrap';

import { ThemeContext } from '../contexts/ThemeContext';
import { darkTheme, lightTheme } from '../themes';

import { AiOutlineCloseCircle } from 'react-icons/ai'

import { phoneFormat } from '../utils/phoneFormat';
import { firstAndLastName, capitalize, getInitials } from '../utils/nameFormat';

import * as Style from './styles'
import { UserContext } from '../contexts/userContext';

const ProfilePopover: React.FC = () => {
    const { theme } = useContext(ThemeContext);
    const { userContext } = useContext(UserContext)

    const [show, setShow] = useState(false);

    const handleClick = () => {
        setShow(!show);
    };

    const PopOverAux = (
        <Style.PopoverProfileComponent id="Profile">
            <Style.PopoverProfileHeader>
                <Style.PopoverTextLabel size={18}>Perfil</Style.PopoverTextLabel>

                <Style.PopOverProfileClose onClick={handleClick}>
                    <AiOutlineCloseCircle
                        style={{width:20, height:20}}
                        color={theme === 'dark' ? darkTheme.text : lightTheme.text}
                    />
                </Style.PopOverProfileClose>
            </Style.PopoverProfileHeader>

            <Style.PopoverProfileBody>
                <Style.PopOverProfileImg onClick={handleClick}>

                    {/*
                        <Figure.Image
                            width={100}
                            height={100}
                            src={require('../assets/avatar.jpg')}
                            style={{borderRadius:50}}
                        />
                    */}

                    <Style.PopoverEmptyProfileImg>
                        <Style.PopoverTextEmptyImg>
                            {getInitials(firstAndLastName(userContext.name))}
                        </Style.PopoverTextEmptyImg>
                    </Style.PopoverEmptyProfileImg>

                </Style.PopOverProfileImg>
                
                <Style.PopoverProfileDesc>
                    <Style.PopoverTextLabel size={18}>{capitalize(firstAndLastName(userContext.name))}</Style.PopoverTextLabel>
                    <Style.PopoverTextLabel size={14}>{userContext.email}</Style.PopoverTextLabel>
                    <Style.PopoverTextLabel size={14}>{phoneFormat(userContext.phone)}</Style.PopoverTextLabel>
                </Style.PopoverProfileDesc>
            </Style.PopoverProfileBody> 
        </Style.PopoverProfileComponent>
    )
    
    return(
        <OverlayTrigger
            show={show}
            placement="bottom-end"
            overlay={PopOverAux}
        >   
                <Style.PopoverHeaderProfile onClick={handleClick}>
                    {`Olá, ${capitalize(firstAndLastName(userContext.name))}`}
                </Style.PopoverHeaderProfile>
        </OverlayTrigger>
    );
}
export default ProfilePopover;