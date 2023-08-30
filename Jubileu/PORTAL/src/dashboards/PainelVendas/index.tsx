import React, { useContext, useEffect, useState } from "react";

import * as Style from "./styles";
import { Col, Row, Table } from "react-bootstrap";

import { ThemeContext } from "../../contexts/ThemeContext";
import { lightTheme, darkTheme } from "../../themes";
import { capitalize, firstAndLastName } from "../../utils/nameFormat";
import ChartColumn from "../../charts/column";
import { optionColumn2 } from "../../dummy";

import { BsEmojiFrown, BsEmojiSmile } from "react-icons/bs";
import { CurrencyFormat } from "../../utils/currencyFormat";
import api from "../../services/api";
import { WindowDimensionsContext } from "../../contexts/WindowDimensionsContext";
import { titleMonth } from "../../utils/dateFormat";

import { RankBrand, RankMonth } from "./rankBrand";

interface Props {
  ano: string;
  mes: string;
}

interface OriginalData {
  data: Array<{ name: string; value: number }>;
  month_actual?: number;
  month_anterior?: number;
}

interface ConvertedData {
  month_actual?: string;
  month_anterior?: string;
  data: number[];
  nomes: string[];
}

const PainelVendas: React.FC<Props> = ({ ano, mes }) => {
  const { theme } = useContext(ThemeContext);
  const themeContext = theme === "light" ? lightTheme : darkTheme;

  const [card1, setCard1] = useState<any>([]);
  const [card2, setCard2] = useState<any>([]);
  const [card3, setCard3] = useState<any>([]);
  const [card4, setCard4] = useState<any>([]);
  const [nameCard3, setNameCard3] = useState<any>([]);

  const [groups1, setGroups1] = useState<any>([]);

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
    fetchData();
  }, [theme, ano, mes]);

  const fetchData = async () => {
    const response = await api.get(`/WSAPP20?ano=${ano}&mes=${mes}`);
    const json: any = response.data;

    if (json.status.code === "#200") {
      setCard1(json.card1);

      let auxGroup : any = []

      json.card1[0].brands.map((item: any) => {
        auxGroup.push(item.title)
      })

      setGroups1(auxGroup)



      setCard2(json.card2);

      const card3Aux = convertData(json.card3);

      const modifiedData = card3Aux.map((item: any) => {
        const { month_anterior, month_actual, nomes, ...rest } = item;
        const name = month_anterior || month_actual; // Obter o valor de name a partir das chaves existentes
        return {
          ...rest,
          name,
          group: name,
          nomes: nomes,
        };
      });

      setCard3(modifiedData);

      modifiedData[0].nomes.map((item: any, index: number) => {
        modifiedData[0].nomes[index] = firstAndLastName(
          capitalize(item.trim())
        );
      });

      setNameCard3(modifiedData[0].nomes);


      const originalArray = [...json.card4]

      const transformedArray: any = [];

      // Agrupar os valores por ano e mês
      const groupedData: any = {};
      originalArray.forEach(item => {
        const year: any = item.current_year || item.last_year;
        item.months.forEach((month: any) => {
          if (!groupedData[year]) {
            groupedData[year] = Array(12).fill(0);
          }
          groupedData[year][month.name - 1] = month.value;
        });
      });

      // Transformar em um array no formato desejado
      Object.keys(groupedData).forEach(year => {
        const meses = [
          "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
          "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
        ];
        
        const anoData = {
          ano: year,
          meses: meses.map((mes, index) => ({
            name: mes,
            valor: groupedData[year][index]
          }))
        };
        
        transformedArray.push(anoData);
      });

      const resultArray = [];

      for (const mes of transformedArray[0].meses) {
        const mesObj2022 = mes;
        const mesObj2023 = transformedArray[1].meses.find((m: any) => m.name === mes.name);
    
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

      setCard4(resultArray);

    }
  };

  const convertData = (originalData: OriginalData[]): ConvertedData[] => {
    const convertedArray: ConvertedData[] = [];

    let mesAtu = "";
    let mesAnt = "";

    const months: string[] = [];
    originalData.forEach((item) => {
      if (item.month_actual) {
        mesAtu = titleMonth(item.month_actual.toString());
        months[item.month_actual - 1] = mesAtu;
      }
      if (item.month_anterior) {
        mesAnt = titleMonth(item.month_anterior.toString());
        months[item.month_anterior - 1] = mesAnt;
      }
    });

    const nomesMap: { [key: string]: string } = {};
    originalData.forEach((item) => {
      item.data.forEach((dataItem) => {
        nomesMap[dataItem.name.trim()] = dataItem.name.trim();
      });
    });

    const nomes: string[] = Object.values(nomesMap);

    months.forEach((month, index) => {
      const newData: number[] = Array(nomes.length).fill(0);

      originalData.forEach((item) => {
        if (
          (item.month_actual === index + 1 && month === mesAtu) ||
          (item.month_anterior === index + 1 && month === mesAnt)
        ) {
          item.data.forEach((dataItem) => {
            const nomeIndex = nomes.indexOf(dataItem.name.trim());
            newData[nomeIndex] = dataItem.value;
          });
        }
      });

      convertedArray.push({
        [month === mesAtu ? "month_actual" : "month_anterior"]: month,
        data: newData,
        nomes: nomes,
      });
    });

    return convertedArray;
  };




  return (
    <Style.Component windowDimensions={windowDimensions}>
      <Row className="g-4">
        <Col md={12}>
          <Row xs={1} md={1} className="g-4">
            <MyCard>
              <Style.TextDash size={14} weight="bold">
                Comparativo Mês Anterior
              </Style.TextDash>
              <ChartColumn
                options={optionColumn2(themeContext, nameCard3)}
                series={card3}
                height={350}
              />
            </MyCard>
            
          </Row>
        </Col>
  
        <Col md={12}>
          <Row xs={1} md={2} className="g-4">
            <Col>
              <Style.CardDash border={theme} className="h-100">
                <Style.CardDashBody>
                  <RankBrand groups1={groups1} card1={card1} />
                </Style.CardDashBody>
              </Style.CardDash>
            </Col>

            <Col>
              <Style.CardDash border={theme} className="h-100">
                <Style.CardDashBody>
                  <RankMonth card2={card2} />
                </Style.CardDashBody>
              </Style.CardDash>
            </Col>
          </Row>
        </Col>

        <div>
          <MyCard>
            <Style.TextDash size={14} weight="bold">
              Comparativo Anual
            </Style.TextDash>
            <Style.Separator />
            <Style.ContHorizontal
              style={{ overflow: "auto", whiteSpace: "nowrap" }}
            >
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
                <Style.TextDash
                  size={14}
                  weight="bold"
                  style={{ marginTop: 20 }}
                >
                  Mês
                </Style.TextDash>
              </Style.ContVertical>
              {card4.map((result: any) => {
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