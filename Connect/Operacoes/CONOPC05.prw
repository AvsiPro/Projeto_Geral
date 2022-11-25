#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

//Cabecalho: CODIGO, NUMERO DE SERIE, DATA, CODIGO CONTRATO, ITEM CONTRATO, PERIODO, COD MAQUINA, CODIGO CLIENTE, CODIGO CLEINTE PAGAMENTO
//Itens: SEQUENCIA, SELECAO, PRODUTO, QUANTIDADE LEITURA, QUANTIDADE VALOR
User Function CONOPC05()

    Local nOpc      :=  0
    Local nCont 
    Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6
    Private oSay7,oSay8,oGet1,oGet2,oGet4,oGrp3,oBtn1,oBtn2
    Private aCols   :=  {{'','','',0,0,'','','','',''}}
    Private cPatr   :=  space(15) 
    Private dDtLei  :=  ctod(" / / ")
    Private oFont1  := TFont():New('Arial',,-15,.T.)
    Private oFont2  := TFont():New('Arial',,-12,.T.)
    Private oFont3  := TFont():New('Verdana',,-12,.T.)
    Private oFont4  := TFont():New('Arial',,-16,.T.)
    Private dDiaLei := ctod(" / / ") 

    IF Select("SM0") == 0
        RpcSetType(3)
        RPCSetEnv("01","0101")
    ENDIF

    oDlg1      := MSDialog():New( 057,187,748,993,"Inclusão manual de Leituras",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,016,108,380,"Cadastro",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        
        oSay1      := TSay():New( 012,116,{||"Codigo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet1      := TGet():New( 012,168,{|u| If(PCount()>0,cPatr:=u,cPatr)},oGrp1,060,008,'',{|| Basexcli()},CLR_BLACK,CLR_WHITE,,,,.T.,,,,,,,,,"AA3_01",,,)

        oSay2      := TSay():New( 030,020,{||"Cliente"},oGrp1,,oFont4,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,332,018)
        
        oSay3      := TSay():New( 045,020,{||"Endereço"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,332,018)
        
        oSay4      := TSay():New( 055,020,{||"Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,332,018)
        
        oSay5      := TSay():New( 070,020,{||"Modelo maquina"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,332,018)
        
        oSay6      := TSay():New( 085,020,{||"Local de Instalação"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,332,018)
        
        oSay7      := TSay():New( 098,020,{||"Data da ultima leitura DD/MM/AAAA"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,332,018)

        oSay8      := TSay():New( 098,150,{||"Data da leitura Atual"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,332,018)
        oGet2      := TGet():New( 096,215,{|u| If(PCount()>0,dDtLei:=u,dDtLei)},oGrp1,060,008,'',{|| dDtLei > dDiaLei},CLR_BLACK,CLR_WHITE,,,,.T.,,,,,,,,,,,,)

        
    oGrp3      := TGroup():New( 112,016,312,380,"Leituras",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{124,048,304,352},,, oGrp3 ) 
        oList1            := TCBrowse():New(124,024,345,180,, {'Selecao','Produto','Descricao','Leit.Ant.','Leit.Atual','Consumo'},{30,40,80,30,30,30},;
                            oGrp3,,,,{|| },{|| editcol(oList1:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        
        oList1:SetArray(aCols)
        oList1:bLine := {||{aCols[oList1:nAt,01],; 
                            aCols[oList1:nAt,02],;
                            aCols[oList1:nAt,03],; 
                            aCols[oList1:nAt,04],;
                            aCols[oList1:nAt,05],;
                            aCols[oList1:nAt,05]-aCols[oList1:nAt,04]}} 

        oBtn1      := TButton():New( 316,112,"Confirmar",oDlg1,{|| oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
        oBtn2      := TButton():New( 316,240,"Cancelar",oDlg1,{|| oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)

    if nOpc = 1 
        If !Empty(dDtLei) .And. !Empty(cPatr)
            cCodiL := GetSXENum("Z08","Z08_COD")
            DbselectArea("Z08")
            For nCont := 1 to len(aCols)
                RecLock("Z08", .T.)
                Z08->Z08_FILIAL := xFilial("Z08")
                Z08->Z08_COD    := cCodiL
                Z08->Z08_SEQUEN := Strzero(nCont,2)
                Z08->Z08_NUMSER := cPatr
                Z08->Z08_DATA   := dDtLei
                Z08->Z08_SELECA := aCols[nCont,01]
                Z08->Z08_PRODUT := aCols[nCont,02]
                Z08->Z08_CONTRT := aCols[nCont,13]
                Z08->Z08_ITEM   := aCols[nCont,15]
                Z08->Z08_QTDLID := aCols[nCont,05] 
                Z08->Z08_DTDIGI := dDatabase 
                Z08->Z08_PERIOD := STRZERO(MONTH(dDtLei),2)+substr(cvaltochar(YEAR(dDtLei)),3,2)
                Z08->Z08_MAQUIN := aCols[nCont,14]
                Z08->Z08_CODCLI := aCols[nCont,06]
                Z08->Z08_LOJACL := aCols[nCont,07]
                Z08->(MsUnlock())
            Next nCont
        EndIF 
    endif

Return 
/*/{Protheus.doc} Basexcli
    (long_description)
    @type  Static Function
    @author user
    @since 23/11/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @Busca o leiaute da maquina e a leitura anterior.
    @see (links_or_references)
/*/

Static Function Basexcli()

Local aArea     :=  GetArea()

If !Empty(cPatr)
    aCols := {}
    // '','Selecao','Produto','Descrição','Valor'
    cQuery := "SELECT Z07_CHAPA,Z07_SELECA,Z07_CODPRO,B1_DESC,Z07_VLRVND,"
    cQuery += " Z07_CLIENT,Z07_LOJA,A1_NOME,A1_END,A1_BAIRRO,A1_MUN,A1_EST,"
    cQuery += " AAN_CONTRT,AAN_CODPRO,AAN_ITEM"
    cQuery += " FROM "+RetSQLName("Z07")+" Z07"
    cQuery += " LEFT JOIN "+RetSQLName("SB1")+ " B1 "
    cQuery += " ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=Z07_CODPRO AND B1.D_E_L_E_T_=' '"
    cQuery += " INNER JOIN "+RetSQLNAme("SA1")+ " A1 
    cQuery += " ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=Z07_CLIENT AND A1_LOJA=Z07_LOJA AND A1.D_E_L_E_T_=' '"
    cQuery += " INNER JOIN "+RetSQLName("AAN")+" AAN 
    cQuery += " ON AAN_FILIAL='"+xFilial("AAN")+"' AND AAN_XCBASE=Z07_CHAPA AND AAN.D_E_L_E_T_=' '"
    cQuery += " WHERE Z07_FILIAL='"+xFilial("Z07")+"' AND Z07_CHAPA='"+cPatr+"' AND Z07.D_E_L_E_T_=' '"
    cQuery += " ORDER BY Z07_SELECA"

    IF Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    ENDIF

    MemoWrite("CONFATC01.SQL",cQuery)
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")  

    WHILE !EOF() 
        Aadd(aCols,{TRB->Z07_SELECA,;
                    TRB->Z07_CODPRO,;
                    Alltrim(TRB->B1_DESC),;
                    0,;
                    0,;
                    TRB->Z07_CLIENT,;
                    TRB->Z07_LOJA,;
                    TRB->A1_NOME,;
                    Alltrim(TRB->A1_END),;
                    Alltrim(TRB->A1_BAIRRO),;
                    Alltrim(TRB->A1_MUN),;
                    TRB->A1_EST,;
                    TRB->AAN_CONTRT,;
                    TRB->AAN_CODPRO,;
                    TRB->AAN_ITEM})

        Dbskip()
    EndDo 

    cQuery := "SELECT Z08_DATA,Z08_SELECA,Z08_QTDLID FROM "+RetSQLName("Z08")
    cQuery += " WHERE Z08_FILIAL='"+xFilial("Z08")+"' AND Z08_NUMSER='"+cPatr+"'"
    cQuery += " AND Z08_DATA+Z08_COD IN(SELECT MAX(Z08_DATA)+MAX(Z08_COD) FROM "+RetSQLName("Z08")
    cQuery += " WHERE Z08_FILIAL='"+xFilial("Z08")+"' AND Z08_NUMSER='"+cPatr+"'"
    cQuery += " AND D_E_L_E_T_=' ')"

    IF Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    ENDIF

    MemoWrite("CONFATC01.SQL",cQuery)
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")

    While !EOF()
        dDiaLei := stod(TRB->Z08_DATA)
        nPos := Ascan(aCols,{|x| Alltrim(x[1]) == Strzero(val(TRB->Z08_SELECA),2)})
        If nPos > 0
            aCols[nPos,04] := TRB->Z08_QTDLID
        EndIf 
        DBSkip()
    EndDo 

    If len(aCols) < 1
        Aadd(aCols,{'','','',0,0,'','','','','','',''})
        MsgAlert("Patrimônio não encontrado ou sem configuração de leiaute!!!")
    else
        oSay2:settext("")
        oSay3:settext("")
        oSay4:settext("")
        oSay5:settext("")
        oSay7:settext("")

        oSay2:settext(aCols[len(aCols),06]+'-'+aCols[len(aCols),07]+'  -  '+aCols[len(aCols),08])
        oSay3:settext(aCols[len(aCols),09]+' - '+aCols[len(aCols),10]+' - '+aCols[len(aCols),11]+' - '+aCols[len(aCols),12])
        oSay4:settext('Contrato '+aCols[len(aCols),13])
        oSay5:settext('Modelo maquina '+Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[len(aCols),14],"B1_DESC")))
        oSay7:settext("Data da ultima leitura "+cvaltochar(dDiaLei))
    EndIf 


    oList1:SetArray(aCols)
    oList1:bLine := {||{aCols[oList1:nAt,01],; 
                        aCols[oList1:nAt,02],;
                        aCols[oList1:nAt,03],; 
                        aCols[oList1:nAt,04],;
                        aCols[oList1:nAt,05],;
                        aCols[oList1:nAt,05]-aCols[oList1:nAt,04]}}

    oList1:refresh()
    oDlg1:refresh()
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} editcol
    (long_description)
    @type  Static Function
    @author user
    @since 23/11/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editcol(nLinha)

Local aArea := GetArea()

If !Empty(dDtLei)

    lEditCell(aCols,oList1,"@E 999,999,999",5)

    oList1:refresh()
    oDlg1:refresh()
Else 
    MsgAlert("Informe a data da leitura primeiro.")
EndIF 

RestArea(aArea)

Return
