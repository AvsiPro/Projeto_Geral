import React, { useContext, useState } from "react";

import * as Style from "./styles";
import { Col, Row } from "react-bootstrap";

import { ThemeContext } from "../../contexts/ThemeContext";
import { lightTheme, darkTheme } from "../../themes";
import {
  lineOptions,
  lineSeries,
  pieOptions,
  pieOptions2,
  pieSeries,
  pieSeries2,
} from "../../dummy";

import Button from "react-bootstrap/Button";

import ChartLine from "../../charts/line";
import ChartPie from "../../charts/pie";
import ModalComponent from "../../components/modal";

const FinanceiroMes: React.FC = () => {
  const { theme } = useContext(ThemeContext);
  const themeContext = theme === "light" ? lightTheme : darkTheme;

  const userData = localStorage.getItem("userdata");
  const user = userData ? JSON.parse(userData) : null;

  const [showModal, setShowModal] = useState(false);

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
        <Col md={12} lg={12}>
          <Row className="g-4">
            <Col md={12}>
              <Row xs={1} md={2} className="g-4">
                <MyCard>
                  <Style.ContHorizontal>
                    <Style.TextDash size={14} weight="bold">
                      Inadimplência por Estado
                    </Style.TextDash>
                    <Button
                      variant={
                        theme === "dark" ? "outline-light" : "outline-dark"
                      }
                      onClick={() => setShowModal(true)}
                    >
                      Detalhes
                    </Button>
                  </Style.ContHorizontal>
                  <ChartPie
                    options={pieOptions(themeContext)}
                    series={pieSeries}
                    width={'80%'}
                  />
                </MyCard>

                <MyCard>
                  <Style.ContHorizontal>
                    <Style.TextDash size={14} weight="bold">
                      Recebidos
                    </Style.TextDash>
                    <Button
                      variant={
                        theme === "dark" ? "outline-light" : "outline-dark"
                      }
                      onClick={() => setShowModal(true)}
                    >
                      Detalhes
                    </Button>
                  </Style.ContHorizontal>
                  <ChartPie
                    options={pieOptions2(themeContext)}
                    series={pieSeries2}
                    width={'80%'}
                  />
                </MyCard>
              </Row>
            </Col>
          </Row>
        </Col>
        <Col md={12}>
          <MyCard>
            <Style.ContHorizontal>
              <Style.TextDash size={14} weight="bold">
                À Pagar
              </Style.TextDash>
              <Button
                variant={theme === "dark" ? "outline-light" : "outline-dark"}
                onClick={() => setShowModal(true)}
              >
                Detalhes
              </Button>
            </Style.ContHorizontal>
            <ChartLine
              options={lineOptions(themeContext)}
              series={lineSeries}
              height={400}
            />
          </MyCard>
        </Col>
      </Row>
      <ModalComponent
        show={showModal}
        onHide={() => setShowModal(false)}
        title={"Modal"}
        Body={
          <div style={{ height: "600px" }}>
            <Style.ContHorizontal>
              <div>Razao Social</div>
              <div>Nome Fantasia</div>
              <div>Vencimento Real</div>
              <div>Saldo (Valor)</div>
              <div>Representante</div>
              <div>Cidade</div>
              <div>UF</div>
            </Style.ContHorizontal>
          </div>
        }
        Tools={""}
      />
    </>
  );
};

export default FinanceiroMes;
