import React, { useContext, useEffect, useState } from "react";
import * as Style from "./styles";

import { DropdownButton, Dropdown } from "react-bootstrap";

import { ThemeContext } from "../contexts/ThemeContext";
import { WindowDimensionsContext } from "../contexts/WindowDimensionsContext";
import { darkTheme, lightTheme } from "../themes";
import { useMediaQuery } from "react-responsive";

import Header from "../components/header";
import Navbar from "../components/navbar";

import FluxoCaixa from "../dashboards/FluxoCaixa";
import VendasConsolidado from "../dashboards/VendasConsolidado";
import VendasDiarias from "../dashboards/VendasDiarias";
import PainelVendas from "../dashboards/PainelVendas";

import { titleMonth } from "../utils/dateFormat";

const Dashboard: React.FC = () => {
  
  const { theme } = useContext(ThemeContext);
  const { windowDimensions } = useContext(WindowDimensionsContext);
  const themeContext = theme === "light" ? lightTheme : darkTheme;
  const isMobile = useMediaQuery({ query: "(max-width: 767px)" });
  
  const [dash, setDash] = useState('dash1')
  const [mes, setMes] = useState('Mês')
  const [ano, setAno] = useState('Ano')


  useEffect(() => {
    const currentDate = new Date();
    const month = String(currentDate.getMonth() + 1)
    const year = currentDate.getFullYear();

    setMes(month)
    setAno(year.toString())

  },[])

  const handleMonthClick = (selectedMonth: string) => {
    setMes(selectedMonth);
  };

  const handleYearClick = (selectedYear: string) => {
    setAno(selectedYear);
  };

  const monthsArray = Array.from({ length: 12 }, (_, index) => index + 1);
  const yearsArray = [2023, 2022, 2021, 2020];

  const FiltersDash1 = () => {
    return (
      <Style.DashHorizontal>
        <DropdownButton
          variant={theme}
          menuVariant={theme}
          title={titleMonth(mes)}
        >
          {monthsArray.map((month) => (
            <Dropdown.Item
              key={month}
              onClick={() => handleMonthClick(String(month))}
            >
              {titleMonth(String(month))}
            </Dropdown.Item>
          ))}
        </DropdownButton>

        <DropdownButton
          variant={theme}
          menuVariant={theme}
          title={ano}
          style={{ marginLeft: 10 }}
        >
          {yearsArray.map((year) => (
            <Dropdown.Item
              key={year}
              onClick={() => handleYearClick(String(year))}
            >
              {year}
            </Dropdown.Item>
          ))}
        </DropdownButton>
      </Style.DashHorizontal>
    )
  }
  

  const titleButtonDash = () => {
    if(dash === 'dash1'){
      return 'Fluxo Caixa - Financeiro'
    
    }else if(dash === 'dash2'){
      return 'Vendas Consolidado'

    }else if(dash === 'dash3'){
      return 'Vendas Diárias'

    }else if(dash === 'dash4'){
      return 'Painel de Vendas'
    
    }else {
      return 'Dashboards'
    }
  }

  return (
    <Style.ContainerAll theme={themeContext}>
      {/* Menu lateral */ !isMobile && <Navbar />}
      
      <Style.Container isMobile={isMobile}>
        <Header />
        <Style.StackDash windowDimensions={windowDimensions} className="mx-auto" gap={4}>

          <Style.DashHorizontal>
            <DropdownButton
              variant={theme}
              menuVariant={theme}
              title={titleButtonDash()}
            >
              <Dropdown.Item onClick={()=> setDash('dash1')}>Fluxo Caixa - Financeiro</Dropdown.Item>
              <Dropdown.Item onClick={()=> setDash('dash2')}>Vendas Consolidado</Dropdown.Item>
              <Dropdown.Item onClick={()=> setDash('dash3')}>Vendas Diárias</Dropdown.Item>
              <Dropdown.Item onClick={()=> setDash('dash4')}>Painel de Vendas</Dropdown.Item>
            </DropdownButton>

            <FiltersDash1 />
          </Style.DashHorizontal>

          { dash === 'dash1' && <FluxoCaixa ano={ano} mes={mes}/> }
          { dash === 'dash2' && <VendasConsolidado ano={ano} mes={mes} /> }
          { dash === 'dash3' && <VendasDiarias ano={ano} mes={mes} /> }
          { dash === 'dash4' && <PainelVendas /> }


        </Style.StackDash>
       
      </Style.Container>
    </Style.ContainerAll>
  );
};

export default Dashboard;
