import styled, {css} from 'styled-components';
import { Stack, Card } from 'react-bootstrap';
import { BsCartCheck, BsCart, BsCartX } from 'react-icons/bs';

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

/** login **/

export const LoginBody = styled.div`
    display: flex;
    flex-direction: column;
    justify-content:center;
    align-items:center;
    height:100vh;
    background-color:${(props) => props.theme.background};
`

export const LoginContainer = styled.div<{isMobile: boolean}>`
    background-color:#fff;
    padding:40px;
    border-top-left-radius:30px;
    border-bottom-left-radius:30px;
    min-width:400px;

    ${({ isMobile }) =>
        isMobile &&
        css`
          min-width:0px;
          padding:25px;
          border-radius:30px;
        `
    };
`

export const LoginContainerLogo = styled.div`
    background-color:#202024;
    padding:40px;
    border-top-right-radius:30px;
    border-bottom-right-radius:30px;
    align-items:center;
    justify-content:center;
    display:flex;
    min-width:400px;
`

export const LoginTitle = styled.h1`
  font-size: 2rem;
  margin-bottom: 2rem;
  font-family: 'Roboto', sans-serif;
  color: #202024;
`;

export const LoginForm = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 300px;
`;

export const LoginInput = styled.input`
  width: 100%;
  margin-bottom: 1rem;
  padding: 0.5rem;
  font-size: 1rem;
  border: none;
  border-bottom: 1px solid #ccc;
  font-family: 'Roboto', sans-serif;
  background-color: #fff;

  &:focus {
    outline: none;
    border-bottom: 2px solid #ffaf0f;
  }
`;

export const LoginButton = styled.button`
  width: 100%;
  padding: 0.5rem;
  margin-top: 1rem;
  border: none;
  border-radius: 5px;
  background-color: #ffaf0f;
  color: #fff;
  font-size: 1rem;
  cursor: pointer;
  font-weight:bold;
`;

export const LoginButton2 = styled.button`
    background-color:#fff;
    border: none;
    cursor: pointer;
    margin-top: 0.5rem;
    font-weight:500;
`


/** dashboard **/
export const ContainerAll = styled.div`
    display:flex;
    height:100vh;
    background-color:${(props) => props.theme.background};
`

export const Container = styled.div<{isMobile ?: boolean}>`
    flex:1;
    ${({ isMobile }) => !isMobile && `
        padding-left:15px;
        padding-right:15px;
        padding-bottom:15px;
    `};
`

export const StackDash = styled(Stack)<{windowDimensions: any}>`
    padding-top:20px;
    padding-left:50px;
    padding-right:50px;
    padding-bottom:50px;
    overflow:auto;
    
    ${({ windowDimensions }) => `
        max-height:${(windowDimensions.height * 90) / 100}px
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



/** customers **/
export const CustComponent = styled.div`
    display:flex;
    height:100vh;
    background-color:${(props) => props.theme.background};
`

export const CustTableComponent = styled.div`
    background-color:#fff;
    padding:30px;
    margin:50px;
    border-radius:20px;
`

/** orders **/
export const OrderComponent = styled.div`
    display:flex;
    height:100vh;
    background-color:${(props) => props.theme.background};
`

/** Change Password **/

export const ChangePassBody = styled.div`
    display: flex;
    flex-direction: column;
    justify-content:center;
    align-items:center;
    height:100vh;
    background-color:${(props) => props.theme.background};
`

export const ChangePassContainer = styled.div<{isMobile: boolean}>`
    background-color:#fff;
    padding:40px;
    border-top-left-radius:30px;
    border-bottom-left-radius:30px;
    min-width:400px;

    ${({ isMobile }) =>
        isMobile &&
        css`
          min-width:0px;
          padding:25px;
          border-radius:30px;
        `
    };
`

export const ChangePassContainerLogo = styled.div`
    background-color:#202024;
    padding:40px;
    border-top-right-radius:30px;
    border-bottom-right-radius:30px;
    align-items:center;
    justify-content:center;
    display:flex;
    min-width:400px;
`

export const ChangePassTitle = styled.h1`
  font-size: 2rem;
  margin-bottom: 2rem;
  font-family: 'Roboto', sans-serif;
  color: #202024;
`;

export const ChangePassForm = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 300px;
`;

export const ChangePassInput = styled.input`
  width: 100%;
  margin-bottom: 1rem;
  padding: 0.5rem;
  font-size: 1rem;
  border: none;
  border-bottom: 1px solid #ccc;
  font-family: 'Roboto', sans-serif;
  background-color: #fff;

  &:focus {
    outline: none;
    border-bottom: 2px solid #ffaf0f;
  }
`;

export const ChangePassButton = styled.button`
  width: 100%;
  padding: 0.5rem;
  margin-top: 1rem;
  border: none;
  border-radius: 5px;
  background-color: #ffaf0f;
  color: #fff;
  font-size: 1rem;
  cursor: pointer;
  font-weight:bold;
`;

export const ChangePassButton2 = styled.button`
    background-color:#fff;
    border: none;
    cursor: pointer;
    margin-top: 0.5rem;
    font-weight:500;
`

/** Input **/
export const InputWrapper = styled.div`
    display: flex;
    align-items: center;
    border: 1px solid #ccc;
    border-radius: 10px;
    padding: 6px;
`;

export const InputField = styled.input`
    flex: 1;
    border: none;
    outline: none;
    font-size: 14px;
    padding: 2px;
    width:100%;
`;

/** Customers Component **/
export const CustomersComponent = styled.div<{windowDimensions: any, modal: boolean,isMobile?: boolean}>`
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