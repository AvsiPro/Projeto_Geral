import React, { useContext, useState } from "react";

import * as Style from "./styles";
import { Col, Row } from "react-bootstrap";

import { ThemeContext } from "../../contexts/ThemeContext";
import { lightTheme, darkTheme } from "../../themes";
import ChartColumn from "../../charts/column";
import {
  dataColumn2,
  lineOptions,
  lineSeries,
  optionColumn3,
} from "../../dummy";

import Dropdown from "react-bootstrap/Dropdown";

import ProgressBar from "react-bootstrap/ProgressBar";
import Button from "react-bootstrap/Button";

import ChartLine from "../../charts/line";
import ModalComponent from "../../components/modal";
import { CurrencyFormat } from "../../utils/currencyFormat";
import { capitalize } from "../../utils/nameFormat";
import { useMediaQuery } from "react-responsive";

const FinanceiroDia: React.FC = () => {
  const { theme } = useContext(ThemeContext);
  const themeContext = theme === "light" ? lightTheme : darkTheme;

  const userData = localStorage.getItem("userdata");
  const user = userData ? JSON.parse(userData) : null;

  const [showModal, setShowModal] = useState(false);

  const isMobile = useMediaQuery({ query: "(max-width: 767px)" });

  const MyCard = ({ children }: any) => {
    return (
      <Col>
        <Style.CardDash border={theme} className="h-100">
          <Style.CardDashBody>{children}</Style.CardDashBody>
        </Style.CardDash>
      </Col>
    );
  };

  const contas = [
    {
      banco: "ITAU",
      agencia: "0001",
      conta: "100000-1",
      saldo: 10000,
    },
    {
      banco: "Itau",
      agencia: "0001",
      conta: "600050-1",
      saldo: 5000,
    },
    {
      banco: "Itau",
      agencia: "0001",
      conta: "600050-1",
      saldo: 5000,
    },
    {
      banco: "Itau",
      agencia: "0001",
      conta: "600050-1",
      saldo: 5000,
    },
    {
      banco: "Itau",
      agencia: "0001",
      conta: "600050-1",
      saldo: 5000,
    },
    {
      banco: "Itau",
      agencia: "0001",
      conta: "600050-1",
      saldo: 5000,
    },
    {
      banco: "Itau",
      agencia: "0001",
      conta: "600050-1",
      saldo: 5000,
    },
    {
      banco: "Itau",
      agencia: "0001",
      conta: "600050-1",
      saldo: 5000,
    },
    {
      banco: "Inter",
      agencia: "0001",
      conta: "520000-1",
      saldo: 300,
    },
    {
      banco: "Inter",
      agencia: "0001",
      conta: "520000-1",
      saldo: 300,
    },
    {
      banco: "Inter",
      agencia: "0001",
      conta: "520000-1",
      saldo: 300,
    },
    {
      banco: "Inter",
      agencia: "0001",
      conta: "520000-1",
      saldo: 300,
    },
    {
      banco: "Inter",
      agencia: "0001",
      conta: "520000-1",
      saldo: 300,
    },
    {
      banco: "Inter",
      agencia: "0001",
      conta: "520000-1",
      saldo: 300,
    },
    {
      banco: "Inter",
      agencia: "0001",
      conta: "520000-1",
      saldo: 300,
    },
    {
      banco: "Inter",
      agencia: "0001",
      conta: "520000-1",
      saldo: 300,
    },
    {
      banco: "NuBank",
      agencia: "0001",
      conta: "201500-1",
      saldo: 50000,
    },
  ];

  const somaSaldo = () => {
    const saldos = contas.map((conta) => conta.saldo);
    const total = saldos.reduce((acc, saldo) => acc + saldo);

    return total;
  };

  return (
    <>
      <Row className="g-4">
        <Col md={12}>
            <Row xs={1} md={2} className="g-4">
              <MyCard>
                <div style={{maxHeight:400, overflow:'auto'}}>
                  <Style.TextDash size={14} weight="bold">
                    Saldo Diário
                  </Style.TextDash>
                  <Style.ContHorizontal>
                    <Style.TextDash
                      size={14}
                      weight="bold"
                      style={{ width: "15%" }}
                    >
                      Banco
                    </Style.TextDash>
                    <Style.TextDash
                      size={14}
                      weight="bold"
                      style={{ width: "15%" }}
                    >
                      Agência
                    </Style.TextDash>
                    <Style.TextDash
                      size={14}
                      weight="bold"
                      style={{ width: "15%" }}
                    >
                      Conta
                    </Style.TextDash>
                    <Style.TextDash
                      size={14}
                      weight="bold"
                      style={{ width: "15%" }}
                    >
                      Saldo Atual
                    </Style.TextDash>
                  </Style.ContHorizontal>
                  <Style.Separator />
                  {contas.map((conta) => {
                    return (
                      <>
                        <Style.ContHorizontal style={{ marginTop: "10px" }}>
                          <Style.TextDash
                            size={14}
                            weight="normal"
                            style={{ width: "15%" }}
                          >
                            {capitalize(conta.banco)}
                          </Style.TextDash>
                          <Style.TextDash
                            size={14}
                            weight="normal"
                            style={{ width: "15%" }}
                          >
                            {conta.agencia}
                          </Style.TextDash>
                          <Style.TextDash
                            size={14}
                            weight="normal"
                            style={{ width: "15%" }}
                          >
                            {conta.conta}
                          </Style.TextDash>
                          <Style.TextDash
                            size={14}
                            weight="normal"
                            style={{ width: "15%" }}
                          >
                            {CurrencyFormat(conta.saldo)}
                          </Style.TextDash>
                        </Style.ContHorizontal>
                      </>
                    );
                  })}
                  <Style.Separator />
                  <Style.ContHorizontalTotal>
                    <Style.TextDash size={18} weight="bold">
                      Total Geral:
                    </Style.TextDash>
                    <Style.TextDash size={18} weight="bold">
                      {CurrencyFormat(somaSaldo())}
                    </Style.TextDash>
                  </Style.ContHorizontalTotal>
                </div>
              </MyCard>

              <MyCard>
                  <Style.ContHorizontal>
                    <Style.TextDash size={14} weight="bold">
                      Pagos e Recebidos
                    </Style.TextDash>
                    <Button
                      variant={
                        theme === "dark" ? "outline-light" : "outline-dark"
                      }
                      onClick={() => setShowModal(true)}
                    >
                      Abrir Detalhes
                    </Button>
                  </Style.ContHorizontal>
                  
                  <Style.ProgressDiv>
                    <Style.ProgressBody>
                      <Style.ContHorizontal>
                        <Style.ContVertical>
                          <Style.TextDash size={16} weight="bold">
                            R$ 4.548.596
                          </Style.TextDash>
                          <Style.TextDash size={14} weight="normal">
                            Recebido
                          </Style.TextDash>
                          <Style.TextDash size={16} weight="bold">
                            R$ 548.596
                          </Style.TextDash>
                          <Style.TextDash size={14} weight="normal">
                            Pago
                          </Style.TextDash>
                        </Style.ContVertical>
                        <Style.ContVertical>
                          <div style={{ width: isMobile ? "80px" : "300px", margin: "20px" }}>
                            <ProgressBar variant="success" now={40} />
                          </div>
                          <div style={{ width: isMobile ? "80px" : "300px", margin: "20px" }}>
                            <ProgressBar variant="danger" now={60} />
                          </div>
                        </Style.ContVertical>
                        <Style.ContVertical>
                          <Style.TextDash size={16} weight="bold">
                            R$ 548.596
                          </Style.TextDash>
                          <Style.TextDash size={14} weight="normal">
                            a Receber
                          </Style.TextDash>
                          <Style.TextDash size={16} weight="bold">
                            R$ 48.596
                          </Style.TextDash>
                          <Style.TextDash size={14} weight="normal">
                            a Pagar
                          </Style.TextDash>
                        </Style.ContVertical>
                      </Style.ContHorizontal>
                    </Style.ProgressBody>
                  </Style.ProgressDiv>
                </MyCard>
            </Row>
        </Col>     


        <Col md={12} lg={12}>
          <Row className="g-4">
            <Col md={12}>
              <Row xs={1} md={2} className="g-4">
                <MyCard>
                  <Style.TextDash size={14} weight="bold">
                    Recebidos diários / semanal
                  </Style.TextDash>
                  <ChartColumn
                    options={optionColumn3(themeContext)}
                    series={dataColumn2}
                  />
                </MyCard>
                <MyCard>
                  <Style.ContHorizontal>
                    <Style.TextDash size={14} weight="bold">
                      Defluxo
                    </Style.TextDash>
                    <Dropdown>
                      <Dropdown.Toggle variant={theme} id="dropdown-basic">
                        Semana
                      </Dropdown.Toggle>
                      <Dropdown.Menu>
                        <Dropdown.Item href="#/action-1">
                          Semana 1
                        </Dropdown.Item>
                        <Dropdown.Item href="#/action-2">
                          Semana 2
                        </Dropdown.Item>
                        <Dropdown.Item href="#/action-3">
                          Semana 3
                        </Dropdown.Item>
                        <Dropdown.Item href="#/action-4">
                          Semana 4
                        </Dropdown.Item>
                      </Dropdown.Menu>
                    </Dropdown>
                  </Style.ContHorizontal>
                  <ChartLine
                    options={lineOptions(themeContext)}
                    series={lineSeries}
                  />
                </MyCard>
              </Row>
            </Col>
          </Row>
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

export default FinanceiroDia;
