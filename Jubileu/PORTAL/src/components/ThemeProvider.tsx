import { useState, useEffect } from "react";
import { ThemeContext } from "../contexts/ThemeContext";
import { ThemeProvider as StyledThemeProvider } from 'styled-components';

import { lightTheme, darkTheme } from '../themes';

interface Props{
  children: any;
}

const ThemeProvider: React.FC <Props> = ({ children }) => {
  const [theme, setTheme] = useState<"light" | "dark">("light");
  const [themeContext, setThemeContext] = useState<any>(lightTheme)

  const toggleTheme = () => {
    setTheme(theme === "light" ? "dark" : "light");
    localStorage.setItem('theme',theme === "light" ? "dark" : "light")
  };

  useEffect(() => {
    const themeStorage: any = localStorage.getItem('theme');

    if(themeStorage !== null){
      setTheme(themeStorage)
      
      const themeAux = theme === 'light' ? lightTheme : darkTheme
      setThemeContext(themeAux)
    }

  }, [theme]);
  
  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      <StyledThemeProvider theme={themeContext}>
        {children}
      </StyledThemeProvider>
    </ThemeContext.Provider>
  );
};

export default ThemeProvider;
