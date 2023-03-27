#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 15/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function CONFSC06()

Local nOpc      :=  0
Private oDlg1,oGrp1,oSay1,oSay2,oGet1,oGet2,oBtn1,oBtn2
Private cAtivo  := space(15)
Private cContra := space(15)

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

if !(cUsername $ GetMV("MV_XCONO07"))
    MsgAlert("Seu usuario (" + cUsername + ") nao tem permissao para acessar essa rotina!", "Encerrado!")
    Return
endif

oDlg1      := MSDialog():New( 092,232,310,670,"Atribuir Ativo ao Contrato",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 008,020,088,192,"Informações Gerais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay1      := TSay():New( 020,052,{||"Ativo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet1      := TGet():New( 020,092,{|u| If(pcount()>0,cAtivo:=u,cAtivo)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SN1X","",,)
    
    oSay2      := TSay():New( 040,052,{||"Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet2      := TGet():New( 040,092,{|u| If(pcount()>0,cContra:=u,cContra)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"AAM","",,)

    oBtn1      := TButton():New( 064,068,"Confirmar",oGrp1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 064,124,"Cancelar",oGrp1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpc == 1
    GeraBI(cAtivo,cContra)
EndIf 

Return 

/*/{Protheus.doc} GeraBI
    (long_description)
    @type  Static Function
    @author user
    @since 15/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraBI(cAtivo,cContra)
    
Local aArea := GetArea()
Local cCodCli := ''
Local cLojCli := ''
Local cCodPro := ''
Local cNumSer := ''
Local cNCbase := ''
Local cNItem  := ''
Local aCab040   := {}    // Cabecalho do AA3
Local aItens040 := {}    // Itens AA4
Local cProx :=	""
Local cQuery 

Private lMsErroAuto := .F. 

cQuery := "SELECT CONVERT(VARCHAR,MAX(AAN_ITEM)+1) AS NEWITM"
cQuery += " FROM "+RetSQLName("AAN")
cQuery += " WHERE AAN_FILIAL='"+xFilial("AAN")+"'"
cQuery += " AND AAN_CONTRT='"+cContra+"' AND D_E_L_E_T_=' '"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("MSD2460.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")   

cProx := STRZERO(VAL(TRB->NEWITM),2)

DbSelectArea("AAM")
DbSetOrder(1)
If DbSeek(xfilial("AAM")+cContra)
    cCodCli := AAM->AAM_CODCLI
    cLojCli := AAM->AAM_LOJA
EndIf 

DbSelectArea("SN1")
DbSetOrder(2)
If Dbseek(xFilial("SN1")+cAtivo)
    cCodPro := SN1->N1_PRODUTO
    cNumSer := SN1->N1_XNUMSER
    cNCbase := SN1->N1_CHAPA
    cNItem  := SN1->N1_ITEM
EndIf 

DbSelectArea("AA3")
DbSetORder(7)

lMsErroAuto := .F.

If Dbseek(xFilial("AA3")+cNCbase)
    Reclock("AA3",.F.)
    AA3->AA3_CODCLI := cCodCli
    AA3->AA3_LOJA   := cLojCli
    AA3->(MSUNLOCK())
Else 
    Aadd(aCab040, { "AA3_FILIAL"    , xFilial("AA3")    , NIL } )               
    Aadd(aCab040, { "AA3_CODCLI"    , cCodCli           , NIL } )               
    Aadd(aCab040, { "AA3_LOJA"      , cLojCli           , NIL } )               
    Aadd(aCab040, { "AA3_CODPRO"    , cCodPro           , NIL } )               
    Aadd(aCab040, { "AA3_NUMSER"    , cNumSer           , NIL } )                
    Aadd(aCab040, { "AA3_CBASE"     , cNCbase           , NIL } )                
    Aadd(aCab040, { "AA3_ITEM"      , cNItem            , NIL } )                
    Aadd(aCab040, { "AA3_CHAPA"     , cNCbase           , NIL } )                
    Aadd(aCab040, { "AA3_DTVEN"     , dDatabase-30      , NIL } )

    TECA040(,aCab040,aItens040,3)   

EndIf 

If lMsErroAuto  
    MostraErro()                            
    lRet := .F.  
    Return
else
    DbSelectArea("SN1")
    DbSetOrder(2)
    If Dbseek(xFilial("SN1")+cAtivo)
        Reclock("SN1",.F.)
        SN1->N1_XCLIENT :=  cCodCli
        SN1->N1_XLOJA   :=  cLojCli 
        SN1->(MsUnlock())
    EndIf 

    DbSelectArea("AAN")
	Reclock("AAN",.T.)
	AAN->AAN_FILIAL := xFilial("AAN")
	AAN->AAN_CONTRT := cContra
	AAN->AAN_ITEM	:= cProx
	AAN->AAN_CODPRO	:= cCodPro 
	AAN->AAN_QUANT	:= 1
	AAN->AAN_VLRUNI	:= 0.01
	AAN->AAN_VALOR	:= 0.01
	AAN->AAN_CONPAG	:= '001'
	AAN->AAN_DATA 	:= DDATABASE
	AAN->AAN_INICOB	:= DDATABASE+1
	AAN->AAN_FIMCOB	:= CTOD('31/12/2030')
	AAN->AAN_XCBASE	:= cAtivo 
	AAN->(MsUnlock())

    cUpdQry := "UPDATE "+RetSQLName("AAN")
    cUpdQry += " SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_"
    cUpdQry += " WHERE AAN_FILIAL='"+xFilial("AAN")+"'"
    cUpdQry += " AND AAN_CONTRT='"+cContra+"'"
    cUpdQry += " AND AAN_CODPRO='CONTRATO'"
    cUpdQry += " AND D_E_L_E_T_=' '"
    TcSqlExec(cUpdQry)
EndIf 

RestArea(aArea)

Return
