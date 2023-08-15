import { Card } from 'react-bootstrap';
import styled, {css} from 'styled-components';

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

export const TextDash = styled.div<{size: number, weight: string}>`
    ${({ size }) => `font-size:${size}px`};
    color:${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
    font-weight:${(props) => props.weight};;
    margin-bottom:5px;
`

export const ContHorizontal = styled.div`
    display: flex;
    flex-direction:row;
    align-items:flex-start;
    justify-content:space-between;

`

export const ContVertical = styled.div`
    display: flex;
    flex-direction:column;
    align-items:center;
    justify-content:center;
`

export const Elipse = styled.div`
    background-color:#aaf;
    width:50px;
    height:50px;
    border-radius:25px;
`

export const Separator = styled.hr`
    height:2px;
    background-color:#fff;
`