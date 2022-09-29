#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTTPROC10 �Autor  �Microsiga           � Data �  06/20/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PEPROC10()

Local aParam		:= PARAMIXB
Local xRet			:= .T.
Local oObj			:= ""
Local cIDPonto		:= ""
Local cIdModel		:= ""
Local lIsGrid		:= .F.
Local nLinha		:= 0
Local nQtdLinhas	:= 0
Local cQuery

If cEmpAnt <> "01"
	return
EndIF

If aParam <> NIl

	oObj		:= aParam[1]
	cIdPonto	:= aParam[2]
	cIDModel	:= aParam[3]
	lIsGrid		:= ( Len(aParam)>3 )

	If lIsGrid
		//nQtdLinhas := oObj:GetQtdLine()
		//nLinha := oObj:nLine
	EndIf
	
	// Antes da alteracao de qualquer campo do modelo
	If cIdPonto == "MODELPRE"
	
	// Na validacao total do modelo	
	ElseIf cIdPonto == "MODELPOS"
	
	// Antes da alteracao de qualquer campo do formulario	                                                 
	ElseIf cIdPonto == "FORMPRE"

		// Na validacao total do formulario	
	ElseIf cIdPonto == "FORMPOS"
                 
    // Antes da alteracao da linha do formulario FWFORMGRID
	ElseIf cIdPonto == "FORMLINEPRE"
	                                                     
	// Na validacao total da linha do formulario FWFORMGRID
	ElseIf cIdPonto == "FORMLINEPOS"
	                                   
	// Apos a gravacao total do modelo e dentro da transacao
	ElseIf cIdPonto == "MODELCOMITTTS"
	                                                        
	// Apos a gravacao total do modelo e fora da transacao
	ElseIf cIdPonto == "MODELCOMMITNTTS"
	                                                      
	// Antes da gravacao da tabela do formulario
	ElseIf cIdPonto == "FORMCOMMITTTSPRE"
		                                        
	// Apos a gravacao da tabela do formulario
	ElseIf cIdPonto == "FORMCOMMITTTSPOS"
	                        
	// No cancelamento do botao
	ElseIf cIdPonto == "MODELCANCEL"
	
	// Na ativacao do modelo
	ElseIf cIdPonto == "MODELVLDACTIVE"
	                        
	// Para inclusao de botoes na ControlBar
	ElseIf cIdPonto == "BUTTONBAR"
		//xRet := { {'Carregar', 'Carregar', {||carregar()}, 'Carregar produtos desta PA'}}
	EndIf
	
EndIf

Return xRet