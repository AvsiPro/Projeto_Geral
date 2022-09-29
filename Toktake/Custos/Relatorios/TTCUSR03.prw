#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MAPAO    ³ Autor ³ Ricardo Souza         ³ Data ³ 25/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio que mapeia todas as movimentacoes realizadas no  ³±±
±±³          ³estoque (SD1, SD2 e SD3)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MAPAOTT(cNome,lJob)

cString  := "SD1"
cTitulo  := "M A P A O "
cDesc1   := "Demonstra resumo da qtde e do custo  "
cDesc2   := "Movimentados no estoque."
cDesc3   := " "
tamanho  := "G"
aReturn  := { "Zebrado", 1,"Administracao", 1, 1, 1, "",1 }
nomeprog := If(cNome == NIL,"MAPAOTT",cNome)
cPerg    := "MAPAO2"
nLastKey := 0
cCabec1  := " "
cCabec2  := " "
cCancel  := "***** CANCELADO PELO OPERADOR *****"
_aStru1	 := {}
limite   := 220
lErro    := .f.
_cGrupCus:= GetMv("MV_GRCUST") // Grupo para ordenar demonstracao de Calculo
aOrd     := {}
lJob     := If(lJob == NIL, .F., lJob)

Private m_pag  := 1
Private li     := 61

If cEmpAnt <> "01"
	Return
EndIf

If lJob
      __aImpress[1] := 1
EndIf

ValPerg()
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := nomeprog

wnrel := SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.,,, lJob)

If nLastKey == 27
	Return
Endif

//SetDefault(aReturn,cString,.F.)
SetDefault( aReturn, cString,, lJob, Tamanho, IIf( Tamanho == "G", 2, 1 ) )

If nLastKey == 27
	Return
Endif
_cAlm1 := SubStr(mv_par17 ,1,2)
_cAlm2 := SubStr(mv_par17 ,3,2)
_cAlm3 := SubStr(mv_par17 ,5,2)
_cAlm4 := SubStr(mv_par17 ,7,2)
_cAlm5 := SubStr(mv_par17 ,9,2)
	
_cString:=	"'"+_cAlm1+"','"+_cAlm2+"','"+_cAlm3+"','"+_cAlm4+"','"+_cAlm5+"'"

If !lJob
	MsAguarde({|| fMontaTrb(lJob)},"Selecionando Registros")
	RptStatus({|| fImprime(lJob)})
Else
	fMontaTrb(lJob)
	fImprime(lJob)
EndIf

Return

//*********************************

Static Function FMontaTrb(lJob)

// Montagem Arquivo de Trabalho

_aStru	:= {}
AADD(_aStru,{"SECAO","C",03,0})
AADD(_aStru,{"CODIGO","C",10,0})
AADD(_aStru,{"TIPO","C",01,0})  // E= ENTRADA ; S=SAIDA
AADD(_aStru,{"TESTM","C",03,0})
AADD(_aStru,{"CF","C",03,0})
AADD(_aStru,{"NUMERO","C",03,0})
AADD(_aStru,{"QTDENT","N",14,2})
AADD(_aStru,{"CUSTOENT","N",16,4})
AADD(_aStru,{"QTDSAI","N",16,4})
AADD(_aStru,{"CUSTOSAI","N",14,2})
AADD(_aStru,{"DOC","C",25,0})
AADD(_aStru,{"ORDEM","C",01,0})
AADD(_aStru,{"DESCTES","C",01,0})
AADD(_aStru,{"MOVIMENTO","C",01,0})

_cArqTrab	:= Criatrab(_aStru,.T.)
_cArqInd	:= CriaTrab(,.F.)
If Select("TRB")	>	0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

Use &_cArqTrab Shared New Alias TRB

If !lJob
	IndRegua("TRB",_cArqInd,"SECAO+CODIGO+TIPO+ORDEM+TESTM+NUMERO+CF",,,"Selecionando Registros")
Else
	IndRegua("TRB",_cArqInd,"SECAO+CODIGO+TIPO+ORDEM+TESTM+NUMERO+CF",,,)
EndIf

_aStru1	:= {}
AADD(_aStru1,{"SECAO","C",03,0})
AADD(_aStru1,{"TIPO","C",01,0})  // E= ENTRADA ; S=SAIDA
AADD(_aStru1,{"TESTM","C",03,0})
AADD(_aStru1,{"CF","C",03,0})
AADD(_aStru1,{"NUMERO","C",03,0})
AADD(_aStru1,{"QTDENT","N",14,2})
AADD(_aStru1,{"CUSTOENT","N",16,4})
AADD(_aStru1,{"QTDSAI","N",16,4})
AADD(_aStru1,{"CUSTOSAI","N",14,2})
AADD(_aStru1,{"ORDEM","C",01,0})
AADD(_aStru1,{"DESCTES","C",01,0})

_cArqTrab	:= Criatrab(_aStru1,.T.)
_cArqInd	:= CriaTrab(,.F.)
If Select("TRB1")>0
	DbSelectArea("TRB1")
	DbCloseArea()
Endif

Use &_cArqTrab Shared New Alias TRB1

If !lJob
	IndRegua("TRB1",_cArqInd,"TIPO+ORDEM+SECAO+TESTM+NUMERO+CF",,,"Selecionando Registros")
Else
	IndRegua("TRB1",_cArqInd,"TIPO+ORDEM+SECAO+TESTM+NUMERO+CF",,,)
EndIf

_aStru	:= {}
AADD(_aStru,{"TIPO","C",01,0})  // E= ENTRADA ; S=SAIDA
AADD(_aStru,{"TESTM","C",03,0})
AADD(_aStru,{"CF","C",03,0})
AADD(_aStru,{"NUMERO","C",03,0})
AADD(_aStru,{"QTDENT","N",14,2})
AADD(_aStru,{"CUSTOENT","N",16,4})
AADD(_aStru,{"QTDSAI","N",16,4})
AADD(_aStru,{"CUSTOSAI","N",14,2})
AADD(_aStru,{"DESCTES","C",01,0})
AADD(_aStru,{"ORDEM","C",01,2})
_cArqTrab	:= Criatrab(_aStru,.T.)
_cArqInd	:= CriaTrab(,.F.)

If Select("TRB2")>0
	DbSelectArea("TRB2")
	DbCloseArea()
Endif

Use &_cArqTrab Shared New Alias TRB2

If !lJob
	IndRegua("TRB2",_cArqInd,"TIPO+ORDEM+TESTM+NUMERO+CF",,,"Selecionando Registros")
Else
	IndRegua("TRB2",_cArqInd,"TIPO+ORDEM+TESTM+NUMERO+CF",,,)
EndIf


DbSelectArea("SB1")
_cArqb1  := CriaTrab(,.f.)

_cFiltro := "B1_COD>='"+MV_PAR01+"' .AND. B1_COD<='"+MV_PAR02+"'"
_cFiltro += " .AND. B1_XSECAO>='"+MV_PAR03+"' .AND. B1_XSECAO<='"+MV_PAR04+"'"
_cFiltro += " .AND. B1_TIPO>='"+MV_PAR20+"' .AND. B1_TIPO<='"+MV_PAR21+"'"

If !lJob
	IndRegua("SB1",_cArqB1,"B1_COD",,_cFiltro,"Selecionando Registros")
Else
	IndRegua("SB1",_cArqB1,"B1_COD",,_cFiltro)
EndIf

_cQuebTes := Upper(AllTrim(MV_PAR18)+"/"+AllTrim(MV_PAR19))
DbselectArea("SB1")
DbGoTop()        
While ! Eof() .AND. SB1->B1_FILIAL=xFilial("SB1") .AND. SB1->B1_COD>=MV_PAR01 .and. SB1->B1_COD<=MV_PAR02
	
	If !lJob
		MsProcTxt("Calculando Produto: "+SB1->B1_COD)
	EndIf
	
	DbSelectArea("SBM")
	DbSetOrder(1)
	DbSeek(xFilial("SBM")+SB1->B1_GRUPO,.F.)
	If SBM->BM_XREGFIS <> 'S'
		DbSelectArea("SB1")
		DbSkip()
		Loop
	Endif
	_lMov := .F.
	
	// MONTAGEM DA QUERY MOVIMENTOS INTERNOS
	If MV_PAR07 == 1 // IMPRIME DETALHES
		cQuery := " SELECT D3_COD,D3_TM,D3_EMISSAO,D3_CF,D3_QUANT AS QUANT ,D3_CUSTO1 AS CUSTO,D3_DOC,D3_OP"
	Else
		cQuery := "SELECT D3_COD,D3_TM,D3_CF,SUM(D3_QUANT)AS QUANT ,SUM(D3_CUSTO1) AS CUSTO "
	Endif
	cQuery += " FROM " + RetSqlName("SD3")+" SD3 "
	cQuery += " WHERE SD3.D3_FILIAL>='"+MV_PAR13+"'  AND "
	cQuery += " SD3.D3_FILIAL<='"+MV_PAR14+"'  AND "
	cQuery += " SD3.D3_COD = '"+SB1->B1_COD+"' AND "
	cQuery += " SD3.D3_EMISSAO >= '" + DTOS(mv_par05) + "'  AND "
	cQuery += " SD3.D3_EMISSAO <= '" + DTOS(mv_par06) + "'  AND "
	cQuery += " SD3.D3_TM >= '" + mv_par11 + "'  AND "
	cQuery += " SD3.D3_TM <= '" + mv_par12 + "'  AND "
	cQuery += " SD3.D3_LOCAL >= '" + mv_par15 + "'  AND "
	cQuery += " SD3.D3_LOCAL <= '" + mv_par16 + "'  AND "
	cQuery += " SD3.D3_LOCAL NOT IN (" + _cString + ") AND "
	cQuery += " SD3.D3_ESTORNO <> 'S'  AND "
	cQuery += " SD3.D_E_L_E_T_=' ' "
	If MV_PAR07== 2
		cQuery += " GROUP BY D3_COD,D3_TM,D3_CF"
	Endif
	
	cQuery := ChangeQuery(cQuery)
	If Select("QRP")>0
		DbSelectArea("QRP")
		DbCloseArea()
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRP",.T.,.T.)
	
	
	TcSetField("QRP","QUANT","N",14,2)
	TcSetField("QRP","CUSTO","N",14,2)
	IF MV_PAR07==1
		TcSetField("QRP","D3_EMISSAO","D",08,0)
	Endif
	
	DbSelectArea("QRP")
	DbGoTop()
	While ! Eof()
		_lMov	:= .T.
		
		If !lJob
			MsprocTxt("Movimentos Internos Produto "+QRP->D3_COD)
		EndIf
		
		_cOrdem :='1'
		If QRP->D3_TM  $ _cGrupCus .AND. (LEFT(QRP->D3_CF,1)=='P' .OR. RIGHT(QRP->D3_CF,1)=='4')
			_cOrdem	:= '0'
		Endif
		DbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->SECAO	:=	Left(SB1->B1_XSECAO,3)
		TRB->CODIGO	:=	SB1->B1_COD
		TRB->TESTM	:=	"TM"
		TRB->CF		:=  QRP->D3_CF
		TRB->ORDEM	:= _cOrdem
		If QRP->D3_TM <='499'
			TRB->NUMERO		:=	IIF(QRP->D3_TM=='001' .AND. LEFT(QRP->D3_CF,1)=='D','005',QRP->D3_TM)
			TRB->TIPO		:= "E"
			TRB->QTDENT		:= QRP->QUANT
			TRB->CUSTOENT	:= QRP->CUSTO
		Else
			TRB->NUMERO		:=	IIF(QRP->D3_TM=='501' .AND. LEFT(QRP->D3_CF,1)=='R','505',QRP->D3_TM)
			TRB->TIPO		:= "S"
			TRB->QTDSAI		:= QRP->QUANT
			TRB->CUSTOSAI	:= QRP->CUSTO
		Endif
		IF MV_PAR07==1
			TRB->DOC := IIF(EMPTY(QRP->D3_OP),QRP->D3_DOC,ALLTRIM(QRP->D3_OP))+" "+LEFT(DTOC(QRP->D3_EMISSAO),5)
		ENDIF
		MsUnlock()
		DbSelectarea("QRP")
		DbSkip()
	Enddo
	// MONTAGEM DA QUERY NOTAS FISCAIS DE ENTRADA
	
	
	If MV_PAR07 == 1
		cQuery := "SELECT D1_COD,F4_REGRA,D1_QUANT AS QUANT ,D1_CUSTO AS CUSTO,D1_DOC,D1_SERIE,D1_DTDIGIT"
	Else
		cQuery := "SELECT D1_COD,F4_REGRA,SUM(D1_QUANT)AS QUANT ,SUM(D1_CUSTO) AS CUSTO "
	Endif
	cQuery += " FROM " + RetSqlName("SD1")+" SD1, "+ RetSqlName("SF4")+" SF4 "
	cQuery += " WHERE SD1.D1_FILIAL>='"+MV_PAR13+"'  AND "
	cQuery += " SD1.D1_FILIAL<='"+MV_PAR14+"'  AND "
	cQuery += " SD1.D1_COD = '"+SB1->B1_COD+"' AND "
	cQuery += " SD1.D1_DTDIGIT >= '" + DTOS(mv_par05) + "'  AND "
	cQuery += " SD1.D1_DTDIGIT <= '" + DTOS(mv_par06) + "'  AND "
	cQuery += " SD1.D1_FILIAL = SF4.F4_FILIAL AND "
	cQuery += " SD1.D1_TES    = SF4.F4_CODIGO AND "
	cQuery += " SF4.F4_REGRA >= '" + mv_par09 + "'  AND "
	cQuery += " SF4.F4_REGRA <= '" + mv_par10 + "'  AND "
	cQuery += " SD1.D1_LOCAL >= '" + mv_par15 + "'  AND "
	cQuery += " SD1.D1_LOCAL <= '" + mv_par16 + "'  AND "
	cQuery += " SD1.D1_LOCAL NOT IN (" + _cString + ") AND "	
	cQuery += " SF4.F4_ESTOQUE='S' AND NOT(SD1.D1_ORIGLAN LIKE 'LF') AND "
	cQuery += " SD1.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' ' "
	If MV_PAR07==2
		cQuery +=" GROUP BY D1_COD,F4_REGRA"
	Endif
	cQuery := ChangeQuery(cQuery)
	
	If Select("QRP")>0
		DbSelectArea("QRP")
		DbCloseArea()
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRP",.T.,.T.)
	
	TcSetField("QRP","QUANT","N",14,2)
	TcSetField("QRP","CUSTO","N",14,2)
	If MV_PAR07 == 1
		TcSetField("QRP","D1_DTDIGIT","D",08,0)
	Endif
	
	DbSelectArea("QRP")
	DbGoTop()
	
	While ! Eof()
		_lMov := .T.
		
		If !lJob
			MsprocTxt("Nota Fiscal de Entrada "+QRP->D1_COD)
		EndIf
		
		_cOrdem :='1'
		If QRP->F4_REGRA $ _cGrupCus
			_cOrdem	:= '0'
		Endif
		If QRP->F4_REGRA $ _cQuebTes .OR.  Empty(QRP->F4_REGRA) // TES ANALITICO
			If MV_PAR07 == 1
				cQuery := "SELECT D1_COD,D1_TES,D1_QUANT AS QUANT ,D1_CUSTO AS CUSTO,D1_DOC,D1_SERIE,D1_DTDIGIT"
			Else
				cQuery := "SELECT D1_COD,D1_TES,SUM(D1_QUANT)AS QUANT ,SUM(D1_CUSTO) AS CUSTO "
			Endif
			cQuery += " FROM " + RetSqlName("SD1")+" SD1, "+ RetSqlName("SF4")+" SF4 "
			cQuery += " WHERE SD1.D1_FILIAL>='"+MV_PAR13+"'  AND "
			cQuery += " SD1.D1_FILIAL<='"+MV_PAR14+"'  AND "
			cQuery += " SD1.D1_COD = '"+SB1->B1_COD+"' AND "
			cQuery += " SD1.D1_DTDIGIT >= '" + DTOS(mv_par05) + "'  AND "
			cQuery += " SD1.D1_DTDIGIT <= '" + DTOS(mv_par06) + "'  AND "
			cQuery += " SD1.D1_FILIAL = SF4.F4_FILIAL AND "
			cQuery += " SD1.D1_TES    = SF4.F4_CODIGO AND "
			cQuery += " SF4.F4_REGRA = '" + QRP->F4_REGRA + "'  AND "
			cQuery += " SD1.D1_LOCAL >= '" + mv_par15 + "'  AND "
			cQuery += " SD1.D1_LOCAL <= '" + mv_par16 + "'  AND "
        	cQuery += " SD1.D1_LOCAL NOT IN (" + _cString + ") AND "			
			cQuery += " SF4.F4_ESTOQUE='S' AND NOT(SD1.D1_ORIGLAN LIKE 'LF') AND "
			cQuery += " SD1.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' ' "
			If MV_PAR07==2
				cQuery +=" GROUP BY D1_COD,D1_TES"
			Endif
			cQuery := ChangeQuery(cQuery)
			
			If Select("TRBD1")>0
				DbSelectArea("TRBD1")
				DbCloseArea()
			Endif
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBD1",.T.,.T.)
			
			TcSetField("TRBD1","QUANT","N",14,2)
			TcSetField("TRBD1","CUSTO","N",14,2)
			If MV_PAR07 == 1
				TcSetField("TRBD1","D1_DTDIGIT","D",08,0)
			Endif
			DbSelectArea("TRBD1")
			DbGoTop()
			While ! Eof()
				DbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->SECAO		:=	LEFT(SB1->B1_XSECAO,3)
				TRB->CODIGO		:=	SB1->B1_COD
				TRB->TIPO		:=	"E"
				TRB->TESTM		:=	"TES"
				TRB->NUMERO		:=	TRBD1->D1_TES
				TRB->QTDENT		:= 	TRBD1->QUANT
				TRB->CUSTOENT	:= 	TRBD1->CUSTO
				TRB->ORDEM		:= 	_cOrdem
				TRB->DESCTES	:= "S"
				If MV_PAR07==1
					TRB->DOC := TRBD1->D1_DOC+"-"+TRBD1->D1_SERIE+" "+Left(DTOC(TRBD1->D1_DTDIGIT),5)
				Endif
				MsUnlock()
				DbSelectArea("TRBD1")
				DbSkip()
			Enddo
		Else
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->SECAO		:=	LEFT(SB1->B1_XSECAO,3)
			TRB->CODIGO		:=	SB1->B1_COD
			TRB->TIPO		:=	"E"
			TRB->TESTM		:=	"TES"
			TRB->NUMERO		:=	QRP->F4_REGRA
			TRB->QTDENT		:= 	QRP->QUANT
			TRB->CUSTOENT	:= 	QRP->CUSTO
			TRB->ORDEM		:= 	_cOrdem
			If MV_PAR07==1
				TRB->DOC := QRP->D1_DOC+"-"+QRP->D1_SERIE+" "+Left(DTOC(QRP->D1_DTDIGIT),5)
			Endif
			
			MsUnlock()
		Endif
		DbSelectarea("QRP")
		DbSkip()
	Enddo
	// MONTAGEM DA QUERY NOTAS FISCAIS DE SAIDA
	If MV_PAR07==1
		cQuery := "SELECT D2_COD,F4_REGRA,D2_QUANT AS QUANT ,D2_CUSTO1 AS CUSTO,D2_DOC,D2_SERIE,D2_EMISSAO "
	Else
		cQuery := "SELECT D2_COD,F4_REGRA,SUM(D2_QUANT)AS QUANT ,SUM(D2_CUSTO1) AS CUSTO "
	Endif
	cQuery += " FROM " + RetSqlName("SD2")+" SD2, "+ RetSqlName("SF4")+" SF4 "
	cQuery += " WHERE SD2.D2_FILIAL>='"+MV_PAR13+"'  AND "
	cQuery += " SD2.D2_FILIAL<='"+MV_PAR14+"'  AND "
	cQuery += " SD2.D2_COD = '"+SB1->B1_COD+"' AND "
	cQuery += " SD2.D2_EMISSAO >= '" + DTOS(mv_par05) + "'  AND "
	cQuery += " SD2.D2_EMISSAO <= '" + DTOS(mv_par06) + "'  AND "
	cQuery += " SD2.D2_FILIAL = SF4.F4_FILIAL AND "
	cQuery += " SD2.D2_TES    = SF4.F4_CODIGO AND "
	cQuery += " SF4.F4_REGRA >= '" + mv_par09 + "'  AND "
	cQuery += " SF4.F4_REGRA <= '" + mv_par10 + "'  AND "
	cQuery += " SD2.D2_LOCAL >= '" + mv_par15 + "'  AND "
	cQuery += " SD2.D2_LOCAL <= '" + mv_par16 + "'  AND "
	cQuery += " SD2.D2_LOCAL NOT IN (" + _cString + ") AND "	
	cQuery += " SF4.F4_ESTOQUE='S' AND NOT(SD2.D2_ORIGLAN LIKE 'LF') AND "
	cQuery += " SD2.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' '"
	If MV_PAR07 == 2
		cQuery += " GROUP BY D2_COD,F4_REGRA"
	Endif
	cQuery := ChangeQuery(cQuery)
	
	If Select("QRP")>0
		DbSelectArea("QRP")
		DbCloseArea()
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRP",.T.,.T.)
	
	TcSetField("QRP","QUANT","N",14,2)
	TcSetField("QRP","CUSTO","N",14,2)
	If MV_PAR07 == 1
		TcSetField("QRP","D2_EMISSAO","D",08,0)
	Endif
	DbSelectArea("QRP")
	DbGoTop()
	While ! Eof()
		_lMov := .T.
		
		If !lJob
			MsprocTxt("Nota Fiscal de Saida "+QRP->D2_COD)
		EndIf
		
		If QRP->F4_REGRA $ _cQuebTes .OR. Empty(QRP->F4_REGRA)// TES ANALITICO
			
			If MV_PAR07==1
				cQuery := "SELECT D2_COD,D2_TES,D2_QUANT AS QUANT ,D2_CUSTO1 AS CUSTO,D2_DOC,D2_SERIE,D2_EMISSAO "
			Else
				cQuery := "SELECT D2_COD,D2_TES,SUM(D2_QUANT)AS QUANT ,SUM(D2_CUSTO1) AS CUSTO "
			Endif
			cQuery += " FROM " + RetSqlName("SD2")+" SD2, "+ RetSqlName("SF4")+" SF4 "
			cQuery += " WHERE SD2.D2_FILIAL>='"+MV_PAR13+"'  AND "
			cQuery += " SD2.D2_FILIAL<='"+MV_PAR14+"'  AND "
			cQuery += " SD2.D2_COD = '"+SB1->B1_COD+"' AND "
			cQuery += " SD2.D2_EMISSAO >= '" + DTOS(mv_par05) + "'  AND "
			cQuery += " SD2.D2_EMISSAO <= '" + DTOS(mv_par06) + "'  AND "
			cQuery += " SD2.D2_FILIAL = SF4.F4_FILIAL AND "
			cQuery += " SD2.D2_TES    = SF4.F4_CODIGO AND "
			cQuery += " SF4.F4_REGRA  = '" + QRP->F4_REGRA + "'  AND "
			cQuery += " SD2.D2_LOCAL >= '" + mv_par15 + "'  AND "
			cQuery += " SD2.D2_LOCAL <= '" + mv_par16 + "'  AND "
        	cQuery += " SD2.D2_LOCAL NOT IN (" + _cString + ") AND "			
			cQuery += " SF4.F4_ESTOQUE='S' AND NOT(SD2.D2_ORIGLAN LIKE 'LF') AND "
			cQuery += " SD2.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' '"
			If MV_PAR07 == 2
				cQuery += " GROUP BY D2_COD,D2_TES"
			Endif
			cQuery := ChangeQuery(cQuery)
			
			If Select("TRBD2")>0
				DbSelectArea("TRBD2")
				DbCloseArea()
			Endif
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBD2",.T.,.T.)
			
			TcSetField("TRBD2","QUANT","N",14,2)
			TcSetField("TRBD2","CUSTO","N",14,2)
			If MV_PAR07 == 1
				TcSetField("TRBD2","D2_EMISSAO","D",08,0)
			Endif
			DbSelectArea("TRBD2")
			DbGoTop()
			While ! Eof()
				DbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->SECAO		:= LEFT(SB1->B1_XSECAO,3)
				TRB->CODIGO		:= SB1->B1_COD
				TRB->TIPO		:= "S"
				TRB->TESTM		:= "TES"
				TRB->NUMERO		:= TRBD2->D2_TES
				TRB->QTDSAI		:= TRBD2->QUANT
				TRB->CUSTOSAI	:= TRBD2->CUSTO
				TRB->DESCTES	:="S"
				If MV_PAR07==1
					TRB->DOC := TRBD2->D2_DOC+"-"+TRBD2->D2_SERIE+" "+Left(DTOC(TRBD2->D2_EMISSAO),5)
				Endif
				MsUnlock()
				DbSelectarea("TRBD2")
				DbSkip()
			Enddo
		Else
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->SECAO		:= LEFT(SB1->B1_XSECAO,3)
			TRB->CODIGO		:= SB1->B1_COD
			TRB->TIPO		:= "S"
			TRB->TESTM		:= "TES"
			TRB->NUMERO		:= QRP->F4_REGRA
			TRB->QTDSAI		:= QRP->QUANT
			TRB->CUSTOSAI	:= QRP->CUSTO
			If MV_PAR07==1
				TRB->DOC := QRP->D2_DOC+"-"+QRP->D2_SERIE+" "+Left(DTOC(QRP->D2_EMISSAO),5)
			Endif
			
			MsUnlock()
		Endif
		DbSelectarea("QRP")
		DbSkip()
	Enddo
	
	If !_lMov // Nao Houve Movimentacao do Produto No Mes
		
		l_Continua := .T.
		
		If MV_PAR22 == 2
			
			_nQtdIni := 0
			_nCustoIni := 0
			
			fCalcSldIni(@_nQtdIni, @_nCustoIni)			
			
			If _nQtdIni = 0 
				l_Continua := .F.
			Endif    
		
		Endif
			
		If l_Continua
	
			DbSelectArea("TRB")
			RecLock("TRB", .T.)
			TRB->SECAO		:=	LEFT(SB1->B1_XSECAO,3)
			TRB->CODIGO		:=	SB1->B1_COD
			TRB->TIPO		:=	"E"
			TRB->MOVIMENTO	:=	"N"
			TRB->TESTM		:=	"S"
			TRB->CF			:=	"000"
			TRB->NUMERO		:=	"999"
			TRB->ORDEM		:=  "0"
			MsUnlock()

		Endif

	Endif
	
	DbSelectArea("SB1")
	DbSkip()

Enddo        

Return


Static Function fImprime(lJob)

Local _cPicture	:=	"@E 999,999,999"
Local _cPictMed	:=	"@E 999.99"

DbSelectArea("TRB")
DbGoTop()

If !lJob
	SetRegua(LASTREC())
EndIf

_cSecao	:= TRB->SECAO
_cCod	:= TRB->CODIGO
nLin 	:= 80

cCabec1:="            P  R  O  D  U T O      |   S A L D O   I N I C I A L  |                                   |        E N T R A D A S        |        S A I D A S            |             S A L D O          |           "
cCabec2:="CODIGO  DESCRICAO                  |     QTDE        CUSTO  MEDIO |HISTORICO                          |      QTDE       CUSTO   MEDIO |     QTDE        CUSTO   MEDIO |       QTDE     CUSTO      MEDIO|  DOCUMENTO"
//         xxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxx 999,999.999 999.999.999  99,99  XXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999.999 999.999.999   99,99 999.999.999  999.999.999  99,99  999.999.999 999.999.999   999,99
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21

_lCusto	:= .t.
_nQtdSal	:= 0
_nCustoSal	:=0
_nSubQtIni	:= 0
_nTotQtIni	:= 0
_nSubVlIni	:= 0
_nTotVlIni	:= 0

nPag1 := 1 
nPag2 := 1 
nPag3 := 1 

While !Eof()
	
	If !lJob
		IncRegua()
	EndIf
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+TRB->CODIGO,.F.)
	_nQtdIni	:= 0
	_nCustoIni	:= 0
	
	If _lCusto
		
		fCalcSldIni(@_nQtdIni, @_nCustoIni)
		
		_nQtdSal	 += _nQtdIni
		_nCustoSal   += _nCustoIni
		_nSubQtIni	 += _nQtdIni
		_nSubVlIni	 += _nCustoIni
		_nTotQtIni	 += _nQtdIni
		_nTotVlIni	 += _nCustoIni

	Endif

	If nLin  > 60
      If lJob
      	nLin := U_ImpCab(cTitulo,cCabec1,cCabec2,NomeProg,Limite,nPag1)//Especifico para impressao em job para respeitar o tamanho do formulario.
      	nPag1++
      Else
      	cabec(cTitulo,cCabec1,cCabec2,nomeprog,tamanho,18)
		nLin  := 9
      EndIf
		
	Endif
	_cTexto	:=	''
	If ALLTRIM(TRB->TESTM)=="TM"
		DbSelectArea("SF5")
		DbSetOrder(1)
		DbSeek(xFilial("SF5")+ALLTRIM(TRB->NUMERO),.F.)
		_cTexto := SF5->F5_TEXTO
		If ALLTRIM(TRB->NUMERO)$"499/999"
			_cTexto	:="TRANSF.ENTRE ALMOXARIFADOS"
			If RIGHT(TRB->CF,1)== '0'
				_cTexto	:= "AJUSTE INVENTARIO"
			Endif
			If RIGHT(TRB->CF,1)== '5'
				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1")+TRB->CODIGO,.F.)
				DbSelectArea("SX5")
				DbSetOrder(1)
				DbSeek(xFilial("SX5")+"Z5"+(SB1->B1_XSECAO),.F.)
				_cTexto	:= "REQ.INDUSTRIALIZACAO "+Alltrim(SX5->X5_DESCRI)
			Endif
		Endif
	ElseIf ALLTRIM(TRB->TESTM)="TES"
		If TRB->DESCTES =="S"
			DbSelectArea("SF4")
			DbSetOrder(1)
			DbSeek(xFilial("SF4")+ALLTRIM(TRB->NUMERO),.F.)
			_cTexto := Upper(SF4->F4_TEXTO)
		Else
			_cTexto := Tabela("Z3",ALLTRIM(TRB->NUMERO),.F.)
		Endif
	Endif
	DbSelectArea("TRB")
	If MV_PAR08 == 1  // Analitico
		If _lCusto
			@ nLin,000 PSAY Left(TRB->CODIGO,10)
			@ nLin,011 PSAY LEFT(SB1->B1_DESC,20)
			@ nLin,035 PSAY Transform(_nQtdIni  ,_cPicture)
			@ nLin,047 PSAY Transform(_nCustoIni,_cPicture)
			@ nLin,059 PSAY Transform(_nCustoIni / _nQtdIni,"@E 999.99")
			_lCusto := .F.
		Endif
		If ! Empty(_cTexto) 
			@ nLin,067 PSAY ALLTRIM(TRB->NUMERO)+"-"+LEFT(_cTexto,29)
		Endif
		If TRB->QTDENT <> 0 .OR. TRB->CUSTOENT<>0
			@ nLin,100 PSAY Transform(TRB->QTDENT ,_cPicture)
			@ nLin,112 PSAY Transform(TRB->CUSTOENT,"@E 999,999,999.99")
			If TRB->QTDENT >=1
				@ nLin,127 PSAY Transform(TRB->CUSTOENT/TRB->QTDENT,"@E 999.99")
			Endif
			_nQtdSal	 := _nQtdSal  + TRB->QTDENT
			_nCustoSal   := _nCustoSal+ TRB->CUSTOENT
		Endif
		If TRB->QTDSAI <> 0 .OR. TRB->CUSTOSAI<>0
			@ nLin,132 PSAY Transform(TRB->QTDSAI ,_cPicture)
			@ nLin,145 PSAY Transform(TRB->CUSTOSAI,"@E 999,999,999.99")
			If TRB->QTDSAI >=1
				@ nLin,159 PSAY Transform(TRB->CUSTOSAI/TRB->QTDSAI,"@E 999.99")
			Endif
			_nQtdSal	 := _nQtdSal  - TRB->QTDSAI
			_nCustoSal   := _nCustoSal- TRB->CUSTOSAI
		Endif
		@ nLin,167 PSAY Transform(_nQtdSal ,_cPicture)
		@ nLin,179 PSAY Transform(_nCustoSal,"@E 999,999,999.99")
		@ nLin,193 PSAY Transform(_nCustoSal/_nQtdSal,"@E 999.99")
		@ nLin,200 PSAY ALLTRIM(TRB->DOC)
		nLin++
	Endif
	DbSelectArea("TRB1") // SUBTOTAL SECAO
	If DbSeek(TRB->TIPO+TRB->ORDEM+_cSecao+TRB->TESTM+TRB->NUMERO+TRB->CF,.F.)
		RecLock("TRB1",.F.)
		TRB1->QTDENT   := TRB1->QTDENT   + TRB->QTDENT
		TRB1->QTDSAI   := TRB1->QTDSAI   + TRB->QTDSAI
		TRB1->CUSTOENT := TRB1->CUSTOENT + TRB->CUSTOENT
		TRB1->CUSTOSAI := TRB1->CUSTOSAI + TRB->CUSTOSAI
		TRB1->DESCTES  := TRB->DESCTES
		msUnlock()
	Else
		RecLock("TRB1",.T.)
		TRB1->SECAO	   :=	_cSecao
		TRB1->TIPO	   := TRB->TIPO
		TRB1->TESTM	   := TRB->TESTM
		TRB1->CF	   := TRB->CF
		TRB1->NUMERO   := TRB->NUMERO
		TRB1->QTDENT   := TRB->QTDENT
		TRB1->QTDSAI   := TRB->QTDSAI
		TRB1->CUSTOENT := TRB->CUSTOENT
		TRB1->CUSTOSAI := TRB->CUSTOSAI
		TRB1->DESCTES  := TRB->DESCTES
		TRB1->ORDEM		:= TRB->ORDEM
		MsUnlock()
	Endif
	DbSelectArea("TRB2")  // TOTAL GERAL
	If DbSeek(TRB->TIPO+TRB->ORDEM+TRB->TESTM+TRB->NUMERO+TRB->CF,.F.)
		RecLock("TRB2",.F.)
		TRB2->QTDENT   := TRB2->QTDENT   + TRB->QTDENT
		TRB2->QTDSAI   := TRB2->QTDSAI   + TRB->QTDSAI
		TRB2->CUSTOENT := TRB2->CUSTOENT + TRB->CUSTOENT
		TRB2->CUSTOSAI := TRB2->CUSTOSAI + TRB->CUSTOSAI
		TRB2->DESCTES  := TRB->DESCTES
		msUnlock()
	Else
		RecLock("TRB2",.T.)
		TRB2->TIPO	   := TRB->TIPO
		TRB2->TESTM	   := TRB->TESTM
		TRB2->CF	   := TRB->CF
		TRB2->NUMERO   := TRB->NUMERO
		TRB2->QTDENT   :=  TRB->QTDENT
		TRB2->QTDSAI   :=  TRB->QTDSAI
		TRB2->CUSTOENT :=  TRB->CUSTOENT
		TRB2->CUSTOSAI :=  TRB->CUSTOSAI
		TRB2->ORDEM		:= TRB->ORDEM
		TRB2->DESCTES  := TRB->DESCTES
		MsUnlock()
	Endif
	
	DbSelectArea("TRB")
	DbSkip()
	If TRB->CODIGO <> _cCod .OR. EOF()
		_lCusto	:= .T.
		_cCod	:= TRB->CODIGO
		_nQtdSal	:= 0
		_nCustoSal	:= 0
		If MV_PAR08 == 1 // Impressao por Produto
			@ nLin,000 PSAY Replicate("-",220)
			nLin++
		Endif
	Endif
	If TRB->SECAO <> _cSecao .OR. EOF()
		_cSecao	:= _cSecao
		_cNomeGru:= Posicione("SX5",1,xFilial("SX5")+"Z5"+_cSecao,"X5_DESCRI")
		nLin++
		@ nLin,005 PSAY "TOTAL SECAO "+_cSecao+"-"+_cNomeGru
		nLin++
		@ nLin,033 PSAY Transform(_nSubQtIni  ,_cPicture)
		@ nLin,045 PSAY Transform(_nSubVlIni,"@E 999,999,999.99")
		@ nLin,059 PSAY Transform(_nSubVlIni / _nSubQtIni,"@E 999.99")
		_nQtdSal	 := _nSubQtIni
		_nCustoSal   := _nSubVlIni
		DbSelectArea("TRB1")
		DbGoTop()
		While ! Eof()
			_cTexto	:=	''
			If ALLTRIM(TRB1->TESTM)=="TM"
				DbSelectArea("SF5")
				DbSetOrder(1)
				DbSeek(xFilial("SF5")+ALLTRIM(TRB1->NUMERO),.F.)
				_cTexto := SF5->F5_TEXTO
				If ALLTRIM(TRB1->NUMERO)$"499/999"
					_cTexto	:="TRANSF.ENTRE ALMOXARIFADOS"
					If Right(TRB1->CF,1)== '0'
						_cTexto := "AJUSTE INVENTARIO"
					Endif
					If RIGHT(TRB1->CF,1)== '5'
					   _cTexto	:= "REQ.INDUSTRIALIZACAO "
                    Endif
				Endif
			ElseIf ALLTRIM(TRB1->TESTM)="TES"
				If TRB1->DESCTES =="S"
					DbSelectArea("SF4")
					DbSetOrder(1)
					DbSeek(xFilial("SF4")+ALLTRIM(TRB1->NUMERO),.F.)
					_cTexto := Upper(SF4->F4_TEXTO)
				Else
					_cTexto := Tabela("Z3",ALLTRIM(TRB1->NUMERO),.F.)
				Endif
			Endif
			
			If nLin  > 60
		      If lJob
		      	nLin := U_ImpCab(cTitulo,cCabec1,cCabec2,NomeProg,Limite,nPag2)//Especifico para impressao em job para respeitar o tamanho do formulario.
		      	nPag2++
		      Else
		      	cabec(cTitulo,cCabec1,cCabec2,nomeprog,tamanho,18)
				nLin  := 9
			  EndIf
			Endif
			
			DbSelectArea("TRB1")
			If ! Empty(_cTexto)
				@ nLin,067 PSAY ALLTRIM(TRB1->NUMERO)+"-"+LEFT(_cTexto,29)
			Endif
			If TRB1->QTDENT <> 0 .OR. TRB1->CUSTOENT <> 0
				@ nLin,100 PSAY Transform(TRB1->QTDENT ,_cPicture)
				@ nLin,112 PSAY Transform(TRB1->CUSTOENT,"@E 999,999,999.99")
				@ nLin,127 PSAY Transform(TRB1->CUSTOENT/TRB1->QTDENT,"@E 999.99")
				_nQtdSal	 := _nQtdSal  + TRB1->QTDENT
				_nCustoSal   := _nCustoSal+ TRB1->CUSTOENT
			Endif
			If TRB1->QTDSAI <> 0 .OR. TRB1->CUSTOSAI <> 0
				@ nLin,132 PSAY Transform(TRB1->QTDSAI ,_cPicture)
				@ nLin,145 PSAY Transform(TRB1->CUSTOSAI,"@E 999,999,999.99")
				@ nLin,159 PSAY Transform(TRB1->CUSTOSAI/TRB1->QTDSAI,"@E 999.99")
				_nQtdSal	 := _nQtdSal   - TRB1->QTDSAI
				_nCustoSal   := _nCustoSal - TRB1->CUSTOSAI
			Endif
			@ nLin,165 PSAY Transform(_nQtdSal ,_cPicture)
			@ nLin,177 PSAY Transform(_nCustoSal,"@E 999,999,999.99")
			@ nLin,193 PSAY Transform(_nCustoSal/_nQtdSal,"@E 999.99")
			nLin++
			DbSkip()
		Enddo
		@ nLin,000 PSAY Replicate("=",220)
		nLin++
		_nSubQtIni	:= 0
		_nSubVlIni	:= 0
		_nQtdSal	:= 0
		_nCustoSal	:= 0
		_cSecao := TRB->SECAO
		_cArqTrab	:= Criatrab(_aStru1,.T.)
		_cArqInd	:= CriaTrab(,.F.)
		If Select("TRB1")>0
			DbSelectArea("TRB1")
			DbCloseArea()
		Endif
		Use &_cArqTrab Shared New Alias TRB1
		
		If !lJob
			IndRegua("TRB1",_cArqInd,"TIPO+ORDEM+SECAO+TESTM+NUMERO+CF",,,"Selecionando Registros")
		Else
			IndRegua("TRB1",_cArqInd,"TIPO+ORDEM+SECAO+TESTM+NUMERO+CF",,,)
		EndIf
	Endif
	DbSelectArea("TRB")
	If  EOF()
		nLin	:= nLin + 2
		@ nLin,010 PSAY "T O T A L   G E R A  L "
		@ nLin,033 PSAY Transform(_nTotQtIni  ,_cPicture)
		@ nLin,045 PSAY Transform(_nTotVlIni,"@E 999,999,999.99")
		@ nLin,059 PSAY Transform(_nTotVlIni / _nTotQtIni,"@E 999.99")
		_nQtdSal	 := _nTotQtIni
		_nCustoSal   := _nTotVlIni
		DbSelectArea("TRB2")
		DbGoTop()
		While ! Eof()
			_cTexto	:= ' '
			If ALLTRIM(TRB2->TESTM)=="TM"
				DbSelectArea("SF5")
				DbSetOrder(1)
				DbSeek(xFilial("SF5")+ALLTRIM(TRB2->NUMERO),.F.)
				_cTexto := SF5->F5_TEXTO
				If ALLTRIM(TRB2->NUMERO)$"499/999"
					_cTexto	:="TRANSF.ENTRE ALMOXARIFADOS"
					If Right(TRB2->CF,1)== '0'
						_cTexto := "AJUSTE INVENTARIO"
					Endif
				Endif
				If RIGHT(TRB2->CF,1)== '5'
				   _cTexto	:= "REQ.INDUSTRIALIZACAO "
                Endif
			ElseIf ALLTRIM(TRB2->TESTM)=="TES"
				If TRB2->DESCTES =="S"
					DbSelectArea("SF4")
					DbSetOrder(1)
					DbSeek(xFilial("SF4")+ALLTRIM(TRB2->NUMERO),.F.)
					_cTexto := Upper(SF4->F4_TEXTO)
				Else
					_cTexto := Tabela("Z3",ALLTRIM(TRB2->NUMERO),.F.)
				Endif
			Endif
			
			If nLin  > 60
		      If lJob
		      	nLin := U_ImpCab(cTitulo,cCabec1,cCabec2,NomeProg,Limite,nPag3)//Especifico para impressao em job para respeitar o tamanho do formulario.
		      	nPag3++
		      Else
		      	cabec(cTitulo,cCabec1,cCabec2,nomeprog,tamanho,18)
				nLin  := 9
		      EndIf
				
			Endif
			DbSelectArea("TRB2")
			If ! Empty(_cTexto)
				@ nLin,067 PSAY ALLTRIM(TRB2->NUMERO)+"-"+LEFT(_cTexto,29)
			Endif
			IF TRB2->QTDENT <> 0 .OR. TRB2->CUSTOENT <> 0
				@ nLin,100 PSAY Transform(TRB2->QTDENT ,_cPicture)
				@ nLin,112 PSAY Transform(TRB2->CUSTOENT,"@E 999,999,999.99")
				@ nLin,127 PSAY Transform(TRB2->CUSTOENT/TRB2->QTDENT,"@E 999.99")
				_nQtdSal	 := _nQtdSal   + TRB2->QTDENT
				_nCustoSal   := _nCustoSal + TRB2->CUSTOENT
			Endif
			IF TRB2->QTDSAI <> 0 .OR. TRB2->CUSTOSAI <> 0
				@ nLin,132 PSAY Transform(TRB2->QTDSAI ,_cPicture)
				@ nLin,145 PSAY Transform(TRB2->CUSTOSAI,"@E 999,999,999.99")
				@ nLin,159 PSAY Transform(TRB2->CUSTOSAI/TRB2->QTDSAI,"@E 999.99")
				_nQtdSal	 := _nQtdSal   - TRB2->QTDSAI
				_nCustoSal   := _nCustoSal - TRB2->CUSTOSAI
			Endif
			@ nLin,165 PSAY Transform(_nQtdSal ,_cPicture)
			@ nLin,177 PSAY Transform(_nCustoSal,"@E 999,999,999.99")
			@ nLin,193 PSAY Transform(_nCustoSal/_nQtdSal,"@E 999.99")
			nLin++
			DbSelectArea("TRB2")
			DbSkip()
		Enddo
	Endif
	DbSelectArea("TRB")
Enddo

@ nLin,001 PSAY "."
TRB->(DbCloseArea())
TRB2->(DbCloseArea())
RetIndex("SB1")

If !lJob
	Set Device To Screen
	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		ourspool(wnrel)
	Endif               
EndIf

Ms_Flush()
	
Return


Static Function fCalcSldIni(_nQtdIni, _nCustoIni)

	// Somar Saldo Inicial dos Estoques de acordo com as filiais dos parametros
	MV_PAR13	:= IIF(EMPTY(MV_PAR13),'01',MV_PAR13)
	MV_PAR14	:= IIF(EMPTY(MV_PAR13),'99',MV_PAR14)
	
	DbSelectArea("SM0")
	_aAreaSM0:= GetArea()
	_cFilAnt := cFilAnt  // variavel publica do sistema ( utilizada na Funcao xFilial())
	DbSetOrDer(1)
	DbSeek(cEmpAnt+MV_PAR13, .T.)
	While SM0->M0_CODIGO == cEmpAnt
		cFilAnt	:= SM0->M0_CODFIL
		If cFilAnt < MV_PAR13 .OR. cFilAnt > MV_PAR14
			DbSkip()
			Loop
		Endif
		DbSelectArea("SB2")
		DbSetOrder(1)
		DbSeek(cFilAnt+SB1->B1_COD,.F.)
		While ! Eof() .AND. SB2->B2_COD==SB1->B1_COD .AND. SB2->B2_FILIAL==cFilAnt
			// Tratamento dos Almoxarifados
			If (SB2->B2_LOCAL < MV_PAR15 .OR. SB2->B2_LOCAL > MV_PAR16) .OR. SB2->B2_LOCAL $ _cString
				DbSelectArea("SB2")
				DbSkip()
				Loop
			Endif
			_aSaldoIni := CalcEst(SB2->B2_COD,SB2->B2_LOCAL,MV_PAR05)
			_nQtdIni   := _nQtdIni   + _aSaldoIni[1]
			_nCustoIni := _nCustoIni + _aSaldoIni[2]
			DbSelectArea("SB2")
			DbSkip()
		EndDo
		DbSelectArea("SM0")
		DbSkip()
	Enddo
	RestArea(_aAreaSM0)
	cFilAnt := _cFilAnt

Return Nil


Static Function ValPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
aRegs:={}

// Secao/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Produto de          ? "	,"","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"02","Produto ate         ? "	,"","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"03","Secao de            ? "	,"","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","Z5"})
aAdd(aRegs,{cPerg,"04","Secao Ate           ? "	,"","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","Z5"})
aAdd(aRegs,{cPerg,"05","Emissao de          ? "	,"","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Emissao Ate         ? "	,"","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Imprime Detalhes ? "	,"","","mv_ch7","N",01,0,0,"C","","mv_par07","Sim","1","","","","Nao","2","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Tipo Relatorio      ? "	,"","","mv_ch8","N",01,0,0,"C","","mv_par08","Produto","1","","","","Secao","2","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Regra CTB De        ? "	,"","","mv_ch9","C",03,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","Z3"})
aAdd(aRegs,{cPerg,"10","Regra CTB Ate       ? "	,"","","mv_chA","C",03,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","Z3"})
aAdd(aRegs,{cPerg,"11","Mov.Interno de      ? "	,"","","mv_chB","C",03,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SF5"})
aAdd(aRegs,{cPerg,"12","Mov.Interno Ate     ? "	,"","","mv_chC","C",03,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SF5"})
aAdd(aRegs,{cPerg,"13","Filial de          ?  "	,"","","mv_chD","C",02,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
aAdd(aRegs,{cPerg,"14","Filial Ate         ?  "	,"","","mv_chE","C",02,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
aAdd(aRegs,{cPerg,"15","Almoxarifado de    ?  "	,"","","mv_chF","C",06,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","",""," "})
aAdd(aRegs,{cPerg,"16","Almoxarifado Ate   ?  "	,"","","mv_chG","C",06,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","",""," "})
aAdd(aRegs,{cPerg,"17","Nao Considerar Almx?  "	,"","","mv_chH","C",06,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","",""," "})
aAdd(aRegs,{cPerg,"18","Grp TES Analitico 1?  "	,"","","mv_chI","C",40,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","",""," "})
aAdd(aRegs,{cPerg,"19","Grp TES Analitico 2?  "	,"","","mv_chJ","C",40,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","",""," "})
aAdd(aRegs,{cPerg,"20","Tipo do Produto de ?  "	,"","","mv_chK","C",02,0,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","","02"})
aAdd(aRegs,{cPerg,"21","Tipo do Produto até?  "	,"","","mv_chL","C",02,0,0,"G","","mv_par21","","","","","","","","","","","","","","","","","","","","","","","","","02"})
aAdd(aRegs,{cPerg,"22","Lista s/mov. sld zero?"	,"","","mv_chM","N",01,0,1,"C","","mv_par22","Sim","","","","","Não","","","","","","","","","","","","","","","","","",""," "})

U_PutX1TT(cPerg, aRegs)

Return
