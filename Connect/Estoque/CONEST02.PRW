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

User Function CONEST02

Local lPer      :=  .T.
Private oDlg1,oGrp1,oGrp2,oGrp3,oGrp4,oBtn1
Private aList1  :=  {}
Private aList2  :=  {}
Private aList2B :=  {}
Private aList3  :=  {}
Private aList3B :=  {}
Private aList4  :=  {}
Private aList4B :=  {}
Private oList1
Private oList2
Private oList3
Private oList4
Private aConsumo := {}

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

lPer := Periodo()

If !lPer 
    Return 
EndIf 

Processa({|| Busca()},"Aguarde")

If len(aList2) < 1
    Aadd(aList2,{'','','','',''})
EndIf

If len(aList3) < 1
    Aadd(aList3,{'','','','',''})
EndIf

If len(aList4) < 1
    Aadd(aList4,{'','','','',''})
EndIf

oDlg1      := MSDialog():New( 053,216,625,1475,"Fechamento Estoque Ponto de Venda",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,008,132,252,"Clientes",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,012,124,248},,, oGrp1 ) 
    oList1 	   := TCBrowse():New(012,012,236,115,, {'Cliente','Loja','Nome'},{30,20,50},;
	                            oGrp1,,,,{|| FHelp(oList1:nAt)},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],;
                        aList1[oList1:nAt,02],; 
                        aList1[oList1:nAt,03]}}
                        
oGrp2      := TGroup():New( 004,256,132,616,"Consumo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,260,128,612},,, oGrp2 ) 
    oList2 	   := TCBrowse():New(012,260,350,115,, {'Produto','Descricao','Consumo'},{40,50,30},;
	                            oGrp2,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList2:SetArray(aList2)
    oList2:bLine := {||{aList2[oList2:nAt,01],;
                        aList2[oList2:nAt,02],; 
                        aList2[oList2:nAt,03]}}

oGrp3      := TGroup():New( 136,008,252,252,"Ativos Contrato",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw3      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{144,012,248,248},,, oGrp3 ) 
    oList3 	   := TCBrowse():New(144,012,236,105,, {'Ativo','Ponto Venda','Contrato'},{40,50,60},;
	                            oGrp3,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList3:SetArray(aList3)
    oList3:bLine := {||{aList3[oList3:nAt,01],;
                        aList3[oList3:nAt,02],; 
                        aList3[oList3:nAt,03]}}

oGrp4      := TGroup():New( 136,256,252,616,"Remessas X Consumo X Estoques",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw4      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{144,260,248,612},,, oGrp4 ) 
    oList4 	   := TCBrowse():New(144,260,350,105,, {'Produto','Descricao','Ponto Venda','Remessa','Consumo','Saldo'},{30,40,30,30,30,30},;
	                            oGrp4,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList4:SetArray(aList4)
    oList4:bLine := {||{aList4[oList4:nAt,01],;
                        aList4[oList4:nAt,02],;
                        aList4[oList4:nAt,08],;
                        aList4[oList4:nAt,09],; 
                        aList4[oList4:nAt,10],;  
                        aList4[oList4:nAt,03]}}

    MENU oMenuP POPUP 
    MENUITEM "Consumo x Estrutura"   ACTION (cnsvsest())
    ENDMENU                                                                           

    oList2:bRClicked := { |oObject,nX,nY| oMenuP:Activate( nX, (nY-10), oObject ) }

//oBtn1      := TButton():New( 256,580,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
//Botao de faturamento
oMenu := TMenu():New(0,0,0,0,.T.)
// Adiciona itens no Menu
oTMenuIte1   := TMenuItem():New(oDlg1,"Devoluções",,,,{|| Processa({|| devolpv(),"Gerando Devoluções"})},,,,,,,,,.T.)
oTMenuIte7   := TMenuItem():New(oDlg1,"Sair",,,,{|| oDlg1:end()},,,,,,,,,.T.)
oMenu:Add(oTMenuIte1)
oMenu:Add(oTMenuIte7)
oTButton1 := TButton():New( 256, 580, "Opções",oDlg1,{||},037,12,,,.F.,.T.,.F.,,.F.,,,.F. )
// Define botão no Menu
oTButton1:SetPopupMenu(oMenu)

oDlg1:Activate(,,,.T.)

Return

/*/{Protheus.doc} Busca
    (long_description)
    @type  Static Function
    @author user
    @since 06/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca()

Local cQuery := ''
Local aProds := {}
Local nCont  := 0

cQuery := "SELECT D2_CLIENTE,D2_LOJA,A1_NOME,D2_COD,B1_DESC,D2_DOC,D2_SERIE,SUM(D2_QUANT) AS CONSUMO"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D2_COD AND B1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " WHERE D2_FILIAL='"+MV_PAR01+"'"
cQuery += " AND D2_EMISSAO BETWEEN '"+dtos(MV_PAR02)+"' AND '"+dtos(MV_PAR03)+"'"
cQuery += " AND D2.D_E_L_E_T_=' '" 
cQuery += " AND D2_PEDIDO IN(SELECT C5_NUM FROM "+RetSQLName("SC5")+" WHERE C5_FILIAL='"+MV_PAR01+"' AND C5_XTPPED='F' AND D_E_L_E_T_=' ' AND C5_EMISSAO<='"+dtos(MV_PAR03)+"')"
cQuery += " AND D2_COD <> 'DOSE COMP'"
cQuery += " GROUP BY D2_CLIENTE,D2_LOJA,A1_NOME,D2_COD,B1_DESC,D2_DOC,D2_SERIE"

If Select("TRB") > 0
    dbSelectArea("TRB")
    dbCloseArea()
EndIf

cQuery:= ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.) 

DbSelectArea("TRB")   

While !EOF()
    If Ascan(aList1,{|x| Alltrim(x[1]) == Alltrim(TRB->D2_CLIENTE)}) == 0
        Aadd(aList1,{TRB->D2_CLIENTE,;
                    TRB->D2_LOJA,;
                    TRB->A1_NOME})
    EndIf 

    nPos2 := Ascan(aList2B,{|x| Alltrim(x[1])+Alltrim(x[4]) == Alltrim(TRB->D2_COD)+Alltrim(TRB->D2_CLIENTE)})
    
    If nPos2 == 0
        Aadd(aList2B,{  TRB->D2_COD,;
                        TRB->B1_DESC,;
                        TRB->CONSUMO,;
                        TRB->D2_CLIENTE,;
                        TRB->D2_LOJA})
    Else 
        aList2B[nPos2,03] += TRB->CONSUMO 
    EndIf

    If Ascan(aProds,{|x| Alltrim(x) == Alltrim(TRB->D2_COD)}) == 0
        Aadd(aProds,TRB->D2_COD) 
    EndIf 

    Dbskip()
EndDo 

For nCont := 1 to len(aProds)
    cQuery := "SELECT G1_COD,G1_COMP,G1_QUANT"
    cQuery += " FROM "+RetSQLName("SG1")
    cQuery += " WHERE G1_FILIAL='"+xFilial("SG1")+"' AND G1_COD='"+aProds[nCont]+"' AND D_E_L_E_T_=' '"

    If Select("TRB") > 0
        dbSelectArea("TRB")
        dbCloseArea()
    EndIf

    cQuery:= ChangeQuery(cQuery)

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.) 

    DbSelectArea("TRB")   

    While !EOF()
        If Ascan(aConsumo,{|x| x[1]+x[2] == TRB->G1_COD+TRB->G1_COMP}) == 0
            Aadd(aConsumo,{ TRB->G1_COD,;
                            TRB->G1_COMP,;
                            TRB->G1_QUANT})
        EndIf
        Dbskip()
    EndDo 

Next nCont 

//Ativos x Clientes x Contratos
For nCont :=  1 to len(aList1)
    cQuery := "SELECT AA3_CODCLI,AA3_LOJA,AA3_CHAPA,AA3_XPTVEN,AAN_CONTRT"
    cQuery += " FROM "+RetSQLName("AA3")
    cQuery += " LEFT JOIN "+RetSQLName("AAN")+" AAN ON AAN_FILIAL=AA3_FILIAL AND AA3_CHAPA=AAN_XCBASE AND AAN.D_E_L_E_T_= ' '
    cQuery += " WHERE AA3_FILIAL='"+xFilial("AA3")+"' AND AA3_CODCLI='"+aList1[nCont,01]+"' AND AA3_LOJA='"+aList1[nCont,02]+"'"

    If Select("TRB") > 0
        dbSelectArea("TRB")
        dbCloseArea()
    EndIf

    cQuery:= ChangeQuery(cQuery)

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.) 

    DbSelectArea("TRB")   

    While !EOF()
        Aadd(aList3B,{  TRB->AA3_CHAPA,;
                        TRB->AA3_XPTVEN,;
                        TRB->AAN_CONTRT,;
                        TRB->AA3_CODCLI,;
                        TRB->AA3_LOJA})
        Dbskip() 
    EndDo
Next nCont

//Remessas
cQuery := "SELECT NNR_CODCLI,NNR_LOJCLI,A1_NOME,D2_COD,B1_DESC,C5_XCODPA,NNR_DESCRI,SUM(D2_QUANT) AS REMESSA"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=D2_FILIAL AND C5_NUM=D2_PEDIDO AND C5.D_E_L_E_T_=' ' AND C5_XTPPED='A' AND C5_EMISSAO BETWEEN '"+dtos(MV_PAR02)+"' AND '"+dtos(MV_PAR03)+"' AND C5_XCODPA<>' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D2_COD AND B1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("NNR")+" NNR ON NNR_FILIAL=C5_FILIAL AND NNR_CODIGO=C5_XCODPA AND NNR.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=NNR_CODCLI AND A1_LOJA=NNR_LOJCLI AND A1.D_E_L_E_T_=' '"
cQuery += " WHERE D2_FILIAL='"+MV_PAR01+"'" 
cQuery += " AND D2_EMISSAO BETWEEN '"+dtos(MV_PAR02)+"' AND '"+dtos(MV_PAR03)+"'"
cQuery += " AND D2.D_E_L_E_T_=' '" 
cQuery += " GROUP BY NNR_CODCLI,NNR_LOJCLI,A1_NOME,D2_COD,B1_DESC,C5_XCODPA,NNR_DESCRI"

If Select("TRB") > 0
    dbSelectArea("TRB")
    dbCloseArea()
EndIf

cQuery:= ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.) 

DbSelectArea("TRB")   

While !EOF()
    Aadd(aList4B,{  Alltrim(TRB->D2_COD),;
                    Alltrim(TRB->B1_DESC),;
                    TRB->REMESSA,;
                    TRB->NNR_CODCLI,;
                    TRB->NNR_LOJCLI,;
                    TRB->A1_NOME,;
                    TRB->C5_XCODPA,;
                    Alltrim(TRB->NNR_DESCRI),;
                    0,;
                    0})
    Dbskip()
EndDo 

Asort(aList1,,,{|x,y| x[3] < y[3]})

CalcSld()
CalcCns()

Return

/*/{Protheus.doc} Periodo
    (long_description)
    @type  Static Function
    @author user
    @since 06/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Periodo()

Local aRet      :=  {}
Local aPergs    :=  {}
Local aFilFat   :=  {"0101","0102"}
Local cFilFat   :=  aFilFat[1]
Local cMesFat   :=  ""
Local aMeses    :=  {"1=Janeiro","2=Fevereiro","3=Março","4=Abril","5=Maio","6=Junho","7=Julho","8=Agosto","9=Setembro","10=Outubro","11=Novembro","12=Dezembro"}


aAdd( aPergs ,{2,"Filial : "		,cFilFat,aFilFat,080,'',.T.})  
aAdd( aPergs ,{2,"Mês Fechamento?"	,cMesFat,aMeses,080,'',.T.})

If !ParamBox(aPergs ,"Parametros ",aRet)
	Return .F.
Else
    MV_PAR01 := aRet[1]
    aMes     := separa(aRet[2],"=")
    MV_PAR02 := stod(cvaltochar(year(ddatabase))+strzero(val(aMes[1]),2)+'01')
    MV_PAR03 := lastday(stod(cvaltochar(year(ddatabase))+strzero(val(aMes[1]),2)+'01'))

EndIF 

Return .T.


/*/{Protheus.doc} Fhelp
    (long_description)
    @type  Static Function
    @author user
    @since 06/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Fhelp(nLinha)

Local aArea := GetArea()
Local nCont 

aList2 := {}
aList3 := {}
aList4 := {}

For nCont := 1 to len(aList2B)
    If aList2B[nCont,04] == aList1[nLinha,01] .And. aList2B[nCont,05] == aList1[nLinha,02]
        Aadd(aList2,aList2B[nCont])
    EndIf 
Next nCont

For nCont := 1 to len(aList3B)
    If aList3B[nCont,04] == aList1[nLinha,01] .And. aList3B[nCont,05] == aList1[nLinha,02]
        Aadd(aList3,aList3B[nCont])
    EndIf 
Next nCont 

For nCont := 1 to len(aList4B)
    If aList4B[nCont,04] == aList1[nLinha,01] .And. aList4B[nCont,05] == aList1[nLinha,02]
        Aadd(aList4,aList4B[nCont])
    EndIf 
Next nCont 

If len(aList2) < 1
    Aadd(aList2,{'','','','',''})
EndIf 

If len(aList3) < 1
    Aadd(aList3,{'','','','','','',''})
EndIf 

If len(aList4) < 1
    Aadd(aList4,{'','','','','','',''})
EndIf 

oList2:SetArray(aList2)
oList2:bLine := {||{aList2[oList2:nAt,01],;
                    aList2[oList2:nAt,02],; 
                    aList2[oList2:nAt,03]}}

oList3:SetArray(aList3)
oList3:bLine := {||{aList3[oList3:nAt,01],;
                    aList3[oList3:nAt,02],; 
                    aList3[oList3:nAt,03]}}

oList4:SetArray(aList4)
oList4:bLine := {||{aList4[oList4:nAt,01],;
                    aList4[oList4:nAt,02],;
                    aList4[oList4:nAt,08],;
                    aList4[oList4:nAt,09],; 
                    aList4[oList4:nAt,10],;  
                    aList4[oList4:nAt,03]}}

oList2:refresh()
oList3:refresh()
oList4:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} CalcSld
    (long_description)
    @type  Static Function
    @author user
    @since 06/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function CalcSld()

Local nCont := 0
//aList4B 9

DbSelectArea("SB2")
DbSetOrder(1)
For nCont := 1 to len(aList4B)
    IF DbSeek(xFilial("SB2")+Avkey(aList4B[nCont,01],"B2_COD")+aList4B[nCont,07])
        aList4B[nCont,09] := SaldoSB2()
    ENDIF
Next nCont 

Return

/*/{Protheus.doc} CalcCns
    (long_description)
    @type  Static Function
    @author user
    @since 06/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function CalcCns()

Local nCont1 := 0
Local nCont2 := 0
Local nPos   := 0
Local nCons  := 0
//aList4B 10
//aConsumo
//aList2B
Asort(aList2B,,,{|x,y| x[4] < y[4]})
Asort(aList4B,,,{|x,y| x[4] < y[4]})

For nCont1 := 1 to len(aList4B)
    nPos := Ascan(aList2B,{|x| Alltrim(x[4]) == Alltrim(aList4B[nCont1,04])})
    If nPos > 0
        For nCont2 := nPos to len(aList2B)
            nPos  := Ascan(aConsumo,{|x| Alltrim(x[1])+Alltrim(x[2]) == Alltrim(aList2B[nCont2,01])+Alltrim(aList4B[nCont1,01])})
            If nPos > 0
                nCons := aList2B[nCont2,03] * aConsumo[nPos,03]
            else
                nCons := 99999
            EndIf 
            aList4B[nCont1,10] := nCons
            If aList2B[nCont2,04] <> aList4B[nCont1,04]
                EXIT
            EndIf
        Next nCont2
    EndIf
Next nCont1

Return


/*/{Protheus.doc} cnsvsest
    (long_description)
    @type  Static Function
    @author user
    @since 06/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function cnsvsest()

Local oDlg2,oSay1,oSay2,oGrp1b,oBtn1b
Local aAux := {}
Local nCont
Local nPos := Ascan(aConsumo,{|x| x[1] == aList2[oList2:nAt,01]})
Local oAux 

If nPos > 0
    For nCont := nPos to len(aConsumo )
        If aConsumo[nCont,01] <> aList2[oList2:nAt,01]
            exit 
        EndIf 
        
        Aadd(aAux,{aConsumo[nCont,02],;
                    Alltrim(Posicione("SB1",1,xFilial("SB1")+aConsumo[nCont,02],"B1_DESC")),;
                    aConsumo[nCont,03]})

        
    Next nCont

    If len(aAux) > 0
        oDlg2      := MSDialog():New( 092,232,446,763,"Consumo X Estrutura",,,.F.,,,,,,.T.,,,.T. )

        oSay1      := TSay():New( 004,032,{||aList2[oList2:nAt,01]},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay2      := TSay():New( 004,072,{||aList2[oList2:nAt,02]},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,152,008)

        oGrp1b      := TGroup():New( 020,008,152,267,"Estrutura",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
            //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{028,012,148,236},,, oGrp1 ) 
            oAux 	   := TCBrowse():New(028,012,248,115,, {'Produto','Descricao','Qtd Consumo dose'},{30,60,30},;
	                            oGrp1b,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
            oAux:SetArray(aAux)
            oAux:bLine := {||{  aAux[oAux:nAt,01],;
                                aAux[oAux:nAt,02],; 
                                aAux[oAux:nAt,03]}}

        oBtn1b      := TButton():New( 156,096,"Sair",oDlg2,{||oDlg2:end()},037,012,,,,.T.,,"",,,,.F. )

        oDlg2:Activate(,,,.T.)
    EndIf 
Else 
    MsgAlert("Sem estrutura cadastrada")
EndIf 
   
Return

/*/{Protheus.doc} devolpv
    (long_description)
    @type  Static Function
    @author user
    @since 06/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function devolpv()
    
Return
