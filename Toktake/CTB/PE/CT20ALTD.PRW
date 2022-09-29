#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT20ALTD  ºAutor  ³Jackson E. de Deus  º Data ³  14/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³O ponto de entrada CT20ALTD é executado após a rotina de    º±±
±±º          ³alteração do Plano de Contas.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CT20ALTD()
                      
Local cDadosorig := 'CT1ALT_' +cusername +".dbf"
Local nI := 0
Local cValorAnt := ""
Local cValorNovo := ""

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O bloco abaixo foi criado para que a cada alteracao, seja gravado log dos campos alterados³
//³O arquivo temporario com os dados atuais é gerado pelo PE CT20ALTA						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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