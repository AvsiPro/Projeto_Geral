import React, {useState} from 'react';
import * as Style from './styles';
import { Modal, FlatList } from 'react-native';

import { FontAwesome } from '@expo/vector-icons';

import { CurrencyFormat } from '../utils/currencyFormat';

interface Props{
    getVisible: boolean,
    handleModal: (item: any) => void,
    itemModal: any
}

export default function modalOrder({getVisible, handleModal, itemModal} : Props){

    const [dropIndex, setDropIndex] = useState(null)

    const handleDropDown = (index: any) => {
        if(index === dropIndex){
            setDropIndex(null)
        }else {
            setDropIndex(index)
        }
    }

    const somarValores = (objetos: any) => {
        let somaQuantidade = 0;
        let somaValorTotal = 0;
        
        if(!!objetos){
            objetos.map((objeto: any) => {
              somaQuantidade += objeto.sold_amount;
              somaValorTotal += objeto.value_sold;
            });
          
        }
        return {
          somaQuantidade,
          somaValorTotal
        };
    }      

    return(
        <Modal 
            transparent
            visible={getVisible}
            animationType='slide'
        >
            <Style.SafeAreaModals>
                <Style.ModalContainer style={Style.styleSheet.shadow}>
                    <Style.ModalHeader>
                        <Style.TextModalHeader>
                            {itemModal.document}
                        </Style.TextModalHeader>

                        <Style.CloseModal 
                            onPress={() => handleModal(null)}
                            activeOpacity={0.4}
                        >
                            <FontAwesome
                                name="close"
                                size={24}
                                color="#FF9F47"
                            />
                        </Style.CloseModal>
                    </Style.ModalHeader>

                    <Style.MiddleModalContainer>
                        <Style.MiddleModalText>
                            { itemModal.customer_name}
                        </Style.MiddleModalText>
                    </Style.MiddleModalContainer>

                    <Style.ContainerItemsOrder>
                        <FlatList
                            data={itemModal.items}
                            showsVerticalScrollIndicator={false}
                            renderItem={({item, index}) => (
                                <>
                                    <Style.ContainerLineItemsOrder 
                                        backGround={index % 2 == 0}
                                    >
                                        <Style.ItemCodigoOrder>
                                            {item.product}
                                        </Style.ItemCodigoOrder>

                                        <Style.ItemDescOrder>
                                            {item.description}
                                        </Style.ItemDescOrder>

                                        { index === dropIndex &&
                                            <Style.DropDownListContainer>
                                                <Style.DropDownSection>
                                                    <Style.DropDownHeaderSection>
                                                        Quant.
                                                    </Style.DropDownHeaderSection>
                                                    <Style.DropDownItemSection>
                                                        {item.sold_amount}
                                                    </Style.DropDownItemSection>
                                                </Style.DropDownSection>

                                                <Style.DropDownSection>
                                                    <Style.DropDownHeaderSection>
                                                        Valor Unitátio
                                                    </Style.DropDownHeaderSection>
                                                    <Style.DropDownItemSection>
                                                        {CurrencyFormat(item.value_sold)}
                                                    </Style.DropDownItemSection>
                                                </Style.DropDownSection>
                                                
                                                <Style.DropDownSection>
                                                    <Style.DropDownHeaderSection>
                                                        Valor Total
                                                    </Style.DropDownHeaderSection>
                                                    <Style.DropDownItemSection>
                                                        {CurrencyFormat(item.value_sold)}
                                                    </Style.DropDownItemSection>
                                                </Style.DropDownSection>
                                            </Style.DropDownListContainer>
                                        }


                                    </Style.ContainerLineItemsOrder>

                                    <Style.DropDownContainer
                                        onPress={() => handleDropDown(index)}
                                        backGround={index % 2 == 0}
                                        activeOpacity={0.4}
                                    >
                                        <FontAwesome
                                            name={index === dropIndex ? "angle-up" : "angle-down"}
                                            size={24}
                                            color="black"
                                        />
                        
                                    </Style.DropDownContainer>
                                </>
                            )}
                            keyExtractor={item => item.id}
                        />
                    </Style.ContainerItemsOrder>
                </Style.ModalContainer>

                <Style.ModalContentFooter>
                    <Style.FooterModalComponent>
                        <Style.TextModalFooter>
                           {'Quant.: ' + somarValores(itemModal.items).somaQuantidade.toString()}
                        </Style.TextModalFooter>
                        <Style.TextModalFooter>
                            {'Total: ' + CurrencyFormat(somarValores(itemModal.items).somaValorTotal)}
                        </Style.TextModalFooter>
                    </Style.FooterModalComponent>
                </Style.ModalContentFooter>
            </Style.SafeAreaModals>
        </Modal>
    )
}