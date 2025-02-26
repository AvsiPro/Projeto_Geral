import React, { createContext, useState, ReactNode } from 'react';

interface CartContextProps {
    cartContext: any;
    customerContext: any;
    paymentContext: any;
    tablePriceContext: any;
    setCartContext: React.Dispatch<React.SetStateAction<any>>;
    setCustomerContext: React.Dispatch<React.SetStateAction<any>>;
    setPaymentContext: React.Dispatch<React.SetStateAction<any>>;
    setTablePriceContext: React.Dispatch<React.SetStateAction<any>>;
}

interface Props {
    children: ReactNode;
}

export const CartContext = createContext<CartContextProps>({
    cartContext: [],
    customerContext: null,
    paymentContext: null,
    tablePriceContext: null,
    setCartContext: () => {},
    setCustomerContext: () => {},
    setPaymentContext: () => {},
    setTablePriceContext: () => {}
});

export const CartProvider: React.FC <Props> = ({ children }) => {

    const [cartContext, setCartContext] = useState<any>(() => {
        const cartData = localStorage.getItem('cartdata');

        if(cartData){
            return JSON.parse(cartData)
        }else {
            return []
        }
    });
    
    const [customerContext, setCustomerContext] = useState<any>(() => {
        const customerData = localStorage.getItem('customer');

        if(customerData){
            return JSON.parse(customerData);
        }else {
            return null
        }
    });
    
    const [paymentContext, setPaymentContext] = useState<any>(() => {
        const paymentData = localStorage.getItem('payment');

        if(paymentData){
            return JSON.parse(paymentData);
        }else {
            return null
        }
    });

    const [tablePriceContext, setTablePriceContext] = useState<any>(() => {
        const tablePriceData = localStorage.getItem('tableprice');

        if(tablePriceData){
            return JSON.parse(tablePriceData);
        }else {
            return {id: "001", description: "TABELA PADRAO"}
        }
    });

    return (
        <CartContext.Provider value={{
            cartContext,
            customerContext,
            paymentContext,
            tablePriceContext,
            setCartContext,
            setCustomerContext,
            setPaymentContext,
            setTablePriceContext
        }}>
            {children}
        </CartContext.Provider>
    );
};
