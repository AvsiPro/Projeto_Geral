import styled from 'styled-components';
import { Popover } from 'react-bootstrap';

/** geral **/
export const TextH1 = styled.h1`
    color:${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
`

export const TextH2 = styled.h2`
    color:${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
`

export const TextH3 = styled.h3`
    color:${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
`

export const TextH4 = styled.h4`
    color:${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
`

export const TextLabel = styled.label`
    color:${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
`


/** popover **/
export const PopoverComponent = styled(Popover)`
    background-color:${(props) => props.theme.component};
    padding:20px;
    border-radius:20px;
    color:${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
    display: flex;
    flex-direction:column;
    align-items:center;
    box-shadow:0px 10px 20px rgba(0, 0, 0, 0.4);
`

export const PopoverProfileComponent = styled(Popover)`
    background-color:${(props) => props.theme.component};
    color:${(props) => props.theme.text};
    padding:20px;
    font-family: 'Roboto', sans-serif;
    display: flex;
    flex-direction:column;
    min-width:300px;
    max-width:400px;
    box-shadow:0px 10px 20px rgba(0, 0, 0, 0.1);
`

export const PopoverProfileHeader = styled.div`
    background-color:${(props) => props.theme.component};
    color:${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
    display: flex;
    flex-direction:row;
    justify-content:space-between;
    align-items:center;
    width:100%;
`

export const PopoverProfileBody = styled.div`
    background-color:${(props) => props.theme.component};
    color:${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
    width:100%;
    margin-top:20px;
    display: flex;
    flex-direction:row;
    align-items:center;
`

export const PopoverProfileDesc = styled.div`
    display: flex;
    flex-direction:column;
    align-items:flex-start;
    justify-content:center;
    margin-left:10px;
`

export const PopOverProfileImg = styled.button`
    background-color:transparent;
    color:${(props) => props.theme.text};
    border: none;
    cursor: pointer;
    border-radius:50px;
    width:100px;
    height:100px;
`

export const PopOverProfileClose = styled.button`
    background-color:transparent;
    border: none;
    cursor: pointer;
`

export const PopoverTextLabel = styled.label<{size: number}>`
    color:${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
    font-weight:bold;
    ${({ size }) => `font-size:${size}px`};
`

export const PopoverButton = styled.button`
    background-color:transparent;
    color:${(props) => props.theme.text};
    border: none;
    cursor: pointer;
    width:100%;
    height:100%;
    display:flex;
    align-items:center;
    margin-left:5px;
`

export const PopoverHeaderProfile = styled.button`
    background-color:transparent;
    border: none;
    cursor: pointer;
    font-weight:500;
    font-family: 'Roboto', sans-serif;
    font-size:16px;
    border-radius:8px;
    color: ${(props) => props.theme.text};
    display:flex;
    align-items:center;
    margin-left:5px;

    &:hover {
        color: ${(props) => props.theme.primary};
    }
`

export const PopoverEmptyProfileImg = styled.div`
    width: 90px;
    height: 90px;
    border-radius: 50px;
    display:flex;
    align-items:center;
    justify-content:center;
    background-color:${(props) => props.theme.text};
`

export const PopoverTextEmptyImg = styled.label`
    color:${(props) => props.theme.component};
    font-family: 'Roboto', sans-serif;
    font-weight:bold;
    font-size:24px;
`

export const PopoverSearchComponent = styled(Popover)<{windowDimensions: any}>`
    background-color:${(props) => props.theme.text};
    color:${(props) => props.theme.component};
    font-family: 'Roboto', sans-serif;
    display: flex;
    flex-direction:column;

    ${({ windowDimensions }) => `
        max-width:${(windowDimensions.width * 60) / 100}px
    `};

    ${({ windowDimensions }) => `
        max-height:${(windowDimensions.height * 60) / 100}px
    `};

    box-shadow:0px 10px 20px rgba(0, 0, 0, 0.1);
    overflow: auto;
`

export const PopoverSearchHeader = styled.div`
    background-color:${(props) => props.theme.text};
    color:${(props) => props.theme.component};
    font-family: 'Roboto', sans-serif;
    display: flex;
    flex-direction:row;
    justify-content:space-between;
    padding-left:20px;
    padding-right:20px;
    padding-top:10px;
    align-items:center;
    width:100%;
`

export const PopOverSearchClose = styled.button`
    background-color:transparent;
    border: none;
    cursor: pointer;
`

export const PopoverSearchBody = styled.div`
    background-color:${(props) => props.theme.text};
    color:${(props) => props.theme.component};
    font-family: 'Roboto', sans-serif;
    width:100%;
    display: flex;
    flex-direction:row;
    align-items:center;
    flex-wrap:wrap;
`

export const PopoverDeleteOrderTools = styled.div`
    display: flex;
    flex-direction:row;
    justify-content:space-between;
    width:100%;
    margin-top:10px;
`

export const PopoverButtonDeleteOrder = styled.button`
    background-color:transparent;
    color:${(props) => props.theme.text};
    cursor: pointer;
    border: 1px solid #ccc;
    width:100%;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:18px;
    margin:5px;

    &:hover {
        background-color: ${(props) => props.theme.primary};
    }
`