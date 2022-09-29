#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFIS01DI บAutor  ณAlexandre Venancio  บ Data ณ  04/19/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao dos registros de complemento da nota fiscal de     บฑฑ
ฑฑบ          ณimportacao.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFIS01DI(cAcerto,cFEnt,cDoc,cSer,cFornec,cLoj,cNumDI,cvTransp,cfImp)

Local aArea	:=	GetArea()
Local cQuery

//If cEmpAnt <> "01"
//	Return
//EndIf

cQuery := "SELECT D1_FILIAL,D1_DOC,D1_SERIE,F1_ESPECIE,D1_FORNECE,D1_LOJA,F1_XDI,D1_BASIMP5,D1_ALQIMP5,D1_VALIMP5,D1_BASIMP6,D1_ALQIMP6,D1_VALIMP6,F1_XDTDI,F1_XLDESE,F1_XUFDES,F1_XDTDES,D1_ITEM"
cQuery += " FROM "+RetSQLName("SD1")+" D1"
cQuery += " INNER JOIN "+RetSQLName("SF1")+" F1 ON F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA AND F1.D_E_L_E_T_=''"

If cAcerto == "CD5"
	cQuery += " WHERE D1_FILIAL='"+cFEnt+"' AND D1_DOC='"+cDoc+"' AND D1_SERIE='"+cSer+"' AND D1_FORNECE='"+cFornec+"' AND D1_LOJA='"+cLoj+"'"
Else
	cQuery += " WHERE D1_DTDIGIT BETWEEN '"+cFEnt+"' AND '"+cDoc+"'"
	If substr(cnumemp,1,2) == "01"
		cQuery += " AND D1_TES IN('491','492','493','494','496','499','49A','49C','49E')"
		cQuery += " AND D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA NOT IN (SELECT CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA FROM "+RetSQLName("CD5")+" WHERE D_E_L_E_T_='')"
	ELSE
		cQuery += " AND D1_TES IN('491','492','49B','49E','49I','49J','49K','49L')"
		cQuery += " AND D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA NOT IN (SELECT CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA FROM "+RetSQLName("CD5")+" WHERE D_E_L_E_T_='')"
	ENDIF
EndIf

cQuery += " AND D1.D_E_L_E_T_=''"

If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

MemoWrite("TTFIS01DI.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )


DbSelectArea( "TRB" )        

While !EOF()
	
	If Empty(cAcerto)
		cDoc := TRB->D1_DOC
		cSer := TRB->D1_SERIE
		cFornec := TRB->D1_FORNECE
		cLoj := TRB->D1_LOJA
		cNumDI  := TRB->F1_XDI
	EndIf
	
	DbSelectArea("CD5")
	DbSetOrder(1)
	If !DbSeek(cFEnt+cDoc+cSer+cFornec+cLoj+cNumDI+cvaltochar(TRB->D1_ITEM))
		Reclock("CD5",.T.)
		CD5->CD5_FILIAL  :=    TRB->D1_FILIAL
		CD5->CD5_DOC   	 :=    TRB->D1_DOC
		CD5->CD5_SERIE   :=    TRB->D1_SERIE
		CD5->CD5_ESPEC   :=    TRB->F1_ESPECIE
		CD5->CD5_FORNEC  :=    TRB->D1_FORNECE
		CD5->CD5_LOJA    :=    TRB->D1_LOJA
		CD5->CD5_TPIMP   :=    '0'
		CD5->CD5_DOCIMP  :=    TRB->F1_XDI
		CD5->CD5_BSPIS   :=    TRB->D1_BASIMP6
		CD5->CD5_ALPIS   :=    TRB->D1_ALQIMP6
		CD5->CD5_VLPIS   :=    TRB->D1_VALIMP6
		CD5->CD5_BSCOF   :=    TRB->D1_BASIMP5
		CD5->CD5_ALCOF   :=    TRB->D1_ALQIMP5
		CD5->CD5_VLCOF   :=    TRB->D1_VALIMP5
		CD5->CD5_NDI     :=    TRB->F1_XDI
		CD5->CD5_DTDI    :=    STOD(TRB->F1_XDTDI)
		CD5->CD5_LOCDES  :=    TRB->F1_XLDESE
		CD5->CD5_UFDES   :=    TRB->F1_XUFDES
		CD5->CD5_DTDES   :=    STOD(TRB->F1_XDTDES)
		CD5->CD5_NADIC   :=    cvaltochar(val(TRB->D1_ITEM))
		CD5->CD5_SQADIC  :=    cvaltochar(val(TRB->D1_ITEM))
		CD5->CD5_CODFAB  :=    TRB->D1_FORNECE
		CD5->CD5_ITEM    :=    TRB->D1_ITEM
		CD5->CD5_CODEXP	 :=		TRB->D1_FORNECE
		CD5->CD5_LOJEXP  :=		TRB->D1_LOJA
		CD5->CD5_LOCAL   :=   	'0'	
		CD5->CD5_VTRANS	:= cvTransp	// adicionado Jackson 03/08/2015
		CD5->CD5_INTERM := cfImp	// adicionado Jackson 03/08/2015
		
		CD5->(Msunlock())
    EndIf
	DbSelectArea("TRB")
	Dbskip()
EndDo 
	
If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

RestArea(aArea)

Return