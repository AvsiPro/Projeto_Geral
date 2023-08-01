import React, { useContext } from "react";

import { Card, Col, Row } from "react-bootstrap";
import { AiOutlineBank, AiFillCaretDown, AiFillCaretUp } from 'react-icons/ai';

import * as Style from "./styles";

import ChartArea from "../../charts/area";
import ChartColumn from "../../charts/column";
import ChartPie from "../../charts/pie";

import { ThemeContext } from "../../contexts/ThemeContext";
import { lightTheme, darkTheme } from "../../themes";


import { optionArea, seriesArea, optionColumn, seriesColumn, optionPie, seriesPie } from '../../dummy'


const ModeloDash: React.FC = () => {

  const { theme } = useContext(ThemeContext);
  const themeContext = theme === "light" ? lightTheme : darkTheme;

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
    <>
        <Row className="g-4">
            <Col md={6} lg={4}>
                <Style.CardDash border={theme} className="h-100">
                    <Style.CardPrimaryDash>
                    <Style.IconPrimaryDash>
                    <AiOutlineBank color={themeContext.primary} size={30}/>
                    </Style.IconPrimaryDash>
                    <Style.TextDash size={20}>R$12.345</Style.TextDash>
                    <Style.TextLabelDash size={14} color="grey" fontWeight={500}>Expenses</Style.TextLabelDash>
                    </Style.CardPrimaryDash>

                    <ChartArea options={optionArea(themeContext)} series={seriesArea} />
                </Style.CardDash>
            </Col>

            <Col md={6} lg={8}>
                <Row className="g-4">
                <Col md={12}>
                    <Style.CardDash border={theme} className="h-100">
                    <Card.Body>
                        <Row>
                        <Col>
                            <Style.ContainerIconsDash>
                            <Style.IconSucessDash size={50} />

                            <Style.ContainerIconTextDash>
                                <Style.TextDash size={14}>Total Orders</Style.TextDash>
                                <Style.TextDash size={24}>2254</Style.TextDash>
                            </Style.ContainerIconTextDash>
                            </Style.ContainerIconsDash>
                        </Col>

                        <Col>
                            <Style.ContainerIconsDash>
                            <Style.IconRecentDash size={50} />

                            <Style.ContainerIconTextDash>
                                <Style.TextDash size={14}>Recent Order</Style.TextDash>
                                <Style.TextDash size={24}>45%</Style.TextDash>
                            </Style.ContainerIconTextDash>
                            </Style.ContainerIconsDash>
                        </Col>

                        <Col>
                            <Style.ContainerIconsDash>
                            <Style.IconCanceledDash size={50} />

                            <Style.ContainerIconTextDash>
                                <Style.TextDash size={14}>Cancel Orders</Style.TextDash>
                                <Style.TextDash size={24}>30%</Style.TextDash>
                            </Style.ContainerIconTextDash>
                            </Style.ContainerIconsDash>
                        </Col>

                        </Row>
                    </Card.Body>
                    </Style.CardDash>
                </Col>

                <Col md={12}>
                    <Row xs={1} md={3} className="g-4">
                    <MyCard>
                        <Style.TextDash size={14}>Total Invoices</Style.TextDash>
                        <Style.TextDash size={36}>245</Style.TextDash>
                        <Style.ContaineSecDash>
                        <AiFillCaretDown color="tomato" />
                        <Style.TextLabelDash size={14} color="tomato" fontWeight={500}>{'43.2'}</Style.TextLabelDash>
                        <Style.TextLabelDash size={14} color="grey" fontWeight={500}>{'last month'}</Style.TextLabelDash>
                        </Style.ContaineSecDash>
                    </MyCard>

                    <MyCard>
                        <Style.TextDash size={14}>Credit Amount</Style.TextDash>
                        <Style.TextDash size={36}>R$53k</Style.TextDash>
                        <Style.ContaineSecDash>
                        <AiFillCaretUp color="#2dce89" />
                        <Style.TextLabelDash size={14} color="#2dce89" fontWeight={500}>{'19.8'}</Style.TextLabelDash>
                        <Style.TextLabelDash size={14} color="grey" fontWeight={500}>{'last month'}</Style.TextLabelDash>
                        </Style.ContaineSecDash>
                    </MyCard>

                    <MyCard>
                        <Style.TextDash size={14}>Pending Amount</Style.TextDash>
                        <Style.TextDash size={36}>R$2354</Style.TextDash>
                        <Style.ContaineSecDash>
                        <AiFillCaretUp color="#2dce89" />
                        <Style.TextLabelDash size={14} color="#2dce89" fontWeight={500}>{'0.8%'}</Style.TextLabelDash>
                        <Style.TextLabelDash size={14} color="grey" fontWeight={500}>{'last month'}</Style.TextLabelDash>
                        </Style.ContaineSecDash>
                    </MyCard>

                    </Row>
                </Col>
                </Row>
            </Col>
            
            <Col>
                <Row className="g-4">
                <Col md={8}>
                    <Style.CardDash border={theme} className="h-100">
                    <Style.TextDash style={{marginTop:20, marginLeft:20}} size={20}>Chart Title</Style.TextDash>
                    <Style.CardDashBody>
                        <ChartColumn options={optionColumn(themeContext)} series={seriesColumn} />
                    </Style.CardDashBody>
                    </Style.CardDash>
                </Col>

                <Col md={4}>
                    <Style.CardDash border={theme} className="h-100">
                    <Style.TextDash style={{marginTop:20, marginLeft:20}} size={20}>Chart Title</Style.TextDash>
                    <Style.CardDashBody>
                    </Style.CardDashBody>
                    </Style.CardDash>
                </Col>
                </Row>
            </Col>
        </Row>
    </>
  );
};

export default ModeloDash;
