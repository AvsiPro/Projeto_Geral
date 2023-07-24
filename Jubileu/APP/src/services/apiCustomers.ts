import { ApiResponse } from "../interfaces";
import AsyncStorage from "@react-native-async-storage/async-storage";
import api from "./api";


/** faz a chamada da api com paginacao, grava no estado de cliente e no storage (online) **/
export const apiCustomers = async (page: number, customers: any, filter: number) => {

    let returnResult: any = []  
    let pageResult: number = page
    let returnObject: any
    
    const pageSize = 100

    const response = await api.get(`/WSAPP02?pagesize=${pageSize}&page=${page}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    
        const itemSalva = [...customers, ...json.result];
        
        returnResult = itemSalva.reduce((acc, current) => {
            const x = acc.find((item: { id: any; }) => item.id === current.id);
            return !x ? acc.concat([current]) : acc;
        }, []);

        returnResult = sortCustomerList(filter, returnResult)

        await AsyncStorage.removeItem("customers")
        await AsyncStorage.setItem("customers", JSON.stringify([...customers, ...returnResult]));

        if(json.result.length === pageSize) {
            pageResult++
        }
        
    }else{
        returnResult = [...customers]
        pageResult = 1
    }

    returnObject = {
        returnResult: returnResult,
        pageResult: pageResult
    }

    return returnObject;  
};


/** faz a chamada no storage e grava no estado de clientes (offline) **/
export const storageCustomers = async (filter: number) => {

    let returnResult: any = []  
    let returnObject: any

    try {
        const result = await AsyncStorage.getItem('customers');

        if (result) {
            const itemSalva = JSON.parse(result);

            returnResult = itemSalva.reduce((acc: any, current: any) => {
                const x = acc.find((item: { id: any; }) => item.id === current.id);
                return !x ? acc.concat([current]) : acc;
            }, []);
    
            returnResult = sortCustomerList(filter, returnResult)
        }

    } catch (error) {
        console.error(error);
    }

    returnObject = {
        returnResult: returnResult,
        pageResult: 1
    }

    return returnObject;
};


/** faz a chamada da api conforme o usuario vai digitando na pesquisa.
    Tem um atraso de 500 milisegundo para aguardar o fim da digitacao e nao encavalar a chamada de api
**/
export const searchCustomers = async (searchQuery: string, isOnline: boolean) => {

    let returnResult: any = []  
    let returnObject: any

    if(isOnline){
        const response = await api.get(`/WSAPP02?pagesize=100&page=1&searchKey=${searchQuery}`);
        const json: ApiResponse = response.data;

        returnResult = json.result

    }else{
        const result = await AsyncStorage.getItem('customers');

        if (result) {
            const customersStorage = JSON.parse(result);
            
            const filtered = customersStorage.filter((client: any) => client.description.includes(searchQuery));
            returnResult = filtered
        }
    }

    returnObject = {
        returnResult: returnResult,
        pageResult: 1
    }

    return returnObject;
}


export const sortCustomerList = (filter: number, customers: any) => {

    const sortedClientes = [...customers].sort((a, b) => {
        if (filter === 2) {
            return a.name.localeCompare(b.name);

        } else if (filter === 3) {
            return a.cnpj.localeCompare(b.cnpj);

        } else{
            return a.code.localeCompare(b.code);
        }
    });

    return sortedClientes;
}