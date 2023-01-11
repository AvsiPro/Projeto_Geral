#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑ Fonte     ณฑฑ CONFATC01                                                   ฑฑ    
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ  Integracao Protheus X VMPay                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ                                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

USER FUNCTION CONFATC01(contrato)

LOCAL   nCont      :=    0
LOCAL   lTeca      :=    .F.
PRIVATE aItens     :=    {'1=Ativo','2=Numero Serie','3=Produto (desc.)','4=Cliente','5=Pick-Lists','6=Linha','7=Contrato'}
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
PRIVATE aList10    :=    {}
PRIVATE oOk        :=    LoadBitmap(GetResources(),'br_verde')  //Controla se o pedido foi alterado ou nao no grid.
PRIVATE oNo        :=    LoadBitmap(GetResources(),'br_vermelho')

DEFAULT contrato   := ''

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

Aadd(aList1,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList4,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList6,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList7,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList8,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList10,{.T.,'','','','','','','','','','','','','','','','','',''})

DbSelectArea("SBM")
Dbgotop()
WHILE !EOF()
    Aadd(aCateg,{Alltrim(SBM->BM_GRUPO),Alltrim(SBM->BM_DESC)})    
    Dbskip()         
ENDDO

Processa({|| Busca1(contrato),"Aguarde, buscando ativos"})

WHILE !empty(procname(nCont))
    IF alltrim(UPPER(procname(nCont))) $ "TECA201"
        lTeca := .T.
        EXIT
    ENDIF 
    nCont++
ENDDO

If len(aList) > 0
    oDlg1    := MSDialog():New( 017,058,628,1344,"Pick-List",,,.F.,,,,,,.T.,,,.T. )

        oGrp1    := TGroup():New( 000,004,148,280,"Ativos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

            //oBrw1    := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,008,144,276},,, oGrp1 ) 
            oList    := TCBrowse():New(008,008,270,137,, {'','Ativo','Modelo','Num. S้rie','Linha'},{10,30,40,20},;
                                        oGrp1,,,,{|| FHelp()},{|| editped(oList:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList:SetArray(aList)
            oList:bLine := {||{ IF(aList[oList:nAt,01],oOk,oNo),; 
                                Alltrim(aList[oList:nAt,02]),;
                                aList[oList:nAt,03],;
                                aList[oList:nAt,04],;
                                aList[oList:nAt,19]}}
                                                                //,"Sangrias"    //,"Inventแrios"
        oFld1    := TFolder():New( 000,284,{"Pick-List","Leituras"},{},oDlg1,,,,.T.,.F.,348,148,) 

            //oBrw4      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,132,344},,, oFld1:aDialogs[3] ) 
            oList1    := TCBrowse():New(000,001,344,135,, {'','Mola','Produto','Descri็ใo','Quant.','Conf','Nivel Par','Saldo'},{5,20,20,90,20,20,20},;
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
            oList8    := TCBrowse():New(000,001,344,135,, {'Data','Sele็ใo','Produto','Descri็ใo','Quant. Apont.','Valor'},{30,30,50,120,30,30},;
                            oFld1:aDialogs[2],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

            oList8:SetArray(aList8)
            oList8:bLine := {||{aList8[oList8:nAt,01],;
                                strzero(val(aList8[oList8:nAt,02]),3),; 
                                aList8[oList8:nAt,03],;
                                aList8[oList8:nAt,04],;
                                aList8[oList8:nAt,05],;
                                aList8[oList8:nAt,08]}}

            //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,132,344},,, oFld1:aDialogs[1] ) 
            // oList9    := TCBrowse():New(000,001,344,135,, {'Data','Audit','Valor'},{30,40,40},;
            //                     oFld1:aDialogs[3],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

            // oList9:SetArray(aList9)
            // oList9:bLine := {||{aList9[oList9:nAt,01],;
            //                     aList9[oList9:nAt,02],; 
            //                     aList9[oList9:nAt,03]}}
                                
            //oBrw5      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,132,344},,, oFld1:aDialogs[4] ) 
                                                                                        //,"Cโnisteres" //,"oaDialogs10"
        oFld2    := TFolder():New( 152,004,{"Produtos","Layouts","Locais Inst.","Rotas"},{},oDlg1,,,,.T.,.F.,276,132,) 

            //oBrw6      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[1] ) 
            oList2    := TCBrowse():New(000,001,274,110,, {'','C๓digo','Descri็ใo','Saldo'},{10,30,40,20},;
                                        oFld2:aDialogs[1],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList2:SetArray(aList2)
            oList2:bLine := {||{ IF(aList2[oList2:nAt,01],oOk,oNo),; 
                                    Alltrim(aList2[oList2:nAt,02]),;
                                    aList2[oList2:nAt,03],;
                                    aList2[oList2:nAt,04]}}    
                                
            //oBrw7      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[2] ) 
            oList3    := TCBrowse():New(000,001,274,110,, {'','Ativo','Selecao','Produto','Descri็ใo','Valor'},{10,30,30,40,30,30},;
                                        oFld2:aDialogs[2],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList3:SetArray(aList3)
            oList3:bLine := {||{ IF(aList3[oList3:nAt,01],oOk,oNo),; 
                                    Alltrim(aList3[oList3:nAt,02]),;
                                    Strzero(val(aList3[oList3:nAt,03]),3),;
                                    aList3[oList3:nAt,04],;
                                    aList3[oList3:nAt,05],;
                                    Transform(aList3[oList3:nAt,06],"@E 999,999.99")}}    

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
            // oList6    := TCBrowse():New(000,001,274,110,, {'','Insumo','Capacidade','Nivel Par','Nivel Alerta','Disponํvel','Utilizado'},{10,80,30,30,30,30,30},;
            //                             oFld2:aDialogs[5],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
            // oList6:SetArray(aList6)
            // oList6:bLine := {||{ IF(aList6[oList6:nAt,01],oOk,oNo),; 
            //                         Alltrim(aList6[oList6:nAt,02]),;
            //                         aList6[oList6:nAt,03],;
            //                         aList6[oList6:nAt,04],;
            //                         aList6[oList6:nAt,05],;
            //                         aList6[oList6:nAt,06],;
            //                         aList6[oList6:nAt,07]}}   
                                
            // oBrw11     := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[6] ) 
            // oList7    := TCBrowse():New(000,001,274,110,, {'','Ativo','Modelo','Pick-List'},{10,30,40,20},;
            //                 oFld2:aDialogs[6],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
            // oList7:SetArray(aList7)
            // oList7:bLine := {||{ IF(aList7[oList7:nAt,01],oOk,oNo),; 
            //                         Alltrim(aList7[oList7:nAt,02]),;
            //                         aList7[oList7:nAt,03],;
            //                         aList7[oList7:nAt,04]}}    

        oGrp2    := TGroup():New( 152,284,198,424,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

            oBmp1    := TBitmap():New( 159,288,044,034,,"C:\Users\digog\OneDrive\Imagens\Saved Pictures\connect-vending-logo.png",.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. )
            oBmp2    := TBitmap():New( 159,339,044,034,,"\system\lgvmp.bmp",.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. )
            oSay1    := TSay():New( 160,386,{||"Pick List V. 2.0"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
            oSay2    := TSay():New( 178,386,{||"developed by"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
            oSay3    := TSay():New( 186,387,{||"AVSI Pro"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)

        oGrp3    := TGroup():New( 209,284,285,632,"Informa็๕es do Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            
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
        oTMenuIte1   := TMenuItem():New(oDlg1,"Pick-List Vmpay",,,,{|| Processa({|| Vmpay(),"Buscando informa็๕es"})},,,,,,,,,.T.)
        oTMenuIte7   := TMenuItem():New(oDlg1,"Vendas Vmpay",,,,{|| Processa({|| Vendaspay(),"Buscando informa็๕es"})},,,,,,,,,.T.)
        oTMenuIte2   := TMenuItem():New(oDlg1,"Validar Saldo",,,,{|| Processa({||saldos(),"Aguarde..."})},,,,,,,,,.T.)   
        oTMenuIte3   := TMenuItem():New(oDlg1,"Inverter",,,,{|| Processa({||inverte(),"Aguarde..."})},,,,,,,,,.T.) 
        oTMenuIte4   := TMenuItem():New(oDlg1,"Validar LAYOUT",,,,{|| Processa({|| ValidPlan(),"Aguarde..."})},,,,,,,,,.T.) 
        oTMenuIte5   := TMenuItem():New(oDlg1,"Gerar PV",,,,{|| Processa({||pedido(),"Aguarde..."})},,,,,,,,,.T.) 
        oTMenuIte8   := TMenuItem():New(oDlg1,"Salvar Vendas",,,,{|| Processa({||savevend(),"Aguarde..."})},,,,,,,,,.T.) 
        //oTMenuIte6 := TMenuItem():New(oDlg1,"Exportar Remessas",,,,{|| Processa({||Remessas(),"Aguarde..."})},,,,,,,,,.T.) 
        IF !lTeca
            oMenu:Add(oTMenuIte1)
            oMenu:Add(oTMenuIte7)
            oMenu:Add(oTMenuIte2)
            oMenu:Add(oTMenuIte3)
            oMenu:Add(oTMenuIte4)
            oMenu:Add(oTMenuIte5) 
            oMenu:Add(oTMenuIte8)
        ELSE
            oMenu:Add(oTMenuIte7)
        ENDIF
        //oMenu:Add(oTMenuIte6)
        //oBtn1      := TButton():New( 160,588,"oBtn1",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
        // Cria botใo que sera usado no Menu
        oTButton1 := TButton():New( 160, 588, "Op็๕es",oDlg1,{||},037,12,,,.F.,.T.,.F.,,.F.,,,.F. )
        // Define botใo no Menu
        oTButton1:SetPopupMenu(oMenu)     
        
        IF !lTeca
            // Menu popup grid 3
            MENU oMenuP POPUP 
            MENUITEM "Salvar LAYOUT"   ACTION (saveplan())
            /*MENUITEM "Incluir LAYOUT"  ACTION (incplan(1))
            MENUITEM "Alterar LAYOUT"  ACTION (incplan(2))
            MENUITEM "Excluir LAYOUT"  ACTION (excplan())
            MENUITEM "Replicar LAYOUT" ACTION (repplan())*/
            
            ENDMENU                                                                           
        
            oList3:bRClicked := { |oObject,nX,nY| oMenuP:Activate( nX, (nY-10), oObject ) }
        ENDIF                                                                               
        
    oDlg1:Activate(,,,.T.)
else
    MsgAlert("Nใo hแ dados a serem exibidos")
EndIf

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/11/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Buscan inicial;                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION Busca1(contrato)

LOCAL cQuery 
LOCAL aAtivos   :=  {}
LOCAL nX
Local cAtivos   :=  ''

cQuery := "SELECT AA3_CHAPA,B1_DESC,AA3_CBASE,AA3_CODCLI,AA3_LOJA,AA3_HORDIA,B1_GRUPO AS AA3_XCATEG,AA3_CODLOC,"
cQuery += " A1_NOME,A1_NREDUZ,A1_END,A1_BAIRRO,A1_MUN,A1_EST,A1_CEP,AA3_CODPRO,AAN_CONTRT"
cQuery += " FROM "+RetSQLName("AA3")+" AA3 "
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=AA3_CODPRO AND B1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("AAN")+" AAN ON AAN_FILIAL=AA3_FILIAL AND AAN_XCBASE=AA3_CBASE AND AAN.D_E_L_E_T_=''" //AA3_CBASE

IF !Empty(contrato)
    //Puxar leituras para faturamento
    cQuery += " AND AAN_CONTRT='"+contrato+"'"

ENDIF 

cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=AA3_CODCLI AND A1_LOJA=AA3_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " WHERE AA3.D_E_L_E_T_='' AND AA3_CODCLI <> '' AND AA3_CODCLI <> '999999'"
cQuery += " ORDER BY AA3_CHAPA"  

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF() 
    IF !Empty(TRB->AA3_CBASE) 

        nPos := Ascan(aCateg,{|x| x[1] == Alltrim(TRB->AA3_XCATEG)})
                         
        Aadd(aList,{.T.,;                   //1
                    TRB->AA3_CBASE,;        //2
                    TRB->B1_DESC,;          //3
                    TRB->AA3_CBASE,;        //4
                    TRB->A1_NOME,;          //5
                    TRB->A1_NREDUZ,;        //6
                    TRB->A1_END,;           //7
                    TRB->A1_BAIRRO,;        //8
                    TRB->A1_MUN,;           //9
                    TRB->A1_EST,;           //10
                    TRB->A1_CEP,;           //11
                    '',;                    //12
                    '',;                    //13
                    '',;                    //14
                    '',;                    //15
                    .F.,;                   //16
                    TRB->AA3_CODCLI,;       //17
                    TRB->AA3_LOJA,;         //18
                    IF(nPos>0,aCateg[nPos,2],''),; //19
                    TRB->AA3_CODLOC,;       //20
                    TRB->AA3_CODPRO,;       //21
                    TRB->AAN_CONTRT})       //22

        Aadd(aListB,{.T.,;
                    TRB->AA3_CBASE,;
                    TRB->B1_DESC,;
                    TRB->AA3_CBASE,;
                    TRB->A1_NOME,;
                    TRB->A1_NREDUZ,;
                    TRB->A1_END,;
                    TRB->A1_BAIRRO,;
                    TRB->A1_MUN,;
                    TRB->A1_EST,;
                    TRB->A1_CEP,;
                    '',;
                    '',;
                    '',;
                    '',;
                    .F.,;
                    TRB->AA3_CODCLI,;
                    TRB->AA3_LOJA,;
                    IF(nPos>0,aCateg[nPos,2],''),;
                    TRB->AA3_CODLOC,;
                    TRB->AA3_CODPRO,;
                    TRB->AAN_CONTRT})
                    
        IF Ascan(aAtivos,{|x| Alltrim(x) == Alltrim(TRB->AA3_CHAPA)}) == 0
            Aadd(aAtivos,TRB->AA3_CHAPA)
        ENDIF
    ENDIF    
    Dbskip()
ENDDO

Aeval(aAtivos,{|x| cAtivos += "'"+x+"',"})
 
cQuery := "SELECT B1_COD,B1_DESC"
cQuery += " FROM "+RetSQLName("SB1")+" SB1 "
cQuery += " WHERE SB1.D_E_L_E_T_='' AND B1_MSBLQL<>'1'"
cQuery += " ORDER BY B1_COD"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
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
    nSaldo            :=    SaldoSB2()
    aList2B[nX,04]    :=    nSaldo
    aList2[nX,04]     :=    nSaldo
NEXT nX

cQuery := "SELECT Z07_CHAPA,Z07_SELECA,Z07_CODPRO,B1_DESC,Z07_VLRVND" 
cQuery += " FROM "+RetSQLName("Z07")+" Z07"
cQuery += " LEFT JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"'"
cQuery += "  AND B1_COD=Z07_CODPRO AND B1.D_E_L_E_T_=' '"
cQuery += " WHERE Z07_FILIAL='"+xFilial("Z07")+"'"
cQuery += " AND Z07_CHAPA IN("+substr(cAtivos,1,len(cAtivos)-1)+")"
cQuery += " AND Z07.D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
    
DbSelectArea("TRB")  

WHILE !EOF()   
    Aadd(aList3B,{  .T.,;
                    TRB->Z07_CHAPA,;
                    TRB->Z07_SELECA,;
                    TRB->Z07_CODPRO,;
                    TRB->B1_DESC,;
                    TRB->Z07_VLRVND})
    Dbskip()
EndDo 
// cQuery := "SELECT Z11_NUMSER,Z11_SEQUEN,Z11_BEBIDA,B1_DESC,0 AS QTD,'' AS CLIENTE,'' AS LOJA,Z11_MAQUINA"
// cQuery += " FROM "+RetSQLName("Z11")+" Z11"
// cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=Z11_BEBIDA AND B1.D_E_L_E_T_=''"
// cQuery += " INNER JOIN "+RetSQLName("AAN")+" AN ON AAN_XCBASE=Z11_NUMSER AND AN.D_E_L_E_T_=''"
// cQuery += " WHERE Z11.D_E_L_E_T_='' AND Z11_NUMSER<>''" 
cQuery := "SELECT ABS_LOCAL,ABS_DESCRI,ABS_CODIGO,ABS_LOJA,ABS_END,ABS_BAIRRO,ABS_MUNIC,ABS_ESTADO,ABS_CEP"
cQuery += " FROM "+RetSQLName("ABS")
cQuery += " WHERE D_E_L_E_T_=''"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF()   
    Aadd(aList4B,{.F.,TRB->ABS_LOCAL,Alltrim(TRB->ABS_DESCRI),TRB->ABS_CODIGO,TRB->ABS_LOJA,;
                    Alltrim(TRB->ABS_END),Alltrim(TRB->ABS_BAIRRO),Alltrim(TRB->ABS_MUNIC),Alltrim(TRB->ABS_ESTADO),TRB->ABS_CEP})
    Dbskip()
ENDDO

cQuery := "SELECT NNR_CODIGO,NNR_DESCRI"
cQuery += " FROM "+RetSQLName("NNR")+" NNR "
// cQuery += " WHERE NNR.D_E_L_E_T_='' AND SUBSTRING(NNR_CODIGO,1,1)='R' ORDER BY NNR_CODIGO"
cQuery += " WHERE NNR.D_E_L_E_T_='' ORDER BY NNR_CODIGO"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
    
DbSelectArea("TRB")  

WHILE !EOF()     
    Aadd(aList5B,{.F.,TRB->NNR_CODIGO,TRB->NNR_DESCRI,'','','','','',''})
    Aadd(aList5,{.F.,TRB->NNR_CODIGO,TRB->NNR_DESCRI,'','','','','',''})
    Dbskip()
ENDDO


RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Pesquisas                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
        oList:nAt := 1
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
            MsgAlert("Nใo encontrado Ativos para o cliente pesquisado")
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
        MsgAlert("Nใo hแ pick-lists pendentes")
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
            MsgAlert("Nใo encontrado Ativos com a Linha pesquisada.","busca2 - CONFATC01")
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
ElseIf cCombo1 == "7"
    aList := {}
    oList1:nAt := 1
    FOR nX := 1 TO len(aListB)
        IF Alltrim(UPPER(cBusca)) $ Alltrim(aListB[nX,22])
            Aadd(aList,aListB[nX])
        ENDIF
    NEXT nX
    
    IF len(aList) < 1
        IF !Empty(cBusca)
            MsgAlert("Nใo encontrado Ativos com a Linha pesquisada.","busca2 - CONFATC01")
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

    oList:refresh()
    oDlg1:refresh()
ENDIF

 Fhelp()

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Atualizacao dos itens conforme ativo selecionado          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION FHelp()

LOCAL nX

oSay4:settext("")
oSay5:settext("")
oSay6:settext("")
oSay7:settext("")
oSay8:settext("")

oSay4:settext('Cliente  - '+Alltrim(aList[oList:nAT,05])+" / "+Alltrim(aList[oList:nAT,06])+" - Contrato "+Alltrim(aList[oList:nAT,22]))
oSay5:settext('Endere็o - '+Alltrim(aList[oList:nAT,07])+" / "+Alltrim(aList[oList:nAT,08])+" / "+Alltrim(aList[oList:nAT,09])+" / "+Alltrim(aList[oList:nAT,10])+" / "+Alltrim(aList[oList:nAT,11]))

aList1 := {}
aList3 := {}  
aList4 := {}  
aList6 := {}  
aList8 := {} 
// aList9 := {}

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
                        Strzero(val(aList3[oList3:nAt,03]),3),;
                        aList3[oList3:nAt,04],;
                        aList3[oList3:nAt,05],;
                        Transform(aList3[oList3:nAt,06],"@E 999,999.99")}}   

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
                oSay6:settext("Local de Instala็ใo "+aList4[len(aList4),06]+" / "+aList4[len(aList4),07]+" / "+aList4[len(aList4),08]+" / "+aList4[len(aList4),09]+" / "+aList4[len(aList4),10])
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
if len(aList8B) > 0     
    FOR nX := 1 TO len(aList8B[oList8:nAt,1])
        IF Alltrim(aList8B[oList8:nAt,1,nX,6]) == Alltrim(aList[oList:nAt,02])
            Aadd(aList8,aList8B[oList8:nAt,1])
            nPos := Ascan(aList3B,{|x| Alltrim(x[2])+Alltrim(x[3]) == Alltrim(aList8B[nX,06])+Alltrim(aList8B[nX,02])})
            IF nPos > 0  
                aList8[len(aList8),03] := aList3B[nPos,04]
                aList8[len(aList8),04] := aList3B[nPos,05]
            ENDIF
        ENDIF
    NEXT nX
endif

IF len(aList8) < 1
    Aadd(aList8,{'','','','','','','','','','','','','','','','','','',''})

    oList8:nAt := 1
    oList8:SetArray(aList8)
    oList8:bLine := {||{aList8[oList8:nAt,01],;
                        strzero(val(aList8[oList8:nAt,02]),3),; 
                        aList8[oList8:nAt,03],;
                        aList8[oList8:nAt,04],;
                        aList8[oList8:nAt,05],;
                        aList8[oList8:nAt,08]}} 
else
    oList8:nAt := 1
    oList8:SetArray(aList8)
    oList8:bLine := {||{aList8[oList:nAt,oList8:nAt,01],;
                        strzero(val(aList8[oList:nAt,oList8:nAt,02]),3),; 
                        aList8[oList:nAt,oList8:nAt,03],;
                        aList8[oList:nAt,oList8:nAt,04],;
                        aList8[oList:nAt,oList8:nAt,05],;
                        aList8[oList:nAt,oList8:nAt,08]}} 
ENDIF


                     
// FOR nX := 1 TO len(aList9B)
//     IF Alltrim(aList9B[nX,04]) == Alltrim(aList[oList:nAt,02])
//         Aadd(aList9,aList9B[nX])
//     ENDIF
// NEXT nX
         
// IF len(aList9) < 1
//     Aadd(aList9,{'','','','','','','','','','','','','','','','','','',''})
// ENDIF

// oList9:nAt := 1
// oList9:SetArray(aList9)
// oList9:bLine := {||{aList9[oList9:nAt,01],;
//                     aList9[oList9:nAt,02],; 
//                      aList9[oList9:nAt,03]}}       

IF len(aList6) < 1
    Aadd(aList6,{.F.,'','','','','','','','','','','','','','','','','','',''})
ENDIF

// oList6:SetArray(aList6)
// oList6:bLine := {||{ IF(aList6[oList6:nAt,01],oOk,oNo),; 
//                         Alltrim(aList6[oList6:nAt,02]),;
//                         aList6[oList6:nAt,03],;
//                         aList6[oList6:nAt,04],;
//                         aList6[oList6:nAt,05],;
//                         aList6[oList6:nAt,06],;
//                         aList6[oList6:nAt,07]}}

                     
oList1:refresh()
oList3:refresh()    
oList4:refresh()
// oList6:refresh()
oList8:refresh()
// oList9:refresh()
oList:refresh()

oDlg1:refresh()

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Buscar Pick-Lists pendentes                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION VMPay()

LOCAL aArea    :=    GetArea()
LOCAL aRet     :=    {}
LOCAL nSld     :=    0
LOCAL cArmz    :=    '01'    
LOCAL lFlag    :=    .f.  
// LOCAL aAuxL    :=    {}
LOCAL nX
                  
aRet := U_CONWSC02()

//'','Mola','Produto','Descri็ใo','Quant.','Conf','Nivel Par','Saldo'
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

IF MsgYesNo("Filtrar somente ativos com Pick-List pendentes?","VMPay - CONFATC01")
    cCombo1 := "5"
    Busca2(1)    
ENDIF

RestArea(aArea)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Edita a coluna de saldo do item do picklist                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
        IF MsgYesNo("Nใo hแ saldo para atender este item, confirma a inclusใo desta quantidade?","editcol - PRTOPE01")
            lSaldo := .T.
        ENDIF
    ENDIF    
ENDDO



oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01  บAutor  ณMicrosiga           บ Data ณ  03/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Tela com saldo por item para administracao               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  08/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

// Fhelp()

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  03/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
oSaySld:settext("Total   "+cvaltochar(nTotal)+"   /   Diferen็a para Saldo   "+cvaltochar(nTotal-aSaldo1[oSaldo1:nAt,04]))

oSaldo2:refresh()
oSaldo:refresh()

RestArea(aArea)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  08/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
oSaySld:settext("Total   "+cvaltochar(nTotal)+"   /   Diferen็a para Saldo   "+cvaltochar(nTotal-aSaldo1[oSaldo1:nAt,04]))
oSaldo2:refresh()
oSaldo:refresh()

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Inverte marcacao do alist com os ativos para geracao do   บฑฑ
ฑฑบ          ณpedido                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  02/22/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Linha do primeiro grid                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Geracao do pedido de venda                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
        aPergs    :=    {}
        aRet      :=    {}               
        cAbast    :=    space(6)   
        cMsgNf    :=    'Pedido Gerado pelo Pick-List do Ativo '+aList[nContJ,02]+space(095)
        aAdd(aPergs ,{1, "Abastecedor"       , cAbast, "", "", "SA4", "", 040, .T.})
        aAdd(aPergs ,{1, "Mensagem para nota", cMsgNf, "", "",    "", "", 240, .T.})    
        
        IF ParamBox(aPergs ,"Informe Abastec e Msg Nf Ativo "+aList[nContJ,02],@aRet)
            cAbast := aRet[1]
            cMsgNf := aRet[2]
        ENDIF
        
        aCabec := {} 
        aItens := {}    
        lPick  := .F.
        aAdd( aCabec , { "C5_FILIAL"    , xFilial("SC5")      , Nil } ) 
        aAdd( aCabec , { "C5_LOCADO"    , 'DOA'               , Nil } )
        aAdd( aCabec , { "C5_TIPO"      , 'N'                 , Nil } )
        aAdd( aCabec , { "C5_CLIENTE"   , '036659'            , Nil } )
        aAdd( aCabec , { "C5_LOJACLI"   , '01'                , Nil } )
        aAdd( aCabec , { "C5_CLIOS"     , aList[nContJ,17]    , Nil } )
        aAdd( aCabec , { "C5_LOJAOS"    , aList[nContJ,18]    , Nil } ) 
        aAdd( aCabec , { "C5_TRANSP"    , cAbast              , Nil } ) 
        Aadd( aCabec , { "C5_MENNOTA"   , cMsgNf              , Nil } )
        aAdd( aCabec , { "C5_CONDPAG"   , '999'               , Nil } )    
        
        IF cempant == "01"
            aAdd( aCabec , { "C5_ICROTA", '999999'            , Nil } )
        ENDIF
        
        aAdd( aCabec , { "C5_ICBCN"     , 'VDG'               , Nil } )
        aAdd( aCabec , { "C5_EMP"       , '6'                 , Nil } )
        aAdd( aCabec , { "C5_ICBVBC"    , 1                   , Nil } )
        
        aAdd( aCabec , { "C5_TABELA"    , '200'               , Nil } )    
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
                
                aAdd( aLinha , { "C6_FILIAL"     , xFilial("SC6")                         , Nil })
                aAdd( aLinha , { "C6_ITEM"       , StrZero(nItem,TamSX3("C6_ITEM")[1])    , Nil })
                aAdd( aLinha , { "C6_PRODUTO"    , aList1B[nJ,03]                         , Nil })
                aAdd( aLinha , { "C6_QTDVEN"     , aList1B[nJ,06]                         , Nil })
                aAdd( aLinha , { "C6_PRCVEN"     , nPreco                                 , Nil })
                // aAdd( aLinha , { "C6_OPER"       , '03'                                   , Nil })  
                aAdd( aLinha , { "C6_TES"        , cTesut                                 , Nil })  
                aAdd( aLinha , { "C6_QTDLIB"     , aList1B[nJ,06]                         , Nil })
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

MsgAlert("Pedido(s) Gerado(s) "+cMsgPed,"CONFATC01")
oDlg1:end()

RestArea(aArea)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Alterar quantidade de itens modificados na rotina no VMPayบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
LOCAL aHeader        :=    {}        
LOCAL nPikid         :=    199090      
LOCAL cChavP         :=    "?access_token=yVXxnxgOExcIaBQOQ9CFgK0cLgX22dJct7y85WXW"  
LOCAL nX

Aadd(aHeader, "Authorization: Basic " + Encode64("access_token:yVXxnxgOExcIaBQOQ9CFgK0cLgX22dJct7y85WXW"))

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

cVarVM    +=    '    {'+CRLF
cVarVM    +=    '    "pick_list": {'+CRLF             
cVarVM    +=    '        "items_attributes"    : ['+CRLF

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
        aAuxR2    :=    {}
        //cVarVM += '"'+substr(aAuxAr[nPos3,1],1,2)+'"'+substr(aAuxAr[nPos3,1],3)
        //Aadd(aAuxR2,'"'+substr(aAuxAr[nPos3,1],1,2)+'"'+substr(aAuxAr[nPos3,1],3))
        //Aadd(aAuxR2,aAuxAr[nPos3,01])
        cVarVM    +=    '{'+CRLF
        cVarVM    +=    '"'+substr(aAuxAr[nPos3,1],1,2)+'"'+substr(aAuxAr[nPos3,1],3)+','+CRLF
        
        
        aAuxP     :=    strtokarr(aAuxAr[nPos3,2],":")
        cVarVM    +=    '"'+aAuxP[1]+'":'+aAuxP[2]+','+CRLF
        //Aadd(aAuxR2,'"'+aAuxP[1]+'":'+aAuxP[2])
        Aadd(aAuxR2,aAuxAr[nPos3,02])
        
        aAuxP     :=    strtokarr(aAuxAr[nPos3,3],":")
        cVarVM    +=    '"'+aAuxP[1]+'":'+cvaltochar(aList1B[nJ,06])+CRLF
        cVarVM    +=    ' }'+CRLF
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/15/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validar o planograma da maquina no vmpay                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION ValidPlan()

LOCAL aArea    :=    GetArea()
      
U_CONWSC03(aList[oList:nAt,02],1)

RestArea(aArea)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/15/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Salvar o planograma de acordo com o contido no vmpay      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION Saveplan()

LOCAL aArea    :=    GetArea()
LOCAL lAlt     :=    .F. 
LOCAL nX
LOCAL nJ

FOR nX := 1 TO len(aList3)
    IF !aList3[nX,01] 
        DbSelectArea("Z07")     
        DbSetOrder(1)

        IF !DbSeek(xFilial("Z07")+Avkey(aList3[nX,02],"Z07_CHAPA")+Avkey(aList[oList:nAt,17],"Z07_CLIENT")+Avkey(aList[oList:nAt,18],"Z07_LOJA")+Avkey(strzero(val(aList3[nX,03]),3),"Z07_SELECA"))
            Reclock("Z07",.T.)
        else
            Reclock("Z07",.F.)
        EndIF 
        
        Z07->Z07_FILIAL     :=  xFilial("Z07")
        Z07->Z07_CLIENT     :=  aList[oList:nAt,17]
        Z07->Z07_LOJA       :=  aList[oList:nAt,18]
        Z07->Z07_CHAPA      :=  aList3[nX,02]
        Z07->Z07_CODMAQ     :=  Posicione("AA3",7,xFilial("AA3")+aList3[nX,02],"AA3_CODPRO")
        Z07->Z07_CODPROD    :=  aList3[nX,04]
        Z07->Z07_SELECA     :=  strzero(val(aList3[nX,03]),3)
        Z07->Z07_DINICIO    :=  dDataBase
        Z07->(Msunlock())
    ENDIF

    aList3[nX,01] := .T.
    lAlt := .T.

NEXT nX
                   
IF lAlt
    FOR nX := 1 TO len(aList3)
        nPos := Ascan(aList3B,{|x| alltrim(x[2])+Alltrim(x[3]) == Alltrim(aList3[nX,02])+Alltrim(aList3[nX,03])})
        IF nPos > 0         
            FOR nJ := 1 TO len(aList3B[nPos]) //len(aList3[nX])
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/29/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  iNCLUIR PLANOGRAMAS                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

oPlan1     := MSDialog():New( 092,232,577,1480,"Incluir LAYOUT",,,.F.,,,,,,.T.,,,.T. )

    oGrPlan    := TGroup():New( 000,004,212,619,"Produtos",oPlan1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,008,208,340},,, oGrPlan ) 
    oPlanog        := TCBrowse():New(008,008,609,202,, {'','Mola','Produto','Descri็ใo','Quant.','Conf','Nivel Par','Insumo1','Dosagem1','Insumo2','Dosagem2','Insumo3','Dosagem3','Insumo4','Dosagem4','Insumo5','Dosagem5','Insumo6','Dosagem6','Insumo7','Dosagem7'},;
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
    DbSelectArea("Z06")     
    DbSetOrder(2)
    //FILIAL+CHAPA+SELECAO+CODCLI
    FOR nX := 1 TO len(aPlanog)
        IF !DbSeek(xFilial("Z06")+aPlanog[nX,38]+aPlanog[nX,02]+aPlanog[nX,36])    
            Reclock("Z06",.T.)
            Z06->Z06_CODCLI     :=    aPlanog[nX,36]
            Z06->Z06_LOJCLI    :=    aPlanog[nX,37]
            Z06->Z06_CHAPA    :=    aPlanog[nX,38]
            Z06->Z06_CODMAQ    :=    aPlanog[nX,40]
            Z06->Z06_CODPRO    :=    aPlanog[nX,03]
            Z06->Z06_SELECAO    :=    aPlanog[nX,02]
            //Insumos
            Z06->Z06_INSUM1     :=     aPlanog[nX,08]
            Z06->Z06_MEDID1    :=    aPlanog[nX,09]
            Z06->Z06_INSUM2     :=    aPlanog[nX,10]
            Z06->Z06_MEDID2    :=    aPlanog[nX,11]
            Z06->Z06_INSUM3     :=    aPlanog[nX,12]
            Z06->Z06_MEDID3    :=    aPlanog[nX,13]
            Z06->Z06_INSUM4     :=    aPlanog[nX,14]
            Z06->Z06_MEDID4    :=    aPlanog[nX,15]               
            Z06->Z06_INSUM5     :=    aPlanog[nX,16]
            Z06->Z06_MEDID5    :=    aPlanog[nX,17]
            Z06->Z06_INSUM6     :=    aPlanog[nX,18]
            Z06->Z06_MEDID6    :=    aPlanog[nX,19]
            Z06->Z06_INSUM7     :=    aPlanog[nX,20]
            Z06->Z06_MEDID7    :=    aPlanog[nX,21]
            
            Z06->(Msunlock())        
            Aadd(aList3B,{.T.,aPlanog[nX,38],aPlanog[nX,02],aPlanog[nX,03],aPlanog[nX,04],aPlanog[nX,05],aPlanog[nX,06],'',;
                            0,aPlanog[nX,36],aPlanog[nX,37]})
            
        ELSE
            Reclock("Z06",.F.)
            Z06->Z06_CODCLI     :=    aPlanog[nX,36]
            Z06->Z06_LOJCLI    :=    aPlanog[nX,37]
            Z06->Z06_CHAPA     :=    aPlanog[nX,38]
            Z06->Z06_CODMAQ    :=    aPlanog[nX,40]
            Z06->Z06_CODPRO    :=    aPlanog[nX,03]
            Z06->Z06_SELECAO    :=    aPlanog[nX,02]
            //Insumos
            Z06->Z06_INSUM1     :=     aPlanog[nX,08]
            Z06->Z06_MEDID1    :=    aPlanog[nX,09]
            Z06->Z06_INSUM2     :=    aPlanog[nX,10]
            Z06->Z06_MEDID2    :=    aPlanog[nX,11]
            Z06->Z06_INSUM3     :=    aPlanog[nX,12]
            Z06->Z06_MEDID3    :=    aPlanog[nX,13]
            Z06->Z06_INSUM4     :=    aPlanog[nX,14]
            Z06->Z06_MEDID4    :=    aPlanog[nX,15]               
            Z06->Z06_INSUM5     :=    aPlanog[nX,16]
            Z06->Z06_MEDID5    :=    aPlanog[nX,17]
            Z06->Z06_INSUM6     :=    aPlanog[nX,18]
            Z06->Z06_MEDID6    :=    aPlanog[nX,19]
            Z06->Z06_INSUM7     :=    aPlanog[nX,20]
            Z06->Z06_MEDID7    :=    aPlanog[nX,21]
            
            Z06->(Msunlock())        
        
        ENDIF
    NEXT nX
ENDIF

RETURN                                                                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/29/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Incluir linha no planograma                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION IncLin(nOpc)

LOCAL aArea    :=    GetArea()

IF nOpc == 1
    aadd(aPlanog,{.F.,space(3),'','','','','','',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,;
                '',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
ELSE
    DbSelectArea("Z06")
    DbSetOrder(2)
    IF Dbseek(xFilial("Z06")+aPlanog[oPlanog:nAt,38]+aPlanog[oPlanog:nAt,02]+aPlanog[oPlanog:nAt,36])
        Reclock("Z06",.F.)
        DbDelete()
        Z06->(Msunlock())
    ENDIF
    
    IF Ascan(aList3,{|x| Alltrim(x[2]) == Alltrim(aPlanog[oPlanog:nAt,03]) }) > 0
        Adel(aList3,Ascan(aList3,{|x| Alltrim(x[2]) == Alltrim(aPlanog[oPlanog:nAt,03]) }))
        Asize(aList3,len(aList3)-1)
    ENDIF
    ADel(aPlanog,oPlanog:nAt)
    Asize(aPlanog,len(aPlanog)-1)
    
    IF len(aPlanog) < 1
        aadd(aPlanog,{.F.,space(3),'','','','','','',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,;
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  04/29/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Edita linhas do planograma                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  05/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclui planograma                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION excplan()

LOCAL aArea    :=    GetArea()
LOCAL nCont    :=    len(aList3)
 
DbSelectArea("Z06")     
DbSetOrder(2)
//FILIAL+CHAPA+SELECAO+CODCLI
IF DbSeek(xFilial("Z06")+ALIST[oList:nAt,02])
       WHILE !EOF() .And. Z06->Z06_CHAPA == ALIST[oList:nAt,02]
           Reclock("Z06",.F.)
           DbDelete()
           Z06->(Msunlock())
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  05/10/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   remessas enviadas para os pontos de venda                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
    cDir         :=    cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
    
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
    
    MemoWrite("CONFATC01.SQL",cQuery)
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
        oExcel:AddColumn("Remessas","PDV","Descri็ใo",1,1) 
        oExcel:AddColumn("Remessas","PDV","Qtd Enviada",1,1) 
        oExcel:AddColumn("Remessas","PDV","Pre็o Unitแrio",1,1) 
        oExcel:AddColumn("Remessas","PDV","Codigo Cliente",1,1) 
        oExcel:AddColumn("Remessas","PDV","Loja",1,1) 
        oExcel:AddColumn("Remessas","PDV","PDV",1,1) 
        oExcel:AddColumn("Remessas","PDV","Data Entrega",1,1) 
        oExcel:AddColumn("Remessas","PDV","Data Emissใo",1,1) 
        
        FOR nX := 1 TO len(aExcel)
            oExcel:AddRow("Remessas","PDV",{aExcel[nX,01],;
                                            aExcel[nX,02],;  //Produto
                                            aExcel[nX,03],;  //Descricao
                                            aExcel[nX,04],;
                                            aExcel[nX,05],;
                                            aExcel[nX,06],;
                                            aExcel[nX,07],;  //Qtd
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  05/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑบฑฑ
ฑฑบDesc.     ณ    Busca planograma                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION BuscPlan()

LOCAL aArea    :=    GetArea()
LOCAL cQuery
LOCAL aRet     :=    {}

cQuery := "SELECT Z06.*,B1_DESC FROM "+RetSQLName("Z06")+" Z06"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=Z06_CODPRO AND B1.D_E_L_E_T_=''
cQuery += " WHERE Z06_CHAPA='"+aList[oList:nAt,02]+"' AND Z06_CODCLI='"+aList[oList:nAt,17]+"' AND Z06.D_E_L_E_T_=''"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

//'','Mola','Produto','Descri็ใo','Quant.','Conf','Nivel Par','Insumo1','Dosagem1','Insumo2','Dosagem2','Insumo3','Dosagem3','Insumo4','Dosagem4','Insumo5','Dosagem5','Insumo6','Dosagem6','Insumo7','Dosagem7'
WHILE !EOF() 
    Aadd(aRet,{.F.,TRB->Z06_SELECAO,TRB->Z06_CODPRO,Alltrim(TRB->B1_DESC),;
                TRB->Z06_CAPACID,TRB->Z06_NIVALE,TRB->Z06_NIVPAR,TRB->Z06_INSUM1,TRB->Z06_MEDID1,TRB->Z06_INSUM2,TRB->Z06_MEDID2,;
                TRB->Z06_INSUM3,TRB->Z06_MEDID3,TRB->Z06_INSUM4,TRB->Z06_MEDID4,TRB->Z06_INSUM5,TRB->Z06_MEDID5,TRB->Z06_INSUM6,;
                TRB->Z06_MEDID6,TRB->Z06_INSUM7,TRB->Z06_MEDID7,;
                '',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
    Dbskip()
ENDDO

IF len(aRet) < 1
    aadd(aRet,{.F.,space(3),'','','','','','',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,;
                '',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
ENDIF

RestArea(aArea)

RETURN(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  05/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca as vendas do Vmpay                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION Vendaspay()

LOCAL aArea    :=   GetArea()
LOCAL dDtD     :=   FirstDate(Date()) 
LOCAL dDtA     :=   LastDate(Date())    
LOCAL cHri     :=   '00:00'
Local cHrf     :=   '23:59'
Local cAtde    :=   space(15)
Local cAtAt    :=   space(15)
Local cCnde    :=   space(15)
Local cCnAt    :=   space(15)


LOCAL cData    :=    ''
LOCAL nX
LOCAL nY

PRIVATE aPergs     :=    {}
PRIVATE aRet       :=    {}
PRIVATE aVendas    :=    {}

aAdd(aPergs ,{1, "Data Inicial?",   dDtD, "", "", "", "", 070, .T.})    
aAdd(aPergs ,{1, "Data Final?",     dDtA, "", "", "", "", 070, .T.})    
aAdd(aPergs ,{1, "Hora Inicial?",   cHri, "", "", "", "", 070, .F.})    
aAdd(aPergs ,{1, "Hora Final?",     cHrf, "", "", "", "", 070, .F.})    
aAdd(aPergs ,{1, "Ativo de?",       cAtde, "", "", "", "", 070, .F.})    
aAdd(aPergs ,{1, "Ativo At้?",      cAtAt, "", "", "", "", 070, .F.})    
aAdd(aPergs ,{1, "Contrato de?",    cCnde, "", "", "", "", 070, .F.})    
aAdd(aPergs ,{1, "Contrato At้?",   cCnAt, "", "", "", "", 070, .F.})    


IF ParamBox(aPergs ,"Periodo de vendas",@aRet)
    for nX := 1 to len(aList)
        If Alltrim(aList[nX,02]) >= Alltrim(MV_PAR05) .AND. Alltrim(aList[nX,02]) <= Alltrim(MV_PAR06) .AND. ;
            Alltrim(aList[nX,22]) >= Alltrim(MV_PAR07) .AND. Alltrim(aList[nX,22]) <= Alltrim(MV_PAR08)
            Aadd(aVendas, U_CONWSC03(aList[nX,02],2,aRet[1],aRet[2],aRet[3],aRet[4]))
        EndIf
    next

    IF len(aVendas) > 0
        aList8B := {}
    //'Data','Sele็ใo','Produto','Descri็ใo','Quant. Apont.',chapa,codigo cliente
        FOR nX := 1 TO len(aVendas) 
            aList8 := {}
            If aVendas[nX] != NIL
                If len(aVendas[nX]) > 2
                    for nY := 3 to len(aVendas[nX])
                        cCodProt := ''
                        IF aVendas[nX,nY,05] == "null"
                            cCodProt := "Nao Consta"
                        ELSE
                            cCodProt := aVendas[nX,nY,05]
                        ENDIF
                        
                        if cCodProt != "Nao Consta"
                            cDesc := Posicione("SB1",1,xFilial("SB1")+cCodProt,"B1_DESC")
                        else
                            cDesc := "Codigo do produto nao se encontra no VMPay"
                        endif

                        nPosit := Ascan(aList8,{|x| x[2] == aVendas[nX,nY,01]})
                        IF nPosit == 0
                            cData := ddatabase //stod(StrTran(SubStr(aVendas[nX,nY,02], 1, 10), '-')) //StrTran(StrTran(SubStr(aVendas[nX,nY,02], 1, 10), '-', '/'), 'T', ' ')
                            Aadd(aList8,{cvaltochar(cData),;
                                        aVendas[nX,nY,01],;
                                        cCodProt,;
                                        cDesc,;
                                        val(aVendas[nX,nY,03]),;
                                        aVendas[nX,2],;
                                        aList[nX,17],;
                                        IF(val(aVendas[nX,nY,03])>1,val(aVendas[nX,nY,04])/val(aVendas[nX,nY,03]),val(aVendas[nX,nY,04]))})
                        ELSE
                            aList8[nPosit,05] += val(aVendas[nX,nY,03])
                        ENDIF
                    next nY
                EndIf
            EndIf 
            
            If len(aList8) < 1
                Aadd(aList8,{'','','','','','','','','','','','','','','','','','',''})
            EndIf 
            
            Aadd(aList8B, {})
            
            Aadd(aList8B[nX], aList8)
        NEXT nX
        
        IF len(aList8) > 0
            Asort(aList8,,,{|x,y| strzero(val(x[2]),3)+x[1] < strzero(val(y[2]),3)+y[1]})
            oList8:SetArray(aList8)
            oList8:bLine := {||{aList8[oList8:nAt,01],;
                                strzero(val(aList8[oList8:nAt,02]),3),; 
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  06/08/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION savevend()
    
    LOCAL aArea        :=    GetArea()  
    LOCAL aGravarP     :=    {} 
    LOCAL cCod         := GetSXENum("Z08", "Z08_COD") 
    LOCAL cSeq         :=    "01" 
    LOCAL aContrato    :=    Contrato()
    LOCAL nX   
    LOCAL nY   
    
    for nX := 1 to len(aList8)

        aGravarP := {}

        Aadd( aGravarP, {"Z08_FILIAL"  ,xFilial("Z08")})
        Aadd( aGravarP, {"Z08_COD"     ,cCod})
        Aadd( aGravarP, {"Z08_SEQUEN"  ,cSeq})
        Aadd( aGravarP, {"Z08_NUMSER"  ,aList[oList:nAt,2]})
        Aadd( aGravarP, {"Z08_DATA"    ,ctod(aList8[nX,1])})
        Aadd( aGravarP, {"Z08_SELECA"  ,aList8[nX,2]})
        Aadd( aGravarP, {"Z08_PRODUT"  ,aList8[nX,3]})
        Aadd( aGravarP, {"Z08_CONTRT"  ,aContrato[1,1]})
        Aadd( aGravarP, {"Z08_ITEM"    ,aContrato[1,2]})
        Aadd( aGravarP, {"Z08_QTDLID"  ,aList8[nX,5]})
        Aadd( aGravarP, {"Z08_VLRLID"  ,aList8[nX,8]})
        Aadd( aGravarP, {"Z08_DTDIGIT" ,dDataBase}) 
        Aadd( aGravarP, {"Z08_PERIODO" ,Strtokarr(aList8[nX,1], "/")[2] + Strtokarr(aList8[nX,1], "/")[3] })
        Aadd( aGravarP, {"Z08_MAQUINA" ,aList[oList:nAt,21]}) 
        Aadd( aGravarP, {"Z08_CODCLI"  ,aList[oList:nAt,17]+aList[oList:nAt,18]})  
        Aadd( aGravarP, {"Z08_CLIPAG"  ,aList[oList:nAt,17]+aList[oList:nAt,18]})

        IF len(aGravarP) > 0

            DbSelectArea("Z08") 

            Reclock("Z08",.T.)

            FOR nY := 1 TO len(aGravarP)

                &("Z08->"+aGravarP[nY,01]) := aGravarP[nY,02]
            
            NEXT nY

            Z08->(Msunlock())
            
            MsgAlert("Leitura salva com sucesso!")
            
        ENDIF

        cSeq := Soma1(cSeq)

    next nX

    RestArea(aArea)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  05/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION Contrato()

    LOCAL cQuery := ""
    LOCAL aRet   := {}

    cQuery := " "
    cQuery += " SELECT AAN_CONTRT,AAN_ITEM FROM " + RetSQLName("AAN") + " "
    cQuery += " INNER JOIN " + RetSQLName("SN1") + " "
    cQuery += " ON N1_FILIAL = " + xFilial("SN1") + " AND AAN_XCBASE = N1_CBASE "
    cQuery += " WHERE AAN_XCBASE = '" + AllTrim(aList[oList:nAt,2]) + "' "
    cQuery += " AND AAN_FILIAL = " + xFilial("AAN") + " "

    if Select("TRB") > 0
        DBSELECTAREA("TRB")
        DBCLOSEAREA()
    endif
    
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    while !EOF()

        Aadd(aRet, {TRB->AAN_CONTRT, TRB->AAN_ITEM})

        DBSKIP()
    end

RETURN  aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  07/19/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Replicar Planograma para outro ativo.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

oRepPl     := MSDialog():New( 092,232,437,876,"Replicar LAYOUT",,,.F.,,,,,,.T.,,,.T. )

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
    IF MsgYesNo("Confirma a c๓pia do LAYOUT atual para as maquinas selecionadas?","repplan - CONFATC01")
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
        
        DbSelectArea("Z06")
        FOR nX := 1 TO len(aGrav)
            Reclock("Z06",.T.)
            Z06->Z06_CODCLI     :=    aGrav[nX,10]
            Z06->Z06_LOJCLI     :=    aGrav[nX,11]
            Z06->Z06_CHAPA      :=    aGrav[nX,02]
            Z06->Z06_CODMAQ     :=    aGrav[nX,12]
            Z06->Z06_CODPRO     :=    aGrav[nX,04]
            Z06->Z06_SELECAO    :=    aGrav[nX,03]
            Z06->Z06_CAPACID    :=    aGrav[nX,06]
            Z06->Z06_NIVPAR     :=    aGrav[nX,07]
            Z06->Z06_NIVALE     :=    aGrav[nX,08]
            Z06->Z06_VALOR      :=    aGrav[nX,09]
            Z06->Z06_INSUM1     :=    aGrav[nX,13]
            Z06->Z06_MEDID1     :=    aGrav[nX,14]
            Z06->Z06_INSUM2     :=    aGrav[nX,15]
            Z06->Z06_MEDID2     :=    aGrav[nX,16]
            Z06->Z06_INSUM3     :=    aGrav[nX,17]
            Z06->Z06_MEDID3     :=    aGrav[nX,18]
            Z06->Z06_INSUM4     :=    aGrav[nX,19]
            Z06->Z06_MEDID4     :=    aGrav[nX,20]
            Z06->Z06_INSUM5     :=    aGrav[nX,21]
            Z06->Z06_MEDID5     :=    aGrav[nX,22]
            Z06->Z06_INSUM6     :=    aGrav[nX,23]
            Z06->Z06_MEDID6     :=    aGrav[nX,24]
            Z06->Z06_INSUM7     :=    aGrav[nX,25]
            Z06->Z06_MEDID7     :=    aGrav[nX,26]
            Z06->(Msunlock())
        NEXT nX  
        
        MsgAlert("Layouts salvos, saia da rotina e abra novamente para atualiza็ใo.")
    ENDIF
ENDIF

RestArea(aArea)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFATC01   บAutor  ณMicrosiga           บ Data ณ  07/19/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
