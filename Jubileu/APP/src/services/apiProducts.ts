import { ApiResponse } from "../interfaces";
import AsyncStorage from "@react-native-async-storage/async-storage";
import api from "./api";


/** faz a chamada da api com paginacao, grava no estado de produtos e no storage (online) **/
export const apiProducts = async (page: number, products: any, filter: number, codTable: any) => {
    
    let returnResult: any = []  
    let pageResult: number = page
    let returnObject: any
    
    const pageSize = 100

    const response = await api.get(`/WSAPP03?pagesize=${pageSize}&page=${page}&codTab=${codTable.id}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){
        const itemSalva = [...products, ...json.result];
    
        const uniqueArray = itemSalva.reduce((acc: any[], current: any) => {
            const index = acc.findIndex((item: { id: any; marked: boolean }) => item.id === current.id);
          
            if (index === -1) {
              // O objeto não existe no acumulador, então o adicionamos
              return [...acc, current];
            } else {
              // O objeto já existe no acumulador
              if (acc[index].marked) {
                // O objeto existente tem marked como true, então o mantemos e não fazemos alterações
                return acc;
              } else if (current.marked) {
                // O objeto atual tem marked como true, então substituímos o objeto existente pelo objeto atual
                const updatedArray = [...acc];
                updatedArray[index] = current;
                return updatedArray;
              } else {
                // Ambos os objetos têm marked como false, então não fazemos alterações
                return acc;
              }
            }
          }, []);

        returnResult = sortProductsList(filter, uniqueArray)

        await AsyncStorage.removeItem("products")
        await AsyncStorage.setItem("products", JSON.stringify([...products, ...returnResult]));
        
        if(json.result.length === pageSize) {
            pageResult++
        }

    }else{
        returnResult = [...products]
        pageResult = 1
    }
    
    returnObject = {
        returnResult: returnResult,
        pageResult: pageResult
    }

    return returnObject;
};


/** faz a chamada no storage e grava no estado de produtos (offline) **/
export const storageProducts = async (filter: number) => {

    let returnResult: any = []  
    let returnObject: any

    try {
        const result = await AsyncStorage.getItem('products');

        if (result) {
            const itemSalva = JSON.parse(result);

            returnResult = itemSalva.reduce((acc: any, current: any) => {
                const x = acc.find((item: { id: any; }) => item.id === current.id);
                return !x ? acc.concat([current]) : acc;
            }, []);
    
            returnResult = sortProductsList(filter, returnResult)
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
export const searchProducts = async (searchQuery: string, isOnline: boolean, codTable: any) => {

    let returnResult: any = []  
    let returnObject: any

    if(isOnline){
        const response = await api.get(`/WSAPP03?pagesize=100&page=1&searchKey=${searchQuery}&codTab=${codTable.id}`);
        const json: ApiResponse = response.data;

        returnResult = json.result

    }else{
        const result = await AsyncStorage.getItem('products');

        if (result) {
            const productsStorage = JSON.parse(result);
            
            const filtered = productsStorage.filter((prods: any) => prods.description.includes(searchQuery));
            returnResult = filtered
        }
    }

    returnObject = {
        returnResult: returnResult,
        pageResult: 1
    }

    return returnObject;
}


export const sortProductsList = (filter: number, products: any) => {

    const sortedProdutos = [...products].sort((a, b) => {
        if (filter === 2) {
            return a.description.localeCompare(b.description);

        } else if (filter === 3) {
            return a.brand.localeCompare(b.brand);

        } else if (filter === 4) {
            return a.line.localeCompare(b.line);

        } else if (filter === 5) {
            return a - b;

        } else if (filter === 6) {
            return a.material.localeCompare(b.material);

        } else{
            return a.code.localeCompare(b.code);
        }
    });

    return sortedProdutos;
}