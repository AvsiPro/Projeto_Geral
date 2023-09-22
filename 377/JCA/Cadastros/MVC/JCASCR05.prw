#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  06/09/2023                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function JCASCR05()

Local oBrowse := FwLoadBrw("JCASCR05")
    
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
   oBrowse:SetMenuDef("JCASCR05")
   

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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JCASCR05' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_ZPRLeg5'         OPERATION 6                      ACCESS 0 //OPERATION X
    //ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.JCASCR05' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'U_JcaCmxVe(1)' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'U_JcaCmxVe(2)' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.JCASCR05' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
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

Local oModel   := FwLoadModel("JCASCR05")

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

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oGet1","oGrp2","oBrw1","oBtn1","oBtn2","oBtn3","oBtn4")
PRIVATE oOk        :=    LoadBitmap(GetResources(),'br_verde')  //Controla se o pedido foi alterado ou nao no grid.
PRIVATE oNo        :=    LoadBitmap(GetResources(),'br_vermelho')

Private aList1  :=  {}
Private oList1

Default nOpc := 2

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

If nOpc == 1
    Aadd(aList1,{.F.,'','','','','','','','',0})
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
        oList1    := TCBrowse():New(048,012,532,165,, {'','Filial','Veículo','Placa','Ano','Chassi','Num. OS','Data Ini. OS','Data Fim Os'},;
                                        {10,40,50,40,70,40,40,40},;
                                        oGrp2,,,,{|| /*FHelp(oList1:nAt)*/},{|| editcol(oList1:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList1:SetArray(aList1)
        oList1:bLine := {||{IF(aList1[oList1:nAt,01],oOk,oNo),; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04],;
                            aList1[oList1:nAt,05],;
                            aList1[oList1:nAt,06],;
                            aList1[oList1:nAt,07],;
                            aList1[oList1:nAt,08],;
                            aList1[oList1:nAt,09]}}
/*
    oBtn1      := TButton():New( 224,120,"Associar Veiculo",oDlg1,{|| associar()},044,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 224,216,"Gerar O.S.",oDlg1,{|| geraros()},044,012,,,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( 224,308,"Relatório",oDlg1,,044,012,,,,.T.,,"",,,,.F. )
    oBtn4      := TButton():New( 224,404,"Sair",oDlg1,{||oDlg1:end()},044,012,,,,.T.,,"",,,,.F. )
*/
    oBtn1      := TButton():New( 218,068,"Associa Veículo",oDlg1,{|| associar()},047,012,,,,.T.,,"",,,,.F. ) //88
    oBtn5      := TButton():New( 218,130,"Remover Veículo",oDlg1,{|| removbem()},047,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 218,192,"Gerar OS",oDlg1,{|| Processa({|| geraros()},"Aguarde")},047,012,,,,.T.,,"",,,,.F. ) //174
    oBtn3      := TButton():New( 218,254,"Relatório",oDlg1,,047,012,,,,.T.,,"",,,,.F. ) //256
    oBtn4      := TButton():New( 218,316,"Sair",oDlg1,{||oDlg1:end()},047,012,,,,.T.,,"",,,,.F. ) //344


    oBtn1:disable()
    oBtn2:disable()
    oBtn3:disable()
    
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
    Aadd(aList1,{   .F.,;
                    TRB->ZPR_FILIAL,;
                    TRB->ZPR_CODBEM,;
                    TRB->ZPR_PLACA,;
                    TRB->ZPR_ANO,;
                    TRB->ZPR_CHASSI,;
                    TRB->ZPR_NUMOS,;
                    stod(TRB->ZPR_DTINI),;
                    stod(TRB->ZPR_DTFIM),;
                    TRB->RECZPR})
    Dbskip()
EndDo 

If len(aList1) < 1
     Aadd(aList1,{.F.,'','','','','','','','',0})
EndIf



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
                //Aadd(aList1,{'','','','','','','',''})
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
                                0})
                
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
                Aadd(aList1,{.F.,'','','','','','','','',0})                
            EndIf 
        Else 
            Aadd(aList1,{.F.,'','','','','','','','',0})
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
                STJ->TJ_SITUACA :=  'L'
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

nX := 1

While nTam <= len(aList1)
    If "X" $ aList1[nX,02]
        Adel(aList1,nX)
        Asize(aList1,len(aList1)-1)
    ENDIF
    nX++
ENDDO

If len(aList1) < 1
     Aadd(aList1,{.F.,'','','','','','','','',0})
EndIf



oList1:SetArray(aList1)
oList1:bLine := {||{IF(aList1[oList1:nAt,01],oOk,oNo),; 
                    aList1[oList1:nAt,02],;
                    aList1[oList1:nAt,03],;
                    aList1[oList1:nAt,04],;
                    aList1[oList1:nAt,05],;
                    aList1[oList1:nAt,06],;
                    aList1[oList1:nAt,07],;
                    aList1[oList1:nAt,08],;
                    aList1[oList1:nAt,09]}}

oList1:refresh()
oDlg1:refresh()

Return
