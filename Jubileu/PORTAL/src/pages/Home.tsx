import React, { useContext } from "react";
import * as Style from "./styles";

import { ThemeContext } from "../contexts/ThemeContext";
import { WindowDimensionsContext } from "../contexts/WindowDimensionsContext";
import { darkTheme, lightTheme } from "../themes";
import { useMediaQuery } from "react-responsive";

import Header from "../components/header";
import Navbar from "../components/navbar";
import CustomerDash from "../dashboards/Customer";

const Home: React.FC = () => {
  
  const { theme } = useContext(ThemeContext);
  const { windowDimensions } = useContext(WindowDimensionsContext);
  const themeContext = theme === "light" ? lightTheme : darkTheme;
  const isMobile = useMediaQuery({ query: "(max-width: 767px)" });

  return (
    <Style.ContainerAll theme={themeContext}>
      {/* Menu lateral */ !isMobile && <Navbar />}
      
      <Style.Container isMobile={isMobile}>
        <Header />
        <Style.StackDash windowDimensions={windowDimensions} className="mx-auto" gap={4}>
          <CustomerDash />

        </Style.StackDash>
      </Style.Container>
    </Style.ContainerAll>
  );
};

export default Home;
