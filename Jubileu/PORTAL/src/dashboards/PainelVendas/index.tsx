import React, { useContext, useEffect, useState } from "react";

import * as Style from "./styles";
import { Col, Row, Table } from "react-bootstrap";

import { ThemeContext } from "../../contexts/ThemeContext";
import { lightTheme, darkTheme } from "../../themes";
import { capitalize, firstAndLastName, getInitials } from "../../utils/nameFormat";
import ChartColumn from "../../charts/column";
import { dataColumn, optionColumn2 } from "../../dummy";

import { BsEmojiFrown, BsEmojiSmile } from "react-icons/bs";
import { CurrencyFormat } from "../../utils/currencyFormat";
import api from "../../services/api";
import { WindowDimensionsContext } from "../../contexts/WindowDimensionsContext";


interface Props {
  ano: string;
  mes: string
}

const PainelVendas: React.FC <Props> = ({ano, mes}) => {
  const { theme } = useContext(ThemeContext);
  const themeContext = theme === "light" ? lightTheme : darkTheme;

  const [card1, setCard1] = useState<any>([])
  const [card2, setCard2] = useState<any>([])

  const { windowDimensions } = useContext(WindowDimensionsContext);


  const userData = localStorage.getItem("userdata");
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
    
    const response = await api.get(`/WSAPP20?ano=${ano}&mes=${mes}`);
    const json: any = response.data;

    if(json.status.code === '#200'){
      setCard1(json.card1)
      setCard2(json.card2)
    }

    return
};

  const compYear = [
    {
      ano: "2022",
      meses: [
        { name: "Janeiro", valor: 700000 },
        { name: "Fevereiro", valor: 850000 },
        { name: "Março", valor: 900000 },
        { name: "Abril", valor: 500000 },
        { name: "Maio", valor: 900000 },
        { name: "Junho", valor: 400000 },
        { name: "Julho", valor: 330000 },
        { name: "Agosto", valor: 700000 },
        { name: "Setembro", valor: 600000 },
        { name: "Outubro", valor: 500000 },
        { name: "Novembro", valor: 1000000 },
        { name: "Dezembro", valor: 700000 },
      ],
    },
    {
      ano: "2023",
      meses: [
        { name: "Janeiro", valor: 900000 },
        { name: "Fevereiro", valor: 500000 },
        { name: "Março", valor: 1200000 },
        { name: "Abril", valor: 950000 },
        { name: "Maio", valor: 850000 },
        { name: "Junho", valor: 562000 },
        { name: "Julho", valor: 270000 },
        { name: "Agosto", valor: 705000 },
        { name: "Setembro", valor: 990000 },
        { name: "Outubro", valor: 512000 },
        { name: "Novembro", valor: 1300000 },
        { name: "Dezembro", valor: 800000 },
      ],
    },
  ];

  const resultArray = [];

  for (const mes of compYear[0].meses) {
    const mesObj2022 = mes;
    const mesObj2023 = compYear[1].meses.find((m) => m.name === mes.name);

    if (mesObj2023) {
      const aumento = mesObj2023.valor > mesObj2022.valor;

      const mesAumentoObj = {
        mes: mes.name,
        aumento: aumento,
        valor2022: mesObj2022.valor,
        valor2023: mesObj2023.valor,
      };

      resultArray.push(mesAumentoObj);
    }
  }

  return (

    <Style.Component windowDimensions={windowDimensions}>
      <Row className="g-4">
        <Col md={12}>
            <Row xs={1} md={2} className="g-4">
            <Style.DivRanking>
              <MyCard>
                <Style.TextDash size={14} weight="bold">
                  Ranking Mês
                </Style.TextDash>
                {card2.map((row: any, index: number) => {
                  return (
                    <>
                      <Style.Card2Container key={index} backGround={theme === 'light' && index % 2 == 0}>
                        <Style.ContVertical>
                          <Style.HeaderProfileImg>
                              <Style.HeaderProfileText>
                                  {getInitials(firstAndLastName(row.nome.trim()))}
                              </Style.HeaderProfileText>
                          </Style.HeaderProfileImg>
                        </Style.ContVertical>
                        
                        <Style.ContVertical style={{ alignItems: "flex-start", marginLeft: 20, minWidth:120 }}>
                          <Style.TextDash size={14} weight="bold">
                            Nome
                          </Style.TextDash>
                          <Style.TextDash size={14} weight="normal">
                            {capitalize(firstAndLastName(row.nome.trim()))}
                          </Style.TextDash>
                        </Style.ContVertical>
                        
                        <Style.ContVertical style={{ alignItems: "flex-start", marginLeft: 60 }}>
                          <Style.TextDash size={14} weight="bold">
                            Valor
                          </Style.TextDash>
                          <Style.TextDash size={14} weight="normal">
                            {CurrencyFormat(row.total)}
                          </Style.TextDash>
                        </Style.ContVertical>
                        <Style.ContVertical style={{ alignItems: "flex-start", marginLeft: 60 }}>
                          <Style.TextDash size={14} weight="bold">
                            Meta
                          </Style.TextDash>
                          <Style.TextDash size={14} weight="normal">
                            {CurrencyFormat(row.meta)}
                          </Style.TextDash>
                        </Style.ContVertical>
                        <Style.ContVertical style={{ alignItems: "flex-start", marginLeft: 60 }}>
                          <Style.TextDash size={14} weight="bold">
                            % Meta
                          </Style.TextDash>
                          <Style.TextDash size={14} weight="normal">
                            {row.atingPercent} %
                          </Style.TextDash>
                        </Style.ContVertical>
                        <Style.ContVertical style={{ alignItems: "flex-start", marginLeft: 60 }}>
                          <Style.TextDash size={14} weight="bold">
                            Projeção
                          </Style.TextDash>
                          <Style.TextDash size={14} weight="normal">
                            {CurrencyFormat(row.total + row.projecao)}
                          </Style.TextDash>
                        </Style.ContVertical>
                      </Style.Card2Container>

                      { theme === 'dark' &&
                        <Style.Separator />
                      }
                    </>
                  );
                })}
              </MyCard>
            </Style.DivRanking>

            <MyCard>
              <Style.TextDash size={14} weight="bold">
                Comparativo Mês Anterior
              </Style.TextDash>
              <ChartColumn
                options={optionColumn2(themeContext)}
                series={dataColumn}
              />
            </MyCard>
            </Row>
        </Col>   

        <Col md={12}>
          <Style.Div100>
          <MyCard>
              <Style.TextDash size={14} weight="bold">
                Ranking por Vendedor e Marcas
              </Style.TextDash>

            {card1.map((row: any, index: number) => {
              return (
                <>
                  <Style.Card1Container key={index} backGround={theme === 'light' && index % 2 == 0}>
                    <Style.ContVertical style={{ flex: 1 }}>
                      <Style.ContHorizontal style={{ width: "100%" }}>
                        <Style.ContHorizontal style={{ marginRight: 50 }}>
                          <Style.ContVertical style={{ marginRight: 50 }}>
                            <Style.TextDash style={{color: 'transparent' }} size={14} weight="normal">_</Style.TextDash>
                              <Style.HeaderProfileImg>
                                  <Style.HeaderProfileText>
                                      {getInitials(firstAndLastName(row.name.trim()))}
                                  </Style.HeaderProfileText>
                              </Style.HeaderProfileImg>
                          </Style.ContVertical>

                          <Style.ContVertical
                            style={{ alignItems: "flex-start", minWidth:120 }}
                          >
                            <Style.TextDash style={{color: 'transparent' }} size={14} weight="normal">_</Style.TextDash>
                            
                            <Style.TextDash style={{marginTop:12}} size={16} weight="normal">
                              {capitalize(firstAndLastName(row.name.trim()))}
                            </Style.TextDash>
                          </Style.ContVertical>
                        </Style.ContHorizontal>

                        { row.brands.map((element: any, index: number) =>{
                            return(
                              <Style.ContVertical style={{ paddingLeft: 25, paddingRight: 25 }} key={index}>
                                <Style.TextDash style={{color:themeContext.primary}} size={14} weight="bold">
                                  {capitalize(element.title.trim())}
                                </Style.TextDash>

                                <Style.ContHorizontal style={{marginTop:15}}>
                                  <Style.ContVertical style={{ marginRight: 20 }}>
                                    <Style.TextDash size={14} weight="bold">
                                      Quant.
                                    </Style.TextDash>
                                    <Style.TextDash size={14} weight="normal">
                                      {element.quantity}
                                    </Style.TextDash>
                                  </Style.ContVertical>

                                  <Style.ContVertical>
                                    <Style.TextDash size={14} weight="bold">
                                      Valor
                                    </Style.TextDash>
                                    <Style.TextDash size={14} weight="normal">
                                      {CurrencyFormat(element.value)}
                                    </Style.TextDash>
                                  </Style.ContVertical>
                                </Style.ContHorizontal>
                              </Style.ContVertical>
                            )
                          })
                        }
                      </Style.ContHorizontal>
                    </Style.ContVertical>
                  </Style.Card1Container>
                  
                  { theme === 'dark' &&
                    <Style.Separator />
                  }
                </>
              );
            })}
          </MyCard>
          </Style.Div100>
        </Col>

        <div>
          <MyCard>
            <Style.TextDash size={14} weight="bold">
              Comparativo Anual
            </Style.TextDash>
            <Style.Separator />
            <Style.ContHorizontal style={{ overflow: "auto", whiteSpace: "nowrap" }}>
              <Style.ContVertical
                style={{ alignItems: "center", marginRight: 20 }}
              >
                <Style.TextDash size={14} weight="bold">
                  2022
                </Style.TextDash>
                <Style.TextDash size={14} weight="bold">
                  2023
                </Style.TextDash>
                <Style.ContHorizontal style={{ gap: 5, marginTop: 10 }}>
                  <Style.TextDash size={14} weight="bold">
                    <BsEmojiSmile size={20} color="Green" />
                  </Style.TextDash>
                  <Style.TextDash size={14} weight="bold">
                    <BsEmojiFrown size={20} color="Red" />
                  </Style.TextDash>
                </Style.ContHorizontal>
                <Style.TextDash size={14} weight="bold" style={{ marginTop: 20 }}>
                  Mês
                </Style.TextDash>
              </Style.ContVertical>
              {resultArray.map((result) => {
                return (
                  <Style.ContVertical style={{ marginRight: 20 }}>
                    <Style.TextDash size={14} weight="normal">
                      {CurrencyFormat(result.valor2022)}
                    </Style.TextDash>
                    <Style.TextDash size={14} weight="normal">
                      {CurrencyFormat(result.valor2023)}
                    </Style.TextDash>
                    {result.aumento ? (
                      <Style.TextDash
                        size={14}
                        weight="bold"
                        style={{ marginTop: 10 }}
                      >
                        <BsEmojiSmile size={20} color="Green" />
                      </Style.TextDash>
                    ) : (
                      <Style.TextDash size={14} weight="bold">
                        <BsEmojiFrown
                          size={20}
                          color="Red"
                          style={{ marginTop: 10 }}
                        />
                      </Style.TextDash>
                    )}
                    <Style.TextDash
                      size={14}
                      weight="bold"
                      style={{ marginTop: 20 }}
                    >
                      {result.mes}
                    </Style.TextDash>
                  </Style.ContVertical>
                );
              })}
            </Style.ContHorizontal>
            <Style.Separator />
          </MyCard>
        </div>
      </Row>
    </Style.Component>
  );
};

export default PainelVendas;
