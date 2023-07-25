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

export const CardPrimaryDash = styled.div`
    top: 0px;
    margin:20px;
    position: absolute;
    display: flex;
    flex-direction: column;
    align-items:center;
    flex: 1;
`

export const IconPrimaryDash = styled.div`
    padding:10px;
    border-radius:100px;
    background-color:${(props) => props.theme.background};
    margin-bottom:5px;
    display: flex;
    justify-content:center;
    align-items:center;
`

export const TextDash = styled.div<{size: number}>`
    ${({ size }) => `font-size:${size}px`};
    color: ${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
    font-weight:bold;
`

export const TextLabelDash = styled.div<{size: number, color: string, fontWeight: number}>`
    ${({ size }) => `font-size:${size}px`};
    color: ${(props) => props.color};
    font-family: 'Roboto', sans-serif;
    font-weight: ${(props) => props.fontWeight};
    margin: 2px;
`

export const ContainerIconsDash = styled.div`
    display:flex;
    flex-direction:row;
    align-items:center;
    justify-content:center;
`

export const ContaineSecDash = styled.div`
    display:flex;
    flex-direction:row;
    align-items:center;
`

export const ContainerIconTextDash = styled.div`
    margin-top:10px;
`

export const IconSucessDash = styled(BsCartCheck)`
    color: #2dce89!important;
    filter:drop-shadow(0px 4px 4px rgba(45,206,137,.3));
    margin-right:10px;
`

export const IconRecentDash = styled(BsCart)`
    color: #4454c3!important;
    filter:drop-shadow(0px 4px 4px rgba(0,0,0, .3));
    margin-right:10px;
`


export const IconCanceledDash = styled(BsCartX)`
    color: #ff5b51!important;
    filter:drop-shadow(0px 4px 4px rgba(255,91,81,.3));
    margin-right:10px;
`

