#INCLUDE 'PROTHEUS.CH'
#include "fileio.ch"

 /*/{Protheus.doc} TIINCP02
    Rotina responsavel por executar a baixa de titulos a pagar e receber na incorporação reversa da Techfin
    issues  
    https://jiraproducao.totvs.com.br/browse/TIINCIN-2870
    https://jiraproducao.totvs.com.br/browse/TIINCIN-2871

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

User Function TIINCP02(cAcao)

Local aParamBox	:= {}
Local cFilBx    :=  space(11)
Local cEmpBx    :=  space(02)
Local dDteBx    :=  ctod(' / / ')
Local aCombo    :=  {'1=Receber','2=Pagar','3=ATF','4=Contratos'}
Local cCombo    :=  '4'
Local lRet      := .F.
Local cEmp      := ""
Local cFil      := ""

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","10001000100")
EndIf

Private oDlg1,oGrp1,oBtn1,oList,oSay1,oSay2,oSay3,oSay4
Private aList   := {}
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')  
Private aHeader := {}
Private oSelWnd  
Private nVlTot  := 0
Private cMotBC  := "296"

Default cAcao := "PH3"

If cAcao<>"PH3"
    Do Case
        Case cAcao == "RCV1"
            Processa({|| fRCVctr()},"Aguarde...")
        Case cAcao == "RCV2"
            Processa({|| fRCVTit()},"Aguarde...") 
        Case cAcao == "RCV4"
            Processa({|| fRCVLig(1)},"Aguarde...")  
        Case cAcao == "RCV5"
            Processa({|| fRCVLig(2)},"Aguarde...")                        
    EndCase          
    //RPCClearEnv()
    Return Nil
Endif

lRet := SelEmp(@cEmp, @cFil )

If !lRet
    RPCClearEnv()
    Return Nil
Endif

cFilBx := CFILANT
cEmpBx := cEmpAnt
aAdd(aParamBox,{01,"Filial Baixa"	  			,cFilBx 	,""					,"","SM0","", 60,.F.})	// MV_PAR01
aAdd(aParamBox,{01,"Data de baixa"  	   		,dDteBx	    ,""					,"",""	 ,"", 60,.T.})	// MV_PAR02
aAdd(aParamBox,{02,"Tipo de Baixa"              ,cCombo     ,aCombo             ,80,""   ,.F.})
AADD(aParamBox,{01,"Motivo Cancelamento"        ,cMotBC     ,""                 ,"",""   ,"", 60,.F.})

If ParamBox(aParamBox,"Cancelamento Contratos",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
    
    cFilBax := MV_PAR01
    dDtaBax := MV_PAR02 
    cCombo  := MV_PAR03

    If cFilant <> cFilBax
        cFilant := cFilBax
        RpcClearEnv()
        RpcSetType(3)
        RPCSetEnv(cEmpAnt,cFilant)
    EndIf

    //If cCombo $ '1/2/3'
    If !Empty(cCombo)
        Processa({|| LerContr(cFilBax)},"Aguarde...Lendo contratos...")
        //Processa({|| buscatit(cFilBax,cCombo)},"Aguarde")
    EndIf

    If len(aList) < 1
        Aadd(aList,{.F.,'','','','','','','','',0,0,0,'',''})
    EndIf 

    oDlg1      := MSDialog():New( 092,232,836,1706,"Baixas/Cancelamentos",,,.F.,,,,,,.T.,,,.T. )
    oGrp1      := TGroup():New( 000,008,340,724,"Registros",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,012,336,720},,, oGrp1 ) 
        If cCombo $ '1/2'
            oList    := TCBrowse():New(008,012,710,320,, {'','Prefixo','Titulo','Parcela','Tipo','Cliente/Fornec.','Razão Social','Emissão','Vencimento','Valor','Saldo','Recno'},;
                                                            {10,40,60,30,30,50,90,40,40,50,40,30},;
                                                            oGrp1,,,,{|| /*FHelp(oList:nAt)*/},{|| inverte(1)},, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList:SetArray(aList)
            oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),;
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
                                    aList[oList:nAt,12]}}
        Elseif cCombo == '3' 
            //N1_CBASE,N1_ITEM,N1_DESCRIC,N1_QUANTD,N3_CBASE,N3_ITEM,N3_TIPO,N3_BAIXA,N3_TPSALDO,N1_CHAPA
            oList    := TCBrowse():New(008,012,710,320,, {'','Cod.Bem','Item','Descrição','Qtd.','Chapa','Recno'},;
                                                        {10,50,30,90,40,50,50},;
                                                        oGrp1,,,,{|| /*FHelp(oList:nAt)*/},{|| inverte(1)},, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList:SetArray(aList)
            oList:bLine := {||{ If(aList[oList:nAt,11],oOk,oNo),;
                                    aList[oList:nAt,01],; 
                                    aList[oList:nAt,02],;
                                    aList[oList:nAt,03],; 
                                    aList[oList:nAt,04],;
                                    aList[oList:nAt,05],; 
                                    aList[oList:nAt,06],;
                                    aList[oList:nAt,07],;
                                    aList[oList:nAt,08],;
                                    aList[oList:nAt,09],;
                                    aList[oList:nAt,10]  }}
        Else 
            //CN9_NUMERO,CNB_NUMERO,CNB_ITEM,CNB_PRODUT,B1_DESC,CNB_QUANT,CNB_VLUNIT,CNB_VLTOT,CNB_SITUAC,CNB_DATASS,CNB_VIGFIM,CNB_PROPOS
            oList    := TCBrowse():New(008,012,710,320,, {'','Contrato','Revisão','Planilha','Item','Produto','Descrição','Qtd.','Vlr.Tot.','Situac.','Proposta'},;//{'','Contrato','Cliente','Planilha','Item','Produto','Descrição','Qtd.','Vlr.Un.','Vlr.Tot.','Situac.','Dt.Ass.','Fim Vig.','Proposta'},;
                                                        {10,40,40,40,60,90,30,30,30,30,40},;
                                                        oGrp1,,,,{|| /*FHelp(oList:nAt)*/},{|| inverte(1)},, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList:SetArray(aList)
            oList:bLine := {||{ If(aList[oList:nAt,11],oOk,oNo),;
                                    aList[oList:nAt,01],; 
                                    aList[oList:nAt,02],;
                                    aList[oList:nAt,03],; 
                                    aList[oList:nAt,04],;
                                    aList[oList:nAt,05],; 
                                    aList[oList:nAt,06],;
                                    aList[oList:nAt,07],; 
                                    aList[oList:nAt,08],;
                                    aList[oList:nAt,09],;
                                    aList[oList:nAt,10]}} 

        EndIf 


        nVlrTot := 0

        iF cCombo $ '1/2'
            Aeval(aList,{|x| nVlrTot += x[11]})
        Else 
            nVlrTot := len(aList)
        EndIf 
        
        oSay1      := TSay():New( 348,020,{||"Quantidade"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay2      := TSay():New( 348,060,{||cvaltochar(len(aList))},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay3      := TSay():New( 348,168,{||"Valor Total"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay4      := TSay():New( 348,208,{||Transform(nVlTot,"@E 999,999,999.99")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)

    MENU oMenuP POPUP 
    MENUITEM "Marcar/Desmarcar Todos" ACTION (Processa({|| inverte(2)},"Aguarde"))
    ENDMENU                                                                           

    oList:bRClicked := { |oObject,nX,nY| oMenuP:Activate( nX, (nY-10), oObject ) }

    //oBtn1      := TButton():New( 344,686,"oBtn1",oDlg1,,038,012,,,,.T.,,"",,,,.F. )
    oMenu := TMenu():New(0,0,0,0,.T.)
    oTMenuIte1   := TMenuItem():New(oDlg1,"Baixar/Cancelamento Selec.",,,,{|| Processa({|| baixastit(cCombo,cFilBax,dDtaBax),"Buscando informações"})},,,,,,,,,.T.)
    oTMenuIte2   := TMenuItem():New(oDlg1,"Exportar registros",,,,{|| Processa({|| GeraPlan(),"Gerando arquivo"})},,,,,,,,,.T.)
    oTMenuIteA   := TMenuItem():New(oDlg1,"Sair",,,,{|| oDlg1:end()},,,,,,,,,.T.)

    oMenu:Add(oTMenuIte1)
    oMenu:Add(oTMenuIte2)
    oMenu:Add(oTMenuIteA)

    oTButton1 := TButton():New( 344, 686, "Opções",oDlg1,{||},037,12,,,.F.,.T.,.F.,,.F.,,,.F. )
    // Define botão no Menu
    oTButton1:SetPopupMenu(oMenu)     
    
        

    oDlg1:Activate(,,,.T.)
EndIf 

Return


/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 21/11/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function buscatit(cFilTit,cTipo)

Local aArea     :=  GetArea()
Local cQuery 

If cTipo == "1"
    cQuery := "SELECT E1.R_E_C_N_O_ AS RECNOE1,E1.*,A1.*" 
    cQuery += " FROM "+RetSQLName("SE1")+" E1"
    cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=' '"
    cQuery += " WHERE E1_FILIAL='"+cFilTit+"' AND E1_SALDO>0  AND E1.D_E_L_E_T_=' ' AND E1_TIPO NOT LIKE '%-%'"

    
    IF Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    ENDIF

    TIMemoW("TIINCP01.SQL",cQuery)
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")  

    //'','Prefixo','Titulo','Parcela','Tipo','Cliente/Fornec.','Razão Social','Emissão','Vencimento','Valor','Saldo','Recno'

    Aadd(aHeader,{  '',;
                    'E1_PREFIXO',;
                    'E1_NUM',;
                    'E1_PARCELA',;
                    'E1_TIPO',;
                    'E1_CLIENTE',;
                    'A1_NOME',;
                    'E1_EMISSAO',;
                    'E1_VENCREA',;
                    'E1_VALOR',;
                    'E1_SALDO',;
                    'RECNOE1'})
    WHILE !EOF() 
        Aadd(aList,{ .F.,;
                    TRB->E1_PREFIXO,;
                    TRB->E1_NUM,;
                    TRB->E1_PARCELA,;
                    TRB->E1_TIPO,;
                    TRB->E1_CLIENTE,;
                    TRB->A1_NOME,;
                    STOD(TRB->E1_EMISSAO),;
                    STOD(TRB->E1_VENCREA),;
                    TRB->E1_VALOR,;
                    TRB->E1_SALDO,;
                    TRB->RECNOE1})
        Dbskip()
    EndDo 

ElseIf cTipo == "2"
    cQuery := "SELECT E2.R_E_C_N_O_ AS RECNOE2,E2.*,A2.*" 
    cQuery += " FROM "+RetSQLName("SE2")+" E2"
    cQuery += " LEFT JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA AND A2.D_E_L_E_T_=' '"
    cQuery += " WHERE E2_FILIAL='"+cFilTit+"' AND E2_SALDO>0  AND E2.D_E_L_E_T_=' ' AND E2_TIPO NOT LIKE '%-%'"

    
    IF Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    ENDIF

    TIMemoW("TIINCP01.SQL",cQuery)
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")  

    //'','Prefixo','Titulo','Parcela','Tipo','Cliente/Fornec.','Razão Social','Emissão','Vencimento','Valor','Saldo','Recno'

    Aadd(aHeader,{  '',;
                    'E2_PREFIXO',;
                    'E2_NUM',;
                    'E2_PARCELA',;
                    'E2_TIPO',;
                    'E2_FORNECE',;
                    'A2_NOME',;
                    'E2_EMISSAO',;
                    'E2_VENCREA',;
                    'E2_VALOR',;
                    'E2_SALDO',;
                    'RECNOE2'})

    WHILE !EOF() 
        Aadd(aList,{ .F.,;
                    TRB->E2_PREFIXO,;
                    TRB->E2_NUM,;
                    TRB->E2_PARCELA,;
                    TRB->E2_TIPO,;
                    TRB->E2_FORNECE,;
                    TRB->A2_NOME,;
                    STOD(TRB->E2_EMISSAO),;
                    STOD(TRB->E2_VENCREA),;
                    TRB->E2_VALOR,;
                    TRB->E2_SALDO,;
                    TRB->RECNOE2})
        Dbskip()
    EndDo 

ElseIf cTipo == "3"
    cQuery := "SELECT N1_CBASE,N1_ITEM,N1_DESCRIC,N1_QUANTD,N3_CBASE,N3_ITEM,N3_TIPO,N3_BAIXA,N3_TPSALDO,N1_CHAPA,N1.R_E_C_N_O_ AS RECNON1"       
    cQuery += " FROM "+RetSQLName("SN1")+" N1"     
    cQuery += " INNER JOIN "+RetSQLName("SN3")+" N3 ON N3_FILIAL=N1_FILIAL AND N3_CBASE=N1_CBASE AND N3_ITEM=N1_ITEM AND N3.D_E_L_E_T_=' '"       
    cQuery += " WHERE N1_FILIAL='"+cFilTit+"' AND N1.D_E_L_E_T_=' ' AND N1_BAIXA=' '"

    IF Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    ENDIF

    TIMemoW("TIINCP01.SQL",cQuery)
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")  

    //'','Cod.Bem','Item','Descrição','Qtd.','Chapa','Recno'
    Aadd(aHeader,{  '',;
                    'N1_CBASE',;
                    'N1_ITEM',;
                    'N1_DESCRIC',;
                    'N1_QUANTD',;
                    'N1_CHAPA',;
                    'RECNON1',;
                    'N3_CBASE',;
                    'N3_ITEM',;
                    'N3_BAIXA',;
                    'N3_TPSALDO'})
    WHILE !EOF() 
        Aadd(aList,{ .F.,;
                    TRB->N1_CBASE,;
                    TRB->N1_ITEM,;
                    TRB->N1_DESCRIC,;
                    TRB->N1_QUANTD,;
                    TRB->N1_CHAPA,;
                    TRB->RECNON1,;
                    TRB->N3_CBASE,;
                    TRB->N3_ITEM,;
                    TRB->N3_BAIXA,;
                    TRB->N3_TPSALDO})

        Dbskip()
    EndDo 
ElseIf cTipo == "4"
    cQuery := "SELECT CN9_NUMERO,CNB_NUMERO,CNB_ITEM,CNB_PRODUT,B1_DESC,CNB_QUANT,CNB_VLUNIT,CNB_VLTOT,CNB_SITUAC,"
    cQuery += " CNB_DATASS,CNB_VIGFIM,CNB_PROPOS,CNB_PROITN,CN9_REVISA,CN9.R_E_C_N_O_ AS RECNOCN9,CNB.R_E_C_N_O_ AS RECNOCNB"
    cQuery += " FROM   "+RetSQLName("CN9")+" CN9"             
    cQuery += " INNER JOIN "+RetSQLName("CNB")+" CNB"             
    cQuery += "         ON (CNB.CNB_FILIAL = CN9.CN9_FILIAL"             
    cQuery += "     AND CNB.CNB_CONTRA = CN9.CN9_NUMERO"             
    cQuery += "     AND CNB.CNB_REVISA = CN9.CN9_REVISA"             
    cQuery += "     AND CNB.CNB_SITUAC NOT IN('C','O','T')"             
    cQuery += "     AND CNB.CNB_UNINEG='"+cFilTit+"'"             
    cQuery += "     AND CNB.D_E_L_E_T_ = ' ' )"           
    cQuery += " INNER JOIN "+RetSQLName("SB1")+" SB1"         
    cQuery += "         ON (SB1.B1_FILIAL = '"+xFilial("SB1")+"'"         
    cQuery += "     AND CNB.CNB_PRODUT = SB1.B1_COD"         
    cQuery += "     AND SB1.D_E_L_E_T_ = ' ' )"         
    cQuery += " WHERE  CN9.CN9_FILIAL = '"+xFilial("CN9")+"'"             
    cQuery += "     AND CN9.CN9_SITUAC = '05'"             
    cQuery += "     AND CN9.CN9_ESPCTR = '2' "            
    cQuery += "     AND CN9.CN9_REVATU = ' '"           
    cQuery += "     AND CN9.CN9_TPCTO = '013'"             
    cQuery += "     AND CN9.D_E_L_E_T_ = ' ' "


    IF Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    ENDIF

    TIMemoW("TIINCP01.SQL",cQuery)
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")  

    //'','Contrato','Cliente','Planilha','Item','Produto','Descrição','Qtd.','Vlr.Un.','Vlr.Tot.','Situac.','Dt.Ass.','Fim Vig.',Proposta'
    //CN9_NUMERO,CNB_NUMERO,CNB_ITEM,CNB_PRODUT,B1_DESC,CNB_QUANT,CNB_VLUNIT,CNB_VLTOT,CNB_SITUAC,CNB_DATASS,CNB_VIGFIM,CNB_PROPOS

    Aadd(aHeader,{  '',;               
                    'CN9_NUMERO',;     
                    'A1_NOME',;          
                    'CNB_NUMERO',;
                    'CNB_ITEM',;
                    'CNB_PRODUT',;
                    'B1_DESC',;
                    'CNB_QUANT',;
                    'CNB_VLUNIT',;
                    'CNB_VLTOT',;
                    'CNB_SITUAC',;
                    'CNB_DATASS',;
                    'CNB_VIGFIM',;
                    'CNB_PROPOS',;
                    'CNB_PROITN',;
                    'CN9_REVISA',;
                    'RECNOCN9',;
                    'RECNOCNB',;
                    'STATUS_CANC',;
                    'STATUS_BONIF'})

    WHILE !EOF() 
        Aadd(aList,{ .F.,;
                    TRB->CN9_NUMERO,;
                    Posicione("SA1",1,xFilial("SA1")+substr(TRB->CN9_NUMERO,4,6),"A1_NOME"),;
                    TRB->CNB_NUMERO,;
                    TRB->CNB_ITEM,;
                    TRB->CNB_PRODUT,;
                    TRB->B1_DESC,;
                    TRB->CNB_QUANT,;
                    Transform(TRB->CNB_VLUNIT,"@E 999,999,999.99"),;
                    Transform(TRB->CNB_VLTOT,"@E 999,999,999.99"),;
                    TRB->CNB_SITUAC,;
                    stod(TRB->CNB_DATASS),;
                    stod(TRB->CNB_VIGFIM),;
                    TRB->CNB_PROPOS,;
                    TRB->CNB_PROITN,;
                    TRB->CN9_REVISA,;
                    TRB->RECNOCN9,;
                    TRB->RECNOCNB,;
                    '',;
                    ''})

        Dbskip()
    EndDo 

    Asort(aList,,,{|x,y| x[2] < y[2]})
EndIF 

RestArea(aArea)

Return

/*/{Protheus.doc} inverte
    (long_description)
    @type  Static Function
    @author user
    @since 21/11/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function inverte(nOpc)

Local nX := 0

If nOpc == 1
    If aList[oList:nAt,11]
        aList[oList:nAt,11] := .F.
    Else 
        aList[oList:nAt,11] := .T.
    EndIf
Else 
    For nX := 1 to len(aList)
        If aList[nx,11]
            aList[nX,11] := .F.
        Else 
            aList[nX,11] := .T.
        EndIf 

    Next nX 
EndIf 

oList:refresh()
oDlg1:refresh()

Return 

/*/{Protheus.doc} baixase1
    Baixar titulos no contas a receber
    @type  Static Function
    @author user
    @since 22/11/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function baixastit(cCombo,cFilBax,dDtaBax)

Local aArea     :=  GetArea()
Local aParam    :=  {}
Local cBanco    :=  space(3)
Local cAgencia  :=  space(6)
Local cConta    :=  space(9)
Local nX        :=  0
Local carquivo  :=  'baixas_cancel_'+DTOS(DDATABASE)+STRTRAN(TIME(),":")+'.txt'
Local cMotivo   :=  "10"
Local cMetDepr  :=  GetMV('MV_ATFDPBX')
Local nMV_LJMULTA := GETMV("MV_LJMULTA")/100
Local cTipo     := "01"
Local aRecCNB   := {}

//Local cNumNF    :=  ""
//Local cSerieNF  :=  ""
//Local nValNF    :=  0

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

Private nHandlel	:=	0 

If !ExistDir('C:\LOG_BAIXA\')
    Makedir('C:\LOG_BAIXA\')
EndIf

nHandlel := TIFCreate('C:\LOG_BAIXA\'+carquivo, FO_READWRITE + FO_SHARED )

If cCombo $ '1/2'
    aAdd(aParam,{01,"Banco"	  			,cBanco 	,""					,"","SA6","", 60,.T.})	
    aAdd(aParam,{01,"Agência"  	   		,cAgencia	,""					,"",""	 ,"", 60,.F.})	
    aAdd(aParam,{01,"Conta"             ,cConta     ,""                 ,"",""   ,"", 60,.F.})

    If ParamBox(aParam,"Informe os dados da conta",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
        cBanco      :=  MV_PAR01
        cAgencia    :=  MV_PAR02
        cConta      :=  MV_PAR03

        DbSelectArea("SA6")
        DbSetOrder(1)
        If DbSeek(xFilial("SA6")+Avkey(cBanco,"A6_COD")+Avkey(cAgencia,"A6_AGENCIA")+Avkey(cConta,"A6_CONTA"))

            If cCombo == "1"
                DbSelectArea("SE1")
                DbSetOrder(1)
                
                For nX := 1 to len(aList)
                    If aList[nX,01]
                        If Dbseek(cFilBax+Avkey(aList[nX,02],"E1_PREFIXO")+Avkey(aList[nX,03],"E1_NUM")+Avkey(aList[nX,04],"E1_PARCELA")+Avkey(aList[nX,05],"E1_TIPO"))
                            _nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

                            DDATABASE := SE1->E1_VENCREA
                            aBaixa := {}
                            nDiasAt:= dDtaBax - SE1->E1_VENCREA 
                            nJurBx := 0
                            nJuros := 0

                            If nDiasAt > 0
                                nJuros := ROUND(SE1->E1_VALJUR * nDiasAt,2)
                                nMulta := SE1->E1_SALDO * nMV_LJMULTA
                                nJurBx := nJuros + nMulta 
                            endIf
                                                                                                                                                                                                                                                                                                                        
                            aBaixa := { {"E1_FILIAL"   ,cFilBax                                 ,Nil    },;
                                        {"E1_PREFIXO"  ,Avkey(aList[nX,02],"E1_PREFIXO")        ,Nil    },;
                                        {"E1_NUM"      ,aList[nX,03]		                    ,Nil    },;
                                        {"E1_TIPO"     ,Avkey(aList[nX,05],"E1_TIPO")           ,Nil    },;
                                        {"E1_PARCELA"  ,Avkey(aList[nX,04],"E1_PARCELA")        ,Nil    },;
                                        {"AUTMOTBX"    ,"TRA"                                   ,Nil    },;
                                        {"AUTBANCO"    ,cBanco                                  ,Nil    },;
                                        {"AUTAGENCIA"  ,Avkey(cAgencia,"A6_AGENCIA")            ,Nil    },;
                                        {"AUTCONTA"    ,Avkey(cConta,"A6_NUMCON")               ,Nil    },;
                                        {"AUTDTBAIXA"  ,SE1->E1_VENCREA /*dDtaBax*/                                ,Nil    },;
                                        {"AUTDTCREDITO",SE1->E1_VENCREA /*dDtaBax*/                                 ,Nil    },;
                                        {"AUTHIST"     ,"TRANSF. TIT. SUPPLIER"                 ,Nil    },;
                                        {"AUTJUROS"    ,0                                       ,Nil,.T.},;
                                        {"AUTDESCONT"  ,0 /*nJurB*/                             ,Nil,.T.},;
                                        {"AUTVALREC"   ,SE1->E1_SALDO-_nVlrAbat  /*aList[nX,11] - nJuros*/               ,Nil    }}
        /*
                                        {"AUTDESCONT"  ,0                                       ,Nil,.T.},;
                                        {"AUTVALREC"   ,aList[nX,11] + nJurBx                   ,Nil    }}
        */                                
        /*                                {"AUTDESCONT"  ,nJurBx                                  ,Nil,.T.},;
                                        {"AUTVALREC"   ,aList[nX,11] - nJuros                   ,Nil    }}
        */
                            lMsErroAuto := .F.

                            MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)                  

                            If lMsErroAuto
                                cMensagem := GetErro()
                            else
                                cMensagem := "Baixa realizada com sucesso"
                            EndIf

                            FWrite(nHandlel,cFilBax+Avkey(aList[nX,02],"E1_PREFIXO")+Avkey(aList[nX,03],"E1_NUM")+Avkey(aList[nX,04],"E1_PARCELA")+Avkey(aList[nX,05],"E1_TIPO")+CRLF,10000)
                            FWrite(nHandlel,cMensagem+CRLF,10000)
                            
                        Else 
                            cMensagem := "Titulo nao encontrado"
                            FWrite(nHandlel,cFilBax+Avkey(aList[nX,02],"E1_PREFIXO")+Avkey(aList[nX,03],"E1_NUM")+Avkey(aList[nX,04],"E1_PARCELA")+Avkey(aList[nX,05],"E1_TIPO")+CRLF,10000)
                            FWrite(nHandlel,cMensagem+CRLF,10000)
                            
                        EndIf  
                    EndIF
                Next nX 

            else

                DbSelectArea("SE2")
                DbSetOrder(1)

                For nX := 1 to len(aList)
                    If aList[nX,01]
                        If Dbseek(cFilBax+Avkey(aList[nX,02],"E2_PREFIXO")+Avkey(aList[nX,03],"E2_NUM")+Avkey(aList[nX,04],"E2_PARCELA")+Avkey(aList[nX,05],"E2_TIPO"))

                            aBaixa := {}        

                            Aadd(aBaixa, {"E2_FILIAL"   , cFilBax                       ,  nil})
                            Aadd(aBaixa, {"E2_PREFIXO"  , SE2->E2_PREFIXO               ,  nil})
                            Aadd(aBaixa, {"E2_NUM"      , SE2->E2_NUM                   ,  nil})
                            Aadd(aBaixa, {"E2_PARCELA"  , SE2->E2_PARCELA               ,  nil})
                            Aadd(aBaixa, {"E2_TIPO"     , SE2->E2_TIPO                  ,  nil})
                            Aadd(aBaixa, {"E2_FORNECE"  , SE2->E2_FORNECE               ,  nil})
                            Aadd(aBaixa, {"E2_LOJA"     , SE2->E2_LOJA                  ,  nil})
                            Aadd(aBaixa, {"AUTMOTBX"    , "TRA"                         ,  nil})
                            Aadd(aBaixa, {"AUTBANCO"    , cBanco                        ,  nil})
                            Aadd(aBaixa, {"AUTAGENCIA"  , Avkey(cAgencia,"A6_AGENCIA")  ,  nil})
                            Aadd(aBaixa, {"AUTCONTA"    , Avkey(cConta,"A6_NUMCON")     ,  nil})
                            Aadd(aBaixa, {"AUTDTBAIXA"  , dDtaBax                       ,  nil})
                            Aadd(aBaixa, {"AUTDTCREDITO", dDtaBax                       ,  nil})
                            Aadd(aBaixa, {"AUTHIST"     , "TRANSF. TIT. SUPPLIER"       ,  nil})
                            Aadd(aBaixa, {"AUTVLRPG"    , aList[nX,11]                  ,  nil})

                            //Pergunte da rotina
                            AcessaPerg("FINA080", .F.)         

                            nOpc := 3
                            //, nSeqBx
                            //Chama a execauto da rotina de baixa manual (FINA080)
                            MsExecauto({|x,y,z,v| FINA080(x,y,z)}, aBaixa, nOpc, .F.)
                            
                            If lMsErroAuto
                                cMensagem := GetErro()
                            else
                                cMensagem := "Baixa realizada com sucesso"
                            EndIf

                            FWrite(nHandlel,cFilBax+Avkey(aList[nX,02],"E2_PREFIXO")+Avkey(aList[nX,03],"E2_NUM")+Avkey(aList[nX,04],"E2_PARCELA")+Avkey(aList[nX,05],"E2_TIPO")+CRLF,10000)
                            FWrite(nHandlel,cMensagem+CRLF,10000)
                        else
                            cMensagem := "Titulo nao encontrado"
                            FWrite(nHandlel,cFilBax+Avkey(aList[nX,02],"E2_PREFIXO")+Avkey(aList[nX,03],"E2_NUM")+Avkey(aList[nX,04],"E2_PARCELA")+Avkey(aList[nX,05],"E2_TIPO")+CRLF,10000)
                            FWrite(nHandlel,cMensagem+CRLF,10000)
                            
                        EndIf
                    EndIf  
                Next nX
            
            EndIf 

        else
            MsgAlert("Banco/Agencia/Conta não encontrada")
        EndIf 

    EndIf 
ElseIf cCombo == '3'

    For nX := 1 to len(aList)
        If aList[nX,01]

            aCab := {   {"FN6_FILIAL",cFilBax           ,NIL},;
                        {"FN6_CBASE" ,aList[nX,02]      ,NIL},;
                        {"FN6_CITEM" ,aList[nX,03]      ,NIL},;
                        {"FN6_MOTIVO",cMotivo           ,NIL},;
                        {"FN6_BAIXA" ,100               ,NIL},;
                        {"FN6_QTDBX" ,aList[nX,03]      ,NIL},;
                        {"FN6_DTBAIX",dDtaBax           ,NIL},;
                        {"FN6_DEPREC",cMetDepr          ,NIL}}
            
            aAtivo := { {"N3_FILIAL"    ,cFilBax        ,NIL},;
                        {"N3_CBASE"     ,aList[nX,08]   ,NIL},;
                        {"N3_ITEM"      ,aList[nX,09]   ,NIL},;
                        {"N3_TIPO"      ,cTipo          ,NIL},;
                        {"N3_BAIXA"     ,aList[nX,10]   ,NIL},;
                        {"N3_TPSALDO"   ,aList[nX,11]   ,NIL}}
            
            //Array contendo os parametros do F12
            aAdd( aParam, {"MV_PAR01", 2} ) //Pergunta 01 - Mostra Lanc. Contab? 1 = Sim ; 2 = Não
            aAdd( aParam, {"MV_PAR02", 2} ) //Pergunta 02 - Aglutina Lancamento Contabil ? 1 = Sim ; 2 = Não
            aAdd( aParam, {"MV_PAR03", 2} ) //Pergunta 03 - Contabaliza On-Line? 1 = Sim ; 2 = Não
            aAdd( aParam, {"MV_PAR04", 2} ) //Pergunta 04 - Visualização ? 2 = Tipos de Ativos   // deve se usar obrigatoriamente o número 2
            
            Begin Transaction

            MsExecAuto({|a,b,c,d,e,f|ATFA036(a,b,c,d,e,f)},aCab,aAtivo,3,,.T./*lBaixaTodos*/,aParam)

            If lMsErroAuto
                cMensagem := GetErro()
            else
                cMensagem := "Baixa realizada com sucesso"
            EndIf

            FWrite(nHandlel,cFilBax+Avkey(aList[nX,02],"N1_CBASE")+Avkey(aList[nX,03],"N1_ITEM")+CRLF,10000)
            FWrite(nHandlel,cMensagem+CRLF,10000)

            End Transaction
        EndIf 
    Next nX
Else 

    For nX := 1 to len(aList)
        If aList[nX,11] //If aList[nX,01]
            cItSeq := maxItSeq(aList[nX,01],aList[nX,03]) //cItSeq := maxItSeq(aList[nX,02],aList[nX,03])
            /*  1    .F.,;
                2    TRB->CN9_NUMERO,;
                3    Posicione("SA1",1,xFilial("SA1")+substr(TRB->CN9_NUMERO,4,6),"A1_NOME"),;
                4    TRB->CNB_NUMERO,;
                5    TRB->CNB_ITEM,;
                6    TRB->CNB_PRODUT,;
                7    TRB->B1_DESC,;
                8    TRB->CNB_QUANT,;
                9    Transform(TRB->CNB_VLUNIT,"@E 999,999,999.99"),;
                10    Transform(TRB->CNB_VLTOT,"@E 999,999,999.99"),;
                11    TRB->CNB_SITUAC,;
                12    stod(TRB->CNB_DATASS),;
                13    stod(TRB->CNB_VIGFIM),;
                14    TRB->CNB_PROPOS,;
                15    TRB->CNB_PROITN,;
                16    TRB->CN9_REVISA
                17    TRB->CNB_STATUS*/

            Begin Transaction

            lContinua := ProgCanc(aList[nX],nX)  //19
            //lContinua2:= BoniCar(aList[nX],nX)     //20

            If lContinua //.And. lContinua2
                cMensagem := "Programação de cancelamento realizada com sucesso"
            
                /* 
                cCmp := cvaltochar(ddatabase)
                cCmp := substr(cCmp,4)*/
                cCmp := SubStr(dtos(ddtabax),5,2)+"/"+SubStr(dtos(ddtabax),1,4) //cCmp := '01/2024'
                
                Reclock("PH3",.T.)
                PH3->PH3_FILIAL :=  xFilial("PH3")
                PH3->PH3_CONTRA :=  aList[nX,01]
                PH3->PH3_REVISA :=  aList[nX,02]
                PH3->PH3_NUMERO :=  aList[nX,03]
                PH3->PH3_ITSEQ  :=  cItSeq
                PH3->PH3_STATUS :=  'C' 
                PH3->PH3_ITEM   :=  aList[nX,04]
                PH3->PH3_PRODUT :=  aList[nX,05]
                PH3->PH3_PROPOS :=  aList[nX,10]
                PH3->PH3_QUANT  :=  Val(aList[nX,07])
                PH3->PH3_SITUAC :=  aList[nX,09]
                PH3->PH3_STATRM :=  '003'
                PH3->PH3_CMPSOL :=  cCmp
                PH3->PH3_CMPCAN :=  cCmp
                PH3->PH3_QTDCAN :=  Val(aList[nX,07])
                PH3->PH3_MOTBC  :=  '296' //'295'
                PH3->PH3_OBS    :=  'CANC. MIGRACAO HOSPITALITY'
                PH3->PH3_DATA   :=  DDATABASE
                PH3->PH3_MSBLQL :=  '2'
                PH3->PH3_MSEMP  :=  cEmpAnt // MEXICO
                PH3->PH3_MSFIL  :=  cFilAnt // MEXICO
                PH3->PH3_GRUPO  :=  cEmpAnt// MEXICO
                PH3->PH3_UNINEG :=  cFilAnt // MEXICO
                PH3->PH3_QTDSLD :=  Val(aList[nX,07])
                PH3->PH3_CMPINI :=  cCmp
                PH3->PH3_CHAMAD := 'TRANSF S'
                PH3->PH3_PERIOD := '000'
                PH3->(Msunlock())

                

                FWrite(nHandlel,cFilAnt+Avkey(aList[nX,01],"CNB_CONTRA")+Avkey(aList[nX,03],"CNB_NUMERO")+Avkey(aList[nX,04],"CNB_ITEM")+CRLF,10000)
                
                //aList[nX,19] += cMensagem
                  
                FWrite(nHandlel,cMensagem+CRLF,10000)
                //CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM
                //nRecCNB := GetAdvFVal("CNB",{"R_E_C_N_O_"},FwXFilial("CNB") + PADR(aList[nX,01],TamSx3("CNB_CONTRA")[1]) + PADR(aList[nX,02],TamSx3("CNB_REVISA")[1]) + PADR(aList[nX,03],TamSx3("CNB_NUMERO")[1]) + PADR(aList[nX,04],TamSx3("CNB_ITEM")[1]),1,"")
                //GetAdvFVal("CNB",,xFilial("CNB")+"CONT25606      ",1,"")
                AADD(aRecCNB,TrazCNB(PADR(aList[nX,01],TamSx3("CNB_CONTRA")[1]), PADR(aList[nX,02],TamSx3("CNB_REVISA")[1]), PADR(aList[nX,03],TamSx3("CNB_NUMERO")[1]),  PADR(aList[nX,04],TamSx3("CNB_ITEM")[1])))
            EndIf
            
            End Transaction
            
            
        EndIf 
    Next nX
    aArea := GetArea()    
    For nX:=1 to Len(aRecCNB)
        CNB->( dbgoto(aRecCNB[nX]) )
        RecLock("CNB",.F.)
        CNB->CNB_STATRM := '003'
        CNB->CNB_SITUAC := 'C'
        CNB->( MSUNLOCK() )
    Next Nx
    RestArea(aArea)
EndIf 

Fclose(nHandlel)


WinExec('NOTEPAD '+ 'C:\LOG_BAIXA\'+carquivo,1)
Geraplan()

RestArea(aArea)
FWAlertSuccess("Fim do processamento !")
Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 24/11/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GetErro()

Local cPath	:= GetSrvProfString("Startpath","")
Local cArq	:= "Erro_Rot_Auto_"+Dtos(dDataBase)+"_"+StrTran(Time(),":","_")+Alltrim(Str(ThreadID()))+".txt"
Local cRet	:= ""

MostraErro( cPath , cArq )

cRet := StrTran(TIMemoR(  cPath + '\' + cArq ),Chr(13) + Chr(10)," ")
cRet := StrTran(cRet, '"', "'")

fErase(cArq)

Return cRet


/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function maxItSeq(cContr,cPlan)

Local cQuery:= ''
Local cRet  := ''

cQuery := "SELECT MAX(PH3_ITSEQ) AS PROX FROM "+RetSQLName("PH3")     
cQuery += " WHERE PH3_FILIAL='"+xFilial("PH3")+"' AND PH3_CONTRA='"+cContr+"' AND PH3_NUMERO='"+cPlan+"' AND D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

TIMemoW("TIINCP01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

cRet := strzero(val(TRB->PROX)+1,6)

Return(cRet)

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
Local cArqXls 	:= "exportar"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}

Local cInterno  :=  'DADOS'

cDir := TIGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet(cInterno) 
oExcel:AddTable (cInterno,cInterno)

// MEXICO
aHeader := {'Contrato','Revisão','Planilha','Item','Produto','Descrição','Qtd.','Vlr.Tot.','Situac.','Proposta'}
For nX := 1 to len(aHeader)
    oExcel:AddColumn(cInterno,cInterno,aHeader[nX],1,1)
Next nX


For nX := 1 to len(aList)   
    If aList[nX,11]
        aAux := {}
        For nY := 1 to len(aHeader)
            Aadd(aAux,aList[nX,nY])
        Next nY

        oExcel:AddRow(cInterno,cInterno,aAux)
    EndIf 
Next nX

oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
oExcelApp:SetVisible(.T.)        
oExcelApp:Destroy()

	
    
Return(cDir+cArqXls)

/*/{Protheus.docn ProgCanc

    @type  Static Function
    @author user
    @since 21/12/2023
    @version version
    @param aAux = aList (array contendo os contratos) || nLinha = Item da CNB
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ProgCanc(aAux,nLinha)

Local aArea   := GetArea()
Local aArea2
Local cQuery 
Local lRet    := .T.
Local aRecph3 := {}
Local nX
Local aRecCNB := {}

Default cSituac    := '05'

cQuery := "SELECT /*+ PARALLEL(8) */  * FROM "+RetSQLName("PH3")
cQuery += " WHERE PH3_FILIAL='"+xFilial("PH3")+"'"
cQuery += " AND PH3_CONTRA='"+aAux[1]+"' AND PH3_NUMERO='"+aAux[3]+"'"
cQuery += " AND PH3_ITEM='"+aAux[4]+"' AND PH3_PRODUT='"+alltrim(aAux[5])+"'"
cQuery += " AND PH3_REVISA='"+aAux[2]+"' AND D_E_L_E_T_=' '"

/*
cQuery := "SELECT * FROM "+RetSQLName("PH3")
cQuery += " WHERE PH3_FILIAL='"+xFilial("PH3")+"'"
cQuery += " AND PH3_CONTRA='"+aAux[2]+"' AND PH3_NUMERO='"+aAux[4]+"'"
cQuery += " AND PH3_ITEM='"+aAux[5]+"' AND PH3_PRODUT='"+alltrim(aAux[6])+"'"
cQuery += " AND PH3_REVISA='"+aAux[16]+"' AND D_E_L_E_T_=' '"
*/
IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

TIMemoW("TIINCP02.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    If TRB->PH3_STATUS == 'P'

        cMensagem := ''

        If SubStr(dtos(ddtabax),1,4) $ TRB->PH3_CMPCAN .And. !SubStr(dtos(ddtabax),5,2)+"/"+SubStr(dtos(ddtabax),1,4) $ TRB->PH3_CMPCAN
            cMensagem += 'Contrato '+aAux[1]+' - Planilha '+aAux[3]+' - Item '+aAux[4]+' - Estava com programação de cancelamento para a competencia '+TRB->PH3_CMPCAN+' com o motivo '+TRB->PH3_MOTBC+CRLF
            Aadd(aRecph3,TRB->R_E_C_N_O_)
            lRet := .F.
        Else
            cMensagem += 'Contrato '+aAux[1]+' - Planilha '+aAux[3]+' - Item '+aAux[4]+' - Com programação de cancelamento para a competencia '+TRB->PH3_CMPCAN
        EndIf 
        
        //aList[nLinha,19] += cMensagem

        FWrite(nHandlel,cMensagem+CRLF,10000)
        AADD(aRecCNB,TrazCNB(PADR(TRB->PH3_CONTRA,TamSx3("CNB_CONTRA")[1]), PADR(TRB->PH3_REVISA,TamSx3("CNB_REVISA")[1]), PADR(TRB->PH3_NUMERO,TamSx3("CNB_NUMERO")[1]),  PADR(TRB->PH3_ITEM,TamSx3("CNB_ITEM")[1])))    
    EndIf
    Dbskip()
EndDo 

If !lRet
    
    For nX := 1 to len(aRecph3)
        DbSelectArea('PH3')
        Dbgoto(aRecph3[nX])
        Reclock("PH3",.F.)
        PH3->PH3_CMPSOL := '12/2024' //PH3->PH3_CMPSOL := '01/2024'
        PH3->PH3_CMPCAN := '12/2024' //PH3->PH3_CMPCAN := '01/2024'
        PH3->PH3_CMPINI := '12/2024' //PH3->PH3_CMPINI := '01/2024'
        PH3->PH3_MOTBC  := '296' //'295' // Talvez tenha que mudar esse código de motivo de cancelamento
        PH3->PH3_STATUS :=  'C'
        PH3->(Msunlock())
    Next nX
Endif
aArea2 := GetArea()
For nX :=1 to Len(aRecCNB)
    CNB->( dbgoto(aRecCNB[nX]) )
    RecLock("CNB",.F.)
    CNB->CNB_STATRM := '003'
    CNB->CNB_SITUAC := 'C'
    CNB->( MSUNLOCK() )
Next nX
RestArea(aArea2)
    /*
    DbSelectArea("CN9")
    MsSeek(xFilial("CN9")+Alltrim(aAux[1])) //MsSeek(xFilial("CN9")+Alltrim(aAux[2]))
    aAMSave := {'2024','11'} //aAMSave := {'2023','12'}
    U_GCVA095A(CN9->CN9_NUMERO, aAMSave, @cMsgErro, NIL   , NIL       , NIL       , NIL       , NIL       , NIL    , lDelPH5, Nil     , Nil    , cSituac) 
    */

RestArea(aArea)
   
Return(lRet)

/*
Função para chamar a leitura do arquivo CSV com os contratos
*/

Static Function LerContr(cFilBax)
Local aArea     := GetArea()
Local cPathGCT  := ""
//Local aRet      := {}

Private oProcCN
//Private aBrwCN := {}

cPathGCT := TIGetFile("Arquivos CSV|*.CSV", OemToAnsi("Selecione a pasta com os contratos a serem cancelados"),0,"SERVIDOR\",.T.,GETF_LOCALHARD + GETF_NETWORKDRIVE+ GETF_RETDIRECTORY)         
oProcCN := MsNewProcess():New({|| fLoadCsv(@aList,cPathGCT,oProcCN)}, "Carregando arquivos a importar...", "Aguarde...", .T.)
oProcCN:Activate()

RestArea(aArea)
Return Nil


/*/{Protheus.doc} fLoadcsv
   Carrega o array aList contendo os itens de contratos a serem cancelados
   @type  Static Function
   @author Julio Saraiva
   @since 06/12/2024
   @version version
   @param aList
   @return 
   @example
   (examples)
      fLoadCsv(@aList,cPathGCT,oObjP)
/*/

Static Function fLoadcsv(aList,cPathGCT,oObjP)

Local aArqs    := {}
Local aArea    := GetArea()
Local nHdl	   := 0
Local nCnt     := 0
Local cFile    := ""
Local cBuffer  := ""
Local nAtual   := 1

aArqs := Directory(cPathGCT + "*.CSV*")

If Len(aArqs) > 0
   nCnt++
Endif

If nCnt > 0

   cFile	:= cPathGCT  + aArqs[nCnt][1]
   nHdl	:= TIFuse( cFile )
   nCnt := 0
   oObjP:SetRegua1(FT_FLastRec())
   While !FT_FEof()
      nCnt++
      cBuffer  := FReadLine()
      If nCnt > 1
        AADD(aList, aBIToken(NoAcento(cBuffer), ';',.F.))
        AADD(aList[nAtual],.T.)
      
        FT_FSkip()
        oObjP:IncRegua1("Importando contratos " + cValToChar(nAtual) + " de " + cValToChar(FT_FLastRec()) + "...")
        oObjP:IncRegua2("Importando Contrato " + aList[nAtual,01] + " / " + aList[nAtual,05] + " ...")      
        PROCESSMESSAGES()
        nVltot += Val(aList[nAtual,08])
        nAtual++        
      Else
        FT_FSkip()
      Endif
   EndDo

   FClose(nHdl)

Else
   FWAlertError("Arquivos CSV com os contratos não lida !")
Endif

RestArea(aArea)
Return NIL

//-------------------------------------------------------------------
/*/{Protheus.doc} FReadLine
Funcao para leitura de linhas com o tamanho superior a 1023

@author Norbert/Ernani/Mansano
@since 05/10/05
@return NIL
/*/
//-------------------------------------------------------------------
Static Function FReadLine()
	Local cLinhaTmp  := ""
	Local cLinhaM100 := ""
	Local cLinAnt    := ""
	Local cLinProx   := ""
	Local cIdent     := ""
    Local cFun       := "FT" + "_" + "FREAD" + "LN()"

	//cLinhaTmp	:= FT_FReadLN()
    cLinhaTmp	:= &(cFun)
	If !Empty(cLinhaTmp)
		cIdent	:= MD5(cLinhaTmp,2)
		If Len(cLinhaTmp) < 1023
			cLinhaM100	:= cLinhaTmp
		Else
			cLinAnt		:= cLinhaTmp
			cLinhaM100	+= cLinAnt

			Ft_FSkip()
			//cLinProx:= Ft_FReadLN()
            cLinProx:= &(cFun)
			If Len(cLinProx) >= 1023 .and. MD5(cLinProx,2) <> cIdent
				While Len(cLinProx) >= 1023 .and. MD5(cLinProx,2) <> cIdent .and. !Ft_fEof()
					cLinhaM100 += cLinProx
					Ft_FSkip()
					//cLinProx := Ft_fReadLn()
                    cLinProx := &(cFun)
					If Len(cLinProx) < 1023 .and. MD5(cLinProx,2) <> cIdent
						cLinhaM100 += cLinProx
					EndIf
				Enddo
			Else
				cLinhaM100 += cLinProx
			EndIf
		EndIf
	EndIf
Return cLinhaM100

//--------------------------------------------------
/*/{Protheus.doc} NoAcento
Retira os acentos.
/*/
//--------------------------------------------------
Static Function NoAcento(cString)
	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
	Local cTio   := "ãõ"+"ÃÕ"
	Local cCecid := "çÇ"
	Local cDiversos	:= "'><ï»¿"

	cDiversos += '"'
	cString := STRTRAN(cString,"	","")
	cString := STRTRAN(cString,"ï»¿","")
	cString := STRTRAN(cString,"¿","")

	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		If cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase+cDiversos
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("ao",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
			nY:= At(cChar,cDiversos)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("",nY,1))
			EndIf
		EndIf
	Next

	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		If Asc(cChar) <> 9 // Para não fubistituir tab por ponto
			If Asc(cChar) < 32 .Or. Asc(cChar) > 123 .Or. cChar $ '&'
				cString:=StrTran(cString,cChar,".")
			EndIf
		EndIf
	Next nX

	cString := _NoTags(cString)

Return cString


/*/{Protheus.doc} TrazCNB
   Traz o recno da CNB do contrato informado
   @type  Static Function
   @author Julio Saraiva
   @since 10/12/2024
   @version version
   @param contrato + revisao + planiha + item
   @return 
   @example
   (examples)
/*/

Static Function TrazCNB(cContra,cRevisa,cNumero,cItem)
Local nRecCNB   := 0
Local aArea     := GetArea()

DbSelectArea("CNB")
CNB->( dbSetOrder(1) )

If dbSeek(xFilial() + cContra + cRevisa + cNumero + cItem)
    nRecCNB := CNB->(Recno())
Endif

RestArea(aArea)
Return nRecCNB

	/*
	/* Seleção de empresas */
	/*                     */

Static Function SelEmp(cEmp,cFil,oSelWnd)
    Local oModal
    Local lOk				:= .F.
    Local oCbxEmp
    Local cEmpAtu			:= ""
    Local aCbxEmp			:= {}
    Local npB
    Local npT
    Local lRet

    OpenSm0()
    dbSelectArea("SM0")
    SM0->(DbGotop())
    While ! SM0->(Eof())
        Aadd(aCbxEmp,SM0->M0_CODIGO + '/' + SM0->M0_CODFIL + ' - ' + Alltrim(SM0->M0_NOME) + ' / ' + SM0->M0_FILIAL)
        SM0->(DbSkip())
    EndDo
    oFont := TFont():New('Arial',, -11, .T., .T.)
    oModal  := FWDialogModal():New()       
    oModal:SetEscClose(.f.)
    oModal:setTitle("Ambiente ")
    oModal:setSize(100, 200)
    oModal:createDialog()
    oModal:AddButton("OK",      {|| lOk := .t., oModal:DeActivate()}     , "OK",,.T.,.F.,.T.,)
	oModal:AddButton("Cancelar",{|| lOk := .F., oModal:DeActivate()}     , "Cancelar",,.T.,.F.,.T.,)

    @ 010,005 Say "Selecione a Empresa:" PIXEL of oModal:getPanelMain()  FONT oFont //
    @ 018,005 MSCOMBOBOX oCbxEmp VAR cEmpAtu ITEMS aCbxEmp SIZE 190,10 OF oModal:getPanelMain() PIXEL

    oModal:Activate()
		
    If lOk
        npB     := at("/", cEmpAtu)
        cEmp    := Left(cEmpAtu, npB - 1)
        cEmpAtu := Subs(cEmpAtu, npB + 1)
        npT     := at("-", cEmpAtu)
        cFil    := Left(cEmpAtu, npT - 3)

        RpcClearEnv()
        RpcSetType(3)

        Processa({||lRet := RpcSetEnv(cEmp, cFil,,,,,) }, "Aguarde...", "Montando Ambiente. Empresa [" + cEmp + "] Filial [" + cFil +"]."  )
        If !lRet
            MsgAlert("Não foi possível montar o ambiente selecionado. " )
		Else
			cEmpAnt := cEmp
			cFilAnt := cFil
        EndIf
    EndIf 
	oModal:Deactivate()
    Return lRet



 /*/{Protheus.doc}fRCVctr
Funcao responsavel por enviar  para o interceptor P37 os dados dos contratos  emitidos nos ultimos 3 dias
@type  Function
@author  Cassio Menabue Lima
@since 27/02/2023
@version 1.0
 /*/
Static Function fRCVctr( nOp)

	Local cTrbAre    := ''
	Local cTjp       := GetNextAlias()
	Local nQtdThread := 1
	Local lRet       := .T.
	Local nQtdReg    := 0
	Local nQuebra    := 0
	Local cParHor0	 := 0
	Local cParHor1	 :=	0
	Local cParHor2	 :=	0
	Local cParHrD0	 :=	""
	Local cParHrD1	 :=	""
	Local cParHrD2	 :=	""
	Local cHrIn 	 := ""
	Local aBoxParam  := {}
	Local aRetParam  := {}
	Local nDias      := 0
	Local cHora   	 :=  substr(cvaltochar(time()),1,2)
	Local aLinhas    := { }
	Local cFilBkp    := cFilAnt
	Local dDtBsBkp   := dDataBase
	Default nOp      := 0

	If U_RCVENV(cEmpAnt,cFilAnt)

		IF(nOp ==  1)
		
			cParHor0	:=	SuperGetmv('TI_RCVGCT1'   ,.F., 1     )
			cParHor1	:=	SuperGetmv('TI_RCVGCT2'   ,.F., 2     )
			cParHor2	:=	SuperGetmv('TI_RCVGCT3'   ,.F., 3     )
			cParHrD0	:=	SuperGetmv('TI_RCVGCH1'   ,.F., "19"  )
			cParHrD1	:=	SuperGetmv('TI_RCVGCH2'   ,.F., "20"  )
			cParHrD2	:=	SuperGetmv('TI_RCVGCH3'   ,.F., "21"  )
			cHrIn 		:=  cParHrD0+"|"+cParHrD1+"|"+cParHrD2

			IF (cHora $ cHrIn)//Roda somente para essas horas
				nDias  := Iif(cHora $ cParHrD0,cParHor0,Iif(cHora $ cParHrD1,cParHor1,cParHor2))
				dDatabase := ddatabase - nDias
			Else
				Return
			EndIF
		Else
			aAdd(aBoxParam, {1 ,"Filial", cFilAnt , "", ".T." , "" ,".F." ,  60 , .T.})  
			//Aadd(aBoxParam, {1, "Data da emissão de títulos", dDataBase,"@D"	,"","",".F.", 60, .F.})		
			IF ParamBox(aBoxParam, "Reenvio de Contratos - Parâmetros", @aRetParam)
				cFilAnt := aRetParam[1]
				//dDataBase:=aRetParam[2]
			Else
				Return
			EndIF
		EndIF

		nQuebra    := GetMv("TI_RCVQB02",,200)
		nQtdThread := GetMv("TI_RCVQT02",,15)
		cTrbAre    := TRCVQRY(nOp)
		If TCCanOpen(cTrbAre)
			cQcc := "SELECT MAX(RECLRT) RECLRT FROM" + cTrbAre
			cQcc:= ChangeQuery(cQcc)
			if Select(cTjp) >0
				(cTjp)->(dbCloseArea())
			EndIF
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQcc),cTjp,.T.,.T.)
			nQtdReg := (cTjp)->RECLRT

			If nQtdReg == 0
				FWLogMsg("INFO", /*cTransactionId*/, "RECEIV", /*cCategory*/, /*cStep*/, /*cMsgId*/, "Nao houve inclusoes/alteracoes de titulos, nao havera carga na RECEIV ...", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
				If!IsBlind()
					FWAlertWarning("Não foram encontrados registros com os parâmetros informados!", "Sem registros")
				EndIf
				lRet := .F.
			else
				FWLogMsg("INFO", /*cTransactionId*/, "RECEIV", /*cCategory*/, /*cStep*/, /*cMsgId*/, "Sera efetuada a carga de " + AllTrim(STR(nQtdReg)) + " titulos a serem utilizados na API de Contratos com a RECEIV", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
				aLinhas := U_SliceThr(@nQtdReg, @nQtdThread, nQuebra)
			EndIf
		Else
			fDropTable(cTrbAre)
			lRet := .F.
		EndIf

		If lRet
			U_TIRCX00B( "U_TIRCVM3A", cTrbAre, aLinhas, nQtdReg, nQtdThread, nQuebra )
		EndIF

		cFilAnt  := cFilBkp
		dDatabase := dDtBsBkp

		FWLogMsg("INFO", /*cTransactionId*/, "RECEIV", /*cCategory*/, /*cStep*/, /*cMsgId*/, "Processo de reenvio de titulos a serem utilizados na API de contratos da RECEIV finalizado...", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
	EndIf
return


/*/{Protheus.doc} TRCVQRY
   Querie para ler os titulos incluidos nos ultimos dias e gerar os contratos
    @type  Function
    @author Cassio Menabue Lima
    @since 27/02/2023
    @version 1.0
  /*/
Static Function TRCVQRY(nOp)
	Local cqry          := ""
	Local cAlTrb        := GetNextAlias()
	Local cPrefDes	    := GetMv("TI_PREFREC",,"VGR/NCC")
	Local lParallel 	:= GetMv('TI_RCVPRL', , .T.)
	Local lLigaInteg	:= GetMv('TI_RCVINC', , .F.)  			// Liga/desliga as integrações com a Receive
	Local cFilInteg     := FormatIn(GetMv('TI_RCVFIL'),"/")   	// Filiais que serão desconsideradas

	cPrefDes := FormatIn(cPrefDes, "/")

	cqry := " SELECT "
	If lParallel
		cQry += " /*+ PARALLEL(8) */ "
	EndIf
	cQry += " DISTINCT E1_FILIAL, E1_TIPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_CLIENTE, E1_LOJA, ROWNUM RECLRT "
	cqry += " FROM "+RETSQLNAME("SE1")+" SE1 "

	cqry += " WHERE  "

	If nOp == 1
		cqry += " E1_FILIAL <> ' ' "
	Else
		cqry += " E1_FILIAL = '" + cFilAnt + "' "
	EndIf
	cQry += " AND SE1.E1_PREFIXO NOT IN " + cPrefDes
	cqry += " AND SE1.E1_TIPO = 'NF' "

	If lLigaInteg // Desconsidera as filiais abaixo
		cqry += " AND SE1.E1_FILIAL NOT IN " + cFilInteg
	Endif
	//cQry += " AND SE1.E1_EMISSAO =  '"+Dtos(dDatabase)+"'  "
	cQry += " AND SE1.D_E_L_E_T_ =' '   "
	cqry += " ORDER BY RECLRT   		"

	FWLogMsg("INFO", /*cTransactionId*/, "RECEIV", /*cCategory*/, /*cStep*/, /*cMsgId*/, "Executando Query CONTRATOS RECEIV RETROATIVO...", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

	cqry:= ChangeQuery(cqry)

	TIMemoW('system\cassio\TIRCV03C_CONTRATO.txt',cqry)
	IF TCCanOpen(cAlTrb)
		fDropTable(cAlTrb)
	EndIF
	If !fCreateTable(cqry, cAlTrb)

	EndIF

return cAlTrb







/*/{Protheus.doc} fCreateTable
   Cria tabela temporaria
    @type  Function
    @author Cassio Menabue Lima
    @since 27/02/2023
    @version 1.0
  /*/
Static Function fCreateTable(cSelect, cTab)

	Local cScript 	:= ''
	Local lRet 		:= .T.

	cScript := "CREATE TABLE "+cTab+" AS "
	cScript += cSelect

	IF TCSQLEXEC(cScript) <> 0

		lRet := .F.
	EndIf

Return lRet

/*/{Protheus.doc} fDropTable
   deleta a tabela temporaria
    @type  Function
    @author Cassio Menabue Lima
    @since 27/02/2023
    @version 1.0
  /*/
Static Function fDropTable(cTable)

	Local cScript := " DROP TABLE "+cTable
	Local lRet := .T.

	If Select(cTable) > 0
		(cTable)->(dbCloseArea())
	EndIf

	IF TCSQLEXEC(cScript) <> 0

		lRet := .F.
	EndIf

Return lRet


static Function fRCVTit( )

	Local aBoxParam  := {}
	Local aRetParam  := {}
	Local cFilBkp    := cFilAnt
	Local cTitDe     := Space(9)
	Local cTitAte    := Space(9)
	Local cCliDe     := Space(6)
	Local cCliAte    := Space(6)
	Local oTIReceiv  := TIRECEIV( ):New()
	Local cWhere     := ""

	If U_RCVENV(cEmpAnt,cFilAnt)

        aAdd(aBoxParam, {1 ,"Filial"     , cFilAnt 	, ""	, ".T."	, "" ,".F."  		,  60 , .T.})
        Aadd(aBoxParam, {1, "Titulo De"  , cTitDe  	, ""	,		, "" 	,  		,  60 , .F.})
        Aadd(aBoxParam, {1, "Titulo Ate" , cTitAte 	, ""	, ".T."	, "" 	,   	,  60 , .T.})
        Aadd(aBoxParam, {1, "Cliente De" , cCliDe  	, ""	, 		, "SA1" ,		,  60 , .F.})
        Aadd(aBoxParam, {1, "Cliente Ate", cCliAte 	, ""	, ".T." , "SA1" ,  		,  60 , .T.})	
       
        IF ParamBox(aBoxParam, "Reenvio de Titulos - Parâmetros", @aRetParam)
            cFilAnt :=aRetParam[1]
            cTitDe	:=aRetParam[2]
            cTitAte :=aRetParam[3]
            cCliDe  :=aRetParam[4]
            cCliAte :=aRetParam[5]

            //Chamar rotina pra enviar titulos
            cWhere+=" E1_FILIAL 	  ='"+cFilAnt+"'"
            cWhere+=" AND E1_NUM  	  BETWEEN '"+cTitDe+"' AND '"+cTitAte+"'"
            cWhere+=" AND E1_CLIENTE  BETWEEN '"+cCliDe+"' AND '"+cCliAte+"'"
            Processa( {|| oTIReceiv:SetTitulos( cWhere) }, "Aguarde...", "Buscando Titulos...",.T.)
            
            FWAlertWarning("Titulos reenviados com sucesso, dentre instantes serao procesadas e reenviadas para a RECEIV", "REENVIO TITULOS")
        Else
            Return
        EndIF
		
    EndIF

    cFilAnt  :=cFilBkp

Return


Static Function fRCVLig(nOpcao)
Local aArea     := GetArea()
Local cFilInteg := AllTrim(SuperGetMV("TI_RCVFIL "))
Local cAlias    := "SX6"
Local cTamFil   := Space(Len(cFilAnt))
Local lRet      := .T.

DbSelectArea(cAlias)
DbSetOrder(1)

If nOpcao == 1 // Liga, ou seja, cFilDest será incluída no parâmetro TI_RCVFIL e não será processada pelas rotinas de reenvio da Receiv
    If !cFilDest $ Alltrim(cFilInteg)
        If !Empty(cFilInteg)
            cFilInteg += "/" + cFilDest
        Else
            cFilInteg += cFilDest
        Endif
    Else
        FWAlertInfo(cFilDest + " - Já está incluída no parâmetro TI_RCVFIL")
        lRet := .F.
    Endif
    If lRet
        DBSEEK(cTamFil+"TI_RCVFIL ")
        RecLock(cAlias,.F.)

        &(cAlias+"->"+"X6_CONTEUD") := cFilInteg
        &(cAlias+"->"+"X6_CONTSPA") := cFilInteg
        &(cAlias+"->"+"X6_CONTENG") := cFilInteg
    
        &(cAlias)->(MsUnlock())

        cFilInteg := AllTrim(SuperGetMV("TI_RCVFIL2"))

        If !cFilDest $ Alltrim(cFilInteg)
            If !Empty(cFilInteg)
                cFilInteg += "/" + cFilDest
            Else
                cFilInteg += cFilDest
            Endif
        Else
            FWAlertInfo(cFilDest + " - Já está incluída no parâmetro TI_RCVFIL2")
            lRet := .F.
        Endif
    
        DBSEEK(cTamFil+"TI_RCVFIL2")
        RecLock(cAlias,.F.)

        &(cAlias+"->"+"X6_CONTEUD") := cFilInteg
        &(cAlias+"->"+"X6_CONTSPA") := cFilInteg
        &(cAlias+"->"+"X6_CONTENG") := cFilInteg
    
        &(cAlias)->(MsUnlock())
        If lRet
            FWAlertInfo(cFilDest + " - incluída nos parâmetros TI_RCVFIL e TI_RCVFIL2")
        Else
            FWAlertError("Erro na ligação dos parâmetros !")
        Endif
    Endif
Else
    // desliga, ou seja, cFilDest será removida no parâmetro TI_RCVFIL e será processada pelas rotinas de reenvio da Receiv
    If "/"+cFilDest $ cFilInteg
        cFilInteg := StrTran(cFilInteg,"/"+cFilDest,"")
        DBSEEK(cTamFil+"TI_RCVFIL ")
        RecLock(cAlias,.F.)

        &(cAlias+"->"+"X6_CONTEUD") := cFilInteg
        &(cAlias+"->"+"X6_CONTSPA") := cFilInteg
        &(cAlias+"->"+"X6_CONTENG") := cFilInteg
    
        &(cAlias)->(MsUnlock())
    Else
        FWAlertInfo(cFilDest + " - Não está incluída no parâmetro TI_RCVFIL")
        lRet := .F.
    Endif
    If lRet
        cFilInteg := AllTrim(SuperGetMV("TI_RCVFIL2"))

        If "/"+cFilDest $ cFilInteg
            cFilInteg := StrTran(cFilInteg,"/"+cFilDest,"")
            DBSEEK(cTamFil+"TI_RCVFIL2")
            RecLock(cAlias,.F.)

            &(cAlias+"->"+"X6_CONTEUD") := cFilInteg
            &(cAlias+"->"+"X6_CONTSPA") := cFilInteg
            &(cAlias+"->"+"X6_CONTENG") := cFilInteg
    
            &(cAlias)->(MsUnlock())

        Else
            FWAlertInfo(cFilDest + " - Não está incluída no parâmetro TI_RCVFIL2")
            lRet := .F.
        Endif
        If lRet
            FWAlertInfo(cFilDest + " - removida dos parâmetros TI_RCVFIL e TI_RCVFIL2")
        Else
            FWAlertError("Erro no desligamento dos parâmetros !")
        Endif
    Endif
Endif

RestArea(aArea)
Return

Static Function TIMemoW(cFile,cString)
Local cRet := ""
Local cFun  := "Memo"+"Write"

cRet := &(cFun)(cFile,cString)  //Não pode tirar a virgula

Return cRet 

Static Function TIMemoR(cFile)
Local cRet := ""
Local cFun  := "Memo"+"Read"

cRet := &(cFun)(cFile,)  //Não pode tirar a virgula

Return cRet 

Static Function TIFCreate(cFile, nAtt)
    Local nRet := 0
    Local cFun  := "MSFCreate"

    nRet := &(cFun)(cFile, nAtt)

Return nRet 

Static Function TIGetFile(cMascara, cTitulo, nMascpadrao, cDirinicial, lSalvar, nOpcoes, lArvore, lKeepCase)
    Local cRet := ""
    Local cGF  := "cGetFile"

    cRet := &(cGF)(cMascara, cTitulo, nMascpadrao, cDirinicial, lSalvar, nOpcoes, lArvore, lKeepCase)

Return cRet


Static Function TIFuse(cFile)
Local cFun := "FT" + "_" + "fUSE('"+CFILE+"')"

//cRet := &(cFun)(cFile)
CRET := &(CFUN)

Return cRet
