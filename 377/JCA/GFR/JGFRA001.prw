#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"


/*
    Campanha – Desenvolvimento do Cadastro de campanha
    MIT 44_Frotas GFR0010, GFR0012 Campanha_Desenvolvimento do Cadastro de campanha

    DOC MIT
    https://docs.google.com/document/d/1qvdxNSSNnZY8UKejDBjbIECIhlhng81j/edit
    DOC Entrega
    https://docs.google.com/document/d/1AGjIbZXbvj9FcdANT7qEdpCmvUNEwDpu/edit

*/

User Function JGFRA001()

Local oBrowse := FwLoadBrw("JGFRA001")
    
//oBrowse:AddLegend( "ZPR->ZPR_MSBLQL = '2'", "GREEN", "Não bloqueado" )
//oBrowse:AddLegend( "ZPR->ZPR_MSBLQL = '1'", "RED",   "Bloqueado" )

oBrowse:Activate()

Return (NIL)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do Browse                                            |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function BrowseDef()

Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("ZPR")
    oBrowse:SetDescription("Cadastro de Campanha x Veiculos")

   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("JGFRA001")
   

Return (oBrowse)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do menu DEF                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function MenuDef()

Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JGFRA001' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_ZPRLeg5'         OPERATION 6                      ACCESS 0 //OPERATION X
    //ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.JGFRA001' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'U_JcaCmxVe(1)' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'U_JcaCmxVe(2)' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.JGFRA001' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação da regra de negócio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("ZPRCMV")
Local oStruSC5 := FwFormStruct(1, "ZPR")

    
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("ZPRMASTER", NIL, oStruSC5)
    //oModel:AddGrid("Z30DETAIL", "ZPRMASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "ZPR_FILIAL", "ZPR_CODIGO" } )

    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Campanha x Veiculos")

    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("ZPRMASTER"):SetDescription("Cabeçalho")
    
Return (oModel)


/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação // INTERFACE GRÁFICA                                 |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

Local oView    := FwFormView():New()
Local oStruSC5 := FwFormStruct(2, "ZPR")

Local oModel   := FwLoadModel("JGFRA001")

    // REMOVE CAMPOS DA EXIBIÇÃO
    //oStruSC5:RemoveField("ZPR_FILIAL")
        
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "ZPRMASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    //oView:AddGrid("VIEW_SC6", oStruSC6, "Z30DETAIL")
    
    //oView:AddIncrementField( 'VIEW_SC6', 'ZY1_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 100)
    //oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    //oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS TÍTULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SC5")
    //oView:EnableTitleView("VIEW_SC6", "REPRESENTANTES", RGB(224, 30, 43))
    
Return (oView)

USER FUNCTION ZPRLeg5()

    LOCAL aLegenda    :=    {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",        "Não Bloqueado"  })
    AADD(aLegenda,{"BR_VERMELHO",    "Bloqueado"})
     
    BrwLegenda(cTitulo, "Status", aLegenda)
RETURN

/*/{Protheus.doc} Static Function Criação de amarraçao de campanha x veiculos
    (long_description)
    @type  Function
    @author user
    @since 19/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function JcaCmxVe(nOpc)

Private cCampanha := space(6)

Private oDlg1,oGrp1,oSay1,oSay2,oGet1,oGrp2,oBrw1,oBtn1,oBtn2,oBtn3,oBtn4

PRIVATE oOk        :=    LoadBitmap(GetResources(),'br_verde')  //Controla se o pedido foi alterado ou nao no grid.
PRIVATE oNo        :=    LoadBitmap(GetResources(),'br_vermelho')

Private aList1  :=  {}
Private oList1
Private aHeader1    :=  {}

Default nOpc := 2

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

If nOpc == 1
    Aadd(aList1,{.F.,'','','','','','','','',0,'','','',''})
Else 
    cCampanha := ZPR->ZPR_CODIGO
EndIf

oDlg1      := MSDialog():New( 092,232,596,1360,"Campanha x Veiculos",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,092,036,476,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        oSay1      := TSay():New( 016,108,{||"Campanha"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet1      := TGet():New( 016,148,{|c| If(Pcount()>0,cCampanha:=c,cCampanha)},oGrp1,060,008,'',{||If(!Empty(cCampanha),Processa({|| busca()},"Aguarde"),)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZPP","",,)
        oSay2      := TSay():New( 016,224,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,244,008)
        
        If nOpc == 2
            oGet1:disable()
        EndIf

    oGrp2      := TGroup():New( 040,008,216,548,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{048,012,212,544},,, oGrp2 ) 
        oList1    := TCBrowse():New(048,012,532,165,, {'','Filial','Veículo','Placa','Ano','Chassi','Familia','Modelo','Data Assoc.','Filial Ab.','Num. OS','Data Ini. OS','Data Fim Os'},;
                                        {10,40,50,40,70,40,40,40,40,40,40,40},;
                                        oGrp2,,,,{|| /*FHelp(oList1:nAt)*/},{|| editcol(oList1:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList1:SetArray(aList1)
        oList1:bLine := {||{IF(aList1[oList1:nAt,01],oOk,oNo),; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04],;
                            aList1[oList1:nAt,05],;
                            aList1[oList1:nAt,06],;
                            aList1[oList1:nAt,11],;
                            aList1[oList1:nAt,12],;
                            aList1[oList1:nAt,13],;
                            aList1[oList1:nAt,14],;
                            aList1[oList1:nAt,07],;
                            aList1[oList1:nAt,08],;
                            aList1[oList1:nAt,09]}}

    oBtn1      := TButton():New( 218,068,"Associa Veículo",oDlg1,{|| veiculos()},047,012,,,,.T.,,"",,,,.F. ) //88
    oBtn5      := TButton():New( 218,130,"Remover Veículo",oDlg1,{|| removbem()},047,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 218,192,"Gerar OS",oDlg1,{|| Processa({|| geraros()},"Aguarde")},047,012,,,,.T.,,"",,,,.F. ) //174
    oBtn6      := TButton():New( 218,254,"Gravar",oDlg1,{||Processa({|| gravaros()},"Aguarde")},047,012,,,,.T.,,"",,,,.F. ) //344
    oBtn3      := TButton():New( 218,316,"Relatório",oDlg1,{||Processa({|| GeraPlan()},"Aguarde") },047,012,,,,.T.,,"",,,,.F. ) //256
    oBtn4      := TButton():New( 218,378,"Sair",oDlg1,{||oDlg1:end()},047,012,,,,.T.,,"",,,,.F. ) //344

    oBtn1:disable()
    oBtn2:disable()
    //oBtn3:disable()
    
    If nOpc == 2
        Busca()
    ENDIF

oDlg1:Activate(,,,.T.)

Return

/*/{Protheus.doc} Busca
    (long_description)
    @type  Static Function
    @author user
    @since 19/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca()

Local cQuery 

cQuery := "SELECT ZPP_CODIGO,ZPP_DESCRI,ZPR_ANO,ZPR_CHASSI,ZPR.R_E_C_N_O_ AS RECZPR,"
cQuery += " ZPR_FILIAL,ZPR_CODIGO,ZPR_CODBEM,ZPR_PLACA,ZPR_NUMOS,ZPR_DTINI,ZPR_DTFIM" 
cQuery += " FROM "+RetSQLName("ZPP")+" ZPP"
cQuery += " LEFT JOIN "+RetSQLName("ZPR")+" ZPR ON ZPR_CODIGO=ZPP_CODIGO AND ZPR.D_E_L_E_T_=' '"
cQuery += " WHERE ZPP.D_E_L_E_T_=' '"
cQuery += " AND ZPP_CODIGO='"+cCampanha+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

oSay2:settext("")
oSay2:settext(TRB->ZPP_DESCRI)
If !Empty(TRB->ZPP_DESCRI)
    oBtn1:enable()
    oBtn2:enable()
EndIf

WHILE !EOF() 
    If TRB->RECZPR > 0
        Aadd(aList1,{   .F.,;
                        TRB->ZPR_FILIAL,;
                        TRB->ZPR_CODBEM,;
                        TRB->ZPR_PLACA,;
                        TRB->ZPR_ANO,;
                        TRB->ZPR_CHASSI,;
                        TRB->ZPR_NUMOS,;
                        stod(TRB->ZPR_DTINI),;
                        stod(TRB->ZPR_DTFIM),;
                        TRB->RECZPR,;
                        '',;
                        '',;
                        '',;
                        ''})
    endif
    Dbskip()
EndDo 

                
If len(aList1) < 1
     Aadd(aList1,{.F.,'','','','','','','','',0,'','','',''})
EndIf



Return

/*/{Protheus.doc} gravaros()
    Gravar registros sem gerar os
    @type  Static Function
    @author user
    @since 11/07/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gravaros()

Local nX 

For nX := 1 to len(aList1)
    If aList1[nX,01]
        If Empty(aList1[nX,07])
            aAux  :=  {}

            DbselectArEA("ZPR")
            DbSetOrder(1)
            If Dbseek(cfilant+cCampanha+aList1[nX,03])
                Reclock("ZPR",.F.)
            Else
                Reclock("ZPR",.T.)
            EndIF 
            ZPR->ZPR_FILIAL := cfilant
            ZPR->ZPR_CODIGO := cCampanha
            ZPR->ZPR_CODBEM := aList1[nX,03]
            ZPR->ZPR_PLACA  := aList1[nX,04]
            ZPR->ZPR_ANO    := aList1[nX,05]
            ZPR->ZPR_CHASSI := aList1[nX,06]
            ZPR->ZPR_FAMILI := aList1[nX,15]
            nRecno := ZPR->(Recno())
            ZPR->(Msunlock())
            aList1[nX,10] := nRecno
        EndIF 
    EndIf 
Next nX 
    
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


/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 19/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function associar()

Local aPergs    :=  {}
Local aRet      :=  {}
Local cVeiculo  :=  space(16)
Local nPos      :=  0

If Empty(aList1[1,2])
    aList1 := {}
EndIF 

aAdd(aPergs, {1, "Veículo",  cVeiculo,  "", ".T.", "ST9", ".T.", 80,  .F.})

If ParamBox(aPergs, "Informe o código da Marca a ser gerada para o produto",aRet)
    cVeiculo := aRet[1]
    nPos := Ascan(aList1,{|x| Alltrim(x[3]) == Alltrim(cVeiculo)})

    If nPos == 0
        DbSelectArea("ST9")
        DbSetOrder(1)
        If Dbseek(xFilial("ST9")+cVeiculo)
            If MsgYesNo("Confirma a inclusão do bem "+cVeiculo+" nesta campanha?")
                //'','Filial','Veículo','Ano','Chassi','Num. OS','Data Ini. OS','Data Fim Os'
            
                Aadd(aList1,{   .F.,;
                                cfilant,;
                                Alltrim(cVeiculo),;
                                ST9->T9_PLACA,;
                                ST9->T9_ANOMOD,;
                                ST9->T9_CHASSI,;
                                '',;
                                '',;
                                '',;
                                0,;
                                Posicione("ST6",1,xFilial("ST6")+ST9->T9_CODFAMI,"T6_NOME"),;
                                Posicione("TQR",1,xFilial("TQR")+ST9->T9_TIPMOD,"TQR_DESMOD"),;
                                '',;
                                '',;
                                ST9->T9_CODFAMI,;
                                ST9->T9_TIPMOD})
                
                Reclock("ZPR",.T.)
                ZPR->ZPR_FILIAL := cfilant
                ZPR->ZPR_CODIGO := cCampanha
                ZPR->ZPR_CODBEM := cVeiculo
                ZPR->ZPR_PLACA  := ST9->T9_PLACA
                ZPR->ZPR_ANO    := ST9->T9_ANOMOD
                ZPR->ZPR_CHASSI := ST9->T9_CHASSI
                nRecno := ZPR->(Recno())
                ZPR->(Msunlock())
                aList1[len(alist1),10] := nRecno                
            Else     
                Aadd(aList1,{.F.,'','','','','','','','',0,'','','','','',''})                
            EndIf 
        Else 
            Aadd(aList1,{.F.,'','','','','','','','',0,'','','','','',''})
            MsgAlert("Veículo não encontrado na base, verifique!!!")
        EndIf
    Else 
        MsgAlert("Veículo já cadastrado nesta campanha")
        oList1:nAt := nPos

    EndIf 
EndIf 

oList1:SetArray(aList1)
oList1:bLine := {||{IF(aList1[oList1:nAt,01],oOk,oNo),; 
                    aList1[oList1:nAt,02],;
                    aList1[oList1:nAt,03],;
                    aList1[oList1:nAt,04],;
                    aList1[oList1:nAt,05],;
                    aList1[oList1:nAt,06],;
                    aList1[oList1:nAt,11],;
                    aList1[oList1:nAt,12],;
                    aList1[oList1:nAt,13],;
                    aList1[oList1:nAt,14],;
                    aList1[oList1:nAt,07],;
                    aList1[oList1:nAt,08],;
                    aList1[oList1:nAt,09]}}

oList1:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} geraros
    (long_description)
    @type  Static Function
    @author user
    @since 19/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function geraros()

Local aArea :=  GetArea()
Local nCont :=  0
Local nX    :=  0
Private aAux  :=  {}

For nX := 1 to len(aList1)
    If aList1[nX,01]
        If Empty(aList1[nX,07])
            aAux  :=  {}

            DbselectArEA("ZPR")
            DbSetOrder(1)
            If Dbseek(cfilant+cCampanha+aList1[nX,03])
                Reclock("ZPR",.F.)
            Else
                Reclock("ZPR",.T.)
            EndIF 
            ZPR->ZPR_FILIAL := cfilant
            ZPR->ZPR_CODIGO := cCampanha
            ZPR->ZPR_CODBEM := aList1[nX,03]
            ZPR->ZPR_PLACA  := aList1[nX,04]
            ZPR->ZPR_ANO    := aList1[nX,05]
            ZPR->ZPR_CHASSI := aList1[nX,06]
            nRecno := ZPR->(Recno())
            ZPR->(Msunlock())
            aList1[nX,10] := nRecno
            
            DbSelectArea("ZPQ")
            DbSetOrder(1)
            If Dbseek(xFilial("ZPQ")+cCampanha)
                While !EOF() .AND. ZPQ->ZPQ_CODIGO == cCampanha 
                    Aadd(aAux,{ZPQ->ZPQ_PRODUT,;
                                Posicione("SB1",1,xFilial("SB1")+ZPQ->ZPQ_PRODUT,"B1_UM"),;
                                Posicione("SB1",1,xFilial("SB1")+ZPQ->ZPQ_PRODUT,"B1_LOCPAD"),;
                                ZPQ->ZPQ_QUANT,;
                                ZPQ->ZPQ_ITEM,;
                                '',;
                                ''})
                    Dbskip()
                EndDo 
            EndIf 
            
            cOrdem  := GETSXENUM("STJ","TJ_ORDEM")
            ConfirmSx8()
            cPlano  := SuperGetmv("TI_TJPLANO",.F.,"000000")
            cTipOs  := SuperGetmv("TI_TJTIPOS",.F.,"B")
            cCodBem := aList1[nX,03]
            cServico:= SuperGetmv("TI_TJSERVI",.F.,"C00001")
            //SEQRELA
            cTipo   := SuperGetmv("TI_TJTIPO" ,.F.,"C01")
            cCodAre := SuperGetmv("TI_CODAREA",.F.,"000003")
            cCntCust:= Posicione("ST9",1,xFilial("ST9")+cCodBem,"T9_CCUSTO")
            cContado:= Posicione("ST9",1,xFilial("ST9")+cCodBem,"T9_POSCONT")

            If gerasa(cCodBem,cOrdem)
                
                Reclock("STJ",.T.)
                STJ->TJ_FILIAL  :=  CFILANT
                STJ->TJ_ORDEM   :=  cOrdem
                STJ->TJ_PLANO   :=  cPlano
                STJ->TJ_DTORIGI :=  DDATABASE
                STJ->TJ_TIPOOS  :=  cTipOs
                STJ->TJ_CODBEM  :=  cCodBem
                STJ->TJ_SERVICO :=  cServico
                STJ->TJ_SEQRELA :=  '0'
                STJ->TJ_TIPO    :=  cTipo
                STJ->TJ_CODAREA :=  cCodAre
                STJ->TJ_POSCONT :=  cContado
                STJ->TJ_HORACO1 :=  cvaltochar(Time())
                STJ->TJ_DTMPINI :=  DDATABASE
                STJ->TJ_HOMPINI :=  cvaltochar(Time())
                STJ->TJ_DTMPFIM :=  DDATABASE
                STJ->TJ_HOMPFIM :=  cvaltochar(Time())
                STJ->TJ_USUARIO :=  CUSERNAME
                STJ->TJ_PRIORID :=  'ZZZ'
                STJ->TJ_TERMINO :=  'N'
                STJ->TJ_XSITUAC :=  '2'
                STJ->TJ_TERCEIR :=  '1'
                STJ->TJ_CONTINI :=  cContado
                STJ->TJ_USUAINI :=  CUSERNAME
                STJ->TJ_FATURA  :=  '2'
                STJ->TJ_APROPRI :=  '2'
                STJ->(MSUNLOCK())

                

                For nCont := 1 to len(aAux)
                    RECLOCK( "STL", .T. )
                    STL->TL_FILIAL  :=  cfilant
                    STL->TL_ORDEM   :=  cOrdem
                    STL->TL_PLANO   :=  cPlano
                    STL->TL_SEQRELA :=  '0'
                    STL->TL_TAREFA  :=  '0'
                    STL->TL_TIPOREG :=  'P'
                    STL->TL_CODIGO  :=  aAux[nCont,01]
                    STL->TL_USACALE :=  'N'
                    STL->TL_QUANTID :=  aAux[nCont,04]
                    STL->TL_UNIDADE :=  aAux[nCont,02]
                    STL->TL_CUSTO   :=  Posicione("SB2",1,cfilant+aAux[nCont,01],"B2_CM1")
                    STL->TL_DESTINO :=  'T'
                    STL->TL_DTINICI :=  ddatabase
                    STL->TL_HOINICI :=  cvaltochar(Time())
                    STL->TL_DTFIM   :=  DDATABASE
                    STL->TL_HOFIM   :=  cvaltochar(Time())
                    STL->TL_LOCAL   :=  aAux[nCont,03]
                    STL->TL_TIPOHOR :=  'D'
                    STL->TL_NUMSA   :=  aAux[nCont,06]
                    STL->TL_ITEMSA  :=  aAux[nCont,07]
                    STL->TL_SEQTARE :=  aAux[nCont,05]
                    STL->(MSUNLOCK())
                Next nCont

                aList1[nX,07] := cOrdem
                aList1[nX,08] := ddatabase
                DbSelectarea("ZPR")
                DbGoto(aList1[nX,10])
                Reclock("ZPR",.F.)
                ZPR->ZPR_NUMOS := cOrdem
                ZPR->ZPR_DTINI := ddatabase
                ZPR->(MSUNLOCK())
            EndIf 

            oList1:refresh()
            oDlg1:refresh()
        else
            MsgAlert("OS já criada para o bem")
        EndIf 
    EndIf
Next nX

RestArea(aArea)

Return

/*/{Protheus.doc} gerasa
    (long_description)
    @type  Static Function
    @author user
    @since 20/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gerasa(cbem,cNumos)

Local aArea     :=  GetArea()
Local aCabec    :=  {}
Local aItens    :=  {}
Local nX 
Local lRet      :=  .T.
Local nOpcx     :=  3

Local cNumero   := GetSx8Num( 'SCP', 'CP_NUM' )

While SCP->( dbSeek( xFilial( 'SCP' ) + cNumero ) )
    ConfirmSx8()
    cNumero := GetSx8Num('SCP', 'CP_NUM')
EndDo

Aadd( aCabec, { "CP_NUM"     ,cNumero   , Nil })
Aadd( aCabec, { "CP_EMISSAO" ,dDataBase , Nil })

For nX := 1 to len(aAux)
    Aadd( aItens, {} )
    Aadd( aItens[ Len( aItens ) ],{"CP_ITEM"    ,Strzero(nX,2)                      , Nil } )
    Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,aAux[nX,01]                        , Nil } )
    Aadd( aItens[ Len( aItens ) ],{"CP_QUANT"   ,aAux[nX,04]                        , Nil } )
    Aadd( aItens[ Len( aItens ) ],{"CP_NUMOS"   ,cNumos                             , Nil } )
    Aadd( aItens[ Len( aItens ) ],{"CP_LOCAL"   ,aAux[nX,03]                        , Nil } )
    Aadd( aItens[ Len( aItens ) ],{"CP_OBS"     ,cbem                               , Nil } )
    Aadd( aItens[ Len( aItens ) ],{"CP_UM"      ,aAux[nX,02]                        , Nil } )
    //Aadd( aItens[ Len( aItens ) ],{"CP_OP"      ,Alltrim(cNumos)+"OS"+aAux[nX,05]   , Nil } )
    
 
    aAux[nX,06] := cNumero
    aAux[nX,07] := Strzero(nX,2)
Next nX 

If len(aItens) > 0
    
    lMsErroAuto := .F.
    MsExecAuto( { | x, y, z | Mata105( x, y , z ) }, aCabec, aItens , nOpcx )

    If lMsErroAuto
        Mostraerro()
        lRet := .F.
    Else 
        lRet := .T.
    EndIf 
EndIf 

RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} removbem
    (long_description)
    @type  Static Function
    @author user
    @since 21/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function removbem()

Local nX        := 1
Local aAreaTL   :=  {}
Local lNegar    :=  .F.
Local nTam      := len(aList1)

If MsgNoYes("Deseja remover todos?")
    For nX := 1 to len(aList1)
        If aList1[nX,01]
            DbSelectArea("STL")
            DbSetOrder(1)
            If Dbseek(aList1[nX,02]+aList1[nX,07])
                While !EOF() .And. STL->TL_FILIAL == aList1[nX,02] .AND. STL->TL_ORDEM == aList1[nX,07]
                    aAreaTL := GetArea()
                    DbSelectArea("SCP")
                    DbSetOrder(1)
                    If Dbseek(aList1[nX,02]+STL->TL_NUMSA+STL->TL_ITEMSA)
                        If SCP->CP_PREREQU == "S"
                            lNegar := .T.
                            exit
                        EndIf
                    EndIf
                    RestArea(aAreaTL)
                    DbSkip()
                EndDo
            EndIf
            
            If !lNegar
                aList1[nX,02] := strtran(aList1[nX,02],"0","X")
            EndIf
        EndIf 
    Next nX 
Else 
    DbSelectArea("STL")
    DbSetOrder(1)
    If Dbseek(aList1[oList1:nAt,02]+aList1[oList1:nAt,07])
        While !EOF() .And. STL->TL_FILIAL == aList1[oList1:nAt,02] .AND. STL->TL_ORDEM == aList1[oList1:nAt,07]
            aAreaTL := GetArea()
            DbSelectArea("SCP")
            DbSetOrder(1)
            If Dbseek(aList1[oList1:nAt,02]+STL->TL_NUMSA+STL->TL_ITEMSA)
                If SCP->CP_PREREQU == "S"
                    lNegar := .T.
                    exit
                EndIf
            EndIf
            RestArea(aAreaTL)
            DbSkip()
        EndDo
    EndIf
    
    If !lNegar
        aList1[oList1:nAt,02] := strtran(aList1[oList1:nAt,02],"0","X")
    EndIf
endIf 

nX := 1

While nTam >= nX .and. len(aList1) >= nX
    If "X" $ aList1[nX,02]
        Adel(aList1,nX)
        Asize(aList1,len(aList1)-1)
    Else  
        nX++
    ENDIF
    
ENDDO

If len(aList1) < 1
     Aadd(aList1,{.F.,'','','','','','','','',0,'','','','','',''})
EndIf



oList1:SetArray(aList1)
oList1:bLine := {||{IF(aList1[oList1:nAt,01],oOk,oNo),; 
                    aList1[oList1:nAt,02],;
                    aList1[oList1:nAt,03],;
                    aList1[oList1:nAt,04],;
                    aList1[oList1:nAt,05],;
                    aList1[oList1:nAt,06],;
                    aList1[oList1:nAt,11],;
                    aList1[oList1:nAt,12],;
                    aList1[oList1:nAt,13],;
                    aList1[oList1:nAt,14],;
                    aList1[oList1:nAt,07],;
                    aList1[oList1:nAt,08],;
                    aList1[oList1:nAt,09]}}

oList1:refresh()
oDlg1:refresh()

Return


/*/{Protheus.doc} veiculos
    (long_description)
    @type  Static Function
    @author user
    @since 24/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function veiculos()

Local aArea     := GetArea()
Local nOpc      :=  0
Local nX 
Local cQuery 

Private lCheck     :=   .F.
PRIVATE aVeiculos :=  {}
Private cPesquisa  :=   space(25)

PRIVATE oOk        :=    LoadBitmap(GetResources(),'br_verde')  //Controla se o pedido foi alterado ou nao no grid.
PRIVATE oNo        :=    LoadBitmap(GetResources(),'br_vermelho')
Private nPrimMrk   :=   1
Private oDlg1v,oGrp1v,oBtn1v,oBtn2v,oList1v,oSay1v,oGet1v,oBtn3v

If Empty(aList1[1,2])
    aList1 := {}
EndIf 

cQuery := "SELECT T9_CODBEM,T9_NOME,T9_PLACA,T9_ZFILORI,T9_ANOMOD,T9_CHASSI"
cQuery += " ,TQR_DESMOD,T9_CODFAMI,T6_NOME,T9_TIPMOD,T9_CODFAMI"
cQuery += " FROM "+RetSQLName("ST9")+" T9"
cQuery += " LEFT JOIN "+RetSQLName("ST6")+" T6 ON T6_FILIAL=T9_FILIAL AND T6_CODFAMI=T9_CODFAMI AND T6.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("TQR")+" TQR ON TQR_FILIAL=T9_FILIAL AND TQR_TIPMOD=T9_TIPMOD AND TQR.D_E_L_E_T_=' '"
cQuery += " WHERE T9_FILIAL='"+xFilial("ST9")+"' AND T9_CATBEM='4' AND T9.D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF()
    Aadd(aVeiculos,{.F.,;
                    TRB->T9_CODBEM,;
                    TRB->T9_NOME,;
                    TRB->T9_PLACA,;
                    TRB->T9_ZFILORI,;
                    TRB->T9_ANOMOD,;
                    TRB->T9_CHASSI,;
                    TRB->T6_NOME,;
                    TRB->TQR_DESMOD,;
                    TRB->T9_TIPMOD,;
                    TRB->T9_CODFAMI})
    Dbskip()
ENDDO

If len(aVeiculos) > 0
    oDlg1v      := MSDialog():New( 092,232,557,863,"Veiculos",,,.F.,,,,,,.T.,,,.T. )
        
        oSay1v  := TSay():New( 005,108,{||"Pesquisa"},oDlg1v,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet1v  := TGet():New( 005,148,{|c| If(Pcount()>0,cPesquisa:=c,cPesquisa)},oDlg1v,060,007,'@!',{||/*If(!Empty(cPesquisa),Processa({|| busca()},"Aguarde"),)*/},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        oGrp1v      := TGroup():New( 012,016,192,294,"Selecione",oDlg1v,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{024,024,184,236},,, oGrp1v ) 
        oList1v 	   := TCBrowse():New(024,024,260,165,, {'','Veículo','Descricao','Placa','Filial Veiculo'},;
                                    {20,50,70,50,50},;
									oGrp1v,,,,{|| /*FHelp(oList:nAt)*/},{|| editcol2(oList1v:nAt)},,,,,,,.F.,,.T.,,.F.,,,)
        oList1v:SetArray(aVeiculos)
        oList1v:bLine := {||{ IF(aVeiculos[oList1v:nAt,01],oOk,oNo),;
                                aVeiculos[oList1v:nAt,02],; 
                                aVeiculos[oList1v:nAt,03],;
                                aVeiculos[oList1v:nAt,04],; 
                                aVeiculos[oList1v:nAt,05]}}

        oCBox1     := TCheckBox():New( 200,016,"Marcar varios",{|u| If(Pcount()>0,lCheck:=u,lCheck)},oDlg1v,048,008,,{|| variaslin(oList1v:nAt) },,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
        //oCheck1 := TCheckBox():New(046,005,'Mais de um atendente?',{|u|if(PCount()>0,lSegAtend:=u,lSegAtend) },oGrp,100,210,,{|| VldAtend() },,,,,,.T.,,,)
	
        oBtn1v      := TButton():New( 200,080,"Confirmar",oDlg1v,{|x| oDlg1v:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
        oBtn2v      := TButton():New( 200,160,"Cancelar",oDlg1v,{|x| oDlg1v:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )
        
        oBtn3v  := TButton():New( 005,210,"?",oDlg1v,{|x| PesqVeic(cPesquisa,oList1v:nAt)},027,008,,,,.T.,,"",,,,.F. )
        

    oDlg1v:Activate(,,,.T.)
else
    MsgAlert("Não há veículos para atrelar")
Endif 

If nOpc == 1
    For nX := 1 to len(aVeiculos)
        If aVeiculos[nX,01]
            Aadd(aList1,{.T.,;
                        aVeiculos[nX,05],;
                        aVeiculos[nX,02],;
                        aVeiculos[nX,04],;
                        aVeiculos[nX,06],;
                        aVeiculos[nX,07],;
                        '',;
                        '',;
                        '',;
                        0,;
                        aVeiculos[nX,08],;
                        aVeiculos[nX,09],;
                        '',;
                        '',;
                        aVeiculos[nX,10],;
                        aVeiculos[nX,11]})
        endIf 
    Next nX 

    If len(aList1) < 1
        Aadd(aList1,{.F.,'','','','','','','','',0,'','','','','',''})
    EndIf 

    oList1:SetArray(aList1)
    oList1:bLine := {||{IF(aList1[oList1:nAt,01],oOk,oNo),; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04],;
                            aList1[oList1:nAt,05],;
                            aList1[oList1:nAt,06],;
                            aList1[oList1:nAt,11],;
                            aList1[oList1:nAt,12],;
                            aList1[oList1:nAt,13],;
                            aList1[oList1:nAt,14],;
                            aList1[oList1:nAt,07],;
                            aList1[oList1:nAt,08],;
                            aList1[oList1:nAt,09]}}
    oList1:refresh()
    oDlg1:refresh()
Else 
    If len(aList1) < 1
        Aadd(aList1,{.F.,'','','','','','','','',0,'','','','','',''})
    EndIf 
EndIf 

RestArea(aArea)

Return 

/*/{Protheus.doc} PesqVeic(cPesquisa)
    Pesquisa
    @type  Static Function
    @author user
    @since 11/07/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function PesqVeic(cPesquisa,nInicio)

Local aArea := GetArea()
Local nCont 
Local nX 
Local lAchou := .F.

For nCont := nInicio to len(aVeiculos)
    For nX := 2 to 9
        If Alltrim(cPesquisa) $ Alltrim(aVeiculos[nCont,nX])
            oList1v:nAt := nCont
            lAchou := .T.
            exit
        EndIF     
    Next nX 

    If lAchou
        exit 
    EndIf 

Next nCont 

oList1v:refresh()
oDlg1V:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} editcol
    (long_description)
    @type  Static Function
    @author user
    @since 24/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editcol2(nLinha)

Local nX := 1

If lCheck .And. nLinha > nPrimMrk
    For nX := nPrimMrk to nLinha
        aVeiculos[nX,01] := .T.
    Next nX 

    lCheck := .F.
    oCBox1:refresh()
Else 
    If aVeiculos[nLinha,01]
        aVeiculos[nLinha,01] := .F.
    else
        aVeiculos[nLinha,01] := .t.
    endif
EndIf 

oList1V:refresh()
oDlg1V:refresh()

Return

/*/{Protheus.doc} variaslin(oList1:nAt)
    (long_description)
    @type  Static Function
    @author user
    @since 24/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function variaslin(nLinha)

If lCheck
    nPrimMrk := nLinha
Else 
    nPrimMrk := 1
ENDIF 

Return

/*/{Protheus.doc} GeraPlan
    (long_description)
    @type  Static Function
    @author user
    @since 04/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraPlan()

Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= ""
Local cArqXls 	:= "Campanhas_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}
Local cInterno  :=  'Campanhas'

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

Aadd(aHeader1,{'',;
                'Filial',;
                'Codigo Bem',;
                'Placa',;
                'Ano',;
                'Chassis',;
                'OS',;
                'Inicio OS',;
                'Fim OS'})


oExcel:AddworkSheet(cInterno) 
oExcel:AddTable (cInterno,cInterno)

For nX := 1 to len(aHeader1[1])
    oExcel:AddColumn(cInterno,cInterno,aHeader1[1,nX],1,1)
Next nX


For nX := 1 to len(aList1)
    aAux := {}
    For nY := 1 to len(aHeader1[1])
        Aadd(aAux,aList1[nX,nY])
    Next nY

    oExcel:AddRow(cInterno,cInterno,aAux)
Next nX




oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
oExcelApp:SetVisible(.T.)        
oExcelApp:Destroy()

	
    
Return(cDir+cArqXls)
