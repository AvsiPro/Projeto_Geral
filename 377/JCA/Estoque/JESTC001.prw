#INCLUDE 'PROTHEUS.CH'

/*
    Consulta de Saldos na solicitação ao armazem por todos os itens relacionados (Pai e filhos)
    MIT 44_ESTOQUE_EST016 -Consulta saldo de produto por marca

    DOC MIT
    https://docs.google.com/document/d/1pB_-YwjYOpPWPDseS5RRQPQ-gKYjGH36/edit
    DOC Entrega
    
    
*/

User Function JESTC001(cProd,nCham)

Local cCodPai   :=  ''
Local nOpcao    :=  0
Local lFilAll   := .T.

Private aSM0Data2 := FWSM0Util():GetSM0Data()
Private nPos1     := Ascan(aSM0Data2,{|x| x[1] == "M0_CODFIL"})
Private nPos2     := Ascan(aSM0Data2,{|x| x[1] == "M0_FILIAL"})
Private nPos3     := Ascan(aSM0Data2,{|x| x[1] == "M0_NOME"})

Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oGrp2,oBtn1,oBtn2,oList

Private aList := {}

Default nCham := 1

oFont13  := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)

Default cProd := ''

If !Empty(cProd)

    cCodPai := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_XCODPAI")

    cNameFil := aSM0Data2[nPos1,02]+"-"+aSM0Data2[nPos2,02]+"/"+aSM0Data2[nPos3,02]

    If Empty(cCodPai)
        cCodPai := cProd
    EndIF 
    
    If MsgYesNo("Consultar somente a filial atual?")
        lFilAll := .F.
    EndIf 

    BuscaSld(cCodPai,lFilAll)

    If len(aList) < 1
        Aadd(aList,{'','','','','','','','','','','','','','','','',''})
    EndIf

    oDlg1      := MSDialog():New( 092,232,711,1652,"Saldos por marcas",,,.F.,,,,,,.T.,,,.T. )
        
        oGrp1      := TGroup():New( 004,004,052,708,"Produto Pai",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        oSay1      := TSay():New( 016,024,{||"Filial"},oGrp1,,oFont13,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay2      := TSay():New( 016,076,{||cNameFil},oGrp1,,oFont15n,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,568,008)
        oSay3      := TSay():New( 036,024,{||""},oGrp1,,oFont16n,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,620,008)
        
        oGrp2      := TGroup():New( 056,004,280,708,"Saldos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{064,008,276,644},,, oGrp2 ) 
        oList    := TCBrowse():New(064,008,695,210,, {'Filial','Codigo','Armazem','Qtd Disponível','Saldo Atual','Qtd. Ped.Venda','Qtd.Empenhada','Qtd.Prevista Entrada','Qtd Empenhada S.A.','Qtd.Reservada','Qt.Ter.Ns.Pd','Qtd.Ns.Pd.Ter','Saldo Pod.3','Qtd.Emp.NF','Qtd.a Endere','Qtd.Emp.Prj.','Empen.Previ'},;
                                                            {50,60,30,50,40,50,50,50,50,40,40,40,40,50,50,50,50},;
                                                            oGrp1,,,,{|| FHelp(oList:nAt)},{|| /*inverte(1)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
                oList:SetArray(aList)
                oList:bLine := {||{ aList[oList:nAt,01],;
                                    aList[oList:nAt,02],; 
                                    aList[oList:nAt,03],;
                                    aList[oList:nAt,04],;
                                    aList[oList:nAt,05],;
                                    aList[oList:nAt,06],; 
                                    aList[oList:nAt,07],;
                                    aList[oList:nAt,08],;
                                    aList[oList:nAt,09],;
                                    aList[oList:nAt,10],; 
                                    aList[oList:nAt,11],;
                                    aList[oList:nAt,12],;
                                    aList[oList:nAt,13],;
                                    aList[oList:nAt,14],; 
                                    aList[oList:nAt,15],; 
                                    aList[oList:nAt,16],;
                                    aList[oList:nAt,17]}}

        oBtn1      := TButton():New( 284,256,"Alterar",oDlg1,{|| oDlg1:end(nOpcao:=oList:nAt)},037,012,,,,.T.,,"",,,,.F. )
        oBtn2      := TButton():New( 284,352,"Sair",oDlg1,{|| oDlg1:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)

    If nOpcao > 0
        If nCham == 1
            M->CP_PRODUTO := aList[nOpcao,02]
        elseif nCham == 2
            M->C1_PRODUTO := aList[nOpcao,02]    
        ElseIf nCham == 3
            M->D3_COD     := aList[nOpcao,02]                                                           
        EndIf             
    EndIf 
EndIf

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 01/12/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaSld(cCodPai,lFilAll)

Local aArea := GetArea()
Local cQuery

cQuery := "SELECT B2_FILIAL,B2_COD,B2_LOCAL,B2_QATU,B2_QEMP,B2_QEMPN,B2_RESERVA,B2_QPEDVEN,B2_SALPEDI,"
cQuery += " B2_QTNP,B2_QNPT,B2_QTER,B2_QACLASS,B2_QEMPSA,B2_QEMPPRE,B2_QEMPPRJ"
cQuery += " FROM "+RetSQLName("SB2")
cQuery += " WHERE "

If lFilAll
    cQuery += " B2_FILIAL BETWEEN ' ' AND 'ZZZ'" 
Else 
    cQuery += " B2_FILIAL='"+xFilial("SB2")+"'" 
EndIf 

cQuery += " AND B2_COD IN(SELECT B1_COD FROM "+RetSQLName("SB1")+" WHERE B1_FILIAL='"+xFilial("SB1")+"'
cQuery += " AND (B1_COD='"+cCodPai+"' OR B1_XCODPAI='"+cCodPai+"'))
cQuery += " AND D_E_L_E_T_=' '"
cQuery += " ORDER BY B2_FILIAL,B2_COD"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("TIINCP01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")
//'Codigo','Armazem','Qtd Disponível','Saldo Atual','Qtd. Ped.Venda','Qtd.Empenhada','Qtd.Prevista Entrada','Qtd Empenhada S.A.','Qtd.Reservada','Qt.Ter.Ns.Pd','Qtd.Ns.Pd.Ter','Saldo Pod.3','Qtd.Emp.NF','Qtd.a Endere','Qtd.Emp.Prj.','Empen.Previ'

While !EOF()
    nDisponivel := TRB->B2_QATU - TRB->B2_QEMP - TRB->B2_RESERVA - TRB->B2_QACLASS - TRB->B2_QEMPSA - TRB->B2_QEMPPRJ 
    Aadd(aList,{TRB->B2_FILIAL,;
                TRB->B2_COD,;
                TRB->B2_LOCAL,;
                nDisponivel,;
                TRB->B2_QATU,;
                TRB->B2_QPEDVEN,;
                TRB->B2_QEMP,;
                TRB->B2_SALPEDI,;
                TRB->B2_QEMPSA,;
                TRB->B2_RESERVA,;
                TRB->B2_QTNP,;
                TRB->B2_QNPT,;
                TRB->B2_QTER,;
                TRB->B2_QEMPN,;
                TRB->B2_QACLASS,;
                TRB->B2_QEMPPRE,;
                TRB->B2_QEMPPRJ})
    DbSkip()
ENDDO

RestArea(aArea)
    
Return

/*/{Protheus.doc} Fhelp
nLinhadescription)
    @type  Static Function
    @author user
    @since 01/12/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Fhelp(nLinha)

Local cMarca := ''

aSM0Data2 := FWSM0Util():GetSM0Data(cempant,aList[nLinha,01])

nPos1     := Ascan(aSM0Data2,{|x| x[1] == "M0_CODFIL"})
nPos2     := Ascan(aSM0Data2,{|x| x[1] == "M0_FILIAL"})
nPos3     := Ascan(aSM0Data2,{|x| x[1] == "M0_NOME"})

cNameFil := aSM0Data2[nPos1,02]+"-"+aSM0Data2[nPos2,02]+"/"+aSM0Data2[nPos3,02]

oSay2:settext("")
oSay3:settext("")
oSay2:settext(cNameFil)

If !Empty(Posicione("SB1",1,xFilial("SB1")+aList[nLinha,02],"B1_ZMARCA"))
    cMarca := " / "+ Posicione("ZPM",1,xFilial("ZPM")+Posicione("SB1",1,xFilial("SB1")+aList[nLinha,02],"B1_ZMARCA"),"ZPM_DESC")
EndIf 


oSay3:settext(aList[nLinha,02]+"-"+Alltrim(Posicione("SB1",1,xFilial("SB1")+aList[nLinha,02],"B1_DESC"))+cMarca)

oDlg1:refresh()

Return
