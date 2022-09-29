#include "protheus.ch"
#include "topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTTMKA25  �Autor  �Jackson E. de Deus  � Data �  14/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava alteracoes no cadastro do patrimonio - Ativo Fixo	  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �10/10/14�01.00 |Criacao                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function TTTMKA25(cPatrimo,aDados)

Local nI  
Local lRet		:= .F.
Local lInco		:= .F.
Local lProblem	:= .F.
Local cTipo		:= ""
Local nTamanho	:= 0
Local aOk		:= {} 

Default cPatrimo	:= ""
Default aDados		:= {}

If cEmpAnt <> "01"
	Return(lRet)
EndIf

If Empty(cPatrimo) .Or. Empty(aDados)
	Return lRet
EndIf
                     
dbSelectArea("SN1")
dbSetOrder(2)
If dbSeek( xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA") )
	// consiste campos
	For nI := 1 To Len(aDados)
		cTipo := ""
		nTamanho := 0
		lInco := .F.
		
		If FieldPos( aDados[nI][1] ) > 0
			cTipo := GetSx3Cache( aDados[nI][1],"X3_TIPO")
			//nTamanho  := GetSx3Cache( aDados[nI][1],"X3_TAMANHO") 
			
			If ValType( aDados[nI][2] ) == cTipo
				AADD( aOk, aDados[nI][1] )          
			Else
				lInco := .T.
			EndIf
		EndIf           
		
		If lInco
			lProblem := .T.
			Conout("# "+Time()+" - U_TTTMKA25 | Campo inconsistente: "+aDados[nI][1] +" #")
		EndIf		
	Next nI
	
	// grava campos
	If !lProblem
		RecLock("SN1",.F.)                                        
		For nI := 1 To Len(aOk)
			For nJ := 1 To Len(aDados)
				If aDados[nJ][1] == aOk[nI]
					SN1->&( aDados[nJ][1] ) := aDados[nJ][2]
					Exit
				EndIf
			Next nJ	
		Next nI
		MsUnLock()
		lRet := .T.  
	EndIf
EndIf


Return lRet