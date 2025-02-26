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

User Function RRFIN01

Local nOpc     := 0
Local nCont    := 0
Local aAuxRec  := {}
Local aPergs   := {}
Local aRet     := {}
Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay8,oSay9,oSay10
Private oSay12,oGet1,oGet2,oGet3,oGet4,oGet5,oGet6,oGet7,oGet8,oBtn1,oGrp2,oBrw1,oBtn3
Private oList1
Private aList1 := {}
Private cCliDe :=   space(6)
Private cCliAt :=   space(6)
Private cCgcDe :=   space(14)
Private cCgcAt :=   space(14)
Private cNotDe :=   space(9)
Private cNotAt :=   space(9)
Private cVndDe :=   space(6)
Private cVndAt :=   space(6)
Private oOk   		:= LoadBitmap(GetResources(),'br_verde') 
Private oNo   		:= LoadBitmap(GetResources(),'br_vermelho')  

Aadd(aList1,{.F.,'','','','','','','','',''})

If Empty(FunName())
	RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf	

oDlg1      := MSDialog():New( 092,232,795,1397,"Baixa em lote Ruby Rose",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,008,112,568,"Parâmetros",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay1      := TSay():New( 021,016,{||"Cliente de"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet1      := TGet():New( 021,049,{|x| If(PCount() > 0,cCliDe := x,cCliDe)},oGrp1,044,008,'',{|| oSay2:settext(cCliDe)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCliDe",,)
    oGet1:bF3:= &('{|| IIf(ConPad1(,,,"SA1",,,.F.),Eval({|| cCliDe := SA1->A1_COD, oGet1:Refresh()}),.T.)}') 
    oSay2      := TSay():New( 021,100,{||"oSay2"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,184,008)

    oSay4      := TSay():New( 021,293,{||"Cliente Até"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    
    oGet2      := TGet():New( 021,329,{|x| If(PCount() > 0,cCliAt := x,cCliAt)},oGrp1,044,008,'',{|| oSay3:settext(cCliAt)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCliAt",,)
    oGet2:bF3:= &('{|| IIf(ConPad1(,,,"SA1",,,.F.),Eval({|| cCliAt := SA1->A1_COD, oGet1:Refresh()}),.T.)}') 
    oSay3      := TSay():New( 021,377,{||"oSay2"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,184,008)

    oSay5      := TSay():New( 045,016,{||"Cnpj de"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet3      := TGet():New( 045,049,{|x| If(PCount() > 0,cCgcDe := x,cCgcDe)},oGrp1,084,008,PesqPict("SA1","A1_CGC"),,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

    oSay6      := TSay():New( 045,153,{||"Cnpj Até"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet4      := TGet():New( 045,197,{|x| If(PCount() > 0,cCgcAt := x,cCgcAt)},oGrp1,083,008,PesqPict("SA1","A1_CGC"),,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay8      := TSay():New( 045,293,{||"Nota de"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet6      := TGet():New( 045,328,{|x| If(PCount() > 0,cNotDe := x,cNotDe)},oGrp1,057,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay7      := TSay():New( 045,398,{||"Nota Até"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet5      := TGet():New( 045,430,{|x| If(PCount() > 0,cNotAt := x,cNotAt)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

    oSay10     := TSay():New( 066,017,{||"Vendedor De"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet7      := TGet():New( 066,049,{|x| If(PCount() > 0,cVndDe := x,cVndDe)},oGrp1,044,008,'',{|| oSay9:settext(cVndDe)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cVndDe",,)
    oGet7:bF3:= &('{|| IIf(ConPad1(,,,"SA3",,,.F.),Eval({|| cVndDe := SA3->A3_COD, oGet1:Refresh()}),.T.)}') 
    oSay9      := TSay():New( 066,101,{||"oSay2"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,184,008)

    oSay12     := TSay():New( 066,294,{||"Vendedor Até"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
    oGet8      := TGet():New( 066,330,{|x| If(PCount() > 0,cVndAt := x,cVndAt)},oGrp1,044,008,'',{|| oSay11:settext(cVndAt)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cVndAt",,)
    oGet8:bF3:= &('{|| IIf(ConPad1(,,,"SA3",,,.F.),Eval({|| cVndAt := SA3->A3_COD, oGet1:Refresh()}),.T.)}') 
    oSay11     := TSay():New( 066,378,{||"oSay2"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,184,008)

    oBtn1      := TButton():New( 092,240,"Pesquisar",oGrp1,{||Processa({||PesqTit()},"Aguarde")},037,012,,,,.T.,,"",,,,.F. )

oGrp2      := TGroup():New( 116,008,320,568,"Lista",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{124,012,316,564},,, oGrp2 ) 
    oList1:= 	TCBrowse():New(124,012,550,190,, {'','Razão','Doc. Conta(NF)','Parcela','Tipo','Data Vencto','Valor Receber','Pago','Saldo'},;
                                {10,40,30,30,30,30,30,30,30},;
	                            oGrp2,,,,{|| },{|| editcol(oList1:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList1:SetArray(aList1)
    oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),; 
                        aList1[oList1:nAt,02],;
                        aList1[oList1:nAt,03],;
                        aList1[oList1:nAt,04],; 
                        aList1[oList1:nAt,05],;
                        STOD(aList1[oList1:nAt,06]),;
                        Transform(aList1[oList1:nAt,07],"@E 999,999,999.99"),; 
                        Transform(aList1[oList1:nAt,08],"@E 999,999,999.99"),;
                        Transform(aList1[oList1:nAt,09],"@E 999,999,999.99")}}

    MENU oMenu POPUP 
	MENUITEM "Marcar/Desmarcar todos" ACTION (selreg())
	ENDMENU                                                                           

	oList1:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }

    oBtn2      := TButton():New( 325,192,"Baixar",oDlg1,{|| oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( 325,285,"Cancelar",oDlg1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpc == 1
    For nCont := 1 to len(aList1)
        If aList1[nCont,01]
            Aadd(aAuxRec,aList1[nCont,10])
        ENDIF
    Next nCont

    If len(aAuxRec) > 0
        cBanco      := space(TamSX3("A6_COD")[1])
        cAgencia    := space(TamSX3("A6_AGENCIA")[1])
        cConta      := space(TamSX3("A6_NUMCON")[1])
        cNaturez    := space(TamSX3("ED_CODIGO")[1])
        dDtBaixa    := ddatabase

        aAdd(aPergs ,{1,"Banco"		,cBanco   ,'',"","SA6","",70,.F.})
        aAdd(aPergs ,{1,"Agência"	,cAgencia   ,'',"","","",70,.F.})
        aAdd(aPergs ,{1,"Conta"		,cConta   ,'',"","","",70,.F.})
        aAdd(aPergs ,{1,"Natureza"	,cNaturez   ,'',"","SED","",70,.F.})
        aAdd(aPergs ,{1,"Data Baixa",dDtBaixa   ,'',"","","",70,.F.})
            
        If ParamBox(aPergs ,"Informe os Parâmetros",aRet)
            //aE1Recnos,cBank,cAgenc,cCont,cCodNat,dDtBaixa
            Processa({|| BaixaLote(aAuxRec,aRet[1],aRet[2],aRet[3],aRet[4],aRet[5])},"Aguarde")
        Endif
    EndIf 
EndIf 

Return


/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 22/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function PesqTit()

Local aArea :=  GetArea()
Local cQuery 

aList1 := {}

cQuery := "SELECT A1_NOME,E1_NUM,E1_PARCELA,E1_TIPO,E1_VENCREA,E1_VALOR,"
cQuery += " E1_VALOR-(E1_VALOR-E1_SALDO) AS PAGO,E1_SALDO,E1.R_E_C_N_O_ AS RECE1"
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"'"
cQuery += "   AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += "   AND A1_CGC BETWEEN '"+cCgcDe+"' AND '"+If(!Empty(cCgcAt),cCgcAt,'ZZZ')+"'"
cQuery += " WHERE E1_FILIAL BETWEEN ' ' AND 'ZZ'"
cQuery += " AND E1_CLIENTE BETWEEN '"+cCliDe+"' AND '"+If(!Empty(cCliAt),cCliAt,'ZZZ')+"'"
cQuery += " AND E1_NUM BETWEEN '"+cNotDe+"' AND '"+If(!Empty(cNotAt),cNotAt,'ZZZ')+"'"
cQuery += " AND E1_VEND1 BETWEEN '"+cVndDe+"' AND '"+If(!Empty(cVndAt),cVndAt,'ZZZ')+"'"
cQuery += " AND E1.D_E_L_E_T_=' ' "
cQuery += " ORDER BY E1.E1_VENCREA"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
    Aadd(aList1,{.F.,;
                TRB->A1_NOME,;
                TRB->E1_NUM,;
                TRB->E1_PARCELA,;
                TRB->E1_TIPO,;
                TRB->E1_VENCREA,;
                TRB->E1_VALOR,;
                TRB->PAGO,;
                TRB->E1_SALDO,;
                TRB->RECE1})
    Dbskip()
EndDo 

If len(aList1) < 1
    Aadd(aList1,{.F.,'','','','','','','','',''})
EndIf 

oList1:SetArray(aList1)
oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),; 
                    aList1[oList1:nAt,02],;
                    aList1[oList1:nAt,03],;
                    aList1[oList1:nAt,04],; 
                    aList1[oList1:nAt,05],;
                    STOD(aList1[oList1:nAt,06]),;
                    Transform(aList1[oList1:nAt,07],"@E 999,999,999.99"),; 
                    Transform(aList1[oList1:nAt,08],"@E 999,999,999.99"),;
                    Transform(aList1[oList1:nAt,09],"@E 999,999,999.99")}}

oList1:refresh()
oDlg1:refresh()


RestArea(aAreA)

Return

/*/{Protheus.doc} selreg()
    (long_description)
    @type  Static Function
    @author user
    @since 22/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function selreg()

Local aArea :=  GetArea()
Local nCont :=  1

For nCont := 1 to len(aList1)
    If aList1[nCont,01]
        aList1[nCont,01] := .F.
    else
        aList1[nCont,01] := .T.
    EndIf
Next nCont

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} editcol
    (long_description)
    @type  Static Function
    @author user
    @since 22/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editcol(nLinha)

Local aArea :=  GetArea()

If aList1[nLinha,01]
    aList1[nLinha,01] := .F.
else
    aList1[nLinha,01] := .T.
EndIf 

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return    

/*/{Protheus.doc} BaixaLote
Executa o processo de baixa em lote pela rotina FINA110
Projeto MPN
@author 
@since 20/04/2022
/*/
Static Function BaixaLote(aE1Recnos,cBank,cAgenc,cCont,cCodNat,dDtBaixa)

Local aBaixa   	:= {}
Local cNumLote 	:= GETSXENUM( "SE5", "E5_LOTE", Nil, 5 )


Private lMsErroAuto := .F.

Private	cBanco 		:= If(Empty(cBank),Alltrim(SuperGetmv('TI_BCOADM'   ,.F.,'341'      )),cBank)
Private	cAgencia	:= If(Empty(cAgenc),Alltrim(SuperGetmv('TI_AGADM'    ,.F.,'1024 '     )),cAgenc)
Private	cConta		:= If(Empty(cCont),Alltrim(SuperGetmv('TI_CONTACC'  ,.F.,'42043 '   )),cCont)


    cBkpPRELAN := GetMV("MV_PRELAN")
    cBkpCT105MS := GetMV("MV_CT105MS")
    cBkpALTLCTO := GetMV("MV_ALTLCTO")

    PutMV("MV_PRELAN","D")
    PutMV("MV_CT105MS","N")  
    PutMV("MV_ALTLCTO","N")   

 
DbSelectArea("SA6")
DbSetOrder(1)
DbSeek(xFilial("SA6")+cBanco+Avkey(cAgencia,"A6_AGENCIA")+Avkey(cConta,"A6_CONTA"))

lMsErroAuto := .F.
aBaixa := {}

aBaixa := {aClone(aE1Recnos),;
			cBanco,;
			cAgencia,;
			cConta,;
			"",;//cCheque
			cNumLote,;
			cCodNat,;
			dDtBaixa}

//mudar data de baixa  
MSExecAuto({|x,y| Fina110(x,y)},3,aBaixa)                  

If lMsErroAuto
	RollbackSx8() //Libera o numero do lote
Else
	ConfirmSx8() //Confirma o numero do lote
	
    PutMV("MV_PRELAN",cBkpPRELAN)
    PutMV("MV_CT105MS",cBkpCT105MS)  
    PutMV("MV_ALTLCTO",cBkpALTLCTO)


EndIf 
 
Return
