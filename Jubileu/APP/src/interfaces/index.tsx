export interface ApiResponse {
    status: {
      code: string;
      message: string;
    };
    hasNext: boolean;
    result: PropItemCartContext[];
}

export interface PropsProductsModal{
    getVisible: boolean;
    handleModalProducts: () => void;
    products: any;
    atualizaProdutos: (item: any) => void;
}

export interface PropsProdDetail{
    getVisible: boolean;
    handleModalProducts: () => void;
    products: any;
}

export interface PropsModalObs{
    getVisible: boolean;
    handleModalObs: () => void;
    changeTextObs: (change: string) => void;
    textObs: any;
    handleGeraPedido: () => void;
    handleGeraOrcamento: () => void;
}

export interface PropsCostumersModal{
    getVisible: boolean;
    handleModalCustomers: () => void;
    customers: any;
    atualizaClientes: (item: any) => void;
}

export interface PropsPaymentModal{
    getVisible: boolean;
    handleModalPayment: () => void;
    payment: any;
    atualizaPagamentos: (item: any) => void;
}

export interface PropsRegistModal{
    getVisible: boolean;
    BodyCustRegister: any
}

export interface PropsProducts{
    products: any;
    handleLoadMore: () => void;
    handleItem: (index: number) => void;
    isLoadBottom: boolean;
    isOnline: boolean;
    isOrder: boolean;
}

export interface PropsCustomers{
    customers: any;
    handleLoadMore: () => void;
    handleItem: (item: any) => void;
    handleCustomerFinancial: (item: any) => void;
    isLoading: boolean;
    isOnline: boolean;
}

export interface PropsPayment{
    payment: any;
    handleLoadMore: () => void;
    handleItem: (item: any) => void;
    isLoading: boolean;
    isOnline: boolean;
}

export interface PropsFinancial{
    financial: any;
    handleLoadMore: () => void;
    handleItem: (item: any) => void;
    isLoading: boolean;
    isOnline: boolean;
}


export interface PropsPopup{
    getVisible: boolean;
    handlePopup: (index: any) => void;
    type: string;
    filter: any;
    message: string;
}

export interface PropsPopupCopyOrder{
    getVisible: boolean;
    handlePopup: (index: any) => void;
}

export interface PropsFooter{
    buttomAdd: any;
}

export interface PropAuthContext{
    token: string;
    name: string;
    address: string;
    phone: string;
    email: string;
    user: string;
    password: string;
}

export interface PropItemCartContext{
    every(arg0: (item: any) => boolean): unknown;
    balance: number;
    brand: string;
    code: string;
    description: string;
    ean: string;
    gender: string;
    group: string;
    id: string;
    line: string;
    marked: boolean;
    material: string;
    ncm: string;
    price: number;
    type: string;
    selected_quantity : number;
}

export interface FormDataCustomer {
    name: string;
    short_name: string;
    cnpj: string;
    email: string;
    address: string;
    complement: string;
    cep: string;
    district: string;
    city: string;
    uf: string;
    contact: string;
    phone: string;
}