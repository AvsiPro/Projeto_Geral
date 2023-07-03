import React, { useState } from "react";

import * as Style from './styles'
import { useMediaQuery } from "react-responsive";
import SearchPopover from "../popovers/searchPopover";
import Table from "./table";
import LottieAnimation from "./lottieAnimation";
import animationWarranty from '../assets/warranty.json'
import { Button, Form } from "react-bootstrap";

import WarrantyDropDown from "./warrantyDropDown";

import InputText from "./inputComponent";
import ImageUploader from "./ImageUploader";
import WarrantyTerms from "./warrantyTerms";
import InvoiceDetail from "./invoiceDetail";
import { ClipLoader } from "react-spinners";
import { fetchData } from "../services/apiWarrantyxInvoices";

interface Props {
  handleSendWarranty: (warranty: any) => void;
  uploadedImages: any;
  setUploadedImages: (image: any) => void;
}

const WarrantyBodyModal: React.FC <Props> = ({handleSendWarranty, uploadedImages, setUploadedImages})  => {

    const isMobile = useMediaQuery({ query: '(max-width: 767px)' });
    
    const [load, setLoad] = useState(false)
    const [step2, setStep2] = useState(false)
    const [step3, setStep3] = useState(false)
    const [step4, setStep4] = useState(false)

    const [selectedOption, setSelectedOption] = useState('')
    const [selectedOption1, setSelectedOption1] = useState('');
    const [selectedOption2, setSelectedOption2] = useState('');

    const [isChecked, setIsChecked] = useState(false);
    
    const [textArea, setTextArea] = useState('')
    const [textAreaAddress, setTextAreaAddress] = useState('')

    const [selected, setSelected] = useState(null)
    const [fieldService, setFieldService] = useState <any>([]);
    const [fields, setFields] = useState <any>([
        { 
          id: 'code',
          label: 'Produto',
          width: 150,
          search: true,
          enabled: true,
          type: 'product',
          value: ''
        },
        { 
          id: 'description',
          label: 'Descrição',
          width: 300,
          search: false,
          enabled: false,
          type: 'description',
          value: ''
        }
    ])

    const handleConfirmSelect = (selected: any) => {
        const auxField = [...fields]

        auxField.map((_, index) => {
          if(auxField[index].id === 'code'){
            auxField[index].value = selected.selected.code

            apiWarrantyInvoice(selected.selected.code)
            
          }else if(auxField[index].id === 'description'){
            auxField[index].value = selected.selected.description
          }
        });
  
        setFields(auxField)
    }

    const apiWarrantyInvoice = async(code: string) => {
        const userData = localStorage.getItem('userdata');
        const user = userData ? JSON.parse(userData) : null;

        const returnResult: any = await fetchData(code, user.token, '')

        if(returnResult.length > 0){
          setFieldService(returnResult)
        }
    }

    const Header = () => {
        return(
          <Style.WarrantyBodyContainer isMobile={isMobile}>
            {fields.map((field: any, index: number) => {
                return (

                  <Style.WarrantyBodyrInputItem key={index} width={field.width}>
                    <Style.TextLabel style={{ color: "#000" }}>
                      {field.label}
                    </Style.TextLabel>

                    <Style.WarrantyBodyInputWrapper>
                      <Style.WarrantyBodyInputField
                        id={field.id}
                        type="text"
                        disabled={!field.enabled}
                        value={field.value}
                      />
    
                      {field.search && (
                        <SearchPopover
                          title={field.label}
                          field={field}
                          handleConfirmSelect={handleConfirmSelect}
                        />
                      )}
                    </Style.WarrantyBodyInputWrapper>
                  </Style.WarrantyBodyrInputItem>
                );
            })}
          </Style.WarrantyBodyContainer>
        )
    }

    const fieldsTable = () =>{
      let auxFields = []

      auxFields.push(
          {field: 'mark', headerText: '', textAlign: 'Center'  },
          {field: 'branch_invoice', headerText: 'Filial', textAlign: 'Center' },
          {field: 'invoice', headerText: 'Nota', textAlign: 'Center' },
          {field: 'invoice_series', headerText: 'Série', textAlign: 'Center' },
          {field: 'quantity', headerText: 'Quantidade', textAlign: 'Center' },
          {field: 'price', headerText: 'Preço', textAlign: 'Left'},
          {field: 'emission', headerText: 'Emissão', textAlign: 'Left'},
      )
      
      return auxFields
    }

    const handleStep2 = () => {

      const auxField = [...fields]

      auxField.map((_, index) => {
        if(auxField[index].id === 'code'){
          auxField[index].enabled = false
          auxField[index].search = false
        }
      });

      setFields(auxField)
      setStep2(true)
    }

    const handleStep3 = () => {
      setStep2(false)
      setStep3(true)
    }

    const handleStep4 = () => {
      setStep3(false)
      setStep4(true)
    }

    const ToolsTable = () => {
      return(
        <Button
          disabled={!selected}
          variant="outline-primary"
          onClick={handleStep2}>Selecionar
        </Button>
      )
    }

    const handleMark = (row: any) => {
      const updatedItems = fieldService.map((item: any) => {
          if (item.id === row.id) {
            return { ...item, mark: true };
          }
          return { ...item, mark: false };
      });
      
      row.mark = true

      setSelected(row)
      setFieldService(updatedItems)
    }

    
    const buttonConfirmDisable = () => {
      if (
          !selectedOption  ||
          !selectedOption1 ||
          !selectedOption2 ||
          !selected || 
          uploadedImages.length === 0
      ) {
        return true;
      }
      return false;
    };

    const handleCheckboxChange = (e: any) => {
      setIsChecked(e.target.checked);
    };

    const sendWarranty = async() => {

      setLoad(true)

      const warrantyJson = {
        invoice: fieldService[0].invoice,
        item: fieldService[0].item,
        product: fieldService[0].product,
        customer:fieldService[0].customer,
        customer_branch: fieldService[0].customer_branch,
        emission: fieldService[0].emission,
        price: fieldService[0].price,
        quantity: fieldService[0].quantity,
        branch_invoice: fieldService[0].branch_invoice,
        option: selectedOption,
        defect: selectedOption1,
        defect_type: selectedOption2,
        obs: textArea,
        another_address: textAreaAddress
      }

      handleSendWarranty(warrantyJson)
      setLoad(false)
    }

    return(
        <>  
            {!step3 && !step4 &&
                <Header />
            }

            { !step2 && !step3 && !step4 ?
              <>
                { fieldService.length > 0 ?
                    <Table
                        data={fieldService}
                        fields={fieldsTable()}
                        title={''}
                        load={false}
                        handleSearch={() => {}}
                        handleMark={handleMark}
                        ToolsTable={ToolsTable}
                        modal={true}
                        search={false}
                    />
                
                :
                  <Style.InvCustEmptyList>
                    
                    <LottieAnimation
                      animationData={animationWarranty}
                      data={fieldService}
                      loop={true}
                      autoplay={true}
                      width={250}
                      height={250}
                    />
                  
                    <Style.InvCustLabel color="#000" bold size={26}>
                      { !fields[0].value
                          ? 'Selecione um produto'
                          : 'Nenhum faturamento correspondente ao produto'
                      }
                    </Style.InvCustLabel>
              
                  </Style.InvCustEmptyList>
                }
              </>

            : step2 ?
              <Style.WarrantyBodyStep2>
                <WarrantyDropDown
                  selectedOption={selectedOption}
                  selectedOption1={selectedOption1}
                  selectedOption2={selectedOption2}
                  setSelectedOption={(opt) => setSelectedOption(opt)}
                  setSelectedOption1={(opt) => setSelectedOption1(opt)}
                  setSelectedOption2={(opt) => setSelectedOption2(opt)}
                />

                <InputText
                  placeholder="Digite seu texto..."
                  label="Observação adicional"
                  value={textArea}
                  onChange={(change) => setTextArea(change)}
                />

                <ImageUploader
                  upload={(image: any) => setUploadedImages(image)}
                  uploadedImages={uploadedImages}
                  label="Envie até 5 imagens"
                />

                <Style.WarrantyButtonTool>
                  <Button
                    disabled={buttonConfirmDisable()}
                    variant="outline-primary"
                    onClick={handleStep3}>Continuar
                  </Button>
                </Style.WarrantyButtonTool>
              </Style.WarrantyBodyStep2>


            : step3 ?
              <Style.WarrantyBodyStep3>
                <Style.TextH4 style={{color:'#000', marginBottom:20}}>Políticas e procedimentos para trocas</Style.TextH4>
                <WarrantyTerms />
                
                <Form.Check
                  type="checkbox"
                  id="termsCheckbox"
                  label="Eu li e aceito os termos de Políticas e procedimentos para trocas"
                  checked={isChecked}
                  onChange={handleCheckboxChange}
                />

                <Style.WarrantyButtonTool>
                  <Button
                    variant="primary"
                    onClick={handleStep4}
                    disabled={!isChecked}
                  >
                    Prosseguir
                  </Button>
                </Style.WarrantyButtonTool>
              </Style.WarrantyBodyStep3>

            : step4 &&
                <>
                    <InvoiceDetail data={selected} />

                    <InputText
                      placeholder="Digite o endereço..."
                      label="Outro endereço de entrega (Opcional)"
                      value={textAreaAddress}
                      onChange={(change) => setTextAreaAddress(change)}
                      height={50}
                    />

                  <Style.WarrantyButtonTool>
                    <Button
                      variant="primary"
                      onClick={sendWarranty}
                    >
                      { load ?
                          <ClipLoader
                            color={'#fff'}
                            loading={load}
                            size={22}
                          />
                        : 'Confirmar'
                      }
                    </Button>
                  </Style.WarrantyButtonTool>
                </>
            }
        </>
    )
}

export default WarrantyBodyModal;