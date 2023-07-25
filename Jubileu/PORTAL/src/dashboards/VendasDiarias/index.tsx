import React, { useContext, useEffect, useState } from "react";

import { Col, Row } from "react-bootstrap";

import * as Style from "./styles";

import ChartBar from "../../charts/bar";
import ChartBubble from "../../charts/bubble";

import { ThemeContext } from "../../contexts/ThemeContext";
import { lightTheme, darkTheme } from "../../themes";

import {
  optionBar1,
  optionPie,
  seriesBar1,
  header,
  seriesPie,
  optionArea1,
  seriesArea1,
  fields1,
  dataTable1,
  fields2,
  dataTable2,
} from "../../dummy";

import { formatRow } from "../../utils/rowTableFormat";
import ChartLine from "../../charts/line";
import { useMediaQuery } from "react-responsive";
import { WindowDimensionsContext } from "../../contexts/WindowDimensionsContext";
import { apiTst } from "../../services/api";
import ChartPie from "../../charts/pie";
import ChartArea from "../../charts/area";
import Table from "../../components/table";


interface ApiResponse {
  status: {
    code: string;
    message: string;
  };
  hasNext: boolean;
  result: any;
}

interface Props {
  ano: string;
  mes: string
}

const VendasDiarias: React.FC <Props> = ({ano, mes}) => {
  const { theme } = useContext(ThemeContext);
  const { windowDimensions } = useContext(WindowDimensionsContext);

  const themeContext = theme === "light" ? lightTheme : darkTheme;
  
  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });
  
  const [expandedGroups, setExpandedGroups] = useState<any>({});

  const [options1, setOptions1] = useState<any>({})
  const [series1, setSeries1] = useState<any>([])
    
  const [options2, setOptions2] = useState<any>({})
  const [series2, setSeries2] = useState<any>([])

  const [headerCards1, setHeaderCards1] = useState<any>([])
  const [table1, setTable1] = useState<any>([])

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
    <Row className="g-4">

      <Col md={12} lg={12}>
        <Row className="g-4">
          <Col md={12}>
            <Row xs={1} md={3} className="g-4">
              { header.map((item: any, index: number) => (
                <MyCard key={index}>
                  <Style.TextDash size={14}>{item.title}</Style.TextDash>
                  <Style.TextDash size={26}>{formatRow(item.type,item.value)}</Style.TextDash>
                </MyCard>
              ))
              }
            </Row>
          </Col>
        </Row>
      </Col>

      <Col md={6} lg={4}>
        <MyCard>
            <Style.TextDash size={14}>Valor vendas por dia</Style.TextDash>

            <Style.CardDashBody>
              <ChartArea
                  options={optionArea1(themeContext)}
                  series={seriesArea1}
              />
            </Style.CardDashBody>
        </MyCard>
      </Col>

      <Col md={6} lg={8}>
        <Row className="g-4">
          <Col md={12}>
              <Row xs={1} md={2} className="g-4">
                <MyCard>
                    <Style.TextDash size={14}>Top 5 Classes por Valor de Vendas</Style.TextDash>
                      <Style.CardDashBody>
                        <ChartBar
                          options={optionBar1(themeContext)}
                          series={seriesBar1}
                        />
                      </Style.CardDashBody>
                </MyCard>

                <MyCard>
                    <Style.TextDash size={14}>Top Grifes por Valor de Vendas</Style.TextDash>
                      <ChartPie options={optionPie(themeContext)} series={seriesPie} />
                </MyCard>
              </Row>
          </Col>          
        </Row>
      </Col>

      <Col md={5} lg={5}>
          <Style.TextDash size={18} style={{marginBottom:5, marginTop:20}}>
            Valor vendas por filial
          </Style.TextDash>
          
            <Table
              data={dataTable1}
              fields={fields1}
              title={''}
              handleSearch={() => {}}
              handleMark={()=>{}}
              load={false}
              ToolsTable={() => (<></>)}
              search={false}
              modal={false}
            />
        </Col>

        <Col md={7} lg={7}>
          <Style.TextDash size={18} style={{marginBottom:5, marginTop:20}}>
            Ranking dos produtos vendidos pelo Num Vendas
          </Style.TextDash>
          
            <Table
              data={dataTable2}
              fields={fields2}
              title={''}
              handleSearch={() => {}}
              handleMark={()=>{}}
              load={false}
              ToolsTable={() => (<></>)}
              search={false}
              modal={false}
            />
        </Col>
      
    </Row>
  );
};

export default VendasDiarias;