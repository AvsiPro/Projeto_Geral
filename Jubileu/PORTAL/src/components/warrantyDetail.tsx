import React, { useContext, useState } from "react";

import * as Style from './styles'
import { CurrencyFormat } from "../utils/currencyFormat";
import { SToD } from "../utils/dateFormat";
import InputText from "./inputComponent";
import ImageUploader from "./ImageUploader";
import { Button } from "react-bootstrap";
import { ClipLoader } from "react-spinners";
import { UserContext } from "../contexts/userContext";
import { capitalize } from "../utils/nameFormat";
import { CgcFormat } from "../utils/cgcFormat";

interface Props {
    data: any;
    textArea: string;
    changeTextArea: (change: any) => void;
    handleCloseDetail: () => void;
    handleInterageDetail: (warranty: any) => void;
    uploadedImages: any;
    setUploadedImages: (image: any) => void;
}

const WarrantyDetail: React.FC <Props> = ({ data, textArea, changeTextArea, handleCloseDetail, handleInterageDetail, uploadedImages, setUploadedImages})  => {
    
    const [load, setLoad] = useState(false)
    
    const { userContext } = useContext(UserContext)


    const sendUpdateWarranty = async() => {
        setLoad(true)

        const user = `${capitalize(userContext.name)} (${CgcFormat(userContext.user)})`
        
        const warrantyJson = {
            invoice: data.invoice,
            item: data.item,
            product: data.product,
            customer:data.customer,
            customer_branch: data.customer_branch,
            emission: data.emission,
            price: data.price,
            quantity: data.quantity,
            customer_response: textArea,
            customer_user: user
        }

        handleInterageDetail(warrantyJson)
        setLoad(false)
    }

    return (
        <Style.InvoiceDetailContainer style={{paddingLeft:10, paddingRight:10}}>
            <Style.WDHoriz>
                <Style.WDColumn>
                    <Style.WDDetailsColumn>
                        <Style.InvoiceDetailTitle>Chamado</Style.InvoiceDetailTitle>
                        <Style.InvoiceDetailValue>{data.warranty}</Style.InvoiceDetailValue>
                    </Style.WDDetailsColumn>
                </Style.WDColumn>

                <Style.WDColumn>
                    <Style.WDDetailsColumn>
                        <Style.InvoiceDetailTitle>Nota</Style.InvoiceDetailTitle>
                        <Style.InvoiceDetailValue>{data.invoice}</Style.InvoiceDetailValue>
                    </Style.WDDetailsColumn>
                </Style.WDColumn>

                <Style.WDColumn>
                    <Style.WDDetailsColumn>
                        <Style.InvoiceDetailTitle>Emissão</Style.InvoiceDetailTitle>
                        <Style.InvoiceDetailValue>{SToD(data.emission)}</Style.InvoiceDetailValue>
                    </Style.WDDetailsColumn>
                </Style.WDColumn>

                <Style.WDColumn>
                    <Style.WDDetailsColumn>
                        <Style.InvoiceDetailTitle>Item</Style.InvoiceDetailTitle>
                        <Style.InvoiceDetailValue>{data.item}</Style.InvoiceDetailValue>
                    </Style.WDDetailsColumn>
                </Style.WDColumn>
            </Style.WDHoriz>

            <Style.WDHoriz>

                <Style.WDColumn>
                    <Style.InvoiceDetailsColumn>
                        <Style.InvoiceDetailTitle>Produto</Style.InvoiceDetailTitle>
                        <Style.InvoiceDetailValue>{data.product}</Style.InvoiceDetailValue>
                    </Style.InvoiceDetailsColumn>
                </Style.WDColumn>

                <Style.WDColumn>
                    <Style.WDDetailsColumn>
                        <Style.InvoiceDetailTitle>Descrição</Style.InvoiceDetailTitle>
                        <Style.InvoiceDetailValue>{data.description}</Style.InvoiceDetailValue>
                    </Style.WDDetailsColumn>
                </Style.WDColumn>

                <Style.WDColumn>
                    <Style.WDDetailsColumn>
                        <Style.InvoiceDetailTitle>Quantidade</Style.InvoiceDetailTitle>
                        <Style.InvoiceDetailValue>{data.quantity}</Style.InvoiceDetailValue>
                    </Style.WDDetailsColumn>
                </Style.WDColumn>

                <Style.WDColumn>
                    <Style.WDDetailsColumn>
                        <Style.InvoiceDetailTitle>Valor</Style.InvoiceDetailTitle>
                        <Style.InvoiceDetailValue>{CurrencyFormat(data.price)}</Style.InvoiceDetailValue>
                    </Style.WDDetailsColumn>
                </Style.WDColumn>
            </Style.WDHoriz>

            <Style.WDHoriz>
                <Style.WDColumn>
                    <Style.WDDetailsColumn>
                        <Style.InvoiceDetailTitle>Defeito</Style.InvoiceDetailTitle>
                        <Style.InvoiceDetailValue>{data.defect}</Style.InvoiceDetailValue>
                    </Style.WDDetailsColumn>
                </Style.WDColumn>

                <Style.WDColumn>
                    <Style.WDDetailsColumn>
                        <Style.InvoiceDetailTitle>Tipo Defeito</Style.InvoiceDetailTitle>
                        <Style.InvoiceDetailValue>{data.defect_type}</Style.InvoiceDetailValue>
                    </Style.WDDetailsColumn>
                </Style.WDColumn>

                <Style.WDColumn>
                    <Style.WDDetailsColumn>
                        <Style.InvoiceDetailTitle>Número Rastreamento</Style.InvoiceDetailTitle>
                        <Style.InvoiceDetailValue></Style.InvoiceDetailValue>
                    </Style.WDDetailsColumn>
                </Style.WDColumn>

                <Style.WDColumn>
                    <Style.WDDetailsColumn>
                        <Style.InvoiceDetailTitle>Número do Pedido</Style.InvoiceDetailTitle>
                        <Style.InvoiceDetailValue>{data.order}</Style.InvoiceDetailValue>
                    </Style.WDDetailsColumn>
                </Style.WDColumn>
            </Style.WDHoriz>

            <InputText
                placeholder=""
                label="Histórico de atendimento"
                value={data.obs_atend}
                onChange={() => {}}
                disabled={true}
                mb={0}
            />

            <InputText
                placeholder=""
                label="Interagir com atendente"
                value={textArea}
                onChange={(change) => changeTextArea(change)}
                mt={5}
                mb={0}
            />


            <ImageUploader
                upload={(image: any) => setUploadedImages(image)}
                uploadedImages={uploadedImages}
                label='Enviar outras imagens'
            />

            <Style.WarrantyButtonTool>
                <Button
                    style={{marginRight: 10}}
                    variant="outline-primary"
                    onClick={() => handleCloseDetail()}>Fechar
                </Button>

                <Button
                    disabled={!textArea}
                    variant="outline-primary"
                    onClick={sendUpdateWarranty}>
                        { load ?
                            <ClipLoader
                                color={'#0d6efd'}
                                loading={load}
                                size={22}
                            />
                        : 'Interagir'
                        }
                </Button>
            </Style.WarrantyButtonTool>
        </Style.InvoiceDetailContainer>
    )
}

export default WarrantyDetail;