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

    const response = await api.get(`/WSAPP07?pagesize=20&page=${page}&token=${token}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      auxResult = json.result.reduce((acc: any, current: any) => {
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);

      const sorted = [...auxResult].sort((a, b) => {
        const expirationComparison = b.issue_date.localeCompare(a.issue_date);
        if (expirationComparison !== 0) {
          return expirationComparison;
        }
        const documentComparison = a.document.localeCompare(b.document);
        if (documentComparison !== 0) {
          return documentComparison;
        }
        return b.customer.localeCompare(a.customer);
      });

      sorted.map((_, index: number) =>{
        sorted[index].mark = false
      })

      returnResult = [...sorted]
    }

    return returnResult
};


export const fetchSearch = async(searchText: string, token: string) => {
    let auxResult: any = []
    let returnResult: any = []

    const response = await api.get(`/WSAPP07?pagesize=50&page=1&searchKey=${searchText}&token=${token}`);
    const json: ApiResponse = response.data;

    if(json.status.code === '#200'){    

      auxResult = json.result.reduce((acc: any, current: any) => {
          json.result.mark = false
          const x = acc.find((item: { id: any; }) => item.id === current.id);
          return !x ? acc.concat([current]) : acc;
      }, []);
            
      const sorted = [...auxResult].sort((a, b) => {
        const expirationComparison = b.issue_date.localeCompare(a.issue_date);
        if (expirationComparison !== 0) {
          return expirationComparison;
        }
        const documentComparison = a.document.localeCompare(b.document);
        if (documentComparison !== 0) {
          return documentComparison;
        }
        return b.customer.localeCompare(a.customer);
      });

      sorted.map((_, index: number) =>{
        sorted[index].mark = false
      })

      returnResult = [...sorted]
    }

  return returnResult
}