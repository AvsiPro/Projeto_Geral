#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CONFAT01

Private oDlg1,oSay7,oGrp1,oSay1,oGrp2,oSay2,oGrp3,oSay3,oGrp4,oSay4,oGrp5,oSay5
Private oSay6,oGrp7,oGrp8,oGet1,oSBtn1,oBtn1

Private aList1  :=  {}
Private oList1 
Private aContra :=  {}
Private aItCont :=  {}
Private aVendas :=  {}
Private aDoses  :=  {}
Private aLocac  :=  {}
Private aVndF2  :=  {}
Private aDosF2  :=  {}
Private aLocF2  :=  {}

Private oFont1  :=  TFont():New('Arial',,-15,.T.)
Private oFont2  :=  TFont():New('Arial',,-12,.T.)
Private oFont3  :=  TFont():New('Verdana',,-12,.T.)
Private oFont4  :=  TFont():New('Arial',,-26,.T.)
Private cPer    :=  space(6)
Private nMes3
Private oChart

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

Aadd(aList1,{'','','','','','','','','',''})
 

oDlg1      := MSDialog():New( 085,210,628,1477,"Painel de Faturamento",,,.F.,,,,,,.T.,,,.T. )
    
    oGrp1      := TGroup():New( 008,008,060,100,"Pedidos Gerados",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oSay1      := TSay():New( 020,020,{||""},oGrp1,,oFont4,.F.,.F.,.F.,.T.,CLR_HMAGENTA,CLR_WHITE,076,034)
    
    oGrp2      := TGroup():New( 008,112,060,204,"Notas Faturadas",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oSay2      := TSay():New( 020,120,{||""},oGrp2,,oFont4,.F.,.F.,.F.,.T.,CLR_HGREEN,CLR_WHITE,076,044)
    
    oGrp3      := TGroup():New( 008,216,060,308,"Faturamento Dose",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oSay3      := TSay():New( 020,222,{||""},oGrp3,,oFont4,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,082,024)
    
    oGrp4      := TGroup():New( 008,320,060,412,"Faturamento Locação",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oSay4      := TSay():New( 020,326,{||""},oGrp4,,oFont4,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,082,024)
    
    oGrp5      := TGroup():New( 008,424,060,516,"Vendas",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oSay5      := TSay():New( 020,430,{||""},oGrp5,,oFont4,.F.,.F.,.F.,.T.,CLR_BROWN,CLR_WHITE,082,024)
    
    oGrp6      := TGroup():New( 008,528,060,620,"Contratos X Faturados X A Faturar",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oSay6      := TSay():New( 020,534,{||""},oGrp6,,oFont4,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,082,024)
    
    oGrp7      := TGroup():New( 068,008,236,308,"Gráfico",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oGrp8      := TGroup():New( 068,320,236,620,"Ranking por Cliente x Valor",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{076,324,232,616},,, oGrp8 ) 
        oList1 	   := TCBrowse():New(076,324,290,155,, {'Codigo','Descrição','Vlr Faturamento'},{30,90,40},;
									oGrp8,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},,,,,,,.F.,,.T.,,.F.,,,)
        oList1:SetArray(aList1)
        oList1:bLine := {||{ aList1[oList1:nAt,01],;
                             aList1[oList1:nAt,02],; 
                             aList1[oList1:nAt,03]}}

    oSay7      := TSay():New( 244,008,{||"Mes/Ano"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet1      := TGet():New( 244,056,{|u| If(Pcount()>0,cPer:=u,cPer)},oDlg1,060,008,'@R 99/9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    oSBtn1     := SButton():New( 244,132,1,{|| If(!Empty(cPer),Processa({|| Busca(cPer)},"Aguarde"),)},oDlg1,,"", )
    
    //oBtn1      := TButton():New( 244,580,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
    oMenu := TMenu():New(0,0,0,0,.T.)

    oTMenuIte1 := TMenuItem():New(oDlg1,"Opções",,,,{|| ContrFat()},,,,,,,,,.T.)
	oTMenuIte9 := TMenuItem():New(oDlg1,"Sair",,,,{|| oDlg1:end()},,,,,,,,,.T.)
	
    oMenu:Add(oTMenuIte1)
	oMenu:Add(oTMenuIte9)
	
    oTButton9 := TButton():New( 244, 580, "Opções",oDlg1,{||},040,12,,,.F.,.T.,.F.,,.F.,,,.F. )
	// Define botão no Menu
	oTButton9:SetPopupMenu(oMenu)

oDlg1:Activate(,,,.T.)

Return

/*/{Protheus.doc} Busca
    (long_description)
    @type  Static Function
    @author user
    @since 17/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca(cPeriodo)

Local aArea := GetArea()
Local cQuery 
Local cPer1 := stod(substr(cPeriodo,3)+substr(cPeriodo,1,2)+'01')
Local cPer2 := lastday(cPer1)
Local cPer3 := MonthSub(cPer1,2)
Local cPer4 := MonthSub(cPer1,1)
Local nTotV1 := 0
Local nTotV2 := 0
Local nTotV3 := 0
Local nTotD1 := 0
Local nTotD2 := 0
Local nTotD3 := 0
Local nTotL1 := 0
Local nTotL2 := 0
Local nTotL3 := 0
Local nMes1  := month(MonthSub(cPer1,2))
Local nMes2  := month(MonthSub(cPer1,1))
Local nPedM  := 0
Local nNotM  := 0
Local nCont  := 0
Local nPedV  := 0
Local nCntFt := 0

nMes3  := month(cPer1)

aContra := {}
aItCont := {}
aVendas := {}
aLocac  := {}
aDoses  := {}
aVndF2  := {}
aDosF2  := {}
aLocF2  := {}
aList1  := {}

oChart := Nil

oSay1:settext("")
oSay2:settext("")
oSay3:settext("")
oSay4:settext("")
oSay5:settext("")
oSay6:settext("")

cQuery := "SELECT AAM_CONTRT,AAM_CODCLI,AAM_LOJA,AAM_CLASSI,AAM_CPAGPV,AAM_CLASSI,X5_DESCRI,"
cQuery += " AAM_XQTVLM,AAM_XPRDCM,AAM_XFRANQ,AAM_XCODTA,AAM_XFORFA,AAM_XTIPFA,AAM_XTIPMI,"
cQuery += " AAN_CODPRO,AAN_VLRUNI,AAN_XMINQT,AAN_XCBASE,AAN_CONPAG,AAN_ITEM,"
cQuery += " A1_NOME,A1_NREDUZ"
cQuery += " FROM "+RetSQLName("AAM")+" AAM"
cQuery += " INNER JOIN "+RetSQLName("AAN")+" AAN ON AAN_FILIAL=AAM_FILIAL AND AAN_CONTRT=AAM_CONTRT AND AAN.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL=AAM_FILIAL AND A1_COD=AAM_CODCLI AND A1_LOJA=AAM_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SX5")+" X5 ON X5_FILIAL='"+xFilial("SX5")+"' AND X5_TABELA='A7' AND X5_CHAVE=AAM_CLASSI AND X5.D_E_L_E_T_=' '"
cQuery += " WHERE AAM.D_E_L_E_T_=' '"

If Select("TRB") > 0
    dbSelectArea("TRB")
    dbCloseArea()
EndIf

MemoWrite("CONFSC01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
    
DbSelectArea("TRB")   

While !EOF()
    If Ascan(aContra,{|x| x[1] == TRB->AAM_CONTRT}) == 0
        Aadd(aContra,{  TRB->AAM_CONTRT,;
                        TRB->AAM_CODCLI,;
                        TRB->AAM_LOJA,;
                        TRB->A1_NOME,;
                        TRB->A1_NREDUZ,;
                        TRB->AAM_XQTVLM,;
                        TRB->AAM_XFORFA,;
                        TRB->AAM_XTIPFA,;
                        TRB->AAM_XTIPMI,;
                        TRB->AAM_CLASSI,;
                        TRB->X5_DESCRI,;
                        0})
    EndIf 

    If Ascan(aItCont,{|x| x[1]+x[2]+x[3] == TRB->AAM_CONTRT+TRB->AAN_ITEM+TRB->AAN_CODPRO}) == 0
        Aadd(aItCont,{  TRB->AAM_CONTRT,;
                        TRB->AAN_ITEM,;
                        TRB->AAN_CODPRO,;
                        TRB->AAN_XCBASE,;
                        TRB->AAN_VLRUNI})
    EndIf 
    Dbskip()
EndDo 

//Faturamento de doses selecionado
cQuery := "SELECT C5_CLIENTE,C5_LOJACLI,MONTH(C5_EMISSAO) AS MES,"
cQuery += " (SELECT SUM(C6_VALOR) FROM "+RetSQLName("SC6")+" WHERE C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND D_E_L_E_T_=' ') AS TOTAL"
cQuery += "  FROM "+RetSQLName("SC5")
cQuery += " WHERE C5_FILIAL BETWEEN '  ' AND 'ZZZ'"
cQuery += " AND C5_EMISSAO BETWEEN '"+dtos(cPer3)+"' AND '"+dtos(cPer2)+"'"
cQuery += " AND D_E_L_E_T_=' '"
cQuery += " AND C5_XTPPED='F'"
cQuery += " ORDER BY C5_CLIENTE,C5_LOJACLI,3"

If Select("TRB") > 0
    dbSelectArea("TRB")
    dbCloseArea()
EndIf

MemoWrite("CONFSC01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
    
DbSelectArea("TRB")   

While !EOF()
    nPos := Ascan(aDoses,{|x| x[1]+x[2]+cvaltochar(x[4]) == TRB->C5_CLIENTE+TRB->C5_LOJACLI+cvaltochar(TRB->MES)})

    If nPos == 0
        Aadd(aDoses,{  TRB->C5_CLIENTE,;
                        TRB->C5_LOJACLI,;
                        TRB->TOTAL,;
                        TRB->MES})
    else
        aDoses[nPos,03] += TRB->TOTAL
    EndIf 

    Dbskip()
EndDo 

//Faturamento de Vendas
cQuery := "SELECT C5_CLIENTE,C5_LOJACLI,MONTH(C5_EMISSAO) AS MES,"
cQuery += " (SELECT SUM(C6_VALOR) FROM "+RetSQLName("SC6")+" WHERE C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND D_E_L_E_T_=' ') AS TOTAL"
cQuery += "  FROM "+RetSQLName("SC5")
cQuery += " WHERE C5_FILIAL BETWEEN '  ' AND 'ZZZ'"
cQuery += " AND C5_EMISSAO BETWEEN '"+dtos(cPer3)+"' AND '"+dtos(cPer2)+"'"
cQuery += " AND D_E_L_E_T_=' '"
cQuery += " AND C5_XTPPED='V'"
cQuery += " ORDER BY C5_CLIENTE,C5_LOJACLI,3"

If Select("TRB") > 0
    dbSelectArea("TRB")
    dbCloseArea()
EndIf

MemoWrite("CONFSC01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
    
DbSelectArea("TRB")   
//aVendas

While !EOF()
    nPos := Ascan(aVendas,{|x| x[1]+x[2]+cvaltochar(x[4]) == TRB->C5_CLIENTE+TRB->C5_LOJACLI+cvaltochar(TRB->MES)})

    If nPos == 0
        Aadd(aVendas,{  TRB->C5_CLIENTE,;
                        TRB->C5_LOJACLI,;
                        TRB->TOTAL,;
                        TRB->MES})
    else
        aVendas[nPos,03] += TRB->TOTAL
    EndIf 
    
    Dbskip()
EndDo

//Faturamento de Locação
cQuery := "SELECT C5_CLIENTE,C5_LOJACLI,MONTH(C5_EMISSAO) AS MES,"
cQuery += " (SELECT SUM(C6_VALOR) FROM "+RetSQLName("SC6")+" WHERE C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND D_E_L_E_T_=' ') AS TOTAL"
cQuery += "  FROM "+RetSQLName("SC5")
cQuery += " WHERE C5_FILIAL BETWEEN '  ' AND 'ZZZ'"
cQuery += " AND C5_EMISSAO BETWEEN '"+dtos(cPer3)+"' AND '"+dtos(cPer2)+"'"
cQuery += " AND D_E_L_E_T_=' '"
cQuery += " AND C5_XTPPED='L'"
cQuery += " ORDER BY C5_CLIENTE,C5_LOJACLI,3"

If Select("TRB") > 0
    dbSelectArea("TRB")
    dbCloseArea()
EndIf

MemoWrite("CONFSC01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
    
DbSelectArea("TRB")   
//

While !EOF()
    nPos := Ascan(aLocac,{|x| x[1]+x[2]+cvaltochar(x[4]) == TRB->C5_CLIENTE+TRB->C5_LOJACLI+cvaltochar(TRB->MES)})

    If nPos == 0
        Aadd(aLocac,{  TRB->C5_CLIENTE,;
                        TRB->C5_LOJACLI,;
                        TRB->TOTAL,;
                        TRB->MES})
    else
        aLocac[nPos,03] += TRB->TOTAL
    EndIf 

    Dbskip()
EndDo

cQuery := "SELECT F2_CLIENTE,F2_LOJA,MONTH(F2_EMISSAO) AS MES,C5_XTPPED,F2_VALMERC AS TOTAL"
cQuery += " FROM "+RetSQLName("SF2")+" F2"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=F2_FILIAL AND C5_NOTA=F2_DOC AND C5_SERIE=F2_SERIE"
cQuery += "  AND C5_XTPPED IN ('L','V','F')  AND C5.D_E_L_E_T_=' '"
cQuery += " WHERE F2_FILIAL BETWEEN '  ' AND 'ZZZ'"
cQuery += " AND F2_EMISSAO BETWEEN '"+dtos(cPer3)+"' AND '"+dtos(cPer2)+"'"
cQuery += " AND F2.D_E_L_E_T_=' '"
cQuery += " ORDER BY F2_CLIENTE,F2_LOJA,3"

If Select("TRB") > 0
    dbSelectArea("TRB")
    dbCloseArea()
EndIf

MemoWrite("CONFSC01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
    
DbSelectArea("TRB")

While !EOF()
    IF TRB->C5_XTPPED == "F"
        //F2_CLIENTE,F2_LOJA,MONTH(F2_EMISSAO) AS MES,C5_XTPPED,F2_VALMERC
        nPos := Ascan(aDosF2,{|x| x[1]+x[2]+cvaltochar(x[4]) == TRB->F2_CLIENTE+TRB->F2_LOJA+cvaltochar(TRB->MES)})

        If nPos == 0
            Aadd(aDosF2,{  TRB->F2_CLIENTE,;
                            TRB->F2_LOJA,;
                            TRB->TOTAL,;
                            TRB->MES})
        else
            aDosF2[nPos,03] += TRB->TOTAL
        EndIf 
    ElseIf TRB->C5_XTPPED == "L"
        nPos := Ascan(aLocF2,{|x| x[1]+x[2]+cvaltochar(x[4]) == TRB->F2_CLIENTE+TRB->F2_LOJA+cvaltochar(TRB->MES)})

        If nPos == 0
            Aadd(aLocF2,{  TRB->F2_CLIENTE,;
                            TRB->F2_LOJA,;
                            TRB->TOTAL,;
                            TRB->MES})
        else
            aLocF2[nPos,03] += TRB->TOTAL
        EndIf 
    ElseIf TRB->C5_XTPPED == "V"
        nPos := Ascan(aVndF2,{|x| x[1]+x[2]+cvaltochar(x[4]) == TRB->F2_CLIENTE+TRB->F2_LOJA+cvaltochar(TRB->MES)})

        If nPos == 0
            Aadd(aVndF2,{  TRB->F2_CLIENTE,;
                            TRB->F2_LOJA,;
                            TRB->TOTAL,;
                            TRB->MES})
        else
            aVndF2[nPos,03] += TRB->TOTAL
        EndIf 
    EndIf 
    

    Dbskip()
EndDo 

Aeval(aVndF2,{|x| nTotV1 += If(x[4]==nMes1,x[3],0) })
Aeval(aLocF2 ,{|x| nTotL1 += If(x[4]==nMes1,x[3],0) })
Aeval(aDosF2 ,{|x| nTotD1 += If(x[4]==nMes1,x[3],0) })

Aeval(aVndF2,{|x| nTotV2 += If(x[4]==nMes2,x[3],0) })
Aeval(aLocF2 ,{|x| nTotL2 += If(x[4]==nMes2,x[3],0) })
Aeval(aDosF2 ,{|x| nTotD2 += If(x[4]==nMes2,x[3],0) })

Aeval(aVndF2 ,{|x| nTotV3 += If(x[4]==nMes3,x[3],0) })
Aeval(aLocF2 ,{|x| nTotL3 += If(x[4]==nMes3,x[3],0) })
Aeval(aDosF2 ,{|x| nTotD3 += If(x[4]==nMes3,x[3],0) })

Aeval(aVendas,{|x| nPedM += If(x[4]==nMes3,1,0) })
Aeval(aLocac ,{|x| nPedM += If(x[4]==nMes3,1,0) })
Aeval(aDoses ,{|x| nPedM += If(x[4]==nMes3,1,0) })

Aeval(aVndF2, {|x| nNotM += If(x[4]==nMes3,1,0) })
Aeval(aLocF2 ,{|x| nNotM += If(x[4]==nMes3,1,0) })
Aeval(aDosF2 ,{|x| nNotM += If(x[4]==nMes3,1,0) })

Aeval(aVendas,{|x| nPedV += If(x[4]==nMes3,x[3],0) })
Aeval(aLocac ,{|x| nPedV += If(x[4]==nMes3,x[3],0) })
Aeval(aDoses ,{|x| nPedV += If(x[4]==nMes3,x[3],0) })

For nCont := 1 to len(aContra)
    If Ascan(aLocF2,{|x| x[1]+x[2] == aContra[nCont,02]+aContra[nCont,03]}) > 0 .And. aContra[nCont,12] == 0
        nCntFt++
        aContra[nCont,12] := 1
    EndIF

    If Ascan(aDosF2,{|x| x[1]+x[2] == aContra[nCont,02]+aContra[nCont,03]}) > 0 .And. aContra[nCont,12] == 0
        nCntFt++
        aContra[nCont,12] := 1
    EndIF 
Next nCont

oSay1:settext(cvaltochar(nPedM)+" "+Transform(nPedV,"@E 999,999,999.99"))
oSay2:settext(cvaltochar(nNotM)+" "+Transform(nTotD3+nTotL3+nTotV3,"@E 999,999,999.99"))

oSay3:settext(cvaltochar(Transform(nTotD3,"@E 999,999,999.99")))
oSay4:settext(cvaltochar(Transform(nTotL3,"@E 999,999,999.99")))
oSay5:settext(cvaltochar(Transform(nTotV3,"@E 999,999,999.99")))
oSay6:settext(cvaltochar(len(aContra))+" / "+cvaltochar(nCntFt)+" / "+cvaltochar(len(aContra)-nCntFt))


oChart := FWChartFactory():New()
oChart:SetOwner(oGrp7)

oChart:SetXAxis( {"Mês "+mesextenso(cPer3), "Mês "+mesextenso(cPer4), "Mês "+mesextenso(cPer1)} )
oChart:addSerie('Doses'     , {  nTotD1, nTotD2, nTotD3 } )
oChart:addSerie('Locação'   , {  nTotL1, nTotL2, nTotL3 } )
oChart:addSerie('Venda'     , {  nTotV1, nTotV2, nTotV3 } )    

oChart:setPicture("@E 999,999,999.99")

oChart:setMask("R$ *@*")

//:SetLegend(CONTROL_ALIGN_LEFT)

oChart:setTitle("Titulo do Grafico", CONTROL_ALIGN_CENTER)

//oChart:SetAlignSerieLabel(CONTROL_ALIGN_RIGHT)

oChart:SetChartDefault(COLUMNCHART)

oChart:Activate()

//aVndF2 aLocF2 aDosF2
For nCont := 1 to len(aVndF2)
    nPos := Ascan(aList1,{|x| x[1] == aVndF2[nCont,01]})

    If nPos == 0
        nPos2 := Ascan(aContra,{|x| x[2] == aVndF2[nCont,01]})
        If nPos2 > 0    
            cNome := aContra[nPos2,05]
        else 
            cNome := Posicione("SA1",1,xFilial("SA1")+aVndF2[nCont,01]+aVndF2[nCont,02],"A1_NREDUZ")
        endif

        Aadd(aList1,{aVndF2[nCont,01],;
                    cNome,;
                    aVndF2[nCont,03]})
    else
        aList1[nPos,03] += aVndF2[nCont,03]
    endif
Next nCont 

For nCont := 1 to len(aLocF2)
    nPos := Ascan(aList1,{|x| x[1] == aLocF2[nCont,01]})

    If nPos == 0
        nPos2 := Ascan(aContra,{|x| x[2] == aLocF2[nCont,01]})
        If nPos2 > 0    
            cNome := aContra[nPos2,05]
        else 
            cNome := Posicione("SA1",1,xFilial("SA1")+aLocF2[nCont,01]+aLocF2[nCont,02],"A1_NREDUZ")
        endif

        Aadd(aList1,{aLocF2[nCont,01],;
                    cNome,;
                    aLocF2[nCont,03]})
    else
        aList1[nPos,03] += aLocF2[nCont,03]
    endif
Next nCont

For nCont := 1 to len(aDosF2)
    nPos := Ascan(aList1,{|x| x[1] == aDosF2[nCont,01]})

    If nPos == 0
        nPos2 := Ascan(aContra,{|x| x[2] == aDosF2[nCont,01]})
        If nPos2 > 0    
            cNome := aContra[nPos2,05]
        else 
            cNome := Posicione("SA1",1,xFilial("SA1")+aDosF2[nCont,01]+aDosF2[nCont,02],"A1_NREDUZ")
        endif

        Aadd(aList1,{aDosF2[nCont,01],;
                    cNome,;
                    aDosF2[nCont,03]})
    else
        aList1[nPos,03] += aDosF2[nCont,03]
    endif
Next nCont

If len(aList1) < 1
    Aadd(aList1,{'','',0})
EndIf

Asort(aList1,,,{|x,y| x[3] > y[3]})

oList1:SetArray(aList1)
oList1:bLine := {||{ aList1[oList1:nAt,01],;
                    aList1[oList1:nAt,02],; 
                    Transform(aList1[oList1:nAt,03],"@E 999,999,999.99")}}

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} ContrFat
    (long_description)
    @type  Static Function
    @author user
    @since 20/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ContrFat()

Local aArea := GetArea()
Local nCont
Local aTipo    :=  {"1=Todos","2=Faturados","3=A Faturar"}
Local cTipo    :=  aTipo[1]
Local aPergs   :=  {}
Local aRet     :=  {}

Private oContra
Private oItemC
Private oNotas
Private aDetCon :=  {}
Private aItemC  :=  {}
Private aFatura :=  {}

Private oDlg2,oContr,oItem,oFatura,oDetalhe,oSay1,oSay2,oSair

Aadd(aItemC,{'','',''})
Aadd(aFatura,{'','',''})

aAdd( aPergs ,{2,"Tipo?"	,cTipo,aTipo,080,'',.T.})

If !ParamBox(aPergs ,"Parametros ",aRet)
    Return 
Else 
    cTipo := aRet[1]
EndIf 

If cTipo == "1"
    For nCont := 1 to len(aContra)
        Aadd(aDetCon,aContra[nCont])
    Next nCont
ElseIf cTipo == "2" 
    For nCont := 1 to len(aContra)
        If aContra[nCont,12] > 0
            Aadd(aDetCon,aContra[nCont])
        EndIf 
    Next nCont
Else
    For nCont := 1 to len(aContra)
        If aContra[nCont,12] == 0
            Aadd(aDetCon,aContra[nCont])
        EndIf 
    Next nCont
EndIf 

oDlg2      := MSDialog():New( 092,232,602,1258,"Contratos",,,.F.,,,,,,.T.,,,.T. )

    oContr     := TGroup():New( 004,004,112,296,"Contratos",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,108,292},,, oContr ) 
    oContra 	   := TCBrowse():New(012,008,285,097,, {'Contrato','Cliente','Vlr Min Contrato'},{30,90,40},;
									oContr,,,,{|| FHelp3(oContra:nAt)},{|| /*editcol(oList:nAt)*/},,,,,,,.F.,,.T.,,.F.,,,)
        oContra:SetArray(aDetCon)
        oContra:bLine := {||{   aDetCon[oContra:nAt,01],;
                                Alltrim(aDetCon[oContra:nAt,05]),; 
                                Transform(aDetCon[oContra:nAt,06],"@E 999,999,999.99")}}

    oItem      := TGroup():New( 116,004,224,296,"Itens",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{124,008,120,292},,, oItem ) 
    oItemC 	   := TCBrowse():New(124,008,285,095,, {'Patrimonio','Descrição','Vlr Locação'},{30,90,40},;
									oItem,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},,,,,,,.F.,,.T.,,.F.,,,)
    oItemC:SetArray(aItemC)
    oItemC:bLine := {||{   aItemC[oItemC:nAt,01],;
                           aItemC[oItemC:nAt,02],; 
                           aItemC[oItemC:nAt,03]}}
                            
    oFatura    := TGroup():New( 116,300,224,504,"Faturamento",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw3      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{124,304,220,500},,, oFatura ) 
    oNotas 	   := TCBrowse():New(124,304,195,095,, {'Tipo','Valor'},{50,90},;
									oFatura,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},,,,,,,.F.,,.T.,,.F.,,,)
    oNotas:SetArray(aFatura)
    oNotas:bLine := {||{   aFatura[oNotas:nAt,01],;
                           aFatura[oNotas:nAt,02]}}

    oDetalhe   := TGroup():New( 004,300,112,504,"Detalhes",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )

        oSay1      := TSay():New( 020,306,{||""},oDetalhe,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,042,008)
        oSay2      := TSay():New( 020,354,{||""},oDetalhe,,oFont1,.F.,.F.,.F.,.T.,CLR_HGREEN,CLR_WHITE,136,008)
        oSay3      := TSay():New( 035,306,{||""},oDetalhe,,,.F.,.F.,.F.,.T.,CLR_HMAGENTA,CLR_WHITE,136,008)
        oSay4      := TSay():New( 050,306,{||""},oDetalhe,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,146,028)
        oSay5      := TSay():New( 085,306,{||""},oDetalhe,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,146,028)
        
        oSair      := TButton():New( 228,224,"Sair",oDlg2,{|| oDlg2:end()},037,012,,,,.T.,,"",,,,.F. )

oDlg2:Activate(,,,.T.)

RestArea(aArea)

Return

/*/{Protheus.doc} FHelp3
nLinhadescription)
    @type  Static Function
    @author user
    @since 20/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FHelp3(nLinha)
    
Local aArea := GetArea()
Local nCont := 0
Local aForfa    :=  {'Mensal','Quinzenal'}
Local aTipFa    :=  {'Min.Global','Min.Ativo','Sem Min.'}
Local aTipMi    :=  {'Quantidade','Valor'}
Local cTipFat   :=  ''

aItemC  := {}
aFatura := {}

oSay1:settext("")
oSay2:settext("")
oSay3:settext("")
oSay4:settext("")
oSay5:settext("")

For nCont := 1 to len(aItCont)
    If aItCont[nCont,01] == aDetCon[nLinha,01]
        Aadd(aItemC,aItCont[nCont])
    EndIf 
Next nCont

For nCont := 1 to len(aVndF2)
    If aVndF2[nCont,01] == aDetCon[nLinha,02] .And. aVndF2[nCont,02] == aDetCon[nLinha,03] .And. aVndF2[nCont,04] == nMes3
        Aadd(aFatura,{'Venda',aVndF2[nCont,03]})
    EndIf
Next nCont

For nCont := 1 to len(aDosF2)
    If aDosF2[nCont,01] == aDetCon[nLinha,02] .And. aDosF2[nCont,02] == aDetCon[nLinha,03] .And. aDosF2[nCont,04] == nMes3
        Aadd(aFatura,{'Doses',aDosF2[nCont,03]})
    EndIf
Next nCont

For nCont := 1 to len(aLocF2)
    If aLocF2[nCont,01] == aDetCon[nLinha,02] .And. aLocF2[nCont,02] == aDetCon[nLinha,03] .And. aLocF2[nCont,04] == nMes3
        Aadd(aFatura,{'Locação',aLocF2[nCont,03]})
    EndIf
Next nCont

If len(aFatura) < 1
    Aadd(aFatura,{'',0,''})
EndIf 

cTipFat := 'Forma Faturamento - '+aForfa[val(aDetcon[nLinha,07])]+CRLF
cTipFat += 'Tipo Faturamento - '+aTipFa[val(aDetcon[nLinha,08])]+CRLF
cTipFat += 'Tipo Minimo - '+aTipMi[val(aDetcon[nLinha,09])]+CRLF

oSay1:settext(aDetCon[nLinha,02]+"/"+aDetcon[nLinha,03])
oSay2:settext(aDetCon[nLinha,04])
oSay3:settext("Ativos no Contrato "+cvaltochar(len(aItemC)))
oSay4:settext(cTipFat)
oSay5:settext("Classificação Contrato - "+If(!Empty(aDetCon[nLinha,11]),Alltrim(aDetCon[nLinha,11]),'Sem classificação'))

oItemC:SetArray(aItemC)
oItemC:bLine := {||{    Alltrim(aItemC[oItemC:nAt,04]),;
                        Alltrim(Posicione("SB1",1,xFilial("SB1")+aItemC[oItemC:nAt,03],"B1_DESC")),; 
                        Transform(If(aItemC[oItemC:nAt,05]<1,0,aItemC[oItemC:nAt,05]),"@E 999,999.99")}}

oNotas:SetArray(aFatura)
oNotas:bLine := {||{    aFatura[oNotas:nAt,01],;
                        Transform(aFatura[oNotas:nAt,02],"@E 999,999,999.99")}}

oNotas:refresh()                 
oItemC:refresh()
oDlg2:refresh()

RestArea(aArea)

Return
