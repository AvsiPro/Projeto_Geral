import React, { createContext, useState, ReactNode } from 'react';

interface UserContextProps {
    userContext: any;
    setUserContext: React.Dispatch<React.SetStateAction<PropAuthContext>>;
}

interface Props {
    children: ReactNode;
}

interface PropAuthContext{
    token: string;
    name: string;
    address: string;
    phone: string;
    email: string;
    user: string;
    password: string;
    code: string;
}

const defaultAuthDetail = { token: '', name: '', address: '', phone: '', email: '', user: '', password: '', code: ''};

export const UserContext = createContext<UserContextProps>({
    userContext: defaultAuthDetail,
    setUserContext: () => {}
});

export const UserProvider: React.FC <Props> = ({ children }) => {
    const [userContext, setUserContext] = useState<PropAuthContext>(() => {
        const userData = localStorage.getItem('userdata');

        if(userData){
            return JSON.parse(userData)
        }else {
            return defaultAuthDetail
        }
    });

    return (
        <UserContext.Provider value={{
            userContext,
            setUserContext
        }}>
            {children}
        </UserContext.Provider>
    );
};
