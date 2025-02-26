import React from "react";
import * as Style from './styles';

import { CurrencyFormat } from "../utils/currencyFormat";
import { SToD } from "../utils/dateFormat";
import { CgcFormat } from "../utils/cgcFormat";

interface Props {
    data: any;
}

const InvoiceDetail: React.FC <Props> = ({data}) => {

    return (
        <Style.InvoiceDetailContainer>
            <Style.TextH4 style={{color:'#000',marginBottom:20}}>Detalhes da Nota</Style.TextH4>

            <Style.InvoiceDetailSection>
                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Item</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.item}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Produto</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.product}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Preço</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{CurrencyFormat(data.price)}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Quantidade</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.quantity}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Emissão</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{SToD(data.emission)}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>
            </Style.InvoiceDetailSection>

            <hr/>
            <Style.InvoiceDetailLabel>Dados da Empresa</Style.InvoiceDetailLabel>

            <Style.InvoiceDetailSection>
                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Nome</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.company_name}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>CNPJ</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{CgcFormat(data.company_cnpj)}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn></Style.InvoiceDetailsColumn>
                <Style.InvoiceDetailsColumn></Style.InvoiceDetailsColumn>
                <Style.InvoiceDetailsColumn></Style.InvoiceDetailsColumn>
            </Style.InvoiceDetailSection>

            <Style.InvoiceDetailSection style={{marginTop:25}}>
                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Endereço</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.company_ender}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Bairro</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.company_district}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Cidade</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.company_city}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Estado</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.company_state}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Inscrição Estadual</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.company_state_reg}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>
            </Style.InvoiceDetailSection>

            <hr/>
            <Style.InvoiceDetailLabel>Detalhes</Style.InvoiceDetailLabel>

            <Style.InvoiceDetailSection>
                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Filial Faturamento</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.branch_invoice}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Nota</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.invoice}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Série</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.invoice_series}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Chave NFE</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.key_nfe}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>
            </Style.InvoiceDetailSection>

            <Style.InvoiceDetailSection style={{marginTop:25}}>
                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>CFOP</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.desc_cfop}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Base ICMS</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{data.base_icm}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Valor ICMS</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{CurrencyFormat(data.value_icm)}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>

                <Style.InvoiceDetailsColumn>
                    <Style.InvoiceDetailTitle>Valor IPI</Style.InvoiceDetailTitle>
                    <Style.InvoiceDetailValue>{CurrencyFormat(data.value_ipi)}</Style.InvoiceDetailValue>
                </Style.InvoiceDetailsColumn>
            </Style.InvoiceDetailSection>
            <hr/>
        </Style.InvoiceDetailContainer>

    );
};

export default InvoiceDetail;
