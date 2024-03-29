#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � CONOPC03  Autor �                       � Data �           ���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao �  Cria��o de leiaute de maquinas                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �                                               ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function CONOPC03(cXPatr,lIncl)

Local nOpc      :=  0
Local nX 

DEFAULT cXPatr := space(15) //space(TamSX3("AA3_CBASE")[1])
DEFAULT lIncl  := .F.

Private aCols   :=  {}
Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6
Private oSay7,oSay8,oGet1,oGet2,oGet4,oGrp3,oBtn1,oBtn2
Private cPatr   
Private cCli 
Private cLj
Private cLocIn

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

cPatr   := cXPatr
cCli    := space(TamSX3("A1_COD")[1])
cLj     := space(TamSX3("A1_LOJA")[1])
cLocIn  := space(TamSX3("NNR_CODIGO")[1])

Aadd(aCols,{'','','','',0,0,.f.})

oDlg1      := MSDialog():New( 057,187,748,993,"Cadastro de Leiautes",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,016,108,380,"Cadastro",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
    oSay1      := TSay():New( 012,116,{||"Patrimonio"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet1      := TGet():New( 012,168,{|u| If(PCount()>0,cPatr:=u,cPatr)},oGrp1,060,008,'@!',{|| Basexcli(lIncl)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SN1X","",,)

    oSay2      := TSay():New( 032,032,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet2      := TGet():New( 032,068,{|u| If(PCount()>0,cCli:=u,cCli)},oGrp1,060,008,'',{|| Fcadcli()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","",,)
    oGet3      := TGet():New( 032,132,{|u| If(PCount()>0,cLj:=u,cLj)},oGrp1,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    oSay3      := TSay():New( 032,168,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,204,008)
    
    oSay4      := TSay():New( 056,032,{||"Endere�o"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay5      := TSay():New( 012,248,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,008)
    oSay6      := TSay():New( 056,068,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,304,008)
    
    oSay7      := TSay():New( 076,032,{||"Local de Instala��o"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
    oGet4      := TGet():New( 076,084,{|u| If(PCount()>0,cLocIn:=u,cLocIn)},oGrp1,060,008,'',{||oSay8:settext(NNR->NNR_DESCRI)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"NNR1","",,)
    oSay8      := TSay():New( 076,152,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,008)
    
    oGrp3      := TGroup():New( 112,040,312,360,"Leiaute",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{124,048,304,352},,, oGrp3 ) 
    oList1            := TCBrowse():New(124,048,305,180,, {'','Selecao','Produto','Descri��o'/*,'R$ Subsid.','R$ Consum.'*/},{10,30,40,50/*,50,50*/},;
                                oGrp3,,,,{|| },{|| editcol(oList1:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList1:SetArray(aCols)
    oList1:bLine := {||{aCols[oList1:nAt,01],; 
                        aCols[oList1:nAt,02],;
                        aCols[oList1:nAt,03],; 
                        aCols[oList1:nAt,04]}}
                        // Transform(aCols[oList1:nAt,05],"@E 999,999.99"),;
                        // Transform(aCols[oList1:nAt,06],"@E 999,999.99")}} 

    oBtn1      := TButton():New( 316,112,"Confirmar",oDlg1,{|| oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 316,240,"Cancelar",oDlg1,{|| oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( 120,364,"+",oDlg1,{|| inclin()},021,012,,,,.T.,,"",,,,.F. )
    oBtn4      := TButton():New( 137,365,"-",oDlg1,{|| dellin(oList1:nAt)},021,012,,,,.T.,,"",,,,.F. )

    If !Empty(cXPatr)
        Basexcli(lIncl)
        oGet1:DISABLE()
        oGet4:DISABLE()
    EndIF 
    
oDlg1:Activate(,,,.T.)

If nOpc == 1
    //Z07_FILIAL+Z07_CHAPA+Z07_CLIENT+Z07_LOJA+Z07_SELECA
    DbSelectArea("Z07")
    DbSetOrder(1)
    For nX := 1 to len(aCols)
        If !Dbseek(xFilial("Z07")+Avkey(cPatr,"Z07_CHAPA")+Avkey(cCli,"Z07_CLIENT")+Avkey(cLj,"Z07_LOJA")+Avkey(aCols[nX,02],"Z07_SELECA"))
            Reclock("Z07",.T.)
        Else 

            RecLock("Z07",.F.)
            if Z07->Z07_CODPRO != aCols[nX,03] /*.OR. Z07->Z07_VLRVND != aCols[nX,05]*/
                Dbdelete()
                Z07->(MsUnlock())
                RecLock("Z07",.T.)
            endif

        ENDIF
        Z07->Z07_FILIAL :=  xFilial("Z07")
        Z07->Z07_CHAPA  :=  cPatr
        Z07->Z07_CLIENT :=  cCli
        Z07->Z07_LOJA   :=  cLj
        Z07->Z07_SELECA :=  aCols[nX,02]
        Z07->Z07_CODPRO :=  aCols[nX,03]
        Z07->(MsUnlock())
    Next nX 
EndIf 

Return

/*/{Protheus.doc} inclin
    (long_description)
    @type  Static Function
    @author user
    @since 31/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function inclin()

Local aArea :=  GetArea()

Aadd(aCols,{'','','','',0,0,.f.})

oList1:SetArray(aCols)
oList1:bLine := {||{aCols[oList1:nAt,01],; 
                        aCols[oList1:nAt,02],;
                        aCols[oList1:nAt,03],; 
                        aCols[oList1:nAt,04],;
                        Transform(aCols[oList1:nAt,05],"@E 999,999.99"),;
                        Transform(aCols[oList1:nAt,06],"@E 999,999.99")}} 

oList1:refresh()
oDlg1:refresh()


RestArea(aArea)

Return

/*/{Protheus.doc} dellin
    (long_description)
    @type  Static Function
    @author user
    @since 31/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function dellin(nLin)
    
Local aArea :=  GetArea()

Adel(aCols,nLin)
ASize(aCols,len(aCols)-1)

If len(aCols) < 1
    Aadd(aCols,{'','','','',0,0,.f.})

    oList1:SetArray(aCols)
    oList1:bLine := {||{aCols[oList1:nAt,01],; 
                        aCols[oList1:nAt,02],;
                        aCols[oList1:nAt,03],; 
                        aCols[oList1:nAt,04],;
                        Transform(aCols[oList1:nAt,05],"@E 999,999.99"),;
                        Transform(aCols[oList1:nAt,06],"@E 999,999.99")}} 
EndIf 

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} editcol
    (long_description)
    @type  Static Function
    @author user
    @since 31/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editcol(nLin)

Local aArea     :=  GetArea()
Local nPosic    :=  oList1:nColpos
Local aPosTam   :=  {'',TamSX3("Z07_SELECA")[1],TamSX3("B1_COD")[1],TamSX3("C6_PRCVEN")[1]}
Local lProd     :=  .F.

If nPosic == 2
    If Empty(aCols[nLin,nPosic])
        aCols[nLin,nPosic] := space(aPosTam[nPosic])
    EndIf 

    lEditCell( aCols, oList1, "@!", nPosic)
    aCols[oList1:nAt,nPosic] := strzero(val(aCols[oList1:nAt,nPosic]),3)

ElseIf nPosic == 3
    lProd    := ConPad1(,,,"SB1",,,.f.)
    
    If lProd
        aCols[nLin,nPosic] := SB1->B1_COD
        aCols[nLin,nPosic+1] := SB1->B1_DESC
    Else 
        If Empty(aCols[nLin,nPosic])
            aCols[nLin,nPosic] := space(aPosTam[nPosic])
        EndIf 

        lEditCell( aCols, oList1, "@!", nPosic)
    EndIf
    
EndIf

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 31/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Fcadcli()

oSay3:settext("")
oSay6:settext("")

If !Empty(cCli)
    oSay3:settext(SA1->A1_NOME)
    oSay6:settext(Alltrim(SA1->A1_END)+' - '+Alltrim(SA1->A1_BAIRRO)+' - '+Alltrim(SA1->A1_MUN)+' - '+Alltrim(SA1->A1_EST))
ENDIF

oDlg1:refresh()

Return

/*/{Protheus.doc} Basexcli()
    (long_description)
    @type  Static Function
    @author user
    @since 03/11/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Basexcli(lIncl)

Local aArea     :=  GetArea()
Local lAtivo    := .T.

If lIncl .And. 'MODELO' $ cPatr
    MsgAlert("Para inclus�o e altera��o de leiaute padr�o, utilize a op��o correta")
    Return(.F.)
EndIf 

If !Empty(cPatr) 
    aCols := {}
   
    cQuery := "SELECT Z07_CHAPA,Z07_SELECA,Z07_CODPRO,B1_DESC,Z07_VLRVND,Z07_CONSUM,"
    cQuery += " Z07_CLIENT,Z07_LOJA"

    If !'MODELO' $ Alltrim(cPatr)
        cQuery += " ,AAM_XCODTA,DA1_PRCVEN,DA1_XCONSU"
    EndIf
    
    cQuery += " FROM "+RetSQLName("Z07")+" Z07"

    If !'MODELO' $ Alltrim(cPatr)
        cQuery += " INNER JOIN "+RetSQLName("AAN")+" AAN ON AAN_FILIAL='01 ' AND AAN_XCBASE=Z07_CHAPA AND AAN.D_E_L_E_T_=' ' "
        cQuery += " INNER JOIN "+RetSQLName("AAM")+" AAM ON AAM_FILIAL=AAN_FILIAL AND AAM_CONTRT=AAN_CONTRT AND AAM.D_E_L_E_T_=' '"
        cQuery += " LEFT JOIN "+RetSQLName("DA1")+" DA1 ON DA1_FILIAL=AAN_FILIAL AND DA1_CODTAB=AAM_XCODTA AND DA1_CODPRO=Z07_CODPRO AND DA1.D_E_L_E_T_=' '"
    EndIf 

    cQuery += " INNER JOIN "+RetSQLName("SB1")+ " B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=Z07_CODPRO AND B1.D_E_L_E_T_=' '"
    cQuery += " WHERE Z07_FILIAL='"+xFilial("Z07")+"' AND Z07_CHAPA='"+cPatr+"' AND Z07.D_E_L_E_T_=' '"
    
    IF Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    ENDIF

    MemoWrite("CONOPC03.SQL",cQuery)
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")  

    WHILE !EOF() 
        
        
        Aadd(aCols,{'',;
                    TRB->Z07_SELECA,;
                    TRB->Z07_CODPRO,;
                    TRB->B1_DESC,;
                    If(!'MODELO' $ Alltrim(cPatr),TRB->DA1_PRCVEN,0),;
                    If(!'MODELO' $ Alltrim(cPatr),TRB->DA1_XCONSU,0),;
                    .F.})

        If !'MODELO' $ Alltrim(cPatr)
            cCli := TRB->Z07_CLIENT
            cLj  := TRB->Z07_LOJA
        Else 
            cCli    := ''
            cLj     := ''
        EndIf 
        Dbskip()
    EndDo 

    If len(aCols) < 1 .AND. !'MODELO' $ Alltrim(cPatr)
        Aadd(aCols,{'','','','',0,0,.f.})
        DbSelectArea("AA3")
        DbSetOrder(7)
        If Dbseek(xFilial("AA3")+cPatr)
            cCli := AA3->AA3_CODCLI
            cLj  := AA3->AA3_LOJA
            lAtivo := .T.
        Else 
            lAtivo := .F.
        EndIf

        DbSelectArea("SA1")
        DbSetOrder(1)
        Dbseek(xFilial("SA1")+Avkey(cCli, "A1_COD") + Avkey(cLj, "A1_LOJA"))

    EndIf 

    If !lAtivo .And. !"MODELO" $ cPatr 
        MsgAlert("Ativo n�o encontrado ou base instalada n�o atribu�da a um cliente.")
        Return(.F.)
    EndIf 

    DbSelectArea("SN1")
    DbSetOrder(2)
    If Dbseek(xfilial("SN1")+cPatr)
        cLocIn := SN1->N1_XPTVEND
    EndIf

    If !Empty(cLocIn)
        oSay8:settext(Posicione("NNR",1,xFilial("NNR")+cLocIn,"NNR_DESCRI"))
        oGet4:disable()
    EndIf 

    Asort(aCols,,,{|x,y| x[2] < y[2]})

    oList1:SetArray(aCols)
    oList1:bLine := {||{aCols[oList1:nAt,01],; 
                        aCols[oList1:nAt,02],;
                        aCols[oList1:nAt,03],; 
                        aCols[oList1:nAt,04],;
                        Transform(aCols[oList1:nAt,05],"@E 999,999.99"),;
                        Transform(aCols[oList1:nAt,06],"@E 999,999.99")}} 
EndIf 

If !Empty(cCli)

    DbSelectArea("SA1")
    DbSetOrder(1)
    If Dbseek(xFilial("SA1")+cCli+cLj)
        oSay3:settext("")
        oSay6:settext("")

        oSay3:settext(SA1->A1_NOME)
        oSay6:settext(Alltrim(SA1->A1_END)+' - '+Alltrim(SA1->A1_BAIRRO)+' - '+Alltrim(SA1->A1_MUN)+' - '+Alltrim(SA1->A1_EST))
        
        
    EndIf 
EndIf 

oGet2:disable()
oGet3:disable()

IF 'MODELO' $ Alltrim(cPatr)
    oGet4:disable()
EndIf 

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return
