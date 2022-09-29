#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
#include "topconn.ch"
#include "fileio.ch"
#include "rwmake.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven√¢ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Cria√ß√£o do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function ROBCMS04()

Local oBrowse := FwLoadBrw("ROBCMS04")
    
oBrowse:Activate()

Return (NIL)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven√¢ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Cria√ß√£o do Browse                                            |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function BrowseDef()

Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z40")
    oBrowse:SetDescription("Rotina de c·lculo de comissıes")

    // DEFINE DE ONDE SER RETIRADO O MENUDEF
    oBrowse:SetMenuDef("ROBCMS04")
    //oBrowse:SetFilterDefault( "Z40->Z40_XCOMPE == SUBSTR(DTOS(Z40->Z40_DTFATU),5,2)+SUBSTR(DTOS(Z40->Z40_DTFATU),1,4)" )

Return (oBrowse)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven√¢ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Cria√ß√£o do menu DEF                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function MenuDef()

Local aRot := {}
     
    //Adicionando opÁıes
    ADD OPTION aRot TITLE 'Visualizar'  ACTION 'VIEWDEF.ROBCMS04' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'   ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    //ADD OPTION aRot TITLE 'Novas'     ACTION 'U_xRBMS03' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Regras'    ACTION 'VIEWDEF.ROBCMS04' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Reprocessar' ACTION 'u_xrbcm4' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'     ACTION 'VIEWDEF.ROBCMS04' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'     ACTION 'VIEWDEF.ROBCMS04' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Inclus„o'    ACTION 'VIEWDEF.ROBCMS04' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Gerar Pagto' ACTION 'Processa({|| u_xGeraTit()},"Aguarde")' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Estornar Pagto' ACTION 'Processa({|| u_xEstTit()},"Aguarde")' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'BÙnus' ACTION 'Processa({|| u_xClcBon()},"Aguarde")' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven√¢ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Cria√ß√£o da regra de neg√≥cio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("ROBCMR")
Local oStruSC5 := FwFormStruct(1, "Z40")
//Local oStruSC6 := FwFormStruct(1, "Z40")
    
    // DEFINE SE OS SUBMODELOS SER√ÉO FIELD OU GRID
    oModel:AddFields("Z40MASTER", NIL, oStruSC5)
    //oModel:AddGrid("Z40DETAIL", "Z40MASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "Z40_FILIAL", "Z40_IDCALC", "Z40_VENDED" } )

    // DEFINE A RELA√á√ÉO ENTRE OS SUBMODELOS
    //oModel:SetRelation("Z40DETAIL", {{"Z40_FILIAL", "FwXFilial('Z40')"}, {"Z40_CODIGO", "Z40_CODIGO"}}, Z40->(IndexKey(1)))

    //oStruSC6:AddTrigger("ZY1_VEND", "ZY1_NVEND",{|| .T.}, {|| POSICIONE("Z40",1,XFILIAL("Z40")+oModel:GetValue('ZY1DETAIL','ZY1_VEND'),"A3_NOME") })
    
    // DESCRI√á√ÉO DO MODELO
    oModel:SetDescription("Cadastro de Regras")

    // DESCRI√á√ÉO DOS SUBMODELOS
    oModel:GetModel("Z40MASTER"):SetDescription("CabeÁalho")
    //oModel:GetModel("Z40DETAIL"):SetDescription("Itens")
    
Return (oModel)


/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven√¢ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Cria√ß√£o // INTERFACE GR√ùFICA                                 |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

Local oView    := FwFormView():New()
Local oStruSC5 := FwFormStruct(2, "Z40")
//Local oStruSC6 := FwFormStruct(2, "Z40")
Local oModel   := FwLoadModel("ROBCMS04")

    // REMOVE CAMPOS DA EXIBI√á√ÉO
    oStruSC5:RemoveField("Z40_FILIAL")
   
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "Z40MASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    //oView:AddGrid("VIEW_SC6", oStruSC6, "Z40DETAIL")
    
    //oView:AddIncrementField( 'VIEW_SC6', 'Z40_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    //oView:CreateHorizontalBox("EMCIMA", 40)
    //oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    //oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    //oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS T√ùTULOS DAS SUBVIEWS
    //oView:EnableTitleView("VIEW_SC5")
    //oView:EnableTitleView("VIEW_SC6", "REGRAS", RGB(224, 30, 43))
    
Return (oView)

/*/{Protheus.doc} User Function xrbcm4
    (long_description)
    @type  Function
    @author user
    @since 24/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xrbcm4()

Local aArea     :=  GetArea()
Local lRet      :=  .F.
Local aRegras   :=  {}
Local aDados    :=  {}
Private _Vend1  :=  space(6)
Private _Vend2  :=  'ZZZZZZ'
Private _Band1  :=  space(6)
Private _Band2  :=  'ZZZZZZ'
Private _Prop1  :=  space(6)
Private _Prop2  :=  'ZZZZZZ'
Private _Pedi1  :=  space(6)
Private _Pedi2  :=  'ZZZZZZ'
Private _DtDe   :=  CTOD(' / / ')
Private _DtAt   :=  CTOD(' / / ')
Private aItens  :=  {}

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

Define msDialog oDlg01 From 00,00 To 390,420 Title "Comissıes" Pixel &&145
Define Font oFont1 Name "Arial" Size 0,-12 Bold

@025,007 SAY "Vendedor De : " Font oFont1 of oDlg01 Pixel
@025,120 MSGET _Vend1  SIZE 60,9 F3 "SA3" OF oDlg01 Pixel 

@040,007 SAY "Vendedor AtÈ : " Font oFont1 of oDlg01 Pixel
@040,120 MSGET _Vend2  SIZE 60,9 F3 "SA3" OF oDlg01 Pixel

@055,007 SAY "Bandeira De : " Font oFont1 of oDlg01 Pixel
@055,120 MSGET _Band1  SIZE 60,9 F3 "Z01" OF oDlg01 Pixel 

@070,007 SAY "Bandeira AtÈ : " Font oFont1 of oDlg01 Pixel
@070,120 MSGET _Band2  SIZE 60,9 F3 "Z01" OF oDlg01 Pixel

@085,007 SAY "Propriet·rio De : " Font oFont1 of oDlg01 Pixel
@085,120 MSGET _Prop1  SIZE 60,9 F3 "Z02" OF oDlg01 Pixel 

@100,007 SAY "Propriet·rio AtÈ : " Font oFont1 of oDlg01 Pixel
@100,120 MSGET _Prop2  SIZE 60,9 F3 "Z02" OF oDlg01 Pixel

@115,007 SAY "Data De : " Font oFont1 of oDlg01 Pixel
@115,120 MSGET _DtDe  SIZE 60,9 OF oDlg01 Pixel 

@130,007 SAY "Data AtÈ : " Font oFont1 of oDlg01 Pixel
@130,120 MSGET _DtAt  SIZE 60,9 OF oDlg01 Pixel

@145,007 SAY "Pedido de : " Font oFont1 of oDlg01 Pixel
@145,120 MSGET _Pedi1  SIZE 60,9 OF oDlg01 Pixel 

@160,007 SAY "Pedido AtÈ : " Font oFont1 of oDlg01 Pixel
@160,120 MSGET _Pedi2  SIZE 60,9 OF oDlg01 Pixel

@180,115 BmpButton Type 1 Action(lRet := .T.,Close(oDlg01))
@180,150 BmpButton Type 2 Action(lRet := .F.,Close(oDlg01))

Activate Dialog oDlg01 Centered

If lRet
    Processa({|| aRegras := BuscaCom()},"Buscando Regras")
    Processa({|| aDados  := BuscaDados(_Vend1,_Vend2,_DtDe,_DtAt,_Band1,_Band2,_Prop1,_Prop2,_Pedi1,_Pedi2)},"Buscando Dados")

    If len(aRegras) > 0 .And. len(aDados) > 0
        Processa({|| TelaCalc(aRegras,aDados)},"Aguarde")
    else
        MsgAlert("N„o foram encontrados registros que atendam aos par‚metros informados.")
    EndIf 
EndIf

RestArea(aArea)

Return 

/*/{Protheus.doc} BuscaCom
    (long_description)
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function BuscaCom()

Local aArea :=  GetArea()
Local aAux  :=  {}
Local cQuery

cQuery := "SELECT Z32_CODIGO,Z32_ITEM,Z32_DTINI,Z32_DTFIM,Z32_VNDQT1,Z32_VNDQT2,"
cQuery += " Z32_QTDDS1,Z32_QTDDS2,Z32_VNDVL1,Z32_VNDVL2,Z32_CONDPG,Z32_COMISS,"
cQuery += " Z32_BONUS,Z32_CLIESP,Z32_GRPESP"
cQuery += " FROM "+RetSQLName("Z32")
cQuery += " WHERE D_E_L_E_T_=' ' AND (Z32_DTFIM=' ' OR Z32_DTFIM >= '"+dtos(ddatabase)+"')"
cQuery += " AND Z32_MSBLQL<>'1' AND Z32_PGTPOR='1'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aAux,{ TRB->Z32_CODIGO,;   //01
                TRB->Z32_ITEM,;     //02
                STOD(TRB->Z32_DTINI),;    //03
                STOD(TRB->Z32_DTFIM),;    //04
                TRB->Z32_VNDQT1,;   //05
                TRB->Z32_VNDQT2,;   //06
                TRB->Z32_QTDDS1,;   //07
                TRB->Z32_QTDDS2,;   //08
                TRB->Z32_VNDVL1,;   //09
                TRB->Z32_VNDVL2,;   //10
                TRB->Z32_CONDPG,;   //11
                TRB->Z32_COMISS,;   //12
                If(TRB->Z32_BONUS=="1","Sim","Nao"),; //13
                TRB->Z32_CLIESP,;   //14
                TRB->Z32_GRPESP})   //15
    Dbskip()
EndDo

RestArea(aArea)

Return(aAux)

/*/{Protheus.doc} BuscaDados(_Vend1,_Vend2,_DtDe,_DtAt)
    (long_description)
    @type  Static Function
    @author user
    @since 24/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaDados(Vend1,Vend2,DtDe,DtAt,Band1,Band2,Prop1,Prop2,Pedi1,Pedi2)
    
Local aArea :=  GetArea()
Local aRet  :=  {}
Local cQuery:=  ""
Local cMesAn:=  substr(strtran(cvaltochar(DtAt),"/"),3)
Local cAuxM :=  " 0822" //BuscaMes(cMesAn)
/*
cQuery := "SELECT D2_ITEM,D2_COD,B1_GRUPO,BM_GRUPO,F2_VEND1,BM_XMODELO,"
cQuery += "Z03_DESGRI,D2_PEDIDO,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,"
cQuery += "C5_EMISSAO,F2_EMISSAO,"
cQuery += "F2_VALMERC,C5_CONDPAG,D2_DESC,D2_QUANT,D2_TOTAL,A3_NOME,A3_GEREN,"
cQuery += " (SELECT SUM(C6_VALOR) FROM "+RetSQLName("SC6")+" WHERE C6_FILIAL=D2_FILIAL AND C6_NUM=D2_PEDIDO  AND D_E_L_E_T_=' ') AS VALORPEDIDO"
*/
cQuery := "SELECT DISTINCT D2_ITEM,D2_COD,D2_PEDIDO,D2_DESC,D2_TOTAL, D2_QUANT,"
cQuery += " B1_GRUPO,BM_GRUPO,E1_PARCELA,"
cQuery += " F2_VEND1,F2_VEND2,F2_VEND2,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_EMISSAO,F2_VALMERC,"
cQuery += " C5_EMISSAO,C5_CONDPAG,C5_XCLASPV,"
cQuery += " ( SELECT E4_DESCRI FROM SE4010 WHERE E4_CODIGO = C5_CONDPAG ) AS DESCRIPAGTO,"
cQuery += " Z43_DESCRI,"
cQuery += " BM_XMODELO,"
cQuery += " Z03_DESGRI,Z03_CODGRI,"
cQuery += " A31.A3_NOME AS VEND1N,A31.A3_GEREN AS GEREN1N,"
cQuery += " A32.A3_NOME AS VEND2N,A32.A3_GEREN AS GEREN2N,"
cQuery += " A1_XBANDEI,Z01_DESBAN,Z01_DSCESP, Z01_CODBAN,"
cQuery += " (SELECT SUM(C6_VALOR) FROM "+RetSQLName("SC6")+" WHERE C6_FILIAL=D2_FILIAL AND C6_NUM=D2_PEDIDO  AND D_E_L_E_T_=' ') AS VALORPEDIDO"

cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D2_COD AND B1.D_E_L_E_T_= ' '"
cQuery += " INNER JOIN "+RetSQLName("SF2")+" F2 ON F2_FILIAL=D2_FILIAL AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA AND F2.D_E_L_E_T_=' '"
cQuery += "             AND F2_EMISSAO BETWEEN '"+dtos(DtDe)+"' AND '"+dtos(DtAt)+"'" 
cQuery += "             AND F2_VEND1 BETWEEN '"+Vend1+"' AND '"+Vend2+"'"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=D2_FILIAL AND C5_NUM=D2_PEDIDO AND C5_CLIENT=D2_CLIENTE AND C5_LOJACLI=D2_LOJA AND C5.D_E_L_E_T_=' ' AND C5_XCLASPV IN('1','5')"

cQuery += " AND C5_NUM BETWEEN '"+Pedi1+"' AND '"+Pedi2+"'"

cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND A1.D_E_L_E_T_=' ' "
cQuery += "    AND A1_XBANDEI BETWEEN '"+Band1+"' AND '"+Band2+"'"
cQuery += "    AND A1_XIDPROP BETWEEN '"+Prop1+"' AND '"+Prop2+"'"
cQuery += " INNER JOIN "+RetSQLName('SE1')+" E1 ON E1_FILIAL='"+xFilial("SE1")+"' AND E1_PEDIDO=D2_PEDIDO"
cQuery += " LEFT JOIN "+RetSQLName("SBM")+" BM ON BM_FILIAL='"+xFilial("SBM")+"' AND BM_GRUPO=B1_GRUPO AND BM.D_E_L_E_T_=' '" 
cQuery += "    AND BM_GRUPO <>'19' AND BM_GRUPO <>' '"
cQuery += " LEFT JOIN "+RetSQLName("Z03")+" Z3 ON Z03_FILIAL=BM_FILIAL AND Z03_CODGRI=BM_XMODELO AND Z3.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("Z31")+" Z31 ON Z31_FILIAL='"+xFilial("Z31")+"' AND Z31_CODVEN=F2_VEND1 AND Z31.D_E_L_E_T_=' '"
cQuery += "       AND RTRIM(Z31_MALA) = BM_XMODELO AND '"+cAuxM+"'='"+cMesAn+"'"
cQuery += " LEFT JOIN "+RetSQLName("SA3")+" A31 ON A31.A3_FILIAL='"+xFilial("SA3")+"' AND A31.A3_COD=F2_VEND1 AND A31.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SA3")+" A32 ON A32.A3_FILIAL='"+xFilial("SA3")+"' AND A32.A3_COD=F2_VEND2 AND A32.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("Z43")+" Z43 ON Z43_FILIAL='"+xFilial("Z43")+"' AND Z43_CODIGO=C5_XEVENTO AND Z43.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("Z01")+" Z01 ON Z01_FILIAL='"+xFilial("Z01")+"' AND Z01_CODBAN=A1_XBANDEI AND Z01.D_E_L_E_T_=' '"
cQuery += " WHERE D2.D_E_L_E_T_=' '"
cQuery += " AND D2_QUANT > D2_QTDEDEV"

//Nao trazer novamente os itens ja calculados no periodo que ja foram pagos ou
//ja foram gerados titulos no financeiro
cQuery += " AND D2_PEDIDO+D2_DOC+D2_SERIE+F2_CLIENTE+F2_LOJA NOT IN"
cQuery += " (SELECT Z40_PEDIDO+Z40_NOTA+Z40_SERIE+Z40_CLIENT+Z40_LOJA" 
cQuery += " FROM "+RetSQLName("Z40")+" WHERE D_E_L_E_T_=' '" 
cQuery += " AND Z40_FILIAL='"+xFilial("Z40")+"' AND Z40_PAGA IN('S','G'))"

//ALTEREI BM Z03 E Z31 PARA LEFT PORQUE AINDA EXISTEM V¡RIOS PRODUTOS COM AMARRA«√O ERRADA COM O GRUPO DE PRODUTOS, COM ISSO, N√O CONSIGO BUSCAR OS VALORES CORRETOS DE COMISSAO X MALAS
If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    nPos := Ascan(aRet,{|x| x[1]+x[2]+x[5]+x[4] == TRB->F2_VEND1+TRB->BM_XMODELO+TRB->F2_DOC+TRB->D2_PEDIDO}) 
    If nPos == 0
        Aadd(aRet,{ TRB->F2_VEND1,;                     //01
                    TRB->BM_XMODELO,;                   //02
                    Alltrim(TRB->Z03_CODGRI),;          //03
                    TRB->D2_PEDIDO,;                    //04
                    TRB->F2_DOC,;                       //05
                    TRB->F2_SERIE,;                     //06
                    TRB->F2_CLIENTE,;                   //07
                    TRB->F2_LOJA,;                      //08
                    STOD(TRB->C5_EMISSAO),;             //09
                    STOD(TRB->F2_EMISSAO),;             //10
                    TRB->F2_VALMERC,;                   //11
                    TRB->C5_CONDPAG,;                   //12
                    TRB->D2_DESC,;                      //13
                    TRB->D2_QUANT,;                     //14 
                    TRB->D2_TOTAL,;                     //15
                    TRB->GEREN1N,;                      //16
                    TRB->VALORPEDIDO,;                  //17
                    Alltrim(TRB->VEND1N),;              //18
                    0,;                                 //19
                    0,;                                 //20
                    '',;                                //21
                    '',;                                //22
                    '',;                                //23
                    '',;                                //24
                    TRB->C5_XCLASPV,;                   //25
                    TRB->F2_VEND2,;                     //26
                    TRB->Z43_DESCRI,;                   //27
                    TRB->A1_XBANDEI,;                   //28
                    TRB->Z01_DESBAN,;                   //29
                    TRB->Z01_DSCESP,;                   //30
                    TRB->DESCRIPAGTO,;                  //31                  
                    TRB->Z01_CODBAN,;                   //32                  
                    TRB->E1_PARCELA})                   //33                  
    Else 
        aRet[nPos,14] += TRB->D2_QUANT
        aRet[nPos,15] += TRB->D2_TOTAL        
    EndIf 

    Aadd(aItens,{TRB->D2_ITEM,;
                TRB->D2_COD,;
                TRB->B1_GRUPO,;
                TRB->BM_GRUPO,;
                TRB->F2_VEND1,;
                Alltrim(TRB->BM_XMODELO),;
                TRB->D2_PEDIDO,;
                TRB->F2_DOC,;
                TRB->D2_QUANT,;
                TRB->D2_TOTAL})
    
    If !Empty(TRB->F2_VEND2)
        nPos := Ascan(aRet,{|x| x[1]+x[2]+x[5]+x[4] == TRB->F2_VEND2+TRB->BM_XMODELO+TRB->F2_DOC+TRB->D2_PEDIDO}) 
        If nPos == 0
            Aadd(aRet,{ TRB->F2_VEND2,;                     //01
                        TRB->BM_XMODELO,;                   //02
                        Alltrim(TRB->Z03_CODGRI),;          //03
                        TRB->D2_PEDIDO,;                    //04
                        TRB->F2_DOC,;                       //05
                        TRB->F2_SERIE,;                     //06
                        TRB->F2_CLIENTE,;                   //07
                        TRB->F2_LOJA,;                      //08
                        STOD(TRB->C5_EMISSAO),;             //09
                        STOD(TRB->F2_EMISSAO),;             //10
                        TRB->F2_VALMERC,;                   //11
                        TRB->C5_CONDPAG,;                   //12
                        TRB->D2_DESC,;                      //13
                        TRB->D2_QUANT,;                     //14 
                        TRB->D2_TOTAL,;                     //15
                        TRB->GEREN2N,;                      //16
                        TRB->VALORPEDIDO,;                  //17
                        Alltrim(TRB->VEND2N),;              //18
                        0,;                                 //19
                        0,;                                 //20
                        '',;                                //21
                        '',;                                //22
                        '',;                                //23
                        '',;                                //24
                        TRB->C5_XCLASPV,;                   //25
                        TRB->F2_VEND1,;                     //26
                        TRB->Z43_DESCRI,;                   //27
                        TRB->A1_XBANDEI,;                   //28
                        TRB->Z01_DESBAN,;                   //29
                        TRB->Z01_DSCESP,;                   //30  
                        TRB->DESCRIPAGTO,;                  //31                  
                        TRB->Z01_CODBAN,;                   //32                  
                        TRB->E1_PARCELA})                   //33   
        Else 
            aRet[nPos,14] += TRB->D2_QUANT
            aRet[nPos,15] += TRB->D2_TOTAL        
        EndIf 

        Aadd(aItens,{TRB->D2_ITEM,;
                    TRB->D2_COD,;
                    TRB->B1_GRUPO,;
                    TRB->BM_GRUPO,;
                    TRB->F2_VEND2,;
                    Alltrim(TRB->BM_XMODELO),;
                    TRB->D2_PEDIDO,;
                    TRB->F2_DOC,;
                    TRB->D2_QUANT,;
                    TRB->D2_TOTAL})
    EndIf 

    Dbskip()
ENDDO


cQuery := "SELECT E1_PEDIDO,E1_PREFIXO,E1_VEND1,E1_NUM,E1_PARCELA,E1_CLIENTE,E1_LOJA,
cQuery += " CONVERT(VARCHAR,MONTH(E1_EMISSAO)) AS MES,Z40_PRCCOM,Z40_VLRCOM,"
cQuery += " Z40_MARCA,E1_EMISSAO,A3_NOME,Z01_DESBAN,Z01_CODBAN,A1_XBANDEI,SUM(E1_VALOR) AS VLRSE1"
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL=E1_FILIAL AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA3")+" A3 ON A3_FILIAL=E1_FILIAL AND A3_COD=E1_VEND1 AND A3.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("Z01")+" Z01 ON Z01_FILIAL='"+xFilial("Z01")+"' AND Z01_CODBAN=A1_XBANDEI AND Z01.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("Z40")+" Z40 ON Z40_FILIAL=E1_FILIAL "
cQuery += " AND Z40_PEDIDO=E1_PEDIDO AND Z40_NOTA=E1_NUM AND Z40_SERIE=E1_PREFIXO"
cQuery += " AND Z40_CLIENT=E1_CLIENTE AND Z40_LOJA=E1_LOJA AND Z40.D_E_L_E_T_=' '  "
cQuery += " AND Z40_VENDED=E1_VEND1"
cQuery += " WHERE E1.D_E_L_E_T_=' ' AND E1_FILIAL='"+xFilial("SE1")+"'"
cQuery += " AND E1_VENCREA<='"+dtos(ddatabase-90)+"'"
cQuery += " AND E1_BAIXA=' ' AND E1_VEND1<>'000001' AND E1_ORIGEM='MATA460'"
cQuery += " AND E1_VEND1 BETWEEN '"+Vend1+"' AND '"+Vend2+"'"

cQuery += " AND E1_PEDIDO+E1_NUM+E1_PREFIXO+E1_CLIENTE+E1_LOJA NOT IN(SELECT Z40_PEDIDO+Z40_NOTA+Z40_SERIE+Z40_CLIENT+Z40_LOJA FROM "+RetSQLName("Z40")+" WHERE D_E_L_E_T_=' ' AND Z40_PAGA='D')"

cQuery += " GROUP BY E1_PEDIDO,E1_PREFIXO,E1_VEND1,E1_NUM,E1_PARCELA,E1_CLIENTE,"
cQuery += " E1_LOJA,CONVERT(VARCHAR,MONTH(E1_EMISSAO)),Z40_PRCCOM,"
cQuery += " Z40_VLRCOM,Z40_MARCA,E1_EMISSAO,A3_NOME,Z01_DESBAN,Z01_CODBAN,A1_XBANDEI"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
//E1_PEDIDO,E1_PREFIXO,E1_VEND1,E1_NUM,E1_CLIENTE,E1_LOJA
//CONVERT(VARCHAR,MONTH(E1_EMISSAO)) AS MES,Z40_PRCCOM,
//Z40_VLRCOM,SUM(E1_VALOR) AS VLRSE1
    Aadd(aRet,{ TRB->E1_VEND1,;                     //01
                TRB->Z40_MARCA,;                    //02
                '',;                                //03
                TRB->E1_PEDIDO,;                    //04
                TRB->E1_NUM,;                       //05
                TRB->E1_PREFIXO,;                   //06
                TRB->E1_CLIENTE,;                   //07
                TRB->E1_LOJA,;                      //08
                STOD(TRB->E1_EMISSAO),;             //09
                STOD(TRB->E1_EMISSAO),;             //10
                TRB->VLRSE1,;                       //11
                '',;                                //12
                0,;                                 //13
                0,;                                 //14
                TRB->VLRSE1,;                       //15
                'GERENTE',;                         //16
                TRB->VLRSE1,;                       //17
                Alltrim(TRB->A3_NOME),;             //18
                If(Z40_PRCCOM<>0,Z40_PRCCOM,10),;                                 //19
                If(Z40_VLRCOM<>0,Z40_VLRCOM*(-1),(TRB->VLRSE1*0.10)*(-1)),;                                 //20
                '',;                                //21
                '',;                                //22
                '',;                                //23
                'D',;                               //24
                '9',;                               //25
                TRB->E1_VEND1,;                     //26
                'Desconto Inadimplencia',;          //27
                TRB->A1_XBANDEI,;                   //28
                TRB->Z01_DESBAN,;                   //29
                '',;                                //30 
                '',;                                //31 
                TRB->Z01_CODBAN,;                   //32
                TRB->E1_PARCELA})                   //33
    Dbskip()
EndDo 

Asort(aRet,,,{|x,y| x[4]+x[5] < y[4]+y[5]})
Asort(aItens,,,{|x,y| x[8]+x[1] < y[8]+y[1]})

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} TelaCalc
    (long_description)
    @type  Static Function
    @author user
    @since 24/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function TelaCalc(aRegras,aDados)

Local aArea :=  GetArea()
Local nCont 
Local nOpcao    :=  0
Private oList1
Private oList2
Private oList3
Private aVend   :=  {}
Private aList1  :=  {}
Private aList2  :=  {}
Private aList3  :=  {}

Private aList2B  :=  {}
Private aList3B  :=  {}

SetPrvt("oDlg1","oGrp1","oBrw1","oGrp2","oBrw2","oGrp3","oBrw3","oBtn1","oBtn2","oBtn3")

For nCont := 1 to len(aDados)
    If Ascan(aVend,{|x| x[1] == aDados[nCont,01]}) == 0
        Aadd(aVend,{aDados[nCont,01],Alltrim(aDados[nCont,18])})
    EndIf

    Aadd(aList2B,aDados[nCont])
Next nCont

For nCont := 1 to len(aRegras)
    Aadd(aList3B,aRegras[nCont])
Next nCont

If len(aVend) > 0

    Asort(aVend,,,{|x,y| x[2] < y[2]})
        
    oDlg1      := MSDialog():New( 092,232,711,1835,"C·lculos",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,008,176,184,"Representantes",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,012,168,180},,, oGrp1 ) 
        oList1:= 	TCBrowse():New(012,012,169,160,, {'Vendedor','Nome'},{40,60},;
                                            oGrp1,,,,{|| Fhelp(oList1:nAt)},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        
        oList1:SetArray(aVend)
        oList1:bLine := {||{aVend[oList1:nAt,01],;
                            aVend[oList1:nAt,02]}}
                                            //536
    oGrp2      := TGroup():New( 004,188,176,795,"Itens para calculo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,192,172,532},,, oGrp2 ) 
        oList2:= 	TCBrowse():New(012,192,599,160,, {'Marca','Pedido','Nota','EmissaoPV','EmissaoNF','Valor PV','Valor NF','CondPagto','Desconto','Qtd PeÁas','Valor PeÁas','% Comissao','R$ Comissao','Cliente','Tipo PV','Evento'},;
                                                    {30,30,30,30,30,30,30,30,30,30,30,30,30,30,30},;
                                            oGrp2,,,,{|| Fhelp2(oList2:nAt)},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        
        oList2:SetArray(aList2)
        oList2:bLine := {||{aList2[oList2:nAt,03],;
                            aList2[oList2:nAt,04],;
                            aList2[oList2:nAt,05],;
                            aList2[oList2:nAt,09],;
                            aList2[oList2:nAt,10],;
                            Transform(aList2[oList2:nAt,17],"@E 999,999,999.99"),;
                            Transform(aList2[oList2:nAt,11],"@E 999,999,999.99"),;
                            aList2[oList2:nAt,12],;
                            aList2[oList2:nAt,13],;
                            Transform(aList2[oList2:nAt,14],"@E 999,999,999.99"),;
                            Transform(aList2[oList2:nAt,15],"@E 999,999,999.99"),;
                            aList2[oList2:nAt,19],;
                            Transform(aList2[oList2:nAt,20],"@E 999,999,999.99"),;
                            Alltrim(Posicione("SA1",1,xFilial("SA1")+aList2[oList2:nAt,07]+aList2[oList2:nAt,08],"A1_NOME")),;
                            If(aList2[oList2:nAt,25]=="1","Venda",If(aList2[oList2:nAt,25]=="9","Desconto","PromoÁ„o")),;
                            Alltrim(aList2[oList2:nAt,27])}}

    oGrp3      := TGroup():New( 180,008,276,795,"Regras",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw3      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{188,012,272,532},,, oGrp3 ) 
        oList3:= 	TCBrowse():New(188,012,780,083,, {'Codigo','Item','Data Ini','Data Fim','Qtd Ini','Qtd Fim','Desc Ini','Desc Fim','Valor Ini','Valor Fim','CondPagto','DescriPagto','Comissao','Bonus'},;
                                                    {30,30,30,30,30,30,30,30,30,30,30,30,30},;
                                            oGrp3,,,,{|| /*Fhelp2(oList2:nAt)*/},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        
        oList3:SetArray(aList3)
        oList3:bLine := {||{aList3[oList3:nAt,01],;
                            aList3[oList3:nAt,02],;
                            aList3[oList3:nAt,03],;
                            aList3[oList3:nAt,04],;
                            aList3[oList3:nAt,05],;
                            aList3[oList3:nAt,06],;
                            aList3[oList3:nAt,07],;
                            aList3[oList3:nAt,08],;
                            aList3[oList3:nAt,09],;
                            aList3[oList3:nAt,10],;
                            aList3[oList3:nAt,11],;
                            aList3[oList3:nAt,12],;
                            aList3[oList3:nAt,13]}}

        oBtn1      := TButton():New( 284,150,"Calcular",oDlg1,{|| Processa({|| Calcular()},"Aguarde") },037,012,,,,.T.,,"",,,,.F. )
        //oBtn1:Disable()
        oBtn2      := TButton():New( 284,200,"Confirmar",oDlg1,{|| Processa({|| gravar()},"Aguarde")},037,012,,,,.T.,,"",,,,.F. )
        oBtn3      := TButton():New( 284,250,"Excel",oDlg1,{|| Processa({|| Geraexc()},"Aguarde")},037,012,,,,.T.,,"",,,,.F. )
        oBtn5      := TButton():New( 284,300,"Pedido S/Fat",oDlg1,{|| Processa({|| PvNaoFat()},"Aguarde")},037,012,,,,.T.,,"",,,,.F. )
        oBtn4      := TButton():New( 284,350,"Cancelar",oDlg1,{||oDlg1:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )

        MENU oMenu POPUP 
        MENUITEM "Comiss„o j· paga" ACTION ( compaga(oList2:nAt) )
        MENUITEM "Ajustar % comiss„o" ACTION ( AjustPer(oList2:nAt) )
        MENUITEM "Historico de Pedidos" ACTION ( Historico(aList2[oList2:nAt,07],aList2[oList2:nAt,04]) )
        ENDMENU                                                                           

        oList2:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }
        
    oDlg1:Activate(,,,.T.)
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} FHelp
    (long_description)
    @type  Static Function
    @author user
    @since 24/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FHelp(nLinha)

Local aArea :=  GetArea()
Local nCont :=  0

aList2 := {}

For nCont := 1 to len(aList2B)
    If aList2B[nCont,01] == aVend[nLinha,01]
        Aadd(aList2,aList2B[nCont])
    EndIf 
Next nCont

If len(aList2) < 1
    Aadd(aList2,{'','','','','','','','','','','','',''})
EndIf 

oList2:SetArray(aList2)
oList2:bLine := {||{aList2[oList2:nAt,03],;
                    aList2[oList2:nAt,04],;
                    aList2[oList2:nAt,05],;
                    aList2[oList2:nAt,09],;
                    aList2[oList2:nAt,10],;
                    Transform(aList2[oList2:nAt,17],"@E 999,999,999.99"),;
                    Transform(aList2[oList2:nAt,11],"@E 999,999,999.99"),;
                    aList2[oList2:nAt,12],;
                    aList2[oList2:nAt,13],;
                    Transform(aList2[oList2:nAt,14],"@E 999,999,999.99"),;
                    Transform(aList2[oList2:nAt,15],"@E 999,999,999.99"),;
                    aList2[oList2:nAt,19],;
                    Transform(aList2[oList2:nAt,20],"@E 999,999,999.99"),;
                    Alltrim(Posicione("SA1",1,xFilial("SA1")+aList2[oList2:nAt,07]+aList2[oList2:nAt,08],"A1_NOME")),;
                    If(aList2[oList2:nAt,25]=="1","Venda",If(aList2[oList2:nAt,25]=="9","Desconto","PromoÁ„o")),;
                    Alltrim(aList2[oList2:nAt,27])}}

oList2:refresh()
oDlg1:refresh()

FHelp2(oList2:nAt)

RestArea(aArea)

Return

/*/{Protheus.doc} FHelp2
    (long_description)
    @type  Static Function
    @author user
    @since 24/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FHelp2(nLinha)

Local aArea :=  GetArea()
Local nCont 

aList3 := {}

nQtdCli   :=  0
nQtdCan   :=  0
nQtdClc   :=  0

AEval(aList2B,{|x| nQtdCli += If(x[5] == aList2B[nLinha,05],x[14],0)})
AEval(aList2B,{|x| nQtdCan += If(x[28] == aList2B[nLinha,28] .And. !Empty(x[28]),x[14],0)})
If nQtdCan > 0
    nQtdClc := nQtdCan
else    
    nQtdClc := nQtdCli
EndIf 
//aList2[nLinha,14]
For nCont := 1 to len(aList3B)
    If (aList3B[nCont,11] == aList2[nLinha,12] .And. ;
        (nQtdClc >= aList3B[nCont,05] .And. nQtdClc <= aList3B[nCont,06])) ;
        .OR. ;
        (Alltrim(aList2[nLinha,07]) == Alltrim(aList3B[nCont,14]) .And. !Empty(aList2[nLinha,07])) ;
        .OR. ;
        (Alltrim(aList2[nLinha,28]) == Alltrim(aList3B[nCont,15]) .And. !Empty(aList2[nLinha,28]))
        Aadd(aList3,aList3B[nCont])
    EndIf 
Next nCont 

If len(aList3) < 1
    Aadd(aList3,{'','','','','','','','','','','','',''})
EndIf 

oList3:SetArray(aList3)
oList3:bLine := {||{aList3[oList3:nAt,01],;
                    aList3[oList3:nAt,02],;
                    aList3[oList3:nAt,03],;
                    aList3[oList3:nAt,04],;
                    aList3[oList3:nAt,05],;
                    aList3[oList3:nAt,06],;
                    aList3[oList3:nAt,07],;
                    aList3[oList3:nAt,08],;
                    aList3[oList3:nAt,09],;
                    aList3[oList3:nAt,10],;
                    aList3[oList3:nAt,11],;
                    aList3[oList3:nAt,12],;
                    aList3[oList3:nAt,13]}}

oList3:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} Calcular
    (long_description)
    @type  Static Function
    @author user
    @since 24/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Calcular()

Local aArea     :=  GetArea()
Local nCont
Local nK 
Local lAchou    :=  .F.
Local nQtdCli   :=  0
Local nQtdCan   :=  0
Local nQtdClc   :=  0
Local lCalcnl   :=  .F.

For nCont := 1 to len(aList2B)
    lAchou    :=  .F.
    If !Alltrim(aList2B[nCont,24]) $ 'S/D'
        nPosEsp := ASCAN(aList3B,{|X| ALLTRIM(X[14]) == ALLTRIM(aList2B[nCont,07]) .And. !Empty(aList2B[nCont,07])})
        nPosCan := ASCAN(aList3B,{|X| ALLTRIM(X[15]) == ALLTRIM(aList2B[nCont,28]) .And. !Empty(aList2B[nCont,28])})
        If nPosCan > 0
            nPosEsp := nPosCan
            lCalcnl := !Empty(aList2B[nCont,28])
        EndIf  
        If nPosEsp > 0
            For nK := nPosEsp to len(aList3B)
                nQtdCli   :=  0
                nQtdCan   :=  0
                nQtdClc   :=  0
                AEval(aList2B,{|x| nQtdCli += If(x[5] == aList2B[nCont,05],x[14],0)})
                AEval(aList2B,{|x| nQtdCan += If(x[28] == aList2B[nCont,28] .And. !Empty(x[28]),x[14],0)})
                If nQtdCan > 0
                    nQtdClc := nQtdCan
                else    
                    nQtdClc := nQtdCli
                EndIf 

                If nQtdClc >= aList3B[nK,05] .And. nQtdClc <= aList3B[nK,06]
                    If (lCalcnl .And. aList3B[nK,15] == aList2B[nCont,28]) .Or. (!lCalcnl .And. Empty(aList2B[nCont,28]))
                        aList2B[nCont,19] := aList3B[nK,12]
                        lAchou := .T.
                        //ValidaÁ„o de desconto
                        If aList2B[nCont,13] > (aList3B[nK,08]  + aList2B[nCont,30])
                            aList2B[nCont,19] -= 2
                        EndIf
                    EndIf
                    
                    //Guardando a regra e item da regra que gerou a comiss„o
                    aList2B[nCont,21] := aList3B[nK,01]
                    aList2B[nCont,22] := aList3B[nK,02]
                EndIf
            Next nK 
            
        Else
            For nK := 1 to len(aList3B)
                If aList3B[nK,11] == aList2B[nCont,12] 
                    nQtdCli   :=  0
                    nQtdCan   :=  0
                    nQtdClc   :=  0
                    AEval(aList2B,{|x| nQtdCli += If(x[5] == aList2B[nCont,05],x[14],0)})
                    AEval(aList2B,{|x| nQtdCan += If(x[28] == aList2B[nCont,28] .And. !Empty(x[28]),x[14],0)})
                    If nQtdCan > 0
                        nQtdClc := nQtdCan
                    else    
                        nQtdClc := nQtdCli
                    EndIf 
                    //ValidaÁ„o por quantidade itens vendidos
                    //If aList2B[nCont,14] >= aList3B[nK,05] .And. aList2B[nCont,14] <= aList3B[nK,06]
                    
                    If nQtdClc >= aList3B[nK,05] .And. nQtdClc <= aList3B[nK,06]
                        If (lCalcnl .And. aList3B[nK,15] == aList2B[nCont,28]) .Or. (!lCalcnl .And. Empty(aList2B[nCont,28]))
                            aList2B[nCont,19] := aList3B[nK,12]
                            lAchou := .T.
                            //ValidaÁ„o de desconto
                            If aList2B[nCont,13] > (aList3B[nK,08] + aList2B[nCont,30])
                                aList2B[nCont,19] -= 2
                            EndIf
                        EndIf 
                        //Guardando a regra e item da regra que gerou a comiss„o
                        aList2B[nCont,21] := aList3B[nK,01]
                        aList2B[nCont,22] := aList3B[nK,02]
                    EndIf
                    
                    
                endif 
            Next nK
        EndIf 

        If !lAchou
            //Verificar quando n„o encontra uma regra, o que fazer
            aList2B[nCont,19] := 10
        EndIf
        
        If !Empty(aList2B[nCont,26])
            aList2B[nCont,19] := aList2B[nCont,19] / 2
        EndIf 
        aList2B[nCont,20] := ROUND(aList2B[nCont,15] * (aList2B[nCont,19]/100),2)
    endIf 
Next nCont

oList2:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PRTFAT01  ∫Autor  ≥Microsiga           ∫ Data ≥  01/24/19   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function Geraexc()

Local oExcel 	:= FWMSEXCEL():New()
//Local cTitulo 	:= "Conferencia Comissao"
Local cDir 		:= ""
Local nX 
Local cArqXls 	:= "conferencia_comissao_"+dtos(ddatabase)+strtran(time(),":")+".xls" 

cDir := cGetFile(, OemToAnsi("Selecione o diretÛrio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet("Conferencia") 

oExcel:AddTable ("Conferencia","Representantes")

oExcel:AddColumn("Conferencia","Representantes","Vendedor",1,1)        //01
oExcel:AddColumn("Conferencia","Representantes","Nome",1,1)            //02
oExcel:AddColumn("Conferencia","Representantes","Emissao_PV",1,1)      //10
oExcel:AddColumn("Conferencia","Representantes","Pedido",1,1)          //04
oExcel:AddColumn("Conferencia","Representantes","Emissao_NF",1,1)      //11
oExcel:AddColumn("Conferencia","Representantes","Nota",1,1)            //05
oExcel:AddColumn("Conferencia","Representantes","Bandeira",1,1)        //24
oExcel:AddColumn("Conferencia","Representantes","COD Bandeira",1,1)    //32
//GRUPO
//%AC FINANC
oExcel:AddColumn("Conferencia","Representantes","Cliente",1,1)         //07
oExcel:AddColumn("Conferencia","Representantes","Loja",1,1)            //08
oExcel:AddColumn("Conferencia","Representantes","Razao",1,1)           //09
oExcel:AddColumn("Conferencia","Representantes","Nome_Fantasia",1,1)   //09
oExcel:AddColumn("Conferencia","Representantes","Marca",1,1)           //03
oExcel:AddColumn("Conferencia","Representantes","Qtd_PeÁas",1,1)       //16
oExcel:AddColumn("Conferencia","Representantes","CondPagto",1,1)       //14
oExcel:AddColumn("Conferencia","Representantes","DescriPagto",1,1)     //31
oExcel:AddColumn("Conferencia","Representantes","PARCELA",1,1)         //33
oExcel:AddColumn("Conferencia","Representantes","Desconto",1,1)        //15
oExcel:AddColumn("Conferencia","Representantes","Valor_PeÁas",1,1)     //17
oExcel:AddColumn("Conferencia","Representantes","%_Comissao",1,1)      //20
oExcel:AddColumn("Conferencia","Representantes","Valor_Comissao",1,1)  //21
oExcel:AddColumn("Conferencia","Representantes","Evento",1,1)          //27

Asort(aList2B,,,{|x,y| x[1]+DTOS(X[10]) < y[1]+DTOS(Y[10])})
cVendAux := aList2B[1,1]
cNomVnd  := aList2B[1,18]
nComisVn := 0
nTotVnd  := 0

For nX := 1 to len(aList2B)
    If cVendAux == aList2B[nX,01]
        nComisVn += aList2B[nX,20]
        nTotVnd  += aList2B[nX,17]
    else
    	oExcel:AddRow("Conferencia","Representantes",{  "",;
                                                        "",;
                                                        "",;
														"",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",; 
                                                        "",;
                                                        "",;
                                                        "",;
                                                        ""})

        oExcel:AddRow("Conferencia","Representantes",{  "",;
                                                        "",;
                                                        "",;
                                                        "",;
														"",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",; 
                                                        "",;
                                                        "",;
                                                        ""})
        
        cVendAux := aList2B[nX,01]
        cNomVnd  := aList2B[nX,18]
        nComisVn := aList2B[nX,20]
        nTotVnd  := aList2B[nX,17]
    EndIf 

	oExcel:AddRow("Conferencia","Representantes",{  aList2B[nX,01],;
                                                    aList2B[nX,18],; 
                                                    aList2B[nX,09],;
                                                    aList2B[nX,04],;
                                                    aList2B[nX,10],;
                                                    aList2B[nX,05],;
                                                    aList2B[nX,29],; 
                                                    aList2B[nX,32],; 
                                                    aList2B[nX,07],; 
                                                    aList2B[nX,08],;
                                                    Alltrim(Posicione("SA1",1,xFilial("SA1")+aList2B[nX,07]+aList2B[nX,08],"A1_NOME")),;	
                                                    Alltrim(Posicione("SA1",1,xFilial("SA1")+aList2B[nX,07]+aList2B[nX,08],"A1_NREDUZ")),;	
                                                    aList2B[nX,03],;	
                                                    aList2B[nX,14],;
                                                    aList2B[nX,12],;	
                                                    aList2B[nX,31],;
                                                    aList2B[nX,33],;
                                                    aList2B[nX,13],;
                                                    aList2B[nX,15],;
                                                    aList2B[nX,19],;
                                                    aList2B[nX,20],;
                                                    aList2B[nX,27]})

Next nX

oExcel:AddRow("Conferencia","Representantes",{  "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",;
                                                "",; 
                                                "",;
                                                "",;
                                                "",;
                                                ""})

oExcel:AddworkSheet("Conferencia2") 
oExcel:AddTable ("Conferencia2","Vendas_Itens")
oExcel:AddColumn("Conferencia2","Vendas_Itens","Item",1,1)
oExcel:AddColumn("Conferencia2","Vendas_Itens","Codigo",1,1)
oExcel:AddColumn("Conferencia2","Vendas_Itens","Grupo_B1",1,1)
oExcel:AddColumn("Conferencia2","Vendas_Itens","Grupo_BM",1,1)
oExcel:AddColumn("Conferencia2","Vendas_Itens","Vendedor",1,1)
oExcel:AddColumn("Conferencia2","Vendas_Itens","Mala",1,1)
oExcel:AddColumn("Conferencia2","Vendas_Itens","Pedido",1,1)
oExcel:AddColumn("Conferencia2","Vendas_Itens","Nota",1,1)
oExcel:AddColumn("Conferencia2","Vendas_Itens","Qtd",1,1)
oExcel:AddColumn("Conferencia2","Vendas_Itens","R$_Total",1,1)

For nX := 1 to len(aItens)
    oExcel:AddRow("Conferencia2","Vendas_Itens",{  aItens[nX,01],;
                                                  aItens[nX,02],; 
                                                  aItens[nX,03],;	
                                                  aItens[nX,04],;
                                                  aItens[nX,05],;
                                                  aItens[nX,06],;
                                                  aItens[nX,07],;
                                                  aItens[nX,08],; 
                                                  aItens[nX,09],;	
                                                  aItens[nX,10]})
Next nX 

oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

WinExec('Explorer.exe /select,"' + substr(cDir,1,len(cDir)-1) + '"', 1)

oExcelApp := MsExcel():New()
oExcelApp:Destroy()

Return

/*/{Protheus.doc} gravar
    (long_description)
    @type  Static Function
    @author user
    @since 25/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gravar()

Local aArea     :=  GetArea()
Local cIdCalc   :=  ''
Local nCont 
Local cQryUpd   :=  ''

If MsgYesNo("Confirma o reprocessamento destas comissıes?")
    cQryUpd := "UPDATE Z40 SET Z40.D_E_L_E_T_='*'"
    cQryUpd += " FROM "+RetSQLName("Z40")+" Z40" 
    cQryUpd += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=Z40_CLIENT AND A1_LOJA=Z40_LOJA AND A1.D_E_L_E_T_=' '"
    cQryUpd += "  AND A1_XBANDEI BETWEEN '"+_Band1+"' AND '"+_Band2+"'"
    cQryUpd += "  AND A1_XIDPROP BETWEEN '"+_Prop1+"' AND '"+_Prop2+"'"
    cQryUpd += " WHERE Z40_DTFATU BETWEEN '"+DTOS(_DtDe)+"' AND '"+DTOS(_DtAt)+"'"
    cQryUpd += " AND Z40_VENDED BETWEEN '"+_Vend1+"' AND '"+_Vend2+"'"
    cQryUpd += " AND Z40_PAGA NOT IN('S','G')"
    
    TcSqlExec( cQryUpd )
  
    cIdCalc := GETSXENUM("Z40","Z40_IDCALC")
    For nCont := 1 to len(aList2B)
        RecLock("Z40", .T.)
        Z40->Z40_FILIAL  :=  xFilial("Z40")
        Z40->Z40_IDCALC  :=  cIdCalc
        Z40->Z40_ITEM    :=  strzero(nCont,5)
        Z40->Z40_XCOMPE  :=  substr(DTOS(_DtDe),5,2)+substr(DTOS(_DtDe),1,4)
        Z40->Z40_PEDIDO  :=  aList2B[nCont,04]
        Z40->Z40_NOTA    :=  aList2B[nCont,05]
        Z40->Z40_SERIE   :=  aList2B[nCont,06]
        Z40->Z40_CLIENT  :=  aList2B[nCont,07]
        Z40->Z40_LOJA    :=  aList2B[nCont,08]
        Z40->Z40_DTPEDI  :=  aList2B[nCont,09]
        Z40->Z40_DTFATU  :=  aList2B[nCont,10]
        Z40->Z40_DTBAIX  :=  CTOD(" / / ")
        Z40->Z40_VLRPED  :=  aList2B[nCont,17]
        Z40->Z40_VLRNF   :=  aList2B[nCont,11]
        Z40->Z40_VLRBXF  :=  0
        Z40->Z40_PRCCOM  :=  aList2B[nCont,19]
        Z40->Z40_VLRCOM  :=  aList2B[nCont,20]
        Z40->Z40_MARCA   :=  aList2B[nCont,02]
        Z40->Z40_QTDITM  :=  aList2B[nCont,14]
        Z40->Z40_DESCON  :=  aList2B[nCont,13]
        Z40->Z40_CONDPG  :=  aList2B[nCont,12]
        Z40->Z40_DTDESC  :=  CTOD(" / / ")
        Z40->Z40_MSBLQL  :=  '2'
        Z40->Z40_VENDED  :=  aList2B[nCont,01]
        Z40->Z40_GERENT  :=  aList2B[nCont,16]
        Z40->Z40_REGRA   :=  aList2B[nCont,21]
        Z40->Z40_ITMREG  :=  aList2B[nCont,22]
        Z40->Z40_OBS     :=  aList2B[nCont,23]
        Z40->Z40_DTCALC  :=  ddatabase
        Z40->Z40_HRCALC  :=  cvaltochar(time())
        Z40->Z40_USRCAL  :=  cusername     
        Z40->Z40_PAGA    :=  aList2B[nCont,24]
        Z40->(MsUnlock())
    Next nCont 

    ConfirmSX8()

    MsgAlert("Processo finalizado!!!")
    oDlg1:end()
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} BuscaMes
    (long_description)
    @type  Static Function
    @author user
    @since 30/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaMes(cMesAno)

Local aArea  := GetArea()
Local cQuery := ""
Local cRet   := ""

cQuery := "SELECT TOP 1 'Z31_MSAN01' AS ORDEM FROM "+RetSQLName("Z31")
cQuery += " WHERE Z31_MSAN01='"+cMesAno+"'"
cQuery += " UNION"
cQuery += " SELECT TOP 1 'Z31_MSAN02' AS ORDEM FROM "+RetSQLName("Z31")
cQuery += " WHERE Z31_MSAN02='"+cMesAno+"'"
cQuery += " UNION"
cQuery += " SELECT TOP 1 'Z31_MSAN03' AS ORDEM FROM "+RetSQLName("Z31")
cQuery += " WHERE Z31_MSAN03='"+cMesAno+"'"

If Select('QUERY') > 0
    dbSelectArea('QUERY')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )

DbSelectArea("QUERY")

cRet := QUERY->ORDEM 

RestArea(aArea)

Return(cRet)

/*/{Protheus.doc} compaga
    (long_description)
    @type  Static Function
    @author user
    @since 07/06/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function compaga(nLinha)

Local aArea :=  GetArea()

aList2B[nLinha,19] := 0
aList2B[nLinha,20] := 0

aList2B[nLinha,24] := 'S'

oList2:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} AjustPer(oList2:nAt)
    (long_description)
    @type  Static Function
    @author user
    @since 09/06/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function AjustPer(nLinha)

Local aArea :=  GetArea()
Local nBk12 :=  aList2[nLinha,12]

aList2[nLinha,12] := padl(aList2[nLinha,19],2," ")
leditcell(aList2, oList2, "", 12)

aList2[nLinha,19] := aList2[nLinha,12]
aList2[nLinha,12] := nBk12

aList2[nLinha,20] := ROUND(aList2[nLinha,15] * (VAL(aList2[nLinha,19])/100),2)

oList2:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} Historico
    (long_description)
    @type  Static Function
    @author user
    @since 05/07/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Historico(cliente,pedido)

Local aArea :=  GetArea()
Local cQuery 

Private aAux1 := {}
Private aAux2 := {}
Private aAux3 := {}
Private oAux1
Private oAux2

SetPrvt("oDlg5","oGrp15","oBrw1","oGrp16","oBrw2","oBtnS")

cQuery := "SELECT C5_NUM,C5_EMISSAO,C5_NOTA,C5_SERIE,C6_DATFAT,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_PRCVEN,C6_VALOR,C6_DESCONT"
cQuery += " FROM "+RetSQLName("SC5")+" C5"
cQuery += " INNER JOIN "+RetSQLName("SC6")+" C6 ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C6_CLI=C5_CLIENTE AND C6_LOJA=C5_LOJACLI AND C6.D_E_L_E_T_=' '
cQuery += " WHERE C5_FILIAL='"+xFilial("SC6")+"' AND C5_CLIENTE='"+cliente+"' AND C5.D_E_L_E_T_=' '"
cQuery += " AND C5_NUM<>'"+pedido+"'"

If Select('QUERY') > 0
    dbSelectArea('QUERY')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )

DbSelectArea("QUERY")

While !EOF()
    If Ascan(aAux1,{|x| x[1] == QUERY->C5_NUM}) == 0
        Aadd(aAux1,{QUERY->C5_NUM,;
                    QUERY->C5_EMISSAO,;
                    QUERY->C5_NOTA,;
                    QUERY->C5_SERIE,;
                    QUERY->C6_DATFAT})
    EndIf 

    Aadd(aAux2,{QUERY->C6_ITEM,;
                QUERY->C6_PRODUTO,;
                QUERY->C6_DESCRI,;
                QUERY->C6_QTDVEN,;
                QUERY->C6_PRCVEN,;
                QUERY->C6_VALOR,;
                QUERY->C6_DESCONT,;
                QUERY->C5_NUM})
    
    Aadd(aAux3,{QUERY->C6_ITEM,;
                QUERY->C6_PRODUTO,;
                QUERY->C6_DESCRI,;
                QUERY->C6_QTDVEN,;
                QUERY->C6_PRCVEN,;
                QUERY->C6_VALOR,;
                QUERY->C6_DESCONT,;
                QUERY->C5_NUM})
    
    Dbskip()
EndDo 

If len(aAux1) > 0
    oDlg5      := MSDialog():New( 092,232,391,1400,"HistÛrico",,,.F.,,,,,,.T.,,,.T. )

        oGrp15     := TGroup():New( 004,004,120,278,"Pedidos",oDlg5,CLR_BLACK,CLR_WHITE,.T.,.F. )
            //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,116,152},,, oGrp15 ) 
            oAux1:= 	TCBrowse():New(012,008,268,104,, {'Pedido','Emiss„o','Nota','Serie','Dt Faturam.'},;
                                                        {25,30,30,15,30},;
                                                oGrp15,,,,{|| Fhelp3(oAux1:nAt)},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
            
            oAux1:SetArray(aAux1)
            oAux1:bLine := {||{ aAux1[oAux1:nAt,01],;
                                stod(aAux1[oAux1:nAt,02]),;
                                aAux1[oAux1:nAt,03],;
                                aAux1[oAux1:nAt,04],;
                                stod(aAux1[oAux1:nAt,05])}}

        oGrp16     := TGroup():New( 004,280,120,585,"Itens",oDlg5,CLR_BLACK,CLR_WHITE,.T.,.F. )
            //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,164,116,452},,, oGrp16 ) 
            //ITEM PRODUTO DESCRICAO QTD PRC UNIT TOTAL DESC %
            oAux2:= 	TCBrowse():New(012,284,296,104,, {'Item','Codigo','DescriÁ„o','Qtd','Vlr Unit.','Vlr Total','Desc. %'},;
                                                        {25,30,30,15,30},;
                                                oGrp16,,,,{|| },{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
            
            oAux2:SetArray(aAux2)
            oAux2:bLine := {||{ aAux2[oAux2:nAt,01],;
                                aAux2[oAux2:nAt,02],;
                                aAux2[oAux2:nAt,03],;
                                Transform(aAux2[oAux2:nAt,04],'@E 999.99'),;
                                Transform(aAux2[oAux2:nAt,05],'@E 999,999.99'),;
                                Transform(aAux2[oAux2:nAt,06],'@E 999,999.99'),;
                                Transform(aAux2[oAux2:nAt,07],'@E 999.99')}}

        oBtnS      := TButton():New( 124,264,"Sair",oDlg5,{|| oDlg5:end()},037,012,,,,.T.,,"",,,,.F. )

    oDlg5:Activate(,,,.T.)
else
    MsgAlert("N„o encontrado pedidos anteriores a este")
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} Fhelp3(oAux1:nAt)
    (long_description)
    @type  Static Function
    @author user
    @since 05/07/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Fhelp3(nLinha)

Local aArea :=  GetArea()
Local nCont 

aAux2 := {}

For nCont := 1 to len(aAux3)
    If aAux1[nLinha,01] == aAux3[nCont,08]
        Aadd(aAux2,aAux3[nCont])
    EndIf 
Next nCont

oAux2:SetArray(aAux2)
oAux2:bLine := {||{ aAux2[oAux2:nAt,01],;
                    aAux2[oAux2:nAt,02],;
                    aAux2[oAux2:nAt,03],;
                    Transform(aAux2[oAux2:nAt,04],'@E 999.99'),;
                    Transform(aAux2[oAux2:nAt,05],'@E 999,999.99'),;
                    Transform(aAux2[oAux2:nAt,06],'@E 999,999.99'),;
                    Transform(aAux2[oAux2:nAt,07],'@E 999.99')}}

oAux2:refresh()
oDlg5:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} PvNaoFat
    (long_description)
    @type  Static Function
    @author user
    @since 11/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function PvNaoFat()
//_Vend1,_Vend2,_DtDe,_DtAt,_Band1,_Band2,_Prop1,_Prop2,_Pedi1,_Pedi2
Local aArea :=  GetArea()
Local cQuery 
Local cMesAn:=  substr(strtran(cvaltochar(_DtAt),"/"),3)
Local cAuxM :=  " 0822"  //BuscaMes(cMesAn)
Local aAuxP :=  {}
Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= ""
Local nX 
Local cArqXls 	:= "Pedido_nao_faturado_"+dtos(ddatabase)+strtran(time(),":")+".xls" 

cDir := cGetFile(, OemToAnsi("Selecione o diretÛrio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

cQuery := "SELECT DISTINCT C5_VEND1,A31.A3_NOME AS A3_NOME,C5_EMISSAO,"
cQuery += "C5_NUM,Z01_DESBAN,C5_CLIENTE,C5_LOJACLI,BM_XMODELO,C6_QTDVEN,"
cQuery += "C5_CONDPAG,E4_DESCRI,C6_DESCONT,A1_NOME,"
cQuery += "CONVERT(VARCHAR(8000),C5_XOBSLIB) AS OBSERVACAO_LIBERACAO,"
cQuery += "SUM(C6_VALOR) AS VALOR,"
cQuery += "SUM(C6_QTDVEN) AS QTDPECAS"
cQuery += " FROM "+RetSQLName("SC6")+" C6 "
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"'" 
cQuery += "       AND B1_COD=C6_PRODUTO "
cQuery += "       AND B1.D_E_L_E_T_= ' '" 
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL" 
cQuery += "       AND C5_NUM=C6_NUM" 
cQuery += "       AND C5_CLIENTE=C6_CLI" 
cQuery += "       AND C5_LOJACLI=C6_LOJA" 
cQuery += "       AND C5.D_E_L_E_T_=' '" 
cQuery += "       AND C5_XCLASPV IN('1' , '5')"
cQuery += "       AND C5_NUM BETWEEN '"+_Pedi1+"' AND '"+_Pedi2+"'"
cQuery += "	   AND C5_EMISSAO BETWEEN '"+dtos(_DtDe)+"' AND '"+dtos(_DtAt)+"'"  
cQuery += "	   AND C5_VEND1<>'000001'"
cQuery += "	   AND C5_VEND1 BETWEEN '"+_Vend1+"' AND '"+_Vend2+"'"
cQuery += "	   AND C5_NOTA=' '"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"'" 
cQuery += "       AND A1_COD=C5_CLIENTE" 
cQuery += "       AND A1_LOJA=C5_LOJACLI" 
cQuery += "       AND A1.D_E_L_E_T_=' '" 
cQuery += "       AND A1_XBANDEI BETWEEN '"+_Band1+"'  AND '"+_Band2+"'" 
cQuery += "       AND A1_XIDPROP BETWEEN '"+_Prop1+"' AND '"+_Prop2+"'" 
cQuery += " INNER JOIN "+RetSQLName("SE4")+" E4 ON E4_FILIAL='"+xFilial("SE4")+"'" 
cQuery += "       AND E4_CODIGO=C5_CONDPAG"
cQuery += " LEFT JOIN "+RetSQLName("SBM")+" BM ON BM_FILIAL='"+xFilial("SBM")+"'" 
cQuery += "       AND BM_GRUPO=B1_GRUPO" 
cQuery += "       AND BM.D_E_L_E_T_=' '" 
cQuery += "       AND BM_GRUPO <>'19'" 
cQuery += "       AND BM_GRUPO <>' '" 
cQuery += " LEFT JOIN "+RetSQLName("Z03")+" Z3 ON Z03_FILIAL=BM_FILIAL" 
cQuery += "       AND Z03_CODGRI=BM_XMODELO" 
cQuery += "       AND Z3.D_E_L_E_T_=' '" 
cQuery += " LEFT JOIN "+RetSQLName("Z31")+" Z31 ON Z31_FILIAL='"+xFilial("Z31")+"'"
cQuery += "       AND Z31_CODVEN=C5_VEND1" 
cQuery += "       AND Z31.D_E_L_E_T_=' '" 
cQuery += "       AND RTRIM(Z31_MALA) = BM_XMODELO" 
cQuery += "       AND "+cAuxM+"='"+cMesAn+"'" 
cQuery += " LEFT JOIN "+RetSQLName("SA3")+" A31 ON A31.A3_FILIAL='"+xFilial("SA3")+"'" 
cQuery += "       AND A31.A3_COD=C5_VEND1" 
cQuery += "       AND A31.D_E_L_E_T_=' '" 
cQuery += " LEFT JOIN "+RetSQLName("Z43")+" Z43 ON Z43_FILIAL='"+xFilial("Z43")+"'" 
cQuery += "       AND Z43_CODIGO=C5_XEVENTO" 
cQuery += "       AND Z43.D_E_L_E_T_=' ' "
cQuery += " LEFT JOIN "+RetSQLName("Z01")+" Z01 ON Z01_FILIAL='"+xFilial("Z01")+"'" 
cQuery += "       AND Z01_CODBAN=A1_XBANDEI" 
cQuery += "       AND Z01.D_E_L_E_T_=' ' "
cQuery += " WHERE  C6.D_E_L_E_T_=' ' AND  C6_QTDENT=0"
cQuery += " GROUP BY C5_VEND1,A3_NOME,C5_EMISSAO,C5_NUM,Z01_DESBAN,C5_CLIENTE,C5_LOJACLI,BM_XMODELO,C6_QTDVEN,C5_CONDPAG,E4_DESCRI,C6_DESCONT,A1_NOME,C5_XOBSLIB"
cQuery += " ORDER BY C5_VEND1,C5_EMISSAO,C5_NUM"

If Select('QUERY') > 0
    dbSelectArea('QUERY')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )

DbSelectArea("QUERY")

While !EOF()
    Aadd(aAuxP,{QUERY->C5_VEND1,;
                QUERY->A3_NOME,;
                cvaltochar(stod(QUERY->C5_EMISSAO)),;
                QUERY->C5_NUM,;
                QUERY->Z01_DESBAN,;
                QUERY->C5_CLIENTE,;
                QUERY->C5_LOJACLI,;
                QUERY->A1_NOME,;
                QUERY->BM_XMODELO,;
                QUERY->QTDPECAS,;
                QUERY->C5_CONDPAG,;
                QUERY->C6_DESCONT,;
                QUERY->VALOR,;
                QUERY->OBSERVACAO_LIBERACAO,;
                QUERY->E4_DESCRI})

    Dbskip()
ENDDO

If len(aAuxP) > 0
    oExcel:AddworkSheet("Conferencia") 

    oExcel:AddTable ("Conferencia","Representantes")
    oExcel:AddColumn("Conferencia","Representantes","Vendedor",1,1)  //01
    oExcel:AddColumn("Conferencia","Representantes","Nome",1,1)      //02
    oExcel:AddColumn("Conferencia","Representantes","Emissao_PV",1,1)   //10
    oExcel:AddColumn("Conferencia","Representantes","Pedido",1,1)       //04
    oExcel:AddColumn("Conferencia","Representantes","Bandeira",1,1)     //24
    oExcel:AddColumn("Conferencia","Representantes","Cliente",1,1)      //07
    oExcel:AddColumn("Conferencia","Representantes","Loja",1,1)         //08
    oExcel:AddColumn("Conferencia","Representantes","Razao",1,1)        //09
    oExcel:AddColumn("Conferencia","Representantes","Marca",1,1)        //03
    oExcel:AddColumn("Conferencia","Representantes","Qtd_PeÁas",1,1)    //16
    oExcel:AddColumn("Conferencia","Representantes","CondPagto",1,1)    //14
    oExcel:AddColumn("Conferencia","Representantes","DescriPagto",1,1)    //14
    oExcel:AddColumn("Conferencia","Representantes","Desconto",1,1)     //15
    oExcel:AddColumn("Conferencia","Representantes","Valor_PeÁas",1,1)  //17
    oExcel:AddColumn("Conferencia","Representantes","Observacao_Liberacao",1,1)   //11
    

    For nX := 1 to len(aAuxP)

        oExcel:AddRow("Conferencia","Representantes",{  aAuxP[nX,01],;
                                                        aAuxP[nX,02],; 
                                                        aAuxP[nX,03],;
                                                        aAuxP[nX,04],;
                                                        aAuxP[nX,05],;
                                                        aAuxP[nX,06],;
                                                        aAuxP[nX,07],; 
                                                        aAuxP[nX,08],; 
                                                        aAuxP[nX,09],;
                                                        aAuxP[nX,10],;	
                                                        aAuxP[nX,11],;
                                                        aAuxP[nX,15],;
                                                        aAuxP[nX,12],;	
                                                        aAuxP[nX,13],;
                                                        aAuxP[nX,14]})

    Next nX

    oExcel:Activate()

    oExcel:GetXMLFile(cDir +cArqXls)

    WinExec('Explorer.exe /select,"' + substr(cDir,1,len(cDir)-1) + '"', 1)

    oExcelApp := MsExcel():New()
    oExcelApp:Destroy()
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 29/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function xGeraTit()

LOCAL aArray        :=  {}
Local aAux          :=  {}
Local cQuery 
Local lRet          :=  .F.
Local _Vend1        :=  space(6)
Local _Vend2        :=  'ZZZZZZ'
Local _DtDe         :=  CTOD(' / / ')
Local _DtAt         :=  CTOD(' / / ')
Local nCont 

PRIVATE lMsErroAuto :=  .F.

Define msDialog oDlg01 From 00,00 To 290,420 Title "Gerar Titulos" Pixel &&145
Define Font oFont1 Name "Arial" Size 0,-12 Bold

@025,007 SAY "Vendedor De : " Font oFont1 of oDlg01 Pixel
@025,120 MSGET _Vend1  SIZE 60,9 F3 "SA3" OF oDlg01 Pixel 

@040,007 SAY "Vendedor AtÈ : " Font oFont1 of oDlg01 Pixel
@040,120 MSGET _Vend2  SIZE 60,9 F3 "SA3" OF oDlg01 Pixel

@055,007 SAY "Data De : " Font oFont1 of oDlg01 Pixel
@055,120 MSGET _DtDe  SIZE 60,9 OF oDlg01 Pixel 

@070,007 SAY "Data AtÈ : " Font oFont1 of oDlg01 Pixel
@070,120 MSGET _DtAt  SIZE 60,9 OF oDlg01 Pixel

@090,115 BmpButton Type 1 Action(lRet := .T.,Close(oDlg01))
@090,150 BmpButton Type 2 Action(lRet := .F.,Close(oDlg01))

Activate Dialog oDlg01 Centered

If lRet 
    cQuery := "SELECT Z40_VENDED,A3_NOME,A3_CGC,A3_FORNECE,A3_LOJA,A2_COD"
    cQuery += " ,A2_LOJA,Z40_XCOMPE,A3_DIA,Z40_IDCALC,SUM(Z40_VLRCOM) AS COMISSAO
    cQuery += " FROM "+RetSQLName("Z40")+" Z40"
    cQuery += " INNER JOIN "+RetSQLName("SA3")+" A3 ON A3_FILIAL=Z40_FILIAL AND A3_COD=Z40_VENDED AND A3.D_E_L_E_T_=' '"
    cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL=Z40_FILIAL AND A2_CGC=A3_CGC AND A2.D_E_L_E_T_=' '"
    cQuery += " WHERE Z40_FILIAL='"+xFilial("Z40")+"'"
    cQuery += " AND Z40_VENDED BETWEEN '"+_Vend1+"' AND '"+_Vend2+"'"
    cQuery += " AND Z40_DTCALC BETWEEN '"+dtos(_DtDe)+"' AND '"+dtos(_DtAt)+"'"
    cQuery += " AND Z40.D_E_L_E_T_=' ' AND Z40_MSBLQL<>'1' AND Z40_PAGA NOT IN('S','G')"
    cQuery += " GROUP BY Z40_VENDED,A3_NOME,A3_CGC,A3_FORNECE,A3_LOJA,A2_COD,A2_LOJA,Z40_XCOMPE,A3_DIA,Z40_IDCALC"

    If Select('QUERY') > 0
        dbSelectArea('QUERY')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )

    DbSelectArea("QUERY")

    While !EOF()
        Aadd(aAux,{ QUERY->Z40_VENDED,;     //01
                    QUERY->A3_NOME,;        //02
                    QUERY->A3_CGC,;         //03
                    QUERY->A3_FORNECE,;     //04
                    QUERY->A3_LOJA,;        //05
                    QUERY->A2_COD,;         //06
                    QUERY->A2_LOJA,;        //07
                    QUERY->Z40_XCOMPE,;     //08
                    QUERY->A3_DIA,;         //09
                    QUERY->Z40_IDCALC,;     //10    
                    QUERY->COMISSAO,;       //11
                    .F.,;                   //12
                    ''})                    //13
        Dbskip()
    EndDo 

    For nCont := 1 to len(aAux)
        dDiaPg := ''
        cAxMPg := substr(dtos(lastday(stod(substr(aaux[nCont,8],3)+substr(aAux[nCont,8],1,2)+'01'))+1),1,6)
        If aAux[nCont,09] <> 0
            dDiaPg := stod(cAxMPg+cvaltochar(aAux[nCont,09]))
        Else
            dDiaPg := stod(cAxMPg+'10')
        endIf 

        If dDiaPg < ddatabase 
            dDiaPg := ddatabase+5
        EndIf 

        aAux[nCont,13] := cvaltochar(dDiaPg)

        aArray := { {"E2_PREFIXO"   ,'COM'              , NIL},;
                    {"E2_NUM"       ,aAux[nCont,10]     , NIL},;
                    {"E2_PARCELA"   ,' '                , NIL},;
                    {"E2_TIPO"      ,'NF'               , NIL},;
                    {"E2_NATUREZ"   ,'22100002'         , NIL},;
                    {"E2_FORNECE"   ,If(!Empty(aAux[nCont,04]),aAux[nCont,04],aAux[nCont,06])  ,   NIL},;
                    {"E2_LOJA"      ,If(!Empty(aAux[nCont,05]),aAux[nCont,05],aAux[nCont,07])  ,   NIL},;
                    {"E2_EMISSAO"   ,dDatabase          , NIL},;
                    {"E2_VENCTO"    ,dDiaPg             , NIL},;
                    {"E2_VENCREA"   ,dDiaPg             , NIL},;
                    {"E2_VALOR"     ,aAux[nCont,11]     , NIL},;
                    {"E2_HIST"      ,'Ref Comissao competencia '+aAux[nCont,08] ,   NIL},;
                    {"E2_ORIGEM"    ,'ROBCMS04'         , NIL}} 

        lMsErroAuto :=  .F.

        MsExecAuto( { |x,y,z| FINA050(x,y,z)},aArray,, 3) // 3 - Inclusao, 4 - AlteraÁ„o, 5 - Exclus„o

        If lMsErroAuto
            MostraErro()
        else
            aAux[nCont,12] := .T.
            cRecnE2 := CVALTOCHAR(SE2->(Recno()))
            cQryUpd := "UPDATE Z40010 SET Z40_RECNE2="+cRecnE2+",Z40_PAGA='G'"
            cQryUpd += " WHERE Z40_VENDED='"+aAux[nCont,01]+"' AND Z40_IDCALC='"+aAux[nCont,10]+"'"
            cQryUpd += " AND Z40_XCOMPE='"+aAux[nCont,08]+"' AND D_E_L_E_T_=' '"

            TcSqlExec( cQryUpd )
        Endif
    Next nCont

    RelTitGer(aAux)
    MsgAlert("Processo finalizado.")
EndIf 

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 29/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function xEstTit()

Local lRet          :=  .F.
Local _Vend1        :=  space(6)
Local _Vend2        :=  'ZZZZZZ'
Local _Compt        :=  space(6)
Local cQuery 
Local aAux          :=  {}
Local nCont 

PRIVATE lMsErroAuto :=  .F.

Define msDialog oDlg01 From 00,00 To 250,420 Title "Estornar Titulos" Pixel &&145
Define Font oFont1 Name "Arial" Size 0,-12 Bold

@025,007 SAY "Vendedor De : " Font oFont1 of oDlg01 Pixel
@025,120 MSGET _Vend1  SIZE 60,9 F3 "SA3" OF oDlg01 Pixel 

@040,007 SAY "Vendedor AtÈ : " Font oFont1 of oDlg01 Pixel
@040,120 MSGET _Vend2  SIZE 60,9 F3 "SA3" OF oDlg01 Pixel

@055,007 SAY "CompetÍncia : " Font oFont1 of oDlg01 Pixel
@055,120 MSGET _Compt  SIZE 60,9 OF oDlg01 Pixel 

@080,115 BmpButton Type 1 Action(lRet := .T.,Close(oDlg01))
@080,150 BmpButton Type 2 Action(lRet := .F.,Close(oDlg01))

Activate Dialog oDlg01 Centered

If lRet 
    cQuery := "SELECT DISTINCT Z40_RECNE2 AS RECE2"
    cQuery +=  " FROM "+RetSQLName("Z40")
    cQuery += " WHERE D_E_L_E_T_=' '"
    cQuery += " AND Z40_VENDED BETWEEN '"+_Vend1+"' AND '"+_Vend2+"'"
    cQuery += " AND Z40_XCOMPE='"+_Compt+"'"
    
    If Select('QUERY') > 0
        dbSelectArea('QUERY')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )

    DbSelectArea("QUERY")

    While !EOF()
        Aadd(aAux,QUERY->RECE2)
        Dbskip()
    EndDo 

    For nCont := 1 to len(aAux)
        DbSelectArea("SE2")
        Dbgoto(aAux[nCont])
        If !Empty(SE2->E2_PORTADO)  
            MsgAlert("Titulo "+SE2->E2_NUM+CRLF+"N„o poder· ser excluÌdo pois se encontra em um borderÙ de pagamento")
            loop
        ENDIF

        If !Empty(SE2->E2_BAIXA)
            MsgAlert("Titulo "+SE2->E2_NUM+CRLF+"N„o poder· ser excluÌdo pois j· foi baixado")
            loop
        ENDIF

        Reclock("SE2",.F.)
        SE2->(DBDelete())
        SE2->(MsUnlock())

        cQryUpd := "UPDATE Z40010 SET Z40_RECNE2=0,Z40_PAGA=' '"
        cQryUpd += " WHERE Z40_RECNE2='"+cvaltochar(aAux[nCont])+"' AND Z40_PAGA='G' AND D_E_L_E_T_=' '"

        TcSqlExec( cQryUpd )
    Next nCont

    
    MsgAlert("Processo finalizado")
EndIf 

Return

/*/{Protheus.doc} User Function xClcBon
    (long_description)
    @type  Function
    @author user
    @since 29/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xClcBon()

Local aPeriod := Periodo()
Local nCont   := 0
Local cPeriod := ""
Local cBarra  := ""
Local aRet    := {}

If len(aPeriod) > 0
    cQuery := "SELECT Z31_CODVEN,Z31_MALA,SUM(Z31_VLMS01+Z31_VLMS02+Z31_VLMS03) AS VALOR" 
    cQuery += " FROM "+RetSQLName("Z31")
    cQuery += " WHERE Z31_FILIAL='"+xFilial("Z31")+"'"
    cQuery += " AND D_E_L_E_T_=' '"
    
    For nCont := 1 to len(aPeriod)
        cQuery += " AND Z31_MSAN0"+cvaltochar(nCont)+"='"+aPeriod[nCont]+"'"
        cPeriod += cBarra + aPeriod[nCont]
        cBarra := "','"
    Next nCont 

    cQuery += " GROUP BY Z31_CODVEN,Z31_MALA"

    If Select('QUERY') > 0
        dbSelectArea('QUERY')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )

    DbSelectArea("QUERY")

    While !EOF()
        Aadd(aRet,{QUERY->Z31_CODVEN,Alltrim(QUERY->Z31_MALA),QUERY->VALOR,0,0,0})
        Dbskip()
    EndDo 

    cQuery := "SELECT Z40_VENDED,Z40_MARCA,SUM(Z40_VLRNF) AS VENDA"
    cQuery += " FROM "+RetSQLName("Z40")
    cQuery += " WHERE Z40_FILIAL='"+xFilial("Z40")+"' AND Z40_XCOMPE IN('"+cPeriod+"') AND D_E_L_E_T_=' '"
    cQuery += " GROUP BY Z40_VENDED,Z40_MARCA"

    If Select('QUERY') > 0
        dbSelectArea('QUERY')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )

    DbSelectArea("QUERY")

    While !EOF()
        nPos := Ascan(aRet,{|x| Alltrim(x[1])+Alltrim(x[2]) == Alltrim(QUERY->Z40_VENDED)+Alltrim(QUERY->Z40_MARCA)})

        If nPos > 0
            aRet[nPos,04] := QUERY->VENDA
            aRet[nPos,05] := Round(aRet[nPos,04] / aRet[nPos,03],2) * 100

            If aRet[nPos,05] >= 70 .and. aRet[nPos,05] <= 99.999
                aRet[nPos,06] := aRet[nPos,04] * 0.005
            ElseIf aRet[nPos,05] >= 100 .and. aRet[nPos,05] <= 124.999
                aRet[nPos,06] := aRet[nPos,04] * 0.01
            ElseIf aRet[nPos,05] >= 125 .and. aRet[nPos,05] <= 149.999
                aRet[nPos,06] := aRet[nPos,04] * 0.015
            ElseIf aRet[nPos,05] >= 150
                aRet[nPos,06] := aRet[nPos,04] * 0.02
            EndIf  
        endIf 

        Dbskip()
    EndDo 

    Asort(aRet,,,{|x,y| x[1] < y[1] })
    BonusClc(aRet,aPeriod)
EndIf 

Return
/*/{Protheus.doc} User Function xClcBon
    (long_description)
    @type  Function
    @author user
    @since 29/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function Periodo()
    
    Local aArea     :=  GetArea()
    Local cPerg1    :=  year(ddatabase)
    Local aPerg     :=  {}
    Local aAux      :=  {}
    Local nCont     :=  0
    Local aGrupos   :=  {'1=Primeiro','2=Segundo','3=Terceiro','4=Quarto'}
    Local aQuadri   :=  {{'01','02','03'},{'04','05','06'},{'07','08','09'},{'10','11','12'}}
    
    aAdd(aPerg, {1, "Ano desejado" ,  cPerg1,  "", ".T.", "", ".T.", 50,  .F.})
    AAdd(aPerg, {2, "Trimestre" ,  aGrupos[1], aGrupos, 50,'.T.',.T.})
	
    If ParamBox(aPerg, "Confirme o ano desejado a ser configurado!")
        cPerg1 := cvaltochar(MV_PAR01)
        aAux   := aQuadri[val(MV_PAR02)]
        cQuad  := cvaltochar(MV_PAR02)

        For nCont := 1 to len(aAux)
            aAux[nCont] += cPerg1
        Next nCont
    else
        aAux := {}
    ENDIF

    

    RestArea(aArea)

Return(aAux)
/*/{Protheus.doc} User Function xClcBon
    (long_description)
    @type  Function
    @author user
    @since 29/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function BonusClc(aRet,aPeriod)

Local aArea :=  GetArea()
Local aAuxP     :=  {}
Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= ""
Local nX 
Local cArqXls 	:= "Calculo_bonus_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local cPeriod   :=  ''

Aeval(aPeriod,{|x| cPeriod += x + ' / '})

cDir := cGetFile(, OemToAnsi("Selecione o diretÛrio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

If len(aRet) > 0
    oExcel:AddworkSheet(cPeriod) 

    oExcel:AddTable (cPeriod,"Representantes")
    oExcel:AddColumn(cPeriod,"Representantes","Vendedor",1,1)
    oExcel:AddColumn(cPeriod,"Representantes","Nome",1,1)   
    oExcel:AddColumn(cPeriod,"Representantes","Mala",1,1)   
    oExcel:AddColumn(cPeriod,"Representantes","Meta",1,1)   
    oExcel:AddColumn(cPeriod,"Representantes","Realizado",1,1)
    oExcel:AddColumn(cPeriod,"Representantes","% Atingido",1,1)
    oExcel:AddColumn(cPeriod,"Representantes","Bonus",1,1)     
    
    For nX := 1 to len(aRet)

        oExcel:AddRow(cPeriod,"Representantes",{  aRet[nX,01],;
                                                        Posicione("SA3",1,xFilial("SA3")+aRet[nX,01],"A3_NOME"),; 
                                                        aRet[nX,02],;
                                                        Transform(aRet[nX,03],"@E 999,999,999.99"),;
                                                        Transform(aRet[nX,04],"@E 999,999,999.99"),;
                                                        Transform(aRet[nX,05],"@E 999,999,999.99"),;
                                                        Transform(aRet[nX,06],"@E 999,999,999.99")})

    Next nX

    oExcel:Activate()

    oExcel:GetXMLFile(cDir +cArqXls)

    WinExec('Explorer.exe /select,"' + substr(cDir,1,len(cDir)-1) + '"', 1)

    oExcelApp := MsExcel():New()
    oExcelApp:Destroy()
EndIf 

RestArea(aArea)

Return
/*/{Protheus.doc} User Function xClcBon
    (long_description)
    @type  Function
    @author user
    @since 29/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function RelTitGer(aAux)

Local aArea :=  GetArea()
Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= ""
Local nX 
Local cArqXls 	:= "Titulos_Gerados_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local cPeriod   :=  'Titulos'

cDir := cGetFile(, OemToAnsi("Selecione o diretÛrio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

If len(aAux) > 0
    oExcel:AddworkSheet(cPeriod) 

    oExcel:AddTable (cPeriod,cPeriod)
    oExcel:AddColumn(cPeriod,cPeriod,"Vendedor",1,1)
    oExcel:AddColumn(cPeriod,cPeriod,"Nome",1,1)   
    oExcel:AddColumn(cPeriod,cPeriod,"CNPJ",1,1)   
    oExcel:AddColumn(cPeriod,cPeriod,"Fornecedor",1,1)   
    oExcel:AddColumn(cPeriod,cPeriod,"Loja",1,1)
    oExcel:AddColumn(cPeriod,cPeriod,"Competencia",1,1)
    oExcel:AddColumn(cPeriod,cPeriod,"Dia_Pagto",1,1)     
    oExcel:AddColumn(cPeriod,cPeriod,"Numero_titulo",1,1) 
    oExcel:AddColumn(cPeriod,cPeriod,"Valor",1,1) 
    oExcel:AddColumn(cPeriod,cPeriod,"Vencimento",1,1) 
    
    For nX := 1 to len(aAux)

        oExcel:AddRow(cPeriod,cPeriod,{  aAux[nX,01],;
                                        aAux[nX,02],; 
                                        aAux[nX,03],;
                                        aAux[nX,04],;
                                        aAux[nX,05],;
                                        aAux[nX,08],;
                                        cvaltochar(aAux[nX,09]),;
                                        aAux[nX,10],;
                                        Transform(aAux[nX,11],"@E 999,999,999.99"),;
                                        aAux[nX,13]})


    Next nX

    oExcel:Activate()

    oExcel:GetXMLFile(cDir +cArqXls)

    WinExec('Explorer.exe /select,"' + substr(cDir,1,len(cDir)-1) + '"', 1)

    oExcelApp := MsExcel():New()
    oExcelApp:Destroy()
EndIf 

RestArea(aArea)

Return
