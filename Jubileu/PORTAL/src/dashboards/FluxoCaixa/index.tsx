import React, { useContext, useEffect, useState } from "react";

import { Col, Row } from "react-bootstrap";
import Table from "../../components/table";

import * as Style from "./styles";

import ChartLine from "../../charts/line";

import { ThemeContext } from "../../contexts/ThemeContext";
import { lightTheme, darkTheme } from "../../themes";

import { formatRow } from "../../utils/rowTableFormat";
import  api from "../../services/api";

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

const FluxoCaixa: React.FC <Props> = ({ano, mes}) => {
  const { theme } = useContext(ThemeContext);
  const themeContext = theme === "light" ? lightTheme : darkTheme;
  
  const [optionsLine1, setOptionsLine1] = useState<any>({})
  const [seriesLine1, setSeriesLine1] = useState<any>([])
    
  const [optionsLine2, setOptionsLine2] = useState<any>({})
  const [seriesLine2, setSeriesLine2] = useState<any>([])

  const [headerCards1, setHeaderCards1] = useState<any>([])
  const [fields1, setFields1] = useState<any>([])
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

  useEffect(() => {
    fetchData()
  },[theme, ano, mes])

  const fetchData = async () => {

    const response = await api.get(`/WSAPP16?ano=${ano}&mes=${mes}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      const option1 = json.result[0].option1
      const option2 = json.result[0].option2
      const series1 = json.result[0].series1
      const series2 = json.result[0].series2

      option1.chart.foreColor = themeContext.text
      setOptionsLine1(option1)
      setSeriesLine1(series1)

      option2.chart.foreColor = themeContext.text
      setOptionsLine2(option2)
      setSeriesLine2(series2)

      setHeaderCards1(json.result[0].header)
      setFields1(json.result[0].fields1)
      setTable1(json.result[0].dataTable1)
    }
  };

  return (
      <Row className="g-4">
        <Col md={12} lg={12}>
          <Row className="g-4">
            <Col md={12}>
              <Row xs={1} md={6} className="g-4">
                { headerCards1.map((item: any, index: number) => (
                  <MyCard key={index}>
                    <Style.TextDash size={14}>{item.title}</Style.TextDash>
                    <Style.TextDash size={22}>{formatRow(item.type,item.value)}</Style.TextDash>
                  </MyCard>
                ))
                }
              </Row>
            </Col>
          </Row>
        </Col>

        <Col>
          <Row className="g-4">
            <Col md={6}>
              <Style.CardDash border={theme} className="h-100">
                <Style.TextDash
                  style={{ marginTop: 20, marginLeft: 20 }}
                  size={20}
                >
                  Valores Pagos e Recebidos
                </Style.TextDash>
                <Style.CardDashBody>
                  <ChartLine
                    options={optionsLine1}
                    series={seriesLine1}
                  />
                </Style.CardDashBody>
              </Style.CardDash>
            </Col>

            <Col md={6}>
              <Style.CardDash border={theme} className="h-100">
                <Style.TextDash
                  style={{ marginTop: 20, marginLeft: 20 }}
                  size={20}
                >
                  Valores Futuros de Pagamentos e Recebimentos
                </Style.TextDash>
                <Style.CardDashBody>
                  <ChartLine
                      options={optionsLine2}
                      series={seriesLine2}
                  />
                </Style.CardDashBody>
              </Style.CardDash>
            </Col>
          </Row>
        </Col>


        <Col md={12} lg={12}>
          <Style.TextDash size={18} style={{marginBottom:5}}>
            Informações dos Pagamentos e Recebimentos por Data
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
      </Row>
  );
};

export default FluxoCaixa;
