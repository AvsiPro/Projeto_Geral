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
    handleGeraPedido: (orcamento: string) => void;
    load: boolean;
    continuaOrc: boolean;
}

export interface PropsCostumersModal{
    getVisible: boolean;
    handleModalCustomers: () => void;
    customers: any;
    atualizaClientes: (item: any) => void;
    handleContinuaOrc: () => void;
}

export interface PropsPaymentModal{
    getVisible: boolean;
    handleModalPayment: () => void;
    payment: any;
    atualizaPagamentos: (item: any) => void;
}

export interface PropsTablePriceModal{
    getVisible: boolean;
    handleModalTablePrice: () => void;
    tablePrice: any;
    atualizaTabPreco: (item: any) => void;
    atualizaProdutos: (item: any) => void;
}

export interface PropsRegistModal{
    getVisible: boolean;
    BodyCustRegister: any
}

export interface PropsProducts{
    products: any;
    handleLoadMore: () => void;
    handleItem: (index: number) => void;
    handleLongItem: (index: number) => void;
    isLoadBottom: boolean;
    isOnline: boolean;
    isOrder: boolean;
    hasBar?: boolean;
    handleMinus?: (item: any) => void;
    handleMore?: (item: any) => void;
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


export interface PropsTablePrice{
    tablePrice: any;
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
    load: boolean;
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
    code: string;
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
    codegroup: string;
    id: string;
    line: string;
    marked: boolean;
    material: string;
    ncm: string;
    price: any;
    type: string;
    selected_quantity : number;
    realPrice: number;
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
    another_address: string;
    another_cep: string;
    another_district: string;
    token: string;
    payment: string;
    payment_description: string;
}