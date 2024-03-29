#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTCOMC10   �Autor  �Jackson E. de Deus � Data �  04/26/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida edi��o do campo D1_XCLASPN (Qtd Fisica).            ���
���	     	 � Quando for classificacao ou alteracao,nao deixar digitar.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Classificacao do Documento de Entrada                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTCOMC10()

Local lRet		:= .T.
Local cEmpRegra := ""                              
Local lAtivaOS	:= If(cEmpAnt == "01",SuperGetMV("MV_XWSK018",.T.,.F.),"")
Local lAtivaBlq := If(cEmpAnt == "01",SuperGetMV("MV_XWSK012",.T.,.F.),"")

 
If cEmpAnt == "01"
           
	// Se for classificacao ou alteracao do documento de entrada
	If !INCLUI
	
		If lAtivaOS .And. lAtivaBlq
		
			// Empresas que utilizam o recurso
			cEmpRegra	:= SuperGetMV("MV_XWSK011",.T.,"")
				
			// Se a empresa esta parametrizada para utilizar esse recurso
			If SM0->M0_CODIGO $ cEmpRegra
		   	
			   	dbSelectArea("SF1")
				// Verifica os campos
				If FieldPos("F1_XWSOSF") == 0
					Aviso("TTCOMC10","Campo: F1_XWSOSF" +CRLF +"N�o encontrado no dicion�rio de dados." +CRLF +"O campo Qtd Fisica n�o ser� bloqueado.", {"Ok"})
					Return lRet
				EndIf
				
				If FieldPos("F1_XWSOSR") == 0
					Aviso("TTCOMC10","Campo: F1_XWSOSR" +CRLF +"N�o encontrado no dicion�rio de dados." +CRLF +"O campo Qtd Fisica n�o ser� bloqueado.", {"Ok"})
					Return lRet
				EndIf
			
			    // Verifica os valores dos campos para saber se � NF com integracao
				If SF1->F1_XWSOSF == "S" .And. AllTrim(SF1->F1_XWSOSR) <> ""
				
					// Se bloqueio deve acontecer - como parametrizado
					lRet := .F.
					                  
				EndIf
				
			EndIf		
			
		EndIf
	
	EndIf
EndIF

Return lRet