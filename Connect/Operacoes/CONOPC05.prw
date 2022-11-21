#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

//Cabecalho: CODIGO, NUMERO DE SERIE, DATA, CODIGO CONTRATO, ITEM CONTRATO, PERIODO, COD MAQUINA, CODIGO CLIENTE, CODIGO CLEINTE PAGAMENTO
//Itens: SEQUENCIA, SELECAO, PRODUTO, QUANTIDADE LEITURA, QUANTIDADE VALOR
User Function CONOPC05()

    Local nOpc      :=  0
    Private aCols   :=  {{'','','','',''}}
    Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6
    Private oSay7,oSay8,oGet1,oGet2,oGet4,oGrp3,oBtn1,oBtn2
    Private cPatr   
    Private cNumSer
    Private cData
    Private cContr
    Private cItem
    Private cCli 
    Private cCliPag

    IF Select("SM0") == 0
        RpcSetType(3)
        RPCSetEnv("01","0101")
    ENDIF

    oDlg1      := MSDialog():New( 057,187,748,993,"Insercao manual de Leituras",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,016,108,380,"Cadastro",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        
        oSay1      := TSay():New( 012,116,{||"Codigo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet1      := TGet():New( 012,168,{|u| If(PCount()>0,cPatr:=u,cPatr)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,,,,,,,,,)

        oSay2      := TSay():New( 012,116,{||"Numero de Serie"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet2      := TGet():New( 012,168,{|u| If(PCount()>0,cNumSer:=u,cNumSer)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,,,,,,,,,)
        
        oSay3      := TSay():New( 012,116,{||"Data"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet3      := TGet():New( 012,168,{|u| If(PCount()>0,cData:=u,cData)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,,,,,,,,,)
        
        oSay4      := TSay():New( 012,116,{||"Codigo do Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet4      := TGet():New( 012,168,{|u| If(PCount()>0,cContr:=u,cContr)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,,,,,,,,,)
        
        oSay5      := TSay():New( 012,116,{||"Item do Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet5      := TGet():New( 012,168,{|u| If(PCount()>0,cItem:=u,cItem)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,,,,,,,,,)
        
        oSay6      := TSay():New( 012,116,{||"Codigo do Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet6      := TGet():New( 012,168,{|u| If(PCount()>0,cCli:=u,cCli)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,,,,,,,,,)

        oSay7      := TSay():New( 012,116,{||"Codigo do CLiente Pagante"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet7      := TGet():New( 012,168,{|u| If(PCount()>0,cCliPag:=u,cCliPag)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,,,,,,,,,)

        
        oGrp3      := TGroup():New( 112,040,312,360,"Leituras",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{124,048,304,352},,, oGrp3 ) 
        oList1            := TCBrowse():New(124,048,305,180,, {'Sequencia','Selecao','Produto','Qunatidade Leitura','Valor da Leitura'},,oGrp3,,,,{|| },{|| editcol(oList1:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList1:SetArray(aCols)
        oList1:bLine := {||{aCols[oList1:nAt,01],; 
                            aCols[oList1:nAt,02],;
                            aCols[oList1:nAt,03],; 
                            aCols[oList1:nAt,04],;
                            aCols[oList1:nAt,05]}} 

        oBtn1      := TButton():New( 316,112,"Confirmar",oDlg1,{|| oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
        oBtn2      := TButton():New( 316,240,"Cancelar",oDlg1,{|| oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)

    if nOpc = 1
        MsgInfo("OK", "OK")
    endif

Return 
