#include "protheus.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC33ºAutor  ³Jackson E. de Deus    º Data ³  27/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclusao/Alteracao/Exclusao de titulo a receber provisorio  º±±
±±º          ³Abastecimento												  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson	       ³27/04/15³01.00 |Criacao                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TTFINC33(nOpcAuto,cCodCli,cLoja,cCompet,nValor,dDtInicio,dDataVcto)

Local lRet			:= .F.
Local aFina040		:= {}
Local cPrefixo		:= "PRC"
Local cNumero		:= ""
Local cTipo			:= "PR"
Local cNatureza		:= "9999999999"	// parametro getmv..
Local cQuery		:= ""
Private lMsErroAuto	:= .F.         
Default nOpcAuto	:= 0
Default cCodCli		:= ""
Default cLoja		:= ""
Default dDtInicio	:= stod("")
Default dDataVcto	:= stod("")
Default nValor		:= 0
Default cCompet		:= ""

If Empty(nOpcAuto) .Or. Empty(cCodCli) .Or. Empty(cLoja)
	Conout("#TTFINC33 -> PARAMETROS INVALIDOS")
	Return lRet
EndIf

If nOpcAuto == 3
	If Empty(dDtInicio) .Or. Empty(dDataVcto) .Or. Empty(nValor)
		Conout("#TTFINC33 -> PARAMETROS INVALIDOS")
		Return lRet	
	EndIf
EndIf

If nOpcAuto == 4
	If Empty(nValor)
		Conout("#TTFINC33 -> PARAMETROS INVALIDOS")
		Return lRet	
	EndIf
EndIf

// inclusao - adiciona valor
If nOpcAuto == 3
		nRecnoE1 := Pesq(cCodCli,cLoja,cCompet)
		If nRecnoE1 > 0
			dbSelectArea("SE1")
			dbGoTo(nRecnoE1)
			cNumero := SE1->E1_NUM
		Else
			cNumero := ProxNum()
		EndIf
		
		aFina040  := {	{"E1_PREFIXO"	,cPrefixo	,Nil},;
						{"E1_NUM"		,cNumero	,Nil},;
						{"E1_TIPO"		,cTipo		,Nil},;
						{"E1_NATUREZ"	,cNatureza	,Nil},;
			          	{"E1_CLIENTE"	,cCodCli	,Nil},;
		             	{"E1_LOJA"		,cLoja		,Nil},;
			          	{"E1_EMISSAO"	,dDtInicio	,Nil},;
				       	{"E1_VENCTO" 	,dDataVcto	,Nil},;
				       	{"E1_VENCREA"	,DataValida(dDataVcto)	,Nil},;
				       	{"E1_VENCORI"	,dDataVcto	,Nil},;
						{"E1_XUSERPR"	,cUserName	,Nil},;
						{"E1_XUSERDT"	,Date()		,Nil},;						       	 		       	
						{"E1_XUSERHR"	,Time()		,Nil},;						       	 		       	
		  				{"E1_VALOR"		,nValor		,Nil},;
				       	{"E1_VALLIQ"	,nValor		,Nil},;
				       	{"E1_SALDO"		,nValor		,Nil }}
		       		       	
		MSExecAuto({|x,y| Fina040(x,y)},aFina040,nOpcAuto)

// alteracao - altera valor do titulo para valor informado no parametro
ElseIf nOpcAuto == 4       
	nRecnoE1 := Pesq(cCodCli,cLoja,cCompet)
	If nRecnoE1 > 0
		aFina040  := {	{"E1_PREFIXO"	,cPrefixo	,Nil},;
						{"E1_NUM"		,cNumero	,Nil},;
						{"E1_TIPO"		,cTipo		,Nil},;
						{"E1_NATUREZ"	,cNatureza	,Nil},;
			          	{"E1_CLIENTE"	,cCodCli	,Nil},;
		             	{"E1_LOJA"		,cLoja		,Nil},;
			          	{"E1_EMISSAO"	,dDtInicio	,Nil},;
				       	{"E1_VENCTO" 	,dDataVcto	,Nil},;
				       	{"E1_VENCREA"	,DataValida(dDataVcto)	,Nil},;
				       	{"E1_VENCORI"	,dDataVcto	,Nil},;
						{"E1_XUSERPR"	,cUserName	,Nil},;
						{"E1_XUSERDT"	,Date()		,Nil},;						       	 		       	
						{"E1_XUSERHR"	,Time()		,Nil},;						       	 		       	
		  				{"E1_VALOR"		,nValor		,Nil},;
				       	{"E1_VALLIQ"	,nValor		,Nil},;
				       	{"E1_SALDO"		,nValor		,Nil }}
				       	
		MSExecAuto({|x,y| Fina040(x,y)},aFina040,nOpcAuto)
	EndIf
		
// exclusao - diminui valor ou exclui titulo
ElseIf nOpcAuto == 5
	// exclusao NOTA - exclui titulo
	If FwIsInCallStack("U_MS520DEL")
		nRecnoE1 := Pesq(cCodCli,cLoja,cCompet)
		If nRecnoE1 > 0
			aFina040  := {	{"E1_PREFIXO"	,cPrefixo	,Nil},;
							{"E1_NUM"		,cNumero	,Nil},;
							{"E1_TIPO"		,cTipo		,Nil},;
							{"E1_NATUREZ"	,cNatureza	,Nil},;
				          	{"E1_CLIENTE"	,cCodCli	,Nil},;
			             	{"E1_LOJA"		,cLoja		,Nil }}
	             	
			MSExecAuto({|x,y| Fina040(x,y)},aFina040,nOpcAuto)
		EndIf
	// exclusao de orcamento
	ElseIf FwIsInCallStack("U_MT415GRV")
		nOpcAuto := 4
		nRecnoE1 := Pesq(cCodCli,cLoja,cCompet)
		If nRecnoE1 > 0                        
			dbSelectArea("SE1")
			dbGoTo(nRecnoE1)
			nValor := SE1->E1_VALOR - nValor
			
			aFina040  := {	{"E1_PREFIXO"	,cPrefixo	,Nil},;
							{"E1_NUM"		,cNumero	,Nil},;
							{"E1_TIPO"		,cTipo		,Nil},;
							{"E1_NATUREZ"	,cNatureza	,Nil},;
				          	{"E1_CLIENTE"	,cCodCli	,Nil},;
			             	{"E1_LOJA"		,cLoja		,Nil},;
				          	{"E1_EMISSAO"	,dDtInicio	,Nil},;
					       	{"E1_VENCTO" 	,dDataVcto	,Nil},;
					       	{"E1_VENCREA"	,DataValida(dDataVcto)	,Nil},;
					       	{"E1_VENCORI"	,dDataVcto	,Nil},;
							{"E1_XUSERPR"	,cUserName	,Nil},;
							{"E1_XUSERDT"	,Date()		,Nil},;						       	 		       	
							{"E1_XUSERHR"	,Time()		,Nil},;						       	 		       	
			  				{"E1_VALOR"		,nValor		,Nil},;
					       	{"E1_VALLIQ"	,nValor		,Nil},;
					       	{"E1_SALDO"		,nValor		,Nil }}
					       	
			MSExecAuto({|x,y| Fina040(x,y)},aFina040,nOpcAuto)
		EndIf
	EndIf
EndIf
	

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC33  ºAutor  ³Microsiga           º Data ³  04/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Pesq(cCodCli,cLoja,cCompet)

Local cQuery := ""

cQuery := "SELECT R_E_C_N_O_ REC "
cQuery += "  FROM "+ RetSQLName("SE1") +" SE1 "
cQuery += " WHERE SE1.E1_FILIAL  = '"+xFilial("SE1")+"' "
cQuery += "   AND SE1.E1_PREFIXO = 'PRC' "
cQuery += "   AND SE1.E1_TIPO = 'PR' AND SE1.E1_CLIENTE = '"+cCodCli+"' AND SE1.E1_LOJA = '"+cLoja+"' "
cQuery += " AND SUBSTRING(SE1.E1_EMISSAO,1,6) = '"+cCompet+"'  "
cQuery += "   AND SE1.D_E_L_E_T_ = '' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SE1TMP",.F.,.T.)

nRecnoE1 := SE1TMP->REC	
SE1TMP->(dbCloseArea()) 
	

Return nRecnoE1


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC33  ºAutor  ³Microsiga           º Data ³  04/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProxNum()

Local cQuery := ""
Local cNumero := ""

cQuery := "SELECT MAX(SE1.E1_NUM) as E1_NUM "
cQuery += "  FROM "+ RetSQLName("SE1") +" SE1 "
cQuery += " WHERE SE1.E1_FILIAL  = '"+xFilial("SE1")+"' "
cQuery += "   AND SE1.E1_PREFIXO = 'PRC' "
cQuery += "   AND SE1.D_E_L_E_T_ = ' '"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SE1TMP",.F.,.T.)

cNumero := Soma1(SE1TMP->E1_NUM)
SE1TMP->(dbCloseArea())

Return cNumero