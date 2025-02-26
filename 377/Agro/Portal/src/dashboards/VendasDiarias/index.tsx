import React, { useContext, useEffect, useState } from "react";

import { Col, Row } from "react-bootstrap";

import * as Style from "./styles";

import ChartBar from "../../charts/bar";

import { ThemeContext } from "../../contexts/ThemeContext";
import { lightTheme, darkTheme } from "../../themes";

import {
  optionBar1,
  optionPie,
  optionArea1,
  fields1,
  fields2,
} from "../../dummy";

import { formatRow } from "../../utils/rowTableFormat";
import api from "../../services/api";
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

  const themeContext = theme === "light" ? lightTheme : darkTheme;
    
  const [series1, setSeries1] = useState<any>([])
  const [series2, setSeries2] = useState<any>([])

  const [labelcat, setLabelcat] = useState<any>([])
  const [series3, setSeries3] = useState<any>([])

  const [headerCards1, setHeaderCards1] = useState<any>([])
  const [table1, setTable1] = useState<any>([])
  const [table2, setTable2] = useState<any>([])

  const [labelpie, setLabelPie] = useState<any>([])

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

  useEffect(() => {
    fetchData()
  },[theme, ano, mes])


  const fetchData = async () => {
    const response = await api.get(`/WSAPP18?token=${user.token}&pagesize=10&page=1&ano=${ano}&mes=${mes}`);
    const json: ApiResponse = response.data;

    let series1: any[] = [];
    let series2: any[] = [];
    let series3: any[] = [];
    let labelPie: any[] = [];
    let labelCat: any[] = [];
    let headerCards: any[] = [];
    let table1Aux: any[] = [];
    let table2Aux: any[] = [];


    if(json.status.code === '#200'){
      series1 = json.result[0].series1
      series2 = json.result[0].series2[0].data
      series3 = [{data: json.result[0].series3[0].data}]
      labelPie = json.result[0].series2[0].labels
      labelCat = json.result[0].series3[0].labelcat
      headerCards = json.result[0].header
      table1Aux = json.result[0].dataTable1
      table2Aux = json.result[0].dataTable2
    }

    setSeries1(series1)
    setSeries2(series2)
    setSeries3(series3)
    setLabelPie(labelPie)
    setLabelcat(labelCat)
    setHeaderCards1(headerCards)
    setTable1(table1Aux)
    setTable2(table2Aux)
  };

  return (
    <Row className="g-4">

      <Col md={12} lg={12}>
        <Row className="g-4">
          <Col md={12}>
            <Row xs={1} md={5} className="g-4">
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