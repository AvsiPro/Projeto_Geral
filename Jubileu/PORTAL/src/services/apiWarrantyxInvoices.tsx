import api from "./api";

interface ApiResponse {
    status: {
      code: string;
      message: string;
    };
    hasNext: boolean;
    result: any;
  }

export const fetchData = async (product: string, token: string, invoice: string) => {

    let auxResult: any = []
    let returnResult: any = []

    const response = await api.get(`/WSAPP09?pagesize=100&page=1&product=${product}&token=${token}&invoice=${invoice}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      auxResult = json.result.reduce((acc: any, current: any) => {
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);

      const sortedResult = [...auxResult].sort((a, b) => {
        return a.invoice.localeCompare(b.invoice);
      });

      returnResult = [...sortedResult]
    }

    return returnResult
};