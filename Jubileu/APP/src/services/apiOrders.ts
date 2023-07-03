import { ApiResponse } from "../interfaces";
import AsyncStorage from "@react-native-async-storage/async-storage";
import api from "./api";


/** faz a chamada da api com paginacao, grava no estado de pedido e no storage (online) **/
export const apiOrders = async (page: number, orders: any, filter: number, token: string) => {

    let returnResult: any = []  
    let pageResult: number = page
    let returnObject: any

    const response = await api.get(`/WSAPP07?pagesize=10&page=${page}&token=${token}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    
        const itemSalva = [...orders, ...json.result];
        
        returnResult = itemSalva.reduce((acc, current) => {
            const x = acc.find((item: { id: any; }) => item.id === current.id);
            return !x ? acc.concat([current]) : acc;
        }, []);

        returnResult = sortOrderList(filter, returnResult)

        returnResult.map((item: any) =>{
            item.orcamento = 'N'
        })

        await AsyncStorage.removeItem("orders")
        await AsyncStorage.setItem("orders", JSON.stringify([...orders, ...returnResult]));

        pageResult++
    }

    const orcOld = await AsyncStorage.getItem('@orcamento')
    let orcNew: any = []

    if (!!orcOld){
        orcNew = JSON.parse(orcOld)
        orcNew.sort((a: any, b: any) => b.numorc.localeCompare(a.numorc));
        returnResult = orcNew.concat(returnResult);
    }


    returnObject = {
        returnResult: returnResult,
        pageResult: pageResult
    }

    return returnObject;  
};


/** faz a chamada no storage e grava no estado de pedidos (offline) **/
export const storageOrders = async (filter: number) => {

    let returnResult: any = []  
    let returnObject: any

    try {
        const result = await AsyncStorage.getItem('orders');

        if (result) {
            const itemSalva = JSON.parse(result);

            returnResult = itemSalva.reduce((acc: any, current: any) => {
                const x = acc.find((item: { id: any; }) => item.id === current.id);
                return !x ? acc.concat([current]) : acc;
            }, []);
    
            returnResult = sortOrderList(filter, returnResult)

            returnResult.map((item: any) =>{
                item.orcamento = 'N'
            })
        }

    } catch (error) {
        console.error(error);
    }

    const orcOld = await AsyncStorage.getItem('@orcamento')
    let orcNew: any = []

    if (!!orcOld){
        orcNew = JSON.parse(orcOld)
        orcNew.sort((a: any, b: any) => b.numorc.localeCompare(a.numorc));
        returnResult = orcNew.concat(returnResult);
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
export const searchOrders = async (searchQuery: string, isOnline: boolean) => {

    let returnResult: any = []  
    let returnObject: any

    if(isOnline){
        const response = await api.get(`/WSAPP07?pagesize=100&page=1&searchKey=${searchQuery}`);
        const json: ApiResponse = response.data;

        returnResult = json.result

    }else{
        const result = await AsyncStorage.getItem('orders');

        if (result) {
            const ordersStorage = JSON.parse(result);
            
            const filtered = ordersStorage.filter((client: any) => client.description.includes(searchQuery));
            returnResult = filtered
        }
    }

    returnResult.map((item: any) =>{
        item.orcamento = 'N'
    })

    const orcOld = await AsyncStorage.getItem('@orcamento')
    let orcNew: any = []

    if (!!orcOld){
        orcNew = JSON.parse(orcOld)
        orcNew.sort((a: any, b: any) => b.numorc.localeCompare(a.numorc));
        returnResult = orcNew.concat(returnResult);
    }

    returnObject = {
        returnResult: returnResult,
        pageResult: 2
    }

    return returnObject;
}


export const sortOrderList = (filter: number, orders: any) => {

    const sortedpedidos = [...orders].sort((a, b) => {
        if (filter === 1) {
            return a.document.localeCompare(b.document);

        }else if (filter === 2) {
            return a.customer_name.localeCompare(b.customer_name);

        } else if (filter === 3) {
            return a.customer_cnpj.localeCompare(b.customer_cnpj);

        } else{
            return b.issue_date.localeCompare(a.issue_date);
        }
    });

    return sortedpedidos;
}