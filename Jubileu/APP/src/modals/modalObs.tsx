import React from 'react';
import * as Style from './styles';
import { ActivityIndicator, Keyboard, Modal, Platform, TouchableWithoutFeedback } from 'react-native';

import { FontAwesome } from '@expo/vector-icons';
import { PropsModalObs } from '../interfaces';

export default function modalObs({getVisible, handleModalObs, changeTextObs, textObs, handleGeraPedido, handleGeraOrcamento, load} : PropsModalObs){

    return(
        <Modal 
            transparent
            visible={getVisible}
            animationType='slide'
        >
            <Style.SafeAreaModals>
                <TouchableWithoutFeedback onPress={Keyboard.dismiss}>
                    <Style.KeyBoardFormCustomer
                        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
                        style={Style.styleSheet.shadow}
                        enabled
                    >
                        <Style.ModalOrderContainer>
                            <Style.containerFormModal animation="fadeInUp">
                                <Style.ModalHeader>
                                    <Style.TextModalHeader>
                                    Finalizar Pedido
                                    </Style.TextModalHeader>

                                    <Style.CloseModal
                                    onPress={() => handleModalObs()}
                                    activeOpacity={0.4}
                                    >
                                    <FontAwesome
                                        name="close"
                                        size={24}
                                        color="#FF9F47"
                                    />
                                    </Style.CloseModal>
                                </Style.ModalHeader>

                                <Style.ObservationsInput
                                    multiline
                                    numberOfLines={10} // Número máximo de linhas visíveis no TextInput
                                    value={textObs}
                                    onChangeText={changeTextObs}
                                    placeholder="Digite suas observações..."
                                />

                                <Style.ContainerButtonSubmit>
                                    <Style.ButtomSubmitLeft2
                                        onPress={() => !load && handleGeraOrcamento()}
                                    >
                                        <Style.ButtomSubmitTitle color='white'> Gerar Orçamento </Style.ButtomSubmitTitle>
                                    </Style.ButtomSubmitLeft2>
                                                                            
                                    <Style.ButtomSubmitRight
                                        onPress={() => !load && handleGeraPedido()}
                                    >
                                        <Style.ButtomSubmitTitle color='white'> Gerar Pedido </Style.ButtomSubmitTitle>
                                    </Style.ButtomSubmitRight>
                                </Style.ContainerButtonSubmit>

                                { load && <ActivityIndicator style={{marginTop:20}} animating size="large" color={'#000'} /> }
                            
                            </Style.containerFormModal>
                        </Style.ModalOrderContainer>
                    </Style.KeyBoardFormCustomer>
                </TouchableWithoutFeedback>
            </Style.SafeAreaModals>
        </Modal>
    )
}