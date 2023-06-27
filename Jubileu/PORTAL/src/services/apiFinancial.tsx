import api from "./api";

interface ApiResponse {
    status: {
      code: string;
      message: string;
    };
    hasNext: boolean;
    result: any;
  }

export const fetchData = async (customer: string, token: string, type: string, seller: string) => {

    let auxResult: any = []
    let returnResult: any = []

    const response = await api.get(`/WSAPP05?pagesize=500&page=1&customer=${customer}&token=${token}&type=${type}&seller=${seller}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      auxResult = json.result.reduce((acc: any, current: any) => {
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);

      const sorted = [...auxResult].sort((a, b) => {
        const expirationComparison = b.expiration.localeCompare(a.expiration);
        if (expirationComparison !== 0) {
          return expirationComparison;
        }
        const documentComparison = a.document.localeCompare(b.document);
        if (documentComparison !== 0) {
          return documentComparison;
        }
        return b.installments.localeCompare(a.installments);
      });

      returnResult = [...sorted]
    }

    return returnResult
};