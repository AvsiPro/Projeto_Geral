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
  tablePriceSelected: any;
  imageProfile: any;
  orcamentoSelected: string;

  setAuthDetail: React.Dispatch<React.SetStateAction<PropAuthContext>>;
  setItemCart: React.Dispatch<React.SetStateAction<any>>;
  setCustomerSelected: React.Dispatch<React.SetStateAction<any>>;
  setPaymentSelected: React.Dispatch<React.SetStateAction<any>>;
  setTablePriceSelected: React.Dispatch<React.SetStateAction<any>>;
  setImageProfile: React.Dispatch<React.SetStateAction<any>>;
  setOrcamentoSelected: React.Dispatch<React.SetStateAction<any>>;
};

const defaultAuthDetail = { token: '', name: '', address: '', phone: '', email: '', user: '', password: '', code: ''};

const AppContext = createContext<AppContextType>({
  authDetail: defaultAuthDetail,
  itemCart: [],
  customerSelected: null,
  paymentSelected: null,
  tablePriceSelected: null,
  imageProfile: null,
  orcamentoSelected: '',

  setAuthDetail: () => {},
  setItemCart: () => {},
  setCustomerSelected: () => {},
  setTablePriceSelected: () => {},
  setPaymentSelected: () => {},
  setImageProfile: () => {},
  setOrcamentoSelected: () => {},
});

type Props = {
  children: React.ReactNode;
};

const AppProvider = ({ children }: Props) => {
  const [authDetail, setAuthDetail] = useState<PropAuthContext>(defaultAuthDetail);
  const [itemCart, setItemCart] = useState<any>([]);
  const [customerSelected, setCustomerSelected] = useState<any>(null);
  const [paymentSelected, setPaymentSelected] = useState<any>(null);
  const [tablePriceSelected, setTablePriceSelected] = useState<any>({id: "001", description: "TABELA PADRAO"});
  const [imageProfile, setImageProfile] = useState<any>(null);
  const [orcamentoSelected, setOrcamentoSelected] = useState<string>('');
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
            tablePriceSelected,
            imageProfile,
            orcamentoSelected,
            setAuthDetail,
            setItemCart,
            setCustomerSelected,
            setPaymentSelected,
            setTablePriceSelected,
            setImageProfile,
            setOrcamentoSelected,
          }}
        >
          {children}
        </AppContext.Provider>
      </StyledThemeProvider>
    </ThemeContext.Provider>
  );
};

export { AppContext, AppProvider };
