
interface OptionSection {
    color: string;
    backgroundColor: string;
    title: string;
    action: string;
}

export const optSections: OptionSection[] = [
    {
        color: "primary",
        backgroundColor: "#D3EFFF",
        title: "Pedidos" as any,
        action: 'pedidos'
    },
    {
        color: "grey",
        backgroundColor: "#FFE2CB",
        title: "Clientes" as any,
        action: 'clientes'
    },
    {
        color: "grey",
        backgroundColor: "#D3EFFF",
        title: "Produtos" as any,
        action: 'produtos'
    },
];

export const popup = [
    {
        icon: 'clouduploado',
        title: 'Alterar foto',
        color: 'darkblue',
        action: 'picture'
    },
    {
        icon: 'profile',
        color: 'orange',
        title: 'Visualizar perfil',
        action: 'profile'
    },
    {
        icon: 'setting',
        color: 'grey',
        title: 'Personalizar tema',
        action: 'theme'
    },
    {
        icon: 'export2',
        color: 'tomato',
        title: 'Sair',
        action: 'exit'
    }
]

export const filterOrder = [null, 'Documento', 'Razão Social', 'CNPJ', 'Emissão']

export const filterProducts = [null, 'Código', 'Descrição', 'Marca', 'Linha', 'Valor', 'Material']

export const filterCustomers = [null, 'Código', 'Nome', 'CNPJ']