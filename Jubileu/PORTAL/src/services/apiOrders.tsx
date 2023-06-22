import api from "./api";

interface ApiResponse {
    status: {
      code: string;
      message: string;
    };
    hasNext: boolean;
    result: any;
  }

export const fetchData = async (page: number, token: string, type: string) => {

    let auxResult: any = []
    let returnResult: any = []

    const response = await api.get(`/WSAPP07?pagesize=20&page=${page}&token=${token}&type=${type}`);
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

    return returnResult
};


export const fetchSearch = async(searchText: string, token: string, type: string) => {
    let auxResult: any = []
    let returnResult: any = []

    const response = await api.get(`/WSAPP07?pagesize=50&page=1&searchKey=${searchText}&token=${token}&type=${type}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      auxResult = json.result.reduce((acc: any, current: any) => {
          json.result.mark = false
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);
            

      auxResult.map((_: any, index: number) =>{
        auxResult[index].mark = false
      })

      returnResult = [...auxResult]
    }

  return returnResult
}