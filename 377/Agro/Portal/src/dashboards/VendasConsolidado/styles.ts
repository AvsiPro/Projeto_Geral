import styled, { css } from 'styled-components';
import { Card } from 'react-bootstrap';


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

export const TableComponent = styled.div<{windowDimensions: any, modal: boolean,isMobile?: boolean}>`
    background-color: #fff;
    padding: 20px;
    border-radius: 20px;
    overflow: auto;
    width: ${({ modal }) => (modal ? '100%' : 'auto')};
    max-height: ${({ windowDimensions }) => (windowDimensions.height * 85) / 100}px;
  
    ${({ isMobile, windowDimensions, modal }) => !modal &&
        css`
            max-width: ${isMobile ? windowDimensions.width : (windowDimensions.width * 80) / 100}px;
        `
    };

    ${({ isMobile, modal }) => (modal && isMobile ) &&
        css`
            padding:0px;
        `
    };
`;