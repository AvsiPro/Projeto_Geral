import React, { useContext, useEffect, useState } from "react";
import * as Style from "./styles";

import { DropdownButton, Dropdown } from "react-bootstrap";

import { ThemeContext } from "../contexts/ThemeContext";
import { WindowDimensionsContext } from "../contexts/WindowDimensionsContext";
import { darkTheme, lightTheme } from "../themes";
import { useMediaQuery } from "react-responsive";

import Header from "../components/header";
import Navbar from "../components/navbar";

import ModeloDash from "../dashboards/Modelo";
import FluxoCaixa from "../dashboards/FluxoCaixa";
import VendasConsolidado from "../dashboards/VendasConsolidado";
import VendasDiarias from "../dashboards/VendasDiarias";

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

  const FiltersDash1 = () => {
    return (
      <Style.DashHorizontal>
        <DropdownButton
          variant={theme}
          menuVariant={theme}
          title={titleMonth(mes)}
        >
          <Dropdown.Item onClick={()=> setMes('1')}>Janeiro</Dropdown.Item>
          <Dropdown.Item onClick={()=> setMes('2')}>Fevereiro</Dropdown.Item>
          <Dropdown.Item onClick={()=> setMes('3')}>Março</Dropdown.Item>
          <Dropdown.Item onClick={()=> setMes('4')}>Abril</Dropdown.Item>
          <Dropdown.Item onClick={()=> setMes('5')}>Maio</Dropdown.Item>
          <Dropdown.Item onClick={()=> setMes('6')}>Junho</Dropdown.Item>
          <Dropdown.Item onClick={()=> setMes('7')}>Julho</Dropdown.Item>
          <Dropdown.Item onClick={()=> setMes('8')}>Agosto</Dropdown.Item>
          <Dropdown.Item onClick={()=> setMes('9')}>Setembro</Dropdown.Item>
          <Dropdown.Item onClick={()=> setMes('10')}>Outubro</Dropdown.Item>
          <Dropdown.Item onClick={()=> setMes('11')}>Novembro</Dropdown.Item>
          <Dropdown.Item onClick={()=> setMes('12')}>Dezembro</Dropdown.Item>
          
        </DropdownButton>

        <DropdownButton
          variant={theme}
          menuVariant={theme}
          title={ano}
          style={{marginLeft:10}}
        >
          <Dropdown.Item onClick={()=> setAno('2023')}>2023</Dropdown.Item>
          <Dropdown.Item onClick={()=> setAno('2022')}>2022</Dropdown.Item>
          <Dropdown.Item onClick={()=> setAno('2021')}>2021</Dropdown.Item>
          <Dropdown.Item onClick={()=> setAno('2020')}>2020</Dropdown.Item>
        </DropdownButton>
      </Style.DashHorizontal>
    )
  }
  
  const FiltersDash3 = () => {
    return (
      <Style.DashHorizontal>
        <DropdownButton
          variant={theme}
          menuVariant={theme}
          title={titleMonth(mes)}
        >
          <Dropdown.Item onClick={()=>{setMes('1')}}>Janeiro</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('2')}}>Fevereiro</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('3')}}>Março</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('4')}}>Abril</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('5')}}>Maio</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('6')}}>Junho</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('7')}}>Julho</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('8')}}>Agosto</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('9')}}>Setembro</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('10')}}>Outubro</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('11')}}>Novembro</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('12')}}>Dezembro</Dropdown.Item>
          
        </DropdownButton>

        <DropdownButton
          variant={theme}
          menuVariant={theme}
          title={ano}
          style={{marginLeft:10}}
        >
          <Dropdown.Item onClick={()=>{setAno('2023')}}>2023</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setAno('2022')}}>2022</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setAno('2021')}}>2021</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setAno('2020')}}>2020</Dropdown.Item>
        </DropdownButton>
      </Style.DashHorizontal>
    )
  }

  const FiltersDash4 = () => {
    return (
      <Style.DashHorizontal>

        <DropdownButton
          variant={theme}
          menuVariant={theme}
          title={titleMonth(mes)}
          style={{marginLeft:10}}
        >
          <Dropdown.Item onClick={()=>{setMes('1')}}>Janeiro</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('2')}}>Fevereiro</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('3')}}>Março</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('4')}}>Abril</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('5')}}>Maio</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('6')}}>Junho</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('7')}}>Julho</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('8')}}>Agosto</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('9')}}>Setembro</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('10')}}>Outubro</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('11')}}>Novembro</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setMes('12')}}>Dezembro</Dropdown.Item>
          
        </DropdownButton>

        <DropdownButton
          variant={theme}
          menuVariant={theme}
          title={ano}
          style={{marginLeft:10}}
        >
          <Dropdown.Item onClick={()=>{setAno('2023')}}>2023</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setAno('2022')}}>2022</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setAno('2021')}}>2021</Dropdown.Item>
          <Dropdown.Item onClick={()=>{setAno('2020')}}>2020</Dropdown.Item>
        </DropdownButton>
      </Style.DashHorizontal>
    )
  }

  const titleButtonDash = () => {
    if(dash === 'dash1'){
      return 'Fluxo Caixa - Financeiro'
    
    /*}else if(dash === 'dash2'){
      return 'Modelo'
    */
    }else if(dash === 'dash3'){
      return 'Vendas Consolidado'

    }else if(dash === 'dash4'){
      return 'Vendas Diárias'
    
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
              {/*<Dropdown.Item onClick={()=> setDash('dash2')}>Modelo</Dropdown.Item>*/}
              <Dropdown.Item onClick={()=> setDash('dash3')}>Vendas Consolidado</Dropdown.Item>
              <Dropdown.Item onClick={()=> setDash('dash4')}>Vendas Diárias</Dropdown.Item>
            </DropdownButton>

            { dash === 'dash1' ? <FiltersDash1 />
              : dash === 'dash3' ? <FiltersDash3 />
              : dash === 'dash4' ? <FiltersDash4 />
              : <></>
            }
          </Style.DashHorizontal>

          { 
            dash === 'dash1' ? <FluxoCaixa ano={ano} mes={mes}/>
            //: dash === 'dash2' ? <ModeloDash />
            : dash === 'dash3' ? <VendasConsolidado ano={ano} mes={mes} />
            : <VendasDiarias ano={ano} mes={mes} />
          }
        </Style.StackDash>
       
      </Style.Container>
    </Style.ContainerAll>
  );
};

export default Dashboard;
