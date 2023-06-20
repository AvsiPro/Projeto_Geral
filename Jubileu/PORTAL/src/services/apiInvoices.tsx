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
    
    const response = await api.get(`/WSAPP08?pagesize=10&page=${page}&token=${token.trim()}&type=${type}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      auxResult = json.result.reduce((acc: any, current: any) => {
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);

      returnResult = [...auxResult]
    }

    return returnResult
};