#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"

/*
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇 Fonte     낢� AVSIINT                                                   굇    
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       �  Integracao Protheus X VMPay                               낢�
굇쳐컴컴컴컴컨컴컫컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿌nalista Resp.�  Data  �                                               낢�
굇쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�              �  /  /  �                                               낢�
굇�              �  /  /  �                                               낢�
굇읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/

USER FUNCTION AVSIINT(contrato)

LOCAL   nCont      :=    0
LOCAL   lTeca      :=    .F.
PRIVATE aItens     :=    {'1=Ativo','2=Numero Serie','3=Produto (desc.)','4=Cliente','5=Pick-Lists','6=Linha'}
PRIVATE aCateg     :=    {} //{'1=BEBIDAS QUENTES','2=BEBIDAS GELADAS','3=SNACKS','4=LANCHES QUENTES','5=CONGELADOS','6=COMBINADA','7=AUTOATENDIMENTO'}
PRIVATE cCombo1    :=    aItens[1]     
PRIVATE cBusca     :=    space(35)
PRIVATE oDlg1,oGrp1,oBrw1,oFld1,oBrw4,oBrw3,oBrw2,oBrw5,oFld2,oBrw6,oBrw7,oBrw8,oMenu,oTButton1
PRIVATE oBrw10,oBrw11,oGrp2,oBmp1,oBmp2,oSay1,oSay2,oSay3,oGrp3,oSay4,oSay5,oSay6,oMenuP
PRIVATE oSay8,oBtn1,oBtn2    
PRIVATE oList,oList2,oList3,oList4,oList5,oList6,oList7,oList8,oList9,oList10
PRIVATE aPick      :=    {}
PRIVATE aList      :=    {} 
PRIVATE aListB     :=    {} 
PRIVATE aList1B    :=    {}
PRIVATE aList1     :=    {}
PRIVATE aList2B    :=    {}
PRIVATE aList2     :=    {}
PRIVATE aList3B    :=    {}
PRIVATE aList3     :=    {} 
PRIVATE aList4B    :=    {}
PRIVATE aList4     :=    {}
PRIVATE aList5B    :=    {}
PRIVATE aList5     :=    {}
PRIVATE aList6     :=    {}
PRIVATE aList7     :=    {}
PRIVATE aList8B    :=    {}
PRIVATE aList8     :=    {}
PRIVATE aList9B    :=    {}
PRIVATE aList9     :=    {}
PRIVATE aList10    :=    {}
PRIVATE oOk        :=    LoadBitmap(GetResources(),'br_verde')  //Controla se o pedido foi alterado ou nao no grid.
PRIVATE oNo        :=    LoadBitmap(GetResources(),'br_vermelho')

DEFAULT contrato   := ''

    IF Select("SM0") == 0
        RpcSetType(3)
        RPCSetEnv("01","0101")
    ENDIF

//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" //MODULO "FAT" TABLES "SA1"        

Aadd(aList,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList1,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList2,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList3,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList4,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList5,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList6,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList7,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList8,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList9,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList10,{.T.,'','','','','','','','','','','','','','','','','',''})

DbSelectArea("SBM")
Dbgotop()
WHILE !EOF()
    Aadd(aCateg,{Alltrim(SBM->BM_GRUPO),Alltrim(SBM->BM_DESC)})    
    Dbskip()         
ENDDO

// Processa({|| Busca1(contrato),"Aguarde, buscando ativos"})

WHILE !empty(procname(nCont))
    IF alltrim(UPPER(procname(nCont))) $ "TECA201"
        lTeca := .T.
        EXIT
    ENDIF 
    nCont++
ENDDO

oDlg1    := MSDialog():New( 017,058,628,1344,"Pick-List",,,.F.,,,,,,.T.,,,.T. )

    oGrp1    := TGroup():New( 000,004,148,280,"Ativos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,008,144,276},,, oGrp1 ) 
        oList    := TCBrowse():New(008,008,270,137,, {'','Ativo','Modelo','Num. S�rie','Linha'},{10,30,40,20},;
                                    oGrp1,,,,{|| FHelp()},{|| editped(oList:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList:SetArray(aList)
        oList:bLine := {||{ IF(aList[oList:nAt,01],oOk,oNo),; 
                              Alltrim(aList[oList:nAt,02]),;
                              aList[oList:nAt,03],;
                              aList[oList:nAt,04],;
                              aList[oList:nAt,19]}}
                                                                               //,"Invent�rios"
    oFld1    := TFolder():New( 000,284,{"Pick-List","Leituras","Sangrias"},{},oDlg1,,,,.T.,.F.,348,148,) 

        //oBrw4      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,132,344},,, oFld1:aDialogs[3] ) 
        oList1    := TCBrowse():New(000,001,344,135,, {'','Mola','Produto','Descri豫o','Quant.','Conf','Nivel Par','Saldo'},{5,20,20,90,20,20,20},;
                           oFld1:aDialogs[1],,,,{|| /*FHelp(oList:nAt)*/},{|| editcol(oList1:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oList1:SetArray(aList1)
        oList1:bLine := {||{IF(aList1[oList1:nAt,01],oOk,oNo),;
                            aList1[oList1:nAt,02],; 
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04],;
                            aList1[oList1:nAt,05],;
                            aList1[oList1:nAt,06],;  
                            aList1[oList1:nAt,16],;  
                            aList1[oList1:nAt,07]}}
                             
        //oBrw3      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,132,344},,, oFld1:aDialogs[2] ) 
        oList8    := TCBrowse():New(000,001,344,135,, {'Data','Sele豫o','Produto','Descri豫o','Quant. Apont.','Valor'},{30,30,50,120,30,30},;
                           oFld1:aDialogs[2],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oList8:SetArray(aList8)
        oList8:bLine := {||{aList8[oList8:nAt,01],;
                            aList8[oList8:nAt,02],; 
                            aList8[oList8:nAt,03],;
                            aList8[oList8:nAt,04],;
                            aList8[oList8:nAt,05],;
                            aList8[oList8:nAt,08]}}

        //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,132,344},,, oFld1:aDialogs[1] ) 
        oList9    := TCBrowse():New(000,001,344,135,, {'Data','Audit','Valor'},{30,40,40},;
                            oFld1:aDialogs[3],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oList9:SetArray(aList9)
        oList9:bLine := {||{aList9[oList9:nAt,01],;
                            aList9[oList9:nAt,02],; 
                            aList9[oList9:nAt,03]}}
                             
        //oBrw5      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,132,344},,, oFld1:aDialogs[4] ) 

    oFld2    := TFolder():New( 152,004,{"Produtos","Planogramas","Locais Inst.","Rotas","C�nisteres","oaDialogs10"},{},oDlg1,,,,.T.,.F.,276,132,) 

        //oBrw6      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[1] ) 
        oList2    := TCBrowse():New(000,001,274,110,, {'','C�digo','Descri豫o','Saldo'},{10,30,40,20},;
                                    oFld2:aDialogs[1],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList2:SetArray(aList2)
        oList2:bLine := {||{ IF(aList2[oList2:nAt,01],oOk,oNo),; 
                                Alltrim(aList2[oList2:nAt,02]),;
                                aList2[oList2:nAt,03],;
                                aList2[oList2:nAt,04]}}    
                              
        //oBrw7      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[2] ) 
        oList3    := TCBrowse():New(000,001,274,110,, {'','Ativo','Selecao','Produto','Descri豫o','Capacidade','Nivel Par','Nivel Alerta','Valor'},{10,30,30,40,30,30,30,30,30},;
                                    oFld2:aDialogs[2],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList3:SetArray(aList3)
        oList3:bLine := {||{ IF(aList3[oList3:nAt,01],oOk,oNo),; 
                                Alltrim(aList3[oList3:nAt,02]),;
                                Strzero(val(aList3[oList3:nAt,03]),2),;
                                aList3[oList3:nAt,04],;
                                aList3[oList3:nAt,05],;
                                aList3[oList3:nAt,06],;
                                aList3[oList3:nAt,07],;
                                aList3[oList3:nAt,08],;
                                Transform(aList3[oList3:nAt,09],"@E 999,999.99")}}    

        //oBrw8      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[3] ) 
        oList4    := TCBrowse():New(000,001,274,110,, {'','Cod. LOCAL','Descricao'},{10,30,40},;
                                    oFld2:aDialogs[3],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList4:SetArray(aList4)             
        oList4:bLine := {||{ IF(aList4[oList4:nAt,01],oOk,oNo),; 
                                        aList4[oList4:nAt,02],;
                                        aList4[oList4:nAt,03],;
                                        aList4[oList4:nAt,04]}}   
                               
        //oBrw9      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[4] ) 
        oList5    := TCBrowse():New(000,001,274,110,, {'','Codigo','Descricao'},{10,30,40},;
                                    oFld2:aDialogs[4],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList5:SetArray(aList5)
        oList5:bLine := {||{ IF(aList5[oList5:nAt,01],oOk,oNo),; 
                                Alltrim(aList5[oList5:nAt,02]),;
                                aList5[oList5:nAt,03]}}   
                               
        //oBrw10     := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[5] ) 
        oList6    := TCBrowse():New(000,001,274,110,, {'','Insumo','Capacidade','Nivel Par','Nivel Alerta','Dispon�vel','Utilizado'},{10,80,30,30,30,30,30},;
                                    oFld2:aDialogs[5],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList6:SetArray(aList6)
        oList6:bLine := {||{ IF(aList6[oList6:nAt,01],oOk,oNo),; 
                                Alltrim(aList6[oList6:nAt,02]),;
                                aList6[oList6:nAt,03],;
                                aList6[oList6:nAt,04],;
                                aList6[oList6:nAt,05],;
                                aList6[oList6:nAt,06],;
                                aList6[oList6:nAt,07]}}   
                               
        //oBrw11     := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[6] ) 
        oList7    := TCBrowse():New(000,001,274,110,, {'','Ativo','Modelo','Pick-List'},{10,30,40,20},;
                        oFld2:aDialogs[6],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList7:SetArray(aList7)
        oList7:bLine := {||{ IF(aList7[oList7:nAt,01],oOk,oNo),; 
                                Alltrim(aList7[oList7:nAt,02]),;
                                aList7[oList7:nAt,03],;
                                aList7[oList7:nAt,04]}}    

    oGrp2    := TGroup():New( 152,284,198,424,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

        oBmp1    := TBitmap():New( 159,288,044,034,,"\system\lgrl01.bmp",.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. )
        oBmp2    := TBitmap():New( 159,339,044,034,,"\system\lgvmp.bmp",.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. )
        oSay1    := TSay():New( 160,386,{||"Pick List V. 2.0"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
        oSay2    := TSay():New( 178,386,{||"developed by"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
        oSay3    := TSay():New( 186,387,{||"AVSI Pro"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)

    oGrp3    := TGroup():New( 209,284,285,632,"Informa寤es do Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        
        oSay4    := TSay():New( 221,288,{||"oSay4"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,432,008)
        oSay5    := TSay():New( 233,288,{||"oSay5"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,432,008)
        oSay6    := TSay():New( 245,288,{||"oSay6"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,432,008)
        oSay7    := TSay():New( 257,288,{||"oSay7"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,432,008)
        oSay8    := TSay():New( 269,288,{||"oSay8"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,432,008)
    
    oGrp4    := TGroup():New( 151,428,208,548,"Busca",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

        oSay9    := TSay():New( 179,432,{||"Procurar por"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oCBox1   := TComboBox():New( 163,432,{|u|IF(PCount()>0,cCombo1:=u,cCombo1)},aItens,108,010,oGrp4,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
        oGet1    := TGet():New( 179,480,{|u|IF(PCount()>0,cBusca:=u,cBusca)},oGrp4,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        oBtn3    := TButton():New( 195,438,"Procurar",oGrp4,{||Busca2(1)},037,008,,,,.T.,,"",,,,.F. )
        oBtn4    := TButton():New( 195,495,"Filtrar",oGrp4,{||Busca2(2)},037,008,,,,.T.,,"",,,,.F. )
    

    oBtn2    := TButton():New( 180,588,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
     
     //Botao de faturamento
    oMenu := TMenu():New(0,0,0,0,.T.)
    // Adiciona itens no Menu
    oTMenuIte1   := TMenuItem():New(oDlg1,"Pick-List Vmpay",,,,{|| Processa({|| Vmpay(),"Buscando informa寤es"})},,,,,,,,,.T.)
    oTMenuIte7   := TMenuItem():New(oDlg1,"Vendas Vmpay",,,,{|| Processa({|| Vendaspay(),"Buscando informa寤es"})},,,,,,,,,.T.)
    oTMenuIte2   := TMenuItem():New(oDlg1,"Validar Saldo",,,,{|| Processa({||saldos(),"Aguarde..."})},,,,,,,,,.T.)   
    oTMenuIte3   := TMenuItem():New(oDlg1,"Inverter",,,,{|| Processa({||inverte(),"Aguarde..."})},,,,,,,,,.T.) 
    oTMenuIte4   := TMenuItem():New(oDlg1,"Validar Planograma",,,,{|| Processa({|| ValidPlan(),"Aguarde..."})},,,,,,,,,.T.) 
    oTMenuIte5   := TMenuItem():New(oDlg1,"Gerar PV",,,,{|| Processa({||pedido(),"Aguarde..."})},,,,,,,,,.T.) 
    //oTMenuIte6 := TMenuItem():New(oDlg1,"Exportar Remessas",,,,{|| Processa({||Remessas(),"Aguarde..."})},,,,,,,,,.T.) 
    IF !lTeca
        oMenu:Add(oTMenuIte1)
        oMenu:Add(oTMenuIte7)
        oMenu:Add(oTMenuIte2)
        oMenu:Add(oTMenuIte3)
        oMenu:Add(oTMenuIte4)
        oMenu:Add(oTMenuIte5) 
    ELSE
        oMenu:Add(oTMenuIte7)
    ENDIF
    //oMenu:Add(oTMenuIte6)
    //oBtn1      := TButton():New( 160,588,"oBtn1",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
    // Cria bot�o que sera usado no Menu
    oTButton1 := TButton():New( 160, 588, "Op寤es",oDlg1,{||},037,12,,,.F.,.T.,.F.,,.F.,,,.F. )
    // Define bot�o no Menu
    oTButton1:SetPopupMenu(oMenu)     
    
    IF !lTeca
        // Menu popup grid 3
        MENU oMenuP POPUP 
        MENUITEM "Salvar Planograma" ACTION ( saveplan())
        MENUITEM "Incluir Planograma" ACTION ( incplan(1))
        MENUITEM "Alterar Planograma" ACTION ( incplan(2))
        MENUITEM "Excluir Planograma" ACTION ( excplan())
        MENUITEM "Replicar Planograma" ACTION ( repplan())
        
        ENDMENU                                                                           
    
        // oList3:bRClicked := { |oObject,nX,nY| oMenuP:Activate( nX, (nY-10), oObject ) }
    ENDIF                                                                               

    // Menu popup grid 2
    MENU oMenu8 POPUP 
    MENUITEM "Salvar Venda" ACTION ( savevend())
    
    ENDMENU                                                                           

    // oList8:bRClicked := { |oObject,nX,nY| oMenu8:Activate( nX, (nY-10), oObject ) }
    
oDlg1:Activate(,,,.T.)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/11/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �   Buscan inicial;                                          볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION Busca1(contrato)

LOCAL cQuery 
LOCAL aAtivos    :=    {}
LOCAL nX

cQuery := "SELECT AA3_CHAPA,B1_DESC,AA3_NUMSER,AA3_CODCLI,AA3_LOJA,AA3_HORDIA,B1_GRUPO AS AA3_XCATEG,AA3_CODLOC,"
cQuery += " A1_NOME,A1_NREDUZ,A1_END,A1_BAIRRO,A1_MUN,A1_EST,A1_CEP,AA3_CODPRO"
cQuery += " FROM "+RetSQLName("AA3")+" AA3 "
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=AA3_CODPRO AND B1.D_E_L_E_T_=''"
//cQuery += " INNER JOIN "+RetSQLName("SZN")+" ZN ON ZN_NUMSER=AA3_NUMSER AND ZN.D_E_L_E_T_=''"

cQuery += " INNER JOIN "+RetSQLName("AAN")+" AAN ON AAN_FILIAL=AA3_FILIAL AND AAN_CODIND=AA3_NUMSER AND AAN.D_E_L_E_T_=''"

IF !Empty(contrato)
    //Puxar leituras para faturamento
    cQuery += " AND AAN_CONTRT='"+contrato+"'"

ENDIF 

cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=AA3_CODCLI AND A1_LOJA=AA3_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " WHERE AA3.D_E_L_E_T_='' AND AA3_CODCLI <> '' AND AA3_CODCLI <> '999999'"
cQuery += " ORDER BY AA3_CHAPA"  //AND AA3_XVMPAY='1' 

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF() 
    IF !Empty(TRB->AA3_NUMSER) 

        nPos := Ascan(aCateg,{|x| x[1] == Alltrim(TRB->AA3_XCATEG)})
                         
        Aadd(aList,{.T.,TRB->AA3_NUMSER,TRB->B1_DESC,TRB->AA3_NUMSER,;
                    TRB->A1_NOME,TRB->A1_NREDUZ,TRB->A1_END,TRB->A1_BAIRRO,TRB->A1_MUN,TRB->A1_EST,TRB->A1_CEP,;
                    '','','','',.F.,TRB->AA3_CODCLI,TRB->AA3_LOJA,IF(nPos>0,aCateg[nPos,2],''),TRB->AA3_CODLOC,TRB->AA3_CODPRO})
        Aadd(aListB,{.T.,TRB->AA3_NUMSER,TRB->B1_DESC,TRB->AA3_NUMSER,;
                    TRB->A1_NOME,TRB->A1_NREDUZ,TRB->A1_END,TRB->A1_BAIRRO,TRB->A1_MUN,TRB->A1_EST,TRB->A1_CEP,;
                    '','','','',.F.,TRB->AA3_CODCLI,TRB->AA3_LOJA,IF(nPos>0,aCateg[nPos,2],''),TRB->AA3_CODLOC,TRB->AA3_CODPRO})
                    
        IF Ascan(aAtivos,{|x| Alltrim(x) == Alltrim(TRB->AA3_CHAPA)}) == 0
            Aadd(aAtivos,TRB->AA3_CHAPA)
        ENDIF
    ENDIF    
    Dbskip()
ENDDO
 
cQuery := "SELECT B1_COD,B1_DESC"
cQuery += " FROM "+RetSQLName("SB1")+" SB1 "
cQuery += " WHERE SB1.D_E_L_E_T_='' AND B1_MSBLQL<>'1'"

cQuery += " AND B1_GRUPO  IN('PA72')" //'PA62' ,'PA73','PA74'

cQuery += " ORDER BY B1_COD"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
    
DbSelectArea("TRB")  

WHILE !EOF()                            
    Aadd(aList2,{.F.,TRB->B1_COD,TRB->B1_DESC,0,'','','','','','','','','','','','','','',''})
    Aadd(aList2B,{.F.,TRB->B1_COD,TRB->B1_DESC,0,'','','','','','','','','','','','','','',''})
    
    Dbskip()
ENDDO 

DbSelectArea("SB2")
DbSetOrder(1)
FOR nX := 1 TO len(aList2B)
    DbSeek(xFilial("SB2")+aList2B[nX,02]+'01')
    nSaldo    :=    SaldoSB2()
    aList2B[nX,04] := nSaldo
    aList2[nX,04] := nSaldo
NEXT nX

cQuery := "SELECT ZO_NUMSER,ZO_SEQUEN,ZO_BEBIDA,B1_DESC,0 AS QTD,'' AS CLIENTE,'' AS LOJA,ZO_MAQUINA"
cQuery += " FROM "+RetSQLName("SZO")+" ZO"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=ZO_BEBIDA AND B1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("AAN")+" AN ON AAN_XCBASE=ZO_NUMSER AND AN.D_E_L_E_T_=''"
cQuery += " WHERE ZO.D_E_L_E_T_='' AND ZO_NUMSER<>''" 
cQuery := "SELECT ABS_LOCAL,ABS_DESCRI,ABS_CODIGO,ABS_LOJA,ABS_END,ABS_BAIRRO,ABS_MUNIC,ABS_ESTADO,ABS_CEP"
cQuery += " FROM "+RetSQLName("ABS")
cQuery += " WHERE D_E_L_E_T_=''"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF()   
    Aadd(aList4B,{.F.,TRB->ABS_LOCAL,Alltrim(TRB->ABS_DESCRI),TRB->ABS_CODIGO,TRB->ABS_LOJA,;
                    Alltrim(TRB->ABS_END),Alltrim(TRB->ABS_BAIRRO),Alltrim(TRB->ABS_MUNIC),Alltrim(TRB->ABS_ESTADO),TRB->ABS_CEP})
    Dbskip()
ENDDO

cQuery := "SELECT NNR_CODIGO,NNR_DESCRI"
cQuery += " FROM "+RetSQLName("NNR")+" NNR "
cQuery += " WHERE NNR.D_E_L_E_T_='' AND SUBSTRING(NNR_CODIGO,1,1)='R' ORDER BY NNR_CODIGO"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
    
DbSelectArea("TRB")  

WHILE !EOF()     
    Aadd(aList5B,{.F.,TRB->NNR_CODIGO,TRB->NNR_DESCRI,'','','','','',''})
    Aadd(aList5,{.F.,TRB->NNR_CODIGO,TRB->NNR_DESCRI,'','','','','',''})
    Dbskip()
ENDDO

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/12/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �   Pesquisas                                                볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION Busca2(nOpca)

LOCAL nX

IF cCombo1 == "1"
    IF nOpca == 1
        //oList:nAt := 1
        oList:refresh()
        nPos := Ascan(aList,{|x| Alltrim(cBusca) $ Alltrim(x[2])})
        IF nPos > 0
            oList:nAt := nPos
        ENDIF              
    ELSE
        aList := {}
        FOR nX := 1 TO len(aListB)
            IF Alltrim(aListB[nX,02]) == Alltrim(cBusca)
                Aadd(aList,aListB[nX])
                oList:SetArray(aList)
                oList:bLine := {||{ IF(aList[oList:nAt,01],oOk,oNo),; 
                                        Alltrim(aList[oList:nAt,02]),;
                                        aList[oList:nAt,03],;
                                        aList[oList:nAt,04],;
                                        aList[oList:nAt,19]}}
                EXIT
            ENDIF   
        NEXT nX  
        
        IF len(aList) < 1
            //FOR nX := 1 TO len(aListB)
            //    Aadd(aList,aListB[nX])
            //NEXT nX    
            aList := aClone(aListB)
        ENDIF  
    
        oList:SetArray(aList)
        oList:bLine := {||{ IF(aList[oList:nAt,01],oOk,oNo),; 
                                Alltrim(aList[oList:nAt,02]),;
                                aList[oList:nAt,03],;
                                aList[oList:nAt,04],;
                                aList[oList:nAt,19]}}
        //oList:nAt := 1
    ENDIF   
    oList:refresh()
    oDlg1:refresh()    
ElseIf cCombo1 == "2" 
    IF nOpca == 1
    //    oList:nAt := 1
        oList:refresh()
        nPos := Ascan(aList,{|x| Alltrim(cBusca) $ Alltrim(x[4])})
        IF nPos > 0
            oList:nAt := nPos
        ENDIF              
    ELSE
        aList := {}
        FOR nX := 1 TO len(aListB)
            IF Alltrim(aListB[nX,04]) == Alltrim(cBusca)
                Aadd(aList,aListB[nX])
                oList:SetArray(aList)
                oList:bLine := {||{ IF(aList[oList:nAt,01],oOk,oNo),; 
                                        Alltrim(aList[oList:nAt,02]),;
                                        aList[oList:nAt,03],;
                                        aList[oList:nAt,04],;
                                        aList[oList:nAt,19]}}
                EXIT
            ENDIF   
        NEXT nX  
        
        IF len(aList) < 1
            //FOR nX := 1 TO len(aListB)
            //    Aadd(aList,aListB[nX])
            //NEXT nX    
            aList := aClone(aListB)

            oList:SetArray(aList)
            oList:bLine := {||{ IF(aList[oList:nAt,01],oOk,oNo),; 
                                    Alltrim(aList[oList:nAt,02]),;
                                    aList[oList:nAt,03],;
                                    aList[oList:nAt,04],;
                                    aList[oList:nAt,19]}}
                
        ENDIF
    ENDIF   
    oList:refresh()
    oDlg1:refresh()   
ElseIf cCombo1 == "3" 
    IF nOpca == 1
        //oList2:nAt := 1
        oList2:refresh()
        nPos := Ascan(aList2,{|x| Alltrim(upper(cBusca)) $ Alltrim(x[3])})
        IF nPos > 0
            oList2:nAt := nPos
        ENDIF              
    ELSE
        aList2 := {}
        FOR nX := 1 TO len(aList2B)
            IF Alltrim(upper(cBusca)) $ Alltrim(upper(aList2B[nX,03])) 
                Aadd(aList2,aList2B[nX])
            ENDIF   
        NEXT nX  
        
        IF len(aList2) < 1
            aList2 := aClone(aList2B)  
        ENDIF
  
          oList2:SetArray(aList2)
        oList2:bLine := {||{ IF(aList2[oList2:nAt,01],oOk,oNo),; 
                                Alltrim(aList2[oList2:nAt,02]),;
                                aList2[oList2:nAt,03],;
                                aList2[oList2:nAt,04]}}
    ENDIF
    oList2:refresh()
    oDlg1:refresh()
ElseIf cCombo1 == "4" 
    aList := {}
    FOR nX := 1 TO len(aListB)
        IF Alltrim(UPPER(cBusca)) $ Alltrim(aListB[nX,05]) .Or. Alltrim(UPPER(cBusca)) $ Alltrim(aListB[nX,06])
            Aadd(aList,aListB[nX])
        ENDIF
    NEXT nX
    
    IF len(aList) < 1
        IF !Empty(cBusca)
            MsgAlert("N�o encontrado Ativos para o cliente pesquisado")
        ENDIF
        FOR nX := 1 TO len(aListB)
            Aadd(aList,aListB[nX])
        NEXT nX    
    ENDIF

    oList:SetArray(aList)
    oList:bLine := {||{ IF(aList[oList:nAt,01],oOk,oNo),; 
                            Alltrim(aList[oList:nAt,02]),;
                            aList[oList:nAt,03],;
                            aList[oList:nAt,04],;
                            aList[oList:nAt,19]}}
    oList:nAt:=1
    oList:refresh()
    oDlg1:refresh()

ElseIf cCombo1 == "5"
    aList := {}
    FOR nX := 1 TO len(aListB)
        IF aListB[nX,16]
            Aadd(aList,aListB[nX])
        ENDIF
    NEXT nX    
    
    IF len(aList) < 1
        MsgAlert("N�o h� pick-lists pendentes")
        FOR nX := 1 TO len(aListB)
            Aadd(aList,aListB[nX])
        NEXT nX    
    ENDIF
    
    oList:SetArray(aList)
    oList:bLine := {||{ IF(aList[oList:nAt,01],oOk,oNo),; 
                            Alltrim(aList[oList:nAt,02]),;
                            aList[oList:nAt,03],;
                            aList[oList:nAt,04],;
                            aList[oList:nAt,19]}}
    oList:nAt:=1
    oList:refresh()
    oDlg1:refresh()
ElseIf cCombo1 == "6"
    aList := {}

    FOR nX := 1 TO len(aListB)
        IF Alltrim(UPPER(cBusca)) $ Alltrim(aListB[nX,19])
            Aadd(aList,aListB[nX])
        ENDIF
    NEXT nX
    
    IF len(aList) < 1
        IF !Empty(cBusca)
            MsgAlert("N�o encontrado Ativos com a Linha pesquisada.","busca2 - AVSIINT")
        ENDIF
        FOR nX := 1 TO len(aListB)
            Aadd(aList,aListB[nX])
        NEXT nX    
    ENDIF

    oList:SetArray(aList)
    oList:bLine := {||{ IF(aList[oList:nAt,01],oOk,oNo),; 
                            Alltrim(aList[oList:nAt,02]),;
                            aList[oList:nAt,03],;
                            aList[oList:nAt,04],;
                            aList[oList:nAt,19]}}

    //oList:refresh()
    //oDlg1:refresh()
ENDIF

Fhelp()

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/12/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �  Atualizacao dos itens conforme ativo selecionado          볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION FHelp()

LOCAL nX

oSay4:settext("")
oSay5:settext("")
oSay6:settext("")
oSay7:settext("")
oSay8:settext("")

oSay4:settext('Cliente  - '+Alltrim(aList[oList:nAT,05])+" / "+Alltrim(aList[oList:nAT,06]))
oSay5:settext('Endere�o - '+Alltrim(aList[oList:nAT,07])+" / "+Alltrim(aList[oList:nAT,08])+" / "+Alltrim(aList[oList:nAT,09])+" / "+Alltrim(aList[oList:nAT,10])+" / "+Alltrim(aList[oList:nAT,11]))

aList1 := {}
aList3 := {}  
aList4 := {}  
aList6 := {}  
aList8 := {} 
aList9 := {}

FOR nX := 1 TO len(aList3B)
    IF Alltrim(aList[oList:nAt,02]) == Alltrim(aList3B[nX,02])
        Aadd(aList3,aList3B[nX])
    ENDIF
NEXT nX  

IF len(aList3) < 1
    Aadd(aList3,{.T.,'','','','','','','','','','','','','','','','','',''})
ENDIF

oList3:nAt := 1
oList3:SetArray(aList3)
oList3:bLine := {||{ IF(aList3[oList3:nAt,01],oOk,oNo),; 
                      Alltrim(aList3[oList3:nAt,02]),;
                      Strzero(val(aList3[oList3:nAt,03]),2),;
                      aList3[oList3:nAt,04],;
                      aList3[oList3:nAt,05],;
                      aList3[oList3:nAt,06],;
                      aList3[oList3:nAt,07],;
                      aList3[oList3:nAt,08],;
                      Transform(aList3[oList3:nAt,09],"@E 999,999.99")}}  

FOR nX := 1 TO len(aList1B)
    IF Alltrim(aList1B[nX,08]) == Alltrim(aList[oList:nAt,02])
        Aadd(aList1,aList1B[nX])
    ENDIF
NEXT nX
         
IF len(aList1) < 1
    Aadd(aList1,{.T.,'','','','','','','','','','','','','','','','','',''})
ENDIF

oList1:nAt := 1
oList1:SetArray(aList1)
oList1:bLine := {||{IF(aList1[oList1:nAt,01],oOk,oNo),;
                    aList1[oList1:nAt,02],; 
                     aList1[oList1:nAt,03],;
                     aList1[oList1:nAt,04],;
                     aList1[oList1:nAt,05],;
                     aList1[oList1:nAt,06],;  
                     aList1[oList1:nAt,16],;  
                     aList1[oList1:nAt,07]}} 
                     
FOR nX := 1 TO len(aList4B)
    IF aList4B[nX,04] == aList[oList:nAt,17] .And. aList4B[nX,05] == aList[oList:nAt,18]    
        Aadd(aList4,aList4B[nX])
        IF aList4B[nX,02] == aList[oList:nAt,20] .And. !Empty(aList[oList:nAt,20])
            aList4[len(aList4),01] := .T.
            IF !Empty(aList4[len(aList4),06]) 
                oSay6:settext("LOCAL de Instala豫o "+aList4[len(aList4),06]+" / "+aList4[len(aList4),07]+" / "+aList4[len(aList4),08]+" / "+aList4[len(aList4),09]+" / "+aList4[len(aList4),10])
            ENDIF
        ENDIF  
    ENDIF
NEXT nX

IF len(aList4) < 1
    Aadd(aList4,{.F.,'','','','','','','','','','','','','','','','','',''})
ENDIF

oList4:nAt := 1
oList4:SetArray(aList4)             
oList4:bLine := {||{ IF(aList4[oList4:nAt,01],oOk,oNo),; 
                      aList4[oList4:nAt,02],;
                      aList4[oList4:nAt,03],;
                      aList4[oList4:nAt,04]}}   

FOR nX := 1 TO len(aList8B)
    IF Alltrim(aList8B[nX,06]) == Alltrim(aList[oList:nAt,02])
        Aadd(aList8,aList8B[nX])
        nPos := Ascan(aList3B,{|x| Alltrim(x[2])+Alltrim(x[3]) == Alltrim(aList8B[nX,06])+Alltrim(aList8B[nX,02])})
        IF nPos > 0  
            aList8[len(aList8),03] := aList3B[nPos,04]
            aList8[len(aList8),04] := aList3B[nPos,05]
        ENDIF
    ENDIF
NEXT nX
         
IF len(aList8) < 1
    Aadd(aList8,{'','','','','','','','','','','','','','','','','','',''})
ENDIF

oList8:nAt := 1
oList8:SetArray(aList8)
oList8:bLine := {||{aList8[oList8:nAt,01],;
                    aList8[oList8:nAt,02],; 
                     aList8[oList8:nAt,03],;
                     aList8[oList8:nAt,04],;
                     aList8[oList8:nAt,05],;
                     aList8[oList8:nAt,08]}} 
                     
FOR nX := 1 TO len(aList9B)
    IF Alltrim(aList9B[nX,04]) == Alltrim(aList[oList:nAt,02])
        Aadd(aList9,aList9B[nX])
    ENDIF
NEXT nX
         
IF len(aList9) < 1
    Aadd(aList9,{'','','','','','','','','','','','','','','','','','',''})
ENDIF

oList9:nAt := 1
oList9:SetArray(aList9)
oList9:bLine := {||{aList9[oList9:nAt,01],;
                    aList9[oList9:nAt,02],; 
                     aList9[oList9:nAt,03]}}       

IF len(aList6) < 1
    Aadd(aList6,{.F.,'','','','','','','','','','','','','','','','','','',''})
ENDIF

oList6:SetArray(aList6)
oList6:bLine := {||{ IF(aList6[oList6:nAt,01],oOk,oNo),; 
                      Alltrim(aList6[oList6:nAt,02]),;
                      aList6[oList6:nAt,03],;
                      aList6[oList6:nAt,04],;
                      aList6[oList6:nAt,05],;
                      aList6[oList6:nAt,06],;
                      aList6[oList6:nAt,07]}}   
                                 
                     
oList1:refresh()
oList3:refresh()    
oList4:refresh()
oList6:refresh()
oList8:refresh()
oList9:refresh()
oList:refresh()

oDlg1:refresh()

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/13/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �  Buscar Pick-Lists pendentes                               볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION VMPay()

LOCAL aArea    :=    GetArea()
LOCAL aRet     :=    {}
LOCAL nSld     :=    0
LOCAL cArmz    :=    '01'    
LOCAL lFlag    :=    .f.  
// LOCAL aAuxL    :=    {}
LOCAL nX
                  
aRet := U_PRTWS02()

//'','Mola','Produto','Descri豫o','Quant.','Conf','Nivel Par','Saldo'
FOR nX := 1 TO len(aRet)

    IF Ascan(aList1B,{|x| x[8]+x[2]+x[3] == aRet[nX,01]+aRet[nX,15]+aRet[nX,08]}) == 0
        DbSelectArea("SB2")
        DbSetOrder(1)
        IF DbSeek(xFilial("SB2")+Avkey(aRet[nX,08],"B2_COD")+cArmz)
            nSld := SaldoSB2()
        ENDIF    
        
        cDescr := ''
           IF Ascan(aList2B,{|x| Alltrim(x[2]) == Alltrim(aRet[nX,08])}) > 0
           //IF DbSeek(xFilial("SB1")+aRet[nX,08])
            cDescr := Alltrim(aList2B[Ascan(aList2B,{|x| Alltrim(x[2]) == Alltrim(aRet[nX,08])}),03])
        ENDIF
        
        IF nSld < val(aRet[nX,05]) .Or. nSld == 0
            lFlag := .F.  
            nPosAtv := Ascan(aList,{|x| Alltrim(x[2]) == aRet[nX,01]})
            IF nPosAtv > 0
                aList[nPosAtv,01] := .F.
            ENDIF 
            nPosAtv := Ascan(aListB,{|x| Alltrim(x[2]) == aRet[nX,01]})
            IF nPosAtv > 0
                aListB[nPosAtv,01] := .F.
            ENDIF 
            
        ELSE
            lFlag := .T.
        ENDIF     
        //Marcando ativos que tem pick-lists pendentes
        nPosAtv := Ascan(aList,{|x| Alltrim(x[2]) == aRet[nX,01]})
        IF nPosAtv > 0
            aList[nPosAtv,16] := .T.
        ENDIF
        nPosAtv := Ascan(aListB,{|x| Alltrim(x[2]) == aRet[nX,01]})
        IF nPosAtv > 0
            aListB[nPosAtv,16] := .T.
        ENDIF
        
        Aadd(aList1B,{lFlag,aRet[nX,15],aRet[nX,08],cDescr,;
                    val(aRet[nX,05]),val(aRet[nX,05]),nSld,aRet[nX,01],aRet[nX,02],;
                    aRet[nX,03],aRet[nX,17],aRet[nX,16],aRet[nX,18],aRet[nX,19],aRet[nX,20],aRet[nX,21]})
    ENDIF    
NEXT nX   
          
Asort(aList1B,,,{|x,y| Alltrim(x[8])+Alltrim(x[2]) < Alltrim(y[8])+Alltrim(y[2])})

FOR nX := 1 TO len(aList1B)
    IF Alltrim(aList1B[nX,08]) == Alltrim(aList[oList:nAt,02])
        Aadd(aList1,aList1B[nX])
    ENDIF
NEXT nX
         
IF len(aList1) < 1
    Aadd(aList1,{.T.,'','','','','','','','','','','','','','','','','',''})
ENDIF
 
oList1:nAt := 1
oList1:SetArray(aList1)
oList1:bLine := {||{IF(aList1[oList1:nAt,01],oOk,oNo),;
                    aList1[oList1:nAt,02],; 
                     aList1[oList1:nAt,03],;
                     aList1[oList1:nAt,04],;
                     aList1[oList1:nAt,05],;
                     aList1[oList1:nAt,06],;  
                     aList1[oList1:nAt,16],;  
                     aList1[oList1:nAt,07]}}
oList1:refresh()    
oDlg1:refresh()     

IF MsgYesNo("Filtrar somente ativos com Pick-List pendentes?","VMPay - AVSIINT")
    cCombo1 := "5"
    Busca2(1)    
ENDIF

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/13/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � Edita a coluna de saldo do item do picklist                볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION editcol(nLinha2)

LOCAL aArea     :=    GetArea()
// LOCAL cBkMail    :=    aList1[nLinha2,6]
LOCAL lSaldo    :=    .F.
                       
WHILE !lSaldo
    aList1[nLinha2,6] := space(4-len(cvaltochar(aList1[nLinha2,6])))+cvaltochar(aList1[nLinha2,6])
    lEditCell( aList1, oList1, "", 6)

    aList1[nLinha2,06] := val(aList1[nLinha2,06])
    
    IF aList1[nLinha2,6] <= aList1[nLinha2,7]
        lSaldo := .T.
    ELSE
        IF MsgYesNo("N�o h� saldo para atender este item, confirma a inclus�o desta quantidade?","editcol - PRTOPE01")
            lSaldo := .T.
        ENDIF
    ENDIF    
ENDDO



oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/13/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION saldos()

LOCAL aArea      :=    GetArea()
LOCAL nSaldo     :=    0  
// LOCAL nPedido    :=    0    
LOCAL aSldPrd    :=    {}
LOCAL nX

FOR nX := 1 TO len(aList1B)
    IF Ascan(aSldPrd,{|x| x[1] == aList1B[nX,03]}) == 0
        cProd    :=    aList1B[nX,03]  
        DbSelectArea("SB2")
        DbSetOrder(1)
        DbSeek(xFilial("SB2")+Avkey(cProd,"B2_COD")+Posicione("SB1",1,xFilial("SB1")+cProd,"B1_LOCPAD"))
        nSaldo := SaldoSB2()
        nTotais:= 0
        AEval(aList1B,{|aList1B| nTotais += IF(aList1B[3]==cProd,aList1B[6],0)}) 
        //AEval(aList2B,{|aList2B| nPedido += IF(aList2B[3]==cProd,aList2B[6],0)}) 
        //Aadd(aSldPrd,{aList2B[nX,03],Alltrim(aList2B[nX,04]),aList2B[nX,07],nSaldo,IF(nSaldo>aList2B[nX,07],.T.,.F.)})
        Aadd(aSldPrd,{aList1B[nX,03],Alltrim(aList1B[nX,04]),nTotais,nSaldo,IF(nSaldo<nTotais,.T.,.F.)})
    ENDIF
NEXT nX

Asort(aSldPrd,,,{|x,y| x[5] > y[5]})
 
SldItem(aSldPrd)

RestArea(aArea)

RETURN                         

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT  튍utor  쿘icrosiga           � Data �  03/07/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �   Tela com saldo por item para administracao               볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION SldItem(aProdc)

LOCAL aArea        :=    GetArea()
LOCAL nJ
LOCAL nX
PRIVATE oSaldo1,oSaldo2
PRIVATE aSaldo1    :=    {}
PRIVATE aSaldo2    :=    {}
PRIVATE aItAux1    :=    {}
PRIVATE aItAux2    :=    {}

SetPrvt("oSaldo","oGrsld1","oBrw1","oGrsld2","oBrw2","oBtSld1","oSaySld")

FOR nX := 1 TO len(aProdc)
    IF aProdc[nX,05]
        nPosx := Ascan(aSaldo1,{|x| Alltrim(x[1]) == Alltrim(aProdc[nX,01])}) 
        IF nPosx == 0
            Aadd(aSaldo1,aProdc[nX])
            FOR nJ := 1 TO len(aList1B)
                IF Alltrim(aList1B[nJ,03]) == Alltrim(aProdc[nX,01])
                    Aadd(aItAux2,{Alltrim(aProdc[nX,01]),Alltrim(aProdc[nX,02]),aList1B[nJ,06],aList1B[nJ,08],aList1B[nJ,02]})
                ENDIF
            NEXT nJ
        ENDIF
    ENDIF
NEXT nX

IF len(aItAux2) < 1
    Aadd(aItAux2,{'','','',''})  
ENDIF

IF len(aSaldo1) > 0    
    oSaldo     := MSDialog():New( 092,232,535,1027,"oSaldo",,,.F.,,,,,,.T.,,,.T. )
    
        oGrsld1    := TGroup():New( 000,004,192,196,"Produto",oSaldo,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,008,188,116},,, oGrsld1 ) 
        oSaldo1        := TCBrowse():New(008,008,185,180,, {'Produto','Descricao','Saldo'},{25,40,20},;
                                oGrsld1,,,,{|| FSaldo(oSaldo1:nAt)},{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
    
        oSaldo1:SetArray(aSaldo1)
        oSaldo1:bLine := {||{ aSaldo1[oSaldo1:nAt,01],;
                                Alltrim(aSaldo1[oSaldo1:nAt,02]),;
                                aSaldo1[oSaldo1:nAt,04]}}
    
        oGrsld2    := TGroup():New( 000,200,192,388,"Ativos",oSaldo,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,128,188,260},,, oGrsld2 ) 
        oSaldo2        := TCBrowse():New(008,203,180,180,, {'Ativo','Mola','Produto','Qtd'},{20,20,30,30},;
                                oGrsld2,,,,{|| },{|| editSld(oSaldo2:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
    
        oSaldo2:SetArray(aSaldo2)
        oSaldo2:bLine := {||{ aSaldo2[oSaldo2:nAt,01],;
                                aSaldo2[oSaldo2:nAt,02],;
                                aSaldo2[oSaldo2:nAt,03],;
                                aSaldo2[oSaldo2:nAt,04]}}
    
    oSaySld    := TSay():New( 195,200,{||"Total "},oSaldo,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,137,008)    
    oBtSld2    := TButton():New( 206,128,"Salvar",oSaldo,{||savsld(oSaldo1:nAt)},037,012,,,,.T.,,"",,,,.F. )
    oBtSld1    := TButton():New( 206,228,"Sair",oSaldo,{||oSaldo:end()},037,012,,,,.T.,,"",,,,.F. )
    
    oSaldo:Activate(,,,.T.)
ENDIF
 
RestArea(aArea)

RETURN         
  
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  08/13/18   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION savsld(nLinha)

LOCAL nJ

FOR nJ := 1 TO len(aItAux2)
    nPosSld := Ascan(aList1B,{|x| x[8]+x[2] == aItAux2[nJ,04]+aItAux2[nJ,05]})
    aList1B[nPosSld,06] := aItAux2[nJ,03]
    nPosSld := Ascan(aList1,{|x| x[8]+x[2] == aItAux2[nJ,04]+aItAux2[nJ,05]})
    aList1[nPosSld,06] := aItAux2[nJ,03]

NEXT nJ
  
oList1:refresh()
oDlg1:refresh()
oSaldo:end()                                

Fhelp()

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  03/07/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION FSaldo(nLinha)

LOCAL aArea     :=    GetArea()
LOCAL nTotal    :=    0    
LOCAL nX     

aSaldo2 := {}

FOR nX := 1 TO len(aItAux2)      
    IF Alltrim(aItAux2[nX,01]) == Alltrim(aSaldo1[nLinha,01])
        Aadd(aSaldo2,{aItAux2[nX,04],aItAux2[nX,05],aItAux2[nX,01],aItAux2[nX,03],aItAux2[nX,03]})
    ENDIF
NEXT nX

IF len(aSaldo2) < 1
    Aadd(aSaldo2,{'','','',0})
ENDIF

oSaldo2:SetArray(aSaldo2)
oSaldo2:bLine := {||{ aSaldo2[oSaldo2:nAt,01],;
                        aSaldo2[oSaldo2:nAt,02],;
                        aSaldo2[oSaldo2:nAt,03],;
                        aSaldo2[oSaldo2:nAt,04]}}

FOR nX := 1 TO len(aSaldo2)
    nTotal += aSaldo2[nX,04]
NEXT nX

oSaySld:settext("")
oSaySld:settext("Total   "+cvaltochar(nTotal)+"   /   Diferen�a para Saldo   "+cvaltochar(nTotal-aSaldo1[oSaldo1:nAt,04]))

oSaldo2:refresh()
oSaldo:refresh()

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  08/13/18   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION editSld(nLinha)

LOCAL nTotal    :=    0    
LOCAL nX

aSaldo2[nLinha,04] := space(5)+cvaltochar(aSaldo2[nLinha,04])
      
lEditCell( aSaldo2, oSaldo2, "", 4)
                 
aSaldo2[nLinha,04] := val(aSaldo2[nLinha,04])

nPosBk := Ascan(aItAux2,{|x| x[4]+x[5] == aSaldo2[nLinha,01]+aSaldo2[nLinha,02]})

IF nPosBk > 0
    aItAux2[nPosBk,03] := aSaldo2[nLinha,04]
ENDIF
 
oSaldo2:SetArray(aSaldo2)
oSaldo2:bLine := {||{ aSaldo2[oSaldo2:nAt,01],;
                        aSaldo2[oSaldo2:nAt,02],;
                        aSaldo2[oSaldo2:nAt,03],;
                        aSaldo2[oSaldo2:nAt,04]}}
                        
FOR nX := 1 TO len(aSaldo2)
    nTotal += aSaldo2[nX,04]
NEXT nX

oSaySld:settext("")
oSaySld:settext("Total   "+cvaltochar(nTotal)+"   /   Diferen�a para Saldo   "+cvaltochar(nTotal-aSaldo1[oSaldo1:nAt,04]))
oSaldo2:refresh()
oSaldo:refresh()

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/13/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �  Inverte marcacao do alist com os ativos para geracao do   볍�
굇�          쿾edido                                                      볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION inverte()
                                                 
LOCAL aArea    :=    GetArea()
LOCAL nX

FOR nX := 1 TO len(aList) 
    IF aList[nX,16]
        IF aList[nX,01] 
            aList[nX,01] := .F.
        ELSE 
            aList[nX,01] := .T.
        ENDIF
    ENDIF
NEXT nX
      
oList:refresh()
oDlg1:refresh()

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  02/22/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �   Linha do primeiro grid                                   볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION editped(nLinha)

LOCAL aArea    :=    GetArea()

IF aList[nLinha,01]
    aList[nLinha,01] := .F.
ELSE
    aList[nLinha,01] := .T.
ENDIF

oList:refresh()
oDlg1:refresh()

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/13/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �  Geracao do pedido de venda                                볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION Pedido()

LOCAL aArea      :=    GetArea()
LOCAL aCabec     :=    {}
LOCAL aItens     :=    {}  
LOCAL nItem      :=    1
LOCAL aLinha     :=    {}  
LOCAL nContJ     :=    0   
LOCAL nPreco     :=    0     
LOCAL cMsgPed    :=    ""
LOCAL cBarra     :=    ""      
LOCAL lPick      :=    .F.
LOCAL nJ
                            
IF Empty(aList[1,2])
    RETURN
ENDIF

FOR nContJ := 1 TO len(aList)
    IF aList[nContJ,01] .And. aList[nContJ,16]    
           aPergs     := {}
           aRet     := {}               
           cAbast    :=    space(6)   
           cMsgNf    :=    'Pedido Gerado pelo Pick-List do Ativo '+aList[nContJ,02]+space(095)
        aAdd(aPergs ,{1,"Abastecedor",cAbast,"","","SA4","",040,.T.})
        aAdd(aPergs ,{1,"Mensagem para nota",cMsgNf,"","","","",240,.T.})    
        
        IF ParamBox(aPergs ,"Informe Abastec e Msg Nf Ativo "+aList[nContJ,02],@aRet)
            cAbast := aRet[1]
            cMsgNf := aRet[2]
        ENDIF
        
        aCabec := {} 
        aItens := {}    
        lPick  := .F.
        aAdd( aCabec , { "C5_FILIAL"     , xFilial("SC5")                    , Nil } ) 
        aAdd( aCabec , { "C5_LOCADO"     , 'DOA'                                , Nil } )
        aAdd( aCabec , { "C5_TIPO"         , 'N'                                , Nil } )
        aAdd( aCabec , { "C5_CLIENTE"    , '036659'                              , Nil } )
        aAdd( aCabec , { "C5_LOJACLI"    , '01'                                   , Nil } )
        aAdd( aCabec , { "C5_CLIOS"        , aList[nContJ,17]                      , Nil } )
        aAdd( aCabec , { "C5_LOJAOS"    , aList[nContJ,18]                       , Nil } ) 
        aAdd( aCabec , { "C5_TRANSP"    , cAbast                               , Nil } ) 
        Aadd( aCabec , { "C5_MENNOTA"    , cMsgNf                            , Nil } )
        aAdd( aCabec , { "C5_CONDPAG"    , '999'                                , Nil } )    
        
        IF cempant == "01"
            aAdd( aCabec , { "C5_ICROTA", '999999'                            , Nil } )
        ENDIF
        
        aAdd( aCabec , { "C5_ICBCN"        , 'VDG'                                , Nil } )
        aAdd( aCabec , { "C5_EMP"         , '6'                                , Nil } )
        aAdd( aCabec , { "C5_ICBVBC"    , 1                                    , Nil } )
        
        aAdd( aCabec , { "C5_TABELA"    , '200'                                , Nil } )    
        nItem := 1
        FOR nJ := 1 TO len(aList1B)
            IF Alltrim(aList[nContJ,02]) == Alltrim(aList1B[nJ,08]) 
                aLinha := {}    
                nPreco := Posicione("SB1",1,xFilial("SB1")+aList1B[nJ,03],"B1_PRV1")
                nPreco := Round(nPreco + (nPreco*0.30),2)
                IF nPreco <= 0
                    nPreco := 9.99
                ENDIF       
                
                IF Valtype(aList1B[nJ,06]) == "N"
                    IF aList1B[nJ,06] <> aList1B[nJ,05] 
                        ConfQtd()                                   //provisorio ICB
                    ENDIF
                ENDIF
                
                IF aList1B[nJ,06] <= 0
                    loop
                ENDIF
                
                cTesut := ''
                
                cTesut := Posicione("SB1",1,xFilial("SB1")+aList1B[nJ,03],"B1_TS")
                
                IF Empty(cTesut)
                    cTesut := "557"
                ENDIF
                
                aAdd( aLinha , { "C6_FILIAL"    , xFilial("SC6")                                     , Nil })
                aAdd( aLinha , { "C6_ITEM"        , StrZero(nItem,TamSX3("C6_ITEM")[1])                , Nil })
                aAdd( aLinha , { "C6_PRODUTO"    , aList1B[nJ,03]                                     , Nil })
                aAdd( aLinha , { "C6_QTDVEN"    , aList1B[nJ,06]                                    , Nil })
                aAdd( aLinha , { "C6_PRCVEN"    , nPreco                                            , Nil })
//                aAdd( aLinha , { "C6_OPER"        , '03'                                                 , Nil })  
                aAdd( aLinha , { "C6_TES"        , cTesut                                             , Nil })  
                aAdd( aLinha , { "C6_QTDLIB"    , aList1B[nJ,06]                                    , Nil })
                aAdd( aItens , aLinha ) 
                nItem++
            ENDIF
        NEXT nJ 
        
        lMsErroAuto := .F.
        MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItens,3)
            
        IF lMsErroAuto  
            //DisarmTransaction()
            MostraErro()
            //RETURN
        ELSE
            //MSGALERT("PEDIDO "+SC5->C5_NUM)
            cMsgPed += cBarra + SC5->C5_NUM
            cBarra := ","
            ENDIF
    ENDIF
NEXT nContJ         

MsgAlert("Pedido(s) Gerado(s) "+cMsgPed,"AVSIINT")
oDlg1:end()

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/13/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �  Alterar quantidade de itens modificados na rotina no VMPay볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION ConfQtd()

LOCAL aArea          :=    GetArea() 
LOCAL aAuxAr         :=    {}
LOCAL nPos           :=    Ascan(aPick,{|x| Alltrim(x[1]) == Alltrim(aList1B[nJ,08])})
LOCAL aAuxPl         :=    strtokarr(aPick[nPos,02],",")  
LOCAL nPos2          :=    Ascan(aAuxPl,{|x| substr(x,1,8) == "items:id"})    
LOCAL aAuxP          :=    {}
LOCAL cVarVM         :=    ''
LOCAL aAuxRet        :=    {}
LOCAL aAuxR2         :=    {}
LOCAL oRestClient    :=    FWRest():New("http://vmpay.vertitecnologia.com.br")
//LOCAL oRestClient    :=    FWRest():New("http://demo.vmpay.vertitecnologia.com.br")
LOCAL aHeader        :=    {}        
LOCAL nPikid         :=    199090      
// LOCAL cChavH    :=    "?access_token=JKRwU4xyVkMFwLY4zP5wmMOSfUAJ0YD1UfgqEMU7"
LOCAL cChavP         :=    "?access_token=tH3FkJ7cB2P0GwwOGbmMpJvoHsQJtMZD2nX1Ihmj"  
LOCAL nX

Aadd(aHeader, "Authorization: Basic " + Encode64("access_token:tH3FkJ7cB2P0GwwOGbmMpJvoHsQJtMZD2nX1Ihmj"))

cDtCriac := Date()
cDtCriac := Dtos(cDtCriac)
cDtCriac := substr(cDtCriac,1,4)+"-"+substr(cDtCriac,5,2)+"-"+substr(cDtCriac,7,2)
cDtCriac += "T" +cvaltochar(time())+".000-03:00"
              
aAuxP := strtokarr(aAuxPl[1],":")
Aadd(aAuxAr,aAuxPl[1])
Aadd(aAuxAr,substr(aAuxPl[2],1,11)+cDtCriac)             
Aadd(aAuxAr,substr(aAuxPl[3],1,11)+cDtCriac)

aAuxP := strtokarr(aAuxPl[4],":")

Aadd(aAuxAr,aAuxPl[4])             

nPikid++

Aadd(aAuxAr,{substr(aAuxPl[nPos2],7),aAuxPl[nPos2+1],aAuxPl[nPos2+2],aAuxPl[nPos2+4]})

FOR nX := nPos2+5 TO len(aAuxPl) step 5
    Aadd(aAuxAr,{aAuxPl[nX],aAuxPl[nX+1],aAuxPl[nX+2],aAuxPl[nX+4]})
    aAuxP := strtokarr(aAuxPl[nX+1],":")
NEXT nX

FOR nX := 5 TO len(aAuxAr)
    IF aAuxAr[nX,01] == "id:"+aList1B[nJ,09]
        nPos3 := nX
        EXIT
    ENDIF
NEXT nX

cVarVM +=     '    {'+CRLF
cVarVM +=     '    "pick_list": {'+CRLF             
cVarVM +=     '        "items_attributes"    : ['+CRLF

//IF nPos3 > 0
    //cVarVM += '"'+substr(aAuxAr[1],1,2)+'"'+substr(aAuxAr[1],3)
    //Aadd(aAuxRet,'"'+substr(aAuxAr[1],1,2)+'"'+substr(aAuxAr[1],3))
    Aadd(aAuxRet,aAuxAr[1])
    
    //cVarVM += '"'+substr(aAuxAr[2],1,10)+'":"'+substr(aAuxAr[2],12)+'"'
    //Aadd(aAuxRet,'"'+substr(aAuxAr[2],1,10)+'":"'+substr(aAuxAr[2],12)+'"')
    Aadd(aAuxRet,aAuxAr[2])
    
    //cVarVM += '"'+substr(aAuxAr[3],1,10)+'":"'+substr(aAuxAr[3],12)+'"'
    //Aadd(aAuxRet,'"'+substr(aAuxAr[3],1,10)+'":"'+substr(aAuxAr[3],12)+'"')
    Aadd(aAuxRet,aAuxAr[3])
    
    //cVarVM += '"'+substr(aAuxAr[4],1,12)+'":'+substr(aAuxAr[4],14)
    //Aadd(aAuxRet,'"'+substr(aAuxAr[4],1,12)+'":'+substr(aAuxAr[4],14))
    Aadd(aAuxRet,aAuxAr[4])
    
    //cVarVM += '"items":['
    //Aadd(aAuxRet,'"items":')
    Aadd(aAuxRet,"pending:true")
    Aadd(aAuxRet,"items:")
    
    //FOR nPos3 := 5 TO len(aAuxAr)
        aAuxR2 := {}
        //cVarVM += '"'+substr(aAuxAr[nPos3,1],1,2)+'"'+substr(aAuxAr[nPos3,1],3)
        //Aadd(aAuxR2,'"'+substr(aAuxAr[nPos3,1],1,2)+'"'+substr(aAuxAr[nPos3,1],3))
        //Aadd(aAuxR2,aAuxAr[nPos3,01])
        cVarVM += '{'+CRLF
        cVarVM += '"'+substr(aAuxAr[nPos3,1],1,2)+'"'+substr(aAuxAr[nPos3,1],3)+','+CRLF
        
        
        aAuxP    :=    strtokarr(aAuxAr[nPos3,2],":")
        cVarVM += '"'+aAuxP[1]+'":'+aAuxP[2]+','+CRLF
        //Aadd(aAuxR2,'"'+aAuxP[1]+'":'+aAuxP[2])
        Aadd(aAuxR2,aAuxAr[nPos3,02])
        
        aAuxP    :=    strtokarr(aAuxAr[nPos3,3],":")
        cVarVM += '"'+aAuxP[1]+'":'+cvaltochar(aList1B[nJ,06])+CRLF
        cVarVM += ' }'+CRLF
        //Aadd(aAuxR2,'"'+aAuxP[1]+'":'+aAuxP[2])
        Aadd(aAuxR2,aAuxAr[nPos3,03])
        
        cVarVM += '  ]'+CRLF
        cVarVM += ' }'+CRLF
        cVarVM += '}'+CRLF
        Aadd(aAuxRet,aAuxR2)      
      //NEXT nX
                                                                  
    //Aadd(aHeader, "Authorization:" + GetMv("TI_MIDAUTH",,""))
    Aadd(aHeader, "Content-Type: application/json")

    cPath := aPick[nPos,03]
    //oRestClient:setPath(cPath+cChavP) 
    //oRestClient:Delete()

    //cPath := substr(aPick[nPos,03],1,at("lists/",aPick[nPos,03])+4)
    
    oRestClient:setPath(cPath+cChavP) 

                                               
    //oRestClient:setPath(cPath)   
    oRestClient:SetPostParams(cVarVM)
    
    IF oRestClient:Put(aHeader,cVarVM)             
    //IF oRestClient:Post(aHeader)
        //cResult := oRestClient:GetResult("GET")
        cResult := oRestClient:GetResult()
    ELSE
        cResult := oRestClient:GetLastError()
    ENDIF
    
    //MsgAlert(cResult)                
        
    //ENDIF
    
//ENDIF

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/15/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � Validar o planograma da maquina no vmpay                   볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION ValidPlan()

LOCAL aArea    :=    GetArea()
      
U_PRTWS03(aList[oList:nAt,02],1)

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/15/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �  Salvar o planograma de acordo com o contido no vmpay      볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION Saveplan()

LOCAL aArea    :=    GetArea()
// LOCAL aCabec:=    {"ZH_CLIENTE","ZH_LOJA","ZH_CHAPA","ZH_CODMAQ","ZH_CODPROD","ZH_MOLA","ZH_QUANT","ZH_NIVPAR","ZH_NIVALE","ZH_VALOR"}
// LOCAL nPosB    :=    Ascan(aList3B,{|x| Alltrim(x[2]) == Alltrim(aList3[oList3:nAt,02])}) 
LOCAL lAlt     :=    .F. 
LOCAL lMolD    :=    .F.
LOCAL aAuxD    :=    {}
LOCAL nPing
LOCAL nX
LOCAL nJ

 //ZH_CLIENTE, ZH_LOJA, ZH_CHAPA, ZH_CODMAQ, ZH_CODPROD, ZH_MOLA, 
//FILIAL+CHAPA+SELECAO+CODCLI
FOR nX := 1 TO len(aList3)
    IF !aList3[nX,01] 
        DbSelectArea("SZH")     
        DbSetOrder(2)

        IF "," $ aList3[nX,03] 
               aAuxD := strtokarr(aList3[nX,03],",")
               lMolD := .T.
               
               FOR nPing := 1 TO len(aAuxD)  
                    DbSelectArea("SZH")     
                    DbSetOrder(2)
                ////ZH_CLIENTE, ZH_LOJA, ZH_CHAPA, ZH_CODMAQ, ZH_CODPROD, ZH_MOLA,
                   IF !DbSeek(xFilial("SZH")+aList3[nX,02]+aList[oList:nAt,17]+aList[oList:nAt,18]+Avkey(aAuxD[nPing],"ZH_MOLA"))
                       Reclock("SZH",.T.)
                    SZH->ZH_CLIENTE    :=    aList[oList:nAt,17]
                    SZH->ZH_LOJA    :=    aList[oList:nAt,18]
                    SZH->ZH_CHAPA    :=    aList3[nX,02]
                    SZH->ZH_CODMAQ    :=    Posicione("AA3",7,xFilial("AA3")+aList3[nX,02],"AA3_CODPRO")
                    SZH->ZH_CODPROD    :=    aList3[nX,04]
                    SZH->ZH_MOLA    :=    aAuxD[nPing]     
                    SZH->ZH_DINICIO    :=    dDataBase
                    SZH->ZH_QUANT    :=    aList3[nX,06]
                    SZH->(Msunlock()) 
                ELSE
                    IF SZH->ZH_CODPROD <> aList3[nX,04]
                        //Na sequencia cria um novo
                        Reclock("SZH",.T.)
                        SZH->ZH_CLIENTE    :=    aList[oList:nAt,17]
                        SZH->ZH_LOJA    :=    aList[oList:nAt,18]
                        SZH->ZH_CHAPA    :=    aList3[nX,02]
                        SZH->ZH_CODMAQ    :=    Posicione("AA3",7,xFilial("AA3")+aList3[nX,02],"AA3_CODPRO")
                        SZH->ZH_CODPROD    :=    aList3[nX,04]
                        SZH->ZH_MOLA    :=    aList3[nX,03]
                        SZH->ZH_DINICIO :=    dDataBase
                        SZH->Z4_QUANT    :=    aList3[nX,06]
                        SZH->(Msunlock())
                    ENDIF
                ENDIF
            NEXT nPing
        ELSE
               IF !DbSeek(xFilial("SZH")+aList3[nX,02]+aList[oList:nAt,17]+aList[oList:nAt,18]+Avkey(aList3[nX,03],"ZH_MOLA"))
    //        IF !DbSeek(xFilial("SZ4")+aList3[nX,02]+Avkey(aList3[nX,03],"Z4_SELECAO")+aList[oList:nAt,17])    
                    Reclock("SZH",.T.)
                    SZH->ZH_CLIENTE    :=    aList[oList:nAt,17]
                    SZH->ZH_LOJA    :=    aList[oList:nAt,18]
                    SZH->ZH_CHAPA    :=    aList3[nX,02]
                    SZH->ZH_CODMAQ    :=    Posicione("AA3",7,xFilial("AA3")+aList3[nX,02],"AA3_CODPRO")
                    SZH->ZH_CODPROD    :=    aList3[nX,04]
                    SZH->ZH_MOLA    :=    aList3[nX,03]
                    SZH->ZH_DINICIO    :=    dDataBase
                    SZH->ZH_QUANT    :=    IF(Valtype(aList3[nX,06])<>"N",val(aList3[nX,06]),aList3[nX,06])
                    SZH->(Msunlock())
            ELSE
                IF SZ4->Z4_CODPRO <> aList3[nX,04]
                    //Na sequencia cria um novo
                    Reclock("SZH",.T.)
                    SZH->ZH_CLIENTE    :=    aList[oList:nAt,17]
                    SZH->ZH_LOJA    :=    aList[oList:nAt,18]
                    SZH->ZH_CHAPA    :=    aList3[nX,02]
                    SZH->ZH_CODMAQ    :=    Posicione("AA3",7,xFilial("AA3")+aList3[nX,02],"AA3_CODPRO")
                    SZH->ZH_CODPROD    :=    aList3[nX,04]
                    SZH->ZH_MOLA    :=    aList3[nX,03]
                    SZH->ZH_QUANT    :=    aList3[nX,06]
                    SZH->(Msunlock())
                ENDIF
            ENDIF 
        ENDIF
        aList3[nX,01] := .T.
        lAlt := .T.
    ENDIF    
NEXT nX
                   
IF lAlt
    FOR nX := 1 TO len(aList3)
        nPos := Ascan(aList3B,{|x| alltrim(x[2])+Alltrim(x[3]) == Alltrim(aList3[nX,02])+Alltrim(aList3[nX,03])})
        IF nPos > 0         
            FOR nJ := 1 TO len(aList3[nX])
                aList3B[nPos,nJ] := aList3[nX,nJ]
            NEXT nJ
        ELSE
            Aadd(aList3B,aList3[nX])
        ENDIF
    NEXT nX
ENDIF

oList3:refresh()
oDlg1:refresh()

RestArea(aArea)

RETURN      

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/29/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �  iNCLUIR PLANOGRAMAS                                       볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION incplan(nSelec)
      
LOCAL aArea     :=    GetArea()  
LOCAL nOpcao    :=    0
LOCAL nX

PRIVATE oPlanog                   
SetPrvt("oPlan1","oGrPlan","oBrw1","oBtn1","oBtn2")
PRIVATE aPlanog    :=    {}
  
IF nSelec == 1
    aadd(aPlanog,{.F.,space(2),'','','','','','',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,;
                    '',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
ELSE
    aPlanog := BuscPlan()
ENDIF

oPlan1     := MSDialog():New( 092,232,577,1480,"Incluir Planograma",,,.F.,,,,,,.T.,,,.T. )

    oGrPlan    := TGroup():New( 000,004,212,619,"Produtos",oPlan1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,008,208,340},,, oGrPlan ) 
    oPlanog        := TCBrowse():New(008,008,609,202,, {'','Mola','Produto','Descri豫o','Quant.','Conf','Nivel Par','Insumo1','Dosagem1','Insumo2','Dosagem2','Insumo3','Dosagem3','Insumo4','Dosagem4','Insumo5','Dosagem5','Insumo6','Dosagem6','Insumo7','Dosagem7'},;
                        {5,20,20,90,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20},;
                           oGrPlan,,,,{|| /*FHelp(oList:nAt)*/},{|| editplan(oPlanog:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)

    oPlanog:SetArray(aPlanog)
    oPlanog:bLine := {||{IF(aPlanog[oPlanog:nAt,01],oOk,oNo),;
                        aPlanog[oPlanog:nAt,02],; 
                         aPlanog[oPlanog:nAt,03],;
                         aPlanog[oPlanog:nAt,04],;
                         aPlanog[oPlanog:nAt,05],;
                         aPlanog[oPlanog:nAt,06],;  
                         aPlanog[oPlanog:nAt,07],;  
                         aPlanog[oPlanog:nAt,08],;
                         aPlanog[oPlanog:nAt,09],;
                         aPlanog[oPlanog:nAt,10],;
                         aPlanog[oPlanog:nAt,11],;
                         aPlanog[oPlanog:nAt,12],;
                         aPlanog[oPlanog:nAt,13],;
                         aPlanog[oPlanog:nAt,14],;
                         aPlanog[oPlanog:nAt,15],;
                         aPlanog[oPlanog:nAt,16],;
                         aPlanog[oPlanog:nAt,17],;
                         aPlanog[oPlanog:nAt,18],;
                         aPlanog[oPlanog:nAt,19],;
                         aPlanog[oPlanog:nAt,20],;
                         aPlanog[oPlanog:nAt,21]}} 
                         
    oBtn1      := TButton():New( 217,192,"Confirmar",oPlan1,{||oPlan1:end(nOpcao:=1)},037,012,,,,.T.,,"",,,,.F. )           
    oBtn2      := TButton():New( 217,242,"Incluir Item",oPlan1,{|| IncLin(1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( 217,292,"Remover Item",oPlan1,{|| IncLin(2)},037,012,,,,.T.,,"",,,,.F. )
    oBtn4      := TButton():New( 217,342,"Sair",oPlan1,{||oPlan1:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )

oPlan1:Activate(,,,.T.)

RestArea(aArea)

IF nOpcao == 1                 
    DbSelectArea("SZ4")     
    DbSetOrder(2)
    //FILIAL+CHAPA+SELECAO+CODCLI
    FOR nX := 1 TO len(aPlanog)
        IF !DbSeek(xFilial("SZ4")+aPlanog[nX,38]+aPlanog[nX,02]+aPlanog[nX,36])    
            Reclock("SZ4",.T.)
            SZ4->Z4_CODCLI     :=    aPlanog[nX,36]
            SZ4->Z4_LOJCLI    :=    aPlanog[nX,37]
            SZ4->Z4_CHAPA    :=    aPlanog[nX,38]
            SZ4->Z4_CODMAQ    :=    aPlanog[nX,40]
            SZ4->Z4_CODPRO    :=    aPlanog[nX,03]
            SZ4->Z4_SELECAO    :=    aPlanog[nX,02]
            //Insumos
            SZ4->Z4_INSUM1     :=     aPlanog[nX,08]
            SZ4->Z4_MEDID1    :=    aPlanog[nX,09]
            SZ4->Z4_INSUM2     :=    aPlanog[nX,10]
            SZ4->Z4_MEDID2    :=    aPlanog[nX,11]
            SZ4->Z4_INSUM3     :=    aPlanog[nX,12]
            SZ4->Z4_MEDID3    :=    aPlanog[nX,13]
            SZ4->Z4_INSUM4     :=    aPlanog[nX,14]
            SZ4->Z4_MEDID4    :=    aPlanog[nX,15]               
            SZ4->Z4_INSUM5     :=    aPlanog[nX,16]
            SZ4->Z4_MEDID5    :=    aPlanog[nX,17]
            SZ4->Z4_INSUM6     :=    aPlanog[nX,18]
            SZ4->Z4_MEDID6    :=    aPlanog[nX,19]
            SZ4->Z4_INSUM7     :=    aPlanog[nX,20]
            SZ4->Z4_MEDID7    :=    aPlanog[nX,21]
            
            SZ4->(Msunlock())        
            Aadd(aList3B,{.T.,aPlanog[nX,38],aPlanog[nX,02],aPlanog[nX,03],aPlanog[nX,04],aPlanog[nX,05],aPlanog[nX,06],'',;
                            0,aPlanog[nX,36],aPlanog[nX,37]})
            
        ELSE
            Reclock("SZ4",.F.)
            SZ4->Z4_CODCLI     :=    aPlanog[nX,36]
            SZ4->Z4_LOJCLI    :=    aPlanog[nX,37]
            SZ4->Z4_CHAPA    :=    aPlanog[nX,38]
            SZ4->Z4_CODMAQ    :=    aPlanog[nX,40]
            SZ4->Z4_CODPRO    :=    aPlanog[nX,03]
            SZ4->Z4_SELECAO    :=    aPlanog[nX,02]
            //Insumos
            SZ4->Z4_INSUM1     :=     aPlanog[nX,08]
            SZ4->Z4_MEDID1    :=    aPlanog[nX,09]
            SZ4->Z4_INSUM2     :=    aPlanog[nX,10]
            SZ4->Z4_MEDID2    :=    aPlanog[nX,11]
            SZ4->Z4_INSUM3     :=    aPlanog[nX,12]
            SZ4->Z4_MEDID3    :=    aPlanog[nX,13]
            SZ4->Z4_INSUM4     :=    aPlanog[nX,14]
            SZ4->Z4_MEDID4    :=    aPlanog[nX,15]               
            SZ4->Z4_INSUM5     :=    aPlanog[nX,16]
            SZ4->Z4_MEDID5    :=    aPlanog[nX,17]
            SZ4->Z4_INSUM6     :=    aPlanog[nX,18]
            SZ4->Z4_MEDID6    :=    aPlanog[nX,19]
            SZ4->Z4_INSUM7     :=    aPlanog[nX,20]
            SZ4->Z4_MEDID7    :=    aPlanog[nX,21]
            
            SZ4->(Msunlock())        
        
        ENDIF
    NEXT nX
ENDIF

RETURN                                                                      

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/29/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �  Incluir linha no planograma                               볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION IncLin(nOpc)

LOCAL aArea    :=    GetArea()

IF nOpc == 1
    aadd(aPlanog,{.F.,space(2),'','','','','','',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,;
                '',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
ELSE
    DbSelectArea("SZ4")
    DbSetOrder(2)
    IF Dbseek(xFilial("SZ4")+aPlanog[oPlanog:nAt,38]+aPlanog[oPlanog:nAt,02]+aPlanog[oPlanog:nAt,36])
        Reclock("SZ4",.F.)
        DbDelete()
        SZ4->(Msunlock())
    ENDIF
    
    IF Ascan(aList3,{|x| Alltrim(x[2]) == Alltrim(aPlanog[oPlanog:nAt,03]) }) > 0
        Adel(aList3,Ascan(aList3,{|x| Alltrim(x[2]) == Alltrim(aPlanog[oPlanog:nAt,03]) }))
        Asize(aList3,len(aList3)-1)
    ENDIF
    ADel(aPlanog,oPlanog:nAt)
    Asize(aPlanog,len(aPlanog)-1)
    
    IF len(aPlanog) < 1
        aadd(aPlanog,{.F.,space(2),'','','','','','',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,;
            '',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
    ENDIF
ENDIF

oPlanog:SetArray(aPlanog)
oPlanog:bLine := {||{IF(aPlanog[oPlanog:nAt,01],oOk,oNo),;
                    aPlanog[oPlanog:nAt,02],; 
                    aPlanog[oPlanog:nAt,03],;
                    aPlanog[oPlanog:nAt,04],;
                    aPlanog[oPlanog:nAt,05],;
                    aPlanog[oPlanog:nAt,06],;  
                    aPlanog[oPlanog:nAt,07],;  
                    aPlanog[oPlanog:nAt,08],;
                    aPlanog[oPlanog:nAt,09],;
                    aPlanog[oPlanog:nAt,10],;
                    aPlanog[oPlanog:nAt,11],;
                    aPlanog[oPlanog:nAt,12],;
                    aPlanog[oPlanog:nAt,13],;
                    aPlanog[oPlanog:nAt,14],;
                    aPlanog[oPlanog:nAt,15],;
                    aPlanog[oPlanog:nAt,16],;
                    aPlanog[oPlanog:nAt,17],;
                    aPlanog[oPlanog:nAt,18],;
                    aPlanog[oPlanog:nAt,19],;
                    aPlanog[oPlanog:nAt,20],;
                    aPlanog[oPlanog:nAt,21]}} 
oPlanog:refresh()
oPlan1:refresh()

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  04/29/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �  Edita linhas do planograma                                볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION editplan(nLinha)          

LOCAL aArea     :=    GetArea()
LOCAL lProd     :=    .F.  
LOCAL nPosic    :=    oPlanog:ncolpos    
     
IF nPosic == 2
    lEditCell( aPlanog, oPlanog, "", 2)
    //Dose
    lProd    := ConPad1(,,,"SB1",,,.f.)
    //Usuario pressionou o ok
    IF lProd
        aPlanog[oPlanog:nAt,03] := SB1->B1_COD
        aPlanog[oPlanog:nAt,04] := SB1->B1_DESC //Alltrim(Posicione("SB1",1,xFilial("SB1")+aPlanog[oPlanog:nAt,03],"B1_DESC"))
    ELSE
        WHILE !lProd
            aPlanog[oPlanog:nAt,03] := space(15)
            lEditCell( aPlanog, oPlanog, "", 3)
            IF existcpo("SB1",aPlanog[oPlanog:nAt,03])
                lProd := .T.
                //aPlanog[oPlanog:nAt,03] := SB1->B1_COD
                aPlanog[oPlanog:nAt,04] := Alltrim(Posicione("SB1",1,xFilial("SB1")+aPlanog[oPlanog:nAt,03],"B1_DESC"))
            ENDIF
        ENDDO 
    ENDIF
ENDIF
    

IF nPosic == 8 
    lProd := .F.
    //Insumo 1
    WHILE !lProd
        aPlanog[oPlanog:nAt,08] := space(15)
        lEditCell( aPlanog, oPlanog, "", 8)
        IF !Empty(aPlanog[oPlanog:nAt,08])
            IF existcpo("SB1",aPlanog[oPlanog:nAt,08])
                lProd := .T.
                lEditCell( aPlanog, oPlanog, "@E 9.9999", 9)
            ENDIF         
        ELSE
            lProd := .T.
        ENDIF
    ENDDO
ENDIF    

IF nPosic == 10 
    lProd := .F.
    
    //Insumo 2        
    WHILE !lProd
        aPlanog[oPlanog:nAt,10] := space(15)
        lEditCell( aPlanog, oPlanog, "", 10)
        IF !Empty(aPlanog[oPlanog:nAt,10])
            IF existcpo("SB1",aPlanog[oPlanog:nAt,10])
                lProd := .T.
                lEditCell( aPlanog, oPlanog, "@E 9.9999", 11)
            ENDIF
        ELSE
            lProd := .T.
        ENDIF
    ENDDO 
ENDIF

IF nPosic == 12
    lProd := .F.
    
    //Insumo 3        
    WHILE !lProd
        aPlanog[oPlanog:nAt,12] := space(15)
        lEditCell( aPlanog, oPlanog, "", 12)
        IF !Empty(aPlanog[oPlanog:nAt,12])
            IF existcpo("SB1",aPlanog[oPlanog:nAt,12])
                lProd := .T.
                lEditCell( aPlanog, oPlanog, "@E 9.9999", 13)
            ENDIF
        ELSE
            lProd := .T.
        ENDIF
    ENDDO
ENDIF

IF nPosic == 14             
    lProd := .F.
    //Insumo 3        
    WHILE !lProd
        aPlanog[oPlanog:nAt,14] := space(15)
        lEditCell( aPlanog, oPlanog, "", 14)
        IF !Empty(aPlanog[oPlanog:nAt,14])
            IF existcpo("SB1",aPlanog[oPlanog:nAt,14])
                lProd := .T.
                lEditCell( aPlanog, oPlanog, "@E 9.9999", 15)
            ENDIF
        ELSE
            lProd := .T.
        ENDIF
    ENDDO
ENDIF    

IF nPosic == 16                
    lProd := .F.
    //Insumo 3        
    WHILE !lProd
        aPlanog[oPlanog:nAt,16] := space(15)
        lEditCell( aPlanog, oPlanog, "", 16)
        IF !Empty(aPlanog[oPlanog:nAt,16])
            IF existcpo("SB1",aPlanog[oPlanog:nAt,16])
                lProd := .T.
                lEditCell( aPlanog, oPlanog, "@E 9.9999", 17)
            ENDIF
        ELSE
            lProd := .T.
        ENDIF
    ENDDO
ENDIF
     
IF nPosic == 18           
    lProd := .F.
    //Insumo 3        
    WHILE !lProd
        aPlanog[oPlanog:nAt,18] := space(15)
        lEditCell( aPlanog, oPlanog, "", 18)
        IF !Empty(aPlanog[oPlanog:nAt,18])
            IF existcpo("SB1",aPlanog[oPlanog:nAt,18])
                lProd := .T.
                lEditCell( aPlanog, oPlanog, "@E 9.9999", 19)
            ENDIF
        ELSE
            lProd := .T.
        ENDIF
    ENDDO
ENDIF

IF nPosic == 20            
    lProd := .F.
    //Insumo 3        
    WHILE !lProd
        aPlanog[oPlanog:nAt,20] := space(15)
        lEditCell( aPlanog, oPlanog, "", 20)
        IF !Empty(aPlanog[oPlanog:nAt,20])
            IF existcpo("SB1",aPlanog[oPlanog:nAt,20])
                lProd := .T.
                lEditCell( aPlanog, oPlanog, "@E 9.9999", 21)
            ENDIF
        ELSE
            lProd := .T.
        ENDIF
    ENDDO
ENDIF  

oPlanog:refresh()
oPlan1:refresh()

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  05/31/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � Exclui planograma                                          볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION excplan()

LOCAL aArea    :=    GetArea()
LOCAL nCont    :=    len(aList3)
 
DbSelectArea("SZ4")     
DbSetOrder(2)
//FILIAL+CHAPA+SELECAO+CODCLI
IF DbSeek(xFilial("SZ4")+ALIST[oList:nAt,02])
       WHILE !EOF() .And. SZ4->Z4_CHAPA == ALIST[oList:nAt,02]
           Reclock("SZ4",.F.)
           DbDelete()
           SZ4->(Msunlock())
           Dbskip()
       ENDDO
ENDIF

WHILE nCont > 0
    ADel(aList3,oList3:nAt)
    Asize(aList3,len(aList3)-1)
    nCont--
ENDDO

IF len(aList3) < 1
    Aadd(aList3,{.T.,'','','','','','','','','','','','','','','','','',''})
ENDIF

oList3:refresh()
oDlg1:refresh()
    
    
RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  05/10/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �   remessas enviadas para os pontos de venda                볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION Remessas()

LOCAL aArea      :=    GetArea()
LOCAL aPergs     :=    {}
LOCAL aRet       :=    {}      
LOCAL cPdvD      :=    space(6)
LOCAL cPdvA      :=    space(6)
LOCAL dDtD       :=    ctod(" / / ")
LOCAL dDtA       :=    ctod(" / / ")
LOCAL aExcel     :=    {}         
LOCAL oExcel     :=    FWMSEXCEL():New()
// LOCAL cTitulo    :=    "Remessas" 
LOCAL cArqXls    :=    "Remessas"+dtos(ddatabase)+strtran(time(),":")+".xls" 
LOCAL nX

LOCAL cDir        

aAdd(aPergs ,{1,"PDV de?",cPdvD,"","","NNR","",050,.T.})
aAdd(aPergs ,{1,"PDV de?",cPdvA,"","","NNR","",050,.T.})    
aAdd(aPergs ,{1,"Periodo de?",dDtD,"","","","",040,.T.})
aAdd(aPergs ,{1,"Periodo ate?",dDtA,"","","","",040,.T.})    

IF ParamBox(aPergs ,"Motivo da Despesa",@aRet)
    cDir         :=    cGetFile(, OemToAnsi("Selecione o diret�rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
    
    IF Empty(cDir)
        RETURN
    ENDIF
    
    //aRet[1]
    cQuery := "SELECT C6_NUM,C6_NOTA,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_PRCVEN,C6_CLI,C6_LOJA,C5_XPDV,C6_ENTREG,C5_EMISSAO"
    cQuery += " FROM "+RetSQLName("SC6")+" C6"
    cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_CLIENTE=C6_CLI AND C5.D_E_L_E_T_=''"
    cQuery += "         AND C5_EMISSAO BETWEEN '"+dtos(aRet[3])+"' AND '"+dtos(aRet[4])+"' AND C5_XPDV BETWEEN '"+aRet[1]+"' AND '"+aRet[2]+"'"
    cQuery += " WHERE C6.D_E_L_E_T_=''"

    IF Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    ENDIF
    
    MemoWrite("AVSIINT.SQL",cQuery)
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
    
    DbSelectArea("TRB")  
    
    WHILE !EOF() 
        Aadd(aExcel,{TRB->C6_NUM,TRB->C6_NOTA,TRB->C6_PRODUTO,TRB->C6_DESCRI,TRB->C6_QTDVEN,TRB->C6_PRCVEN,;
                        TRB->C6_CLI,TRB->C6_LOJA,TRB->C5_XPDV,STOD(TRB->C6_ENTREG),STOD(TRB->C5_EMISSAO)})
        Dbskip()
    ENDDO
                
    IF len(aExcel) > 0
        //C6_NUM,C6_NOTA,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_PRCVEN,C6_CLI,C6_LOJA,C5_XPDV,C6_ENTREG,C5_EMISSAO
        oExcel:AddworkSheet("Remessas") 
        
        oExcel:AddTable ("Remessas","PDV")
        
        oExcel:AddColumn("Remessas","PDV","Pedido",1,1)
        oExcel:AddColumn("Remessas","PDV","Nota",1,1) 
        oExcel:AddColumn("Remessas","PDV","Produto",1,1) 
        oExcel:AddColumn("Remessas","PDV","Descri豫o",1,1) 
        oExcel:AddColumn("Remessas","PDV","Qtd Enviada",1,1) 
        oExcel:AddColumn("Remessas","PDV","Pre�o Unit�rio",1,1) 
        oExcel:AddColumn("Remessas","PDV","Codigo Cliente",1,1) 
        oExcel:AddColumn("Remessas","PDV","Loja",1,1) 
        oExcel:AddColumn("Remessas","PDV","PDV",1,1) 
        oExcel:AddColumn("Remessas","PDV","Data Entrega",1,1) 
        oExcel:AddColumn("Remessas","PDV","Data Emiss�o",1,1) 
        
        FOR nX := 1 TO len(aExcel)
            oExcel:AddRow("Remessas","PDV",{aExcel[nX,01],;
                                            aExcel[nX,02],;     //Produto
                                            aExcel[nX,03],;        //Descricao
                                            aExcel[nX,04],;
                                            aExcel[nX,05],;
                                            aExcel[nX,06],;
                                            aExcel[nX,07],;        //Qtd
                                            aExcel[nX,08],;
                                            aExcel[nX,09],;
                                            aExcel[nX,10],;
                                            aExcel[nX,11]})  //valor total

        NEXT nX  
        
        oExcel:Activate()

        oExcel:GetXMLFile(cDir +cArqXls)
        
        //IF File(cDir +cArqXls)
            oExcelApp := MsExcel():New()
            oExcelApp:Destroy()
        //ENDIF    
    ENDIF
ENDIF

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  05/31/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �    Busca planograma                                        볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION BuscPlan()

LOCAL aArea    :=    GetArea()
LOCAL cQuery
LOCAL aRet     :=    {}

cQuery := "SELECT Z4.*,B1_DESC FROM "+RetSQLName("SZ4")+" Z4"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=Z4_CODPRO AND B1.D_E_L_E_T_=''
cQuery += " WHERE Z4_CHAPA='"+aList[oList:nAt,02]+"' AND Z4_CODCLI='"+aList[oList:nAt,17]+"' AND Z4.D_E_L_E_T_=''"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

//'','Mola','Produto','Descri豫o','Quant.','Conf','Nivel Par','Insumo1','Dosagem1','Insumo2','Dosagem2','Insumo3','Dosagem3','Insumo4','Dosagem4','Insumo5','Dosagem5','Insumo6','Dosagem6','Insumo7','Dosagem7'
WHILE !EOF() 
    Aadd(aRet,{.F.,TRB->Z4_SELECAO,TRB->Z4_CODPRO,Alltrim(TRB->B1_DESC),;
                TRB->Z4_CAPACID,TRB->Z4_NIVALE,TRB->Z4_NIVPAR,TRB->Z4_INSUM1,TRB->Z4_MEDID1,TRB->Z4_INSUM2,TRB->Z4_MEDID2,;
                TRB->Z4_INSUM3,TRB->Z4_MEDID3,TRB->Z4_INSUM4,TRB->Z4_MEDID4,TRB->Z4_INSUM5,TRB->Z4_MEDID5,TRB->Z4_INSUM6,;
                TRB->Z4_MEDID6,TRB->Z4_INSUM7,TRB->Z4_MEDID7,;
                '',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
    Dbskip()
ENDDO

IF len(aRet) < 1
    aadd(aRet,{.F.,space(2),'','','','','','',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,;
                '',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
ENDIF

RestArea(aArea)

RETURN(aRet)

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  05/31/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � Busca as vendas do Vmpay                                   볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION Vendaspay()

LOCAL aArea    :=    GetArea()
LOCAL dDtD     :=    ctod(' / / ') 
LOCAL dDtA     :=    ctod(' / / ')    
LOCAL cHri     :=    space(5)
// LOCAL cHrf    :=    space(5)
LOCAL nX

PRIVATE aPergs     :=    {}
PRIVATE aRet       :=    {}
PRIVATE aVendas    :=    {}

aAdd(aPergs ,{1,"Data Inicial?",dDtD,"","","","",070,.T.})    
aAdd(aPergs ,{1,"Data Final?",dDtA,"","","","",070,.T.})    
aAdd(aPergs ,{1,"Hora Inicial?",cHri,"","","","",070,.T.})    
aAdd(aPergs ,{1,"Hora Final?",cHri,"","","","",070,.T.})    
      
IF ParamBox(aPergs ,"Periodo de vendas",@aRet)
    aVendas := U_PRTWS03(aList[oList:nAt,02],2,aRet[1],aRet[2],aRet[3],aRet[4])
    IF len(aVendas) > 0
        aList8 := {}
    //'Data','Sele豫o','Produto','Descri豫o','Quant. Apont.',chapa,codigo cliente
        FOR nX := 3 TO len(aVendas) 
            cCodProt := ''
            IF aVendas[nX,05] == "null"
                IF Ascan(aList3,{|x| Alltrim(x[3]) == Alltrim(aVendas[nX,02])}) > 0
                    cCodProt      :=     aList3[Ascan(aList3,{|x| Alltrim(x[3]) == Alltrim(aVendas[nX,02])}),04]  
                ENDIF   
            ELSE
                cCodProt := aVendas[nX,05]
            ENDIF
            cDesc := Posicione("SB1",1,xFilial("SB1")+cCodProt,"B1_DESC")       
            
            nPosit := Ascan(aList8,{|x| x[2] == aVendas[nX,02]})
            IF nPosit == 0
                Aadd(aList8,{cvaltochar(aRet[2]),aVendas[nX,02],cCodProt,cDesc,val(aVendas[nX,03]),aVendas[2],;
                            aList[oList:nAt,17],IF(val(aVendas[nX,03])>1,val(aVendas[nX,04])/val(aVendas[nX,03]),val(aVendas[nX,04]))})
            ELSE
                aList8[nPosit,05] += val(aVendas[nX,03])
            ENDIF
        NEXT nX
        
        
        IF len(aList8) > 0
            Asort(aList8,,,{|x,y| x[2]+x[1] < y[2]+y[1]})
            oList8:SetArray(aList8)
            oList8:bLine := {||{aList8[oList8:nAt,01],;
                                aList8[oList8:nAt,02],; 
                                 aList8[oList8:nAt,03],;
                                 aList8[oList8:nAt,04],;
                                 aList8[oList8:nAt,05],;
                                 Transform(aList8[oList8:nAt,08],"@E 999,999.99")}}
            oList8:refresh()
            oDlg1:refresh()
    
        ENDIF
    ENDIF
ENDIF

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  06/08/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION savevend()

LOCAL aArea       :=    GetArea()  
LOCAL aGravarP    :=    {}
LOCAL aGravarS    :=    {}      
LOCAL aGravar     :=    {}
LOCAL cMesAno     :=    Compete()    
LOCAL nX   
LOCAL nJ
         
cContrato := POSICIONE("AAN",3,XFILIAL("AAN")+aList[oList:nAt,2],"AAN_CONTRT")
//cLeitura  := STRZERO(VAL(GetSX8NUM("SZP","ZP_COD"))+1,6)
//ConfirmSX8() 
cLeitura  :=  GetMV("MV_XNRCONT")  //GetSx8Num("SZP","ZP_COD")
cPrx := Strzero(val(cLeitura)+1,6)
PUTMV("MV_XNRCONT",cPrx)

cItem      := POSICIONE("AAN",3,XFILIAL("AAN")+aList[oList:nAt,2],"AAN_ITEM")
cModPg      := POSICIONE("AAN",3,XFILIAL("AAN")+aList[oList:nAt,2],"AAN_XMODPG")

Aadd(aGravarP,{"ZP_FILIAL"    , xFilial("SZP")}) 
Aadd(aGravarP,{"ZP_COD"        , cLeitura}) 
Aadd(aGravarP,{"ZP_NUMSER"    , aList[oList:nAt,2]}) 
Aadd(aGravarP,{"ZP_DTDIGIT"    , dDataBase}) 
Aadd(aGravarP,{"ZP_CONTRT"    , cContrato}) 
Aadd(aGravarP,{"ZP_ITEM"    , cItem}) 
Aadd(aGravarP,{"ZP_DATA"    , ctod(aList8[1,1])}) 
Aadd(aGravarP,{"ZP_PERIODO" , cMesAno })     //strzero(month(ctod(alist8[1,1])),2)+"/"+cvaltochar(year(ctod(alist8[1,1])))
Aadd(aGravarP,{"ZP_MAQUINA"    , aList[oList:nAt,21]}) 
Aadd(aGravarP,{"ZP_CODTEC"    , ""}) 
Aadd(aGravarP,{"ZP_TECNICO"    , ""}) 
Aadd(aGravarP,{"ZP_CODCLI"    , aList[oList:nAt,17]+aList[oList:nAt,18]})  
Aadd(aGravarP,{"ZP_CLIPAG"    , aList[oList:nAt,17]+aList[oList:nAt,18]})  
Aadd(aGravarP,{"ZP_TIPOCON"    , "COM"})  
Aadd(aGravarP,{"ZP_GRPCLI"  , Posicione("SZM",1,xFilial("SZM")+cContrato,"ZM_GRPCLI")})  
Aadd(aGravarP,{"ZP_FILRESP"    , Strzero(val(xFilial("SC5")),6)})  
                
FOR nX := 1 TO len(aList8)
    Aadd(aGravarS,{"ZS_COD"        , cLeitura})
    Aadd(aGravarS,{"ZS_CONTRT"    , cContrato})
    Aadd(aGravarS,{"ZS_ITEM"    , cItem})
    Aadd(aGravarS,{"ZS_SEQUEN"    , aList8[nX,02]})
    IF !Empty(cModPg)
        Aadd(aGravarS,{"ZS_DOSESG"    , aList8[nX,05]})        
    ELSE
        Aadd(aGravarS,{"ZS_DOSESP"    , aList8[nX,05]})
    ENDIF
    
    Aadd(aGravarS,{"ZS_BEBIDA"    , aList8[nX,03]})
    Aadd(aGravar,aGravarS)
    aGravarS := {}
NEXT nX

IF len(aGravarP) > 0
    DbSelectArea("SZP") 
    Reclock("SZP",.T.)
    FOR nX := 1 TO len(aGravarP)
        &("SZP->"+aGravarP[nX,01]) := aGravarP[nX,02]
    NEXT nX
    SZP->(Msunlock())
    
    DbSelectArea("SZS")
    
    FOR nX := 1 TO len(aGravar)        
        Reclock("SZS",.T.)
        FOR nJ := 1 TO len(aGravar[nX])
            &("SZS->"+aGravar[nX,nJ,01]) := aGravar[nX,nJ,02]
        NEXT nJ
        SZS->(Msunlock())
    NEXT nX   
    
    MsgAlert("Leitura salva com sucesso!")
    
ENDIF

RestArea(aArea)

RETURN  

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  05/08/19   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION Compete()

LOCAL cQuery
LOCAL aPeriodo    :=    {}  
LOCAL aPergs      :=    {}
LOCAL aRet        :=    {}
LOCAL nQtd        :=    space(1)
LOCAL cRet        :=    ''     
LOCAL cMsg        :=    ""
LOCAL nXx

cQuery := "SELECT ZZ4_PERIOD,MIN(ZZ4_DTINI) AS INI,MAX(ZZ4_DTFIM) AS FIM"
cQuery += " FROM ZZ4010"
cQuery += " WHERE ZZ4_STATUS='A' AND D_E_L_E_T_='' GROUP BY ZZ4_PERIOD"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("PRTFAT01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

nCont := 1

WHILE !EOF()        
    Aadd(aPeriodo,{nCont,TRB->ZZ4_PERIOD,TRB->INI,TRB->FIM})
    nCont++
    Dbskip()
ENDDO

IF len(aPeriodo) == 0
    MsgAlert("N�o encontrado um periodo de competencia aberto, favor verificar")
ElseIf len(aPeriodo) > 1
    FOR nXx := 1 TO len(aPeriodo)
        cMsg += cvaltochar(aPeriodo[nXx,01])+" - "+aPeriodo[nXx,02]+" # "
    NEXT nXx                             
ELSE
    cRet := aPeriodo[1,2]
ENDIF
                
IF !Empty(cMsg)
    
    aAdd(aPergs ,{1,"Informe o Numero",nQtd,"","","","",50,.F.})

      Aadd(aPergs ,{9,cMsg,150,80,.F.})
        
    IF !ParamBox(aPergs ,"Informe a competencia desejada",@aRet)
        RETURN 
    ELSE                               
        cRet := aPeriodo[Ascan(aPeriodo,{|x| cvaltochar(x[1]) == cvaltochar(aRet[1])}),2]
    ENDIF      
ENDIF

RETURN(cRet)   

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  07/19/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �  Replicar Planograma para outro ativo.                     볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION repplan()

LOCAL aArea    :=    GetArea()
LOCAL aBkPl    :=    {}
LOCAL nOpc     :=    0
LOCAL aGrav    :=    {}
LOCAL nX
LOCAL nJ

PRIVATE oPlCp    
PRIVATE aAteq    :=    {}

SetPrvt("oRepPl","oGrp1","oBrw1","oBtn1","oBtn2")

FOR nX := 1 TO len(aList3)
    Aadd(aBkPl,aList3[nX])
NEXT nX

FOR nX := 1 TO len(aListB)
    IF Alltrim(aListB[nX,03]) == Alltrim(aList[oList:nAt,03])
        IF Ascan(aList3B,{|x| Alltrim(x[2]) == Alltrim(aListB[nX,02]) }) == 0
            Aadd(aAteq,{.F.,aListB[nX,02],aListB[nX,03],aListB[nX,17],aListB[nX,18],aListB[nX,05],aListB[nX,06]})
        ENDIF
    ENDIF
NEXT nX       

oRepPl     := MSDialog():New( 092,232,437,876,"Replicar Planograma",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,008,148,308,"Ativos",oRepPl,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,012,144,304},,, oGrp1 ) 

    oPlCp            := TCBrowse():New(012,012,290,135,, {'','Ativo','Modelo','Cliente','Nome Fantasia'},{10,30,40,50,50},;
                                oGrp1,,,,{|| },{|| editcp(oPlCp:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oPlCp:SetArray(aAteq)
    oPlCp:bLine := {||{ IF(aAteq[oPlCp:nAt,01],oOk,oNo),; 
                          Alltrim(aAteq[oPlCp:nAt,02]),;
                          Alltrim(aAteq[oPlCp:nAt,03]),;
                          Alltrim(aAteq[oPlCp:nAt,06]),;
                          Alltrim(aAteq[oPlCp:nAt,07])}}

    oBtn1      := TButton():New( 152,080,"Confirmar",oRepPl,{||oRepPl:end(nOpc := 1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 152,192,"Cancelar",oRepPl,{||oRepPl:end(nOpc := 0)},037,012,,,,.T.,,"",,,,.F. )

oRepPl:Activate(,,,.T.)

IF nOpc == 1
    IF MsgYesNo("Confirma a c�pia do planograma atual para as maquinas selecionadas?","repplan - AVSIINT")
        FOR nX := 1 TO len(aAteq)
            IF aAteq[nX,01]
                //Aadd(aGrav,aAteq[nX])
                FOR nJ := 1 TO len(aBkPl)
                    Aadd(aGrav,aBkPl[nJ])
                    aGrav[len(aGrav),02] := aAteq[nX,02]
                    aGrav[len(aGrav),10] := aAteq[nX,04]
                    aGrav[len(aGrav),11] := aAteq[nX,05]
                NEXT nJ
            ENDIF
        NEXT nX  
        
        DbSelectArea("SZ4")
        FOR nX := 1 TO len(aGrav)
            Reclock("SZ4",.T.)
            SZ4->Z4_CODCLI     :=    aGrav[nX,10]
            SZ4->Z4_LOJCLI     :=    aGrav[nX,11]
            SZ4->Z4_CHAPA      :=    aGrav[nX,02]
            SZ4->Z4_CODMAQ     :=    aGrav[nX,12]
            SZ4->Z4_CODPRO     :=    aGrav[nX,04]
            SZ4->Z4_SELECAO    :=    aGrav[nX,03]
            SZ4->Z4_CAPACID    :=    aGrav[nX,06]
            SZ4->Z4_NIVPAR     :=    aGrav[nX,07]
            SZ4->Z4_NIVALE     :=    aGrav[nX,08]
            SZ4->Z4_VALOR      :=    aGrav[nX,09]
            SZ4->Z4_INSUM1     :=    aGrav[nX,13]
            SZ4->Z4_MEDID1     :=    aGrav[nX,14]
            SZ4->Z4_INSUM2     :=    aGrav[nX,15]
            SZ4->Z4_MEDID2     :=    aGrav[nX,16]
            SZ4->Z4_INSUM3     :=    aGrav[nX,17]
            SZ4->Z4_MEDID3     :=    aGrav[nX,18]
            SZ4->Z4_INSUM4     :=    aGrav[nX,19]
            SZ4->Z4_MEDID4     :=    aGrav[nX,20]
            SZ4->Z4_INSUM5     :=    aGrav[nX,21]
            SZ4->Z4_MEDID5     :=    aGrav[nX,22]
            SZ4->Z4_INSUM6     :=    aGrav[nX,23]
            SZ4->Z4_MEDID6     :=    aGrav[nX,24]
            SZ4->Z4_INSUM7     :=    aGrav[nX,25]
            SZ4->Z4_MEDID7     :=    aGrav[nX,26]
            SZ4->(Msunlock())
        NEXT nX  
        
        MsgAlert("Planogramas salvos, saia da rotina e abra novamente para atualiza豫o.")
    ENDIF
ENDIF

RestArea(aArea)

RETURN

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌VSIINT   튍utor  쿘icrosiga           � Data �  07/19/17   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

STATIC FUNCTION editcp(nLinha)

LOCAL aArea    :=    GetArea()

IF aAteq[nLinha,01]
    aAteq[nLinha,01] := .F.
ELSE
    aAteq[nLinha,01] := .T.
ENDIF
      
oPlCp:refresh()
oRepPl:refresh()

RestArea(aArea)

RETURN
