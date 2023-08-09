#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 08/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function CONOPC08()

Local aDados := {}

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

aDados := Busca()
tela(aDados)

Return

/*/{Protheus.doc} Busca
    (long_description)
    @type  Static Function
    @author user
    @since 08/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca()

Local aRet := {}
Local cQuery := ""

cQuery := "SELECT AB2_NRCHAM,AB2_XOS,AB2_CODCLI,AB2_LOJA,A1_NREDUZ,AB2_EMISSA,AB2_XCBASE,AB2_XTEC,AA1_NOMTEC,B1_DESC"
cQuery += " FROM "+RetSQLName("AB2")+" AB2"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=AB2_CODCLI AND A1_LOJA=AB2_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=AB2_CODPRO AND B1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("AA1")+" AA1 ON AA1_FILIAL=AB2_FILIAL AND AA1_CODTEC=AB2_XTEC AND AA1.D_E_L_E_T_=' '"
cQuery += " WHERE AB2.D_E_L_E_T_=' '"
cQuery += " AND AB2_XOS<>' ' AND AB2_STATUS='A'"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("CONOPC08.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()
    Aadd(aRet,{TRB->AB2_NRCHAM,;
                TRB->AB2_XOS,;
                TRB->AB2_CODCLI,;
                TRB->AB2_LOJA,;
                TRB->A1_NREDUZ,;
                STOD(TRB->AB2_EMISSA),;
                TRB->AB2_XCBASE,;
                TRB->AB2_XTEC,;
                TRB->AA1_NOMTEC,;
                TRB->B1_DESC})
    Dbskip()
EndDo 

Return(aRet)

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 08/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function tela(aDados)

Local nCont := 0    
Private oDlg1,oGrp1,oBtn1,oList1
Private aList1 := {}

For nCont := 1 to len(aDados)
    Aadd(aList1,aDados[nCont])
Next nCont

If len(aList1) > 0
    oDlg1      := MSDialog():New( 092,232,662,1209,"Protheus x Goon",,,.F.,,,,,,.T.,,,.T. )
    oGrp1      := TGroup():New( 004,008,256,476,"Status das Ordens de Serviços",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,012,252,472},,, oGrp1 ) 
    //AB2_NRCHAM,AB2_XOS,AB2_CODCLI,AB2_LOJA,A1_NREDUZ,AB2_EMISSA,AB2_XCBASE,AB2_XTEC,AA1_NOMTEC,B1_DESC
    oList1 := TCBrowse():New(012,012,460,240,, {'Chamado','OS Goon','Cliente','Data','Patrimonio','Tecnico','Modelo'},;
                                {40,30,80,30,30,60,80},;
                                oGrp1,,,,{|| /*FHelp(oList1:nAt)*/},{|| /*EDITCOL*/ },, ,,,  ,,.F.,,.T.,,.F.,,,)                          
    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],; 
                        aList1[oList1:nAt,02],;
                        aList1[oList1:nAt,05],;
                        aList1[oList1:nAt,06],;
                        aList1[oList1:nAt,07],;
                        aList1[oList1:nAt,09],;
                        aList1[oList1:nAt,10]}}

    oBtn1      := TButton():New( 260,200,"Sair",oDlg1,{|| oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)
EndIF

Return
