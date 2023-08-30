import styled, {css} from 'styled-components';
import { Popover, Alert } from 'react-bootstrap';
import { RxHamburgerMenu } from "react-icons/rx"
import { CgClose } from 'react-icons/cg';

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


/** navbar **/
export const NavContainer = styled.nav`
    background-color:#202024;
    padding:16px;
    width:250px;
    align-items:center;
    display:flex;
    flex-direction:column;
    justify-content:space-between;
`

export const NavTopSection = styled.div`
    width: 100%;
    display:flex;
    flex-direction:column;
    align-items:center;
`

export const NavBottomSection = styled.div`
    width: 100%;
    display:flex;
    flex-direction:row;
    align-items:center;
    justify-content:center;
`

export const NavLabel = styled.label`
    color: #fff;
    opacity:0.6;
    font-weight:500;
    font-size:14px;
    font-family: 'Roboto', sans-serif;
`

export const NavSubMenuComponent = styled.div`
    margin-bottom:20px;
    width:100%;
`

export const NavButtonsContainer = styled.div`
    display:flex;
    flex-direction:row;
    align-items:center;
    width:100%;
    margin:15px;
`

export const NavButtonMenu = styled.button<{color: string}>`
    background-color:transparent;
    border: none;
    cursor: pointer;
    font-weight:500;
    font-family: 'Roboto', sans-serif;
    font-size:18px;
    width:100%;
    height:100%;
    color:${(props) => props.color};
    display:flex;
    align-items:center;
    margin-left:5px;

    &:hover {
        color: ${(props) => props.theme.primary};
    }
`

export const NavToggleContainer = styled.div<{theme: any}>`
  width: 80px;
  height: 40px;
  border-radius: 20px;
  background-color: ${props => (props.theme === 'dark' ? 'hsl(198,90%,15%)' : 'hsl(48,90%,85%)')};
  position: relative;
  cursor: pointer;
  margin: 10px;
`;

export const NavToggleIcon = styled.div<{theme: any}>`
  width: 30px;
  height: 30px;
  background-color: ${props => (props.theme === 'dark' ? '#0071e2' : '#FDB813')};
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 18px;
  color: #fff;
  position: absolute;
  top: 50%;
  left: ${props => (props.theme === 'dark' ? 'calc(100% - 36px)' : '6px')};
  transform: translateY(-50%);
  transition: left 0.3s ease-in-out;
`;


export const ToggleDiscount = styled.div<{rule: boolean}>`
  width: 70px;
  height: 35px;
  border-radius: 20px;
  background-color: ${props => (props.rule ? '#FDB813' : '#000')};
  position: relative;
  cursor: pointer;
  margin: 10px;
`;

export const ToggleIconDiscount = styled.div<{rule: boolean}>`
  width: 25px;
  height: 25px;
  background-color: #fff;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 18px;
  color: #fff;
  position: absolute;
  top: 50%;
  left: ${props => (props.rule ? 'calc(100% - 30px)' : '6px')};
  transform: translateY(-50%);
  transition: left 0.3s ease-in-out;
`;

export const DiscountHoriz = styled.div`
    display: flex;
    flex-direction:row;
    align-items:center;
`

export const NavMenuIconOpen = styled(RxHamburgerMenu)`
  cursor: pointer;
  width: 25px;
  height: 25px;

`;

export const NavMenuIconClose = styled(CgClose)`
  cursor: pointer;
  margin-left:22px;
  margin-right:22px;
  margin-top:22px;
  width: 25px;
  height: 25px;
`;


export const NavMobileMenuWrapper = styled.div`
  position: fixed;
  top: 0;
  left: 0;
  width: 60%;
  height: 100%;
  background-color:#202024;
  z-index: 9999; /* Garanta que o menu seja exibido acima de outros elementos */
  display:flex;
    flex-direction:column;
    justify-content:space-between;
`;

export const NavMobileMenuContent = styled.div`
  padding: 20px;
`;


/** header **/
export const HeaderContainer = styled.div`
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin:20px;
    margin-right:3%;
`

export const HeaderRightIcons = styled.div`
    display:flex;
    flex-direction:row;
    align-items:center;
`

export const HeaderProfileImg = styled.div`
    width: 30px;
    height: 30px;
    border-radius:15px;
    display: flex;
    align-items:center;
    justify-content: center;
    background-color: ${(props) => props.theme.text};
    margin-left:10px;
`

export const HeaderProfileText = styled.label`
    font-size:12px;
    font-weight:bold;
    color: ${(props) => props.theme.component};
`

export const HeaderButtonCart = styled.button`
    background-color:transparent;
    border: none;
    cursor: pointer;
`

export const HeaderButtonNoti = styled.button`
    background-color:transparent;
    border: none;
    cursor: pointer;
`

export const HeaderElipseNotify = styled.div`
    width: 10px;
    height: 10px;
    border-radius:5px;
    background-color:tomato;
    position: absolute;
    margin-left:14px;
`

/** modal **/
export const ButtonModal = styled.button <{backgroundColor: string, color: string}>`
    padding:8px 16px;
    font-weight:bold;
    border:none;
    cursor:pointer;
    border-radius:5px;
    margin:3px;
    ${({ backgroundColor }) => `
        background-color:${backgroundColor}
    `};
    ${({ color }) => `
        color:${color}
    `};
`

export const ModalOverlay = styled.div`
    background-color: rgba(0, 0, 0, 0.2); /* Fundo desfocado ou mais escuro */
    position: fixed;
    top: 0px;
    right: 0px;
    bottom: 0px;
    left: 0px;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
`

export const ModalContent = styled.div<{theme: any}>`
    background-color: ${(props) => props.theme.table};
    padding-left: 16px;
    padding-right: 16px;
    padding-bottom: 16px;
    width: 400px;
    text-align: center;
    border-radius:20px;
    border-radius:20px;
    box-shadow:0px 10px 20px rgba(0, 0, 0, 0.4);
`

export const ModalButtonContent = styled.div`
    display:flex;
    justify-content:flex-end;
    margin-top:20px;
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
    color:${(props) => props.theme.text};
    border: none;
    cursor: pointer;
`

export const PopoverTextLabel = styled.label<{size: number}>`
    color:${(props) => props.theme.text};
    font-family: 'Roboto', sans-serif;
    font-weight:bold;
    ${({ size }) => `font-size:${size}px`};
`

export const PopOverButton = styled.button`
    background-color:transparent;
    color:${(props) => props.theme.text};
    border: none;
    cursor: pointer;
    width:100%;
    height:100%;
    display:flex;
    align-items:center;
    margin-left:5px;
    font-weight:bold;
`

/** table **/
export const TableComponent = styled.div<{windowDimensions: any, modal: boolean,isMobile?: boolean, popover: boolean}>`
    background-color: #fff;
    padding: 20px;
    border-radius: ${({ popover }) => (popover ? '0px' : '20px')};
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
  
  
export const TableWrapper = styled.div<{windowDimensions: any}>`
    border-collapse: collapse;
`

export const TableHeader = styled.th<{ textAlign?: string }>`
    padding: 10px;
    text-align: ${({ textAlign }) => textAlign || 'left'};
    font-weight: bold;
    font-size: 14px;
    border: 1px solid #ccc;
    cursor: pointer;
    resize: horizontal;
`;

export const TableData = styled.td<{ textAlign?: string, width?: string }>`
    padding: 10px;
    text-align: ${({ textAlign }) => textAlign || 'left'};
    border: 1px solid #ccc;
    width: ${({ width }) => width || 'auto'};
    font-family: 'Roboto', sans-serif;
    font-size:14px;
`;

export const TableRow = styled.tr`
    cursor: pointer;
`;

export const TableGenderRow = styled.div`
    flex-direction:row;
    align-items:center;
    display: flex;
`

export const TableSortColumn = styled.div<{action: boolean, width?: string}>`
    cursor: pointer;
    display: flex;
    flex-direction:row;
    align-items:center;
    justify-content: ${({ action }) => action ? 'center' : 'space-between'};
    width: ${({ width }) => width || 'auto'};
`

export const TableButtonAction = styled.button`
    background-color:transparent;
    border: none;
    cursor: pointer;
`

export const ToolsContainer = styled.div<{ modal: boolean, isMobile: boolean }>`
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: ${({ modal }) => (modal ? '0px' : '20px')};
    margin-bottom: 10px;

    ${({ isMobile }) =>
        isMobile &&
        css`
            flex-direction: column;
            width: 100%;
            align-items: flex-start;
        `
    };
`;

/** SearchInput **/
export const InputWrapper = styled.div`
    display: flex;
    align-items: center;
    border: 1px solid #ccc;
    border-radius: 10px;
    padding: 6px;
    width: 200px;
`;

export const InputField = styled.input`
    flex: 1;
    border: none;
    outline: none;
    font-size: 14px;
    padding: 2px;
`;

/** alerts **/

export const AlertContainer = styled(Alert)`
    position: absolute;
    z-index:9999;
    top:20px;
    right:20px;
    min-width:500px;
`

/** Lottie Animation **/
export const LottieContainer = styled.div`
    display: flex;
    justify-content:center;
    align-items:center;
`

export const LottieItem = styled.div<{width: number, height: number}>`
    ${({ width }) => `width:${width}px`};
    ${({ height }) => `height:${height}px`};
`

/** bodyOrderModal **/
export const BodyOrderContainer = styled.div<{isMobile: boolean}>`
    display: flex;
    flex-direction:row;
    flex-wrap:wrap;
    align-items:center;
    padding-left:20px;
    padding-right:20px;

    ${({ isMobile }) =>
        isMobile &&
        css`
            padding-left:2px;
            padding-right:2px;
        `
    };
`

export const BodyOrderInputItem = styled.div <{width: number}>`
    margin:5px;
    ${({ width }) => `width:${width}px`};
`

export const BodyOrderItensModal = styled.div<{windowDimensions: any, isMobile: boolean}>`
    flex:1;
    display:flex;
    flex-wrap:wrap;
    overflow:auto;
    width:100%;
    ${({ windowDimensions }) => `
        max-height:${(windowDimensions.height * 60) / 100}px
    `};

    padding-left:5px;
    padding-right:5px;
`

export const BodyOrderInputWrapper = styled.div`
    display: flex;
    align-items: center;
    border: 1px solid #ccc;
    border-radius: 10px;
    padding: 6px;
`;

export const BodyOrderInputField = styled.input`
    flex: 1;
    border: none;
    outline: none;
    font-size: 14px;
    padding: 2px;
    width:100%;
`;

export const BodyOrderContainerItens = styled.div<{isMobile: boolean}>`
    display: flex;
    flex-direction:column;
    width:100%;
    padding-left:20px;
    padding-right:20px;
    padding-top:20px;

    ${({ isMobile }) =>
        isMobile &&
        css`
            padding-left:2px;
            padding-right:2px;
        `
    };
`

export const BodyOrderProducts = styled.div`
    display:flex;
    flex-direction:row;
    align-items:center;
    justify-content:space-between;
    margin-bottom:20px;
`

export const BodyOrderProductContainer = styled.div`
    flex:4;
    display:flex;
    flex-direction:column;
`

export const BodyOrderQtyTools = styled.div`
    flex:1;
    display:flex;
    align-items:center;
    justify-content:center;
`

export const BodyOrderQtyPriceTools = styled.div`
    display:flex;
    flex-direction:column;
    align-items:center;
    justify-content:center;
`

export const BodyOrderProductCode = styled.label`
    font-size:18px;
    font-weight:bold;
    font-family: 'Roboto', sans-serif;
`

export const BodyOrderProductDesc = styled.label`
    font-size:16px;
    font-weight:500;
    font-family: 'Roboto', sans-serif;
    opacity:0.8;
`

export const BodyOrderInputQty = styled.input<{isMobile: boolean}>`
    border: none;
    outline: none;
    font-size: 18px;
    padding: 2px;
    width:80px;
    margin-left:10px;
    text-align:center;

    ${({ isMobile }) =>
        isMobile &&
        css`
            width:30px;
            padding: 0px;
            margin-left:0px;
        `
    };
`;

export const BodyOrderProductPrice = styled.label`
    font-size:14px;
    font-weight:500;
    font-family: 'Roboto', sans-serif;
    opacity:0.8;
`

export const BodyOrderButonsQty = styled.div`
    display: flex;
    flex-direction:row;
    justify-content:space-between;
`

export const BodyOrderButtonQty = styled.button<{delete: boolean, theme: any}>`
    ${(props) => {
        const primaryColor = props.theme.primary;
        return `background-color: ${props.delete ? 'tomato' : primaryColor};`;
    }}
    border: none;
    cursor: pointer;
    width:30px;
    height:30px;
    border-radius:15px;
    color:#fff;
    display:flex;
    align-items:center;
    justify-content:center;

    &:hover {
        opacity:0.6;
    }
`

export const BodyOrderButtonAddComp = styled.div`
    display:flex;
    align-items:center;
    justify-content:center;
    margin-top:20px;
`

export const BodyOrderButtonAddMore = styled.button`
    background-color:transparent;
    border: none;
    cursor: pointer;
    color:#000;
    display:flex;
    align-items:center;
    justify-content:center;
    font-weight:bold;
    font-size:18px;
    &:hover {
        color:${(props) => props.theme.primary};
    }
`

export const BodyOrderTotalsComponent = styled.div`
    display:flex;
    flex-direction:row;
    align-items:center;
    justify-content: space-between;
    width:100%;
    margin-top:30px;
`

export const BodyOrderTotalsLeft = styled.div`
    display:flex;
    flex-direction:row;
    flex:2;
`

export const BodyOrderTotalsRight = styled.div`
    display:flex;
    flex-direction:row;
    justify-content: space-around;
    flex:1;
`

export const BodyOrderInputDiscount = styled.input`
    font-size:16px;
    border: none;
    border-bottom :2px solid #FF932F;
    width:10%;
    bottom:5px;
    color: #FF932F;
    text-align:center;
    font-weight:bold;
`;

export const OrderBodyInput = styled.input`
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

/** FinancialBodyModal **/
export const BodyFinTable = styled.div<{backGround: boolean}>`
    background-color:${props => props.backGround ? 'rgba(66, 106, 208, 0.1)' : 'transparent'};
    width:100%;
    padding:20px;
    display: flex;
    flex-direction:column;
`

export const BodyFinLabel = styled.label<{color: string, bold: boolean, size: number}>`
    color:${(props) => props.color};
    font-family: 'Roboto', sans-serif;
    font-weight: ${(props) => props.bold ? 'bold' : '300'};
    font-size: ${(props) => `${props.size}px`};
`

export const BodyFinColumn = styled.div`
    display:flex;
    flex-direction:column;
    align-items:center;
    margin-top:25px;
`

export const BodyFinItens = styled.div`
    display:flex;
    flex-direction:row;
    justify-content:space-between;
    align-items:center;
    margin-bottom:5px;
`

export const BodyHorizItens = styled.div`
    width:100%;
    display:flex;
    flex-direction:row;
    justify-content:space-between;
    align-items:center;
`

export const BodyEmptyList = styled.div`
    display:flex;
    align-items:center;
    flex-direction:column;
`

export const BodyFinTools = styled.div`
    display:flex;
    flex-direction:row;
    align-items:center;
    justify-content:flex-end;
    margin-top:15px;
`

export const BodyFinButTool = styled.div`
    cursor: pointer;
    border: none;
    background-color: ${(props) => props.theme.primary};
    padding-left:10px;
    padding-right:10px;
    padding-top:5px;
    padding-bottom:5px;
    color: #fff;
    font-weight:bold;
    font-family: 'Roboto', sans-serif;
    border-radius:8px;
    margin-left:5px;
    margin-right:5px;
`

/** Invoicing Customer **/
export const InvCustTable = styled.div<{backGround: boolean}>`
    background-color:${props => props.backGround ? 'rgba(66, 106, 208, 0.1)' : 'transparent'};
    width:100%;
    padding:20px;
    display: flex;
    flex-direction:column;
`

export const InvCustHorizItens = styled.div`
    width:100%;
    display:flex;
    flex-direction:row;
    justify-content:space-between;
    align-items:center;
`

export const InvCustLabel = styled.label<{color: string, bold: boolean, size: number}>`
    color:${(props) => props.color};
    font-family: 'Roboto', sans-serif;
    font-weight: ${(props) => props.bold ? 'bold' : '300'};
    font-size: ${(props) => `${props.size}px`};
`

export const InvCustTools = styled.div`
    display:flex;
    flex-direction:row;
    align-items:center;
    justify-content:flex-end;
    margin-top:15px;
`

export const InvCustButTool = styled.div`
    cursor: pointer;
    border: none;
    background-color: ${(props) => props.theme.primary};
    padding-left:10px;
    padding-right:10px;
    padding-top:5px;
    padding-bottom:5px;
    color: #fff;
    font-weight:bold;
    font-family: 'Roboto', sans-serif;
    border-radius:8px;
    margin-left:5px;
    margin-right:5px;
`

export const InvCustEmptyList = styled.div`
    display:flex;
    align-items:center;
    flex-direction:column;
`

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


/** Warranty Component **/
export const WarrantyTable = styled.div<{backGround: boolean}>`
    background-color:${props => props.backGround ? 'rgba(66, 106, 208, 0.1)' : 'transparent'};
    width:100%;
    padding:20px;
    display: flex;
    flex-direction:column;
    overflow-x: auto;
    white-space: nowrap;
    margin-top:10px;
`

export const WarrantyItens = styled.div`
    display:flex;
    flex-direction:row;
    justify-content:space-between;
    align-items:center;
    margin-bottom:5px;
`

export const WarrantyColumn = styled.div`
    display:flex;
    flex-direction:column;
    margin-top:25px;
    margin-left:10px;
    margin-right:10px;
`

export const WarrantyColumnBell = styled.div`
    display:flex;
    flex-direction:column;
    margin-top:25px;
`

export const WarrantyLabel = styled.label<{color: string, bold: boolean, size: number, align: string}>`
    color:${(props) => props.color};
    font-family: 'Roboto', sans-serif;
    font-weight: ${(props) => props.bold ? 'bold' : '300'};
    font-size: ${(props) => `${props.size}px`};
    text-align:${(props) => props.align};
`

export const WarrantyTools = styled.div`
    display:flex;
    flex-direction:row;
    align-items:center;
    justify-content:flex-end;
    margin-top:15px;
`

export const WarrantyButTool = styled.div`
    cursor: pointer;
    border: none;
    background-color: ${(props) => props.theme.primary};
    padding-left:10px;
    padding-right:10px;
    padding-top:5px;
    padding-bottom:5px;
    color: #fff;
    font-weight:bold;
    font-family: 'Roboto', sans-serif;
    border-radius:8px;
    margin-left:5px;
    margin-right:5px;
`

export const WarrantyButTop = styled.div`
    cursor: pointer;
    border: 1px solid ${(props) => props.theme.primary};
    background-color: #fff;
    padding-left:10px;
    padding-right:10px;
    padding-top:5px;
    padding-bottom:5px;
    color: ${(props) => props.theme.primary};
    font-weight:bold;
    font-family: 'Roboto', sans-serif;
    border-radius:8px;
    margin-left:5px;
    margin-right:5px;

    &:hover {
        color: #fff;
        background-color: ${(props) => props.theme.primary};
    }
`

export const WarrantyEmptyList = styled.div`
    display:flex;
    align-items:center;
    flex-direction:column;
`

export const WarrantyHoriz = styled.div`
    width:100%;
    display:flex;
    flex-direction:row;
    justify-content:space-between;
    align-items:center;
`

/** warranty body modal **/
export const WarrantyBodyInput = styled.input<{size: number}>`
    border: 1px solid ${(props) => props.theme.primary};
    outline: none;
    font-size: 14px;
    padding:8px;
    width: ${(props) => `${props.size}px`};
    border-radius: 8px;
    margin: 5px;
`;

export const WarrantyBodyContainer = styled.div<{isMobile: boolean}>`
    display: flex;
    flex-direction:row;
    flex-wrap:wrap;
    align-items:center;
    padding-left:20px;
    padding-right:20px;

    ${({ isMobile }) =>
        isMobile &&
        css`
            padding-left:2px;
            padding-right:2px;
        `
    };
`

export const WarrantyBodyrInputItem = styled.div <{width: number}>`
    margin:5px;
    ${({ width }) => `width:${width}px`};
`

export const WarrantyBodyInputWrapper = styled.div`
    display: flex;
    align-items: center;
    border: 1px solid #ccc;
    border-radius: 10px;
    padding: 6px;
`;

export const WarrantyBodyInputField = styled.input`
    flex: 1;
    border: none;
    outline: none;
    font-size: 14px;
    padding: 2px;
    width:100%;
`;

export const WarrantyBodyDropContainer = styled.div`
    display: flex;
    flex-direction: row;
`

export const WarrantyBodyStep2 = styled.div`
    padding-left:25px;
    padding-right:25px;
    padding-top:15px;
`

export const WarrantyBodyStep3 = styled.div`
    padding-left:25px;
    padding-right:25px;
    padding-top:15px;
`

export const WarrantyButtonTool = styled.div`
    width: 100%;
    display: flex;
    flex-direction:row;
    justify-content:flex-end;
    margin-top:20px;
`


/** Input Text **/
export const InputContainer = styled.div<{mt: number, mb: number}>`
    background-color: #fff;
    margin-top:16px;
    margin-bottom: 16px;
    ${({ mt }) => `margin-top:${mt}px`};
    ${({ mb }) => `margin-bottom:${mb}px`};
`;

export const TextInput = styled.textarea<{height: number}>`
    margin-top:3px;
    font-size: 16px;
    color: #333;
    ${({ height }) => `height:${height}px`};
    border-radius: 10px;
    width: 100%;
    padding:10px;

      &:focus {
        outline: none;
        border: 2px solid #ffaf0f;
    }
`;

/** dropzone **/
export const DropzoneContainer = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    border: 2px dashed #ccc;
    padding: 20px;
    height: 120px;
    width: 100%;
    cursor: pointer;
`;

export const Message = styled.p`
    font-size: 18px;
    color: #888;
    margin: 10px 0;
`;

export const ImageUploaderContainer = styled.div`
    display: flex;
    flex-direction: column;
    align-items: center;
`;

export const ImageButtonHoriz = styled.div`
    display: flex;
    flex-direction:row;
    margin-top:10px;
    width: 100%;
`

/** Invoice Detail **/
export const InvoiceDetailContainer = styled.div`
    display: flex;
    flex-direction:column;
    flex:1;
    width:100%;
`

export const InvoiceDetailSection = styled.div`
    display: flex;
    flex-direction:row;
    width:100%;
    align-items:center;
    justify-content: space-between;
`

export const InvoiceDetailsColumn = styled.div`
    display: flex;
    align-items:flex-start;
    justify-content:center;
    flex-direction:column;
`

export const InvoiceDetailTitle = styled.label`
    font-size:16px;
    font-weight:bold;
    font-family: 'Roboto', sans-serif;
`

export const InvoiceDetailValue = styled.label`
    font-size:16px;
    font-family: 'Roboto', sans-serif;
`

export const InvoiceDetailLabel = styled.label`
    font-weight:bold;
    font-size:14px;
    font-family: 'Roboto', sans-serif;
    color: ${(props) => props.theme.primary};
    margin-bottom:15px;
`

/** WarrantyDetail **/

export const WDHoriz = styled.div`
    display: flex;
    width: 100%;
    flex-direction:row;
`

export const WDColumn = styled.div`
    display: flex;
    flex: 1;
    padding: 10px;
`

export const WDDetailsColumn = styled.div`
    display: flex;
    align-items:flex-start;
    flex-direction:column;
`

export const financialBodyComponent = styled.div<{windowDimensions: any, modal: boolean,isMobile?: boolean}>`
    background-color: #fff;
    overflow: auto;
    width: ${({ modal }) => (modal ? '100%' : 'auto')};
    max-height: ${({ windowDimensions }) => (windowDimensions.height * 75) / 100}px;
  
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


export const SearchButton = styled.button`
    background-color:transparent;
    border: none;
    cursor: pointer;
`