import React, { useContext } from "react";

import * as Style from './styles'; 
import { Col, Row } from "react-bootstrap";

import { ThemeContext } from "../../contexts/ThemeContext";
import { lightTheme, darkTheme } from "../../themes";
import { capitalize, firstAndLastName } from "../../utils/nameFormat";

const PainelVendas: React.FC = () => {

    const { theme } = useContext(ThemeContext);
    const themeContext = theme === "light" ? lightTheme : darkTheme;

    const userData = localStorage.getItem('userdata');
    const user = userData ? JSON.parse(userData) : null;

    const MyCard = ({ children }: any) => {
        return (
            <Col>
                <Style.CardDash border={theme} className="h-100">
                    <Style.CardDashBody>{children}</Style.CardDashBody>
                </Style.CardDash>
            </Col>
        );
    };
    
  return (

    <Row className="g-4" >
        <Col md={12}>
            <MyCard>
                <Style.ContHorizontal style={{ overflowX: 'auto', whiteSpace: 'nowrap' }}>
                    <Style.ContVertical style={{flex:1}}>
                        <Style.ContHorizontal style={{width:'100%'}}>
                            
                            <Style.ContHorizontal style={{marginRight:50}}>
                                <Style.ContVertical style={{marginRight:50}}>
                                    <Style.TextDash size={14} weight="normal">_</Style.TextDash>
                                    <Style.Elipse />
                                </Style.ContVertical>

                                <Style.ContVertical style={{alignItems:'flex-start'}}>
                                    <Style.TextDash size={14} weight="normal">_</Style.TextDash>
                                    <Style.TextDash size={14} weight="bold">Nome</Style.TextDash>
                                    <Style.TextDash size={14} weight="normal">{capitalize(firstAndLastName(user.name))}</Style.TextDash>
                                </Style.ContVertical>
                            </Style.ContHorizontal>

                            <Style.ContVertical>
                                <Style.TextDash size={14} weight="bold">MX</Style.TextDash>
                                <Style.ContHorizontal>
                                    <Style.ContVertical style={{marginRight:20}}>
                                        <Style.TextDash size={14} weight="bold">Quant.</Style.TextDash>
                                        <Style.TextDash size={14} weight="normal">10</Style.TextDash>
                                    </Style.ContVertical>
                                    
                                    <Style.ContVertical>
                                        <Style.TextDash size={14} weight="bold">Valor</Style.TextDash>
                                        <Style.TextDash size={14} weight="normal">R$10,00</Style.TextDash>
                                    </Style.ContVertical>
                                </Style.ContHorizontal>
                            </Style.ContVertical>

                            <Style.ContVertical>
                                <Style.TextDash size={14} weight="bold">Fell</Style.TextDash>
                                <Style.ContHorizontal>
                                    <Style.ContVertical style={{marginRight:20}}>
                                        <Style.TextDash size={14} weight="bold">Quant.</Style.TextDash>
                                        <Style.TextDash size={14} weight="normal">10</Style.TextDash>
                                    </Style.ContVertical>
                                    
                                    <Style.ContVertical>
                                        <Style.TextDash size={14} weight="bold">Valor</Style.TextDash>
                                        <Style.TextDash size={14} weight="normal">R$10,00</Style.TextDash>
                                    </Style.ContVertical>
                                </Style.ContHorizontal>
                            </Style.ContVertical>

                            <Style.ContVertical>
                                <Style.TextDash size={14} weight="bold">Swiss</Style.TextDash>
                                <Style.ContHorizontal>
                                    <Style.ContVertical style={{marginRight:20}}>
                                        <Style.TextDash size={14} weight="bold">Quant.</Style.TextDash>
                                        <Style.TextDash size={14} weight="normal">10</Style.TextDash>
                                    </Style.ContVertical>
                                    
                                    <Style.ContVertical>
                                        <Style.TextDash size={14} weight="bold">Valor</Style.TextDash>
                                        <Style.TextDash size={14} weight="normal">R$10,00</Style.TextDash>
                                    </Style.ContVertical>
                                </Style.ContHorizontal>
                            </Style.ContVertical>

                            <Style.ContVertical>
                                <Style.TextDash size={14} weight="bold">TNG</Style.TextDash>
                                <Style.ContHorizontal>
                                    <Style.ContVertical style={{marginRight:20}}>
                                        <Style.TextDash size={14} weight="bold">Quant.</Style.TextDash>
                                        <Style.TextDash size={14} weight="normal">10</Style.TextDash>
                                    </Style.ContVertical>
                                    
                                    <Style.ContVertical>
                                        <Style.TextDash size={14} weight="bold">Valor</Style.TextDash>
                                        <Style.TextDash size={14} weight="normal">R$10,00</Style.TextDash>
                                    </Style.ContVertical>
                                </Style.ContHorizontal>
                            </Style.ContVertical>

                            <Style.ContVertical>
                                <Style.TextDash size={14} weight="bold">Cambridge</Style.TextDash>
                                <Style.ContHorizontal>
                                    <Style.ContVertical style={{marginRight:20}}>
                                        <Style.TextDash size={14} weight="bold">Quant.</Style.TextDash>
                                        <Style.TextDash size={14} weight="normal">10</Style.TextDash>
                                    </Style.ContVertical>
                                    
                                    <Style.ContVertical>
                                        <Style.TextDash size={14} weight="bold">Valor</Style.TextDash>
                                        <Style.TextDash size={14} weight="normal">R$10,00</Style.TextDash>
                                    </Style.ContVertical>
                                </Style.ContHorizontal>
                            </Style.ContVertical>
                        </Style.ContHorizontal>
                    </Style.ContVertical>
                </Style.ContHorizontal>

                <Style.Separator />
            </MyCard>
        </Col>
    </Row>

  );
};

export default PainelVendas;
