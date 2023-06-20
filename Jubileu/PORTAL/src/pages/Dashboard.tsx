import React, { useState, useContext } from "react";

import { Card, Col, Row, DropdownButton, Dropdown } from "react-bootstrap";
import { AiOutlineBank, AiFillCaretDown, AiFillCaretUp } from 'react-icons/ai';


import * as Style from "./styles";

import ChartArea from "../charts/area";
import ChartColumn from "../charts/column";
import ChartPie from "../charts/pie";

import { ThemeContext } from "../contexts/ThemeContext";
import { lightTheme, darkTheme } from "../themes";

import { WindowDimensionsContext } from "../contexts/WindowDimensionsContext";


import Navbar from "../components/navbar";
import Header from "../components/header";

import { useMediaQuery } from "react-responsive";

const Dashboard: React.FC = () => {
  const { theme } = useContext(ThemeContext);
  const { windowDimensions } = useContext(WindowDimensionsContext);
  const themeContext = theme === "light" ? lightTheme : darkTheme;
  const isMobile = useMediaQuery({ query: "(max-width: 767px)" });

  const optionArea = {
    chart: {
      foreColor: themeContext.text,
      toolbar: {
        show: false
      },
      sparkline: {
        enabled: true,
      }
    },
    dataLabels: {
      enabled: false,
    },
    stroke: {
      curve: "smooth",
    },
    xaxis: {
      type: "numeric",
      categories: [1,2,3,4,5,6,7,8,],
    },
  };

  const seriesArea = [

    {
      name: "series",
      data: [13, 26, 20, 33, 21, 40, 35, 45],
    },
  ];

  const optionColumn = {
    chart: {
      type: 'bar',
      foreColor: themeContext.text,
    },
    plotOptions: {
      bar: {
        horizontal: false,
        columnWidth: '55%',
        endingShape: 'rounded'
      },
    },
    dataLabels: {
      enabled: false
    },
    stroke: {
      show: true,
      width: 2,
      colors: ['transparent']
    },
    xaxis: {
      categories: ['Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
    },
    yaxis: {
      title: {
        text: '$ (thousands)'
      }
    },
    fill: {
      opacity: 1
    },
  }

  const seriesColumn = [{
    name: 'Net Profit',
    data: [44, 55, 57, 56, 61, 58, 63, 60, 66]
  }, {
    name: 'Revenue',
    data: [76, 85, 101, 98, 87, 105, 91, 114, 94]
  }, {
    name: 'Free Cash Flow',
    data: [35, 41, 36, 26, 45, 48, 52, 53, 41]
  }]

  const optionPie = {
    chart: {
      type: 'donut',
      foreColor: themeContext.text,
    },
    stroke:{
      show:false,
    },
    responsive: [{
      breakpoint: 480,
      options: {
        chart: {
          width: 200
        },
        legend: {
          position: 'bottom'
        }
      }
    }]
  }

  const seriesPie = [
    44, 55, 41, 17, 15
  ]

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
    <Style.ContainerAll theme={themeContext}>
      {/* Menu lateral */ !isMobile && <Navbar />}

      <Style.Container isMobile={isMobile}>
        {/* Header */}
        <Header />

        <Style.StackDash windowDimensions={windowDimensions} className="mx-auto" gap={4}>

          <DropdownButton
            variant={theme}
            menuVariant={theme}
            title="Dashboards"
          >
            <Dropdown.Item onClick={()=>{}}>Financeiro</Dropdown.Item>
            <Dropdown.Item onClick={()=>{}}>Vendas</Dropdown.Item>
          </DropdownButton>

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

                  <ChartArea options={optionArea} series={seriesArea} />
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
                      <ChartColumn options={optionColumn} series={seriesColumn} />
                    </Style.CardDashBody>
                  </Style.CardDash>
                </Col>

                <Col md={4}>
                  <Style.CardDash border={theme} className="h-100">
                    <Style.TextDash style={{marginTop:20, marginLeft:20}} size={20}>Chart Title</Style.TextDash>
                    <Style.CardDashBody>
                      <ChartPie options={optionPie} series={seriesPie} />
                    </Style.CardDashBody>
                  </Style.CardDash>
                </Col>
              </Row>
            </Col>
            
          </Row>
        </Style.StackDash>
      </Style.Container>
    </Style.ContainerAll>
  );
};

export default Dashboard;
