import React, { useContext, useState } from "react";

import SyncLoader from "react-spinners/SyncLoader";
import LottieAnimation from "./lottieAnimation";

import animationData from '../assets/emptylist.json'
import animationBell from '../assets/bell.json'

import * as Style from "./styles"

import { ThemeContext } from "../contexts/ThemeContext";
import { WindowDimensionsContext } from "../contexts/WindowDimensionsContext";

import { darkTheme, lightTheme } from "../themes";
import { useMediaQuery } from 'react-responsive';

import Badge from 'react-bootstrap/Badge';

import { SToD } from "../utils/dateFormat";

import ModalComponent from "./modal";
import WarrantyBodyModal from "./warrantyBodyModal";
import api from "../services/api";
import { AlertComponent } from "./alerts";
import WarrantyDetail from "./warrantyDetail";
import { fetchData } from "../services/apiWarrantyxInvoices";
import InvoiceDetail from "./invoiceDetail";
import { Button } from "react-bootstrap";


interface Props{
    warranty: any
    load: boolean;
    handleLoadItems: () => void;
}

const WarrantyComponent: React.FC <Props> = ({ warranty, load, handleLoadItems })  => {

    const [showModal, setShowModal] = useState<boolean>(false)
    const [showModalDetail, setShowModalDetail] = useState<boolean>(false)
    const [showModalMirror, setShowModalMirror] = useState<boolean>(false)
    const { theme } = useContext(ThemeContext);
    const { windowDimensions } = useContext(WindowDimensionsContext);
    const isMobile = useMediaQuery({ query: '(max-width: 700px)' });
    const [uploadedImages, setUploadedImages] = useState<{ file: File; base64: string }[]>([]);

    const [warrantyDetail, setWarrantyDetail] = useState<any>([])

    const [alertMessage, setAlertMessage] = useState<any>([])
    const [showAlert, setShowAlert] = useState(false)

    const themeAux = theme === 'dark' ? darkTheme : lightTheme;

    const [textArea, setTextArea] = useState('')

    const [fieldService, setFieldService] = useState <any>([]);
    
    const badgeStatus = (status: string) => {

        let badge = {color: '', label: ''}

        if (status === '1'){
            badge = {color:'warning', label: 'Em Aberto'}

        } else if (status === '2'){
            badge = {color:'primary', label: 'Atendido'}
        
        }else if (status === '3'){
            badge = {color:'danger', label: 'Negado'}
        
        }else if (status === '4'){
            badge = {color:'success', label: 'Finalizado'}
        
        }else if (status === '5'){
            badge = {color:'secondary', label: 'Envio pendente de documentos'}
        
        }else if (status === '6'){
            badge = {color:'dark', label: 'Cancelado pelo atendente'}
        }

        return badge
    }

    const sendWarranty = async(warrantyJson: any) => {
                
        try{
            const response = await api.post("/WSAPP10", warrantyJson);
            const receive = response.data;
            
            const statusCode = receive.status.code
            
            if(statusCode === '#200') {
                setShowModal(false)

                setTimeout(() => {
                    handleLoadItems()
                }, 2000);
            }
            
            if(statusCode === '#200') {
                if(uploadedImages.length > 0) {
        
                    const separado = receive.status.message.split(':');
                    const codigo = separado[1].trim();
            
                    uploadedImages.forEach(async (image: any, index: number) => {
                        const params = {
                          warranty: codigo,
                          image: image.base64,
                          image_name: `${codigo}_image_${index.toString()}.${image.extension}`
                        };
                      
                        await sendImage(params);
                    });
                }
            }
            
            const alertAux = [
                statusCode === '#200' ? 'Sucesso' : 'Erro',
                receive.status.message,
                statusCode === '#200' ? 'success' : 'danger'
            ]
            
            setAlertMessage(alertAux)
            setShowAlert(true)

        } catch(error){
            console.log(error)
            setAlertMessage(['Erro', 'Erro ao criar chamado', 'danger'])
            setShowAlert(true)
        }
        
    }


    const sendImage = async(params: any) => {
        try{
            const response = await api.post("/WSAPP15", params);
            const receive = response.data;
            
            const statusCode = receive.status.code
            
            if(statusCode === '#200') {
                console.log(`${receive.status.message} ${params.image_name}`)
            }
        } catch(error){
            console.log(error)
        }
    }

    const BodyModal = (
        <WarrantyBodyModal
            handleSendWarranty={(warranty)=> sendWarranty(warranty)}
            uploadedImages={uploadedImages}
            setUploadedImages={(image) => setUploadedImages(image)}
        />
    )

    const handleCloseDetail = () => {
        setShowModalDetail(false)
        setShowModalMirror(false)
        setTextArea('')
        setWarrantyDetail([])
    }

    const handleInterageDetail = async(warranty: any) => {
        await sendWarranty(warranty)
        handleCloseDetail()
    }
    
    const BodyModalDetail = (
        <WarrantyDetail
            data={warrantyDetail}
            textArea={textArea}
            changeTextArea={(change) => setTextArea(change)}
            handleCloseDetail={handleCloseDetail}
            handleInterageDetail={(warranty)=> handleInterageDetail(warranty)}
            uploadedImages={uploadedImages}
            setUploadedImages={(image) => setUploadedImages(image)}

        />
    )

    const BodyModalMirror = (
        <>
            <InvoiceDetail data={fieldService} />

            <Style.WarrantyButtonTool>
                <Button variant="outline-primary" onClick={() => setShowModalMirror(false)}>Fechar</Button>
            </Style.WarrantyButtonTool>
        </>
    )

    const handleWarrantyDetail = (item: any) => {
        setWarrantyDetail(item)
        setShowModalDetail(true)
    }

    const apiWarrantyInvoice = async(item: any) => {
        const userData = localStorage.getItem('userdata');
        const user = userData ? JSON.parse(userData) : null;

        const returnResult: any = await fetchData(item.product, user.token, item.invoice)

        if(returnResult.length > 0){
          setFieldService(returnResult[0])
          setShowModalMirror(true)
        }
    }

    return(
        <>
            <Style.CustomersComponent
                id='table'
                windowDimensions={windowDimensions}
                modal={false}
                isMobile={isMobile}
            >
                <Style.WarrantyHoriz>
                    <Style.TextH3 style={{color:themeAux.primary}}>{'Garantia'}</Style.TextH3>
                    <Style.WarrantyButTop onClick={() => setShowModal(true)}>Novo Chamado</Style.WarrantyButTop>
                </Style.WarrantyHoriz>
                
                <SyncLoader
                    color={themeAux.primary}
                    loading={load}
                    size={12}
                    style={{display:'flex', justifyContent:'center', marginTop:30}}
                />

                { warranty.map((item: any, index: number) =>
                    <Style.WarrantyTable key={index} backGround={index % 2 == 0}>
                        
                        <Style.WarrantyItens>
                            <Style.WarrantyColumn>
                                <Style.WarrantyLabel align={'left'} color="#000" bold size={16}>Chamado</Style.WarrantyLabel>
                                <Style.WarrantyLabel align={'center'} color="#000" bold={false} size={16}>{item.warranty}</Style.WarrantyLabel>
                            </Style.WarrantyColumn>

                            <Style.WarrantyColumn>
                                <Style.WarrantyLabel align={'left'} color="#000" bold size={16}>Nota</Style.WarrantyLabel>
                                <Style.WarrantyLabel align={'center'} color="#000" bold={false} size={16}>{item.invoice}</Style.WarrantyLabel>
                            </Style.WarrantyColumn>

                            <Style.WarrantyColumn>
                                <Style.WarrantyLabel align={'left'} color="#000" bold size={16}>Item</Style.WarrantyLabel>
                                <Style.WarrantyLabel align={'center'} color="#000" bold={false} size={16}>{item.item}</Style.WarrantyLabel>
                            </Style.WarrantyColumn>

                            <Style.WarrantyColumn>
                                <Style.WarrantyLabel align={'left'} color="#000" bold size={16}>Emissão</Style.WarrantyLabel>
                                <Style.WarrantyLabel align={'center'} color="#000" bold={false} size={16}>{SToD(item.emission)}</Style.WarrantyLabel>
                            </Style.WarrantyColumn>

                            <Style.WarrantyColumn>
                                <Style.WarrantyLabel align={'left'} color="#000" bold size={16}>Produto</Style.WarrantyLabel>
                                <Style.WarrantyLabel align={'center'} color="#000" bold={false} size={16}>{item.product}</Style.WarrantyLabel>
                            </Style.WarrantyColumn>

                            <Style.WarrantyColumn>
                                <Style.WarrantyLabel align={'left'} color="#000" bold size={16}>Descrição</Style.WarrantyLabel>
                                <Style.WarrantyLabel align={'left'} color="#000" bold={false} size={16}>{item.description}</Style.WarrantyLabel>
                            </Style.WarrantyColumn>

                            <Style.WarrantyColumn>
                                <Style.WarrantyLabel align={'left'} color="#000" bold size={16}>Quantidade</Style.WarrantyLabel>
                                <Style.WarrantyLabel align={'center'} color="#000" bold={false} size={16}>{item.quantity}</Style.WarrantyLabel>
                            </Style.WarrantyColumn>

                            <Style.WarrantyColumn>
                                <Style.WarrantyLabel align={'left'} color="#000" bold size={16}>Defeito</Style.WarrantyLabel>
                                <Style.WarrantyLabel align={'center'} color="#000" bold={false} size={16}>{item.defect}</Style.WarrantyLabel>
                            </Style.WarrantyColumn>

                            <Style.WarrantyColumn>
                                <Style.WarrantyLabel align={'left'} color="#000" bold size={16}>Tipo Defeito</Style.WarrantyLabel>
                                <Style.WarrantyLabel align={'center'} color="#000" bold={false} size={16}>{item.defect_type}</Style.WarrantyLabel>
                            </Style.WarrantyColumn>

                            <Style.WarrantyColumn>
                                <Style.WarrantyLabel align={'left'} color="#000" bold size={16}>Status</Style.WarrantyLabel>
                                <Badge bg={badgeStatus(item.status).color}>{badgeStatus(item.status).label}</Badge>
                            </Style.WarrantyColumn>

                            <Style.WarrantyColumnBell>
                                { item.notification === 'atualizou' &&
                                    <Style.HeaderButtonNoti onClick={()=>{}}>
                                        <LottieAnimation
                                            animationData={animationBell}
                                            data={warranty}
                                            loop={true}
                                            autoplay={true}
                                            width={80}
                                            height={80}
                                        />
                                    </Style.HeaderButtonNoti>
                                }
                            </Style.WarrantyColumnBell>

                        </Style.WarrantyItens>

                        <Style.WarrantyTools>
                            <Style.WarrantyButTool onClick={() => handleWarrantyDetail(item)}>Detalhes do Chamado</Style.WarrantyButTool>
                            <Style.WarrantyButTool onClick={() => apiWarrantyInvoice(item)}>Espelho da Nota</Style.WarrantyButTool>
                        </Style.WarrantyTools>

                        
                    </Style.WarrantyTable>
                )}

                { warranty.length <= 0 && !load &&
                    <Style.WarrantyEmptyList>
                        <LottieAnimation
                            animationData={animationData}
                            data={warranty}
                            loop={true}
                            autoplay={true}
                            width={300}
                            height={300}
                        />
                        <Style.InvCustLabel color="#000" bold size={26}>Nenhum chamado aberto</Style.InvCustLabel>

                    </Style.WarrantyEmptyList>
                }
            </Style.CustomersComponent>

            <ModalComponent
                show={showModal}
                onHide={() => setShowModal(false)}
                title='Novo Chamado'
                Body={BodyModal}
                Tools={<></>}
            />

            <ModalComponent
                show={showModalDetail}
                onHide={handleCloseDetail}
                title='Detalhes do Chamado'
                Body={BodyModalDetail}
                Tools={<></>}
            />

            <ModalComponent
                show={showModalMirror}
                onHide={handleCloseDetail}
                title=''
                Body={BodyModalMirror}
                Tools={<></>}
            />

            <AlertComponent
              header={alertMessage[0]}
              body={alertMessage[1]}
              textButton='Fechar'
              type={alertMessage[2]}
              showAlert={showAlert}
              handleShowAlert={() => setShowAlert(false)}
            />
        </>
    )
}

export default WarrantyComponent;