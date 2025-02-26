import React from 'react';
import { OverlayTrigger, Button } from 'react-bootstrap';

import * as Style from './styles'

interface Props {
  handleClick: (event: string) => void;
}

const DeleteOrderPopover: React.FC<Props> = ({ handleClick }) => {

    const PopOverCustomer = (
        <Style.PopoverComponent id="Customers">
            <Style.TextH4>Deseja realmente descartar o pedido?</Style.TextH4>
            
            <Style.PopoverDeleteOrderTools>
                <Style.PopoverButtonDeleteOrder onClick={() => handleClick('no')}>
                    Não
                </Style.PopoverButtonDeleteOrder>

                <Style.PopoverButtonDeleteOrder onClick={() => handleClick('yes')}>
                    Sim
                </Style.PopoverButtonDeleteOrder>
            </Style.PopoverDeleteOrderTools>
        </Style.PopoverComponent>
    )
    
    return(
        <OverlayTrigger
            trigger={[ 'focus']}
            placement="top-end"
            overlay={PopOverCustomer}
        >   
            <Button variant="outline-danger">Descartar Pedido</Button>
        </OverlayTrigger>
    );
}
export default DeleteOrderPopover;
