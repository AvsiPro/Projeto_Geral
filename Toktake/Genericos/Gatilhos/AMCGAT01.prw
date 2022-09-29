#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AMCGAT01  �Autor  �Microsiga           � Data �  01/06/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Gatilho para buscar codigo de cliente e loja na inclusao ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AMCGAT01

Local aArea	:=	GetArea()
Local cQuery
Local cLoj	:=	''
                                               
If !Empty(M->A1_CGC) .AND. INCLUI
	cQuery := "SELECT A1_COD,A1_LOJA,A1_CGC FROM "+RetSQLName("SA1")
	cQuery += " WHERE D_E_L_E_T_='' AND SUBSTRING(A1_CGC,1,8)='"+substr(M->A1_CGC,1,8)+"'"

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	  
	MemoWrite("AMCGAT01.SQL",cQuery)
	
	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)
	
	If !Empty(TRB->A1_COD)
		M->A1_COD := TRB->A1_COD
	EndIf
	
	If LEN(Alltrim(M->A1_CGC)) < 14
		cLoj := '0001'
	Else
		cLoj := substr(M->A1_CGC,9,4)
	EndIF
		
EndIF

RestArea(aArea)

Return(cLoj)