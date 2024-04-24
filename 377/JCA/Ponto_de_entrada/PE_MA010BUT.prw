#INCLUDE 'PROTHEUS.CH'

/*
    Ponto de entrada rotina mata010 para inclusão de botões em outras ações
*/
User Function MA010BUT()

Local aButtons := {} 
// botões a adicionar

AAdd(aButtons,{ 'NOTE',{| |  U_xMABt010(M->B1_COD) }, 'Endereçar','Estrut' } )


Return (aButtons)


/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 05/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xMABt010(cCodigo)

Local aArea := GetArea()
Local cEnd  := space(15)
Local cFil  := space(8)
Local nCont 
Local nOpc  := 0

Private oDlg1,oGrp1,oBtn1,oBtn2,oGrp2,oSay1,oSay2,oGet1,oGet2,oBtn3,oList1
PRIVATE oOk        :=    LoadBitmap(GetResources(),'br_verde')  
PRIVATE oNo        :=    LoadBitmap(GetResources(),'br_vermelho')

Private aList1 := {}

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

Busca(cCodigo)

If len(aList1) < 1 
    Aadd(aList1,{.F.,'','','','','','','','','','',''})
EndIf 

oDlg1      := MSDialog():New( 092,232,681,1480,"Endereçamento",,,.F.,,,,,,.T.,,,.T. )

    oGrp2      := TGroup():New( 004,144,044,440,"Endereçar",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
    oSay1      := TSay():New( 020,156,{||"Empresa/Filial"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
    oGet1      := TGet():New( 020,200,{|u| If(Pcount()>0,cFil:=u,cFil)},oGrp2,064,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SM0","",,)
    
    oSay2      := TSay():New( 020,284,{||"Endereço"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet2      := TGet():New( 020,328,{|u| If(Pcount()>0,cEnd:=u,cEnd)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SBE","",,)
    
    oBtn3      := TButton():New( 019,404,"Incluir",oGrp2,{|| adicitm(cFil,cEnd,cCodigo)},029,012,,,,.T.,,"",,,,.F. )

    oGrp1      := TGroup():New( 052,004,256,612,"Amarração Produto X Filial X Endereçamento de Estoque",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{064,008,248,608},,, oGrp1 ) 
    oList1    := TCBrowse():New(064,008,595,185,, {'','Filial','Produto','Estoque','Endereço','Descrição'},;
                                        {10,40,50,40,40,70},;
                                        oGrp1,,,,{|| /*FHelp(oList1:nAt)*/},{|| /*editcol(oList1:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList1:SetArray(aList1)
    oList1:bLine := {||{IF(aList1[oList1:nAt,01],oOk,oNo),; 
                        aList1[oList1:nAt,02],;
                        aList1[oList1:nAt,03],;
                        aList1[oList1:nAt,04],;
                        aList1[oList1:nAt,05],;
                        aList1[oList1:nAt,06]}}


    oBtn1      := TButton():New( 264,192,"Confirmar",oDlg1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 264,360,"Sair",oDlg1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )
    
oDlg1:Activate(,,,.T.)

If nOpc == 1
    For nCont := 1 to len(aList1)
        If !aList1[nCont,01] .And. !Empty(aList1[nCont,02])
            Reclock("ZPU",.T.)
            ZPU->ZPU_FILIAL := aList1[nCont,02]
            ZPU->ZPU_COD    := aList1[nCont,03]
            ZPU->ZPU_LOCPAD := aList1[nCont,04]
            ZPU->ZPU_ENDERE := aList1[nCont,05]
            ZPU->(Msunlock())
        EndIf 
    Next nCont
EndIf 

RestArea(aArea)
    
Return

/*/{Protheus.doc} adicitm
    (long_description)
    @type  Static Function
    @author user
    @since 05/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function adicitm(cFil,cEnd,cProd)

Local aArea := GetArea()
Local cCodPai := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_XCODPAI")
Local lLibera := .T.
Local nPos  :=  Ascan(aList1,{|x| x[2]+Alltrim(x[3]) == cFil+Alltrim(cProd) })

If Empty(aList1[1,2])
    aList1 := {}
EndIf 

If nPos > 0
    MsgAlert("Produto já esta com amarração para esta filial","PE_MA010BUT - adicitm")
    lLibera := .f.
Else 

    DbSelectArea("ZPU")
    DbSetOrder(1)

    If Dbseek(cFil+cEnd)
        If ZPU->ZPU_COD <> cCodPai .and. ZPU->ZPU_COD <> cProd
            MsgAlert("Endereço já esta sendo utilizado para o produto "+ZPU->ZPU_COD,"PE_MA010BUT - adicitm")
            lLibera := .f.
        EndIf 
    EndIf 
EndIf 

If lLibera
    cLoc := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_LOCPAD")
    cDesL := Posicione("SBE",9,xFilial("SBE")+cEnd,"BE_DESCRIC")
    
    Aadd(aList1,{.F.,cFil,cProd,cLoc,cEnd,cDesL})
    
    If cCodPai <> cProd .And. !Empty(cCodPai) .And. Ascan(aList1,{|x| alltrim(x[3]) == Alltrim(cCodPai)}) == 0
        Aadd(aList1,{.F.,cFil,cCodPai,cLoc,cEnd,cDesL})
    EndIf
    
EndIf 

If len(aList1) < 1
    Aadd(aList1,{.F.,'','','','','','','','','','',''})
EndIf 

oList1:SetArray(aList1)
oList1:bLine := {||{IF(aList1[oList1:nAt,01],oOk,oNo),; 
                    aList1[oList1:nAt,02],;
                    aList1[oList1:nAt,03],;
                    aList1[oList1:nAt,04],;
                    aList1[oList1:nAt,05],;
                    aList1[oList1:nAt,06]}}

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 05/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function busca(codigo)

Local aArea     := GetArea()
Local cQuery 
Local cCodPai   := Posicione("SB1",1,xFilial("SB1")+codigo,"B1_XCODPAI")

cQuery := "SELECT ZPU_FILIAL,ZPU_COD,ZPU_LOCPAD,ZPU_ENDERE,BE_DESCRIC"
cQuery += " FROM "+RetSQLName("ZPU") + " ZPU"
cQuery += " INNER JOIN "+RetSQLName("SBE")+" BE ON BE_FILIAL=ZPU_FILIAL AND BE_LOCALIZ=ZPU_ENDERE AND BE.D_E_L_E_T_=' '"
cQuery += " WHERE ZPU_FILIAL BETWEEN ' ' AND 'ZZ'

If !Empty(cCodPai)
    cQuery += " AND ZPU_COD IN(SELECT B1_COD FROM "+RetSQLName("SB1")  
    cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"
    cQuery += " AND (B1_COD = '"+codigo+"' OR B1_XCODPAI='"+cCodPai+"' OR B1_COD='"+cCodPai+"')) "
Else 
    cQuery += " AND ZPU_COD = '"+codigo+"'"
EndIf 


cQuery += " AND ZPU.D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF()
    Aadd(aList1,{.T.,TRB->ZPU_FILIAL,TRB->ZPU_COD,TRB->ZPU_LOCPAD,TRB->ZPU_ENDERE,TRB->BE_DESCRIC})
    Dbskip()
EndDo 

RestArea(aArea)

Return
