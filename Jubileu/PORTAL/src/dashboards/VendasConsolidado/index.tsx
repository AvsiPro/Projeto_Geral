import React, { useContext, useEffect, useState } from "react";

import { Col, Row, Table } from "react-bootstrap";

import * as Style from "./styles";

import ChartBar from "../../charts/bar";
import ChartBubble from "../../charts/bubble";

import { ThemeContext } from "../../contexts/ThemeContext";
import { lightTheme, darkTheme } from "../../themes";

import {
  optionBubble1,
  seriesBubble1,
} from "../../dummy";

import { formatRow } from "../../utils/rowTableFormat";
import ChartLine from "../../charts/line";
import { useMediaQuery } from "react-responsive";
import { WindowDimensionsContext } from "../../contexts/WindowDimensionsContext";
import api from "../../services/api";


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

const VendasConsolidado: React.FC <Props> = ({ano, mes}) => {
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

  const toggleGroupExpansion = (classe: any) => {
    setExpandedGroups((prevState: any) => ({
      ...prevState,
      [classe]: !prevState[classe],
    }));
  };

  useEffect(() => {
    fetchData()
  },[theme, ano, mes])

  const fetchData = async () => {

    const response = await api.get(`/WSAPP17?ano=${ano}&mes=${mes}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      const option1 = json.result[0].option1
      const option2 = json.result[0].option2
      const series1 = json.result[0].series1
      const series2 = json.result[0].series2

      option1.chart.foreColor = themeContext.text
      option1.dataLabels.style.colors = [themeContext.text]

      setOptions1(option1)
      setSeries1(series1)

      option2.chart.foreColor = themeContext.text
      setOptions2(option2)
      setSeries2(series2)

      setHeaderCards1(json.result[0].header)
      setTable1(json.result[0].dataTable)
    }
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

      <Col md={6} lg={4}>
        <MyCard>
            <Style.TextDash size={14}>Valor Vendas por Filial</Style.TextDash>

            <Style.CardDashBody>
              <ChartBar
                  options={options1}
                  series={series1}
              />
            </Style.CardDashBody>
        </MyCard>
      </Col>

      <Col md={6} lg={8}>
        <Row className="g-4">
          <Col md={12}>
              <Row xs={1} md={2} className="g-4">
                <MyCard>
                    <Style.TextDash size={14}>Valor Vendas por Ano e Mês</Style.TextDash>
                      <Style.CardDashBody>
                        <ChartLine
                          options={options2}
                          series={series2}
                          width={'100%'}
                        />
                      </Style.CardDashBody>
                </MyCard>

                <MyCard>
                    <Style.TextDash size={14}>Análise das Vendas por Tipo Indicação</Style.TextDash>
                      <ChartBubble
                          options={optionBubble1(themeContext)}
                          series={seriesBubble1}
                          width={'100%'}
                        />
                </MyCard>
              </Row>
          </Col>          
        </Row>
      </Col>

      <Col md={1} lg={12}>
        <Style.TextDash style={{marginBottom:10}} size={14}>Valor Vendas por Classe, Subclasse e Grife</Style.TextDash>

        <Style.TableComponent
          id="tabledash3"
          windowDimensions={windowDimensions}
          modal={false}
          isMobile={isMobile}
        >
          <Table striped bordered hover>
            <thead>
              <tr>
                <th>Classe</th>
                <th>Valor Vendas</th>
                <th>% Total</th>
                <th>Quantidade</th>
                <th>Nº Vendas</th>
                <th>Valor Descontos</th>
                <th>Valor Vendas Bruto</th>
              </tr>
            </thead>
            <tbody>
              {table1.map((item: any, index: number) => (
                <React.Fragment key={index}>
                  <tr
                    style={{ cursor: 'pointer' }}
                    onClick={() => toggleGroupExpansion(item.classe)}
                  >
                    <td>{item.classe}</td>
                    <td>{formatRow('vlrVendas',item.vlrVendas)}</td>
                    <td>{formatRow('percTotal',item.percTotal)}</td>
                    <td>{formatRow('quant',item.quant)}</td>
                    <td>{formatRow('numVendas',item.numVendas)}</td>
                    <td>{formatRow('vlrDesc',item.vlrDesc)}</td>
                    <td>{formatRow('vlrVBrut',item.vlrVBrut)}</td>
                  </tr>
                  {expandedGroups[item.classe] &&
                    item.subgrupos.map((subgrupo: any, subIndex: number) => (
                      <tr 
                        key={`${index}-${subIndex}`}
                        //onClick={() => alert(subgrupo.name)} 
                        style={{ cursor: 'pointer' }}
                      >
                        <td>{subgrupo.name}</td>
                        <td>{formatRow('vlrVendas',subgrupo.vlrVendas)}</td>
                        <td>{formatRow('percTotal',subgrupo.percTotal)}</td>
                        <td>{formatRow('quant',subgrupo.quant)}</td>
                        <td>{formatRow('numVendas',subgrupo.numVendas)}</td>
                        <td>{formatRow('vlrDesc',subgrupo.vlrDesc)}</td>
                        <td>{formatRow('vlrVBrut',subgrupo.vlrVBrut)}</td>
                      </tr>
                    ))}
                </React.Fragment>
              ))}
            </tbody>
          </Table>
        </Style.TableComponent>
      </Col>
    </Row>
  );
};

export default VendasConsolidado;