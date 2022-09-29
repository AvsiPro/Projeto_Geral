#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK271END  �Autor  �Jackson E. de Deus�   Data �  27/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada executado no final da gravacao,            ���
���          �ao dar o OK na tela de atendimento.                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TK271END()

Local aArea			:= GetArea()
Local aCabMail		:= {}
Local aItens		:= {}
Local cArqMail		:= ""
Local cRemete		:= ""
Local cSubject		:= ""
Local aAttach		:= {}

If cEmpAnt == "01"
	If Valtype(llOMM) == "U"
		llOMM := .F.
	EndIf
	
	If ValType(llExcluiu) == "U"
		llExcluiu := .F.
	EndIf                          
	
	/*
	If llOMM
		If ( llAlterou == .T. .And. Len(aAltProd) > 0 ) .Or. ( llExcluiu == .T. .And. Len(aExcProd) > 0 )
			// Prepara variaveis para montagem do corpo do email
			U_TTTMKA09(1,SUC->UC_FILIAL,SUC->UC_CODIGO,@aCabMail,@aItens)                
		 	If ValType(aCabMail) == "A" .And. Valtype(aItens) == "A"
		       	If Len(aCabMail) > 0 .And. Len(aItens) > 0 
		       		Aadd(aCabMail,aAltProd)                                  
					// Prepara o corpo do email
					U_TTTMKA07(1,aCabMail,@cArqMail,aItens)
					cRemete := SuperGetMV("MV_RELACNT",.T.,"microsiga",)
					cTgtMail += ";" +AllTrim(UsrRetMail(__cUserID)) 
					cSubject := "Ordem de Movimenta��o de Maquina - N� "+SUC->UC_CODIGO
				
					// Envia o email
					U_TTMailN(cRemete,cTgtMail,cSubject,cArqMail,aAttach,.F.)
				EndIf
			EndIf					
		EndIf	
	EndIf
	*/
EndIf
RestArea(aArea)

Return