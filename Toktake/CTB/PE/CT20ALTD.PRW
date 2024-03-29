#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CT20ALTD  �Autor  �Jackson E. de Deus  � Data �  14/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �O ponto de entrada CT20ALTD � executado ap�s a rotina de    ���
���          �altera��o do Plano de Contas.                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CT20ALTD()
                      
Local cDadosorig := 'CT1ALT_' +cusername +".dbf"
Local nI := 0
Local cValorAnt := ""
Local cValorNovo := ""

/*
//������������������������������������������������������������������������������������������Ŀ
//�O bloco abaixo foi criado para que a cada alteracao, seja gravado log dos campos alterados�
//�O arquivo temporario com os dados atuais � gerado pelo PE CT20ALTA						 �
//��������������������������������������������������������������������������������������������
*/
If MsFile(cDadosOrig,,"DBFCDXADS")
	dbUseArea( .T., "DBFCDXADS", cDadosorig, "TRBC", .F. ,.T. )
	dbSelectArea("TRBC")
	For nI := 1 To FCount()
		cValorAnt := TRBC->&( FieldName(nI) )
		cValorNovo := M->&(FieldName(nI))
		If cValorNovo <> cValorAnt
			If ValType( cValorNovo ) <> "C"
				If ValType( cValorNovo ) == "N"
					cValorAnt := CValToChar( cValorAnt )        
					cValorNovo := CValToChar( cValorNovo )
				ElseIf ValType( cValorNovo ) == "D"
					cValorAnt := DTOC( cValorAnt ) 
					cValorNovo := DTOC( cValorNovo )
				EndIf
			EndIf
			If cEmpAnt == "01" .or. cEmpAnt == "02"
				If FindFunction("U_TTGENC01")
					U_TTGENC01(xFilial("CT1"),"CT20ALTD","ALTERACAO DE CADASTR","",CT1->CT1_CONTA,"",cusername,dtos(date()),time(),,"CAMPO: "+FieldName(nI) +" - VALOR ANTERIOR: " +AllTrim(cValorAnt) + " - VALOR NOVO: "+AllTrim(cValorNovo),"","","CT1")	
				EndIf
			EndIf
		EndIf
	Next nI
	TRBC->( dbCloseArea() )
	FErase("\system\"+cDadosOrig)	// APAGA O DBF TEMPORARIO
EndIf	

Return