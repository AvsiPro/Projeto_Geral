import api from "../services/api";

interface ApiResponse {
    status: {
      code: string;
      message: string;
    };
    hasNext: boolean;
    result: any;
}

export const fetchData = async (page: number, token: string) => {

    let auxResult: any = []
    let returnResult: any = []

    //const response = await api.get(`/WSAPP02?pagesize=100&page=${page}&token=${token}`);
    const response = await api.get(`/WSAPP02?pagesize=9999&page=1&token=${token}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      auxResult = json.result.reduce((acc: any, current: any) => {
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);

      const sortedResult = [...auxResult].sort((a, b) => {
        return a.name.localeCompare(b.name);
      });

      sortedResult.map((_, index: number) =>{
        sortedResult[index].mark = false
      })

      returnResult = [...sortedResult]
    }

    return returnResult
};


export const fetchSearch = async(searchText: string, token: string) => {
    let auxResult: any = []
    let returnResult: any = []

    //const response = await api.get(`/WSAPP02?pagesize=100&page=1&searchKey=${searchText}&token=${token}`);
    const response = await api.get(`/WSAPP02?pagesize=9999&page=1&searchKey=${searchText}&token=${token}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      auxResult = json.result.reduce((acc: any, current: any) => {
          json.result.mark = false
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);
            
      const sortedResult = [...auxResult].sort((a, b) => {
        return a.name.localeCompare(b.name);
      });

      sortedResult.map((_, index: number) =>{
        sortedResult[index].mark = false
      })

      returnResult = [...sortedResult]
    }

  return returnResult
}