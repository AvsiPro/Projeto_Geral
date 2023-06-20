import React, { createContext, useState } from 'react';
import { ThemeProvider as StyledThemeProvider } from 'styled-components/native';

import { PropAuthContext } from '../interfaces';

interface ITheme {
  handleColorChange: (color: string) => void;
  colors: {
    primary: string;
    text: string;
  };
}

const initialTheme: ITheme = {
  handleColorChange: () => {},
  colors: {
    primary: '#426AD0',
    text: '#fff',
  },
};

export const ThemeContext = createContext(initialTheme);
export type ThemeType = typeof initialTheme;

declare module 'styled-components/native' {
  export interface DefaultTheme extends ThemeType {}
}

type AppContextType = {
  authDetail: PropAuthContext;
  itemCart: any;
  customerSelected: any;
  paymentSelected: any;
  imageProfile: any;

  setAuthDetail: React.Dispatch<React.SetStateAction<PropAuthContext>>;
  setItemCart: React.Dispatch<React.SetStateAction<any>>;
  setCustomerSelected: React.Dispatch<React.SetStateAction<any>>;
  setPaymentSelected: React.Dispatch<React.SetStateAction<any>>;
  setImageProfile: React.Dispatch<React.SetStateAction<any>>;
};

const defaultAuthDetail = { token: '', name: '', address: '', phone: '', email: '', user: '', password: ''};

const AppContext = createContext<AppContextType>({
  authDetail: defaultAuthDetail,
  itemCart: [],
  customerSelected: null,
  paymentSelected: null,
  imageProfile: null,

  setAuthDetail: () => {},
  setItemCart: () => {},
  setCustomerSelected: () => {},
  setPaymentSelected: () => {},
  setImageProfile: () => {},
});

type Props = {
  children: React.ReactNode;
};

const AppProvider = ({ children }: Props) => {
  const [authDetail, setAuthDetail] = useState<PropAuthContext>(defaultAuthDetail);
  const [itemCart, setItemCart] = useState<any>([]);
  const [customerSelected, setCustomerSelected] = useState<any>(null);
  const [paymentSelected, setPaymentSelected] = useState<any>(null);
  const [imageProfile, setImageProfile] = useState<any>(null);
  const [theme, setTheme] = useState(initialTheme);

  const handleColorChange = (color: string) => {
    setTheme({
      ...theme,
      colors: {
        ...theme.colors,
        primary: color,
      },
    });
  };

  return (
    <ThemeContext.Provider value={{ ...theme, handleColorChange }}>
      <StyledThemeProvider theme={theme}>
        <AppContext.Provider
          value={{
            authDetail,
            itemCart,
            customerSelected,
            paymentSelected,
            imageProfile,
            setAuthDetail,
            setItemCart,
            setCustomerSelected,
            setPaymentSelected,
            setImageProfile,
          }}
        >
          {children}
        </AppContext.Provider>
      </StyledThemeProvider>
    </ThemeContext.Provider>
  );
};

export { AppContext, AppProvider };
