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
Private aList5  :=  {}
Private aList5B :=  {}
Private oList1
Private oList2
Private oList3
Private oList4
Private oList5
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
    Aadd(aList4,{'','','','','','',''})
EndIf

If len(aList5) < 1
    Aadd(aList5,{'','','','','',''})
EndIf 

oDlg1      := MSDialog():New( 053,216,725,1620,"Fechamento Estoque Ponto de Venda",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,008,142,302,"Clientes",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
    oList1 	   := TCBrowse():New(012,012,286,126,, {'Cliente','Loja','Nome'},{30,20,50},;
	                            oGrp1,,,,{|| FHelp(oList1:nAt)},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],;
                        aList1[oList1:nAt,02],; 
                        aList1[oList1:nAt,03]}}

oGrp4      := TGroup():New( 004,306,142,690,"Remessas X Consumo X Estoques",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oList4 	   := TCBrowse():New(012,310,375,126,, {'Produto','Descricao','Ponto Venda','Remessa','Consumo','Saldo'},{30,40,30,30,30,30},;
	                            oGrp4,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

    oList4:SetArray(aList4)
    oList4:bLine := {||{aList4[oList4:nAt,01],;
                        aList4[oList4:nAt,02],;
                        aList4[oList4:nAt,08],;
                        aList4[oList4:nAt,09],; 
                        aList4[oList4:nAt,10],;  
                        aList4[oList4:nAt,03]}}

oGrp3      := TGroup():New( 146,008,292,212,"Ativos Contrato",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oList3 	   := TCBrowse():New(154,012,196,135,, {'Ativo','Ponto Venda','Contrato'},{40,50,60},;
	                            oGrp3,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList3:SetArray(aList3)
    oList3:bLine := {||{aList3[oList3:nAt,01],;
                        aList3[oList3:nAt,02],; 
                        aList3[oList3:nAt,03]}}

oGrp2      := TGroup():New( 146,216,292,435,"Consumo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oList2 	   := TCBrowse():New(154,220,210,135,, {'Produto','Descricao','Consumo'},{40,50,30},;
	                            oGrp2,,,,{|| FHelp2(oList2:nAt)},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
  
    oList2:SetArray(aList2)
    oList2:bLine := {||{aList2[oList2:nAt,01],;
                        aList2[oList2:nAt,02],; 
                        aList2[oList2:nAt,03]}}

oGrp5      := TGroup():New( 146,439,292,690,"Estrutura x Consumo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oList5 	   := TCBrowse():New(154,442,243,135,, {'Produto','Descricao','UM','Consumo','Bx Estr'},{30,30,20,30,30},;
	                            oGrp5,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
  
    oList5:SetArray(aList5)
    oList5:bLine := {||{aList5[oList5:nAt,02],;
                        aList5[oList5:nAt,03],; 
                        aList5[oList5:nAt,04],;
                        aList5[oList5:nAt,05],;
                        aList5[oList5:nAt,06]}}


//Botao de faturamento
oMenu := TMenu():New(0,0,0,0,.T.)
    // Adiciona itens no Menu
    oTMenuIte1   := TMenuItem():New(oDlg1,"Devoluções",,,,{|| Processa({|| devolpv(),"Gerando Devoluções"})},,,,,,,,,.T.)
    oTMenuIte7   := TMenuItem():New(oDlg1,"Sair",,,,{|| oDlg1:end()},,,,,,,,,.T.)
    oMenu:Add(oTMenuIte1)
    oMenu:Add(oTMenuIte7)
    
    oTButton1 := TButton():New( 310, 650, "Opções",oDlg1,{||},037,12,,,.F.,.T.,.F.,,.F.,,,.F. )

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
cQuery += " AND D2_PEDIDO IN(SELECT C5_NUM FROM "+RetSQLName("SC5")+" WHERE C5_FILIAL='"+MV_PAR01+"'"
cQuery += "     AND C5_XTPPED='F' AND D_E_L_E_T_=' ' AND C5_EMISSAO<='"+dtos(MV_PAR03)+"'"
cQuery += "     AND C5_CLIENTE BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"')"
cQuery += " AND D2_COD <> 'DOSE COMP'"

cQuery += " AND D2_CLIENTE BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'"

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
                        Alltrim(TRB->B1_DESC),;
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
    cQuery := "SELECT G1_COD,G1_COMP,B1_DESC,B1_UM,B1_SEGUM,G1_QUANT,G1_XBAIXA"
    cQuery += " FROM "+RetSQLName("SG1")+" G1"
    cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=G1_COMP AND B1.D_E_L_E_T_=' '"
    cQuery += " WHERE G1_FILIAL='"+xFilial("SG1")+"' AND G1_COD='"+aProds[nCont]+"' AND G1.D_E_L_E_T_=' '"

    If Select("TRB") > 0
        dbSelectArea("TRB")
        dbCloseArea()
    EndIf

    cQuery:= ChangeQuery(cQuery)

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.) 

    DbSelectArea("TRB")   

    While !EOF()
        If Ascan(aConsumo,{|x| x[1]+x[2] == TRB->G1_COD+TRB->G1_COMP}) == 0
            Aadd(aConsumo,{ Alltrim(TRB->G1_COD),;
                            Alltrim(TRB->G1_COMP),;
                            Alltrim(TRB->B1_DESC),;
                            Alltrim(TRB->B1_UM)+"/"+Alltrim(TRB->B1_SEGUM),;
                            TRB->G1_QUANT,;
                            TRB->G1_XBAIXA})
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

cQuery += "   AND A1_COD BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'"

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
    If Ascan(aList4B,{|x| x[1]+x[4] == Alltrim(TRB->D2_COD)+TRB->NNR_CODCLI}) == 0
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
    EndIf

    Dbskip()
EndDo 

Asort(aList1,,,{|x,y| x[3] < y[3]})

SldSRem()
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
Local cAno      :=  cvaltochar(year(ddatabase))
Local cCliDe    :=  space(9)
Local cCliAt    :=  'ZZZZZZZZZ'

aAdd( aPergs ,{2,"Filial : "		,cFilFat,aFilFat,080,'',.T.})  
aAdd( aPergs ,{2,"Mês Fechamento?"	,cMesFat,aMeses,080,'',.T.})
aAdd( aPergs ,{1,"Ano?"				,cAno	,"@!",'.T.',"",'.T.',50,.T.})  
aAdd( aPergs ,{1,"Cliente de?"		,cCliDe	,"@!",'.T.',"SA1",'.T.',80,.F.})  
aAdd( aPergs ,{1,"Cliente Ate?"		,cCliAt	,"@!",'.T.',"SA1",'.T.',80,.F.})  

If !ParamBox(aPergs ,"Parametros ",aRet)
	Return .F.
Else
    MV_PAR01 := aRet[1]
    aMes     := separa(aRet[2],"=")
    MV_PAR02 := stod(cvaltochar(year(ddatabase))+strzero(val(aMes[1]),2)+'01')
    MV_PAR03 := lastday(stod(cvaltochar(year(ddatabase))+strzero(val(aMes[1]),2)+'01'))
    MV_PAR04 := aRet[4]
    MV_PAR05 := aRet[5]
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
        nPos := Ascan(aList4,{|x| x[1]+x[4] == aList4B[nCont,01]+aList4B[nCont,04]})
        If nPos == 0
            Aadd(aList4,aList4B[nCont])
        Else 
            aList4[nPos,03] += aList4B[nCont,03]
        EndIf
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

FHelp2(oList2:nAt)

RestArea(aArea)

Return

/*/{Protheus.doc} Fhelp2
nLinhadescription)
    @type  Static F
    uthor user
    @since 25/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Fhelp2(nLinha)

Local aArea := GetArea()
Local nCont := 0

aList5 := {}

For nCont := 1 to len(aConsumo)
    If Alltrim(aConsumo[nCont,01]) == Alltrim(aList2[nLinha,01])
        Aadd(aList5,aConsumo[nCont])
    EndIf 
Next nCont 

If len(aList5) < 1 
    Aadd(aList5,{'','','','','',''})
EndIf 


oList5:SetArray(aList5)
oList5:bLine := {||{aList5[oList5:nAt,02],;
                    aList5[oList5:nAt,03],; 
                    aList5[oList5:nAt,04],;
                    aList5[oList5:nAt,05],;
                    aList5[oList5:nAt,06]}}

oList5:refresh()
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
            If aList2B[nCont2,04] <> aList4B[nCont1,04]
                EXIT
            EndIf
            
            nPos  := Ascan(aConsumo,{|x| Alltrim(x[1])+Alltrim(x[2]) == Alltrim(aList2B[nCont2,01])+Alltrim(aList4B[nCont1,01])})
            
            nCons := 0

            If nPos > 0
                If aConsumo[nPos,06] <> "N"
                    nCons := aList2B[nCont2,03] * aConsumo[nPos,05]
                EndIf
            
            EndIf 

            If nCons > 0
                aList4B[nCont1,10] += nCons
            EndIf 
            
        Next nCont2
    EndIf
Next nCont1

Return

/*/{Protheus.doc} SldSRem
    (long_description)
    @type  Static Function
    @author user
    @since 25/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function SldSRem()

Local aArea     :=  GetArea()
Local nCont     :=  0
Local cQuery 

For nCont := 1 to len(aList3B)

    cQuery := "SELECT B2_COD,B1_DESC,0 AS REMESSA,A1_NOME,B2_LOCAL,NNR_DESCRI,B2_QATU"
    cQuery += " FROM "+RetSQLName("SB2")+" B2"
    cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=B2_COD AND B1.D_E_L_E_T_=' '"
    cQuery += " INNER JOIN "+RetSQLName("NNR")+" NNR ON NNR_FILIAL=B2_FILIAL AND NNR_CODIGO=B2_LOCAL AND NNR.D_E_L_E_T_=' ' AND NNR_MSBLQL<>'1'"
    cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=NNR_CODCLI AND A1_LOJA=NNR_LOJCLI AND A1.D_E_L_E_T_=' '"

    cQuery += "   AND A1_COD BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'"
    
    cQuery += " WHERE B2_FILIAL='"+Alltrim(MV_PAR01)+"' AND B2_LOCAL='"+aList3B[nCont,02]+"'"

    If Select("TRB") > 0
        dbSelectArea("TRB")
        dbCloseArea()
    EndIf

    cQuery:= ChangeQuery(cQuery)

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.) 

    DbSelectArea("TRB")   

    While !EOF()
        If Ascan(aList4B,{|x| x[1]+x[4] == Alltrim(TRB->B2_COD)+aList3B[nCont,04]}) == 0
            Aadd(aList4B,{  Alltrim(TRB->B2_COD),;
                            Alltrim(TRB->B1_DESC),;
                            TRB->REMESSA,;
                            aList3B[nCont,04],;
                            aList3B[nCont,05],;
                            TRB->A1_NOME,;
                            TRB->B2_LOCAL,;
                            Alltrim(TRB->NNR_DESCRI),;
                            TRB->B2_QATU,;
                            0})
        EndIf 
        Dbskip()
    EndDo 

Next nCont

RestArea(aArea)

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

Local aArea     :=  GetArea()
Local nCont 
Local aAux      :=  {}
Local nX 
Local aQtdx     :=  {}
Local nOpc      :=  0
Private aCabec  :=  {}
Private aItemD1 :=  {}
Private oCabec
Private oItem 
Private aItens  :=  {}

Private oOk   	:= LoadBitmap(GetResources(),'br_verde')   
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')    

Private oDev1,oGrp1,oGrp2,oBtn1,oBtn2

Aadd(aItens,{'','','','','','','','','','',''})

For nCont := 1 to len(aList1)

    nPos := Ascan(aList4B,{|x| Alltrim(x[4]) == Alltrim(aList1[nCont,01])})

    If nPos > 0 

        Aadd(aAux,{ aList1[nCont,01],;
                    aList1[nCont,02],;
                    aList1[nCont,03]})

        For nX := nPos to len(aList4B)

            If Alltrim(aList4B[nX,04]) <> Alltrim(aList1[nCont,01])
                EXIT
            EndIf 

            If aList4B[nX,10] > 0
                DbSelectArea("SB1")
                DbSetOrder(1)
                DbSeek(xFilial("SB1")+aList4B[nX,01])
                cUn := SB1->B1_UM
                cSe := SB1->B1_SEGUM
                nCn := SB1->B1_CONV
                //Convertendo quantidades para subir pacotes na devolucao
                //aList4B[nX,10]
                nVlrBxD1 := Round((aList4B[nX,10]*nCn)/nCn,0)
                If nVlrBxD1 <= 0
                    nVlrBxD1 := 1
                EndIF 
                Aadd(aAux[len(aAux)],{  aList4B[nX,01],;
                                        nVlrBxD1,;
                                        aList4B[nX,07],;
                                        nVlrBxD1})
            EndIf 

        Next nX 

    EndIf

Next nCont 

For nCont := 1 to len(aAux)
    If len(aAux[nCont]) > 2
        aQtdx := {}
        
        For nX := 4 to len(aAux[nCont])
            cQuery := "SELECT D2_DOC,D2_SERIE,D2_ITEM,D2_QUANT,D2_QTDEDEV,D2_PRCVEN,D2_QUANT-D2_QTDEDEV AS SALDO"
            cQuery += " FROM "+RetSQLName("SD2")+" D2"
            cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=D2_FILIAL AND D2_PEDIDO=C5_NUM AND C5.D_E_L_E_T_=' '"
            cQuery += " AND C5_XTPPED='A' AND C5_XCODPA='"+aAux[nCont,nX,03]+"'"
            cQuery += " WHERE D2_FILIAL='"+MV_PAR01+"' AND D2.D_E_L_E_T_=' ' AND D2_EMISSAO <='"+dtos(MV_PAR03)+"'"
            cQuery += " AND D2_COD='"+aAux[nCont,nX,01]+"'"
            cQuery += " AND D2_QUANT>D2_QTDEDEV"
            cQuery += " ORDER BY D2_EMISSAO"

            If Select("TRB") > 0
                dbSelectArea("TRB")
                dbCloseArea()
            EndIf

            cQuery:= ChangeQuery(cQuery)

            DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.) 

            DbSelectArea("TRB")   

            While !EOF()
               
                If TRB->SALDO >= aAux[nCont,nX,04]
                    If aAux[nCont,nX,04] <= TRB->SALDO 
                        nSaldo := aAux[nCont,nX,04]
                    Else 
                        nSaldo := TRB->SALDO 
                    EndIF

                    aAux[nCont,nX,04] -= nSaldo

                    Aadd(aQtdx,{TRB->D2_DOC,;
                                TRB->D2_SERIE,;
                                TRB->D2_ITEM,;
                                nSaldo,;
                                TRB->D2_PRCVEN})
                Else 
                    nSaldo := TRB->SALDO 
                    aAux[nCont,nX,04] -= TRB->SALDO 
                    Aadd(aQtdx,{TRB->D2_DOC,;
                                TRB->D2_SERIE,;
                                TRB->D2_ITEM,;
                                nSaldo,;
                                TRB->D2_PRCVEN})
                Endif

                If aAux[nCont,nX,04] == 0
                    Aadd(aAux[nCont,nX],aQtdx)
                    aQtdx := {} 
                    exit 
                EndIf 

                DbSkip()
            EndDo 

            If len(aQtdx) > 0
                Aadd(aAux[nCont,nX],aQtdx)
                aQtdx := {}     
            EndIf 

        Next nX

    EndIF 

Next nCont 


If len(aAux) > 0
    //Aadd(aCabec,{'','','','',''})
    //Aadd(aItemD1,{'','','','',''})

    For nCont := 1 to len(aAux)
        Aadd(aCabec,{   .T.,;
                        aAux[nCont,01],;
                        aAux[nCont,02],;
                        aAux[nCont,03],;
                        '',;
                        '',;
                        ''})
        
        cItem := '01'

        For nX := 4 to len(aAux[nCont])
            nPos := Ascan(aList4B,{|x| Alltrim(x[1]) == Alltrim(aAux[nCont,nX,01])})
            If nPos > 0
                cDesc := aList4B[nPos,02]
            Else 
                cDesc := Posicione("SB1",1,xFilial("SB1")+aAux[nCont,nX,01])
            EndIf 
            
            nVlrUn := 0
            cNFOri := ''
            cSROri := ''
            cITOri := ''

            If len(aAux[nCont,nX]) > 4
                nVlrUn := aAux[nCont,nX,5,1,5]
                cNFOri := aAux[nCont,nX,5,1,1]
                cSROri := aAux[nCont,nX,5,1,2]
                cITOri := aAux[nCont,nX,5,1,3]
            EndIf 

            Aadd(aItemD1,{  cItem,;
                            aAux[nCont,nX,01],;
                            cDesc,;
                            aAux[nCont,nX,02],;
                            nVlrUn,;
                            aAux[nCont,nX,03],;
                            cNFOri,;
                            cSROri,;
                            cITOri,;
                            aAux[nCont,01],;
                            aAux[nCont,02]})

            cItem := Soma1(cItem)    
        Next nX 
    Next nCont 

    oDev1      := MSDialog():New( 092,232,654,1336,"Notas a Retornar",,,.F.,,,,,,.T.,,,.T. )
    
        oGrp1      := TGroup():New( 004,004,120,540,"Cabeçalhos",oDev1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,116,536},,, oGrp1 ) 
            oCabec 	   := TCBrowse():New(012,008,526,104,, {'','Cliente','Loja','Nome','Nota','Serie','Pedido'},{10,30,20,150,30,30,30},;
	                            oGrp1,,,,{|| FHelpNF(oCabec:nAt)},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
            oCabec:SetArray(aCabec)
            oCabec:bLine := {||{If(aCabec[oCabec:nAt,01],oOk,oNo),;
                                aCabec[oCabec:nAt,02],; 
                                aCabec[oCabec:nAt,03],;
                                aCabec[oCabec:nAt,04],;
                                aCabec[oCabec:nAt,05],; 
                                aCabec[oCabec:nAt,06],;
                                aCabec[oCabec:nAt,07]}}

        oGrp2      := TGroup():New( 124,004,252,540,"Itens",oDev1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{132,008,248,536},,, oGrp2 ) 
            oItem 	   := TCBrowse():New(132,008,526,114,, {'Item','Codigo','Descricao','Qtd','Vlr Unt.','Estoque','NF Origem','Serie Origem','Item Origem'},{20,40,80,30,30,30,30,30,30},;
	                            oGrp2,,,,{|| /*FHelp(oItem:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
            oItem:SetArray(aItens)
            oItem:bLine := {||{ aItens[oItem:nAt,01],;
                                aItens[oItem:nAt,02],; 
                                aItens[oItem:nAt,03],;
                                aItens[oItem:nAt,04],;
                                aItens[oItem:nAt,05],; 
                                aItens[oItem:nAt,06],;
                                aItens[oItem:nAt,07],;
                                aItens[oItem:nAt,08],; 
                                aItens[oItem:nAt,09]}}

        oBtn1      := TButton():New( 256,192,"Confirmar",oDev1,{|| oDev1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
        oBtn2      := TButton():New( 256,260,"Cancelar",oDev1,{|| oDev1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

    oDev1:Activate(,,,.T.)


    If nOpc == 1
        Processa({|| gerardoc(aCabec,aItemD1),"Aguarde"})
    EndIf 

EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} FHelpNF
nLinhadescription)
    @type  Static Function
    @author user
    @since 08/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FHelpNF(nLinha)

Local aArea :=  GetArea()
Local nCont :=  1

aItens := {}

For nCont := 1 to len(aItemD1)
    If aItemD1[nCont,10] == aCabec[nLinha,02] .And. aItemD1[nCont,11] == aCabec[nLinha,03]
        Aadd(aItens,aItemD1[nCont])
    EndIf  
Next nCont 

If len(aItens) < 1
    Aadd(aItens,{'','','','','','','','','','',''})
EndIf 

oItem:SetArray(aItens)
oItem:bLine := {||{ aItens[oItem:nAt,01],;
                    aItens[oItem:nAt,02],; 
                    aItens[oItem:nAt,03],;
                    aItens[oItem:nAt,04],;
                    aItens[oItem:nAt,05],; 
                    aItens[oItem:nAt,06],;
                    aItens[oItem:nAt,07],;
                    aItens[oItem:nAt,08],; 
                    aItens[oItem:nAt,09]}}

oItem:refresh()
oDev1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} gerardoc
    (long_description)
    @type  Static Function
    @author user
    @since 13/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gerardoc(aCabec,aItemD1)

Local aArea     :=  GetArea()
Local nCont
Local nItens
Local nX 
Local aCabD1    :=  {}
Local aItens    :=  {}
Local aIteNF    :=  {}
Local aLinha    :=  {}
Local cFornec   :=  '24575331 '
Local cLojFor   :=  '0001'
Local _atotitem :=  {}
Local _aitem    :=  {}
Local cTM			:=	GetMv("MV_XTMSD3S",,"501")
	
Asort(aItemD1,,,{|x,y| x[10]+x[11] < y[10]+y[11]})
Asort(aCabec,,,{|x,y| x[2]+x[3] < y[2]+y[3]})

For nCont := 1 to len(aCabec)
    aCabD1 := {}
    _atotitem :=  {}
    _aitem    :=  {}

    //cDoc := GetSXenum("SF1","F1_DOC")
    DbSelectArea("SX5")
    SX5->(MsSeek(cFilant +'01' + "1     "))
    cDoc := Alltrim(SX5->X5_DESCRI)
    RecLock("SX5",.F.)
    SX5->X5_DESCRI  := Soma1(AllTrim(Substr(cDoc,1,9)))
    SX5->X5_DESCSPA := Soma1(AllTrim(Substr(cDoc,1,9)))
    SX5->X5_DESCENG := Soma1(AllTrim(Substr(cDoc,1,9)))
    SX5->(MsUnlock())
    
    aadd(aCabD1,{"F1_TIPO"   		,"N"})		
    aadd(aCabD1,{"F1_FORMUL" 		,"S"})		
    aadd(aCabD1,{"F1_DOC"    		,cDoc})		
    aadd(aCabD1,{"F1_SERIE"  		,"1"})		
    aadd(aCabD1,{"F1_EMISSAO"		,dDataBase})		
    aadd(aCabD1,{"F1_FORNECE"		,cFornec})		
    aadd(aCabD1,{"F1_LOJA"   		,cLojFor})		
    aadd(aCabD1,{"F1_ESPECIE"		,"SPED"})		
    aadd(aCabD1,{"F1_COND"			,"001"})		
    aadd(aCabD1,{"F1_DESPESA"   	,0})				
    aadd(aCabD1,{"E2_NATUREZ"		,"32101002  "})		
    
    For nItens := 1 to len(aItemD1)
        If aItemD1[nItens,10] == aCabec[nCont,02] .And. aItemD1[nItens,11] == aCabec[nCont,03]
            Aadd(aItens,aItemD1[nItens])
        else
            exit
        EndIf  
    Next nCont 

    If len(aItens) > 0
        For nX := 1 To len(aItens)
            aLinha := {}			
            aadd(aLinha,{"D1_DOC"  	    ,cDoc    									,Nil})
            aadd(aLinha,{"D1_ITEM"      ,STRZERO(nX,3) 								,NIL})
            aadd(aLinha,{"D1_COD"  	    ,aItens[nX,02]								,Nil})			
            aadd(aLinha,{"D1_QUANT"	    ,aItens[nX,04]	    						,Nil})			
            aadd(aLinha,{"D1_VUNIT"	    ,aItens[nX,05]  							,Nil})			
            aadd(aLinha,{"D1_TOTAL"	    ,ROUND(aItens[nX,04] * aItens[nX,05],2)     ,Nil})			
            aadd(aLinha,{"D1_NFORI"     ,aItens[nX,07]								,Nil})			
            aadd(aLinha,{"D1_SERIORI"  	,aItens[nX,08]								,Nil})			
            aadd(aLinha,{"D1_ITEMORI"  	,aItens[nX,09]								,Nil})	
            //aadd(aLinha,{"D1_LOCAL"  	,aItens[nX,06]								,Nil})		
            //aadd(aLinha,{"D1_TES"	,"159"										,Nil})   
            aadd(aIteNF,aLinha)		

            _aItem:={{"D3_COD"      ,aItens[nX,02]      ,NIL},;
                    {"D3_UM"        ,Posicione("SB1",1,xFilial("SB1")+aItens[nX,02],"B1_UM")         ,NIL},;
                    {"D3_QUANT"     ,aItens[nX,04]      ,NIL},;
                    {"D3_LOCAL"     ,aItens[nX,06]      ,NIL},;
                    {"D3_LOTECTL"   ,""                 ,NIL},;
                    {"D3_LOCALIZ"   , ""                ,NIL}}

			aadd(_atotitem,_aitem)
    
        Next nX

        lMsErroAuto := .F.
        MSExecAuto({|x,y,z| mata103(x,y,z)},aCabD1,aIteNF,3)		

        If lMsErroAuto
            MOSTRAERRO()
        Else 
            //Gerapv(aItens,SF1->F1_DOC)	
            //Nao vai gerar pedido mais, a saida sera via movimentação interna
            _aCab1 := {{"D3_DOC" ,SF1->F1_DOC, NIL},;
                        {"D3_TM" ,cTM , NIL},;
                        {"D3_CC" ,"        ", NIL},;
                        {"D3_EMISSAO" ,ddatabase, NIL}}
            
            If len(_aCab1) > 0 .And. Len(_atotitem) > 0
                MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)
                
                If lMsErroAuto
                    Mostraerro()
                    DisarmTransaction()
                    break
                EndIf
            EndIf 

	    EndIf
    EndIf

Next nCont

RestArea(aArea)

Return

/*/{Protheus.doc} Gerapv
    (long_description)
    @type  Static Function
    @author user
    @since 22/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Gerapv(aItens,cDodEnt)

Local aCabec    := {}
Local aItC6     := {}
Local nCont
Local cCliente  :=  '24575331 '
Local cLoja     :=  '0001'
Local cItem     :=  '01'

Private lMsErroAuto := .F.

aAdd( aCabec , { "C5_FILIAL"    , cFilant 		        , Nil } ) 
aAdd( aCabec , { "C5_TIPO"      , 'N'                   , Nil } )
aAdd( aCabec , { "C5_CLIENTE"   , cCliente              , Nil } )
aAdd( aCabec , { "C5_LOJACLI"   , cLoja                 , Nil } )
aAdd( aCabec , { "C5_XTPPED"    , 'A'                   , Nil } )
Aadd( aCabec , { "C5_MENNOTA"   , 'Faturamento estoque PV', Nil } )
aAdd( aCabec , { "C5_CONDPAG"   , '001'                 , Nil } )    
aAdd( aCabec , { "C5_NATUREZ"   , "31101001  "          , Nil } )    
//aAdd( aCabec , { "C5_XCONTRT"	, AAM->AAM_CONTRT   	, Nil })

For nCont := 1 to len(aItens)    
    aLinha := {}
    aAdd( aLinha , { "C6_FILIAL"     , cFilant		                          , Nil })
    aAdd( aLinha , { "C6_ITEM"       , cItem  							      , Nil })
    aAdd( aLinha , { "C6_PRODUTO"    , aItens[nCont,02]                       , Nil })
    aAdd( aLinha , { "C6_QTDVEN"     , aItens[nCont,04]                       , Nil })
    aAdd( aLinha , { "C6_PRCVEN"     , aItens[nCont,05]                       , Nil })
    aAdd( aLinha , { "C6_QTDLIB"     , aItens[nCont,04]    	                  , Nil })
	aAdd( aLinha , { "C6_TES" 	     , '537'        						  , Nil })

    aAdd( aItC6 , aLinha )

    cItem := Soma1(cItem)
Next nCont

lMsErroAuto := .F.

MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItC6,3)
    
IF lMsErroAuto  
    MostraErro()
ELSE
    MsgAlert("Pedido "+SC5->C5_NUM+CRLF+"Nota "+cDodEnt)
    Reclock("SC5",.F.)
    SC5->C5_XTPPED := 'Z'
    SC5->(Msunlock())
Endif 

Return
