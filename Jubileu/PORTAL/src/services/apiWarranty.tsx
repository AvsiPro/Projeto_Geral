import api from "./api";

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
    
    const response = await api.get(`/WSAPP11?pagesize=10&page=${page}&token=${token.trim()}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      auxResult = json.result.reduce((acc: any, current: any) => {
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);

      const sortedResult = [...auxResult].sort((a, b) => {
        return b.warranty.localeCompare(a.warranty);
      });

      returnResult = [...sortedResult]
    }

    return returnResult
};