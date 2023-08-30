import api from "./api";

interface ApiResponse {
    status: {
      code: string;
      message: string;
    };
    hasNext: boolean;
    result: any;
  }

export const fetchData = async (page: number, ) => {

    let auxResult: any = []
    let returnResult: any = []
    let tablePrice: any
    
    const tablePriceData = localStorage.getItem('tableprice');

    if(!!tablePriceData){
        tablePrice = JSON.parse(tablePriceData);
    }else {
        tablePrice = {id: "001", description: "TABELA PADRAO"}
    }
        
    //const response = await api.get(`/WSAPP03?pagesize=9999&page=${page}&codTab=${tablePrice.id}`);
    const response = await api.get(`/WSAPP03?pagesize=9999&page=1&codTab=${tablePrice.id}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      auxResult = json.result.reduce((acc: any, current: any) => {
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);

      const sortedResult = [...auxResult].sort((a, b) => {
        return a.code.localeCompare(b.code);
      });

      sortedResult.map((_, index: number) =>{
        sortedResult[index].mark = false
      })

      returnResult = [...sortedResult]
    }

    return returnResult
};


export const fetchSearch = async(searchText: string) => {
    let auxResult: any = []
    let returnResult: any = []
    let tablePrice: any
    
    const tablePriceData = localStorage.getItem('tableprice');

    if(tablePriceData){
        tablePrice = JSON.parse(tablePriceData);
    }else {
        tablePrice = {id: "001", description: "TABELA PADRAO"}
    }

    const response = await api.get(`/WSAPP03?pagesize=99999&page=1&searchKey=${searchText}&codTab=${tablePrice.id}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      auxResult = json.result.reduce((acc: any, current: any) => {
          json.result.mark = false
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);
            
      const sortedResult = [...auxResult].sort((a, b) => {
        return a.code.localeCompare(b.code);
      });

      sortedResult.map((_, index: number) =>{
        sortedResult[index].mark = false
      })

      returnResult = [...sortedResult]
    }

  return returnResult
}