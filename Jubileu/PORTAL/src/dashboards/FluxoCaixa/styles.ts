import styled from 'styled-components';
import { Card } from 'react-bootstrap';
import { BsCartCheck, BsCart, BsCartX } from 'react-icons/bs';

export const Container = styled.div<{isMobile ?: boolean}>`
    flex:1;
    ${({ isMobile }) => !isMobile && `
        padding-left:15px;
        padding-right:15px;
        padding-bottom:15px;
    `};
`

export const CardDash = styled(Card)`
    box-shadow:0px 10px 20px rgba(0, 0, 0, 0.2);
    background-color:${(props) => props.theme.component};
    display: flex;
    flex-direction:column;
    justify-content:flex-end;
`

export const CardDashBody = styled(Card.Body)`
    display: flex;
    flex-direction:column;
    justify-content:center;
`


export const TextDash = styled.div<{size: number}>`
    ${({ size }) => `font-size:${size}px`};
    color: ${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
    font-weight:bold;
`