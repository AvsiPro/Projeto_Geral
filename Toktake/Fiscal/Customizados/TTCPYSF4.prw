#INCLUDE "PROTHEUS.CH" 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTCPYSF4  � Autor � Jackson E. de Deus  � Data � 20/02/13	  ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa utilizado para duplicar cadastro de TES           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TTCPYSF4()

Private aRotina		:= {}
Private cCadastro	:= "Cadastro de TES"
Private cAlias		:= "SF4"

AAdd(aRotina, {"Pesquisar"	, "AxPesqui"	, 0, 1})
AAdd(aRotina, {"Visualizar"	, "AxVisual"	, 0, 2})
AAdd(aRotina, {"Copiar"		, "U_CPSF4"		, 0, 3})


dbSelectArea(cAlias)
dbSetOrder(1)
dbGoTop()

mBrowse(6,1,22,75,cAlias)                 


Return 


/*
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    � CPSF4  � Autor � Jackson E. de Deus     � Data � 20/02/13 �   ��
���������������������������������������������������������������������������Ĵ��
���Desc.	 �  Verifica se existe cadastro de TES na tabela SF4  		    ���
���          �  e executa a fun��o da duplica��o - SF4Copia()			    ���
���������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum               	                                    ���
���������������������������������������������������������������������������Ĵ��
���Retorno   � .T.     	                                                    ���
���������������������������������������������������������������������������Ĵ��
���Uso       � U_TTCPYSF4()                                                 ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
*/
User Function CPSF4() 
Local aArea   	:= { Alias(), IndexOrd(), Recno() }
Local nPosSF4 	:= aArea[3]
Local lContinua	:= .T.

If /*xFilial("SF4") # SF4->F4_FILIAL .Or. */(SF4->(EOF()) .and. SF4->(BOF()))
	HELP(" ",1,"ARQVAZIO")
	lContinua := .F.
Endif


If lContinua
	SF4Copia("SF4",nPosSF4,3)
EndIf


Return(.T.)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF4Copia  �Autor  �Jackson E. de Deus  � Data �  20/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa de C�pia de TES                                   ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada 	  					  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � U_CPSF4()                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SF4Copia(cAlias,nReg,nOpc)

Local aCampos  := {}
Local lCopia := .T.
Private aTELA[0][0],aGETS[0]

/*----------------------------------------------------------------+
|	Envia para processamento dos Gets.							  |
+----------------------------------------------------------------*/
nOpcA := 0

If lCopia
	Begin Transaction
		
		nOpcA := AxInclui( cAlias, nReg, nOpc,,"U_SF4LeReg()",,,,,,,,.T.)
		
		If nOpcA == 1
			MsgInfo("C�pia conclu�da com sucesso!")
		EndIf
			
	End Transaction
EndIf		
			
				
dbSelectArea(cAlias)
	

Return
            


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF4LeReg  �Autor  �Jackson E. de Deus  � Data �  20/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Copia os campos da TES original para a mem�ria.            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � U_SF4Copia()                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SF4LeReg()

Local aCpoNot	:= {}
Local bCampo	:= { |nCPO| Field(nCPO) }
Local nI		:= 0
Local cCodAtu	:= ""
Local cCodNovo	:= ""
Local lVld		:= .F.


/*---------------------------------------------------------------+
|	Copia os campos da TES de referencia para a memoria.	 |
+----------------------------------------------------------------*/
dbSelectArea("SF4")
For nI := 1 To FCount()
	If /*!(FieldName( nI ) == "F4_CODIGO") .And.*/ Empty( AScan( aCpoNot,{|x| x == Upper(allTrim(FieldName( nI )))} ) )
		If FieldName (nI ) == "F4_CODIGO" 
		
			cCodAtu := FieldGet(nI)
			
			cCodNovo := NextNum(cCodAtu)	// Busca o prox. registro dispon�vel para a filial de destino
			
			M->F4_CODIGO := cCodNovo
		
		Else
		
			M->&(EVAL(bCampo,nI)) := FieldGet(nI)
			
		EndIf		
	EndIf
Next nI


Return Nil

 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NextNum  �Autor  �Jackson E. de Deus  � Data �  20/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca pr�ximo registro dispon�vel para a filial de destino.���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function NextNum(cCodAtu)

Local lVld 		:= .F.
Local cAux		:= cCodAtu
Local _aArea	:= GetArea()

dbSelectArea("SF4")
dbSetOrder(1)
dbGoTop()

/*---------------------------------------------------------------+
|	Busca o pr�ximo registro dispon�vel na filial de destino.|
+----------------------------------------------------------------*/
While !lVld

	If dbSeek(xFilial("SF4") + AvKey(cAux,"F4_CODIGO"))
		cAux := SOMA1(cAux)
	Else
		lVld := .T.	
	EndIf
  
End


RestArea(_aArea)

Return (cAux)