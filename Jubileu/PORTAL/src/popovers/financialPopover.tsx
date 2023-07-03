import React, { useContext } from 'react';
import { OverlayTrigger } from 'react-bootstrap';

import { BsThreeDots } from 'react-icons/bs'
import { TbFileDollar } from 'react-icons/tb'
import { ThemeContext } from '../contexts/ThemeContext';
import { darkTheme, lightTheme } from '../themes';

import * as Style from '../components/styles'

interface Props {
  handleFinancialClick: (item: any) => void;
  item: any;
}

const FinancialPopover: React.FC<Props> = ({ handleFinancialClick, item }) => {
    const { theme } = useContext(ThemeContext);

    const PopOverCustomer = (
        <Style.PopoverComponent id="Customers">
            <Style.PopOverButton onClick={() => handleFinancialClick(item)}>
                <TbFileDollar
                    size={22}
                    style={{marginRight:5}}
                    color={theme === 'dark' ? darkTheme.text : lightTheme.text} 
                /> 
                Títulos
            </Style.PopOverButton>
        </Style.PopoverComponent>
    )
    
    return(
        <OverlayTrigger
            trigger={[ 'focus']}
            placement="bottom-start"
            overlay={PopOverCustomer}
        >   
            <Style.TableButtonAction>
                <BsThreeDots
                    style={{width:20, height:20}}
                    color={theme === 'dark' ? darkTheme.primary : lightTheme.primary}
                /> 
            </Style.TableButtonAction>
        </OverlayTrigger>
    );
}
export default FinancialPopover;
