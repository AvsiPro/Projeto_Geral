#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ JCAGFR01  ³ Autor ³ Alexandre Venâncio ³ Data ³ 08/09/2023 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  Tela de Campanha X Veículos com geração de OS             ³±±
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

User Function JCAGFR01

Local cCampan := space(6)

Private oDlg1,oGrp1,oSay1,oSay2,oGet1,oGrp2,oBrw1,oBtn1,oBtn2,oBtn3,oBtn4,oList1 
Private aList1 := {}
PRIVATE oOk        :=    LoadBitmap(GetResources(),'br_verde')  //Controla se o pedido foi alterado ou nao no grid.
PRIVATE oNo        :=    LoadBitmap(GetResources(),'br_vermelho')


IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
ENDIF

Aadd(aList1,{.F.,'','','','','','','',''})

oDlg1      := MSDialog():New( 092,232,586,1221,"Campanha X Veículos",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,008,032,476,"Campanha",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        oSay1      := TSay():New( 016,024,{||"Código Campanha"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
        oGet1      := TGet():New( 015,075,{|c| If(Pcount()>0,cCampan:=c,cCampan)},oGrp1,060,008,'@!',{|| Busca()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZPP","",,)
        
        oSay2      := TSay():New( 016,148,{||"oSay2"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,320,008)

    oGrp2      := TGroup():New( 036,008,212,480,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //    oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{044,012,208,476},,, oGrp2 ) 
        oList1 	   := TCBrowse():New(044,012,465,165,, {'Sel','Filial','Veículo','Ano','Chassi','Num. OS','Data Ini. OS','Data Fim OS'},;
                                    {20,150,40,60,40,40,40,40},;
									oGrp2,,,,{|| /*FHelp(oList:nAt)*/},{|| editcol(oList1:nAt)},,,,,,,.F.,,.T.,,.F.,,,)
        oList1:SetArray(aList1)
        oList1:bLine := {||{ IF(aList1[oList1:nAt,01],oOk,oNo),;
                             aList1[oList1:nAt,02],; 
                             aList1[oList1:nAt,03],;
                             aList1[oList1:nAt,04],;
                             aList1[oList1:nAt,05],; 
                             aList1[oList1:nAt,06],;
                             aList1[oList1:nAt,07],; 
                             aList1[oList1:nAt,08]}}

    oBtn1      := TButton():New( 218,068,"Associa Veículo",oDlg1,,047,012,,,,.T.,,"",,,,.F. ) //88
    oBtn5      := TButton():New( 218,130,"Remover Veículo",oDlg1,,047,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 218,192,"Gerar OS",oDlg1,,047,012,,,,.T.,,"",,,,.F. ) //174
    oBtn3      := TButton():New( 218,254,"Relatório",oDlg1,,047,012,,,,.T.,,"",,,,.F. ) //256
    oBtn4      := TButton():New( 218,316,"Sair",oDlg1,{||oDlg1:end()},047,012,,,,.T.,,"",,,,.F. ) //344

oDlg1:Activate(,,,.T.)

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 08/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca(cCampanha)

Local aArea     :=  GetArea()
Local cQuery 

aList1 := {}

oSay2:settext(ZPP->ZPP_DESCRI)

cQuery := "SELECT T9_CODBEM,T9_PLACA,T9_ANOMOD,T9_ANOFAB,T9_CHASSI,T9_ZFILORI"
cQuery += " FROM "+RetSQLName("ST9")+" T9"
cQuery += " WHERE T9.D_E_L_E_T_=' '"
cQuery += " AND T9_PLACA <>' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF() 
//'Sel','Filial','Veículo','Ano','Chassi','Num. OS','Data Ini. OS','Data Fim OS'
//      T9_CODBEM,T9_PLACA,T9_ANOMOD,T9_ANOFAB,T9_CHASSI,T9_ZFILORI
    Aadd(aList1,{   .F.,;
                    TRB->T9_ZFILORI+If(!Empty(TRB->T9_ZFILORI)," - "+FWFilialName('01',TRB->T9_ZFILORI),''),;
                    TRB->T9_PLACA,;
                    TRB->T9_ANOMOD+"/"+T9_ANOFAB,;
                    TRB->T9_CHASSI,;
                    "",;
                    CTOD(" / / "),;
                    CTOD(" / / "),;
                    TRB->T9_CODBEM})
    Dbskip()
EndDo 

If len(aList1) < 1
    Aadd(aList1,{.F.,'','','','','','','',''})
EndIf 

oList1:SetArray(aList1)
oList1:bLine := {||{ IF(aList1[oList1:nAt,01],oOk,oNo),;
                        aList1[oList1:nAt,02],; 
                        aList1[oList1:nAt,03],;
                        aList1[oList1:nAt,04],;
                        aList1[oList1:nAt,05],; 
                        aList1[oList1:nAt,06],;
                        aList1[oList1:nAt,07],; 
                        aList1[oList1:nAt,08]}}

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} editcol
    (long_description)
    @type  Static Function
    @author user
    @since 08/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editcol(nLinha)

Local aArea := GetArea()

If !Empty(aList1[nLinha,02])
    If aList1[nLinha,01]
        aList1[nLinha,01] := .F.
    Else 
        aList1[nLinha,01] := .T.
    EndIf 
EndIf 

oList1:refresh()
oDlg1:refresh()

RestArea(aAreA)

Return
