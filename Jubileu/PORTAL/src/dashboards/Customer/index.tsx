import React, { useContext, useEffect, useState } from "react";

import { Card, Col, Row } from "react-bootstrap";

import * as Style from "./styles";

import ChartColumn from "../../charts/column";
import ChartPie from "../../charts/pie";

import { ThemeContext } from "../../contexts/ThemeContext";
import { lightTheme, darkTheme } from "../../themes";


import {  optionColumnCust, optionPieCustomer } from '../../dummy'
import { formatRow } from "../../utils/rowTableFormat";
import api from "../../services/api";

interface ApiResponse {
    status: {
      code: string;
      message: string;
    };
    hasNext: boolean;
    result: any;
}

const CustomerDash: React.FC = () => {

  const { theme } = useContext(ThemeContext);
  const themeContext = theme === "light" ? lightTheme : darkTheme;

  const userData = localStorage.getItem('userdata');
  const user = userData ? JSON.parse(userData) : null;

  const [series, setSeries] = useState<any>([])
  const [series1, setSeries1] = useState<any>([])
  const [series2, setSeries2] = useState<any>([])

  useEffect(() => {
    fetchData()
  },[])

  const fetchData = async () => {

    const response = await api.get(`/WSAPP21?token=${user.token}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){
      setSeries(json.result[0].series)
      setSeries1(json.result[0].series1)
      
      const serie1Aux = json.result[0].series1;

      // Step 1: Calcular o total dos valores
      const total = serie1Aux.reduce((acc: any, item: any) => acc + item.value, 0);
      
      // Step 2: Calcular o percentual de cada item e arredondar
      const seriesWithPercentage = serie1Aux.map((item: any) => ({
        ...item,
        percentage: Math.round((item.value / total) * 100 * 100) / 100 // Arredondando para duas casas decimais
      }));
      
      // Step 3: Ordenar os itens com base na lógica desejada
      const sortedSeries = seriesWithPercentage.sort((a: any, b: any) => {
        // Coloque a lógica de ordenação aqui, de acordo com os títulos específicos
        const order = ['late', 'open', 'paid'];
        return order.indexOf(a.icon) - order.indexOf(b.icon);
      });
      
      const auxSeries2: any = []
      sortedSeries.map((item: any) =>{
        auxSeries2.push(item.percentage);
      })

      setSeries2(auxSeries2);
      
    }
  };
  

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
                    <Style.TextDash style={{marginTop:20, marginLeft:20}} size={20}>Status dos Títulos %</Style.TextDash>
                    <Style.CardDashBody>
                        <ChartPie height={'100%'} options={optionPieCustomer(themeContext)} series={series2} />
                    </Style.CardDashBody>
                </Style.CardDash>
            </Col>

            <Col md={6} lg={8}>
                <Row className="g-4">
                <Col md={12}>
                    <Style.CardDash border={theme} className="h-100">
                    <Card.Body style={{margin:10, textAlign:'center'}}>
                       <Style.TextDash size={28}>Acompanhamento Anual de Títulos Financeiros</Style.TextDash>
                    </Card.Body>
                    </Style.CardDash>
                </Col>

                <Col md={12}>
                    <Row className="g-4">
                        <Col md={12}>
                            <Row xs={1} md={3} className="g-4">
                            { series1.map((item: any, index: number) => (
                                <MyCard key={index}>
                                    <Style.IconContainer>
                                        { item.icon === 'paid' 
                                            ? <Style.IconEmAberto size={30} />
                                            : item.icon === 'open'
                                            ? <Style.IconAVencer size={30} />
                                            : <Style.IconEmAtraso size={30} />
                                        }
                                                              </Style.IconContainer>

                                    <Style.TextDash size={14}>{item.title}</Style.TextDash>
                                    <Style.TextDash size={26}>{formatRow(item.type,item.value)}</Style.TextDash>
                                </MyCard>
                            ))
                            }
                            </Row>
                        </Col>
                    </Row>
                </Col>
                </Row>
            </Col>
            
            <Col>
                <Col md={12}>
                    <Style.CardDash border={theme} >
                    <Style.TextDash style={{marginTop:20, marginLeft:20}} size={20}>Valores dos Títulos</Style.TextDash>
                    <Style.CardDashBody>
                        <ChartColumn height={340} options={optionColumnCust(themeContext)} series={series} />
                    </Style.CardDashBody>
                    </Style.CardDash>
                </Col>
            </Col>
        </Row>
    </>
  );
};

export default CustomerDash;
