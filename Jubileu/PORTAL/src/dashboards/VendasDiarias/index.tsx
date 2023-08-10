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
import api from "../../services/api";
import ChartPie from "../../charts/pie";
import ChartArea from "../../charts/area";
import Table from "../../components/table";
import { data } from "@syncfusion/ej2";


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

  const [labelcat, setLabelcat] = useState<any>([])
  const [series3, setSeries3] = useState<any>([])

  const [headerCards1, setHeaderCards1] = useState<any>([])
  const [table1, setTable1] = useState<any>([])
  const [table2, setTable2] = useState<any>([])

  const [labelpie, setLabelPie] = useState<any>([])
  
  const MyCard = ({ children }: any) => {
    return (
      <Col>
        <Style.CardDash border={theme} className="h-100">
          <Style.CardDashBody>{children}</Style.CardDashBody>
        </Style.CardDash>
      </Col>
    );
  };

  useEffect(() => {
    fetchData()
  },[theme, ano, mes])

  const fetchData = async () => {
    const response = await api.get(`/WSAPP18?token=eyJTQTMiLCJNVVJJTE8iLCIxMjgzMjY2MTY0NSJ9&pagesize=10&page=1&ano=2023&mes=6`);
    //const response = await api.get(`/WSAPP18?token=eyJTQTMiLCJNVVJJTE8iLCIxMjgzMjY2MTY0NSJ9&pagesize=10&page=1&ano=${ano}&mes=${mes}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    
      console.log(json.result)

      const series1 = json.result[0].series1
      setSeries1(series1)
      const series2 = json.result[0].series2[0].data
      setSeries2(series2)
      const labels : any = json.result[0].series2[0].labels
      setLabelPie(labels)      
      const labelcat : any = json.result[0].series3[0].labelcat
      setLabelcat(labelcat)
      const series3 = [{data: json.result[0].series3[0].data}]
      setSeries3(series3)
      const headerCards1 = json.result[0].header
      setHeaderCards1(headerCards1)
      const table1 = json.result[0].dataTable1
      setTable1(table1)
      const table2 = json.result[0].dataTable2
      setTable2(table2)
    }
  };


  return (
    <Row className="g-4">

      <Col md={12} lg={12}>
        <Row className="g-4">
          <Col md={12}>
            <Row xs={1} md={3} className="g-4">
              { headerCards1.map((item: any, index: number) => (
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
      <Col md={12}>
      <Row xs={1} md={1} className="g-4">
                
        <MyCard>
          
            <Style.TextDash size={14}>Valor vendas por dia</Style.TextDash>

            <Style.CardDashBody>
              <ChartArea
                  options={optionArea1(themeContext)}
                  series={series1}
              />
            </Style.CardDashBody>
        </MyCard>
        </Row>
      </Col>
      <Col md={12}>
          <Row xs={1} md={2} className="g-4">
            <MyCard>
                <Style.TextDash size={14}>Top Grifes por Valor de Vendas</Style.TextDash>
                  <Style.CardDashBody>
                    <ChartBar
                      options={optionBar1(themeContext,labelcat)}
                      series={series3}
                    />
                  </Style.CardDashBody>
            </MyCard>

            <MyCard>
                <Style.TextDash size={14}>Top Grifes por % de Vendas</Style.TextDash>
                  <ChartPie options={optionPie(themeContext,labelpie)} series={series2} />
            </MyCard>
          </Row>
      </Col>          
        

      <Col md={20} lg={20}>
          <Style.TextDash size={18} style={{marginBottom:5, marginTop:20}}>
            Valor vendas por cliente
          </Style.TextDash>
          
            <Table
              data={table1}
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

      <Col md={20} lg={20}>
          <Style.TextDash size={18} style={{marginBottom:5, marginTop:20}}>
            Ranking dos produtos vendidos pelo Num Vendas
          </Style.TextDash>
          
            <Table
              data={table2}
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