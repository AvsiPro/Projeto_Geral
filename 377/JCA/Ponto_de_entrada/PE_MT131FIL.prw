#Include 'Protheus.ch'

User Function MT131FIL()

Local cItmNeg    := BuscaIt(cfilant)
Local cFiltroSC1 := "!C1_FILIAL+C1_PRODUTO $ '"+cItmNeg+"'"


Return cFiltroSC1




/*/{Protheus.doc} BuscaIt
    (long_description)
    @type  Static Function
    @author user
    @since 15/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaIt(cfilant)

Local aArea := GetArea()
//Local aRet  := {}
Local cQuery 
Local cRet  := ""
Local cBarra:= ""

cQuery := " SELECT ZPN_FILIAL,ZPN_PRODUT"
cQuery += " FROM "+RetSQLName("ZPN")
cQuery += " WHERE ZPN_FILIAL='"+cFilant+"' AND D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF()
    //Aadd(aRet,{TRB->ZPN_FILIAL+TRB->ZPN_PRODUT})
    cRet += cBarra + TRB->ZPN_FILIAL+TRB->ZPN_PRODUT
    cBarra := "/"
    Dbskip()
ENDDO 

RestArea(aArea)

Return(cRet)
/*
#Include 'Protheus.ch'

User Function MTA131C8()

Local oModFor := PARAMIXB[1]
Local aCols   := oModFor:aDatamodel[1]
Local nCont   := 1
Local aAux    := {}
Local nPosItm := ascan(oModFor:aHeader,{|x| x[2] == "C8_ITEM"})

DbSelectArea("SB1")
DbsetOrder(1)
Dbseek(xFilial("SB1")+SC1->C1_PRODUTO)

oModFor:LoadValue("C8_XCODPAI",SB1->B1_XCODPAI) 
oModFor:SetValue("C8_XCODPAI",SB1->B1_XCODPAI)

For nCont := 1 to len(aCols)
    Aadd(aAux,aCols[nCont])
Next nCont 
//C8_FILIAL+C8_NUM+C8_ITEM+C8_ITEMGRD+C8_FORNECE+C8_LOJA+C8_FORNOME+C8_NUMPRO

Aadd(oModFor:aDatamodel,aAux)

For nCont := 1 to len(oModFor:aDatamodel)
    //oModFor:aDatamodel[nCont]:LoadValue("C8_ITEM",) 
    oModFor:aDatamodel[nCont,1,1,nPosItm] := STRZERO(nCont,4)
Next nCont

Return

#Include 'Protheus.ch'

User Function MT131C8()
Local cCamposC8 := "|C8_XCODPAI)" 
// O retorno deve começar com uma barra vertical ( | ) e ir intercalando o nomes do campos com barras verticais.
Return (cCamposC8)
*/
