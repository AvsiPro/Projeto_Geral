import React, { createContext, useContext, useState, ReactNode, useEffect } from 'react';
import { UserContext } from './userContext';
import api from '../services/api';

interface CartContextProps {
    cartContext: any;
    customerContext: any;
    paymentContext: any;
    setCartContext: React.Dispatch<React.SetStateAction<any>>;
    setCustomerContext: React.Dispatch<React.SetStateAction<any>>;
    setPaymentContext: React.Dispatch<React.SetStateAction<any>>;
}

interface Props {
    children: ReactNode;
}

interface ApiResponse {
    status: {
      code: string;
      message: string;
    };
    hasNext: boolean;
    result: any;
}

export const CartContext = createContext<CartContextProps>({
    cartContext: [],
    customerContext: null,
    paymentContext: null,
    setCartContext: () => {},
    setCustomerContext: () => {},
    setPaymentContext: () => {}
});

export const CartProvider: React.FC <Props> = ({ children }) => {

    const { userContext } = useContext(UserContext)


    const [cartContext, setCartContext] = useState<any>(() => {
        const cartData = localStorage.getItem('cartdata');

        if(cartData){
            return JSON.parse(cartData)
        }else {
            return []
        }
    });
    
    const [customerContext, setCustomerContext] = useState<any>(null);
    
    const [paymentContext, setPaymentContext] = useState<any>(() => {
        const paymentData = localStorage.getItem('payment');

        if(paymentData){
            return JSON.parse(paymentData);
        }else {
            return null
        }
    });

    useEffect(() => {
        initializeCustomerContext();
    }, []);

    const initializeCustomerContext = async () => {
        let customerData: any;
      
        if (userContext.type === 'C') {
            customerData = await apiCustomer();

            const custAux = JSON.parse(customerData)
            
            const payment = {
                code: custAux.payment,
                form: custAux.payment_description,
                id: custAux.payment,
                description: custAux.payment_description,
                mark: true
            }
            setPaymentContext(payment);
          
        } else {
            customerData = localStorage.getItem('customer');
        }

        if (customerData) {
            setCustomerContext(JSON.parse(customerData));
        } else {
            setCustomerContext(null);
        }
    };


    const apiCustomer = async() => {
        let auxResult: any = []
        let returnResult: any = []
    
        const response = await api.get(`/WSAPP02?pagesize=1&page=1&byId=true&SearchKey=${userContext.code}`);
        const json: ApiResponse = response.data;

    
        if(json.status.code === '#200'){    
    
          auxResult = json.result.reduce((acc: any, current: any) => {
              const x = acc.find((item: { id: any; }) => item.id === current.id);
              return !x ? acc.concat([current]) : acc;
          }, []);
    
          auxResult.map((_: any, index: number) =>{
            auxResult[index].mark = false
          })
    
          returnResult = [...auxResult]
        }

        return JSON.stringify(returnResult[0])
    }

    return (
        <CartContext.Provider value={{
            cartContext,
            customerContext,
            paymentContext,
            setCartContext,
            setCustomerContext,
            setPaymentContext
        }}>
            {children}
        </CartContext.Provider>
    );
};
