#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "FWBROWSE.CH"
#Include "FWMVCDEF.CH"
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Totvs.Ch"

Static cChaveLog    As Character
Static nCN9         As Numeric
Static cObserv   := "" //Essa variável será usada no rodapé, para exibir mensagens de aviso
Static nTransQry := 1  //Define se o texto da query irá passar por transformação, exemplo, 0 - Não; 1 - Tudo maiúsculo (SQL Server e Oracle); 2 - Tudo minúsculo (Postgre)
Static __nHeight   := NIL
Static __nWidth    := NIL

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦                                                     
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ TINCWH01 ¦ Autor ¦ Alexandre Venancio     ¦ Data ¦ 20/02/24¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Rotina para cadastrar as tabelas de WebHook  		      ¦¦¦
¦¦¦          ¦ Incorporador                                        		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ SQUAD INCORPORADOR                                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function TINCWH01()

	Local aArea   := GetArea()
	Local oBrowse
    Local cTitulo := "Processos de WebHook (Incorporador) "
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("P96")
	oBrowse:SetDescription(cTitulo)
    oBrowse:SetFilterDefault("P96_SEQ == '001'")
    
	oBrowse:Activate()
	
	RestArea(aArea)
Return Nil


Static Function MenuDef()

	Local aRot      := {}
	
	//Adicionando opções
	ADD OPTION aRot TITLE 'Incluir Tabelas'	      ACTION 'U_xTincWH1(1)' 		                                            OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar Tabelas' 	  ACTION 'U_xTincWH1(2)' 	                                                OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Integraçao'            ACTION 'FWMsgRun(, {|| U_xTincWH2()},"","Processando os dados...")'       OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Relacionar Tabelas'    ACTION 'U_xTincWH4()' 	                                                OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Bloqueio Filiais'      ACTION 'FWMsgRun(, {|| U_TINCWHBF()},"","|*| Bloqueio de Filiais |*|")'   OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 4
	//ADD OPTION aRot TITLE 'Monitor'    	        ACTION 'U_TINTA011()' 	OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
	If fVldAcess()
        ADD OPTION aRot TITLE 'Consulta Dados'	      ACTION 'FWMsgRun(, {|| U_fTables() },"","Processando os dados...")'         OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	    ADD OPTION aRot TITLE 'Atu. Parametros' 	  ACTION 'U_TINCWHAP()' 	                                                OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    EndIf
	 
Return aRot

Static Function ModelDef()
	Local oModel 		:= Nil
	Local oStruP96 		:= FWFormStruct(1, 'P96')
    
	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('zMVCMd3M',,/*{||U_XXX()}*/)
	oModel:AddFields('P96MASTER',,oStruP96)
	oModel:SetPrimaryKey({'P96_FILIAL','P96_TABELA'})
	
	//Setando as descrições
	oModel:SetDescription("Processos de WebHook (Sistemas x Ofertas)")
	oModel:GetModel('P96MASTER'):SetDescription('Processos')
    
Return oModel


Static Function ViewDef()
	Local oView		:= Nil
	Local oModel		:= FWLoadModel('TINCWH01')
	Local oStruP96		:= FWFormStruct(2, 'P96')
    
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Adicionando os campos do cabeçalho e o grid dos filhos
	oView:AddField('VIEW_P96',oStruP96,'P96MASTER')
    //Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',50)
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_P96','CABEC')
	//Habilitando título
	oView:EnableTitleView('VIEW_P96','Processos')

    oView:CreateHorizontalBox('INFERIOR',50)
	oView:CreateFolder('ABAS','INFERIOR')
	
    oView:SetCloseOnOk({||.T.})

Return oView

/*/{Protheus.doc} xTincWH4
Relacionar tabelas 
@type user function
@author user
@since 22/05/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function xTincWH4

Local nOpcao := 0
Local nCont  := 0

Private cTabRsg   
Private oDlg1,oGrpR1,oBrw1,oGrpR2,oBrw2,oBtn1,oBtn2
Private oOk   	    := LoadBitmap(GetResources(),'br_verde')   
Private oNo   	    := LoadBitmap(GetResources(),'br_vermelho') 
Private oList1
Private oList2

Private aList1  := {}
Private aList2  := {}
Private aList1B := {}
Private aList2B := {}
Private aForma  := {'0=Selecione'}

Default cEmpAnt := '00'

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv(cEmpAnt,"00001000100")
EndIf

Private aTipInc := RetSX3Box(GetSX3Cache("P96_TIPINC", "X3_CBOX"),,,1)
Aeval(aTipInc,{|x| Aadd(aForma,x[1]) })
cTabRsg := aForma[1]

DbSelectArea("P96")

cQuery := "SELECT P96_TABELA,P96_RELACI,P96_TIPINC,COUNT(*)"
cQuery += " FROM "+RetSQLName("P96")
cQuery += " WHERE P96_FILIAL='"+xFilial("P96")+"'"
cQuery += " AND D_E_L_E_T_=' '"
cQuery += " GROUP BY P96_TABELA,P96_RELACI,P96_TIPINC"
cQuery += " ORDER BY P96_TABELA"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    If Ascan(aList1,{|x| x[2] == TRB->P96_TABELA}) == 0
        Aadd(aList1,{if(!EMPTY(TRB->P96_RELACI),.T.,.F.),;
                    TRB->P96_TABELA,;
                    FwSX2Util():GetX2Name( TRB->P96_TABELA , .T. ),;
                    TRB->P96_RELACI,;
                    TRB->P96_TIPINC})
    EndIF 

    If Ascan(aList2,{|x| x[2] == TRB->P96_TABELA}) == 0
        Aadd(aList2,{if(!EMPTY(TRB->P96_RELACI),.T.,.F.),;
                    TRB->P96_TABELA,;
                    FwSX2Util():GetX2Name( TRB->P96_TABELA , .T. ),;
                    TRB->P96_RELACI,;
                    TRB->P96_TIPINC})
    EndIF 

    Dbskip()
EndDo 


If len(aList1) > 0

    oDlg1      := MSDialog():New( 281,641,726,1373,"Relacionar tabelas",,,.F.,,,,,,.T.,,,.T. )

        oGrpR1     := TGroup():New( 004,004,196,172,"Cabeçalho",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //    oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,192,168},,, oGrpR1 ) 
        oList1:= 	TCBrowse():New(012,008,158,165,, {'','Tabela','Descrição','Itens/Acess.'},;
                                    {10,40,60,60},;
                                    oGrpR1,,,,{|| HelpRelac(oList1:nAt)},{|| /*relactab(oList1:nAt,oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oList1:SetArray(aList1)
        oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04]}}

        oGrpR2     := TGroup():New( 004,176,196,356,"Itens e acessorias",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //    oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,180,192,352},,, oGrpR2 ) 
        oList2:= 	TCBrowse():New(012,180,158,165,, {'','Tabela','Descrição','Itens/Acess.'},;
                                    {10,40,60,60},;
                                    oGrpR2,,,,{|| /*FHelp()*/},{|| relactab(oList1:nAt,oList2:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oList2:SetArray(aList2)
        oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),; 
                            aList2[oList2:nAt,02],;
                            aList2[oList2:nAt,03],;
                            aList2[oList2:nAt,04]}}

        oSay1      := TSay():New( 184,020,{||'Forma de carga'},oGrpR1,,/*oFontTit*/,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
        oCBox1     := TComboBox():New( 182,095,{|u| If(Pcount()>0,cTabRsg:=u,cTabRsg)},aForma,072,010,oGrpR1,,{|| trcSel()},,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
        oBtn1      := TButton():New( 200,104,"Confirmar",oDlg1,{||oDlg1:end(nOpcao:=1)},037,012,,,,.T.,,"",,,,.F. )
        oBtn2      := TButton():New( 200,204,"Cancelar",oDlg1,{||oDlg1:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)

    If nOpcao == 1
        For nCont := 1 to len(aList1)
            If aList1[nCont,01]
                cUpdate := "UPDATE "+RetSQLName("P96")+" SET P96_RELACI='"+alltrim(aList1[nCont,04])+"'"
                If !Empty(aList1[nCont,05])
                    cUpdate += ",P96_TIPINC='"+alltrim(aList1[nCont,05])+"'"
                EndIf 

                cUpdate += " WHERE P96_TABELA='"+aList1[nCont,02]+"' AND D_E_L_E_T_=' ' "

                If (nError := TCSQLExec(cUpdate)) <> 0
                    Help(,, "xTincWH4",, AllTrim(Str(nError)) + "-" + TCSQLError(), 1, 0)
                endif 
            Else 
                If !Empty(aList1[nCont,05])
                    cUpdate := "UPDATE "+RetSQLName("P96")+" SET P96_TIPINC='"+alltrim(aList1[nCont,05])+"'"

                    cUpdate += " WHERE P96_TABELA='"+aList1[nCont,02]+"' AND D_E_L_E_T_=' ' "

                    If (nError := TCSQLExec(cUpdate)) <> 0
                        Help(,, "xTincWH4",, AllTrim(Str(nError)) + "-" + TCSQLError(), 1, 0)
                    endif 
                EndIf 
            EndIf 

            

        Next nCont
    EndIf 
Else 
    MsgAlert("Não há tabelas cadastradas")
endIf 

Return

/*/{Protheus.doc} relactab
    Relacionar tabelas
    @type  Static Function
    @author user
    @since 22/05/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function relactab(nlinha1,nlinha2)
Local aRetRelations := {}

Local lRet := FWSX9Util():SearchX9Paths( aList1[nlinha1,2], aList2[nlinha2,2], @aRetRelations )

If aList1[nLinha1,02] == aList2[nlinha2,2]
    Return
EndIF 

If aList2[nlinha2,1]
    return 
Endif 

If lRet
    If aList2[nLinha2,01]
        If MsgYesNo("Remover relacionamento?")
            aList2[nLinha2,01] := .F.
            aList1[nLinha1,04] := STRTRAN(aList1[nLinha1,04],aList2[nLinha2,02],"")
        EndIf

    Else 
        aList1[nLinha1,04] := alltrim(aList1[nLinha1,04])+if(!empty(aList1[nLinha1,04]),"/","")+aList2[nlinha2,2] 
        aList1[nLinha1,01] := .T.
        aList2[nLinha2,01] := .T.
    EndIf 
endIf

oList1:SetArray(aList1)
oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04]}}

oList2:SetArray(aList2)
oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),; 
                            aList2[oList2:nAt,02],;
                            aList2[oList2:nAt,03],;
                            aList2[oList2:nAt,04]}}

oList1:refresh()
oList2:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} HelpRelac
    (long_description)
    @type  Static Function
    @author user
    @since 22/05/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function HelpRelac(nLinha)

Local aTabelas := separa(aList1[nLinha,04],"/")
Local nCont    := 1

For nCont := 1 to len(aList2)
    aList2[nCont,01] := .F.
Next nCont 

For nCont := 1 to len(aTabelas)
    nPos := Ascan(aList2,{|x| x[2] == alltrim(aTabelas[nCont])})
    If nPos > 0
        aList2[nPos,01] := .T.
    EndIf 
Next nCont 

cTabRsg := if(!empty(aList1[nLinha,05]),aList1[nLinha,05],'0')

oList2:SetArray(aList2)
oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),; 
                            aList2[oList2:nAt,02],;
                            aList2[oList2:nAt,03],;
                            aList2[oList2:nAt,04]}}

oCBox1:refresh()
oList1:refresh()
oList2:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} trcSel(cTabRsg)
    (long_description)
    @type  Static Function
    @author user
    @since 27/05/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function trcSel()

Local aBloq := {{'1','SA1'},{'2','SA2'},{'5','CN9'}}

Local nPos  := Ascan(aBloq,{|x| x[1] == cTabRsg})
Local nPos2 := Ascan(aList1,{|x| aList1[oList1:nAt,02] $ x[4]})
Local aAux  := {}
Local nCont := 0

If nPos > 0
    If aList1[oList1:nAt,02] <> aBloq[nPos,02]
        cTabRsg := aList1[oList1:nAt,05]
        oList1:refresh()
        oCBox1:refresh()
        oDlg1:refresh()
        MsgAlert("Opção inválida, somente a tabela "+aBloq[nPos,02]+" é permitida para esta opção!!!")
        Return 
    EndIf 
EndIf 

If nPos2 > 0
    cTabRsg := aList1[oList1:nAt,05]
    oList1:refresh()
    oCBox1:refresh()
    oDlg1:refresh()
    MsgAlert("Apenas para a tabela principal deve ser atribuido o tipo de Inclusão de dados!!!")
    
    Return 
EndIf 

If !Empty(aList1[oList1:nAt,04])
    aAux := separa(aList1[oList1:nAt,04],"/")

    For nCont := 1 to len(aAux)
        nPos3 := Ascan(aList1,{|x| x[2] == alltrim(aAux[nCont])})

        If nPos3 > 0
            aList1[nPos3,05] := cTabRsg
        EndIf 
    Next nCont 

EndIF 

aList1[oList1:nAt,05] :=  cTabRsg   

oList1:SetArray(aList1)
oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04]}}

oList1:refresh()
oDlg1:refresh()

Return
/*/{Protheus.doc} User Function nomeFunction
    Incluir tabelas a serem consideradas no processo de incorporação
    @type  Function
    @author user
    @since 20/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xTincWH1(nOpc)

Local aArea := GetArea()
Local aPergs    := {}
Local aRet      := {}
Local cTabela   := space(3)
Local aAuxiliar := {}
Local cQuery    := ''


Default nOpc    := 1

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("00","00001000100")
EndIf

If nOpc == 1

    AAdd( aPergs ,{1,"Tabela",Space(3),"@!","","SX2","", 50, .T. } )
            
    If ParamBox(aPergs ,"Informe a tabela",@aRet)
        cTabela := aRet[1]
    else 
        return
    EndIf 

    FWMsgRun(, {|| GeraOrig(cTabela,aAuxiliar)},"","Processando os dados...")
Else 
    DbSelectArea("P96")
    cQuery := "SELECT P96_TABELA,P96_CAMPO,P96_DESCRI,P96_TIPO,P96_TAMANH,P96_DECIMA,"
    cQuery += " P96_DICA,P96_PESQUI,P96_DEPARA,P96_TITULO,P96_RELACI,P96_TEMAOX,P96_RELAOX"
    cQuery += " FROM "+RetSQLName("P96")
    cQuery += " WHERE P96_FILIAL='"+xFilial("P96")+"'"
    cQuery += " AND P96_TABELA='"+P96->P96_TABELA+"'"
    cQuery += " AND D_E_L_E_T_=' '"
    cQuery += " ORDER BY P96_SEQ"

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")

    While !EOF()
        //P96_TABELA,P96_CAMPO,P96_DESCRI,P96_TIPO,P96_TAMANH,P96_DECIMA,P96_DICA,P96_PESQUI,P96_DEPARA
        cTabela := TRB->P96_TABELA
        Aadd(aAuxiliar,{.T.,;
                        TRB->P96_CAMPO,;
                        TRB->P96_TITULO,;
                        TRB->P96_DESCRI,;
                        TRB->P96_TAMANH,;
                        TRB->P96_DECIMA,;
                        alltrim(TRB->P96_DICA),;
                        TRB->P96_PESQUI,;
                        alltrim(TRB->P96_DEPARA),;
                        len(aAuxiliar)+1,;
                        TRB->P96_TABELA,;
                        TRB->P96_TIPO,;
                        TRB->P96_RELACI,;
                        TRB->P96_TEMAOX,;
                        TRB->P96_RELAOX})
        Dbskip()
    EndDo 

    FWMsgRun(, {|| GeraOrig(cTabela,aAuxiliar)},"","Processando os dados...")
EndIf 

RestArea(aArea)
    
Return

/*/{Protheus.doc} GeraOrig
    Gerar tabelas origens para incorporação
    @type  Static Function
    @author user
    @since 20/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraOrig(cTabela,aAuxiliar)

Local nOpca         := 0
Local nCont 
Local nX 
Private oDlg1,oSay1,oGrp1,oBtn1,oBtn2
Private oList1  
Private aList1      := {}
Private aList1B     := {}
Private aList1T     := {}
Private oOk   	    := LoadBitmap(GetResources(),'br_verde')   
Private oNo   	    := LoadBitmap(GetResources(),'br_vermelho') 
Private aHoBrw1     := {}
Private aHeader     := {'','P96_CAMPO','P96_TITULO','P96_DESCRI','P96_TAMANH','P96_DECIMA','P96_DICA','P96_PESQUI','P96_DEPARA','','P96_TABELA','P96_TIPO','','P96_TEMAOX','P96_RELAOX'}
Default cTabela     := 'SC6'
Default aAuxiliar   := {}
Private oFontTit    := TFont():New('Verdana', , -13, , .T.)

//P96_TABELA,P96_CAMPO,P96_DESCRI,P96_TIPO,P96_TAMANH,P96_DECIMA,P96_DICA,P96_PESQUI,P96_DEPARA

aList1T := aClone(aAuxiliar)

lertab(cTabela)

cTabela := Alltrim(cTabela)+"  -  " +FWX2Nome ( cTabela )

If len(aHoBrw1) > 0
    For nCont := 1 to len(aHoBrw1)
        Aadd(aList1B,{  If("_FILIAL" $ aHoBrw1[nCont,02],.T.,aHoBrw1[nCont,09]),;
                        aHoBrw1[nCont,02],;
                        aHoBrw1[nCont,03],;
                        aHoBrw1[nCont,04],;
                        aHoBrw1[nCont,06],;
                        aHoBrw1[nCont,07],;
                        '',;
                        aHoBrw1[nCont,08],;
                        If("_FILIAL" $ aHoBrw1[nCont,02],'Definição CST',''),;
                        aHoBrw1[nCont,10],;
                        aHoBrw1[nCont,01],;
                        aHoBrw1[nCont,05],;
                        '',;
                        '',;
                        ''})
    Next nCont 

Else 
    Aadd(aList1B,{.f.,'','','','','','','','','','','','','',''})
ENdIf 

If len(aAuxiliar) > 0
    aList1 := aClone(aAuxiliar)
Else 
    aList1 := aclone(aList1B)
EndIf 

oDlg1      := MSDialog():New( 092,232,917,1718,"Cadastro de tabelas Modelos",,,.F.,,,,,,.T.,,,.T. )
    
    oSay1      := TSay():New( 004,318,{||cTabela},oDlg1,,oFontTit,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
    
    oGrp1      := TGroup():New( 020,012,360,728,"Campos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{028,016,356,624},,, oGrp1 ) 
        oList1:= 	TCBrowse():New(028,016,708,325,, {'','Campo','Titulo','Descricao','Tamanho','Decimais','Dica','Pesquisa','De/Para','Tem Rel. AOX','Relação AOX'},;
                                {10,40,60,90,30,20,90,50,50,40},;
                                oGrp1,,,,{|| /*FHelp()*/},{|| editcol(oList1:nAt,0)},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oList1:SetArray(aList1)
        oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04],; 
                            aList1[oList1:nAt,05],;
                            aList1[oList1:nAt,06],;
                            aList1[oList1:nAt,07],; 
                            aList1[oList1:nAt,08],;
                            aList1[oList1:nAt,09],;
                            If(len(aList1[oList1:nAt])>13,If(aList1[oList1:nAt,14]=='1','Sim','Nao'),''),;
                            If(len(aList1[oList1:nAt])>14,aList1[oList1:nAt,15],'')}}
    
    oBtn1      := TButton():New( 376,272,"Salvar",oDlg1,{||oDlg1:end(nOpca:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 376,406,"Cancelar",oDlg1,{||oDlg1:end(nOpca:=0)},037,012,,,,.T.,,"",,,,.F. )

    MENU oMenu1 POPUP 
     
    MENUITEM "Manter somente campos marcados" ACTION ( SoCampMarc() )
    MENUITEM "Exibir todos os campos da tabela" ACTION ( TodosCmpTab() )
    MENUITEM "Marcar/Desmarcar todos" ACTION ( editcol({},1))
    MENUITEM "Campo definido pelo CST" ACTION ( editcol(oList1:nAt,0))
    MENUITEM "Ordenar" ACTION ( ordenar())
    MENUITEM "Procurar campo" ACTION ( localiz() )
    ENDMENU                                                                           

    oList1:bRClicked := { |oObject,nX,nY| oMenu1:Activate( nX, (nY-10), oObject ) }


oDlg1:Activate(,,,.T.)

If nOpca == 1
    //P96_TABELA,P96_CAMPO,P96_DESCRI,P96_TIPO,P96_TAMANH,P96_DECIMA,P96_DICA,P96_PESQUI,P96_DEPARA
    nSeq := 1
    
    For nCont := 1 to len(aList1)
    
        If aList1[nCont,01]
            DbSelectArea("P96")
            If !Dbseek(xFilial("P96")+aList1[nCont,11]+aList1[nCont,02])
                Reclock("P96",.T.)
            else
                Reclock("P96",.F.)
            EndIf 

            P96->P96_SEQ    := Strzero(nSeq,3)
            P96->P96_FILIAL := xFilial("P96")

            nSeq++

            For nX := 1 to len(aHeader)
                If !Empty(aHeader[nX])
                    &("P96->"+aHeader[nX]) := aList1[nCont,nX]
                EndIf 
            Next nX 

            P96->(Msunlock())

        EndIf 
    Next nCont 
endIf 

Return

/*/{Protheus.doc} lertab
    Ler campos da tabela a ser incorporada
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
Static Function lertab(cTabela)

Local aAuxX3 := {}
Local nCont  := 0
Local aAux   := {}
Local cCombo := ''

aAuxX3 := FWSX3Util():GetAllFields( cTabela , .F. )

For nCont := 1 to len(aAuxX3)

    aAux := FWSX3Util():GetFieldStruct( aAuxX3[nCont] )
    
    lRet := X3Obrigat(aAux[1])
    cCombo := GetSX3Cache(aAux[1], "X3_F3") 
    cTitulo := FWX3Titulo( aAux[1] )
    Aadd(aHoBrw1,{  cTabela,;
                    aAux[1],;
                    cTitulo,;
                    Alltrim(FWSX3Util():GetDescription( aAuxX3[nCont]  ) ),;
                    aAux[2],;
                    aAux[3],;
                    aAux[4],;
                    Alltrim(cCombo),;
                    lRet,;
                    len(aHoBrw1)+1} )
Next nCont


Return

/*/{Protheus.doc} SoCampMarc
    Marca e desmarca campos a serem considerados na integração da tabela
    @type  Static Function
    @author user
    @since 20/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function SoCampMarc()

Local nCont 
Local aAux := aClone(aList1)

aList1 := {}

For nCont := 1 to len(aAux)
    If aAux[nCont,01]
        Aadd(aList1,aAux[nCont])
    EndIf 
Next nCont

If len(aList1) < 1
    aList1 := aclone(aList1B)
EndIf 

oList1:SetArray(aList1)
oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),; 
                    aList1[oList1:nAt,02],;
                    aList1[oList1:nAt,03],;
                    aList1[oList1:nAt,04],; 
                    aList1[oList1:nAt,05],;
                    aList1[oList1:nAt,06],;
                    aList1[oList1:nAt,07],; 
                    aList1[oList1:nAt,08],;
                    aList1[oList1:nAt,09],;
                    If(len(aList1[oList1:nAt])>13,If(aList1[oList1:nAt,14]=='1','Sim','Nao'),''),;
                    If(len(aList1[oList1:nAt])>14,aList1[oList1:nAt,15],'')}}

oList1:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} TodosCmpTab
    Define todos os campos da tabela como passiveis de importação
    @type  Static Function
    @author user
    @since 20/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/ 
Static Function TodosCmpTab()

Local aArea := GetArea()
Local aAux  := aClone(aList1)
Local nCont 

aList1 := {}

aList1 := aClone(aList1B)

For nCont := 1 to len(aList1)
    If Ascan(aAux,{|x| alltrim(x[2]) == alltrim(aList1[nCont,02])}) > 0
        aList1[nCont,01] := .T.
    EndIf 
Next nCont 

oList1:SetArray(aList1)
oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),; 
                    aList1[oList1:nAt,02],;
                    aList1[oList1:nAt,03],;
                    aList1[oList1:nAt,04],; 
                    aList1[oList1:nAt,05],;
                    aList1[oList1:nAt,06],;
                    aList1[oList1:nAt,07],; 
                    aList1[oList1:nAt,08],;
                    aList1[oList1:nAt,09],;
                    If(len(aList1[oList1:nAt])>13,If(aList1[oList1:nAt,14]=='1','Sim','Nao'),''),;
                    If(len(aList1[oList1:nAt])>14,aList1[oList1:nAt,15],'')}}

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return 

/*/{Protheus.doc} editcol
    Edita a coluna do grid
    @type  Static Function
    @author user
    @since 20/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editcol(nLinha,nOpcao)

Local aArea     := GetArea()
Local nColPos   := oList1:nColpos 
Local nCont 

If nOpcao == 0

    If len(aList1T) > 0
        nPosBkp := Ascan(aList1T,{|x| alltrim(x[2]) == alltrim(aList1[nLinha,02])})
    Else 
        nPosBkp := Ascan(aList1B,{|x| alltrim(x[2]) == alltrim(aList1[nLinha,02])})
    EnDIf 

    If nColPos == 1
        If aList1[nLinha,nColPos]
            aList1[nLinha,nColPos] := .F.
        Else 
            aList1[nLinha,nColPos] := .T.
        EndIf 

        If nPosBkp > 0
            aList1B[nPosBkp,nColPos] := aList1[nLinha,nColPos]
        EndIf 
    
    ElseIf nColPos == 7

        aList1[nLinha,nColPos] := avkey(aList1[nLinha,nColPos],"P96_DICA")

        lEditCell(aList1, oList1, '@!', oList1:nColPos) 

        If nPosBkp > 0
            aList1B[nPosBkp,nColPos] := aList1[nLinha,nColPos]
        EndIf 
    
    ElseIf nColPos == 9
        If empty(aList1[nLinha,nColPos])
            aList1[nLinha,nColPos] := 'Definição CST'
        Else 
            aList1[nLinha,nColPos] := ''
        EndIf 

        If nPosBkp > 0
            aList1B[nPosBkp,nColPos] := aList1[nLinha,nColPos]
        EndIf 

    ElseIf nColPos == 10
        If Empty(aList1[nLinha,14])
            aList1[nLinha,14] := '1'
        Else 
            aList1[nLinha,14] := ''
            aList1[nLinha,15] := space(20)
        EndIf 
    ElseIf nColPos == 11
        cBkpCpo := aList1[nLinha,nColPos]

        aList1[nLinha,nColPos] := aList1[nLinha,15]

        lEditCell(aList1, oList1, '@!', oList1:nColPos) 

        aList1[nLinha,15] := aList1[nLinha,nColPos]
        aList1[nLinha,nColPos] := cBkpCpo
        
        If !Empty(aList1[nLinha,15])
            aList1[nLinha,14] := "1"
        EndIf 

        If nPosBkp > 0
            aList1B[nPosBkp,nColPos] := aList1[nLinha,nColPos]
        EndIf 
    
    EndIf 
Else 
    For nCont := 1 to len(aList1)
        nPosBkp := Ascan(aList1B,{|x| alltrim(x[2]) == alltrim(aList1[nCont,02])})
        
        If aList1[nCont,1]
            aList1[nCont,1] := .F.
        Else 
            aList1[nCont,1] := .T.
        EndIf

        If nPosBkp > 0
            aList1B[nPosBkp,1] := aList1[nCont,1]
        EndIf

    Next nCont
EndIf 

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return


/*/{Protheus.doc} ordenar
    Ordenacao do grid de campos
    @type  Static Function
    @author user
    @since 13/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ordenar()

Local aPergs    :=  {}
Local aRet      :=  {}
Local aOrdem    :=  {'1=Ordem Alfabetica','2=Ordem configurador'}
Local nOpc      :=  0

aAdd( aPergs ,{2,"Ordenar por?","1" , aOrdem , 100,'.T.',.F.})
	
If ParamBox(aPergs ,"Ordem",@aRet)
    nOpc := aRet[1]
    If val(nOpc) == 1
        Asort(aList1,,,{|x,y| x[2] < y[2]})
    Else
        Asort(aList1,,,{|x,y| x[10] < y[10]})
    EndIf

    oList1:refresh()
    oDlg1:refresh()
EndIf

Return

/*/{Protheus.doc} localiz
    Função de localização de campos nas tabelas selecionadas
    @type  Static Function
    @author user
    @since 06/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function localiz()

Local aPergs    := {}
Local aRet      := {}
Local cOpc      := space(10)
Local nLoc      := 0

AAdd( aPergs ,{1,"Campo",Space(9),"","","","", 50, .F. } )
		
If ParamBox(aPergs ,"Procura",@aRet)
    cOpc := aRet[1]
    nLoc := Ascan(aList1,{|x| alltrim(upper(cOpc)) $ alltrim(x[2]) })

    If nLoc > 0
        oList1:nAt := nLoc
    Else 
        MsgAlert("Campo não encontrado")
    EndIf 

    oList1:refresh()
    oDlg1:refresh()
EndIf

Return

/*/{Protheus.doc} xTincWH2
    Rotina principal para execução das incorporações
    busca os registros na P98 e processa para suas tabelas
    @type  Function
    @author user
    @since 21/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xTincWH2(nOpc)

Local nX,nCont,nY
Local cLinkDoc      := "https://tdn.totvs.com.br/display/tdi/IntegraMais"
Local aSizeWiz      := {}
Local nWidthWiz     := 1800
Local nHeightWiz    := 855
Local cFont         := 'Tahoma'
Local oFontGrp      := TFont():New(cFont, , -15, , .T.)
Local oFontA        := TFont():New(cFont, , -12, , .T.)
Local oFontB        := TFont():New(cFont, , -12, , .F.)

Private oDlg1,oGrp1,oGrp2,oGrp3,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay8,oSay9,oSay10,oGet1,oGet2,oGet3,oBtn1
Private oMenu2,oTM2Item1,oTM2Item2,oTM2Item3,oTM2Item4,oTM2Item5,oTM2Item6,oTM2Item7
Private oMenu3,oTM3Item1,oTM3Item2,oTM3Item3,oTM3Item4,oTM3Item6,oTM3Item7,oTM3Item8,oTM3Item9
Private oSubMenu1,oSubMenu2,oSubMenu3,oSubMenu4,oSubMenu5,oSubMenu6,oSubMenu7,oSubMenu8
Private oList1 
Private aList1      := {}
Private oList2 
Private aList2      := {}
Private aList2B     := {}
Private oList3 
Private aList3      := {}
Private aList3B     := {}
Private aListB3     := {}
Private aList4      := {}
Private aList5      := {}
Private oOk   	    := LoadBitmap(GetResources(),'br_verde')   
Private oNo   	    := LoadBitmap(GetResources(),'br_vermelho') 
Private oTv   	    := LoadBitmap(GetResources(),'br_amarelo')
Private cFilOrig    := space(11)
Private cFilDest    := space(11)
Private cCnpjOrig   := space(14)
Private cTabRsg     := ''
Private cNomeFil    := ''
Private lCarga      := .F.
Private aDadosDet   := {}
Private cCodigo     := ''
Private lIncluir    := .F.
Private lAlterar    := .F.
Private lAjsDePa    := .F.
Private aX3Cache    := {}
Private aCNs        := {}
Private cToken      := ''
Private cTimeProc   := ''
Private cTimFProc   := ''
Private cQtdProc    := ''
Private nSucess     := 0
Private nAlert      := 0
Private nErr        := 0
Private lLibBotao   := .T. 

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("00","00001000100")
EndIf

Private cParamd     := SuperGetMv('TI_TINCH1',.F.,'CLIENT/CODCLI/CLIFOR/FORNEC/CLIENTE/FORNECE/TITPAI') 

Private cEmailInc	:= UsrRetMail(RetCodUsr())
Private cUsrLog     := cUserName
Private aTabs       := RelTab() 
Private cFilPesq    := space(2048)
Private aX2Unq      :=  {}
Private aAxX3       :=  {}
Private aEstrX3     :=  {}
Private aSepStr     :=  {}
Private cCodPN2     :=  ""
Private lInc        := .F.
Private lAlt        := .F.
Private aTabTmp     := {}
Private oTempTable
Private lCheck1     := .F.


For nCont := 1 to len(aTabs)
    For nX := 1 to len(aTabs[nCont])
        
        If "/" $ aTabs[nCont,nX]
            aSepStr := separa(aTabs[nCont,nX],"/")
            For nY := 1 to len(aSepStr)
                cUnKey      := FWX2Unico( aSepStr[nY] )
                Aadd(aX2Unq,{aSepStr[nY],cUnKey}) 

                aAxX3     := FWSX3Util():GetListFieldsStruct( aSepStr[nY] , .F. )
                
                aEval(aAxX3,{|x| aadd(x,.T.)})

                Aadd(aEstrX3,aAxX3)
                Aadd(aEstrX3[len(aEstrX3)],aSepStr[nY])

                cQuery := " SELECT X3_CAMPO,X3_F3 FROM "+RetSQLName("SX3")
                cQuery += " WHERE D_E_L_E_T_=' '   
                cQuery += " AND X3_ARQUIVO='"+aSepStr[nY]+"' AND X3_F3<>' ' 

                If Select('TRB') > 0
                    dbSelectArea('TRB')
                    dbCloseArea()
                EndIf

                DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

                DbSelectArea("TRB")

                While !EOF()
                    Aadd(aX3Cache,{&("TRB->X3_CAMPO"),&("TRB->X3_F3")})
                    Dbskip()
                EndDo 
            Next nY
        else 
            If !Empty(aTabs[nCont,nX])
                cUnKey      := FWX2Unico( aTabs[nCont,nX] )
                Aadd(aX2Unq,{aTabs[nCont,nX],cUnKey})

                aAxX3     := FWSX3Util():GetListFieldsStruct( aTabs[nCont,nX] , .F. )
                
                aEval(aAxX3,{|x| aadd(x,.T.)})

                Aadd(aEstrX3,aAxX3)
                Aadd(aEstrX3[len(aEstrX3)],aTabs[nCont,nX])

                
                cQuery := " SELECT X3_CAMPO,X3_F3 FROM "+RetSQLName("SX3")
                cQuery += " WHERE D_E_L_E_T_=' '   
                cQuery += " AND X3_ARQUIVO='"+aTabs[nCont,nX]+"' AND X3_F3<>' ' 

                If Select('TRB') > 0
                    dbSelectArea('TRB')
                    dbCloseArea()
                EndIf

                DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

                DbSelectArea("TRB")

                While !EOF()
                    Aadd(aX3Cache,{&("TRB->X3_CAMPO"),&("TRB->X3_F3")})
                    Dbskip()
                EndDo 
            EndIf 
        EndIF 
    Next nX 
Next nCont 

BuscaDePara()

// Tela 
aSizeWiz    := MsAdvSize()
If aSizeWiz[5] > 0
    nWidthWiz   := aSizeWiz[5] 
    nHeightWiz  := aSizeWiz[6] 
EndIf
nMargem     := (nHeightWiz/2)*0.0179
nSpace      := (nHeightWiz/2)*0.009
nNum1       := nMargem+nSpace

oDlg1      := MSDialog():New( /*092*/000,/*232*/000,nHeightWiz, nWidthWiz/*855,1800*/,"Cadastro",,,.F.,,,,,,.T.,,,.T. )
    
// Grupo 1
    nRefWGp1    := (nWidthWiz/2)
    nRefHGp1    := (nHeightWiz/2)
    nWGp1       := nRefWGp1*0.6
    nHGp1       := nRefHGp1*0.17
    nLine1      := nRefHGp1*0.03 
    nLine2      := nRefHGp1*0.06 
    nLine3      := nRefHGp1*0.09 
    nLine4      := nRefHGp1*0.12 
    nCol1       := nRefHGp1*0.24 
    nCol2       := nRefHGp1*0.37 
    nCol3       := nRefHGp1*0.063 
    nCol4       := nRefHGp1*0.18  
    nCol5       := nRefHGp1*0.38  
    nCol6       := nRefHGp1*0.50 
    If nRefWGp1*0.3 > 210
        nCol7       := nCol6*1.40  
    Else
        nCol7       := nCol6*1.30  
    EndIf 
    nTamGp11    := nRefWGp1*0.055 
    nTamGp12    := nRefWGp1*0.084 
    nTamGp13    := nRefWGp1*0.19  
    nTamGp14    := (nRefWGp1*0.3612)/5 
    nBCol1Gp1   := nWGp1+nSpace
    nBCol2Gp1   := nBCol1Gp1+nTamGp14+nSpace
    nBCol3Gp1   := nBCol2Gp1+nTamGp14+nSpace
    nBCol4Gp1   := nBCol3Gp1+nTamGp14+nSpace
    nBCol5Gp1   := nBCol4Gp1+nTamGp14+nSpace
    nAltBts     := nLine1
    nBLin1Gp1   := nMargem+nAltBts+nSpace     
    nBLin2Gp1   := nBLin1Gp1+nAltBts+nSpace   
    nBLin3Gp1   := nBLin2Gp1+nAltBts+nSpace  
    
    oGrp1       := TGroup():New( nSpace,nMargem,nHGp1,nWGp1,"Dados Filiais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oGrp1:oFont := oFontGrp
        oSay1      := TSay():New( nLine2,nCol3,{||"Código"},oGrp1,,oFontA,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,nTamGp11,nMargem)
        oSay2      := TSay():New( nLine2,nCol4,{||cCodigo},oGrp1,,oFontB,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,nTamGp11,nMargem)
        
        oSay3      := TSay():New( nLine3,nCol3,{||"Filial Origem"},oGrp1,,oFontA,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,nTamGp11,nMargem)
        oGet1      := TGet():New( nLine3,nCol4,{|u| If(Pcount()>0,cFilOrig:=u,cFilOrig)},oGrp1,nTamGp12,nMargem,'',{|| liberok(1)},,,oFontB,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        oGet1:disable()

        oSay6      := TSay():New( nLine4,nCol3,{||"CNPJ Origem"},oGrp1,,oFontA,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,nTamGp11,nMargem)
        oGet3      := TGet():New( nLine4,nCol4,{|u| If(Pcount()>0,cCnpjOrig:=u,cCnpjOrig)},oGrp1,nTamGp12,nMargem,'',{|| liberok(1)},,,oFontB,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        oGet3:disable()

        oSay4      := TSay():New( nLine3,nCol5,{||"Filial Totvs"},oGrp1,,oFontA,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,nTamGp11,nMargem)
        oGet2      := TGet():New( nLine3,nCol6,{|u| If(Pcount()>0,cFilDest:=u,cFilDest)},oGrp1,nTamGp12,nMargem,'',{|| liberok(2)},,,oFontB,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SM0","",,)
        oGet2:disable()

        oSay5      := TSay():New( nLine3,nCol7,{||cNomeFil},oGrp1,,oFontA,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,nTamGp13,nMargem)
        
        oSay7      := TSay():New( nLine4,nCol5,{||"Cod Emp Integrada "},oGrp1,,oFontA,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,nTamGp11,nMargem)
        oSay8      := TSay():New( nLine4,nCol6,{||cCodPN2},oGrp1,,oFontB,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,nTamGp11,nMargem)

        oSay9      := TSay():New( nLine2,nCol5,{||"Tipo Inclusão "},oGrp1,,oFontA,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,nTamGp11,nMargem)
        oSay10     := TSay():New( nLine2,nCol6,{||aList1[len(aList1),05]},oGrp1,,oFontB,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,nTamGp11,nMargem)

        oCBox1     := TCheckBox():New( nLine2,nCol7,"Habilita WEB",{|u|If(Pcount()>0,lCheck1:=u,lCheck1)},oGrp1,048,008,,{|| /*trocaChk(1)*/},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
        
    oMenu := TMenu():New(0,0,0,0,.T.)
    // Adiciona itens no Menu
    oTMenuIte1 := TMenuItem():New(oDlg1,"Incluir",,,,{|| InclNew()},,,,,,,,,.T.)
    oTMenuIte2 := TMenuItem():New(oDlg1,"Alterar",,,,{|| AltCnfg()},,,,,,,,,.T.)   
    oTMenuIte3 := TMenuItem():New(oDlg1,"Salvar Config.",,,,{|| savecnfg()},,,,,,,,,.T.) 
    oTMenuIte4 := TMenuItem():New(oDlg1,"Cfg. Parametros",,,,{|| },,,,,,,,,.T.) 
        oMenu:Add(oTMenuIte4)        
        oSubMenu6 := TMenuItem():new(oTMenuIte4, "Cadastro de Parametros", , , , {|| FWMsgRun(,{|| U_TINCCFG(.T.) },"","Processando os dados...")}, , , , , , , , , .T.) 
        oSubMenu7 := TMenuItem():new(oTMenuIte4, "Listagem de Parametros", , , , {|| FWMsgRun(,{|| U_LstParam() },"","Processando os dados...")}, , , , , , , , , .T.) 
        oSubMenu8 := TMenuItem():new(oTMenuIte4, "CSV dos Parametros", , , , {|| FWMsgRun(,{|| ParamCSV() },"","Processando os dados...")}, , , , , , , , , .T.) 
        oTMenuIte4:add(oSubMenu6)
        oTMenuIte4:add(oSubMenu7)
        oTMenuIte4:add(oSubMenu8)

    oTMenuIte5 := TMenuItem():New(oDlg1,"Excluir Dados",,,,{|| exclP98()},,,,,,,,,.T.) 

    oMenu:Add(oTMenuIte1)
    oMenu:Add(oTMenuIte2)
    oMenu:Add(oTMenuIte3)
    oMenu:Add(oTMenuIte4)
    oMenu:Add(oTMenuIte5)

    // Cria botão que sera usado no Menu
    oTButton1 := TButton():New( nMargem, nBCol1Gp1, "Selecione",oDlg1,{||},nTamGp14,nAltBts,,oFontB,.F.,.T.,.F.,,.F.,,,.F. )
    // Define botão no Menu
    oTButton1:SetPopupMenu(oMenu)
    oTMenuIte5:disable()

    oBtn10     := TButton():New( nMargem,nBCol2Gp1,"Consist.Dados",oDlg1,{|| FWMsgRun(, {|| constdados()},"","Processando os dados...") },nTamGp14,nAltBts,,oFontB,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( nMargem,nBCol3Gp1,"Config. De/Para",oDlg1,{|| ConfigDePara() },nTamGp14,nAltBts,,oFontB,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( nMargem,nBCol4Gp1,"Atualizar De/Para",oDlg1,{|| FWMsgRun(, {|| AjustaDP()},"","Processando os dados...") },nTamGp14,nAltBts,,oFontB,,.T.,,"",,,,.F. )
    oBtn4      := TButton():New( nMargem,nBCol5Gp1,"Verificar Dados",oDlg1,{|| FWMsgRun(, {|| DetalhaDados(aList1[oList1:nAt,01])},"","Processando os dados...") } ,nTamGp14,nAltBts,,oFontB,,.T.,,"",,,,.F. )

    // Combo Outras Ações
    oMenu2 := TMenu():New(0,0,0,0,.T.)
    // Adiciona itens no Menu
    oTM2Item1 := TMenuItem():New(oDlg1,"Atualiza Vendedor",,,,{|| FWMsgRun(, {|| U_TINCWHVD(cToken,cUsrLog,cFilDest,cNomeFil) },"","Processando os dados...")},,,,,,,,,.T.)
    oTM2Item2 := TMenuItem():New(oDlg1,"Conferir Contratos",,,,{|| FWMsgRun(, {|| U_TINCGEN01(cFilDest) },"","Processando os dados...")},,,,,,,,,.T.)   
    oTM2Item3 := TMenuItem():New(oDlg1,"Criar FK's",,,,{|| FWMsgRun(, {|| fCriaFKs(cEmpAnt,cFilDest,.T.) },"","Processando os dados...")},,,,,,,,,.T.) 
    oTM2Item4 := TMenuItem():New(oDlg1,"Viagens",,,,{|| FWMsgRun(, {|| U_ViagemRD0() },"","Processando os dados...")},,,,,,,,,.T.)
    // oTM2Item5 := TMenuItem():New(oDlg1,"Consulta Dados",,,,{|| FWMsgRun(, {|| fTables() },"","Processando os dados...")},,,,,,,,,.T.) 
    oTM2Item6 := TMenuItem():New(oDlg1,"Rollback de Migração",,,,{|| FWMsgRun(, {|| _RBMigra() },"","Processando os dados...")},,,,,,,,,.T.) 
    oTM2Item7 := TMenuItem():New(oDlg1,"Encerra Migração",,,,{|| FWMsgRun(, {|| fCloseMig() },"","Processando os dados...")},,,,,,,,,.T.) 

    oMenu2:Add(oTM2Item1)
    oMenu2:Add(oTM2Item2)
    oMenu2:Add(oTM2Item3)
    oMenu2:Add(oTM2Item4)
    //oMenu2:Add(oTM2Item5)
    oMenu2:Add(oTM2Item6)
    oMenu2:Add(oTM2Item7)

    // Cria botão que sera usado no Menu
    oTButton2 := TButton():New( nBLin1Gp1, nBCol1Gp1, "Outras Acoes",oDlg1,{||},nTamGp14,nAltBts,,oFontB,.F.,.T.,.F.,,.F.,,,.F. )
    // Define botão no Menu
    oTButton2:SetPopupMenu(oMenu2)
    oTM2Item4:disable()
    //oTM2Item5:disable()
    oTM2Item6:disable()
    oTM2Item7:disable()

    // Combo Utilidades
    oMenu3 := TMenu():New(0,0,0,0,.T.)
    // Adiciona itens no Menu
    oTM3Item1   := TMenuItem():New(oDlg1,"Planilhas"        ,,,,{|| FWMsgRun(, {|| GeraPlan()},"","Processando os dados...") },,,,,,,,,.T.)
    oTM3Item2   := TMenuItem():New(oDlg1,"Documentação"     ,,,,{|| ShellExecute("Open", cLinkDoc, "", "", 1)},,,,,,,,,.T.)   
    oTM3Item3   := TMenuItem():New(oDlg1,"Copia CE1"        ,,,,{|| FWMsgRun(, {|| U_CriarDTC("CE1") },"","Aguarde"+CRLF+"Copiando CE1...")},,,,,,,,,.T.) 
    oTM3Item3a  := TMenuItem():New(oDlg1,"Duplica CE1"      ,,,,{|| FWMsgRun({|| U_DuplDTC("CE1") },"","Aguarde"+CRLF+"Duplicando a CE1...")},,,,,,,,,.T.) 
    oTM3Item4   := TMenuItem():New(oDlg1,"Copia Produtos"   ,,,,{|| FWMsgRun(, {|| U_DTCProd("SB1") },"","Aguarde"+CRLF+"Copiando SB1, SB5, SBM, ZQK...")},,,,,,,,,.T.)
    oTM3Item6   := TMenuItem():New(oDlg1,"Copia SIGAMAT"    ,,,,{|| FWMsgRun(, {|| U_DTCSM0("SM0") },"","Aguarde"+CRLF+"Copiando SYS_COMPANY...")},,,,,,,,,.T.)
    oTM3Item7   := TMenuItem():New(oDlg1,"Apaga PN1"        ,,,,{|| FWMsgRun(, {|| U_ExclPN1("PN1") },"","Processando os dados...")},,,,,,,,,.T.)    
    oTM3Item8   := TMenuItem():New(oDlg1,"Canc. Contratos"  ,,,,{|| FWMsgRun(, {|| U_TIINCP02("PH3") },"","Processando os dados...")},,,,,,,,,.T.)    
    oTM3Item9   := TMenuItem():New(oDlg1,"RECEIV "          ,,,,{|| },,,,,,,,,.T.)
        oMenu3:Add(oTM3Item9)        
        oSubMenu1 := TMenuItem():new(oTM3Item9, "Reenvio de Contratos", , , , {|| FWMsgRun(, {|| U_TIINCP02("RCV1")},"","Processando os dados...")}, , , , , , , , , .T.) 
        oSubMenu2 := TMenuItem():new(oTM3Item9, "Reenvio de Títulos", , , , {|| FWMsgRun(, {|| U_TIINCP02("RCV2")},"","Processando os dados...")}, , , , , , , , , .T.) 
        oSubMenu3 := TMenuItem():new(oTM3Item9, "Reenvio de Baixas", , , , {|| FWMsgRun(, {|| U_TIINCP02("RCV3")},"","Processando os dados...")}, , , , , , , , , .T.) 
        oSubMenu4 := TMenuItem():new(oTM3Item9, "Liga Parâmetros", , , , {|| FWMsgRun(, {|| U_TIINCP02("RCV4")},"","Carregando...")}, , , , , , , , , .T.) 
        oSubMenu5 := TMenuItem():new(oTM3Item9, "Desliga Parâmetros", , , , {|| FWMsgRun(, {|| U_TIINCP02("RCV5")},"","Carregando...")}, , , , , , , , , .T.) 
        oTM3Item9:add(oSubMenu1)
        oTM3Item9:add(oSubMenu2)
        oTM3Item9:add(oSubMenu3)
        oTM3Item9:add(oSubMenu4)
        oTM3Item9:add(oSubMenu5)
        oSubMenu4:disable()
        oSubMenu5:disable()
    oTM3Item5 := TMenuItem():New(oDlg1,"Re-Processar",,,,{|| FWMsgRun(, {|| fReprocess() },"","Processando os dados...")},,,,,,,,,.T.)

    oTM3Item10   := TMenuItem():New(oDlg1,"Conf.Migração"        ,,,,{|| FWMsgRun(, {|| ConfMigra()},"","Conferindo os dados...") },,,,,,,,,.T.)
    
    oMenu3:Add(oTM3Item1)
    oMenu3:Add(oTM3Item2)
    oMenu3:Add(oTM3Item3)
    oMenu3:Add(oTM3Item3a)
    oMenu3:Add(oTM3Item4)
    oMenu3:Add(oTM3Item5)
    oMenu3:Add(oTM3Item6)    
    oMenu3:Add(oTM3Item7) 
    oMenu3:Add(oTM3Item8)
    oMenu3:Add(oTM3Item10)
   
    // Cria botão que sera usado no Menu
    oTButton3 := TButton():New( nBLin1Gp1, nBCol2Gp1, "Utilidades",oDlg1,{||},nTamGp14,nAltBts,,oFontB,.F.,.T.,.F.,,.F.,,,.F. )

    // Define botão no Menu
    oTButton3:SetPopupMenu(oMenu3)
    oTM3Item3:disable()
    oTM3Item3a:disable()
    oTM3Item4:disable()
    oTM3Item6:disable()
    oTM3Item7:disable()

    oBtn9      := TButton():New( nBLin2Gp1,nBCol1Gp1,"Processar",oDlg1,{||fWizard()},nTamGp14,nAltBts,,oFontB,,.T.,,"",,,,.F. ) 
    oBtn1      := TButton():New( nBLin2Gp1,nBCol5Gp1,"Sair",oDlg1,{|| oDlg1:end()},nTamGp14,nAltBts,,oFontB,,.T.,,"",,,,.F. )

    // Personalização dos botões
    oBtn1:SetCSS(GetCSS('oBtn1'))
    oBtn2:SetCSS(GetCSS('oBtn2'))  
    oBtn3:SetCSS(GetCSS('oBtn3'))  
    oBtn4:SetCSS(GetCSS('oBtn4'))  
    oBtn9:SetCSS(GetCSS('oBtn9'))
    oBtn10:SetCSS(GetCSS('oBtn10')) 
    
    If !(fVldAcess())
        //oTM2Item5:disable()
        oTM3Item3:disable()
        oTM3Item3a:disable()
        oTM3Item4:disable()
        oTM3Item5:disable()
        oTMenuIte5:disable()
        oBtn2:disable()
        oBtn3:disable()
        oBtn4:disable()
        oBtn9:disable()
        oBtn10:disable()
    EndIf

// Grupo 2
    nRefWGp2    := (nWidthWiz/2)
    nRefHGp2    := (nHeightWiz/2)
    nWGp2       := nRefWGp2*0.3
    nHGp2       := nRefHGp2-nSpace
    nGrp2Tot    := nRefWGp2*0.275
    nLineGp2    := nRefWGp2*0.1
    nLargGp2    := nRefWGp2*0.112
    If nWGp2 > 210
        nAltGp2     := nHGp2*0.75
    Else
        nAltGp2     := nHGp2*0.8
    EndIf
    nBt1Gr2     := nGrp2Tot*0.1
    nBt2Gr2     := nGrp2Tot*0.15
    nBt3Gr2     := nGrp2Tot*0.55
    nBt4Gr2     := nGrp2Tot*0.15

    oGrp2       := TGroup():New( nLineGp2,nMargem,nHGp2,nWGp2,"Tabelas",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oGrp2:oFont := oFontGrp
        
        oList1:= 	TCBrowse():New(nLargGp2,nAltBts,nGrp2Tot,nAltGp2,, {'','Tabela','Descricao','Registros'},;
                                {nBt1Gr2,nBt2Gr2,nBt3Gr2,nBt4Gr2},;
                                oGrp1,,,,{|| FHelp()},{|| /*editcol(oList1:nAt,0)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oList1:SetArray(aList1)
        oList1:bLine := {||{If(aList1[oList1:nAt,04]==1,oNo,(If(aList1[oList1:nAt,04]==2,oTv,oOk))),;
                            aList1[oList1:nAt,01],; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03]}}

// Grupo 3
    nRefWGp3    := (nWidthWiz/2)
    nRefHGp3    := (nHeightWiz/2)
    nWGp3       := nRefWGp3*0.6
    nHGp3       := nHGp2
    nMargGp3    := nRefWGp3*0.3+nSpace
    nGrp3Tot    := nRefWGp3*0.284
    nLineGp3    := nLineGp2
    nLargGp3    := nRefWGp3*0.112
    nAltGp3     := nAltGp2
    nBtref3     := nGrp3Tot*0.872
    nBt1Gr3     := nBtref3*0.2
    nBt2Gr3     := nBtref3*0.45
    nBt3Gr3     := nBtref3*0.2
    nBt4Gr3     := nBtref3*0.1

    oGrp3       := TGroup():New( nLineGp3,nMargGp3,nHGp3,nWGp3,"Campos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oGrp3:oFont := oFontGrp
        
        oList2:= 	TCBrowse():New(nLargGp3,nMargGp3*1.02,nGrp3Tot,nAltGp3,,{'Campo','Descricao','Tamanho','Pesquisa'},;
                                {nBt1Gr3,nBt2Gr3,nBt3Gr3,nBt4Gr3},;
                                oGrp2,,,,{|| FHelp2()},{|| /*editcol(oList1:nAt,0)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oList2:SetArray(aList2)
        oList2:bLine := {||{aList2[oList2:nAt,01],; 
                            aList2[oList2:nAt,02],;
                            aList2[oList2:nAt,03],; 
                            aList2[oList2:nAt,04]}}

// Grupo 4
    nRefWGp4    := (nWidthWiz/2)
    nRefHGp4    := (nHeightWiz/2)
    nGrp4Tot    := nRefWGp4*0.376
    nWGp4       := nRefWGp4-nMargem 
    nHGp4       := nHGp3
    nLineGp4    := nLineGp3
    nMargGp4    := nRefWGp4*0.6+nSpace
    nLargGp4    := nRefWGp4*0.112
    nAltGp4     := nAltGp3
    nBtref4     := nGrp4Tot*0.718
    nBt1Gr4     := nBtref4*0.1
    nBt2Gr4     := nBtref4*0.3
    nBt3Gr4     := nBtref4*0.3
    nBt4Gr4     := nBtref4*0.3

    oGrp4       := TGroup():New( nLineGp4,nMargGp4,nHGp4,nWGp4,"De/Para",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oGrp4:oFont := oFontGrp 
        
        oList3:= 	TCBrowse():New(nLargGp4,nMargGp4*1.006,nGrp4Tot,nAltGp4,, {'','Conteúdo Origem','Conteúdo Destino','Descrição Totvs'},;
                                {nBt1Gr4,nBt2Gr4,nBt3Gr4,nBt4Gr4},;
                                oGrp3,,,,{|| },{|| /*editdepa(oList3:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oList3:SetArray(aList3)
        oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),; 
                                aList3[oList3:nAt,02],;
                                aList3[oList3:nAt,03],;
                                aList3[oList3:nAt,05]}}
    
    MENU oMenu2 POPUP 
     
    MENUITEM "N para 1" ACTION ( xtrcrel('1') )
    MENUITEM "N para N" ACTION ( xtrcrel('N') )
    //MENUITEM "Agrupar/Desagrupar iguais" ACTION ( xtrcrel('I') )
    
    ENDMENU                                                                           

    oList2:bRClicked := { |oObject,nX,nY| oMenu2:Activate( nX, (nY-10), oObject ) }


oDlg1:Activate(,,,.T.)

Return

/*/{Protheus.doc} RelTab()
    Relacionamento entre tabelas de integração
    @type  Static Function
    @author user
    @since 24/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function RelTab()

Local aArea := Getarea()
Local aRet  := {}
Local cQuery 

cQuery := "SELECT P96_TABELA,P96_RELACI,P96_TIPINC,COUNT(*) AS QTD"      
cQuery += " FROM "+RetSQLName("P96")
cQuery += " WHERE D_E_L_E_T_=' '"
cQuery += " AND P96_TABELA NOT IN(SELECT RTRIM(P96_RELACI) FROM "+RetSQLName("P96")+" WHERE D_E_L_E_T_=' ' AND P96_RELACI<>' ')"
cQuery += " GROUP BY P96_TABELA,P96_RELACI,P96_TIPINC"
cQuery += " ORDER BY 2 desc"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    
    If Ascan(aRet,{|x| Alltrim(TRB->P96_TABELA) $ alltrim(x[2]) }) == 0
        Aadd(aRet,{TRB->P96_TABELA,Alltrim(TRB->P96_RELACI)})
    EndIf 
    Dbskip()
EndDo 

dbCloseArea()

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} InclNew
    Incluir uma nova configuração
    @type  Static Function
    @author user
    @since 01/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function InclNew()

Local aArea := GetArea()

cCodigo := GetSXEnum("P97","P97_CODIGO")
ConfirmSX8()

oGet1:enable()
oGet2:enable()
oGet3:enable()

oSay2:settext("")
oSay2:settext(cCodigo)

lIncluir := .t.

RestArea(aArea)

Return

/*/{Protheus.doc} AltCnfg
    Alterar configuraçao para executar a carga de dados
    @type  Static Function
    @author user
    @since 01/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function AltCnfg()

Local aArea     := GetArea()
Local cQuery    := ""
//Local cCodDevs  := SuperGetMv('TI_TINCH4',.F.,Decode64('NDE4MjE0LzQ0NjY1MC8yNzYxMDUvMjk5NTgyLzAyODYwMg=='))
Local nOpca     := 0
Local nCont     := 0
Local aTabR     := {}
Local lChkBox   := .F.
//Local cPreFilt  := ""
Local oSay1a//,oSay2a

Private aDadosP := {}
Private oDadosP
Private oDlgL,oGrpL1,oBtnL1,oBtnL2

cQuery := "SELECT P97_CODIGO,P97_FILORI,P97_FILDES,P97_CNPJ,COUNT(*)"
cQuery += " FROM "+RetSQLName("P97")
cQuery += " WHERE D_E_L_E_T_=' '" 
cQuery += " GROUP BY P97_CODIGO,P97_FILORI,P97_FILDES,P97_CNPJ"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aDadosP,{.F.,TRB->P97_CODIGO,TRB->P97_FILORI,TRB->P97_FILDES,TRB->P97_CNPJ,xnomefil(TRB->P97_FILDES)})
    Dbskip()
EndDo 
    
cQuery := "SELECT DISTINCT P96_TABELA,P96_RELACI"
cQuery += " FROM "+RetSQLName("P96")
cQuery += " WHERE D_E_L_E_T_=' '"
cQuery += " AND P96_TABELA NOT IN(SELECT DISTINCT P96_RELACI FROM "+RetSQLName("P96")+" WHERE D_E_L_E_T_=' ')"
cQuery += " ORDER BY P96_TABELA"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

Aadd(aTabR,'Selecione')

While !EOF()
    If Ascan(aTabR,{|x| Alltrim(TRB->P96_TABELA) $ alltrim(x) }) == 0
        Aadd(aTabR,TRB->P96_TABELA+IF(!Empty(TRB->P96_RELACI),'/'+ALLTRIM(TRB->P96_RELACI),''))
    EndIf
    Dbskip()
EndDo 

Aadd(aTabR,'Todos')
Aadd(aTabR,'SXs')
Aadd(aTabR,'RD0')
Aadd(aTabR,'Cópia Tabelas')
Aadd(aTabR,'PN1')

cTabRsg := aTabR[1]
lLibBotao   := .T.

dbCloseArea()

If len(aDadosP) > 0
    oDlgL      := MSDialog():New( 092,232,506,823,"Alterar",,,.F.,,,,,,.T.,,,.T. )
        
        oGrp1      := TGroup():New( 004,004,180,286,"Selecione",oDlgL,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,176,232},,, oGrp1 ) 
        oDadosP:= 	TCBrowse():New(012,008,275,115,, {'','Codigo','Filial Origem','Filial Destino','Nome Filial'},;
                                {10,40,40,40,90},;
                                oGrp1,,,,{|| },{|| AltSel(oDadosP:nAt,1,cTabRsg)},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oDadosP:SetArray(aDadosP)
        oDadosP:bLine := {||{If(aDadosP[oDadosP:nAt,01],oOk,oNo),; 
                                aDadosP[oDadosP:nAt,02],;
                                aDadosP[oDadosP:nAt,03],;
                                aDadosP[oDadosP:nAt,04],;
                                aDadosP[oDadosP:nAt,06]}}

        oSay1a     := TSay():New( 130,010,{||'Selecione a tabela desejada'},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
        oCBox1     := TComboBox():New( 130,100,{|u| If(Pcount()>0,cTabRsg:=u,cTabRsg)},aTabR,072,010,oGrp1,,{|| AltSel(0,2,cTabRsg)},,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

/*        oChkObj1   := TCheckBox():New(130,180,"Reprocessar" , {|u| Iif(PCount() > 0 , lChkBox := u, lChkBox)}, oGrp1, 050, 025, , , , , CLR_BLACK,CLR_WHITE, , .T.,"",, )

        cPreFilt += '<b>UMA TABELA</b><br> '
        cPreFilt += '<b>TABELA#CAMPO#OPERADOR#CONTEUDO/</b><br>'
        cPreFilt += 'Ex.: SA1#A1_CGC#==#12345678000112,12345678000224/<br><br>'
        cPreFilt += '<b>DUAS OU MAIS TABELAS</b><br>'
        cPreFilt += '<b>TABELA#CAMPO#OPERADOR#CONTEUDO/TABELA#CAMPO#OPERADOR#CONTEUDO/</b><br>'
        cPreFilt += 'Ex.: SF2#F2_DOC#==#000000001/SD2#D2_DOC#==#000000001/<br><br>'
        cPreFilt += '<b>Obs.: Sempre terminar com Barra ( / )</b><br><br><br>'
        cPreFilt += '<b>EM CASO DE CONTRATOS INFORMA APENAS OS CNPJs SEPARADOS POR VIRGULAS (,)       </b><br> '
        cPreFilt += 'Ex.: 99999999999999,88888888888888,77777777777777... '

        oSay2a     := TSay():New( 150,010,{||'Filtros'},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
        oMGet1     := TMultiGet():New( 150,100,{|u| If(Pcount()>0,cFilPesq:=u,cFilPesq)},oDlgL,172,026,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
        
        // Colocar validação para liberar somente para os devs
        oBtnL3     := TButton():New( 160,010,"Ex: Preenchimento",oDlgL,{|| MsgInfo(cPreFilt,"Ex. de Filtros")},050,012,,,,.T.,,"",,,,.F. )
*/        
        
        oBtnL1     := TButton():New( 184,060,"Confirmar",oDlgL,{|| oDlgL:end(nOpca:=1)},037,012,,,,.T.,,"",,,,.F. )
        oBtnL2     := TButton():New( 184,180,"Sair",oDlgL,{|| oDlgL:end(nOpca:=0)},037,012,,,,.T.,,"",,,,.F. )

        oBtnL1:disable()

    oDlgL:Activate(,,,.T.)

    If nOpca == 1
        cTimeProc := time()
        For nCont := 1 to len(aDadosP)
            If aDadosP[nCont,01]
                cCodigo  := aDadosP[nCont,02]
                cFilOrig := aDadosP[nCont,03]
                cFilDest := aDadosP[nCont,04]
                cCnpjOrig:= aDadosP[nCont,05]
                cNomeFil := aDadosP[nCont,06]
            EndIf 
        Next nCont


        cQuery := "SELECT PN2_CINTEG FROM "+RetSQLName("PN2")
        cQuery += " WHERE PN2_FILIAL='"+xFilial("PN2")+"' AND D_E_L_E_T_=' '"
        cQuery += " AND PN2_FILFAT='"+cFilDest+"'"

        If Select('TRB') > 0
            dbSelectArea('TRB')
            dbCloseArea()
        EndIf

        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        DbSelectArea("TRB")

        cCodPN2 := TRB->PN2_CINTEG
        
        If !Empty(cFilOrig)
            lAjsDePa := .F.
            FWMsgRun(, {|| CargaDados(lChkBox)},"","Aguarde, buscando dados")
            
            cQuery := "SELECT P97_CAMPO,P97_TABELA,P97_CONTOR,P97_CONTDE,P97_DESCTO"
            cQuery += " FROM "+RetSQLName("P97")      
            cQuery += " WHERE D_E_L_E_T_=' '"     
            cQuery += " AND P97_CODIGO='"+cCodigo+"' AND P97_FILORI='"+cFilOrig+"' AND P97_FILDES='"+cFilDest+"'"
            cQuery += " AND P97_CNPJ='"+cCnpjOrig+"'"

            cQuery += " AND P97_TABELA IN('"+strtran(cTabRsg,"/","','")+"')"

            If Select('TRB') > 0
                dbSelectArea('TRB')
                dbCloseArea()
            EndIf

            DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

            DbSelectArea("TRB")

            While !EOF()
                nPos := Ascan(aList3B,{|x| alltrim(x[4])+alltrim(x[2]) == Alltrim(TRB->P97_CAMPO)+alltrim(TRB->P97_CONTOR)})

                If nPos > 0
                    aList3B[nPos,03] := TRB->P97_CONTDE
                    aList3B[nPos,05] := TRB->P97_DESCTO
                    aList3B[nPos,01] := If(!Empty(TRB->P97_CONTDE),.T.,.F.)
                EndIf 

                nPos := Ascan(aListB3,{|x| alltrim(x[4])+alltrim(x[2]) == Alltrim(TRB->P97_CAMPO)+alltrim(TRB->P97_CONTOR)})

                If nPos > 0
                    aListB3[nPos,03] := TRB->P97_CONTDE
                    aListB3[nPos,05] := TRB->P97_DESCTO
                    aListB3[nPos,01] := If(!Empty(TRB->P97_CONTDE),.T.,.F.)
                EndIf

                Dbskip()
            EndDo 
        EndIf 

        dbCloseArea()

        oBtn10:enable()
        // oBtn2:enable()
        // oBtn3:enable()

        If !Empty(cTabRsg)
            oTM3Item1:enable()
            oTM3Item3:enable()
            oTM3Item3a:enable()
            oTM3Item4:enable()
            oTM3Item6:enable()
            oTM3Item7:enable()
            oTM2Item4:enable()
           // oTM2Item5:enable()
            oTM2Item6:enable()
            oTM2Item7:enable()
            oTMenuIte5:enable()
            oSubMenu4:enable()
            oSubMenu5:enable()
        EndIf

        If (cTabRsg == 'SA1') 
            oTM2Item1:enable()
        EndIf

        If (cTabRsg $'SE1/SE2/SE5') 
            oTM2Item3:enable()
        EndIf

        If (cTabRsg $'AI0/SA1/SA2/CT2/SN1/SN3/CN9/CNA/CNB/CNC') 
            oBtn3:Disable()
            oBtn2:Disable()
        EndIf

    EndIf  

    lAlterar := .T.
    oGet1:Refresh()
    oGet2:Refresh()
    oGet3:Refresh()
    oSay2:Refresh()
    oSay5:Refresh()
    oSay8:Refresh()
    oDlg1:Refresh()
Else 

    MsgAlert("Não há dados")

EndIF 

RestArea(aArea)

Return

/*/{Protheus.doc} AltSel
    Alterar a seleção do item a ser alterado
    @type  Static Function
    @author user
    @since 01/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function AltSel(nLinha,nOpc,cOpcaoC)

Local nCont 
Local lOk   := .F.

If nOpc == 1
    If aDadosP[nLinha,01]   
        aDadosP[nLinha,01] := .F.
    Else 
        aDadosP[nLinha,01] := .T.
        If cOpcaoC <> 'Selecione'
            lOk := .t.
        else    
            lOk := .f.
        endif 
    EndIf 
Else 
    If cOpcaoC <> 'Selecione'
        For nCont := 1 to len(aDadosP)
            If aDadosP[nCont,01]
                lOk := .T.
                exit
            endif 
        Next nCont 
    endif
EndIf 

If lOk
    oBtnL1:enable()
else 
    oBtnL1:disable()
EndIf 

oDadosP:refresh()
oDlgL:refresh()

Return

/*/{Protheus.doc} liberok
    (long_description)
    @type  Static Function
    @author user
    @since 21/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function liberok(nOpcao)

If nOpcao == 2
    cNomeFil:=xnomefil(cFilDest)

    If Empty(cNomeFil)
        Msgalert("Filial inexistente, verifique")
        cFilDest := space(11)
        oGet2:SetFocus()
        return
    Else 
        oSay5:settext(cNomeFil)
    EndIf 
EndIf
/*
If !Empty(cFilOrig) .And. !Empty(cFilDest) .And. !Empty(cCnpjOrig) .And. !lCarga
    
    If lIncluir
        DbSelectArea("P97")
        DbSetOrder(2)
        If !Dbseek(xFilial("P97")+Avkey(cFilOrig,"P97_FILORI")+Avkey(cFilDest,"P97_FILDES"))
            //oBtn2:enable()
            //oBtn5:enable()
        Else 
            MsgAlert("De/Para já configurado para estas filiais, utilize a opção alterar.")
        EndIf 
    EndIf 

    
Else 
    //oBtn2:disable()
EndIf
*/

Return

/*/{Protheus.doc} constdados
    Consistencia dos dados carregados.
    Validar a quantidade de cabeçalho, valores totais de cada entidade
    Comparar SE1 com as demais tabelas 
    (SE1 é a balisadora da incorporação, todo titulo de nf na e1 deve ter uma nota atrelada)
    @type  Static Function
    @author user
    @since 27/05/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function constdados()

Local cTab      := ''
Local cMsgErr   := ''
Local cCliFor   := ''
Local cDescri   := ''
Local cCab      := ''
Local cCpoCab   := ''
Local cItem     := ''
Local cCpoItem  := ''

Local nX        := 0
Local nY        := 0
Local nZ        := 0
Local nVzs      := 0
Local nTotal    := 0
Local nPosTabA  := 0
Local nPDup     := 0
Local nCli      := 0
Local nFor      := 0
Local nCpoCab   := 0
Local nTabItem  := 0
Local nCpoItem  := 0

Local aAuxD     := {}
Local aStruCps  := {}
Local aAuxClF   := {}
Local aProdutos := {}
Local aAuxExp   := {}
Local aRecPag   := {}
Local aAgrup    := {{'SE1','E1_TIPO','E1_VALOR',''},;
                {'SE5','E5_TIPO','E5_VALOR',''},;
                {'SE2','E2_TIPO','E2_VALOR',''},;
                {'CT2','CT2_DATA','CT2_VALOR',''},;
                {'SC5','C5_NUM','CONTAR',''},{'SC6','C6_FILIAL','C6_VALOR','C6_NUM'},;
                {'SF2','F2_DOC','CONTAR',''},{'SD2','D2_FILIAL','D2_TOTAL','D2_DOC'},;
                {'SF3','F3_NFISCAL','CONTAR',''},{'SFT','FT_FILIAL','FT_VALCONT','FT_NFISCAL'},;
                {'CN9','CN9_NUMERO','CONTAR',''},{'CNA','CNA_CONTRA','CONTAR',''},{'CNB','CNB_CONTRA','CONTAR',''},{'CNC','CNC_NUMERO','CONTAR',''},;
                {'PHG','PHG_CONTRA','CONTAR',''},{'PHH','PHH_CONTRT','CONTAR',''},{'PH4','PH4_CONTRA','CONTAR',''},;
                {'SN1','N1_CBASE','CONTAR',''},{'SN3','N3_FILIAL','N3_VORIG1','N3_CBASE'}}
Local aCpoProd  := {{'SC6','C6_PRODUTO'},{'CNB','CNB_PRODUT'},{'SD2','D2_COD'},{'SFT','FT_PRODUTO'},{'PGH','PHG_PRODUT'}}

Local lTemDados := .T.

Private oDados,oGrp1,oSay1,oSay2,oSay3,oSay4,oBtnx1,oBtnx2

If Len(aTabTmp) > 0

    For nX := 1 To Len(aTabTmp)
        // Soma, Conta e verifica se tem duplicados
        If !(AllTrim(aTabTmp[nX,02]) $'SA1/SA2/FOR')
            nPos := aScan(aAgrup,{|x| x[1] == aTabTmp[nX,02]})
            If nPos > 0
                If aAgrup[nPos,03] == 'CONTAR'
                    cQuery := " SELECT "   
                    cQuery += "    COALESCE(SUM(DUPLI.QTD), 0) AS DUPLICADOS, "  
                    cQuery += "    COUNT(TAB."+aAgrup[nPos,02]+") AS QUANTIDADE "  
                    cQuery += " FROM "   
                    cQuery += "    (SELECT "+aAgrup[nPos,02]+", COUNT(*) AS QTD "  
                    cQuery += "    FROM "+aTabTmp[nX,01] + " 
                    cQuery += "    GROUP BY "+aAgrup[nPos,02]+ "  
                    cQuery += "    HAVING COUNT(*) > 1) DUPLI   
                    cQuery += " RIGHT JOIN " +aTabTmp[nX,01]+ " TAB ON DUPLI.QTD = TAB."+aAgrup[nPos,02] 
                    cQuery += " WHERE " + PrefixoCPO(aTabTmp[nX,02]) + "_P98STA IN ('0','5')"
                Else 
                    If !(AllTrim(aTabTmp[nX,02]) $'SE1/SE2/SE5')
                        cQuery := " SELECT "
                        cQuery += "    SUM("+aAgrup[nPos,03]+") AS RESULT,"
                        cQuery += "    COUNT("+aAgrup[nPos,03]+") AS QUANTIDADE"
                        cQuery += " FROM "+aTabTmp[nX,01]
                        cQuery += " WHERE " + PrefixoCPO(aTabTmp[nX,02]) + "_P98STA IN ('0','5')"
                    Else
                        cQuery := " SELECT "+aAgrup[nPos,02]+" AS TIPO,"
                        cQuery += "    SUM("+aAgrup[nPos,03]+") AS RESULT,"
                        cQuery += "    COUNT("+aAgrup[nPos,03]+") AS QUANTIDADE"
                        cQuery += " FROM "+aTabTmp[nX,01]
                        cQuery += " WHERE "+aAgrup[nPos,02]+" NOT LIKE ('%-%')"
                        cQuery += " AND " + PrefixoCPO(aTabTmp[nX,02]) + "_P98STA IN ('0','5')"
                        cQuery += " GROUP BY "+aAgrup[nPos,02]
                    EndIF
                EndIf
            EndIf

            If Select('TRB') > 0
                DbSelectArea('TRB')
                DbCloseArea()
            EndIf

            DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
            DbSelectArea("TRB")

            While !EOF()
                If aAgrup[nPos,03] == 'CONTAR'
                    Aadd(aAuxD,{aAgrup[nPos,01],;
                                aAgrup[nPos,02],;
                                TRB->QUANTIDADE,;
                                0})
                    If TRB->DUPLICADOS > 0
                        Aadd(aAuxD,{"Chave_Unica",;
                                    "Registro duplicado",;
                                    TRB->DUPLICADOS,;
                                    aAgrup[nPos,02]})
                    EndIf
                Else
                    If !(AllTrim(aTabTmp[nX,02]) $'SE1/SE2/SE5')
                        Aadd(aAuxD,{aAgrup[nPos,01],;
                                    aAgrup[nPos,02],;
                                    TRB->QUANTIDADE,;
                                    TRB->RESULT})
                    Else
                        Aadd(aAuxD,{aAgrup[nPos,01],;
                                    TRB->TIPO,;
                                    TRB->QUANTIDADE,;
                                    TRB->RESULT})
                    EndIf
                EndIf
                Dbskip()
            EndDo 

            // Verifica se o Cliente/Fornecedor esta cadastrado com base nas tabelas de Pedidos/Notas/Movimentos/Titulos/Contratos
            aStruCps    := EstructTemp(aTabTmp[nX,01])

            // Se for SE5 verifica se existem movimentos à Pagar e a Receber, caso tenha os dois verifica tanto cliente quando fornecedor 
            If AllTrim(aTabTmp[nX,02]) == 'SE5'

                cQuery := " SELECT E5_RECPAG, COUNT(*) AS QTD"
                cQuery += " FROM "+aTabTmp[nX,01]
                cQuery += " WHERE E5_P98STA IN ('0','5') AND E5_RECPAG <> ' ' "
                cQuery += " GROUP BY E5_RECPAG"

                If Select('TRB') > 0
                    dbSelectArea('TRB')
                    dbCloseArea()
                EndIf

                PlsQuery(cQuery, "TRB")
                DbSelectArea("TRB")

                If !TRB->(EoF())
                    TRB->(DbGoTop())
                    While !EOF()
                        Aadd(aRecPag,{AllTrim(TRB->E5_RECPAG)})
                        DbSkip()
                    EndDo
                EndIf

                nVzs := Len(aRecPag)
            
            Else
                nVzs := 1
            EndIf

            For nZ := 1 To nVzs
                If AllTrim(aTabTmp[nX,02]) == 'SE5'
                    aAuxClF := fVldCliFor(aStruCps,aTabTmp[nX,01],aTabTmp[nX,02],@cCliFor,aRecPag[nZ,01])
                Else
                    aAuxClF := fVldCliFor(aStruCps,aTabTmp[nX,01],aTabTmp[nX,02],@cCliFor,'')
                EndIf
                For nY := 1 To Len(aAuxClF)
                    If cCliFor == 'C'
                        cTab := 'SA1'
                        cQuery := " SELECT "+alltrim(aAuxClF[nY])+" AS CLIENTE,A1_COD,COUNT(*) AS QTD"
                        cQuery += " FROM "+aTabTmp[nX,01]
                            cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL=' '" 
                            cQuery += " AND A1_CGC=RPAD("+alltrim(aAuxClF[nY])+", 14, ' ') AND A1.D_E_L_E_T_=' '"
                        cQuery += " WHERE LENGTH("+alltrim(aAuxClF[nY])+") > 6  AND A1_CGC IS NULL"
                        cQuery += " AND " + PrefixoCPO(aTabTmp[nX,02]) + "_P98STA IN ('0','5')"
                        cQuery += " GROUP BY "+alltrim(aAuxClF[nY])+",A1_COD"
                    Else
                            cTab := 'SA2'
                        cQuery := " SELECT "+alltrim(aAuxClF[nY])+" AS FORNEC,A2_COD,COUNT(*) AS QTD"
                        cQuery += " FROM "+aTabTmp[nX,01]
                            cQuery += " LEFT JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL=' '"
                            cQuery += " AND A2_CGC=RPAD("+alltrim(aAuxClF[nY])+", 14, ' ') AND A2.D_E_L_E_T_=' '"
                        cQuery += " WHERE LENGTH("+alltrim(aAuxClF[nY])+") > 6 AND A2_CGC IS NULL"     
                        cQuery += " AND " + PrefixoCPO(aTabTmp[nX,02]) + "_P98STA IN ('0','5')"    
                        cQuery += " GROUP BY "+alltrim(aAuxClF[nY])+",A2_COD"
                    EndIf 
                        
                    If Select('TRB') > 0
                        dbSelectArea('TRB')
                        dbCloseArea()
                    EndIf

                    PlsQuery(cQuery, "TRB")
                    DbSelectArea("TRB")

                    If !TRB->(EoF())
                        TRB->(DbGoTop())
                        While !EOF()
                                nPosTabA := Ascan(aAuxD,{|x| x[1] == cTab})
                                If nPosTabA == 0
                                If cCliFor == 'C'
                                    cMsgErr := "Cliente(s) nao_cadastrado(s)"
                                Else
                                    cMsgErr := "Fornecedor(es) nao_cadastrado(s)"
                                    EndIf 
                                    Aadd(aAuxD,{cTab,;
                                                cMsgErr,;
                                                1,;
                                            AllTrim(If(cCliFor == 'C',TRB->CLIENTE,TRB->FORNEC))})
                                Else 
                                If !(AllTrim(If(cCliFor == 'C',TRB->CLIENTE,TRB->FORNEC)) $ aAuxD[nPosTabA,4])
                                        aAuxD[nPosTabA,3] += 1
                                    aAuxD[nPosTabA,4] += "/"+AllTrim(If(cCliFor == 'C',TRB->CLIENTE,TRB->FORNEC))
                    EndIf 
                EndIF

                            Dbskip()
                        Enddo
                                EndIf
                Next nY 
            Next nZ
        Else
            // Conta quantidade de Clientes/Fornecedores à serem migrados
                cTab    := AllTrim(aTabTmp[nX,02])
            cCliFor := If(cTab == 'SA1','C','F')
            cQuery  := " SELECT COUNT(*) AS QTD FROM "+aTabTmp[nX,01]+" WHERE " + PrefixoCPO(cTab) + "_P98STA IN ('0','5')"

            If Select('TRB') > 0
                DbSelectArea('TRB')
                DbCloseArea()
            EndIf 

            PlsQuery(cQuery, "TRB")
            DbSelectArea("TRB")

            If !TRB->(EoF())
                TRB->(DbGoTop())
                Aadd(aAuxD,{cTab,;
                            If(cTab == 'SA1','Clientes à serem migrados','Fornecedores à serem migrados'),;
                            TRB->QTD,;
                            /*TRB->RESULT*/ ''})
            EndIF

            // Verificar se já existem clientes/fornecedores a importação dos mesmos 
            If cTab == 'SA1'
                cQuery := " SELECT A1_COD AS RESULT FROM "+RetSQLName("SA1")+" A1"
                cQuery += " WHERE  A1.D_E_L_E_T_=' ' AND A1_CGC IN (SELECT A1_CGC FROM "+aTabTmp[nX,01]+" WHERE A1_P98STA IN ('0','5')) "
                                        Else
                cQuery := " SELECT A2_COD AS RESULT FROM "+RetSQLName("SA2")+" A2"
                cQuery += " WHERE  A2.D_E_L_E_T_=' ' AND A2_CGC IN (SELECT A2_CGC FROM "+aTabTmp[nX,01]+" WHERE A2_P98STA IN ('0','5')) "
                                        EndIf 

            If Select('TRB') > 0
                dbSelectArea('TRB')
                dbCloseArea()
                                EndIf 

            PlsQuery(cQuery, "TRB")
            DbSelectArea("TRB")

            If !TRB->(EoF())
                TRB->(DbGoTop())

                Count To nTotal
                If cCliFor == 'C'
                    cMsgErr := "Clientes já cadastrados"
                Else
                    cMsgErr := "Fornecedor já cadastrados"
                EndIf 

                Aadd(aAuxD,{aTabTmp[nX,02],;
                            cMsgErr,;
                            nTotal,;
                            /*TRB->RESULT*/ ''})
            EndIF

        EndIf 

        // Verifica os Produtos (C6_PRODUTO/CNB_PRODUT/D2_COD/FT_PRODUTO/PHG_PRODUT)
        nProd := Ascan(aCpoProd,{|x| x[1] == AllTrim(aTabTmp[nX,02])})
        If nProd > 0
            aProdutos := {}

            cQuery := " SELECT "+aCpoProd[nProd,02]+" AS PRODUTO,COUNT(*) FROM "+aTabTmp[nX,01]+" TMP"
            cQuery += " WHERE TMP."+aCpoProd[nProd,02]+" NOT IN (SELECT SB1.B1_COD FROM "+RetSQLName("SB1")+" SB1)  GROUP BY TMP."+aCpoProd[nProd,02]
            
            If Select('TRB') > 0
                dbSelectArea('TRB')
                dbCloseArea()
                                                EndIf 

            PlsQuery(cQuery, "TRB")
            DbSelectArea("TRB")

            If !TRB->(EoF())
                Count To nTotal
                TRB->(DbGoTop())
                While !EOF()
                    If Len(aProdutos) == 0 
                        Aadd(aProdutos,AllTrim(TRB->PRODUTO))
                    ElseIf Ascan(aProdutos,AllTrim(TRB->PRODUTO)) == 0
                        Aadd(aProdutos,AllTrim(TRB->PRODUTO))
                                    EndIf 
                    Dbskip()
                EndDo
                                EndIf 
    
            If Len(aProdutos) > 0
                VldPrdGr(aProdutos,aAuxD)
            EndIf 
        EndIf 

        // Verifica se existe Cabeçalhos sem os Itens 
        If aTabTmp[nX,02] $ 'SC5/SF2/SF3/SN1'

            // Pega a Tabela Pai
            cCab        := aTabTmp[nX,02]
            nCpoCab     := Ascan(aAgrup,{|x| x[1] == cCab})
            cCpoCab     := aAgrup[nCpoCab,02]

            // Pega a Tabela Filha 
            If cCab == 'SC5'
                cItem :='SC6'
            ElseIf cCab == 'SF2'
                cItem :='SD2'
            ElseIf cCab == 'SF3'
                cItem :='SFT'
            ElseIf cCab == 'SN1'
                cItem :='SN3'
            EndIf

            If !Empty(cItem)

                nTabItem    := Ascan(aTabTmp,{|x| x[2] == cItem})
                nCpoItem    := Ascan(aAgrup,{|x| x[1] == cItem})
                cCpoItem    := aAgrup[nCpoItem,04]

                cQuery := " SELECT '"+cCab+"' AS TAB, 'Cabecalho_Sem_Item' AS DESCRI, COUNT(*) AS QTD, "+cCpoCab+" AS CHV_CAB "
                cQuery += " FROM "+aTabTmp[nX,01]+" CAB "
                cQuery += " WHERE CAB." + PrefixoCPO(cCab) + "_P98STA IN ('0', '5') "
                cQuery += "     AND NOT EXISTS (SELECT 1 "
                cQuery += "                     FROM "+aTabTmp[nTabItem,01]+" ITEM "
                cQuery += "                     WHERE ITEM."+cCpoItem+" = CAB."+cCpoCab
                cQuery += "                         AND ITEM." + PrefixoCPO(cItem) + "_P98STA IN ('0', '5')) "
                cQuery += " GROUP BY "+cCpoCab
                cQuery += " UNION "
                cQuery += " SELECT '"+cItem+"' AS TAB, 'Item_Sem_Cabecalho' AS DESCRI, COUNT(*) AS QTD, "+cCpoItem+" AS CHV_CAB "
                cQuery += " FROM "+aTabTmp[nTabItem,01]+" ITEM "
                cQuery += " WHERE ITEM." + PrefixoCPO(cItem) + "_P98STA IN ('0', '5') "
                cQuery += "     AND NOT EXISTS (SELECT 1 "
                cQuery += "                     FROM "+aTabTmp[nX,01]+" CAB "
                cQuery += "                     WHERE CAB."+cCpoCab+" = ITEM."+cCpoItem
                cQuery += "                         AND CAB." + PrefixoCPO(cCab) + "_P98STA IN ('0', '5')) "
                cQuery += " GROUP BY "+cCpoItem

                If Select('TRB') > 0
                    dbSelectArea('TRB')
                    dbCloseArea()
                EndIf 

                PlsQuery(cQuery, "TRB")
                DbSelectArea("TRB")

                If !TRB->(EoF())
                    TRB->(DbGoTop())

                    While !EOF()

                        If TRB->QTD > 0

                            If cDescri <> TRB->DESCRI
                                cDescri := TRB->DESCRI
                            EndIf 

                            nPosTabA := Ascan(aAuxD,{|x| x[2] == cDescri})

                            If nPosTabA == 0
                                Aadd(aAuxD,{TRB->TAB,;
                                            cDescri,;
                                            TRB->QTD,;
                                            AllTrim(TRB->CHV_CAB)})
                            Else 
                                If !(AllTrim(TRB->CHV_CAB) $ aAuxD[nPosTabA,4])
                                    aAuxD[nPosTabA,3] += 1
                                    aAuxD[nPosTabA,4] += "/"+AllTrim(TRB->CHV_CAB)
                                EndIf 
                            EndIf
                        EndIf
                        Dbskip()
                    EndDo
                EndIf
            EndIf 
        EndIf 

        Next nX 

    // Fecha a tabela temporaria para liberar memória 
    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    If Len(aAuxD) > 0 
        oDados  := MSDialog():New( 114,802,704,1398,"Consistência dos Dados",,,.F.,,,,,,.T.,,,.T. )

            oGrp1   := TGroup():New( 004,016,272,276,"Registros",oDados,CLR_BLACK,CLR_WHITE,.T.,.F. )
            oList2x := TCBrowse():New(012,024,240,250,, {'Tabela','Tipo','Qtd','Valor'},;
                                        {40,90,60,60},;
                                        oGrp1,,,,{|| /*FHelp()*/},{|| /*relactab(oList1:nAt,oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

            aAuxExp := aClone(aAuxD)
            nPDup   := Ascan(aAuxD,{|x| AllTrim(x[1]) $ AllTrim("Chave_Unica")})
            nCli    := Ascan(aAuxD,{|x| AllTrim(x[1]) == AllTrim("SA1")})
            nFor    := Ascan(aAuxD,{|x| AllTrim(x[1]) == AllTrim("SA2")})
            nCab    := Ascan(aAuxD,{|x| AllTrim(x[2]) == AllTrim("Cabecalho_Sem_Item")})
            nItem   := Ascan(aAuxD,{|x| AllTrim(x[2]) == AllTrim("Item_Sem_Cabecalho")})

            If !Empty(cMsgErr) .OR. !Empty(cDescri)
            If nCli > 0 
                aAuxD[nCli,4] := "Exportar p/ vizualizar"
            EndIf

            If nFor > 0 
                aAuxD[nFor,4] := "Exportar p/ vizualizar"
                    EndIf

                If nCab > 0 
                    lLibBotao := .F.
                    aAuxD[nCab,4] := "Exportar p/ vizualizar"
                EndIf

                If nItem > 0 
                    lLibBotao := .F.
                    aAuxD[nItem,4] := "Exportar p/ vizualizar"
                EndIf
            EndIf

            oList2x:SetArray(aAuxD)
            oList2x:bLine := {||{aAuxD[oList2x:nAt,01],; 
                                aAuxD[oList2x:nAt,02],;
                                Transform(aAuxD[oList2x:nAt,03],"@E 999,999"),;
                                If((!(aAuxD[oList2x:nAt,01] $ "SA1/SA2/Chave_Unica") .AND. !(aAuxD[oList2x:nAt,02]$"nao_cadastrado/Cabecalho_Sem_Item/Item_Sem_Cabecalho")),;
                                Transform(aAuxD[oList2x:nAt,04],"@E 999,999,999.99"),aAuxD[oList2x:nAt,04])}}

            oBtnx1      := TButton():New( 276,084,"Exportar",oDados,{|| ExpConst(aAuxExp)},037,008,,,,.T.,,"",,,,.F. )
            oBtnx2      := TButton():New( 276,144,"Sair",oDados,{|| oDados:end()},037,008,,,,.T.,,"",,,,.F. )

        oDados:Activate(,,,.T.)
    Else
        lTemDados := .F.
        FWAlertWarning("Não há Dados para realizar Consistência","Atenção !!")
    EndIf
Else
    lTemDados := .F.
    FWAlertWarning("Não há Dados para realizar Consistência","Atenção !!")
EndIf

If lTemDados
    If (cTabRsg $'AI0/SA1/SA2/CT2/SN1/SN3/CN9/CNA/CNB/CNC') .Or. fVldAcess()
            oBtn9:enable()  // Processar
            oBtn4:enable()  // Verificar Dados
        If 'CN9' $ cTabRsg
                oTM2Item2:enable()  //Conferir Contratos
        EndIf
    Else
            oBtn3:enable()  //Config. De/Para 
    EndIf

    If !lLibBotao
        oBtn2:disable() // Atualizar De/Para
        oBtn3:disable() // Config. De/Para 
        oBtn4:disable() // Verificar Dados
        oBtn9:disable() // Processar
        FWAlertWarning("Não é possivel processar Cabeçalhos com Itens faltantes ou vice-versa."+CRLF+CRLF+" Corrija os dados a serem migrados!! ","Atenção !!")
    EndIf
EndIf

Return

/*/{Protheus.doc} VldPrdGr
    Validação de produtos  - verifica se todos estão 
    @type  Static Function
    @author user
    @since 20/09/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function VldPrdGr(aProdutos,aAuxD)

Local aArea     := GetArea()
Local cQuery    := ""
Local cMsgErr   := ""
Local nI        := 0
Local lRet      := .T.

cQuery := "SELECT B1_COD,B1.R_E_C_N_O_ AS B1REC,B5.R_E_C_N_O_ AS B5REC,BM.R_E_C_N_O_ AS BMREC "
cQuery += " FROM "+RetSqlName("SB1")+" B1"
cQuery += " LEFT JOIN "+RetSqlName("SB5")+" B5 ON B5_FILIAL=B1_FILIAL AND B5_COD=B1_COD AND B5.D_E_L_E_T_=' '    
cQuery += " LEFT JOIN "+RetSqlName("SBM")+" BM ON BM_FILIAL=B1_FILIAL AND BM_GRUPO=B1_GRUPO AND BM.D_E_L_E_T_=' '    
cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'" 
cQuery += " AND B1_COD IN('" 

For nI := 1 To Len(aProdutos)
    cQuery += aProdutos[nI]
    If nI > 1 .And. nI < Len(aProdutos)
        cQuery += "','"
    EndIf
Next nI 

cQuery += "')"
cQuery += " AND B1.D_E_L_E_T_=' ' "

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
DbSelectArea("TRB")

While !EOF()
    nPosTabA := Ascan(aAuxD,{|x| x[1] == "Produtos"})
    If nPosTabA == 0
    If Empty(TRB->B1_COD) 
        lRet := .F.
        Aadd(aAuxD,{"Produtos",;
                    "Registro incompleto",;
                    1,;
                        AllTrim(TRB->B1_COD) + " Não Cadastrado (SB1)"})
    Else
        If Empty(TRB->B5REC)
            lRet := .F.
            Aadd(aAuxD,{"Produtos",;
                        "Registro incompleto",;
                        1,;
                            AllTrim(TRB->B1_COD) + " Falta Complemento (SB5)"})
        EndIf

        If Empty(TRB->BMREC)
            lRet := .F.
            Aadd(aAuxD,{"Produtos",;
                        "Registro incompleto",;
                        1,;
                            AllTrim(TRB->B1_COD) + " Falta Complemento (SBM)"})
        EndIf

        EndIf
    Else
        If Empty(TRB->B1_COD)
            cMsgErr := AllTrim(TRB->B1_COD) + " Não Cadastrado (SB1)"
        ElseIf Empty(TRB->B5REC)
            cMsgErr := AllTrim(TRB->B1_COD) + " Falta Complemento (SB5)"
        ElseIf Empty(TRB->BMREC)
            cMsgErr := AllTrim(TRB->B1_COD) + " Falta Complemento (SBM)"
        EndIf

        If !(cMsgErr $ aAuxD[nPosTabA,4])
            aAuxD[nPosTabA,3] += 1
            aAuxD[nPosTabA,4] += "/"+cMsgErr
        EndIf
    EndIf
    Dbskip()
EndDo 

RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} ExpConst
    Exporta o grid de consistencia de dados.
    @type  Static Function
    @author user
    @since 20/08/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ExpConst(aAuxD)

Local cDir 		 := 'c:\temp\integramais\'
Local cArqXls 	 := "Consistencia_"+dtos(ddatabase)+strtran(time(),":")+".txt" 
Local nY,nW  
Local cDados     := ""
Local oFWriter

If Len(aAuxD) > 0

    oFWriter := FWFileWriter():New(cDir + cArqXls, .T.)

    If ! oFWriter:Create()
        FWAlertError("Houve um erro ao gerar o arquivo: " + CRLF + oFWriter:Error():Message, "Atenção")
    Else

        // Nome da colunas
        cDados := "Tabela;Tipo;Qtd;Valor"+CRLF

        //Conteudo das colunas 
        For nY := 1 To Len(aAuxD)
            For nW := 1 To Len(aAuxD[nY])
                If ValType(aAuxD[nY,nW]) == "C"
                    cDados += aAuxD[nY,nW]
                ElseIf ValType(aAuxD[nY,nW]) == "N"
                    cDados += cValToChar(aAuxD[nY,nW])
                ElseIf ValType(aAuxD[nY,nW]) == "D"
                    cDados += cValToChar(aAuxD[nY,nW])
                EndIf
                If nW < Len(aAuxD[nY])
                    cDados += ';'
                EndIf 
            Next nW
            cDados += CRLF
        Next nY 
        
        oFWriter:Write(cDados)
        oFWriter:Close()
        FreeObj(oFWriter)

        If FWAlertYesNo("Arquivo gerado com sucesso ( " + cDir + cArqXls + " )!" + CRLF + "Deseja abrir?", "Atenção")
            ShellExecute("OPEN", cArqXls, "", cDir, 1 )
        EndIf

    EndIf

EndIf

Return

/*/{Protheus.doc} BuscaDePara
    Busca de para ja configurados
    @type  Static Function
    @author user
    @since 21/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaDePara()

Local aArea := GetArea()
Local cQuery 

cQuery := "SELECT P96_TABELA,P96_TIPINC FROM "+RetSQLName("P96")   
cQuery += " WHERE D_E_L_E_T_=' '"  
cQuery += " GROUP BY P96_TABELA,P96_TIPINC"
cQuery += " ORDER BY 1 "

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aList1,{TRB->P96_TABELA,FWX2Nome ( TRB->P96_TABELA ),0,1,TRB->P96_TIPINC})
    Dbskip()
EndDo 

If len(aList1) < 1
    Aadd(aList1,{'','',0,1,''})
EndIf 

cQuery := "SELECT P96_CAMPO,P96_DESCRI,P96_TAMANH,P96_PESQUI,P96_TABELA,"
cQuery += " P96_TITULO,P96_DEPARA,P96_TIPO,P96_DICA,P96_VALIDA,P96_FIXO,P96_INDTBL"
cQuery += " FROM "+RetSQLName("P96")
cQuery += " WHERE D_E_L_E_T_=' '  AND P96_FILIAL=' '" //AND P96_DEPARA<>' '
cQuery += " ORDER BY P96_SEQ"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    aAux := FWSX3Util():GetFieldStruct( TRB->P96_CAMPO )
    
    cCombo := GetSX3Cache(aAux[1], "X3_GRPSXG") 
    
    If !Empty(TRB->P96_DEPARA)
        Aadd(aList2B,{  TRB->P96_CAMPO,;
                        TRB->P96_DESCRI,;
                        TRB->P96_TAMANH,;
                        TRB->P96_PESQUI,;
                        TRB->P96_TABELA,;
                        TRB->P96_TIPO,;
                        cCombo,;
                        ''})
    EndIf 

    AadD(aList4,{TRB->P96_CAMPO,;
                 TRB->P96_DESCRI,;
                 TRB->P96_TAMANH,;
                 TRB->P96_PESQUI,;
                 TRB->P96_TABELA,;
                 TRB->P96_TIPO,;
                 cCombo,;
                 '',;
                 TRB->P96_TITULO,;
                 TRB->P96_DICA,;
                 TRB->P96_VALIDA,;
                 TRB->P96_FIXO,;
                 TRB->P96_INDTBL})

    Dbskip()
EndDo 

Asort(aList4,,,{|x,y| x[5] < y[5]})

If len(aList2B) < 1
    Aadd(aList2B,{'','','','','',''})
EndIf 

Aadd(aList3B,{.F.,'','','','','',''})

aListB3 := aClone(aList3B)

dbCloseArea()

RestArea(aArea)

Return

/*/{Protheus.doc} FHelp
    Atualização do grid principal
    @type  Static Function
    @author user
    @since 21/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FHelp()

Local aArea := GetArea()
Local nCont 

aList2 := {}
oList2:nAt := 1 
oSay10:settext("")

For nCont := 1 to len(aList2B)
    If alltrim(aList2B[nCont,05]) == alltrim(aList1[oList1:nAt,01])
        Aadd(aList2,aList2B[nCont])
    EndIf 
Next nCont 

If len(aList2) < 1
    Aadd(aList2,{'','','','',''})
EndIf 

oList2:SetArray(aList2)
oList2:bLine := {||{aList2[oList2:nAt,01],; 
                    aList2[oList2:nAt,02],;
                    aList2[oList2:nAt,03],; 
                    aList2[oList2:nAt,04]}}

oSay10:settext(aList1[oList1:nAt,05] + ' - ' + x3Combo('P96_TIPINC',aList1[oList1:nAt,05]))

oList2:refresh()
oDlg1:refresh()

Fhelp2()

RestArea(aArea)

Return

/*/{Protheus.doc} FHelp2
    Atualização do segundo grid
    @type  Static Function
    @author user
    @since 21/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FHelp2()

Local aArea := GetArea()
Local nCont 

aList3 := {}
oList3:nAt := 1

nPosB3 := Ascan(aList3B,{|x| alltrim(x[4]) == alltrim(aList2[oList2:nAt,01]) })

If nPosB3 > 0
    For nCont := nPosB3 to len(aList3B)
        If alltrim(aList3B[nCont,04]) != alltrim(aList2[oList2:nAt,01])
            exit 
        EndIf 

        If aList3B[nCont,06] == "I"
            If Ascan(aList3,{|x| alltrim(x[2]) == alltrim(aList3B[nCont,02])}) == 0
                Aadd(aList3,aList3B[nCont])
            EndIf 
        Else 
            Aadd(aList3,aList3B[nCont])

            If Alltrim(aList3B[nCont,02]) == '*'
                aList3[len(aList3),01] := .T.
                EXIT
            EndIf 
        EnDIf 
        
    Next nCont
EndIf  

If len(aList3) < 1
    Aadd(aList3,{.f.,'','','','',''})
EndIf 

oList3:SetArray(aList3)
oList3:bLine := {||{if(aList3[oList3:nAt,01],oOk,oNo),; 
                    aList3[oList3:nAt,02],;
                    aList3[oList3:nAt,03],;
                    aList3[oList3:nAt,05]}}

oList3:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} xnomefil
    Busca o nome da filial determinada para incorporação
    @type  Static Function
    @author user
    @since 21/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xnomefil(cFilSel)

Local aFilRet := FWSM0Util():GetSM0Data( cempant , cFilSel , { "M0_FILIAL" } )
Local cRet    := ''

If len(aFilRet) > 0
    cRet := aFilRet[1,2]
EndIf 

Return(cRet)

/*/{Protheus.doc} ConfigDePara()
    Configuração De/Para dos dados a serem executados
    @type  Static Function
    @author user
    @since 28/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ConfigDePara()

Local aArea     := GetArea()
Local nCont 
Local nOpcao    :=  0
Local nX,nY,nZ,nW
Local aAuxL2    := {}
Local aTabPrc   := separa(cTabRsg,"/")
Local nTabL3    := 0
Local aAuxL3    := {}
Local aConteL3  := {}
Local nAux      := 0
Private aAux2   := {}
Private aAux3   := {}

Private oDlg3,oGrp1,oGrp2,oGrp3,oBtn1Cfg,oBtn2Cfg,oDp1,oDp2,oDp3

For nCont := 1 to len(aList2B)
    nPos  := Ascan(aAux2,{|x| x[7] == aList2B[nCont,07]})
    nPos2 := Ascan(aAux2,{|x| Alltrim(x[4]) == Alltrim(aList2B[nCont,04]) .And. !Empty(aList2B[nCont,04]) })

    nTabL3    := Ascan(aTabPrc,{|x| x == aList2B[nCont,05]}) 

    If nTabL3 > 0
        nAux  := Ascan(aTabTmp,{|x| x[2] == alltrim(aTabPrc[nTabL3])})
        If nAux > 0
            cCampo := alltrim(aList2B[nCont,01])
            If Ascan(aList3B,{|x| x[4] == alltrim(cCampo)}) == 0
                aConteL3 := BuscaTemp(cCampo,aTabTmp[nAux,01])
                For nZ := 1 to len(aConteL3)
                    Aadd(aList3B,{  .F.,;
                            aConteL3[nZ],;
                            If("FILIAL" $ alltrim(upper(cCampo)),cFilDest,""),;
                            alltrim(upper(cCampo)),;
                            If("FILIAL" $ alltrim(upper(cCampo)),cNomeFil,""),;
                            ''})
                Next nZ 
            EndIf 
        EndIf 
    Else 
        For nY := 1 to len(aTabPrc)
            If PrefixoCPO(aTabPrc[nY])+"_" $ aList2B[nCont,08]
                aAuxL3 := separa(aList2B[nCont,08],"/")
                Asort(aAuxL3,,,{|x,y| x < y})
                cPrefixo := PrefixoCPO(aTabPrc[nY])+"_"
                nTamPrx  := len(cPrefixo)
                nPosL3 := Ascan(aAuxL3,cPrefixo)
                For nW := nPosL3 to len(aAuxL3)
                    If substr(aAuxL3[nW],1,nTamPrx) <> cPrefixo 
                        exit 
                    EndIf 
                    cCampo := alltrim(aAuxL3[nW])
                    If Ascan(aList3B,{|x| x[4] == alltrim(cCampo)}) == 0
                        aConteL3 := BuscaTemp(cCampo,aTabPrc[nY])
                        For nZ := 1 to len(aConteL3)
                            Aadd(aList3B,{  .F.,;
                                    aConteL3[nZ],;
                                    If("FILIAL" $ alltrim(upper(cCampo)),cFilDest,""),;
                                    alltrim(upper(cCampo)),;
                                    If("FILIAL" $ alltrim(upper(cCampo)),cNomeFil,""),;
                                    ''})
                        Next nZ 
                    EndIf 
                Next nW 
            EndIf 
        Next nY 
    EndIf 

    If nPos == 0
        Aadd(aAux2,aList2B[nCont])
        aAux2[len(aAux2),08] := alltrim(aList2B[nCont,01])
    else 
        If !Empty(aList2B[nCont,07])
            aAux2[nPos,08] := alltrim(aAux2[nPos,08]) + '/'+ alltrim(aList2B[nCont,01])
        Else 
            If nPos2 == 0
                Aadd(aAux2,aList2B[nCont])
                aAux2[len(aAux2),08] := alltrim(aList2B[nCont,01])
            Else 
                aAux2[nPos2,08] := alltrim(aAux2[nPos2,08]) + '/'+ alltrim(aList2B[nCont,01])
            EndIf 
        EndIf 
    EndIf 

Next nCont 

oDlg3      := MSDialog():New( 375,527,660,1753,"Configuração do De/Para",,,.F.,,,,,,.T.,,,.T. )
    
    oGrp1      := TGroup():New( 004,004,124,358,"Destino",oDlg3,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,120,304},,, oGrp1 ) 
        oDp1:= 	TCBrowse():New(012,008,345,105,, {'Descricao','Tamanho','Pesquisa','Campos'},;
                                {80,30,40,90},;
                                oGrp1,,,,{|| HelpAux()},{|| /*editcol(oList1:nAt,0)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oDp1:SetArray(aAux2)
        oDp1:bLine := {||{  aAux2[oDp1:nAt,02],;
                            aAux2[oDp1:nAt,03],; 
                            aAux2[oDp1:nAt,04],;
                            aAux2[oDp1:nAt,08]}}

    oGrp2      := TGroup():New( 004,362,124,602,"Origem",oDlg3,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,316,120,548},,, oGrp2 ) 
        oDp2:= 	TCBrowse():New(012,366,229,105,, {'Conteudo Origem','Conteudo Destino','Descriçao'},;
                                {80,80,90},;
                                oGrp2,,,,{|| /*FHelp2()*/},{|| edtdepar(oDp2:nAt) /*editcol(oList1:nAt,0)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oDp2:SetArray(aAux3)
        oDp2:bLine := {||{  aAux3[oDp2:nAt,02],;
                            aAux3[oDp2:nAt,03],; 
                            aAux3[oDp2:nAt,05]}}

    oBtnCfg1      := TButton():New( 130,200,"Salvar",oDlg3,{||oDlg3:end(nOpcao:=1)},037,008,,,,.T.,,"",,,,.F. )
    oBtnCfg2      := TButton():New( 130,275,"Carga",oDlg3,{|| cargadepara()},037,008,,,,.T.,,"",,,,.F. )
    oBtnCfg3      := TButton():New( 130,350,"Sair",oDlg3,{||oDlg3:end(nOpcao:=0)},037,008,,,,.T.,,"",,,,.F. )
    
    MENU oMenux POPUP 
     
    MENUITEM "Replicar" ACTION ( replicar(oDp2:nAt) )
    //MENUITEM "Agrupar/Desagrupar iguais" ACTION ( xtrcrel('I') )
    
    ENDMENU                                                                           

    oDp2:bRClicked := { |oObject,nX,nY| oMenux:Activate( nX, (nY-10), oObject ) }

oDlg3:Activate(,,,.T.)

If nOpcao == 1
    //oBtn9 gravar log aqui de alteração da configuração realizada pelo usuário
    lOk := .F.
    
    DbSelectArea("P97")
    DbSetOrder(1)
    For nCont := 1 to len(aList3B)
        If !Empty(aList3B[nCont,04])
            nPos := Ascan(aList2B,{|x| aList3B[nCont,04] $ x[8]  .And. !Empty(x[8])})
            
            If nPos > 0
                aAuxL2 := separa(aList2B[nPos,08],"/")

                For nX := 1 to len(aAuxL2)
                    nPosTb := ascan(aList2b,{|x| alltrim(x[1]) == alltrim(aAuxL2[nX])})
                            
                    If nPosTb > 0
                        If Dbseek(xFilial("P97")+cCodigo+cFilOrig+cFilDest+Avkey(aAuxL2[nX],"P97_CAMPO")+Avkey("","P97_CONTOR"))
                            Reclock("P97",.F.)
                            cConteudo := 'Usuario '+cusername+' Data '+cvaltochar(ddatabase)+' Hora '+cValToChar(time())+CRLF 
                            cConteudo += 'Conteudo Origem Anterior '+P97->P97_CONTOR+" / "
                            cConteudo += 'Conteudo Origem Atual '+aList3B[nCont,02]
                            cConteudo += 'Conteudo Destino Anterior '+P97->P97_CONTDE+" / "
                            cConteudo += 'Conteudo Destino Atual '+cvaltochar(aList3B[nCont,03])
                        Else 
                            If Dbseek(xFilial("P97")+cCodigo+cFilOrig+cFilDest+Avkey(aAuxL2[nX],"P97_CAMPO")+cvaltochar(aList3B[nCont,02]))
                                Reclock("P97",.F.)

                                cConteudo := 'Usuario '+cusername+' Data '+cvaltochar(ddatabase)+' Hora '+cValToChar(time())+CRLF 
                                cConteudo += 'Conteudo Origem Anterior '+P97->P97_CONTOR+" / "
                                cConteudo += 'Conteudo Origem Atual '+cvaltochar(aList3B[nCont,02])
                                cConteudo += 'Conteudo Destino Anterior '+P97->P97_CONTDE+" / "
                                cConteudo += 'Conteudo Destino Atual '+cvaltochar(aList3B[nCont,03])

                            Else 
                                Reclock("P97",.T.)
                                P97->P97_CODIGO := cCodigo
                                P97->P97_FILORI := cFilOrig
                                P97->P97_FILDES := cFilDest
                                P97->P97_CAMPO  := aAuxL2[nX]
                                P97->P97_CNPJ   := cCnpjOrig
                                P97->P97_CODEXT := Encode64(cCnpjOrig+alltrim(cFilOrig))
                                
                                P97->P97_TABELA :=  aList2B[nPosTb,05]
                                cConteudo := 'Usuario '+cusername+' incluiu em '+cvaltochar(ddatabase)+' Hora '+cvaltochar(time()) 

                                
                            EndIf
                        EndIf 

                        If !Empty(aList3B[nCont,02])
                            P97->P97_CONTOR := cvaltochar(aList3B[nCont,02])
                        EndIF 

                        If !Empty(aList3B[nCont,03])
                            P97->P97_CONTDE := cvaltochar(aList3B[nCont,03])
                        EndIF 

                        If !Empty(aList3B[nCont,05])
                            P97->P97_DESCTO := aList3B[nCont,05]
                        EndIf 

                        P97->P97_HISTOR := cConteudo

                        P97->(Msunlock())
                    EndIf 
                    lOk := .T.
                    
                Next nX 
            Else    
                nPosTb := ascan(aList2b,{|x| alltrim(x[1]) == alltrim(aList3B[nCont,04])})
                cConteudo := ''

                If nPosTb > 0
                               
                    If Dbseek(xFilial("P97")+cCodigo+cFilOrig+cFilDest+Avkey(aList3B[nCont,04],"P97_CAMPO")+Avkey("","P97_CONTOR"))
                        Reclock("P97",.F.)

                        cConteudo := 'Usuario '+cusername+' Data '+cvaltochar(ddatabase)+' Hora '+cValToChar(time())+CRLF 
                        cConteudo += 'Conteudo Origem Anterior '+P97->P97_CONTOR+" / "
                        cConteudo += 'Conteudo Origem Atual '+cvaltochar(aList3B[nCont,02])
                        cConteudo += 'Conteudo Destino Anterior '+P97->P97_CONTDE+" / "
                        cConteudo += 'Conteudo Destino Atual '+cvaltochar(aList3B[nCont,03])
                    Else 
                    
                        If Dbseek(xFilial("P97")+cCodigo+cFilOrig+cFilDest+Avkey(aList3B[nCont,04],"P97_CAMPO")+cvaltochar(aList3B[nCont,02]))
                            Reclock("P97",.F.)
                            cConteudo := 'Usuario '+cusername+' Data '+cvaltochar(ddatabase)+' Hora '+cValToChar(time())+CRLF 
                            cConteudo += 'Conteudo Origem Anterior '+P97->P97_CONTOR+" / "
                            cConteudo += 'Conteudo Origem Atual '+cvaltochar(aList3B[nCont,02])
                            cConteudo += 'Conteudo Destino Anterior '+P97->P97_CONTDE+" / "
                            cConteudo += 'Conteudo Destino Atual '+cvaltochar(aList3B[nCont,03])
                        Else 
                            Reclock("P97",.T.)
                            P97->P97_CODIGO := cCodigo
                            P97->P97_FILORI := cFilOrig
                            P97->P97_FILDES := cFilDest
                            P97->P97_CAMPO  := aList3B[nCont,04]
                            P97->P97_CNPJ   := cCnpjOrig
                            P97->P97_CODEXT := Encode64(cCnpjOrig+alltrim(cFilOrig))

                            P97->P97_TABELA :=  aList2B[nPosTb,05]

                            cConteudo := 'Usuario '+cusername+' incluiu em '+cvaltochar(ddatabase)+' Hora '+cvaltochar(time()) 

                            
                        EndIf
                    EndIf 

                    If !Empty(aList3B[nCont,02])
                        P97->P97_CONTOR := cvaltochar(aList3B[nCont,02])
                    EndIF 

                    If !Empty(aList3B[nCont,03])
                        P97->P97_CONTDE := cvaltochar(aList3B[nCont,03])
                    EndIF 

                    If !Empty(aList3B[nCont,05])
                        P97->P97_DESCTO := aList3B[nCont,05]
                    EndIf 

                    P97->P97_HISTOR := cConteudo

                    P97->(Msunlock()) 
                EndIf 
                lOk := .T.
                
            EndIf 
        EndIf 
    Next nCont 

    If lOk 
        // oBtn9:enable()
        FWAlertSuccess(" As configurações foram salvas !!!", "SUCESSO")
    EndIf 
EndIf 

oBtn2:enable()

RestArea(aArea)

Return

/*/{Protheus.doc} BuscaTemp(cCampo,aTabTmp[nAux,01])
    Busca dados da tabela temporaria agrupados por campo para realização do de/para
    @type  Static Function
    @author user
    @since 10/02/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaTemp(cCampo,cTabela)

Local aArea := GetArea()
Local cQuery 
Local aRetorno := {}

cQuery := "SELECT "+cCampo+",COUNT(*) "
cQuery += " FROM "+cTabela
cQuery += " GROUP BY "+cCampo

MPSysOpenQuery( cQuery, 'QRYTMP' )
DbSelectArea('QRYTMP')

While !EOF()
    Aadd(aRetorno,QRYTMP->&(cCampo))
    Dbskip()
EndDo 

RestArea(aArea)

Return(aRetorno)
/*/{Protheus.doc} AjustaDP()
    Ajustar o De/Para dos itens carregados
    @type  Static Function
    @author user
    @since 12/08/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function AjustaDP()

Local lOk       := .T.
Local cMsgFim   := ""
Local cArq      := ''
Local oLogDP    := Nil
Private aWizL   := {}
Private aItens  := {}
Private aCliTra   := {}
Private cJaProc := '' //De-Parar todos os campos iguais de uma vez só
Private cItemDP := ''

ctime := "Inicio "+cvaltochar(time())+CRLF 

Depara2()

cTime += "Final "+cvaltochar(time())+CRLF
Msgalert(ctime)

If !lOk 

    If !ExistDir('c:\temp')
        MakeDir('c:\temp')
    EndIf

    cArq := 'c:\temp\integramais_depara'+dtos(ddatabase)+strtran(cvaltochar(time()),":")+'.txt'

    oLogDP := FWFileWriter():New(cArq, .T.)
    If !oLogDP:Create()

        FWAlertError("Houve um erro ao gerar o arquivo de log do de-para: " + CRLF + oLogDP:Error():Message, "Atenção")

    Else
            
        oLogDP:Write(cMsgFim)
        oLogDP:Close()       
        fLogCont(cArq)

    EndIf

Else 
    lAjsDePa := .T.
EndIf 

FWAlertSuccess("De/Para Finalizado, verifique os dados !!!", "SUCESSO")

oBtn4:enable()

Return

/*/{Protheus.doc} replicar
    Replicar o de/para do item 
    @type  Static Function
    @author user
    @since 02/07/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Replicar(nLinha)

Local aArea     := GetArea()
Local nCont 
//aAux3
//aaux2
If MsgYesNo("Replicar todas as linhas abaixo com o conteúdo 'DE'?")
    For nCont := nLinha to len(aAux3)
        aAux3[nCont,3] := aAux3[nCont,2]
    Next nCont 
    For nCont := 1 to len(aList3B)
        aList3B[nCont,3] := aList3B[nCont,2]
    Next nCont 

EndIf 

oDp2:refresh()
oDlg3:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} HelpAux
    Atualiza o grid de De/Para dos itens
    @type  Static Function
    @author user
    @since 28/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function HelpAux()

Local nCont 

aAux3 := {}
oDp2:nAt := 1

For nCont := 1 to len(aList3B)
    If alltrim(aList3B[nCont,04]) $ alltrim(aAux2[oDp1:nAt,08])
        If Ascan(aAux3,{|x| alltrim(x[2]) == alltrim(aList3B[nCont,02])}) == 0
            Aadd(aAux3,aList3B[nCont])
        EndIf 
    EndIf 
Next nCont


If len(aAux3) < 1
    Aadd(aAux3,{'','','','',''})
EndIf 

oDp2:SetArray(aAux3)
oDp2:bLine := {||{  aAux3[oDp2:nAt,02],;
                    aAux3[oDp2:nAt,03],; 
                    aAux3[oDp2:nAt,05]}}

oDp2:refresh()
oDlg3:refresh()

Return

/*/{Protheus.doc} cargadepara
    Exporta planilha e importa com os dados de de/para
    @type  Static Function
    @author user
    @since 29/05/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function cargadepara()

Local aPergs    :=  {}
Local aRet      :=  {}
Local aOrdem    :=  {'1=Exportar','2=Importar'}
Local cOpcao    :=  ''
Local nCont 
Local aAux      :=  {}
Local nX,nY 
Local aCabec    :=  {}
Local cDir 
Local nL        :=  1
Local aDados    :=  {}
Local lOk       :=  .T.
Local aCampos   :=  {}
//Local lGrvNew   :=  .F.

aAdd( aPergs ,{2,"Ação?","1" , aOrdem , 100,'.T.',.F.})
	
If ParamBox(aPergs ,"Importar/Exportar?",@aRet)
    cOpcao := aRet[1]

    If cOpcao == '1'  
        /*
        tabela
        campo
        conteudo enviado
        conteudo de para totvs
        descricao conteudo totvs
        campos relacionados
        */  
        Aadd(aCabec,{'Tabela',;
                    'Campo',;
                    'Conteudo_Recebido',;
                    'Conteudo_Totvs',;
                    'Descricao_Totvs',;
                    'Campos_Relacionados'})
    
        For nX := 1 to len(aAux2)
            For nCont := 1 to len(aList3B)
                If alltrim(aList3B[nCont,04]) $ alltrim(aAux2[nX,08])
                    If Ascan(aAux,{|x| alltrim(x[2]) == alltrim(aList3B[nCont,02])}) == 0
                        Aadd(aAux,{aAux2[nX,05],;
                                    aAux2[nX,01],;
                                    aList3B[nCont,02],;
                                    aList3B[nCont,03],;
                                    aList3B[nCont,05],;
                                    aAux2[nX,08]})
                    EndIf 
                EndIf 
            Next nCont
        Next nX 

        PlanDP(aCabec,aAux)
    Else 
        cMascara  := "Arquivos CSV|*.CSV"
        cTitulo   := "Escolha o arquivo"
        nMascpad  := 0
        cDirini   := "\"
        lSalvar   := .F. 
        nOpcoes   := GETF_LOCALHARD
        lArvore   := .F.
        //cDir := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar, nOpcoes, lArvore)
        cDir := tFileDialog(cMascara, cTitulo, nMascpad, cDirIni, lSalvar, nOpcoes)
        
        If Empty(cDir)
            Return
        Else    
            oFile := FWFileReader():New( cDir )

            If (oFile:Open())
        
                While (oFile:hasLine())
                    cTexto := oFile:GetLine()
                    If !Empty(cTexto)
                        If nL == 1
                            Aadd(aCabec,Separa(cTexto, ";", .T.))
                        Else
                            AADD(aDados, Separa(cTexto, ";", .T.))
                        EndIf
                    EndIf
                    nL++
                EndDo

                oFile:Close()

                For nX := 1 to len(aDados)
                    If Empty(aDados[nX,04])
                        FWAlertWarning("Não informado o De/Para na linha "+cvaltochar(nX+1), 'Atenção')
                        lOk := .F.
                    EndIf
                Next nX 

                If lOk 
                    Asort(aList3B,,,{|x,y| x[4] < y[4]})
                    Asort(aListB3,,,{|x,y| x[4] < y[4]})
                    For nX := 1 to len(aDados)
                        aCampos := Separa(aDados[nX,06],"/")
                        For nL := 1 to len(aCampos)
                            nPosL3 := Ascan(aList3B,{|x| alltrim(x[4]) == alltrim(aCampos[nL]) })
                            If nPosL3 > 0
                                For nY := nPosL3 to len(aList3B)
                                    If aList3B[nY,04] <> aCampos[nL]
                                        exit 
                                    EndIf

                                    If alltrim(aList3B[nY,02]) <> alltrim(aDados[nX,03])
                                        loop 
                                    EndIf 

                                    aList3B[nY,03] := aDados[nX,04]
                                    aList3B[nY,05] := aDados[nX,05]
                                    aListB3[nY,03] := aDados[nX,04]
                                    aListB3[nY,05] := aDados[nX,05]
                                    
                                Next nY
                            EndIf 
                        Next nL 
                    Next nX 
                    
                    FWAlertSuccess("Arquivo carregado com sucesso!!!", "SUCESSO!")
                EndIF 
            else
                FWAlertWarning("Arquivo não encontrado!!!","Atenção !!")
                Return
            EndIf
        EndIf
    EndIF 
EndIf 

Return
/*/{Protheus.doc} xtrcrel
    Muda o relacionamento dos itens a serem feitos de para
    @type  Static Function
    @author user
    @since 21/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xtrcrel(cOpcao)

Local aArea := GetArea()
Local nCont := 1

If "FILIAL" $ Alltrim(aList2[oList2:nAt,01])
    Return 
EndIf 

If cOpcao == "1"
    For nCont := 1 to len(aList3B)
        If Alltrim(aList3B[nCont,04]) == Alltrim(aList2[oList2:nAt,01])
            aList3B[nCont,02] := '*'
            aList3B[nCont,03] := space(aList2[oList2:nAt,3])
        EndIf 
    Next nCont
ElseIf cOpcao == "I"
    For nCont := 1 to len(aListB3)
        If Alltrim(aList3B[nCont,04]) == Alltrim(aListB3[nCont,04]) .And. Alltrim(aListB3[nCont,04]) == Alltrim(aList2[oList2:nAt,01])
            aList3B[nCont,06] := If(Empty(aList3B[nCont,06]),'I','')
        EndIf 
    Next nCont
ElseIf cOpcao == "N"
    For nCont := 1 to len(aListB3)
        If Alltrim(aList3B[nCont,04]) == Alltrim(aListB3[nCont,04]) .And. Alltrim(aListB3[nCont,04]) == Alltrim(aList2[oList2:nAt,01])
            aList3B[nCont,01] := .F.
            aList3B[nCont,02] := aListB3[nCont,02]
            aList3B[nCont,03] := aListB3[nCont,03]
        EndIf 
    Next nCont
EndIf 

FHelp2()

RestArea(aArea)

Return

/*/{Protheus.doc} CargaDados
    Busca os dados ja contidos nas tabelas de destino
    @type  Static Function
    @author user
    @since 21/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function CargaDados(lChkBox)

Local aArea     := GetArea()
Local cQuery
Local nCont 
Local nCont2
Local cBarra    := ''
Local aAux1     := separa(cTabRsg,"/")
Local cTabOk    := ""
Local aTabOk    := {}
Local cToken    := cCnpjOrig 
Local nX,nZ,nW,nY 
Local aSepCN9 := {}
Local aStruQry := {}
Local lTemdados := .F.
Local aConteL3  :=  {}
Local aIndTmp   :=  {}
Local cDescons := 'Todos/SXs/RD0/Cópia Tabelas/PN1'
Local aTrocVir  :=  {}

Private aListP98 := {}

///RETIRANDO O TITPAI DA VARIAVEL APENAS PARA PODER CRIAR O CAMPO TEMPORARIO CORRETO
cParamd := strtran(cParamd,"TITPAI/","/")

cToken := cCnpjOrig 

If Empty(cFilOrig)
    MsgAlert("Não foi informado a filial de origem dos dados")
    Return 
EndIf 

Aeval(aDadosDet,{|x| cTabOk += If(!x[1][1] $ cTabOk, x[1][1]+'/','')})
Aeval(aList1,{|x| x[3] := 0})
Aeval(aList1,{|x| x[4] := 0})

CTIME := TIME()+CRLF 

cQuery := "SELECT /*PARALLEL(16)*/ P98_COD,P98_DATA,P98_HORA,P98_STATUS,R_E_C_N_O_ AS RECNOP98,P98_TABELA,"
cQuery += " (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,1))) "
cQuery += " || (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,2001))) "
cQuery += " || (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,4001))) "
cQuery += " || (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,6001))) "
cQuery += " || (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,8001))) "
cQuery += " || (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,10001))) AS JSON"
cQuery += " FROM "+RetSQLName("P98")
cQuery += " WHERE D_E_L_E_T_=' '"
cQuery += " AND P98_FILIAL='"+xFilial("P98")+"'" 
cQuery += " AND P98_CALLBA='"+cToken+"'"

If !lChkBox
    cQuery += " AND P98_STATUS IN('0','5')"
EndIf

If cTabRsg <> "Todos"
    cQuery += " AND P98_TABELA IN('"
    For nCont := 1 to len(aAux1)
        cQuery += cBarra + aAux1[nCont]
        cBarra := "','"
    Next nCont 

    cQuery += "')"
EndIf 

If !Empty(cTabOk)
    cBarra := ""
    aTabOk := separa(cTabOk,"/")
    cQuery += " AND P98_TABELA NOT IN('"

    For nCont := 1 to len(aTabOk)
        If !Empty(aTabOk[nCont])
            cQuery += cBarra + aTabOk[nCont]
            cBarra := "','"
        Endif 
    Next nCont 
    
    cQuery += "')"
EndIf 

If "CN9" $ cTabRsg
    //nCN9    := 0      // somente para contratos - Quantidade de CN9
    aCNs    := {{'CN9',0},{'CNA',0},{'CNC',0},{'CNB',0}}
    If !Empty(cFilPesq)
        If "," $ cFilPesq
            aSepCN9 := separa(cFilPesq,",")
            cSepCn9 := ""

            cQuery += " AND ("
            
            For nCont2 := 1 to len(aSepCN9)
                cQuery += cSepCn9 + " ((UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,1)))"
                cQuery += "  || (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,2001)))"
                cQuery += "  || (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,4001)))"
                cQuery += "  || (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,6001)))"
                cQuery += "  LIKE '%"+alltrim(aSepCN9[nCont2])+"%')"
                cSepCn9 := " OR "
            Next nCont 

            cQuery += " ) "

        Else 
            cQuery += " AND  (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,1)))"
            cQuery += "  || (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,2001)))"
            cQuery += "  || (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,4001)))"
            cQuery += "  || (UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(P98_BODY,2000,6001)))"
            cQuery += "  LIKE '%"+alltrim(cFilPesq)+"%'"
        EndIf 
    EndIf 
EndIf 

//cQuery += " AND ROWNUM <= 100"
cQuery += " ORDER BY P98_TABELA"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

cTable := ''
nTotalJson := 0
aCpoJson := {}
cIniTemp := time()
While !EOF()
    
    oBody := nil
    oBody := JsonObject():New()
    oBody:fromJson(TRB->JSON)

    If cTable <> upper(oBody['table'])
        lTemdados := .T.
        
        cTable      := upper(oBody['table'])
        cCmpJson    := oBody['fields']
        aCpoJson    := cCmpJson:GetNames()
        nTotalJson  := len(aCpoJson)
        aStruQry    := {}
    
        For nCont := 1 to nTotalJson
            aAux := FWSX3Util():GetFieldStruct( aCpoJson[nCont] )
            If len(aAux) > 0
                Aadd(aStruQry,aAux)
            EndIF
        Next nCont
        
        cQuery := ""
        cBarra := ""
        For nCont := 1 to len(aStruQry)
            cTexto := ""
            If aStruQry[nCont,02]=="C"
                If ALLTRIM(SUBSTR(aStruQry[nCont,01],AT("_",aStruQry[nCont,01])+1)) $ Alltrim(cParamd)
                    cTexto := ' VARCHAR(14)'
                else 
                    cTexto := ' VARCHAR('+cvaltochar(aStruQry[nCont,03])+')'
                endif 
            ElseIf aStruQry[nCont,02]=="N"
                cTexto := ' NUMBER '
            ElseIf aStruQry[nCont,02]=="D"
                cTexto := ' VARCHAR('+cvaltochar(aStruQry[nCont,03])+')'
            ElseIf aStruQry[nCont,02]=="M"
                cTexto := ' VARCHAR(1024)'
            EndIf 
            cQuery += cBarra +alltrim(aStruQry[nCont,01])+' '+cTexto 
            cBarra := ","
        Next nCont 
        
        cQuery += cBarra + PrefixoCPO(cTable)+'_P98REC NUMBER'
        cQuery += cBarra + PrefixoCPO(cTable)+'_P98STA VARCHAR(1)'

        cAliasX := If(cEmpAnt=="00","BR",IF(cEmpAnt=="60","DM","MI"))+"P98"+cTable+cCodigo
        
        If !xVldTbBco(cAliasX) 
            If fCreateTable(cQuery,cAliasX)
                If Ascan(aTabTmp,{|x| x[1] == AllTrim(cAliasX)}) == 0
                    Aadd(aTabTmp,{cAliasX,cTable})
                EndIf
                cQuery := " SELECT * FROM "+cAliasX+" "
                If Select(cAliasX) > 0
                    (cAliasX)->(dbCloseArea())
                EndIf

                DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), cAliasX, .T., .T. )
                DbSelectArea(cAliasX)

            EndIf
        EndIf

        If Ascan(aTabTmp,{|x| x[1] == AllTrim(cAliasX)}) == 0
            Aadd(aTabTmp,{cAliasX,cTable})
        EndIf 

    EndIf 
    
    
    cQuery := "INSERT INTO "+cAliasX+"("
    cBarra := ""
    cConteudo := ""

    For nCont := 1 to len(aStruQry)
        cCampo := alltrim(aStruQry[nCont,01])
        cQuery += cBarra + cCampo 
        
        If aStruQry[nCont,02] == "N" 
            If Empty(oBody['fields'][alltrim(aStruQry[nCont,01])])
                cConteudo += cBarra + '0'
            Else
                cConteudo += cBarra + cvaltochar(oBody['fields'][alltrim(aStruQry[nCont,01])])
            EndIf
        Else 
            cNewCnt := ""
            If Empty(cvaltochar(oBody['fields'][alltrim(aStruQry[nCont,01])]))
                cNewCnt := cvaltochar(oBody['fields'][alltrim(aStruQry[nCont,01])])
            else 
                cNewCnt := alltrim(cvaltochar(oBody['fields'][alltrim(aStruQry[nCont,01])]))
            endif 
            cNewCnt := strtran(cNewCnt,"'","")
            If len(cNewCnt) > aStruQry[nCont,03] .And. !SUBSTR(cCampo,AT("_",cCampo)+1,6) $ Alltrim(cParamd)
                cNewCnt := substr(cNewCnt,1,aStruQry[nCont,03])
            EndIf 
            cConteudo += cBarra + "'" + cNewCnt + "'"

            If "<" $ cNewCnt    
                If Ascan(aTrocVir,{|x| x[2] == cCampo}) == 0
                    aadd(aTrocVir,{cAliasX,cCampo})
                EndIf 
            EndIf 
        EndIf 
        cBarra := ","
    Next nCont 

    cQuery += cBarra + PrefixoCPO(cTable)+'_P98REC'
    cQuery += cBarra + PrefixoCPO(cTable)+'_P98STA'

    cConteudo += cBarra + cvaltochar(TRB->RECNOP98)
    cConteudo += cBarra + "'" + TRB->P98_STATUS + "'"
    cQuery += ") VALUES ("+cConteudo+")"
    
    nResult := TCSQLEXEC(cQuery) 

    DbselectArea("TRB")
    Dbskip()
EndDo 

//Este ponto foi colocado por conta das virgulas que são colocadas no arquivo de clientes SA1
//na ultima validação a usuaria informou que os campos de endereço deveriam ficar com as virgulas conforme planilha
//como a virgula quebra o json, no script estou trocando a virgula por < e aqui na tabela temporaria voltaremos a virgula para o campo 
//GEAN - DEPOIS AJUSTA AQUI PARA UTILIZAR A QUERY DO SEGUNDO EXEMPLO PARA OS CASOS DE DUAS TABELAS
If len(aTrocVir) > 0
    /*  EXEMPLO 1
        UPDATE TABELA
        SET A1_END = REPLACE(A1_END, '<', ',')
        WHERE A1_END LIKE '%<%';
    */
    For nCont := 1 to len(aTrocVir)
        cQuery := " UPDATE "
        cQuery += aTrocVir[nCont,01]
        cQuery += " SET "+aTrocVir[nCont,02]+" = REPLACE("+aTrocVir[nCont,02]+", '<', ',')"
        cQuery += " WHERE "+aTrocVir[nCont,02]+" LIKE '%<%'"
        nResult := TCSQLEXEC(cQuery)

    Next nCont 

    /* EXEMPLO 2
            UPDATE TABELA
        SET 
            A1_END = REPLACE(A1_END, '<', ','),
            A1_COMPLEM = REPLACE(A1_COMPLEM, '<', ','),
            A1_BAIRRO = REPLACE(A1_BAIRRO, '<', ',')
        WHERE 
            A1_END LIKE '%<%' 
            OR A1_COMPLEM LIKE '%<%' 
            OR A1_BAIRRO LIKE '%<%'
    */
EndIf 

cFimTemp := time()
cTempoTo := ElapTime(cIniTemp,cFimTemp)
MsgAlert('Tempo com temporaria '+cvaltochar(cTempoTo))

If lTemdados 
    cBarra := ""
    cQuery := "UPDATE "+RetSQLName("P98") +" SET P98_STATUS='3' WHERE D_E_L_E_T_=' '"
    cQuery += " AND P98_STATUS IN('0','5')"

    If cTabRsg <> "Todos"
        cQuery += " AND P98_TABELA IN('"
        For nCont := 1 to len(aAux1)
            cQuery += cBarra + aAux1[nCont]
            cBarra := "','"
        Next nCont 

        cQuery += "')"
    EndIf 

    If !Empty(cTabOk)
        cBarra := ""
        aTabOk := separa(cTabOk,"/")
        cQuery += " AND P98_TABELA NOT IN('"

        For nCont := 1 to len(aTabOk)
            If !Empty(aTabOk[nCont])
                cQuery += cBarra + aTabOk[nCont]
                cBarra := "','"
            Endif 
        Next nCont 
        
        cQuery += "')"
    EndIf 

    TCSQLEXEC(cQuery) 
Else
    If !cTabRsg $ cDescons
        For nCont := 1 to len(aAux1)
            cTable := aAux1[nCont]
            cAliasX := If(cEmpAnt=="00","BR",IF(cEmpAnt=="60","DM","MI"))+"P98"+cTable+cCodigo
            If xVldTbBco(cAliasX) 
                Aadd(aTabTmp,{cAliasX,cTable})
            EndIf 
        Next nCont 
    Else 
        If cTabRsg == 'Todos'
            For nCont := 1 to len(aList1)
                cTable := aList1[nCont,01]
                cAliasX := If(cEmpAnt=="00","BR",IF(cEmpAnt=="60","DM","MI"))+"P98"+cTable+cCodigo
                If xVldTbBco(cAliasX) 
                    Aadd(aTabTmp,{cAliasX,cTable})
                EndIf 
            Next nCont 
        EndIf 
    Endif 
EndIF 


For nCont := 1 to len(aTabTmp)

    cQuery := "SELECT COUNT(*) AS QTD FROM "+ aTabTmp[nCont,01]+" WHERE " + PrefixoCPO(aTabTmp[nCont,02]) + "_P98STA = '0'"

    MPSysOpenQuery( cQuery, 'QRYTMP' )
    DbSelectArea('QRYTMP')

    nPos := ascan(aList1,{|x| x[1] == aTabTmp[nCont,02]})

    If nPos > 0
        aList1[nPos,03] := QRYTMP->QTD
        aList1[nPos,04] := 2
    EndIf

Next nCont 
/*
If len(aListP98) > 0
    //ordenar pela tabela para melhorar o processamento de leitura do json na rotina de desserialização
    Asort(aListP98,,,{|x,y| x[8] < y[8]})

    If len(aListP98) > 150  .And. Empty(cFilPesq)
        If MsgYesNo("Existem "+cValToChar(len(aListP98))+" registros para serem processados, deseja processar uma quantidade menor?","CargaDados - TINCWH01")
            AAdd( aPergs ,{1,"Qtd a Processar",Space(5),"@E 99999","","","", 50, .T. } )
            
            If ParamBox(aPergs ,"Informe a Qtd",@aRet)
                nQtdPrc := val(aRet[1])
            EndIf 
        EndIf 

    EndIf 
    cIniTemp := time()
    LerJson2(nQtdPrc)
    cFimTemp := time()
    cTempoTo := ElapTime(cIniTemp,cFimTemp)
    
    MSGALERT("Tempo de leitura json "+cTempoTo)
EndIf
*/

For nCont := 1 to len(aList2B)
    
    nTabL3    := Ascan(aAux1,{|x| x == aList2B[nCont,05]}) 

    If nTabL3 > 0
        nAux  := Ascan(aTabTmp,{|x| x[2] == alltrim(aAux1[nTabL3])})
        If nAux > 0
            cCampo := alltrim(aList2B[nCont,01])
            If Ascan(aList3B,{|x| x[4] == alltrim(cCampo)}) == 0
                aConteL3 := BuscaTemp(cCampo,aTabTmp[nAux,01])
                For nZ := 1 to len(aConteL3)
                    Aadd(aList3B,{  .F.,;
                            aConteL3[nZ],;
                            If("FILIAL" $ alltrim(upper(cCampo)),cFilDest,""),;
                            alltrim(upper(cCampo)),;
                            If("FILIAL" $ alltrim(upper(cCampo)),cNomeFil,""),;
                            ''})
                Next nZ 
            EndIf 
        EndIf 
    Else 
        For nY := 1 to len(aAux1)
            If PrefixoCPO(aAux1[nY])+"_" $ aList2B[nCont,08]
                aAuxL3 := separa(aList2B[nCont,08],"/")
                Asort(aAuxL3,,,{|x,y| x < y})
                cPrefixo := PrefixoCPO(aAux1[nY])+"_"
                nTamPrx  := len(cPrefixo)
                nPosL3 := Ascan(aAuxL3,cPrefixo)
                For nW := nPosL3 to len(aAuxL3)
                    If substr(aAuxL3[nW],1,nTamPrx) <> cPrefixo 
                        exit 
                    EndIf 
                    cCampo := alltrim(aAuxL3[nW])
                    If Ascan(aList3B,{|x| x[4] == alltrim(cCampo)}) == 0
                        aConteL3 := BuscaTemp(cCampo,aAux1[nY])
                        For nZ := 1 to len(aConteL3)
                            Aadd(aList3B,{  .F.,;
                                    aConteL3[nZ],;
                                    If("FILIAL" $ alltrim(upper(cCampo)),cFilDest,""),;
                                    alltrim(upper(cCampo)),;
                                    If("FILIAL" $ alltrim(upper(cCampo)),cNomeFil,""),;
                                    ''})
                        Next nZ 
                    EndIf 
                Next nW 
            EndIf 
        Next nY 
    EndIf 

Next nCont 

For nCont := 1 to len(aTabTmp)
    aIndTmp := IndcTmp(aTabTmp[nCont,01])
    For nX := 1 to len(aList3B)
        If !Empty(aList3B[nX,04])
            cCampo := aList3B[nX,04]
            nPos := Ascan(aIndTmp,{|x| alltrim(x) == "IDX_"+aTabTmp[nCont,01]+"_"+cCampo})
            If nPos == 0 .And. AliasCpo(cCampo) == aTabTmp[nCont,02]
                IF fCreateIdx(aTabTmp[nCont,01],cCampo)
                    Aadd(aIndTmp,"IDX_"+aTabTmp[nCont,01]+"_"+cCampo)
                EndIf 
            EndIf 
        EndIf 
    Next nX 
Next nCont 

aListB3 := aClone(aList3B)

lCarga := .T.

If Ascan(aList1,{|x| x[1] == substr(cTabRsg,1,3)}) > 0
    oList1:nAt := Ascan(aList1,{|x| x[1] == substr(cTabRsg,1,3)})
EndIf 

Fhelp()
Fhelp2()

oGet1:disable()
oGet2:disable()
oList1:refresh()
oDlg1:refresh()

// If lChkBox .And. Len(aDadosDet) > 0
//     oTM3Item5:Enable()
// EndIf

dbCloseArea()

RestArea(aArea)    

Return

/*/{Protheus.doc}  Verificar se a tabela temporaria esta criada no banco
    @type  Static Function
    @author user
    @since 11/02/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xVldTbBco(cTabela)

Local aArea := GetArea()
Local cQuery := "SELECT COUNT(*) AS QTD FROM ALL_TABLES WHERE TABLE_NAME ='"+cTabela+"'"
Local lRet   := .F.

If Select("QRTTBL") > 0
    ("QRTTBL")->(dbCloseArea())
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QRTTBL", .T., .T. )
DbSelectArea("QRTTBL")

If QRTTBL->QTD > 0
    lRet := .T.
EndIf 

RestArea(aArea)
    
Return(lRet)

/*/{Protheus.doc} IndcTmp
    verificando os indices das tabelas temporarias
    @type  Static Futhor user
    @since 12/02/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function IndcTmp(cTabela)

Local aArea := GetArea()
Local aRet  := {}

cQuery := "SELECT INDEX_NAME"
cQuery += " FROM USER_INDEXES"
cQuery += " WHERE TABLE_NAME = '"+cTabela+"'"

If Select("QRTTBL") > 0
    ("QRTTBL")->(dbCloseArea())
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QRTTBL", .T., .T. )
DbSelectArea("QRTTBL")

While !EOF()
    Aadd(aRet,Alltrim(INDEX_NAME))
    Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)
/*/{Protheus.doc} fCreateTable
    Criar uma tabela temporaria com os dados do json
    @type  Static Function
    @author user
    @since 07/02/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fCreateTable(cSelect, cTab)

    Local cScript   := ''
    Local lRet      := .T.

    cScript := "CREATE TABLE "+cTab
    cScript += "("+cSelect+")"

    IF TCSQLEXEC(cScript) <> 0
        UserException( "Não Foi Possível criar a tabela "+ cTab + CRLF + TCSqlError()   )
        lRet := .F.
    EndIf


Return lRet

/*/{Protheus.doc} EstructTemp
    Busca a estrutura da tabela temporaria criada
    @type  Static Function
    @author user
    @since 12/02/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function EstructTemp(cTabela)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery 

cQuery := "SELECT COLUMN_NAME"
cQuery += " FROM USER_TAB_COLUMNS"
cQuery += " WHERE TABLE_NAME = '"+cTabela+"'"

If Select("QRTTBL") > 0
    ("QRTTBL")->(dbCloseArea())
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QRTTBL", .T., .T. )
DbSelectArea("QRTTBL")

While !EOF()
    Aadd(aRet,Alltrim(QRTTBL->COLUMN_NAME))
    Dbskip()
Enddo 

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} DetalhaDados
    Carrega os dados importados na transitoria para verificação
    @type  Static Function
    @author user
    @since 23/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function DetalhaDados(cTabela)

Local nCont
Local cPrmRun    := AllTrim(SuperGetMv('TI_TINCH2',.F.,Decode64('NDE4MjE0LzI3NjEwNS9hLnZlbmFuY2lv')))
Local nPosTab    := Ascan(aTabTmp,{|x| x[2] == cTabela})

Private oDlg2,oGrpD1,oBtnD1,oBtnD2
Private oListD1 
Private aListaD1 := {}
Private aCabeca  := If(nPosTab>0,EstructTemp(aTabTmp[nPosTab,01]),{}) //{'','Conteúdo Origem','Conteúdo Destino','Descrição Totvs'}
Private aTamanho := {} //{10,90,90,90}
Private aAux     := {}
Private aAuxCab  := {}
Private aAuxTam  := {}
Private aAuxItm  := {}
Private lCabec   := .F.
Private oFontTit    := TFont():New('Verdana', , -13, , .T.)

cUnKey  := FWX2Unico( cTabela )
aUnKey  := Separa(cUnKey,"+")
cScan   := ""
cPlus   := ""
cSCAx   := ""
cSCSr   := ""

If nPosTab > 0
    cQuery := "SELECT * FROM "+aTabTmp[nPosTab,01]
    cQuery += " WHERE " + PrefixoCPO(aTabTmp[nPosTab,02]) + "_P98STA IN ('0','5')"

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")

    While !EOF()
        aAuxItm := {}
        For nCont := 1 to len(aCabeca)
            Aadd(aAuxItm,&(aCabeca[nCont]))
        Next nCont 
        Aadd(aListaD1,aAuxItm)
        Dbskip()
    EndDo 
EndIf 

If len(aListaD1) > 0

    Asort(aListaD1,,,{|x,y| &(cScan) < &(cSCSr)})

    oDlg2      := MSDialog():New( 086,215,856,1850,"Dados Carregados na integração",,,.F.,,,,,,.T.,,,.T. )

        oGrpD1     := TGroup():New( 004,004,356,804,"Tabela "+cTabela,oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
            //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,352,800},,, oGrpD1 ) 
            oListD1:= 	TCBrowse():New(012,008,790,340,, aCabeca /*{'','Conteúdo Origem','Conteúdo Destino','Descrição Totvs'}*/,;
                                    aTamanho /*{10,90,90,90}*/,;
                                    oGrpD1,,,,{|| },{|| /*editcol(oList1:nAt,0)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

            oListD1:SetArray(aListaD1)

            xLinGrid(aListaD1,len(aListaD1[1]))
            
            
        oSayd1      := TSay():New( 360,020,{||'Quantidade de Registros '+cvaltochar(len(aListaD1))},oGrpD1,,oFontTit,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
        
        //oBtnD1     := TButton():New( 360,200,"Processar",oDlg2,{|| Processa(AtualItem(cTabela))},037,012,,,,.T.,,"",,,,.F. )
 
        If RetCodUsr() $cPrmRun .OR. cUsrLog $cPrmRun
            oBtnD3     := TButton():New( 360,350,"Re-Processar",oDlg2,{|| FWMsgRun(, {|| ReproTab(cTabela)},"","Processando os dados...")},037,012,,,,.T.,,"",,,,.F. )
        EndIf

        oBtnD4     := TButton():New( 360,400,"Ver Json",oDlg2,{|| FWMsgRun(, {|| VerJson()},"","Processando os dados...")},037,012,,,,.T.,,"",,,,.F. )
        

        oBtnD2     := TButton():New( 360,500,"Sair",oDlg2,{|| oDlg2:end()},037,012,,,,.T.,,"",,,,.F. )

    oDlg2:Activate(,,,.T.)

    oBtn9:enable()
Else 

    MsgAlert("Não encontrado dados referente a esta tabela")

EndIf 

Return

/*/{Protheus.doc} ReproTab(cTabela)
    (long_description)
    @type  Static Function
    @author user
    @since 10/09/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ReproTab(cTabela)

Local aArea := GetArea()
Local nCont := 1
Local nK 
Local nPosStr := Ascan(aEstrX3,{|x| x[len(x)] == cTabela})
Local cTipo := ""

For nCont := 1 to len(aListaD1)

    nRecnoDs := 0
    cQuery := " "
    cQuery += " SELECT DISTINCT PWU_RECNDS FROM " + RetSQLName("PWU") + "        " 
    cQuery += " WHERE PWU_FILIAL='" + FwxFilial("PWU") + "'      " 
    cQuery += " AND PWU_TABELA='"+cTabela+"' " 
    cQuery += " AND PWU_RECN98="+cvaltochar(aListaD1[nCont,len(aListaD1[nCont])]) 
    cQuery += " AND D_E_L_E_T_=' '      " 

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")

    nRecnoDs := TRB->PWU_RECNDS

    If nRecnoDs > 0

        DbSelectArea(cTabela)

        DbGoto(nRecnoDs)
        Reclock(cTabela,.F.)

        For nK := 1 to len(aCabeca)-1
            nPosCpo     := Ascan(aEstrX3[nPosStr],{|x| x[1] == aCabeca[nK]})
            cConteudo   := ""
            cTipo       := valtype(aListaD1[nCont,nK])
            
            //A1_VEND, A1_CODTER, A1_CODMEMB, A1_XGAR 
            //VALIDAR SE VAMOS TROCAR OU NAO
            If aEstrX3[nPosStr,nPosCpo,2] == "C" .And. cTipo <> "C" .And. aEstrX3[nPosStr,nPosCpo,1] <> 'A1_COD'
                cConteudo := cvaltochar(aListaD1[nCont,nK])
            ElseIf aEstrX3[nPosStr,nPosCpo,2] == "N" .And. cTipo <> "N"
                cConteudo := val(aListaD1[nCont,nK])
            ElseIf aEstrX3[nPosStr,nPosCpo,2] == "D" .And. cTipo <> "D"
                cConteudo := ctod(aListaD1[nCont,nK])
            Else 
                cConteudo := aListaD1[nCont,nK]
            EndIF 

            If !(&(cTabela+"->"+aCabeca[nK]) == cConteudo)
                If aEstrX3[nPosStr,nPosCpo,1] == 'A1_CNAE'
                    &(cTabela+"->"+aCabeca[nK]) := Transform( AllTrim(cConteudo), "@R 9999-9/99" )
                Else
                &(cTabela+"->"+aCabeca[nK]) := cConteudo
                EndIf
            EndIf 
        Next nK 
        
        &(cTabela)->(Msunlock())

    EndIf 

Next nCont 

RestArea(aArea)

FWAlertSuccess("Processo Finalizado", "ReproTab")
    
Return

/*/{Protheus.doc} AtualItem()
    Atualiza tela com os de/para para conferencias
    @type  Static Function
    @author user
    @since 27/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function AtualItem(cTabela,nOpc)

Local nX,nY,nZ
Local nCont
Local cCampo    :=  ''

Default nOpc := 1

For nX := 1 to len(aList3B)
    If !Empty(aList3B[nX,03])
        cCampo := Alltrim(aList3B[nX,04])

        For nY := 1 to len(aDadosDet)
            For nZ := 1 to len(aDadosDet[nY])
                If aDadosDet[nY,nZ,01] == cTabela .And. Alltrim(aDadosDet[nY,nZ,02]) == Alltrim(aList3B[nX,04])
                    For nCont := 1 to len(aListaD1)
                        If alltrim(aListaD1[nCont,nZ]) == alltrim(aList3B[nX,02])
                            aListaD1[nCont,nZ] := aList3B[nX,03]
                        EndIf 
                    Next nCont
                EndIf 
            Next nZ
        Next nY 
    EndIF 
Next nX

If nOpc == 1
    oListD1:SetArray(aListaD1)
    xLinGrid(aListaD1,0)
EndIf 

Return

/*/{Protheus.doc} ListDePa
    (long_description)
    @type  Static Function
    @author user
    @since 01/04/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ListDePa(cTabela)

Local aArea     := GetArea()
Local nCont     := 0
Local nCont2    := 0
Local nAux      := 0
Local aLocD1    := {}

Private aCabeca  := {} 
Private aTamanho := {} 
Private aAux     := {}
Private aAuxCab  := {}
Private aAuxTam  := {}
Private aAuxItm  := {}
Private lCabec   := .F.

cUnKey  := FWX2Unico( cTabela )
aUnKey  := Separa(cUnKey,"+")
cScan   := ""
cPlus   := ""
cSCAx   := ""
cSCSr   := ""
cSeek   := ""

For nCont := 1 to len(aDadosDet)
    For nAux := 1 to len(aDadosDet[nCont])
        If aDadosDet[nCont,nAux,01] <> cTabela
            exit 
        Else 
            If Empty(cScan)
                For nCont2 := 1 to len(aUnKey)
                    nPos := Ascan(aDadosDet[nCont],{|x| alltrim(x[2]) == alltrim(aUnKey[nCont2])})
                    If nPos > 0
                        cScan += cPlus+"x["+cvaltochar(nPos)+"]"
                        cSCSr += cPlus+"y["+cvaltochar(nPos)+"]"
                        cSCAx += cPlus+"aAuxItm["+cvaltochar(nPos)+"]"
                        cSeek += cPlus+"Avkey(aListaD1[nX,"+cvaltochar(nPos)+"],'"+alltrim(aUnKey[nCont2])+"')"
                        cPlus := "+"
                    EndIf 
                Next nCont2
            EndIf 
        EndIf 

        If !lCabec 
            Aadd(aAuxCab,aDadosDet[nCont,nAux,02])
            Aadd(aAuxTam,30)
            If len(aAuxCab) >= len(aDadosDet[nCont])
                lCabec := .T.
                aCabeca := aAuxCab
                aTamanho:= aAuxTam
            EndIf 
        EndIf 

        Aadd(aAuxItm,alltrim(aDadosDet[nCont,nAux,03]))

    Next nAux

    If len(aAuxItm) > 0 
        If Ascan(aLocD1,{|x| &(cScan) == &(cSCAx) }) == 0
            Aadd(aListaD1,aAuxItm)
            Aadd(aListaD1[len(aListaD1)],cTabela)
            Aadd(aListaD1[len(aListaD1)],cSeek)
            Aadd(aLocD1,aAuxItm)
        EndIf 
    Endif 

    aAuxItm := {}

Next nCont 

RestArea(aArea)

Return
/*/{Protheus.doc} edtdepar
    Edita as colunas que serão realizados o de para das tabelas.
    @type  Static Function
    @author user
    @since 26/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function edtdepar(nLinha)

Local nPosCol := oDp2:nColpos
Local aBkpX3D 
Local cBackup 
Local nCont 
Local aAux 
Local cBkpCpo
Local lOk     := .F.

If nPosCol == 2
    cBackup := aAux3[nLinha,nPosCol]
    cBkpCpo := aAux3[nLinha,nPosCol+1]
    aAux3[nLinha,nPosCol] := aAux3[nLinha,nPosCol+1]

    If Empty(aAux3[nLinha,nPosCol])
        aAux3[nLinha,nPosCol] := Avkey(aAux3[nLinha,nPosCol],alltrim(aAux3[nLinha,4]))
    EndIf 

    If !Empty(aAux2[oDp1:nAt,04])
        lOk := Conpad1(,,,Alltrim(aAux2[oDp1:nAt,04]),,,.F.)
        DbSelectArea("SXB")
        DbSetOrder(1)
        
        cRet := ''

        If lOk
            If DbSeek(aAux2[oDp1:nAt,04]+'5')  //Verifica se existe o cadastro na SXB para a consulta
                aBkpX3D := FWSX3Util():GetAllFields( Substr(&("SXB->XB_CONTEM"),1,3) , .F. )
                cRet  := &(&("SXB->XB_CONTEM"))
            Else 
                cRet  := &("SX5->X5_CHAVE")
                aAux3[nLinha,5] := &("SX5->X5_DESCRI")
            EndIf

            If !Empty(cRet)
                If !"SF4" $ &(&("SXB->XB_CONTEM"))
                    nPosDsc := Ascan(aBkpX3D,{|x| "DESC" $ x})
                Else 
                    nPosDsc := Ascan(aBkpX3D,{|x| "TEXTO" $ x})
                EndIF 

                aAux3[nLinha,nPosCol] := cRet

                If nPosDsc > 0
                    aAux3[nLinha,5] := &(Substr(&("SXB->XB_CONTEM"),1,3)+"->"+aBkpX3D[nPosDsc])
                EndIf 
            EndIf 
        EndIF 

        aAux3[nLinha,nPosCol+1] := aAux3[nLinha,nPosCol]
        aAux3[nLinha,nPosCol] := cBackup 

    Else 
        

        lOk := lEditCell(aAux3, oDp2, '@!', oDp2:nColPos) 

        aAux3[nLinha,nPosCol+1] := aAux3[nLinha,nPosCol]
        aAux3[nLinha,nPosCol] := cBackup 
    
    EndIf 
    
    If aAux3[nLinha,nPosCol+1] <> cBkpCpo 
        aAux3[nLinha,01] := .T.
    EndIf 

    aAux := separa(aAux2[oDp1:nAt,08],"/")

    For nCont := 1 to len(aAux)
        nPos := Ascan(aList3B,{|x| alltrim(x[4])+alltrim(x[2]) == Alltrim(aAux[nCont])+alltrim(aAux3[nLinha,2])})
        If nPos > 0
            aList3B[nPos,01] := .T.
            aList3B[nPos,03] := aAux3[nLinha,nPosCol+1]
            aList3B[nPos,05] := aAux3[nLinha,5]
        EndIf 
    Next nCont

EndIf 

Return

/*/{Protheus.doc} exclP98
    Excluir registros da tabela transitoria
    @type  Static Function
    @author user
    @since 28/05/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function exclP98()

Local aArea         := GetArea()
Local cQuery 
Local nOpcao        := 0
Local nCont 
Local nX 
Private oExcluir,oGrE1,oBrw1,oGrE2,oBrw2,oBtn1,oBtn2
Private oOk   	    := LoadBitmap(GetResources(),'br_verde')   
Private oNo   	    := LoadBitmap(GetResources(),'br_vermelho') 
Private oList1x,oList2x
Private aLista1     := {}
Private aLista2     := {}

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv(cEmpAnt,"00001000100")
EndIf

cQuery := "SELECT DISTINCT P98_TABELA,P96_RELACI,COUNT(P98_TABELA) QTD"
cQuery += " FROM "+RetSQLName("P98")+" P98"
cQuery += " LEFT JOIN "+RetSQLName("P96")+" P96 ON P96_FILIAL='"+xFilial("P96")+"' AND P96_TABELA=P98_TABELA AND P96.D_E_L_E_T_=' '"
cQuery += " WHERE P98_FILIAL='"+xFilial("P98")+"' AND P98_CALLBA ='"+cCnpjOrig+"'  AND P98.D_E_L_E_T_=' '"
cQuery += " AND P98_TABELA NOT IN(SELECT P96_RELACI FROM "+RetSQLName("P96")+" WHERE P96_FILIAL=' ' AND P96_RELACI<>' ' AND P96.D_E_L_E_T_=' ')"
cQuery += " AND P98_STATUS='0'"
cQuery += " GROUP BY P98_TABELA ,P96_RELACI"
cQuery += " ORDER BY 1"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aLista1,{.f.,TRB->P98_TABELA,TRB->P96_RELACI,TRB->QTD})
    Dbskip()
EndDo 

cQuery := "SELECT P98_TABELA,COUNT(*) AS QTD"
cQuery += " FROM "+RetSQLName("P98")+" P98"         
cQuery += " WHERE P98_FILIAL='"+xFilial("P98")+"' AND P98_CALLBA ='"+cCnpjOrig+"'  AND P98.D_E_L_E_T_=' '"
cQuery += " AND P98_STATUS='0'"
cQuery += " GROUP BY P98_TABELA"
cQuery += " ORDER BY 1"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aLista2,{TRB->P98_TABELA,TRB->QTD})
    Dbskip()
EndDo 

oExcluir   := MSDialog():New( 092,232,642,1086,"Excluir Movimentos",,,.F.,,,,,,.T.,,,.T. )

    oGrE1      := TGroup():New( 004,008,240,200,"Tabelas e Relacionamentos",oExcluir,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,012,232,196},,, oGrE1 ) 
        oList1x:= 	TCBrowse():New(012,012,185,215,, {'','Tabela','Relacionadas'},;
                                {10,40,90,60},;
                                oGrE1,,,,{|| /*FHelp()*/},{|| trcP98(oList1x:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oList1x:SetArray(aLista1)
        oList1x:bLine := {||{if(aLista1[oList1x:nAt,01],oOk,oNo),; 
                                aLista1[oList1x:nAt,02],;
                                aLista1[oList1x:nAt,03]}}

    oGrE2      := TGroup():New( 004,204,240,416,"Registros por tabela",oExcluir,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,208,236,412},,, oGrE2 ) 
        oList2x:= 	TCBrowse():New(012,208,185,215,, {'Tabela','Quantidade'},;
                                {90,60},;
                                oGrE2,,,,{|| /*FHelp()*/},{|| /*relactab(oList1:nAt,oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oList2x:SetArray(aLista2)
        oList2x:bLine := {||{   aLista2[oList2x:nAt,01],;
                                aLista2[oList2x:nAt,02]}}

    oBtn1      := TButton():New( 248,112,"Confirmar",oExcluir,{|| oExcluir:end(nOpcao:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 248,276,"Cancelar",oExcluir,{|| oExcluir:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )

oExcluir:Activate(,,,.T.)

If nOpcao == 1
    If MsgYesNo("Confirma a exclusão dos registros selecionados?")
        For nCont := 1 to len(aLista1)
            If aLista1[nCont,01]
                cUpdate := "UPDATE "+RetSQLName("P98")+" SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_"
                
                cUpdate += " WHERE P98_TABELA='"+Alltrim(aLista1[nCont,02])+"' AND D_E_L_E_T_=' ' "
                cUpdate += " AND P98_STATUS='0'"

                If (nError := TCSQLExec(cUpdate)) <> 0
                    Help(,, "exclP98",, AllTrim(Str(nError)) + "-" + TCSQLError(), 1, 0)
                endif 

                If !Empty(aLista1[nCont,03])
                    aaux := separa(aLista1[nCont,03],"/")
                    For nX := 1 to len(aaux)
                        cUpdate := "UPDATE "+RetSQLName("P98")+" SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_"
                
                        cUpdate += " WHERE P98_TABELA='"+Alltrim(aaux[nX])+"' AND D_E_L_E_T_=' ' "
                        cUpdate += " AND P98_STATUS='0'"

                        If (nError := TCSQLExec(cUpdate)) <> 0
                            Help(,, "exclP98",, AllTrim(Str(nError)) + "-" + TCSQLError(), 1, 0)
                        endif
                    Next nX 
                EndIf 
            EndIf 
        Next nCont 
    EndIf 

    MsgAlert("Registros excluídos")

EndIf 

RestArea(aArea)
   
Return

/*/{Protheus.doc} trcP98
    (long_description)
    @type  Static Function
    @author user
    @since 28/05/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function trcP98(nLinha)

Local aArea := GetArea()

If aLista1[nLinha,01]
    aLista1[nLinha,01] := .F.
Else 
    aLista1[nLinha,01] := .T.
EndIf 

oList1x:refresh()
oExcluir:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} savecnfg
    Salva os dados de configuração da incorporação
    @type  Static Function
    @author user
    @since 01/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function savecnfg()

Local aArea := GetArea()
Local nCont
Local lSalvou := .F.
Local lIncln    :=  .T.
Local cConteudo := ''
Local lRet := .T.

DbSelectArea("P97")
DbSetOrder(1)

If len(aList3B) > 1 
    For nCont := 1 to len(aList3B)
        If !Empty(aList3B[nCont,04])
            nPos := Ascan(aList2B,{|x| alltrim(x[1]) == alltrim(aList3B[nCont,04])})

            If nPos > 0
                If Dbseek(xFilial("P97")+cCodigo+Avkey(cFilOrig,"P97_FILORI")+Avkey(cFilDest,"P97_FILDES")+Avkey(aList3B[nCont,04],"P97_CAMPO")+Avkey(aList3B[nCont,02],"P97_CONTOR"))
                    Reclock("P97",.F.)
                    lIncln := .F.
                    cConteudo := 'Usuario '+cusername+' Data '+cvaltochar(ddatabase)+' Hora '+cValToChar(time())+CRLF 
                    cConteudo += 'Conteudo Origem Anterior '+P97->P97_CONTOR+" / "
                    cConteudo += 'Conteudo Origem Atual '+aList3B[nCont,02]
                    cConteudo += 'Conteudo Destino Anterior '+P97->P97_CONTDE+" / "
                    cConteudo += 'Conteudo Destino Atual '+cvaltochar(aList3B[nCont,03])
                    

                Else 
                    Reclock("P97",.T.)
                    lIncln := .T.
                    cConteudo := 'Usuario '+cusername+' incluiu em '+cvaltochar(ddatabase)+' Hora '+cvaltochar(time()) 
                EndIf 

                P97->P97_FILIAL := xFilial("P97")
                P97->P97_CODIGO := cCodigo 
                P97->P97_FILORI := cFilOrig
                P97->P97_FILDES := cFilDest
                P97->P97_CAMPO  := aList3B[nCont,04]
                P97->P97_TABELA := aList2B[nPos,05]
                P97->P97_CONTOR := aList3B[nCont,02]
                P97->P97_CONTDE := aList3B[nCont,03]
                P97->P97_DESCTO := aList3B[nCont,05]
                P97->P97_CODEXT := Encode64(cCnpjOrig+alltrim(cFilOrig))
                P97->P97_CNPJ   := cCnpjOrig
                P97->P97_HISTOR := cConteudo
                P97->(Msunlock())
                lSalvou := .T.
            EndIf   
        EndIf 

    Next nCont
Else 
    If !Empty(cCodigo) .And. !Empty(cFilOrig) .And. !Empty(cFilDest)
        For nCont := 1 to len(aList2B)
            If Dbseek(xFilial("P97")+cCodigo+Avkey(cFilOrig,"P97_FILORI")+Avkey(cFilDest,"P97_FILDES")+Avkey(aList2B[nCont,01],"P97_CAMPO"))
                Reclock("P97",.F.)
            Else 
                Reclock("P97",.T.)
            EndIf 

            P97->P97_FILIAL := xFilial("P97")
            P97->P97_CODIGO := cCodigo 
            P97->P97_FILORI := cFilOrig
            P97->P97_FILDES := cFilDest
            P97->P97_CAMPO  := aList2B[nCont,01]
            P97->P97_TABELA := aList2B[nCont,05]
            P97->P97_CONTOR := ''
            P97->P97_CONTDE := ''
            P97->P97_DESCTO := ''
            P97->P97_CODEXT := Encode64(cCnpjOrig+alltrim(cFilOrig))
            P97->P97_CNPJ   := cCnpjOrig
            P97->P97_HISTOR := 'Usuario '+cusername+' incluiu em '+cvaltochar(ddatabase)+' Hora '+cvaltochar(time()) 
            P97->(Msunlock())
            lSalvou := .T.
        Next nCont 

        If lCheck1
            /* 

                    cnpj: z.string(),
                    table: z.string(),
                    field: z.string(),
                    title: z.string(),
                    description: z.string(),
                    type: z.string(),
                    size: z.string(),
                    decimal: z.string(),
                    tip: z.string(),
                    search: z.string(),
                    valid: z.string(),
                    fixed: z.string(),
                    mandatory: z.boolean(),
                    empty: z.boolean(),

                    cCnpjOrig
                AadD(aList4,{TRB->P96_CAMPO,;   1
                 TRB->P96_DESCRI,;              2
                 TRB->P96_TAMANH,;              3
                 TRB->P96_PESQUI,;              4
                 TRB->P96_TABELA,;              5
                 TRB->P96_TIPO,;                6
                 cCombo,;                       7
                 '',;                           8
                 TRB->P96_TITULO,;              9
                 TRB->P96_DICA,;                10
                 TRB->P96_VALIDA,;              11
                 TRB->P96_FIXO,;                12
                 TRB->P96_INDTBL})              13
            */
            
            oJson := JsonObject():New()
            oJson['data'] := {}
            
            aArray := {}
            aHead  := {}
            Aadd(aHead,'Content-Type: application/json')
            Aadd(aArray,'https://integramais-web-backend.onrender.com')
            Aadd(aArray,'/transactions/insert/entity')

            For nCont := 1 to len(aList4)
                oJson['data'] := {}
                oItem := JsonObject():New()
                oItem['cnpj'] := cCnpjOrig
                oItem['table'] := aList4[nCont,05]
                oItem['field'] := Alltrim(aList4[nCont,01])
                oItem['title'] := Alltrim(aList4[nCont,09])
                oItem['description'] := Alltrim(aList4[nCont,02])
                oItem['type'] := aList4[nCont,06]
                oItem['size'] := cvaltochar(aList4[nCont,03])
                oItem['decimal'] := '0'
                oItem['tip'] := Alltrim(aList4[nCont,10])
                oItem['search'] := Alltrim(aList4[nCont,04])
                oItem['valid'] := Alltrim(aList4[nCont,11])
                oItem['fixed'] := ''
                oItem['mandatory'] := .F.
                oItem['empty'] := .F.
                Aadd(oJson['data'],oItem)

                cJson := oJson:toJson()

                If !Empty(cJson)
                    WAPIPOST(aArray,cJson,aHead)
                endIf 
            Next nCont 

            cJson := oJson:toJson()

            If !Empty(cJson)
                
                WAPIPOST(aArray,cJson,aHead)
            endIf 
        EndIf 
    Else
        FWAlertError("É necessário realizar uma inclusão, e preencher todos os campos, para salvar as configurações", "SAVECNFG()")
    EndIf
EndIF 

If lSalvou
    lRet := GravaPN2(cFilDest)
    IF lRet
        FWAlertSuccess("Conteúdo salvo com sucesso!!!", "Sucesso !")
    EnDIf
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} WAPIPOST
    Chamada de post Generica para todas as APIs
    @type  Static Function
    @author Alexandre Venâncio
    @since 26/05/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function WAPIPOST(aArray,cJson,aHead)

Local oRest 
Local oJson     :=  ""
Local aHeader   :=  {}
Local cRetorno  :=  ""
Local lRet      :=  .T.
Local cUrlInt   :=  aArray[1]
Local cPath     :=  aArray[2]
Local cRet      :=  ''
Local nCont     :=  0
Local aRet      :=  {}

/*
AAdd(aHeader, "Content-Type: application/json")
AAdd(aHeader, "Authorization: Basic "+cToken)
*/

For nCont := 1 to len(aHead)
    AAdd(aHeader, aHead[nCont])
Next nCont  

oRest := FWRest():New(cUrlInt)

oRest:SetPath(cPath)

oRest:SetPostParams(cJson)

If oRest:POST(aHeader)
    cRet  := oRest:GetResult()
    oJson := JsonObject():New()
    oJson:FromJson(cRet) 
    lRet := .T.
else
    cRetorno := Alltrim(oRest:GetLastError()) 
    cRet := Alltrim(oRest:cresult)
    oJson  := JsonObject():New()
    oJson:fromJson(cRet)
    lRet := .F.
EndIF 

Aadd(aRet,{lRet,cRet})

Return(aRet)

/*/{Protheus.doc} xLinGrid
    fiz provisoriamente até resolver como fazer de forma dinamica.
    @type  Static Function
    @author user
    @since 23/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xLinGrid(aListaD1,nLim)

Local nTamArr   := If(nLim>0,nLim,len(aListaD1[1]))
Local cLines    := '{|| {'
Local nLines    := 0

If nTamArr > 0
    For nLines := 1 To nTamArr
        cLines += 'aListaD1[oListD1:nAt, '+cValToChar(nLines)+']'
        If nLines < nTamArr
            cLines += ','
        Else
            cLines += '}}'
        EndIf
    Next
EndIf

If !Empty(cLines)
    oListD1:bLine := &(cLines)
Else
    FWAlertError("Não há dados selecionados para apresentar", "Atenção")
EndIf

Return

/*/{Protheus.doc} FHelp3(
    (long_description)
    @type  Static Function
    @author user
    @since 01/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FHelp3(nLinha)

Local nCont 
aListaD1 := {}

For nCont := 1 to len(aList4)
    If len(aList4[nCont]) > 0
        If aList4[nCont,len(aList4[nCont])] == aList2[nLinha,01]
            Aadd(aListaD1,aList4[nCont])
        EnDIf
    EndIf
Next nCont 

If len(aListaD1) < 1
    Aadd(aListaD1,{'','','','','','','','','','','','',''})
EndIf 

If len(aList5) > 0
    nPos := Ascan(aList5,{|x| x[len(x)] == aList2[nLinha,01]})
    
    If nPos > 0
        aCabeca := {}
        aTamanho := {}
        For nCont := 1 to len(aList5[nPos])
            Aadd(aCabeca,aList5[nPos,nCont])
            AadD(aTamanho,40)
        Next nCont
        oListD1:= 	TCBrowse():New(164,008,696,176,, aCabeca,;
                                        aTamanho,;
                                        oGrp4,,,,{|| },{|| /*AltSel(oList1:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    EndIf 
EndIf 

oListD1:SetArray(aListaD1)
xLinGrid(aListaD1,If(len(aCabeca)>0,len(aCabeca),len(aListad1[1])))

oListD1:refresh()
oDlg1:refresh()

Return


/*/{Protheus.doc} LerJson2
    Leitura dos itens incluídos na tabela transitoria, para tratamento do de/para
    @type  Static Function
    @author user
    @since 15/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function LerJson2(nQtdPrc)

Local nCont 
Local nCont1
Local oBody     := JsonObject():New()
Local aCpoJson  := {}
Local nX,nJ 
Local cUnKey
Local aAux2     := {}
Local aUnKey    := {}
Local aPKey     := {}
Local aPkey2    := {}
Local nPosST    := 0
Local aFilters  := {}
Local aFiltersB := {}
Local lFiltersB := .F.
Local nY        := 0
Local nCt       := 0
Local nCNs      := 0
Local nProc     := 0
Local cTabCt    := ""
Local aAuxK1    := {}
Local aAuxK2    := {}
Local cTabAux   := ''
Local nZeraObj  := 500
Local aCpoInex  := {}

If !Empty(cTabRsg)
    If !"/" $ cTabRsg
        nPosX2 := Ascan(aX2Unq,{|x| x[1] == cTabRsg})
        If nPosX2 > 0
            cUnKey := aX2Unq[nPosX2,2]
        Else 
            cUnKey := ""
        EndIf 
        
        aAuxK2      := Separa(cUnKey,"+")
        Aadd(aUnKey,{cTabRsg,aAuxK2})
        
    Else 
        aAuxK1 := separa(cTabRsg,"/")
        For nCont := 1 to len(aAuxK1)
            nPosX2 := Ascan(aX2Unq,{|x| x[1] == aAuxK1[nCont]})
            If nPosX2 > 0
                cUnKey := aX2Unq[nPosX2,2]
            Else 
                cUnKey := ""
            EndIf 
            
            aAuxK2      := Separa(cUnKey,"+")
            Aadd(aUnKey,{aAuxK1[nCont],aAuxK2})
        Next nCont 
    EndIf 
EndIf 

If !Empty(cFilPesq) .And. !"CN9" $ cTabRsg
    If '/' $cFilPesq
        aFilters := StrToKarr(AllTrim(cFilPesq),'/')
        For nX :=1 To Len(aFilters)
            aAdd(aFiltersB,StrToKarr(AllTrim(aFilters[nX]),'#'))
        Next nX
    Else
        FWAlertWarning( "O separador precisa ser (/)", "Atenção!")
        Return
    EndIf
EndIf

//DbSelectArea("P98")

If Empty(aCNs)
    ProcRegua(IIF(nQtdPrc > 0, nQtdPrc, len(aListP98)))
EndIf

nProc := If(nQtdPrc > 0,nQtdPrc,len(aListP98))

For nCont1 := 1 to nProc

    If nZeraObj == nCont1
        nZeraObj += 500
        freeObj(oBody)
        oBody := JsonObject():New()
    EndIf

    oBody := nil
    oBody := aListP98[nCont1,07]
    cTable  :=  aListP98[nCont1,08]
    aCpoJson:=  aListP98[nCont1,09]

    If !Empty(aCNs)
        nCNs := Ascan(aCNs,{|x| x[1] == cTable}) 
        If nCNs > 0
            If cTabCt <> cTable
                ProcRegua(aCNs[nCNs,2])
                cTabCt := cTable
                nCt := 0
            EndIf
        EndIf

        nCt++

        //trocar isso
        IncProc("Processando a Tabela "+cTabCt+" ..."+cvaltochar(nCt)+" de "+cvaltochar(aCNs[nCNs,2]))

    Else
        IncProc("Processando..."+cvaltochar(nCont1)+" de "+cvaltochar(nProc))
    EndIf
    

    If Len(aFiltersB) > 0 
        lFiltersB := .F.
        For nY := 1 To Len(aFiltersB)
            If cTable == aFiltersB[nY][1]
                If !lFiltersB .And.  &( "'" + oBody['fields'][AllTrim(aFiltersB[nY][2])] + "' " + AllTrim(aFiltersB[nY][3]) + " '" + AllTrim(aFiltersB[nY][4]) + "'" )
                    lFiltersB := .T.
                EndIf 
            EndIf 
        Next nY 
        If !lFiltersB
            loop 
        EndIf 
    EndIf

    If cTabAux <> cTable
        nPosKey := Ascan(aUnKey,{|x| x[1] == cTable})
        aAuxK1 := aUnKey[nPosKey,2]
        cTabAux := cTable
        nPosStrc    :=  Ascan(aEstrX3,{|x| x[len(x)] == cTable})
        nPosL4 := Ascan(aList4,{|x| x[5] == upper(cTable)})
        //Validação especifica para filial, não tratar os jsons de outras filials
        nPosFil     := Ascan(aAuxK1,{|x| 'FILIAL' $ x})
        cFilPrc     := xFilial(cTable)
        aCpoInex    := {}
        
        For nX := 1 to len(aEstrX3[nPosStrc]) - 1
            //cCpoInex += alltrim(aEstrX3[nPosStrc][nX][1]) + "/"
            Aadd(aCpoInex,alltrim(aEstrX3[nPosStrc][nX][1]))
        Next nX 

    EndIf 
    
    If !Empty(cFilPrc)
        If nPosFil > 0
            if oBody['fields'][aAuxK1[nPosFil]] <> alltrim(cFilOrig) .And. oBody['fields'][aAuxK1[nPosFil]] <> alltrim(cFilDest)
                loop 
            EndIf 
        ElseIf len(aAuxK1) < 1
            cPrefx := PrefixoCPO( cTable )
            if oBody['fields'][cPrefx+"_FILIAL"] <> alltrim(cFilOrig) .And. oBody['fields'][cPrefx+"_FILIAL"] <> alltrim(cFilDest)
                loop 
            EndIf
        EndIf 
    EndIf 
    
    
    aAux2 := {}

    For nX := 1 to len(aCpoJson)
        If Ascan(aCpoInex,{|x| alltrim(x) == Alltrim(aCpoJson[nX])}) == 0
            loop 
        EndIf 

        nCont := Ascan(aEstrX3[nPosStrc],{|x| alltrim(x[1]) == Alltrim(aCpoJson[nX])})
        
        If nCont == 0
            aEstrX3[nPosStrc,nCont,len(aEstrX3[nPosStrc,nCont])] := .F.
        EndIf 

        If !aEstrX3[nPosStrc,nCont,len(aEstrX3[nPosStrc,nCont])]
            loop
        EndIf 

        cCampo := alltrim(upper(aEstrX3[nPosStrc,nCont,01]))
      
            campo1 := ''
            If aEstrX3[nPosStrc,nCont,02]=="C"
                campo1 := oBody['fields'][cCampo]
            ElseIf aEstrX3[nPosStrc,nCont,02]=="N" .And. valtype(oBody['fields'][cCampo]) != "N"
                campo1 := val(oBody['fields'][cCampo])
            ElseIf aEstrX3[nPosStrc,nCont,02]=="D"
                campo1 := cvaltochar(stod(cvaltochar(oBody['fields'][cCampo])))
            Else 
                campo1 := oBody['fields'][cCampo]
            EndIf 

            
            If !Empty(cvaltochar(oBody['fields'][cCampo])) .And. Ascan(aPKey,{|x| cvaltochar(x) == cvaltochar(oBody['fields'][cCampo])}) == 0
                Aadd(aList3B,{  .F.,;
                                campo1,;
                                If("FILIAL" $ alltrim(upper(cCampo)),cFilDest,""),;
                                alltrim(upper(cCampo)),;
                                If("FILIAL" $ alltrim(upper(cCampo)),cNomeFil,""),;
                                ''})

                Aadd(aPKey,oBody['fields'][cCampo])
                
                
            ENDIF 

            
             Aadd(aAux2,{upper(cTable),upper(cCampo),if(valtype(campo1)=="C",upper(campo1),campo1)})
            
            
 
    Next nX    
 
    If len(aAux2) > 0
        
        // Teste Gean - HOMOLOGAR
        Aadd(aAux2,{upper(cTable),'RecnoP98',aListP98[nCont1,05]})
        Aadd(aDadosDet,aAux2)

        Aadd(aList5,aAux2)
    EndIf 

    //Busca dados da tabela filha quando houver
    If nPosST > 0
        If len(aTabs[nPosST]) > 1
            If oBody:HasProperty(aTabs[nPosST,2])
                cTable := aTabs[nPosST,2]
                nPosX2 := Ascan(aX2Unq,{|x| x[1] == cTable})
                If nPosX2 > 0
                    cUnKey := aX2Unq[nPosX2,2]
                Else 
                    cUnKey := ""
                EndIf 

                aUnKey      := Separa(cUnKey,"+")

                nPosStrc    :=  Ascan(aEstrX3,{|x| x[len(x)] == cTable})
                
                For nX := 1 to len(oBody[aTabs[nPosST,2]])
                

                    For nCont := 1 to len(aEstrX3[nPosStrc])-1

                        If !aEstrX3[nPosStrc,nCont,len(aEstrX3[nPosStrc,nCont])]
                            loop
                        EndIf 

                        cCampo := alltrim(upper(aEstrX3[nPosStrc,nCont,01]))

                        If oBody[aTabs[nPosST,2]][nX]:HasProperty(cCampo)
                            If !Empty(oBody[aTabs[nPosST,2]][nX][cCampo]) .And. Ascan(aPKey2,{|x| x == oBody[aTabs[nPosST,2]][nX][cCampo]}) == 0
                                Aadd(aList3B,{  .F.,;
                                                If(aEstrX3[nPosStrc,nCont,02]=="N",val(oBody[aTabs[nPosST,2]][nX][cCampo]),;
                                                If(aEstrX3[nPosStrc,nCont,02]=="D",cvaltochar(stod(oBody[aTabs[nPosST,2]][nX][cCampo])),;
                                                oBody[aTabs[nPosST,2]][nX][cCampo])),;
                                                If("FILIAL" $ alltrim(upper(cCampo)),cFilDest,""),;
                                                alltrim(upper(cCampo)),;
                                                If("FILIAL" $ alltrim(upper(cCampo)),cNomeFil,""),;
                                                ''})

                                Aadd(aPKey2,oBody[aTabs[nPosST,2]][nX][cCampo])
                                
                            ENDIF  
                        Else 
                            aEstrX3[nPosStrc,nCont,len(aEstrX3[nPosStrc,nCont])] := .F.
                        EndIf
                            
                    Next nCont
                    
                    aAux1 := {}
                    
                    nPosL4 := Ascan(aList4,{|x| x[5] == upper(aTabs[nPosST,2])})

                    If nPosL4 > 0
                        
                        For nJ := nPosL4 to len(aList4)
                            If aList4[nJ,05] != aTabs[nPosST,2]
                                exit 
                            else
                                cCampo := alltrim(upper(aList4[nJ,01]))
                                
                                If oBody[aTabs[nPosST,2]][nX]:HasProperty(cCampo)
                                    If aList4[nJ,06] == "C"
                                        cConteudo := oBody[aTabs[nPosST,2]][nX][cCampo]
                                    ElseIf aList4[nJ,06] == "D"
                                        cConteudo := STOD(oBody[aTabs[nPosST,2]][nX][cCampo])
                                    ElseIf aList4[nJ,06] == "N"
                                        cConteudo := VAL(oBody[aTabs[nPosST,2]][nX][cCampo])
                                    EndIf 

                                    Aadd(aAux1,{  .F.,;
                                                cConteudo,;
                                                If("FILIAL" $ alltrim(aList4[nJ,01]),cFilDest,""),;
                                                alltrim(aList4[nJ,01]),;
                                                If("FILIAL" $ alltrim(aList4[nJ,01]),cNomeFil,""),;
                                                '',;
                                                aTabs[nPosST,2]})

                                    // Teste Gean
                                    Aadd(aAux2,{aTabs[nPosST,2],alltrim(aList4[nJ,01]),cConteudo})

                                EndIF
                            EndIf
                        Next nJ 
                    EndIf 

                Next nX

                If len(aAux2) > 0
                    Aadd(aAux2,{upper(cTable),'RecnoP98',aListP98[nCont1,05]})
                    Aadd(aDadosDet,aAux2)
                EndIf

            EndIf
        EndIf 

        
    EndIf
    
    
Next nCont1 

Return

static Function ConfMigra( )

    Local aTabelas  := { }
    Local aPergs    := { }
    Local aRet      := { }
    Local aOrdem    := { '1=Tabela Posicionada' } // {'0=Selecione','1=Tabela Posicionada','2=Todos'}
    Local nOpcao    := 0
    Local cTabImp   := cTabRsg
    Local nX, nLen

    aAdd( aPergs ,{ 2, "Conferir Por?", "1" , aOrdem , 100, '.T.', .F. } )

    If ParamBox( aPergs , "Conferência Migração", @aRet )
        nOpcao := val( aRet[1] )
        
        If nOpcao == 0
            Return
        EndIf
        
    EndIf

    If nOpcao == 1

        aTabelas := Separa( cTabImp, '/' )
        nLen     := Len( aTabelas ) 

        // For nX := 1 To nLen
        //     ConferenciaMigracao.U_ThreadPrincipalConfereMigracao( aTabelas[nX], cCnpjOrig, cFilDest )
        // next nX
        For nX := 1 To nLen
            //ConferenciaMigracao.U_ThreadPrincipalConfereMigracao( aTabelas[nX], cCnpjOrig, cFilDest )
            U_TINCWHCM( aTabelas[nX], cCnpjOrig, cFilDest )
        next nX

        FWAlertWarning("Processo finalizado.", "Conferência de Migração" )

    Endif

Return

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
Static Function GeraPlan(aCabec,aDados)

Local oExcel    := FWMsExcelEx():New()
Local oFWriter
Local cDir 		:= 'c:\temp\integramais\'
Local cArqXls 	:= "" 
Local nX,nY,nZ 
Local aAux      := {}
Local aStruCps  := {}
Local aTabelas  := {} //Separa(aCabec[6],"|")
Local aCampos   := {} //Separa(aCabec[9],"|")
Local aPergs    := {}
Local aRet      := {}
Local aOrdem    := {'0=Selecione','1=Modelo','2=Conferir Dados da filial','3=Conferir Dados Tabela Final','4=Erros Tabela Final'}
Local nOpcao    := 0
Local aHeader   := {}
Local cTabImp   := cTabRsg 
Local cLocalTXT := ''
Local cType     := ''
Local cQuery    := ''
Local cDados    := ''
Local cMsg      := ''
Local nLen      := 0  

aAdd( aPergs ,{2,"Ordenar por?","1" , aOrdem , 100,'.T.',.F.})

If ParamBox(aPergs ,"Ordem",@aRet)
    nOpcao := val(aRet[1])
    
    If nOpcao == 0
        Return 
    Else
        If !ExistDir(cDir)
            MakeDir(cDir)
        EndIf
    EndIf 
EndIf 

If Empty(cDir)
	Return
EndIf

If nOpcao == 1

    cArqXls := "Dados_Modelo"+StrTran(DtoC(ddatabase),"/",'-')+" _ "+StrTran(Time(),":",'-')+".xls" 

    DbSelectArea("P96")
    DbSetOrder(1)

    Aadd(aHeader,{  "Campo","Titulo","Descrição","Tipo","Tamanho", "Dica","Pesquisa","De/Para"})

    While !EOF()
        If Ascan(aTabelas,{|x| alltrim(x) == Alltrim(P96->P96_TABELA)}) == 0
            Aadd(aTabelas,P96->P96_TABELA)
        EndIf 

        Aadd(aCampos,{  P96->P96_CAMPO,P96->P96_TITULO,P96->P96_DESCRI, P96->P96_TIPO,P96->P96_TAMANH,;
                        P96->P96_DICA,P96->P96_PESQUI,P96->P96_DEPARA, P96->P96_TABELA})
        Dbskip()
    EndDo 

    For nX := 1 to len(aTabelas)
        oExcel:AddworkSheet(aTabelas[nX]) 
        oExcel:AddTable (aTabelas[nX],aTabelas[nX])

        For nY := 1 to len(aHeader[1])
            oExcel:AddColumn(aTabelas[nX],aTabelas[nX],aHeader[1,nY],1,1)
        Next nY

        For nZ := 1 to len(aCampos)
            aAux := {}
            If aCampos[nZ,09] == aTabelas[nX]
                For nY := 1 to len(aHeader[1])
                    Aadd(aAux,aCampos[nZ,nY])
                Next nY
            EndIf 
            If len(aAux)
                oExcel:AddRow(aTabelas[nX],aTabelas[nX],aAux)
            EndIf
        Next nZ 
    Next nX 

    oExcel:Activate()
    oExcel:GetXMLFile(cDir +cArqXls)

    If !ApOleClient( 'MsExcel' )
        FWAlertWarning("Excel não instalado, o arquivo esta hein"+cDir+cArqXls, 'Atenção')
    Else
        oExcelApp := MsExcel():New()
        oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
        oExcelApp:SetVisible(.T.)        
        oExcelApp:Destroy()
        FWAlertSuccess("Arquivo gerado em: "+cDir+cArqXls,'Sucesso')
    EndIf

ElseIf nOpcao == 2 
    nTime := Time()
    cLocalTXT := cDir+"Dados_da_Filial "+StrTran(DtoC(ddatabase),"/",'-')+" _ "+StrTran(Time(),":",'-')+'\'

    If !ExistDir(cLocalTXT)
        MakeDir(cLocalTXT)
    EndIf

    For nX := 1 to Len(aTabTmp)
        cDados := ''
        lCriaAba := .F.

        cQuery := " SELECT /*PARALLEL(16)*/ * FROM "+aTabTmp[nX,01]

        If Select('TRB') > 0
            dbSelectArea('TRB')
            dbCloseArea()
            EndIf 

        PlsQuery(cQuery, "TRB")
        DbSelectArea("TRB")

        If !TRB->(EoF())
            cDados := ''
            Count To nTotal
            TRB->(DbGoTop())

                cArqXls := aTabTmp[nX,02]+".txt" 
            oFWriter := FWFileWriter():New(cLocalTXT + cArqXls, .T.)

            If ! oFWriter:Create()
                FWAlertError("Houve um erro ao gerar o arquivo: " + CRLF + oFWriter:Error():Message, "Atenção")
            Else
                While !EOF()

            // Campos
                aStruCps := EstructTemp(aTabTmp[nX,01])
                nLen := Len(aStruCps)
                If Empty(cDados)
                    For nY := 1 To nLen
                        cDados += aStruCps[nY]  
                        If nY < nLen
                            cDados += ';'
                EndIf 
            Next nY
            cDados += CRLF
                EndIf
            
            //Dados
                For nZ := 1 To nLen
                    cType := ValType(&('TRB->'+aStruCps[nZ]))
                    If cType == "C"
                        cDados += &('TRB->'+aStruCps[nZ])
                    ElseIf cType $ "N/D"
                        cDados += cValToChar(&('TRB->'+aStruCps[nZ]))
                        EndIf
                    If nZ < nLen
                            cDados += ';'
                        EndIf 
                    Next nZ
                    cDados += CRLF
                Dbskip()
            EndDo
            EndIf
                
            // Gera o arquivo em TXT
            If !Empty(cDados)

                oFWriter:Write(cDados)
                oFWriter:Close()
                FreeObj(oFWriter)   

                If FWAlertYesNo("Arquivo gerado com sucesso ( " + cLocalTXT + cArqXls + " )!" + CRLF + "Deseja abrir?", "Atenção")
                    ShellExecute("OPEN", cArqXls, "", cLocalTXT, 1 )
            EndIf 

            Else

                oFWriter:Close()
                FreeObj(oFWriter)

            EndIf 
        EndIf
                
    Next nX 
    FWAlertSuccess("Tempo de execução "+ElapTime( Time() , nTime )+CRLF+" Arquivo(s) gerado(s) em: "+cLocalTXT+cArqXls,'Sucesso')

ElseIf nOpcao == 3

    nTime := Time()
    If fArqTabFim(cDir,cTabImp,nOpcao,@cMsg)
        FWAlertSuccess("Arquivo(s) gerado(s) em: "+cMsg+CRLF+"Tempo de execução: "+ElapTime( nTime, Time() ),'Sucesso')
    EndIf 

ElseIf nOpcao == 4
    
    nTime := Time()
    If fArqTabFim(cDir,cTabImp,nOpcao,@cMsg)
        FWAlertSuccess("Arquivo(s) gerado(s) em: "+cMsg+CRLF+"Tempo de execução: "+ElapTime( nTime, Time() ),'Sucesso')
    EndIf 

    EndIf

Return(cDir+cArqXls)

/*/{Protheus.doc} fArqTabFim
    #Cria arquivo com os registros das tabelas finais 
    @type  Static Function
    @author user
    @since 25/02/2025
/*/
Static Function fArqTabFim(cDir,cTabImp,nOption,cMsg)
    Local aArea     := FWGetArea()
    Local cLocArq   := ""
    Local cArq      := ""
    Local cDados    := ""
    Local cCampos   := ""
    Local cQuery    := ""
    Local cType     := ""
    Local cAlsTab   := ""
    Local aTabelas  := {}
    Local aItens    := {}
    Local aStruCps  := {}
    Local nX,nY,nZ,nPosTab,nLen,nPosDel
    Local lRet      := .F.
    Local oFWriter  := Nil

    If nOption == 3
        cLocArq := cDir+"Dados_Tabela_Final_"+StrTran(DtoC(ddatabase),"/",'-')+"_"+StrTran(Time(),":",'-')+'/'
    Else
        cLocArq := cDir+"Erros_Tabela_Final_"+StrTran(DtoC(ddatabase),"/",'-')+"_"+StrTran(Time(),":",'-')+'/'
        EndIf 
    
    If !ExistDir(cLocArq)
        MakeDir(cLocArq)
    EndIf 

    aTabelas := Separa(cTabImp,'/')

    If Len(aTabelas) > 0
        For nX := 1 To Len(aTabelas) 
            cArq := aTabelas[nX]+".txt"
            
            //Cria o arquivo de logs
            oFWriter := FWFileWriter():New(cLocArq+cArq, .T.)
        
            //Se não foi possível criar o arquivo, encerra o Protheus
            If ! oFWriter:Create()
                Final("Houve um erro ao criar o arquivo - " + oFWriter:Error():Message)
            Else

                cQuery := " SELECT /*PARALLEL(16)*/ "

                If nOption == 3
                    cQuery += " PWU_CODIGO,PWU_RECN98,PWU_RECNDS,PWU_TABELA,R_E_C_N_O_ AS RECPWU"
                Else
                    cQuery += " PWU_FILIAL,PWU_CODIGO,PWU_DATA,PWU_HORA,PWU_USER,PWU_RESULT,"
                    cQuery += " UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PWU.PWU_DET, 2000,1)) AS DETALHE,"
                    cQuery += " PWU_RECN98,PWU_RECNDS,PWU_TABELA,PWU_CODP98,PWU_CODP97,R_E_C_N_O_ AS RECPWU "
            EndIf 

                cQuery += " FROM "+RetSQLName("PWU")+" PWU"
                cQuery += " WHERE PWU_CODP97='"+cCodigo+"' AND D_E_L_E_T_=' '"
                cQuery += " AND PWU_TABELA = '"+ aTabelas[nX] +"'"

                If nOption == 3
                    cQuery += " AND UPPER(PWU_RESULT) LIKE '#SUCESSO%'"
                Else
    cQuery += " AND UPPER(PWU_RESULT) NOT LIKE '#SUCESSO%'"
    EndIf 


    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

                PlsQuery(cQuery, "TRB")
    DbSelectArea("TRB")

                If !TRB->(EoF())
                    cDados  := ''
                    cCampos := ''

                    TRB->(DbGoTop())
    While !EOF()
                        If nOption == 3
                            Aadd(aItens,{TRB->PWU_TABELA,TRB->PWU_RECNDS,TRB->PWU_CODIGO,TRB->PWU_RECN98,TRB->RECPWU})
                        Else
                            Aadd(aItens,{TRB->PWU_FILIAL,TRB->PWU_CODIGO,TRB->PWU_DATA,TRB->PWU_HORA,TRB->PWU_USER,;
                                         TRB->PWU_RESULT,TRB->DETALHE,TRB->PWU_RECN98,TRB->PWU_RECNDS,TRB->PWU_TABELA,;
                                         TRB->PWU_CODP98,TRB->PWU_CODP97,TRB->RECPWU})
                        EndIf
        Dbskip()
    EndDo 

                    If nOption == 3
                        nPosTab := Ascan(aTabTmp,{|x| x[2] == aTabelas[nX]})
                        If nPosTab > 0
                            aStruCps := EstructTemp(aTabTmp[nPosTab,01])
                            nPosDel := Ascan(aStruCps,{|x| x == PrefixoCPO(aTabelas[nX])+'_P98REC'})
                            If nPosDel > 0 
                                aDel(aStruCps,nPosDel)
                                aSize(aStruCps, Len(aStruCps) - 1)
                                nPosDel := Ascan(aStruCps,{|x| x == PrefixoCPO(aTabelas[nX])+'_P98STA'})
                                If nPosDel > 0
                                    aDel(aStruCps,nPosDel)
                                    aSize(aStruCps, Len(aStruCps) - 1)
                                EndIf
                            EndIF
                            nLen := Len(aStruCps)
                        EndIf
                    Else 
                        aStruCps := FWSX3Util():GetAllFields( 'PWU', .F. )
                        nLen := Len(aStruCps)
                    EndIf

                    If nLen > 0

                        // Campos 
                        If Empty(cCampos)
                            For nY := 1 To nLen
                                cCampos += aStruCps[nY]  
                                If nY < nLen
                                    cCampos += ';'
                                EndIf 
        Next nY

                            //Insere no arquivo
                            oFWriter:Write(cCampos + CRLF)

                        EndIf

                        // Dados
                        cAlsTab := If(nOption == 3,aTabelas[nX],'PWU')

                        DbSelectArea(cAlsTab)

                        For nY := 1 To Len(aItens)

                            DbGoTo(If(cAlsTab == aTabelas[nX],aItens[nY,02],aItens[nY,Len(aItens[nY])]))

                            For nZ := 1 To nLen
                                cType := ValType(&(cAlsTab+"->"+aStruCps[nZ]))
                                If cType == "C"
                                    cDados += &(cAlsTab+"->"+aStruCps[nZ])
                                ElseIf cType $ "N/D"
                                    cDados += cValToChar(&(cAlsTab+"->"+aStruCps[nZ]))
                                EndIf 
                                If nZ < nLen
                                    cDados += ';'
                                EndIf 
        Next nZ 

                            //Insere no arquivo
                            oFWriter:Write(cDados + CRLF)
                            lRet := .T.
                            cDados := ''
                            
                        Next nY 
                    EndIf
                Else
                    If nOption == 3
                        FWAlertWarning("Dados não encontrados nas tabelas finais !", 'Atenção')
                    Else
                        FWAlertSuccess("Não foram encontrados Erros/Avisos",'Sucesso')
    EndIf
                EndIf
EndIf 

            //Encerra o arquivo
            oFWriter:Close()
            FreeObj(oFWriter)
            ShellExecute("OPEN", cLocArq+cArq, "", cLocArq, 1)

        Next nX 

EndIf
    
    cMsg := cLocArq+cArq

    FWRestArea(aArea)
Return lRet


/*/{Protheus.doc} PlanDP
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
Static Function PlanDP(aCabec,aDados)

Local oExcel 	:= FWMsExcelEx():New()
Local cDir 		:= 'c:\temp\integramais\'
Local cArqXls 	:= "DePara_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY
Local aAux      :=  {} 
Local cExterno  := "Relacionamento"
Local lCancel   := .T.

If !ExistDir(cDir)
    MakeDir(cDir)
EndIf
//cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet(cExterno) 
oExcel:AddTable (cExterno,cExterno)

For nX := 1 to len(aCabec[1])
    oExcel:AddColumn(cExterno,cExterno,aCabec[1,nX],1,1)
Next nX
   
    
For nX := 1 to len(aDados)
    lCancel := .F.
    aAux := {}
    For nY := 1 to len(aCabec[1])
            Aadd(aAux,aDados[nX,nY])
    Next nY
    
    oExcel:AddRow(cExterno,cExterno,aAux)
Next nX

If !lCancel
oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If !ApOleClient( 'MsExcel' )
        FWAlertWarning("Excel não instalado, o arquivo esta em: "+cDir+cArqXls, 'Atenção')
Else
    oExcelApp := MsExcel():New()
    oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
    oExcelApp:SetVisible(.T.)        
    oExcelApp:Destroy()
    FWAlertSuccess("Arquivo gerado em: "+cDir+cArqXls,'Sucesso')
Endif
EndIf	
    
Return(cDir+cArqXls)


/*/{Protheus.doc} fWizard
	CriaÃ§Ã£o do Wizard.
	Issue: TICONTIN-1534
	@author Alexandre Venancio	
	@since 07/08/2021
/*/
Static Function fWizard()

	Private oStepWiz	As object
	Private oPage1	    As Object
	Private oPage2	    As Object
	Private oPage3	    As Object
	Private oPage4	    As Object

	Private cTargetFile As Character
	Private LNextP1 as Logical
	Private LNextP2 as Logical
	Private LNextP3 as Logical

    Private aItems      := {}
    Private nTpMigInt
    Private lErro       :=  .F.
    Private aItens      := {}
    Private aTabFim     := {}
	
    cChaveLog := 'TINCWH01'+'_'+DToS(Date())+'_'+Time()+'_'+cUserName
	
    oStepWiz := FWWizardControl():New(,{700,1250})//Instancia a classe FWWizardControl
	oStepWiz:ActiveUISteps()
	LNextP1:= .T.
	LNextP2:= .F.
	LNextP3:= .F.
	//----------------------
	// Pagina 1
	//----------------------
	oPage1 := oStepWiz:AddStep("STEP1",{|Panel| cria_pn0(Panel)}) // Adiciona um Step
	oPage1:SetStepDescription("Tabelas a serem importadas") // Define o tÃ­tulo do "step"
	oPage1:SetNextTitle("Avançar") // Define o tÃ­tulo do botÃ£o de avanÃ§o
	oPage1:SetNextAction({||LNextP1}) // Define o bloco ao clicar no botÃ£o PrÃ³ximo
	oPage1:SetCancelAction({|| .T.}) // Define o bloco ao clicar no botÃ£o Cancelar

	
	//----------------------
	// Pagina 2
	//----------------------
    If "CN9" $ cTabRSG
        oPage2 := oStepWiz:AddStep("STEP2", {|Panel| cria_pCtr(Panel)})
        oPage2:SetStepDescription("Dados")
        oPage2:SetNextTitle("Avançar")
        oPage2:SetPrevTitle("Voltar") // Define o tÃ­tulo do botÃ£o para retorno
        oPage2:SetNextAction({|| LNextP2  })
        oPage2:SetCancelAction({|| .T.})
        oPage2:SetPrevAction({|| .T.}) //Define o bloco ao clicar no botÃ£o Voltar
    Else 
        oPage2 := oStepWiz:AddStep("STEP2", {|Panel| cria_pn2(Panel)})
        oPage2:SetStepDescription("Dados")
        oPage2:SetNextTitle("Avançar")
        oPage2:SetPrevTitle("Voltar") // Define o tÃ­tulo do botÃ£o para retorno
        oPage2:SetNextAction({|| LNextP2  })
        oPage2:SetCancelAction({|| .T.})
        oPage2:SetPrevAction({|| .T.}) //Define o bloco ao clicar no botÃ£o Voltar
    EndIF 
	//----------------------
	// Pagina 3
	//----------------------
	oPage3 := oStepWiz:AddStep("STEP3", {|Panel| cria_pn4(Panel)})
	oPage3:SetStepDescription("Log de processamento")
	oPage3:SetNextTitle("Finalizar")
    oPage3:SetPrevTitle("Voltar") // Define o tÃ­tulo do botÃ£o para retorno
    oPage3:SetNextAction({|| LNextP3  })
    oPage3:SetCancelAction({|| .F.})
	oPage3:SetPrevWhen({||.T.})
	oPage3:SetCancelWhen({||.T.})

	oStepWiz:Activate()

	oStepWiz:Destroy()

Return

/*/{Protheus.doc} cria_pn1
	CriaÃ§Ã£o da primeira pÃ¡gina do Wizard.
	Issue: TICONTIN-1534
	@author Alexandre Venancio	
	@since 07/08/2021
/*/
Static Function cria_pn0( oPanel As Object )

	Local oFont As Object
    Local nPosSa1   :=  Ascan(aTabs,{|x| x[1] == "SA1"})
    Local nPosSa2   :=  Ascan(aTabs,{|x| x[1] == "SA2"})
    Local nCont 
    
    If nPosSa1 > 0
        nPos2 := Ascan(aList1,{|x| x[1] == aTabs[nPosSa1,1]})
        Aadd(aItems,aTabs[nPosSa1,1]+" - "+aList1[nPos2,2])
    EndIf 
    If nPosSa2 > 0
        nPos2 := Ascan(aList1,{|x| x[1] == aTabs[nPosSa2,1]})
        Aadd(aItems,aTabs[nPosSa2,1]+" - "+aList1[nPos2,2])
    EndIf 
    
    For nCont := 1 to len(aTabs)
        If nCont <> nPosSa1 .And. nCont <> nPosSa2
            nPos2 := Ascan(aList1,{|x| x[1] == aTabs[nCont,1]})
            Aadd(aItems,aTabs[nCont,01]+(If(!Empty(aTabs[nCont,02]),"/"+alltrim(aTabs[nCont,02])+" - "," - "))+aList1[nPos2,2])
        EndIF 
    Next nCont 

    oFont := TFont():New(,,-25,.T.,.T.,,,,,)

    nTpMigInt := 1    

    oRadio := TRadMenu():New (30,45,aItems,,oPanel,,,,,,,,200,220,,,,.T.)
    oRadio:bSetGet := {|u|Iif (PCount()==0,nTpMigInt,nTpMigInt:=u)}
    /*
    esta parte vai voltar, porque aqui controlaremos quais entidades estão liberadas para rodar.
    For nCont := 1 to len(aItems)
        nPos := Ascan(aList1,{|x| x[1] == substr(aItems[nCont],1,3)})
        If nPos > 0
            If aList1[nPos,04] <> 2
                oRadio:disable(nCont)
            EndIF 
        EndIF 
    Next nCont */
    
    LNextP1 := .t.

Return .t.



/*/{Protheus.doc} cria_pCtr
	CriaÃ§Ã£o da segunda pÃ¡gina do Wizard. para os casos de Contratos
    Faremos a instanciação de um objeto diferente
	Issue: TICONTIN-1534
	@author Alexandre Venancio	
	@since 07/08/2021
/*/
Static Function cria_pCtr( oPanel As Object )

    Local aCabc         := {}
    Local aWizL         := {}
    Local aTbls         := {}
    //Local aRetRelations := {}
    Local aTabW         := Separa(alltrim(aItems[nTpMigInt]),'-')
    Local aTabsExec     := Separa(cTabRSG,'/')
    Local cTabela       := ''
    Local cBarra        := ''
    Local cFrTab        := ''
    Local cScTab        := ''
    Local cTitle        := ''
    Local cStatus       := 'AGUARDANDO'
    Local cClrSts       := 'QWidget { color: #FF8C00; }'
    Local lDupla        := .F.
    Local nTipIncl      := 0

    Local cInfosA,cInfosB,cInfosC,cInfosD,cInfosE,cInfosF,cInfosG
    Local nI,nSum,nPos,nCont,nPosT
    Local oIntegraMais 
    Local oTabA,oTabB,oTabC,oTabD,oTabE,oTabF,oTabG
    Local oTabA1,oTabB1,oTabC1,oTabD1,oTabE1,oTabF1,oTabG1
    Local oTitle,oSubTitle,oRodaPe,oBtnA,oBtnB,oBtnC,oBtnD

    oFont   := TFont():New(,,-25,.T.,.T.,,,,,)
    oFont2  := TFont():New(,,-15,.T.,.T.,,,,,)
    oFont3  := TFont():New(,,-20,.T.,.T.,,,,,)

    If "/" $ alltrim(aTabW[1])
        aTbls := separa(alltrim(aTabW[1]),"/")
        cFrTab := alltrim(aTbls[1])
        cScTab := alltrim(substr(aTabW[1],5))

        For nCont := 1 to len(aTbls)
            cTabela += cBarra + Alltrim(aTbls[nCont])
            cBarra := "/"
            nPosT := Ascan(aTabTmp,{|x| x[2] == aTbls[nCont]})
            Aadd(aTabFim,EstructTemp(aTabTmp[nPosT,1]))
            Aadd(aTabFim[len(aTabFim)],aTabTmp[nPosT,1])
            Aadd(aTabFim[len(aTabFim)],aTbls[nCont])

        Next nCont 



    EndIf 

    cTabCabec := cFrTab
    cTabItens := cScTab 
    nPosTipIn := Ascan(aList1,{|x| x[1] == cFrTab})

    If nPosTipIn > 0 
        nTipIncl := val(aList1[nPosTipIn,05])
    Else 
        nTipIncl := 3
    EndIf 

    If !Empty(cTabCabec) .And. !Empty(cTabItens)
        lDupla := .T.
    EndIf 

    // cPasta   	:= 'c:\temp\'
    // cLocArq 	:= cPasta+"Log Migração "+ IIF('/'$ cFrTab,StrTran(cFrTab,"/",'_'),cFrTab)+" - "+StrTran(DtoC(ddatabase),"/",'-')+" _ "+StrTran(time(),":",'-')+".txt"
    cUsrLog     := cUserName

    ///muda este
    oIntegraMais := WHIntegraMais():NPrMG( cTabCabec, cTabItens, cCodigo, cUsrLog, cCodPN2, "1/1", /*"", cLocArq,*/ lDupla, nTipIncl, cFilDest )
    ////
    oIntegraMais:StNomTabAuxCabec( )
    oIntegraMais:SetQtdRegExecProcessar( )
    // oIntegraMais:CalculaRegistrosPorThread( )

	oSay1 := TSay():New(10,15,{|| "Aguarde"},oPanel,,oFont,,,,.T.,CLR_GREEN,)

    oBtnA := TButton():New(25,130,"Exec. MultiThread",oPanel, { ||LNextP2 := oIntegraMais:ThreadsProcessaMigracao(oTabA1,oTabB1,oTabC1,oTabD1,oTabE1,oTabF1,oTabG1,.F./*lMonoThrd*/,oPanel,oBtnA,oBtnB,oBtnC,oIntegraMais,@cTimFProc) },120,22,/*uparam8*/,oFont,/*uparam10*/,.T.) 
    oBtnB := TButton():New(25,260,"Exec. MonoThread",oPanel, { ||LNextP2 := oIntegraMais:ThreadsProcessaMigracao(oTabA1,oTabB1,oTabC1,oTabD1,oTabE1,oTabF1,oTabG1,.T./*lMonoThrd*/,oPanel,oBtnA,oBtnB,oBtnC,oIntegraMais,@cTimFProc) },120,22,/*uparam8*/,oFont,/*uparam10*/,.T.) 
    oBtnC := TButton():New(25,390,"Imp.Resultado",oPanel, { ||FWMsgRun(, {|| ExpResult(aWizL,aCabc) },"","Processando os dados...")},120,22,/*uparam8*/,oFont,/*uparam10*/,.T.) //"Cancelar"
    oBtnD := TButton():New(55,282,"Monitor",oPanel, { ||U_LogWindow()},080,10,/*uparam8*/,oFont2,/*uparam10*/,.T.) 
    
    oBtnC:Disable()

    oBtnA:SetCSS(GetCss('oBtnA'))
    oBtnB:SetCSS(GetCss('oBtnB'))
    oBtnC:SetCSS(GetCss('oBtnC'))
    oBtnD:SetCSS(GetCss('oBtnD'))
	
	oSay1:settext("")

	oTitle := TSay():New(007,150,{|| "Confirme o processamento através do botão 'Executar' "},oPanel,,oFont,,,,.T.,,)
    oTitle:SetCSS('QWidget { color: #2F4F4F; }')
	
    cTitle  := "INICIANDO O PROCESSAMENTO ("+cTabRSG+")"
    oSubTitle := TSay():New(075,150,{|| cTitle },oPanel,,oFont,,,,.T.,,)
    oSubTitle:SetCSS('QWidget { color: #2F4F4F; }') 
    If Len(aTabsExec) > 1
        nSum := 0
        For nI := 1 To Len(aTabsExec)
            If nI > 1
                nSum += 17 
            EndIf

            nPos := aScan(aList1,{|x| x[1] == aTabsExec[nI] } )

            If nI == 1
                cInfosA := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabA := TSay():New(105+nSum,150,{|| cInfosA },oPanel,,oFont3,,,,.T.,,)
                oTabA1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabA1:SetCSS(cClrSts)
            ElseIf nI == 2
                cInfosB := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabB := TSay():New(105+nSum,150,{|| cInfosB },oPanel,,oFont3,,,,.T.,,)
                oTabB1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabB1:SetCSS(cClrSts)
            ElseIf nI == 3
                cInfosC := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabC := TSay():New(105+nSum,150,{|| cInfosC },oPanel,,oFont3,,,,.T.,,)
                oTabC1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabC1:SetCSS(cClrSts)
            ElseIf nI == 4
                cInfosD := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabD := TSay():New(105+nSum,150,{|| cInfosD },oPanel,,oFont3,,,,.T.,,)
                oTabD1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabD1:SetCSS(cClrSts)
            ElseIf nI == 5
                cInfosE := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabE := TSay():New(105+nSum,150,{|| cInfosE },oPanel,,oFont3,,,,.T.,,)
                oTabE1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabE1:SetCSS(cClrSts)
            ElseIf nI == 6
                cInfosF := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabF := TSay():New(105+nSum,150,{|| cInfosF },oPanel,,oFont3,,,,.T.,,)
                oTabF1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabF1:SetCSS(cClrSts)
            ElseIf nI == 7
                cInfosG := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabG := TSay():New(105+nSum,150,{|| cInfosG },oPanel,,oFont3,,,,.T.,,)
                oTabG1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabG1:SetCSS(cClrSts)
            EndIf 
        Next nI
    Else
        nPos := aScan(aList1,{|x| x[1] == cTabRSG } )
        cInfosA := "Tabela: "+cTabRSG+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
        oTabA := TSay():New(105,150,{|| cInfosA },oPanel,,oFont3,,,,.T.,,)
        oTabA1 := TSay():New(105,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
        oTabA1:SetCSS(cClrSts)
    EndIf 
    
    oRodaPe := TSay():New(245,115,{|| "Ambiente de execução IP="+GetServerIP()+" / Porta= "+cValToChar(GetPort(1))+" / IP usuario ="+GetClientIP()+" / Computador = "+GetComputerName()},oPanel,,oFont2,,,,.T.,CLR_BLUE,)


Return .t.

/*/{Protheus.doc} cria_pn2
	CriaÃ§Ã£o da segunda pÃ¡gina do Wizard.
	Issue: TICONTIN-1534
	@author Alexandre Venancio	
	@since 07/08/2021
/*/
Static Function cria_pn2( oPanel As Object )

Local aCabc         := {}
Local aWizL         := {}
Local aTbls         := {}
Local aRetRelations := {}
Local aTabW         := Separa(alltrim(aItems[nTpMigInt]),'-')
Local aTabsExec     := Separa(cTabRSG,'/')
Local cTabela       := ''
Local cBarra        := ''
Local cFrTab        := ''
Local cScTab        := ''
Local cTitle        := ''
Local cStatus       := 'AGUARDANDO'
Local cClrSts       := 'QWidget { color: #FF8C00; }'
Local lDupla        := .F.
Local nTipIncl      := 0

Local cInfosA,cInfosB,cInfosC,cInfosD,cInfosE,cInfosF,cInfosG
Local nI,nSum,nPos,nCont,nPosT
Local oIntegraMais 
Local oTabA,oTabB,oTabC,oTabD,oTabE,oTabF,oTabG
Local oTabA1,oTabB1,oTabC1,oTabD1,oTabE1,oTabF1,oTabG1
Local oTitle,oSubTitle,oRodaPe,oBtnA,oBtnB,oBtnC,oBtnD

//Local cTabela := substr(aItems[nTpMigInt],1,3)
// Local aAux          := {}
// Local aWizT         := {}
// Local aTabWiz       := {'CN9_NUMERO','CN9_SITUAC','CN9_FILCTR'}
// Local cTabWiz       := ''
// Local nPosTab       := 0
// Local nJ
// Local nCtt, nW
// Local oLWiz

oFont   := TFont():New(,,-25,.T.,.T.,,,,,)
oFont2  := TFont():New(,,-15,.T.,.T.,,,,,)
oFont3  := TFont():New(,,-20,.T.,.T.,,,,,)

If "/" $ alltrim(aTabW[1])
    aTbls := separa(alltrim(aTabW[1]),"/")
    cFrTab := alltrim(aTbls[1])
    cScTab := alltrim(aTbls[2])

    For nCont := 1 to len(aTbls)
        cTabela += cBarra + Alltrim(aTbls[nCont])
        cBarra := "/"
        nPosT := Ascan(aTabTmp,{|x| x[2] == aTbls[nCont]})
        Aadd(aTabFim,EstructTemp(aTabTmp[nPosT,1]))
        Aadd(aTabFim[len(aTabFim)],aTabTmp[nPosT,1])
        Aadd(aTabFim[len(aTabFim)],aTbls[nCont])

    Next nCont 

    FWSX9Util():SearchX9Paths( cFrTab, cScTab , @aRetRelations )

Else  // Quanto é uma tabela apenas
    cTabela := alltrim(aTabW[1])
    cFrTab  := alltrim(aTabW[1])
    nPosT := Ascan(aTabTmp,{|x| x[2] == cTabela})
    Aadd(aTabFim,EstructTemp(aTabTmp[nPosT,1]))
    Aadd(aTabFim[len(aTabFim)],aTabTmp[nPosT,1])
    Aadd(aTabFim[len(aTabFim)],cTabela)

EndIf 

cTabCabec := cFrTab
cTabItens := cScTab 
nPosTipIn := Ascan(aList1,{|x| x[1] == cFrTab})

If nPosTipIn > 0 
    nTipIncl := val(aList1[nPosTipIn,05])
Else 
    nTipIncl := 3
EndIf 

If !Empty(cTabCabec) .And. !Empty(cTabItens)
    lDupla := .T.
EndIf 

// cPasta   	:= 'c:\temp\'
// cLocArq 	:= cPasta+"Log Migração "+ IIF('/'$ cFrTab,StrTran(cFrTab,"/",'_'),cFrTab)+" - "+StrTran(DtoC(ddatabase),"/",'-')+" _ "+StrTran(time(),":",'-')+".txt"
cUsrLog     := cUserName

oIntegraMais := WHIntegraMais():NPrMG( cTabCabec, cTabItens, cCodigo, cUsrLog, cCodPN2, "1/1", /*"", cLocArq,*/ lDupla, nTipIncl, cFilDest )
oIntegraMais:StNomTabAuxCabec( )
oIntegraMais:SetQtdRegExecProcessar( )
oIntegraMais:CalculaRegistrosPorThread( )

// nPosTab := Ascan(aList1,{|x| x[1] == cFrTab})
// If aList1[nPosTab,3] > 0
//     cTabWiz := cFrTab
// Else
//     nPosTab := Ascan(aList1,{|x| x[1] == cScTab})
//     If aList1[nPosTab,3] > 0
//         cTabWiz := cScTab
//     Else
//         cTabWiz := cFrTab
//     EndIf
// EndIf

//FWMsgRun(, {|| aDadosDet := CargaDet(aTabFim) },"","Aguarde...")

// For nCont := 1 to len(aDadosDet)
//     If aDadosDet[nCont,01,01] ==cTabWiz  
//         aAux := {}
//         If len(aCabc) < 1 .And. aDadosDet[nCont,01,01] == cTabWiz
//             If !(aDadosDet[nCont,01,01] $ 'CN9/CNA/CNB/CNC') 
//                 Aadd(aCabc,aDadosDet[nCont,1,2])
//                 Aadd(aCabc,aDadosDet[nCont,2,2])
//                 Aadd(aCabc,aDadosDet[nCont,3,2])
//             Else
//                 Aadd(aCabc,'CN9_NUMERO')
//                 Aadd(aCabc,'CN9_SITUAC')
//                 Aadd(aCabc,'CN9_FILCTR')
//             EndIf
//             Aadd(aCabc,'Status')
//             Aadd(aCabc,'RecnoP98')
//             Aadd(aCabc,'Tabela')

//         EndIF 

//         For nJ := 1 to 3 
//             If !(aDadosDet[nCont,01,01] == 'CN9')
//                 Aadd(aAux,aDadosDet[nCont,nJ,03])
//             Else
//                 nCtt := Ascan(aDadosDet[nCont],{|x| x[2] == aTabWiz[nJ]})
//                 If nCtt > 0
//                     Aadd(aAux,aDadosDet[nCont,nCtt,03])
//                 EndIf
//             EndIF
//         Next nJ
        
//         Aadd(aAux,'')
        
//         nPosRec := Ascan(aDadosDet[nCont],{|x| "P98" $ x[2] }) 

//         If nPosRec > 0
//             Aadd(aAux,aDadosDet[nCont,nPosRec,3])
//         EndIf 

//         Aadd(aAux,aDadosDet[nCont,01,01])

//         Aadd(aWizL,aAux)
    
//         aAux := {}
    
//         For nJ := 1 to len(aDadosDet[nCont])
//             Aadd(aAux,{aDadosDet[nCont,nJ,02],aDadosDet[nCont,nJ,03]})
//         Next nJ

//         Aadd(aItens,aAux)

//     EndIF 
// Next nCont 

// For nW := 1 To Len(aWizL)
//     If aWizL[nW,6] == cTabWiz
//         Aadd(aWizT,aWizL[nW])
//     EndIf
// Next nW

// If len(aWizL) < 1
//     Aadd(aWizL,{'','','','',''})
//     Aadd(aCabc,'Conteudo 1')
//     Aadd(aCabc,'Conteudo 2')
//     Aadd(aCabc,'Conteudo 3')
//     Aadd(aCabc,'Status')
//     Aadd(aCabc,'RecnoP98')
//     Aadd(aCabc,'Tabela')

// EndIf 


	oSay1 := TSay():New(10,15,{|| "Aguarde"},oPanel,,oFont,,,,.T.,CLR_GREEN,)

    //oBtn1 := TButton():New(25,175,"Executar",    oPanel, { ||FWMsgRun(, {|| LNextP2 := ProcRegTb(aItens,@aWizL,cTabela,@aWizT)},"","Processando os dados...")},100,22,/*uparam8*/,oFont,/*uparam10*/,.T.) //"Cancelar"
    oBtnA := TButton():New(25,130,"Exec. MultiThread",oPanel, { ||LNextP2 := oIntegraMais:ThreadsProcessaMigracao(oTabA1,oTabB1,oTabC1,oTabD1,oTabE1,oTabF1,oTabG1,.F./*lMonoThrd*/,oPanel,oBtnA,oBtnB,oBtnC,oIntegraMais,@cTimFProc) },120,22,/*uparam8*/,oFont,/*uparam10*/,.T.) 
    oBtnB := TButton():New(25,260,"Exec. MonoThread",oPanel, { ||LNextP2 := oIntegraMais:ThreadsProcessaMigracao(oTabA1,oTabB1,oTabC1,oTabD1,oTabE1,oTabF1,oTabG1,.T./*lMonoThrd*/,oPanel,oBtnA,oBtnB,oBtnC,oIntegraMais,@cTimFProc) },120,22,/*uparam8*/,oFont,/*uparam10*/,.T.) 
    oBtnC := TButton():New(25,390,"Imp.Resultado",oPanel, { ||FWMsgRun(, {|| ExpResult(aWizL,aCabc) },"","Processando os dados...")},120,22,/*uparam8*/,oFont,/*uparam10*/,.T.) //"Cancelar"
    oBtnD := TButton():New(55,282,"Monitor",oPanel, { ||U_LogWindow()},080,10,/*uparam8*/,oFont2,/*uparam10*/,.T.) 
    
    oBtnC:Disable()

    oBtnA:SetCSS(GetCss('oBtnA'))
    oBtnB:SetCSS(GetCss('oBtnB'))
    oBtnC:SetCSS(GetCss('oBtnC'))
    oBtnD:SetCSS(GetCss('oBtnD'))
	
	oSay1:settext("")

	oTitle := TSay():New(007,150,{|| "Confirme o processamento através do botão 'Executar' "},oPanel,,oFont,,,,.T.,,)
    oTitle:SetCSS('QWidget { color: #2F4F4F; }')
	
    cTitle  := "INICIANDO O PROCESSAMENTO ("+cTabRSG+")"
    oSubTitle := TSay():New(075,150,{|| cTitle },oPanel,,oFont,,,,.T.,,)
    oSubTitle:SetCSS('QWidget { color: #2F4F4F; }') 
    If Len(aTabsExec) > 1
        nSum := 0
        For nI := 1 To Len(aTabsExec)
            If nI > 1
                nSum += 17 
            EndIf

            nPos := aScan(aList1,{|x| x[1] == aTabsExec[nI] } )

            If nI == 1
                cInfosA := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabA := TSay():New(105+nSum,150,{|| cInfosA },oPanel,,oFont3,,,,.T.,,)
                oTabA1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabA1:SetCSS(cClrSts)
            ElseIf nI == 2
                cInfosB := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabB := TSay():New(105+nSum,150,{|| cInfosB },oPanel,,oFont3,,,,.T.,,)
                oTabB1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabB1:SetCSS(cClrSts)
            ElseIf nI == 3
                cInfosC := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabC := TSay():New(105+nSum,150,{|| cInfosC },oPanel,,oFont3,,,,.T.,,)
                oTabC1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabC1:SetCSS(cClrSts)
            ElseIf nI == 4
                cInfosD := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabD := TSay():New(105+nSum,150,{|| cInfosD },oPanel,,oFont3,,,,.T.,,)
                oTabD1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabD1:SetCSS(cClrSts)
            ElseIf nI == 5
                cInfosE := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabE := TSay():New(105+nSum,150,{|| cInfosE },oPanel,,oFont3,,,,.T.,,)
                oTabE1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabE1:SetCSS(cClrSts)
            ElseIf nI == 6
                cInfosF := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabF := TSay():New(105+nSum,150,{|| cInfosF },oPanel,,oFont3,,,,.T.,,)
                oTabF1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabF1:SetCSS(cClrSts)
            ElseIf nI == 7
                cInfosG := "Tabela: "+aTabsExec[nI]+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
                oTabG := TSay():New(105+nSum,150,{|| cInfosG },oPanel,,oFont3,,,,.T.,,)
                oTabG1 := TSay():New(105+nSum,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
                oTabG1:SetCSS(cClrSts)
            EndIf 
        Next nI
    Else
        nPos := aScan(aList1,{|x| x[1] == cTabRSG } )
        cInfosA := "Tabela: "+cTabRSG+"        Qtd. Registros: "+cValToChar(aList1[nPos,03])+"        Status: "
        oTabA := TSay():New(105,150,{|| cInfosA },oPanel,,oFont3,,,,.T.,,)
        oTabA1 := TSay():New(105,400,{|| cStatus },oPanel,,oFont3,,,,.T.,,)
        oTabA1:SetCSS(cClrSts)
    EndIf 
    
    oRodaPe := TSay():New(245,115,{|| "Ambiente de execução IP="+GetServerIP()+" / Porta= "+cValToChar(GetPort(1))+" / IP usuario ="+GetClientIP()+" / Computador = "+GetComputerName()},oPanel,,oFont2,,,,.T.,CLR_BLUE,)

    // -  - GetEnvServer()
Return .t.

/*/{Protheus.doc} CargaDet
    (long_description)
    @type  Static Function
    @author user
    @since 17/02/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function CargaDet(aTabFim)

Local aArea := GetArea()
Local aRet  := {}
Local nCont 
Local nX 
Local aAuxFim := {}

For nCont := 1 to 1 //len(aTabFim)
    cTabela := aTabFim[nCont,len(aTabFim[nCont])]
    cBusca  := aTabFim[nCont,len(aTabFim[nCont])-1]
    aAuxFim := {}
    cQuery := "SELECT * FROM "+cBusca 
    
    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")

    While !EOF()
        aAuxFim := {}
        For nX := 1 to len(aTabFim[nCont])-2
            Aadd(aAuxFim,{cTabela,Alltrim(aTabFim[nCont,nX]),&(Alltrim(aTabFim[nCont,nX]))})
        Next nX 
        Aadd(aRet,aAuxFim)
        Dbskip()
    EndDo 
Next nCont 

RestArea(aArea)
    
Return(aRet)
/*/{Protheus.doc} cria_pn4
	VisualizaÃ§Ã£o do log de processamento.
    Issue: TICONTIN-1534
	@author Alexandre Venancio	
	@since 24/04/2021
/*/
Static Function cria_pn4( oPanel As Object )

	Local oFont		As Object
    Local oFTitle	As Object
    Local cTimeExec := ""
    Local cQtdParc  := ""
    Local cQtdTotal := ""
    Local cTitle    := "RESULTADO DO PROCESSAMENTO ("+cTabRSG+")"
    Local cTableTmp := ""
    Local cTabPrinc := ""
    Local aProcess  := {}
    Local nPos      := 0
    Local oTitle,oTitleSts,oSucess,oAlert,oError 
    Local oDetailsA,oDetailsB,oDetailsC,oDetailsD   

    //oBtn1:disable()
	oFont := TFont():New(,,-25,.T.,.T.,,,,,)
    oFTitle := TFont():New(,,-25,.T.,.T.,,,,,)

	LNextP3 := .T.

	// Apresenta o tSay com a fonte Courier New
	If lErro
		oTitleSts := TSay():New(10,15,{|| "Importacao finalizada com erro"},oPanel,,oFont,,,,.T.,CLR_RED,)
        oTitleSts:SetCSS('QWidget { color: #FF0000; }') 
	Else
		oTitleSts := TSay():New(10,15,{|| "Processo finalizado com sucesso!"},oPanel,,oFont,,,,.T.,CLR_GREEN,)
        oTitleSts:SetCSS('QWidget { color: #008000; }') 
	EndIf

    // Monta array para envio de informações via e-mail 
    nPos        := aScan(aTabTmp,{|x| x[2] == Left(AllTrim(cTabRSG), 3) } )
    cTableTmp   := aTabTmp[nPos,1]
    cTabPrinc   := aTabTmp[nPos,2]
    cQtdParc    := fQtd(cTabPrinc,cTableTmp,.F.)
    cQtdTotal   := fQtd(cTabPrinc,cTableTmp,.T.)
    aProcess    := {cvaltochar(cTimeProc),;
                    cvaltochar(cTimFProc),;
                    ElapTime(cTimeProc,cTimFProc),;
                    cQtdParc,;
                    cQtdTotal,;
                    fSts(cTabPrinc,cTableTmp,'SUCESSO'),;
                    fSts(cTabPrinc,cTableTmp,'ALERTA'),;
                    fSts(cTabPrinc,cTableTmp,'ERRO')}

    cTimeProc   := "Inicio do Processamento: "      + aProcess[1]
    cTimFProc   := "Final do Processamento: "       + aProcess[2]
    cTimeExec   := "Tempo Total de Execução: "      + aProcess[3]
    cQtdTotal   := "Total Exec. Tabela Origem "     + aProcess[4] + " / " + aProcess[5]
    nSucess     := "Processados com SUCESSO: "      + aProcess[6]
    nAlert      := "Processados com ALERTA: "       + aProcess[7]
    nErr        := "Processados com ERRO: "         + aProcess[8]

    oTitle  := TSay():New(045,200,{|| cTitle       },oPanel,,oFTitle,,,,.T.,CLR_BLACK  ,)
    oTitle:SetCSS('QWidget { color: #2F4F4F; }') 
    oDetailsA := TSay():New(075,200,{|| cTimeProc    },oPanel,,oFont,,,,.T.,CLR_BLUE   ,)
    oDetailsA:SetCSS('QWidget { color: #2F4F4F; }') 
    oDetailsB := TSay():New(095,200,{|| cTimFProc    },oPanel,,oFont,,,,.T.,CLR_BLUE   ,)
    oDetailsB:SetCSS('QWidget { color: #2F4F4F; }') 
    oDetailsC := TSay():New(115,200,{|| cTimeExec    },oPanel,,oFont,,,,.T.,CLR_BLUE   ,)
    oDetailsC:SetCSS('QWidget { color: #2F4F4F; }') 
    oDetailsD := TSay():New(135,200,{|| cQtdTotal     },oPanel,,oFont,,,,.T.,CLR_BLUE  ,)
    oDetailsD:SetCSS('QWidget { color: #2F4F4F; }') 
    oSucess := TSay():New(185,200,{|| nSucess      },oPanel,,oFont,,,,.T.,CLR_GREEN    ,)
    oSucess:SetCSS('QWidget { color: #008000; }') 
    oAlert  := TSay():New(205,200,{|| nAlert       },oPanel,,oFont,,,,.T.,CLR_BROWN    ,)
    oAlert:SetCSS('QWidget { color: #FFA500; }') 
    oError  := TSay():New(225,200,{|| nErr         },oPanel,,oFont,,,,.T.,CLR_RED      ,)
    oError:SetCSS('QWidget { color: #FF0000; }') 


    //fEnvWF(aProcess, cTitle)

Return

/*/{Protheus.doc} fQtd
    (long_description)
    @type  Static Function
    @author user
    @since 23/09/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fQtd(cTabPrinc,cTableTmp,lTotal)

    Local aAreaTRB  := FwGetArea()
    Local cQuery    := ""
    Local cRet      := "0"

    If lTotal
        cQuery := "SELECT COUNT(*) AS CONT_TOTAL FROM "+ cTableTmp 
    Else
        cQuery := "SELECT COUNT(*) AS CONT_TOTAL FROM "+ cTableTmp + " WHERE " + PrefixoCPO(cTabPrinc) + "_P98STA = '1'"
    EndIf

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    PlsQuery(cQuery, "TRB")
    DbSelectArea("TRB")

    If !TRB->(EoF())
        TRB->(DbGoTop())
        cRet := cvaltochar(TRB->CONT_TOTAL)
    EndIf

    FwRestArea(aAreaTRB)
Return cRet

/*/{Protheus.doc} fSts
    Retorna a quantidade do Status da tabela temporaria
    @type  Static Function
    @author Geanlucas Sousa
    @since 10/04/2025
/*/
Static Function fSts(cTabPrinc,cTableTmp,cStatus)

    Local aAreaTRB  := FwGetArea()
    Local cQuery    := ""
    Local cRet      := "0"

    cQuery := "SELECT COUNT(*) AS CONT_TOTAL FROM "+ cTableTmp + " WHERE " + PrefixoCPO(cTabPrinc)
    If cStatus == 'SUCESSO'
        cQuery += "_P98STA = '1'"
    ElseIf cStatus == 'ALERTA'
        cQuery += "_P98STA = '3'"
    ElseIf cStatus == 'ERRO'
        cQuery += "_P98STA = '2'"
    EndIf

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    PlsQuery(cQuery, "TRB")
    DbSelectArea("TRB")

    If !TRB->(EoF())
        TRB->(DbGoTop())
        cRet := cValToChar(TRB->CONT_TOTAL)
    EndIf

    FwRestArea(aAreaTRB)
Return cRet

/*/{Protheus.doc} ExpResult
    Exporta o grid do resultado da exportação.
    @type  Static Function
    @author user
    @since 20/08/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ExpResult(aAuxD,aCabc)

Local cDir 		 := 'c:\temp\integramais\'
Local cArqXls 	 := "Resultado_"+StrTran(DtoC(ddatabase),"/",'-')+" _ "+StrTran(Time(),":",'-')+".txt" 
Local nX,nY,nW,nLen
Local cDados     := ""
Local oFWriter

If Len(aAuxD) > 0 .AND. Len(aCabc) > 0
If !ExistDir(cDir)
    MakeDir(cDir)
EndIf

If Empty(cDir)
	Return
EndIf

    oFWriter := FWFileWriter():New(cDir + cArqXls, .T.)

    If ! oFWriter:Create()
        FWAlertError("Houve um erro ao gerar o arquivo: " + CRLF + oFWriter:Error():Message, "Atenção")
    Else

    For nX := 1 To Len(aCabc)
        cDados += aCabc[nX] 
        If nX < Len(aCabc)
            cDados += ';'
        EndIf 
    Next nX
    cDados += CRLF

    For nY := 1 To Len(aAuxD)
        nLen := Len(aAuxD[nY]) 
        For nW := 1 To nLen
            If ValType(aAuxD[nY,nW]) == "C"
                cDados += aAuxD[nY,nW]
            ElseIf ValType(aAuxD[nY,nW]) $ "N/D"
                cDados += cValToChar(aAuxD[nY,nW])
            EndIf
            If nW < nLen
                cDados += ';'
            EndIf 
        Next nW
        cDados += CRLF
Next nY

        oFWriter:Write(cDados)
        oFWriter:Close()
        FreeObj(oFWriter)

        If FWAlertYesNo("Arquivo gerado com sucesso ( " + cDir + cArqXls + " )!" + CRLF + "Deseja abrir?", "Atenção")
            ShellExecute("OPEN", cArqXls, "", cDir, 1 )
        EndIf

    EndIf

    // &("MemoWrite( cDir+cArqXls , cDados )")
    // FWAlertSuccess("Arquivo gerado em: "+cDir+cArqXls,'Sucesso')

    EndIf

Return

/*/{Protheus.doc} ProcRegTb
    Processa os registros para suas devidas tabelas
    @type  AQUI SERA UTILIZADO O MULTITHREAD PARA GRAVAÇÃO DO EXECAUTO
    @author user
    @since 25/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ProcRegTb(aItens,aWizL,cTabe,aWizT)

Local aArea     := GetArea()
Local lRet      := .T.
Local nCont     := 1
Local cRet      := ''
Local nX        := 1
Local nJ
Local aAuxAtf   := {}
Local aContr    := {}
Local aItem     := {}
Local aAuxTb    := {}
Local nLeg      := 0
Local nX0       := 0
Local aLogP98   := {}
Local aAuxInd1  := {}
Local aAuxInd2  := {}
Local cQtdLog   := ''
Local nItens    := 0
Local cPasta   	:= 'c:\temp\'
// Local cLocArq 	:= cPasta+"Log Migração "+ IIF('/'$ cTabe,StrTran(cTabe,"/",'_'),cTabe)+" - "+StrTran(DtoC(ddatabase),"/",'-')+" _ "+StrTran(time(),":",'-')+".txt"
Local aTabFil   := {}

If !ExistDir(cPasta)
    MakeDir(cPasta)
EndIf

Private cArquivo    := ''
// Private cTextoLog 	:= ''

nSucess := 0
nAlert  := 0
nErr    := 0

If cfilant <> cFilDest
    RpcClearEnv()
    RpcSetType(3)
    RPCSetEnv(cEmpAnt,cFilDest) 
EndIf 

nItens := Len(aItens)

If cTabe == "SA1"

    // cTextoLog 	:= "INTEGRAMAIS ########## Inicio: " + Time() + " ########## " +CRLF
        
    For nCont := 1 to nItens
        cQtdLog := cvaltochar(nCont)+"/"+cvaltochar(nItens)

        nPos := Ascan(aItens[nCont],{|x| x[1] == "RecnoP98"})
        
        cRet := U_TINCWHXF(1,aItens[nCont],"SA1",aItens[nCont,nPos,02],,cUsrLog,,cCodPN2,,cQtdLog/*,cTextoLog,cLocArq*/)
        //StartJob("U_TINCWHXF",GetEnvServer(),.F.,1,aItens[nCont],"SA1",aItens[nCont,nPos,02],,cUsrLog)  
        //sleep(600)
        /* lRetMnJob := ManualJob( cSemafJob                   ,;  //JobName
                    GetEnvServer()                          ,;  //Environment
                    "IPC"                                   ,;  //Type
                    "U_GVSTPAMB"                            ,;  //OnStart
                    "U_J22CliHLC"                           ,;  //OnConnect
                    ""                                      ,;  //OnExit
                    ALLTRIM(cEmpAnt)+"|"+ Alltrim(cFilAnt)  ,;  //SessionKey
                    Nil                                     ,;  // InactiveTimeOut
                    nMax                                    ,;  // Instances min - Minimo de Instancias para o ManualJob 
                    nMax+5                                  ,;  // Instances max - Maximo de Instancias para o ManualJob
                    1                                       ,;  // Instances minfree - Minimo Free de Instancias para o ManualJob
                    1                                       )  */  // Instances inc - Incia as Instancias para o ManualJob

        //cRet := ""
        If !Empty(cRet)
            nPos := Ascan(aItens[nCont],{|x| x[1] == "A1_COD"})
            If nPos > 0
                nPos2 := Ascan(aWizL,{|x| x[1] == aItens[nCont,nPos,02]})
                If nPos2 > 0
                    aWizL[nPos2,04] := cRet
                EndIf 
            EndIf 

            If "#SUCESSO" $ Upper(cRet)
                nSucess++
            ElseIf "#ERRO" $ Upper(cRet)
                nErr++
            ElseIf "#AVISO" $ Upper(cRet)
                nAlert++
            EndIf 

        EndIF 
        // cTextoLog := ''
    Next nCont 
ElseIf cTabe == "SA2"

    // cTextoLog 	:= "INTEGRAMAIS ########## Inicio: " + Time() + " ########## "+CRLF

    For nCont := 1 to nItens
        cQtdLog := cvaltochar(nCont)+"/"+cvaltochar(nItens)

        nPos := Ascan(aItens[nCont],{|x| x[1] == "RecnoP98"})
        
        cRet := U_TINCWHXF(2,aItens[nCont],"SA2",aItens[nCont,nPos,02],,cUsrLog,,cCodPN2,,cQtdLog/*,cTextoLog,cLocArq*/)
    
        If !Empty(cRet)
            If nPos > 0
                nPos2 := Ascan(aWizL,{|x| x[5] == aItens[nCont,nPos,02]})
                If nPos2 > 0
                    aWizL[nPos2,04] := cRet
                EndIf 
            EndIf

            If "#SUCESSO" $ Upper(cRet)
                nSucess++
            ElseIf "#ERRO" $ Upper(cRet)
                nErr++
            ElseIf "#AVISO" $ Upper(cRet)
                nAlert++
            EndIf 
            // cTextoLog := ''
        EndIF 
    Next nCont
ElseIf "CN9" $ cTabe 
    
    aAuxiliar := separa(cTabe,"/")
    Asort(aAuxiliar,,,{|x,y| x < y })

    For nX := 1 to len(aAuxiliar)
        Aadd(aContr,{aAuxiliar[nX]})
        For nCont := 1 to nItens
            If substr(aItens[nCont,1,1],1,3) == aAuxiliar[nX]
                aItem := {}
                For nJ := 1 to len(aItens[nCont])
                    Aadd(aItem,aItens[nCont,nJ])
                Next nJ

                Aadd(aContr[len(aContr)],aItem)
            EndIf 
            
            
            If !Empty(cRet)
                If nPos > 0
                    nPos2 := Ascan(aWizL,{|x| x[5] == aItens[nCont,nPos,02]})
                    If nPos2 > 0
                        aWizL[nPos2,04] := cRet
                    EndIf 
                    nPos3 := Ascan(aWizT,{|x| x[5] == aItens[nCont,nPos,02]})
                    If nPos3 > 0
                        aWizT[nPos3,04] := cRet
                    EndIf 
                EndIf

                If "#SUCESSO" $ Upper(cRet)
                    nSucess++
                ElseIf "#ERRO" $ Upper(cRet)
                    nErr++
                ElseIf "#AVISO" $ Upper(cRet)
                    nAlert++
                EndIf 

                
            EndIF  
        Next nCont
    Next nX 

    // Se o diretório não existir, cria o mesmo!
    If !ExistDir('c:\temp')
        MakeDir('c:\temp')
    EndIf
    cArquivo := 'c:\temp\migratotvs'+StrTran(DtoC(ddatabase),"/",'-')+" _ "+StrTran(Time(),":",'-')+'.txt'

    // Testar tela de log
    // fLogCont(cArquivo)
    U_TINCWHXF(5,aContr,'CN9','',cArquivo,cUsrLog,@aLogP98,cCodPN2)
    
    For nCont := 1 to len(aLogP98)
        cRet := ''
        If aLogP98[nCont,01] == "CNB"
            nPos2 := Ascan(aWizL,{|x| x[5] == aLogP98[nCont,04]})
            cRet := aLogP98[nCont,5]
        Else 
            nPos2 := Ascan(aWizL,{|x| x[5] == aLogP98[nCont,03]})
            cRet := aLogP98[nCont,4]
        EndIf 

        If nPos2 > 0
            aWizL[nPos2,04] := cRet
        EndIf 

        If "#SUCESSO" $ Upper(cRet)
            nSucess++
        ElseIf "#ERRO" $ Upper(cRet)
            nErr++
        ElseIf "#AVISO" $ Upper(cRet)
            nAlert++
        EndIf 

    Next nCont 
ElseIf "SN1" $ cTabe .OR. "/" $ cTabe
    
    // cTextoLog 	:= "INTEGRAMAIS ########## Inicio: " + Time() + " ########## "+CRLF
    // ProcRegua(nItens)
    aAux1 := separa(cTabe,"/")
    
    aAuxInd1 := {}
    aAuxInd2 := {}

    If Ascan(aX2Unq,{|x| x[1] == aAux1[1]}) > 0
        aAuxInd1 := separa(aX2Unq[Ascan(aX2Unq,{|x| x[1] == aAux1[1]}),2],"+")
    EndIf 

    If Ascan(aX2Unq,{|x| x[1] == aAux1[2]}) > 0
        aAuxInd2 := separa(aX2Unq[Ascan(aX2Unq,{|x| x[1] == aAux1[2]}),2],"+")
    EndIf 

    aTabFil := {}

    /*

        cQuery := " "
        cQuery += " select * from (           " 
        cQuery += " SELECT                    " 
        cQuery += " 	            " 
        cQuery += "     DENSE_RANK() OVER (ORDER BY C5_FILIAL, SC5.C5_NUM) AS RN                   " 
        cQuery += " ,SC5.*,SC6.*    " 
        cQuery += " FROM BRP98SC5000013 SC5                   " 
        cQuery += " JOIN BRP98SC6000013 SC6 ON SC5.C5_FILIAL = SC6.C6_FILIAL                   " 
        cQuery += " 	AND SC5.C5_NUM = SC6.C6_NUM                   " 
        cQuery += " WHERE SC5.C5_FILIAL = '05501000100'                   " 
        cQuery += " ORDER BY                    " 
        cQuery += "     SC5.C5_FILIAL, SC5.C5_NUM, SC6.C6_ITEM                  " 
        //cQuery += " FETCH NEXT 1000 ROWS ONLY          " 
        cQuery += "  )  " 
        cQuery += " where RN between 1 and 1000  " 


        PlsQuery( cQuery, cAlsQry )

        While ( cAlsQry )->( !Eof( ) )

            Dbskip()
        EndDo 

    */

    
    For nX := 1 to len(aAuxInd1)
        aAuxPF := aItens[1]
        nPos := ascan(aAuxind2,{|x| substr(aauxind1[nX],at("_",aauxind1[nX])+1) $ x})
        nPosF:= ascan(aAuxPF,{|x| substr(x[1],at("_",aauxind1[nX])+1) == substr(aauxind1[nX],at("_",aauxind1[nX])+1) })
        If nPos > 0
            //aadd(aScan,nPos)
            Aadd(aTabFil,{aAuxind2[nPos],If(nPosF>0,nPosF,nX)})
        EndIf 
    Next nX 

    For nCont := 1 to nItens

        cQtdLog := cvaltochar(nCont)+"/"+cvaltochar(nItens)
/*        If !substr(aItens[nCont,1,1],1,at("_",aItens[nCont,1,1])-1) $ aAux1[1]
            loop 
        EndIf 
*/
        cScn1 := ""

        nPos98 := Ascan(aItens[nCont],{|x| "P98REC" $ x[1]}) //Ascan(aItens[nCont],{|x| x[1] == "RecnoP98"})
        nRec1P98 := 0
        nRec2P98 := 0

        If nPos98 > 0 
            nRec1P98 :=  aItens[nCont,nPos98,2]
        EndIf 

        Aadd(aAuxAtf,aItens[nCont])
/*
        For nX := 1 to len(aAuxInd1)
            
            nPosA := Ascan(aItens[nCont],{|x| x[1] == aAuxInd1[nX]})
            If nPosA > 0
                cScn1 += cvaltochar(aItens[nCont,nPosA,2])
            EndIf 

        Next nX 
*/

        cP98Tb := aTabTmp[Ascan(aTabTmp,{|x| x[2] == aAux1[2]}),1]
        nPostb2 := Ascan(aTabFim,{|x| x[len(x)] == aAux1[2]})
        cQuery := "SELECT * FROM "+cP98Tb
        cQuery += " WHERE "
        cBarra := ""

        For nX := 1 to len(aTabFil)
            cQuery += cBarra + aTabFil[nX,1]+"='"+alltrim(aItens[nCont,aTabFil[nX,2],2])+"'"
            cBarra := " AND "
        Next nX 

        If Select('TRB') > 0
            dbSelectArea('TRB')
            dbCloseArea()
        EndIf

        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        DbSelectArea("TRB")

        While !EOF()
            aAuxFim := {}
            For nX := 1 to len(aTabFim[nPostb2])-2
                Aadd(aAuxFim,{Alltrim(aTabFim[nPostb2,nX]),&("TRB->"+Alltrim(aTabFim[nPostb2,nX]))})
            Next nX 
            Aadd(aAuxAtf,aAuxFim)
            Dbskip()
        EndDo 

/*
        For nX := 1 to nItens 
            If AliasCpo(aItens[nX,1,1]) == aAux1[1] // substr(aItens[nX,1,1],1,at("_",aItens[nX,1,1])-1) $ aAux1[1]
                loop 
            EndIf 

            If AliasCpo(aitens[nx,1,1]) == aAux1[2] //substr(aitens[nx,1,1],1,at("_",aItens[nx,1,1])-1) $ aAux1[2] 
                cScn2 := ""

                For nJ := 1 to len(aTabFil)
                    cScn2 += aItens[nX,aTabFil[nJ],2]
                Next nJ 

                If cScn2 == cScn1
                    nPos := Ascan(aItens[nX],{|x| "P98REC" $ x[1] }) //Ascan(aItens[nX],{|x| x[1] == "RecnoP98"})
                    nRec2P98 := 0
                    
                    If nPos > 0 
                        nRec2P98 :=  aItens[nX,nPos,2]
                    EndIf 

                    Aadd(aAuxAtf,aItens[nX])
                    exit
                EndIf 
            Endif 
        Next nX 
*/
        cRet := ""
        If len(aAuxAtf) > 1
            cFilAnt := cFilDest
            If aAux1[1] == "SN1" 
                cRet := U_TINCWHXF(4,aAuxAtf,"SN1",nRec1P98,,cUsrLog,,cCodPN2,nRec2P98,cQtdLog/*,cTextoLog,cLocArq*/)
            else 
                For nX := 1 to len(aAuxAtf)
                    nPos98 := Ascan(aAuxAtf[nX],{|x| "P98REC" $ x[1]})
                    nRec1P98 := aAuxAtf[nX,nPos98,2]
                    cRet := U_TINCWHXF(3,aAuxAtf[nX],Aliascpo(aAuxAtf[nX,1,1]),nRec1P98,,cUsrLog,,cCodPN2,nRec2P98,cQtdLog/*,cTextoLog,cLocArq*/)
                Next nX 
            EndIf 

            aAuxAtf := {}
        EndIf 

        /*
        If !Empty(cRet)
            If nRec1P98 > 0
                nPos2 := Ascan(aWizL,{|x| x[5] == nRec1P98}) //aItens[nCont,nPos,02]
                If nPos2 > 0
                    aWizL[nPos2,04] := cRet
                EndIf 
            EndIf

            If nRec2P98 > 0
                nPos2 := Ascan(aWizL,{|x| x[5] == nRec2P98}) //aItens[nCont,nPos,02]
                If nPos2 > 0
                    aWizL[nPos2,04] := cRet
                EndIf 
            EndIf

            If "#SUCESSO" $ Upper(cRet)
                nSucess++
            ElseIf "#ERRO" $ Upper(cRet)
                nErr++
            ElseIf "#AVISO" $ Upper(cRet)
                nAlert++
            EndIf 

        EndIF */
        // cTextoLog := ''
    Next nCont
Else 
    // cTextoLog 	:= "INTEGRAMAIS ########## Inicio: " + Time() + " ########## "+CRLF
    
    For nCont := 1 to nItens
        
        cQtdLog := cvaltochar(nCont)+"/"+cvaltochar(nItens)
        
        nPos := Ascan(aItens[nCont],{|x| "P98REC" $ x[1] })
                //U_TINCWHXF(3,aAuxAtf[nX],Aliascpo(aAuxAtf[nX,1,1]),nRec1P98,,cUsrLog,,cCodPN2,nRec2P98,cQtdLog,cTextoLog,cLocArq)
        cRet := U_TINCWHXF(3,aItens[nCont],cTabe,aItens[nCont,nPos,02],,cUsrLog,,cCodPN2,,cQtdLog/*,cTextoLog,cLocArq*/)   
        /*
        nPos := Ascan(aItens[nCont],{|x| x[1] == "RecnoP98"})
        
        If !Empty(cRet)
            If nPos > 0
                nPos2 := Ascan(aWizL,{|x| x[5] == aItens[nCont,nPos,02]})
                If nPos2 > 0
                    aWizL[nPos2,04] := cRet
                EndIf 
                nPos3 := Ascan(aWizT,{|x| x[5] == aItens[nCont,nPos,02]})
                If nPos3 > 0
                    aWizT[nPos3,04] := cRet
                EndIf 
            EndIf
            
            If "#SUCESSO" $ Upper(cRet)
                nSucess++
            ElseIf "#ERRO" $ Upper(cRet)
                nErr++
            ElseIf "#AVISO" $ Upper(cRet)
                nAlert++
            EndIf 

        EndIF 
        */
        // cTextoLog := '' 
    Next nCont
    
EndIf 

If nItens == nSucess 
    aAuxTb := StrToKarr(cTabe,"/")
    for nX0 :=1 to len(aAuxTb)        
        nLeg := aScan(aList1,{|x| x[1] == aAuxTb[nX0]})
        if nLeg > 0
            aList1[nLeg,04] := 1
        endif
    next nX0
EndIf

cTimFProc := time()
// If File(cLocArq)
//     cTextoLog := "INTEGRAMAIS ########## Fim: " + cTimFProc + " ########## "
//     U_xAcaLog(cLocArq,cTextoLog)
// EndIf
FWAlertSuccess("Processo executado com sucesso!. Imprima o resultado para validar os status dos resgistros!", "Sucesso!")


IF "CN9"$cTabe  // somente para contratos - Quantidade de CN9
    cQtdProc := cvaltochar(nCN9)
Else
    cQtdProc := cvaltochar(nItens)
Endif

RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} Depara2
    Atualizar o de/para de itens
    @type  Static Function
    @author user
    @since 18/11/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Depara2()

Local nX,nY,nZ,nVzs
Local cCampo    :=  ''
Local lRet      :=  .T.
Local aAuxPH    := {}
Local cErro     := ""
Local cTable    := ""
Local aAuxDP    := {}
Local aAuxFl    := {}
Local aAuxClF   := {}
Local aRecPag   := {}
Local cCliFor   := ''
Local cTab      := ''

For nY := 1 to len(aList3B)
    If aList3B[nY,01]
        cCampo := Alltrim(aList3B[nY,04])
        cConteudo1 := ""
        cConteudo2 := ""

        If !"FILIAL" $ cCampo

            If cTable <> AliasCpo(cCampo)
                cTable := AliasCpo(cCampo)
                nPos   := Ascan(aEstrX3,{|x| x[len(x)] == cTable})
                aAuxDP := aEstrX3[nPos]
            EndIf 

            cTipo := aAuxDP[Ascan(aAuxDP,{|x| alltrim(x[1]) == cCampo}),2]
            //cAliasX := If(cEmpAnt=="00","BR",IF(cEmpAnt=="60","DM","MI"))+"P98"+cTable+cCodigo
            cAliasX := aTabTmp[Ascan(aTabTmp,{|x| x[2] == cTable}),01]
            
            If cTipo<>"N"
                cConteudo1 := "'"+alltrim(aList3B[nY,03])+"'"
                cConteudo2 := "'"+alltrim(aList3B[nY,02])+"'"
            Else 
                cConteudo1 := cvaltochar(aList3B[nY,03])
                cConteudo2 := cvaltochar(aList3B[nY,02])
            EndIf 
            cQuery := "UPDATE "+cAliasX+" SET "+cCampo+"="+cConteudo1+" WHERE "+cCampo+"="+cConteudo2
            TCSQLEXEC(cQuery)
        ENDiF 

    EndIf 
Next nY

For nY := 1 to len(aTabTmp)
    //Atualizar campo filial 
    cCampo := PrefixoCPO(aTabTmp[nY,02])+"_FILIAL"
    cConteudo := ""
    DbSelectArea(aTabTmp[nY,02])
    If !Empty(xFilial(aTabTmp[nY,02]))
        cConteudo := "'"+cFilDest+"'"
    Else
        cConteudo := "' '"
    EndIf

    cQuery := "UPDATE "+aTabTmp[nY,01]+" SET "+cCampo+"="+cConteudo
    TCSQLEXEC(cQuery)


    //Pegar estrutura das tabelas temporarias E atualizar os clientes com o de/para de cnpj para codigo T
    aAuxFl := EstructTemp(aTabTmp[nY,01])

    // Se for SE5 verifica se existem movimentos à Pagar e a Receber, caso tenha os dois verifica tanto cliente quando fornecedor 
    If AllTrim(aTabTmp[nY,02]) == 'SE5'

        cQuery := " SELECT E5_RECPAG, COUNT(*) AS QTD"
        cQuery += " FROM "+aTabTmp[nY,01]
        cQuery += " WHERE E5_P98STA IN ('0','5') AND E5_RECPAG <> ' ' "
        cQuery += " GROUP BY E5_RECPAG"

        If Select('TRB') > 0
            dbSelectArea('TRB')
            dbCloseArea()
        EndIf

        PlsQuery(cQuery, "TRB")
        DbSelectArea("TRB")

        If !TRB->(EoF())
            TRB->(DbGoTop())
            While !EOF()
                Aadd(aRecPag,{AllTrim(TRB->E5_RECPAG)})
                DbSkip()
            EndDo
        EndIf

        nVzs := Len(aRecPag)
    
    Else
        nVzs := 1
    EndIf

    For nZ := 1 To nVzs
        If AllTrim(aTabTmp[nY,02]) == "SE5"
            aAuxClF := fVldCliFor(aAuxFl,aTabTmp[nY,01],aTabTmp[nY,02],@cCliFor,aRecPag[nZ,01])
        Else
            aAuxClF := fVldCliFor(aAuxFl,aTabTmp[nY,01],aTabTmp[nY,02],@cCliFor,'')
        EndIf

    If cCliFor == 'C'
        For nX := 1 to len(aAuxClF)
            cQuery := "SELECT "+alltrim(aAuxClF[nX])+" AS CLIENTE,A1_COD,COUNT(*)"
            cQuery += " FROM "+aTabTmp[nY,01]
            cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL=' ' AND A1_CGC=RPAD("+alltrim(aAuxClF[nX])+", 14, ' ') AND A1.D_E_L_E_T_=' '"
            cQuery += " WHERE LENGTH("+alltrim(aAuxClF[nX])+") > 6"     
            cQuery += " GROUP BY "+alltrim(aAuxClF[nX])+",A1_COD"
            
            If Select('TRB') > 0
                dbSelectArea('TRB')
                dbCloseArea()
            EndIf

            DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

            DbSelectArea("TRB")

            While !EOF()

                cUpdate := "UPDATE "+aTabTmp[nY,01]+" SET "+alltrim(aAuxClF[nX])+" = '"+TRB->A1_COD+"'"
                cUpdate += " WHERE "+alltrim(aAuxClF[nX])+" = '"+Alltrim(TRB->CLIENTE)+"'"
                TCSQLEXEC(cUpdate)

                Dbskip()
            Enddo

            
            cQuery := "SELECT COUNT(*) AS QTD FROM "+aTabTmp[nY,01]
            cQuery += " WHERE LENGTH("+alltrim(aAuxClF[nX])+") > 9"

            If Select('TRB') > 0
                dbSelectArea('TRB')
                dbCloseArea()
            EndIf

            DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

            DbSelectArea("TRB")

            If TRB->QTD > 0
                cErro += "Tabela "+aTabTmp[nY,02]+CRLF 
                    cErro += "Campo "+alltrim(aAuxClF[nX])+" Cliente não atualizados "+cvaltochar(TRB->QTD)+" para o campo "+aAuxClF[nX]+CRLF
            EndIf 
        Next nX 

        //Atualizar Titpai para titulos do contas a receber
        If aTabTmp[nY,02] == "SE1"
            cQuery := "UPDATE "+aTabTmp[nY,01]+" SET E1_TITPAI=E1_PREFIXO||E1_NUM||E1_PARCELA||'NF '||E1_CLIENTE||E1_LOJA"
            cQuery += " WHERE E1_TIPO LIKE '%-%' AND E1_P98STA='0'"
            TCSQLEXEC(cQuery)
        EndIf 
    Else 
            cTab := ''
        For nX := 1 to len(aAuxClF)
            cQuery := "SELECT "+alltrim(aAuxClF[nX])+" AS FORNECE,A2_COD,COUNT(*)"
            cQuery += " FROM "+aTabTmp[nY,01]
            cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL=' ' AND A2_CGC=RPAD("+alltrim(aAuxClF[nX])+", 14, ' ') AND A2.D_E_L_E_T_=' '"
            cQuery += " WHERE LENGTH("+alltrim(aAuxClF[nX])+") > 6"     
            cQuery += " GROUP BY "+alltrim(aAuxClF[nX])+",A2_COD"
            
            If Select('TRB') > 0
                dbSelectArea('TRB')
                dbCloseArea()
            EndIf

            DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

            DbSelectArea("TRB")

            While !EOF()

                cUpdate := "UPDATE "+aTabTmp[nY,01]+" SET "+alltrim(aAuxClF[nX])+" = '"+TRB->A2_COD+"'"
                cUpdate += " WHERE "+alltrim(aAuxClF[nX])+" = '"+Alltrim(TRB->FORNECE)+"'"
                TCSQLEXEC(cUpdate)

                Dbskip()
            Enddo

                cTab := ''
            cQuery := "SELECT COUNT(*) AS QTD FROM "+aTabTmp[nY,01]
                cQuery += " WHERE LENGTH("+alltrim(aAuxClF[nX])+") <> 6"

            If Select('TRB') > 0
                dbSelectArea('TRB')
                dbCloseArea()
            EndIf

            DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

            DbSelectArea("TRB")

            If TRB->QTD > 0
                cErro += "Tabela "+aTabTmp[nY,02]+CRLF 
                    cErro += "Campo "+alltrim(aAuxClF[nX])+" Fornecedores não atualizados "+cvaltochar(TRB->QTD)+CRLF 
            EndIf 
        Next nX 

        //Atualizar Titpai para titulos do contas a pagar
        If aTabTmp[nY,02] == "SE2"
            cQuery := "UPDATE "+aTabTmp[nY,01]+" SET E2_TITPAI=E2_PREFIXO||E2_NUM||E2_PARCELA||'NF '||E2_FORNECE||E2_LOJA"
            cQuery += " WHERE E2_TIPO LIKE '%-%' AND E2_P98STA='0'"
            TCSQLEXEC(cQuery)
        EndIf 
    endIf 
    Next nZ
Next nY 

If !Empty(cErro)
    MsgAlert(cErro,"Depara2")
EndIf  

For nY := 1 to len(aDadosDet) 
    
    For nX := 1 to len(aDadosDet[nY])
        cCampo := Alltrim(aDadosDet[nY,nX,02])
 
        If aDadosDet[nY,nX,01] $ 'PH4/PHG' .and. "ITEM" $ cCampo  
            
            aAuxPH := BuscaItem(aDadosDet[nY])

            aDadosDet[nY,nX,03] := aAuxPH[1,1]

            nPos1 := Ascan(aDadosDet[nY],{|x| x[2] == aDadosDet[nY,nX,01]+"_NUMERO"})
            nPos2 := Ascan(aDadosDet[nY],{|x| x[2] == aDadosDet[nY,nX,01]+"_REVISA"})
            nPos3 := Ascan(aDadosDet[nY],{|x| x[2] == aDadosDet[nY,nX,01]+"_PROPOS"})

            If nPos1 > 0
                aDadosDet[nY,nPos1,03] := aAuxPH[1,2]
            EndIF 
            If nPos2 > 0
                aDadosDet[nY,nPos2,03] := aAuxPH[1,3]
            EndIF 
            If nPos3 > 0
                aDadosDet[nY,nPos3,03] := aAuxPH[1,4]
            EndIF
        EndIf 

        If aDadosDet[nY,nX,01] == "PHH" .And. lPHS
            nPos1 := Ascan(aDadosDet[nY],{|x| "REVCON" $ x[2]}) 

            nPos2 := Ascan(aDadosDet[nY],{|x| "NUMPLA" $ x[2]}) 
            
            If nPos1 > 0
                aAuxPH := BuscaItem(aDadosDet[nY])
                
                aDadosDet[nY,nPos1,03] := aAuxPH[1,3]

                If nPos2 > 0
                    aDadosDet[nY,nPos2,03] := aAuxPH[1,2]
                EndIf 
            EndIf 

            lPHS := .F.
        EndIf 

    Next nX 
Next nY 

Return(lRet)
/*/{Protheus.doc} BuscaItem
    Busca os itens dos contratos
    @type  Static Function
    @author user
    @since 07/10/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaItem(aArray)

Local cQuery 
Local nPos1 := Ascan(aArray,{|x| 'PRODUT' $ x[2]})
Local nPos2 := Ascan(aArray,{|x| 'UNINEG' $ x[2]})
Local nPos3 := Ascan(aArray,{|x| 'CLIEN' $ x[2]})
Local nPos4 := Ascan(aArray,{|x| 'CONTR' $ x[2]})
Local aItem := {}

If nPos2 == 0
    nPos2 := Ascan(aArray,{|x| 'SITEFT' $ x[2]})
EndIf 


    cQuery := "SELECT CNB_ITEM,CNB_REVISA,CNB_NUMERO,CNB_PROPOS"
    cQuery += " FROM   "+RetSQLName("CNB")+" CNB , "+RetSQLName("CN9")+" CN9" 
    cQuery += " WHERE  CNB_FILIAL=' ' AND "
    cQuery += "     CN9_FILIAL = ' '"
    If nPos1 > 0
        cQuery += "     and CNB_PRODUT = '"+aArray[nPos1,3]+"'"           
    EndIf 
    cQuery += "     AND CNB.D_E_L_E_T_ = ' '"
    cQuery += "             AND CN9_NUMERO = CNB_CONTRA"         
    cQuery += "             AND CN9_REVISA = CNB.CNB_REVISA"
    cQuery += "             AND CN9_REVATU = ' '"              
    cQuery += "             AND CN9_ESPCTR = '2'"         
    cQuery += "             AND CN9.D_E_L_E_T_ = ' '"

    If nPos4 > 0
        cQuery += " AND CNB_CONTRA = '"+If('CON'$aArray[nPos4,3],aArray[nPos4,3],'CON'+aArray[nPos4,3])+"'"
    Else 
        cQuery += " AND CNB_CONTRA IN (SELECT 'CON'||A1_COD FROM "+RetSQLName("SA1")+" WHERE A1_FILIAL=' ' AND A1_CGC IN('"+aArray[nPos3,3]+"'))"
    EndIF 

    cQuery += " AND CNB_UNINEG='"+aArray[nPos2,3]+"'"          
    cQuery += " ORDER BY CNB_CONTRA,CNB_ITEM"

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")

    Aadd(aItem,{TRB->CNB_ITEM,TRB->CNB_NUMERO,TRB->CNB_REVISA,TRB->CNB_PROPOS})


Return(aItem)

/*/{Protheus.doc} fEnvWF
    Envia WF, com o tempo de execução
    @type  Static Function
    @author user
    @since 09/09/2024    
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

Static Function fEnvWF(aProcess,cTitle)

    Local aArea         := FWGetArea()
	Local cAssunto		:= "# WH Integra Mais - Inf. do Processamento"							
    Local cPathHTML     := GetMV("MV_WFDIR")
    Local cFileName     := ""
    Local cArqHTML      := "\workflow\TINCWH01.html"
    Local oHtml 
    Local cTexto        := ""

    If ! File(cArqHtml)
        If ! Isblind()
            MsgInfo("Arquivo [" + cArqHTML + "] não encontrado !")
        EndIf 
        Return
    EndIf

    oHtml := TWFHtml():New( cArqHTML )

    // variáveis utilizadas no html
    oHTML:ValByName("TITLE"	    ,cTitle )
    oHTML:ValByName("INIPROC"	,aProcess[1] )   
    oHTML:ValByName("FIMPROC"	,aProcess[2] )
    oHTML:ValByName("TEMPEXEC"	,aProcess[3] )
    oHTML:ValByName("QTDREGP"	,aProcess[4] )
    oHTML:ValByName("QTDREGT"	,aProcess[5] )
    oHTML:ValByName("CSUCESS"	,aProcess[6] )
    oHTML:ValByName("CALERT"	,aProcess[7] )
    oHTML:ValByName("CCERROR"	,aProcess[8] )

    cFileName := CriaTrab(NIL,.F.) + ".htm"
    cFileName := cPathHTML + "\" + cFileName 
    oHtml:SaveFile(cFileName)
    cRet      := WFLoadFile(cFileName)
    ctexto    := StrTran(cRet,chr(13),"")
    ctexto    := StrTran(cRet,chr(10),"")
    cTexto    := OemtoAnsi(cTexto)

    u_xSendMail(AllTrim(cEmailInc),cAssunto,cTexto)
	
    RestArea(aArea)

Return


/*/{Protheus.doc} fCriaFKs
    Cria as FK's
    @type  Static Function
    @author user Geanlucas Rodrigues
    @since 16/09/2024    
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

Static Function fCriaFKs(cEmpAnt,cFilDest,lByPass)

    Local aPergs    := {}
    Local aRet      := {}
    Local aOrdem    := {'0=Selecione','1=Cria FK7','2=Cria FKs'}
    Local nOpcao    := 0
    
    aAdd( aPergs ,{2,"Ordenar por?","0" , aOrdem , 100,'.T.',.F.})
	
    If ParamBox(aPergs ,"Ordem",@aRet)
        nOpcao := val(aRet[1])
        If nOpcao == 0
            Return 
        EndIf 
    EndIf 

    If nOpcao == 1
        u_fCreateFK7(cEmpAnt,cFilDest,.T.,cUserName)
    ElseIf nOpcao == 2
        u_CreateFKs(cEmpAnt,cFilDest,.T.,cUserName)
    EndIf

Return 

/*/{Protheus.doc} GravaPN2
    Cria a codificação na empresa integradora na PN2 e SX5000 - ZK
    @type  Static Function
    @author user Julio Saraiva
    @since 01/10/2024    
    @version version
    @param Filial destino, Nome da empresa
    @return return true or false
/*/
Static Function GravaPN2(cFilDest)
Local aArea     := GetArea()
Local cQuery    := " "
Local cProxPn2  := ""
Local cProxZK   := ""
Local lRet      := .T.
Local cUm       := '1'
Local cDois     := '2'

cQuery += " SELECT MAX(PN2_CINTEG) AS PROXPN2 FROM " + RetSQLName("PN2") 
cQuery += " WHERE SUBSTR(PN2_CINTEG,1,1)='0' "
cQuery += " ORDER BY PN2_CINTEG  " 

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

If !eof()
    cProxPn2 := Soma1(TRB->PROXPN2)
    cCodPN2  := cProxPn2
    dbSelectArea("PN2")
    PN2->( dbSetOrder(1) )
    PN2->( dbSeek(FwXFilial() + cProxPN2) )
    If !Found()
        //Grava PN2
        RecLock('PN2',.T.)
        PN2_FILIAL := FWxFilial()
        PN2_CINTEG := cProxPN2
        PN2_DSCEMP := Alltrim(cNomeFil)
        PN2_EMPFAT := cEmpAnt
        PN2_FILFAT := cFilDest
        PN2_GPRPEX := cUm
        PN2_GCTREX := cUm
        PN2_GMEDEX := cUm
        PN2_GPDVEX := cUm	
        PN2_GNOTEX := cUm	
        PN2_WPRPSI := cDois
        PN2_WPRPST := cDois	
        PN2_WVIGSI := cDois
        PN2_WVIGST := cDois	
        PN2_WCANSI := cDois	
        PN2_WCANST := cDois	
        PN2_OPORLD := cDois	
        PN2_INTONL := cDois	
        PN2_INTCLI := cDois
        PN2_WELONL := cDois	
        PN2_MSBLQL := cDois
        PN2_CLCIMP := cDois
        PN2_GRJSPR := cDois
        PN2_VDIREQ := cDois
        PN2_TACESS := cUm
        PN2_WSSNCN := cDois
        PN2->( MSUnlock() )
        lRet := .T.
    Else
        lRet:=.F.
    Endif
Else
    lRet := .F.
Endif

PN2->( dbCloseArea() )

If Select('TRB') > 0
    dbSelectArea('TRB')
    TRB->( dbCloseArea() )
EndIf

If lRet
    cQuery := " "
    cQuery += " SELECT MAX(LPAD(TRIM(X5_CHAVE),2,'0')) AS PROXZK FROM " + RetSQLName("SX5") 
    cQuery += " WHERE X5_TABELA='ZK' AND X5_FILIAL=' ' AND D_E_L_E_T_=' ' AND X5_CHAVE<>'ZK'  " 

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")

    cAlias := "SX5"

    If !eof()
        cProxZK := Soma1(AllTrim(TRB->PROXZK))
        dbSelectArea(cAlias)
        //&(cAlias+"->"+Alltrim(aHoBrw2[nPosFil,2])) := oBrw2:aCols[nCont,nPosFil]
        dbSetOrder(1)
        dbSeek(FwXFilial() + "ZK" + cProxZK)
        If !Found()
            //Grava ZK
            RecLock(cAlias,.T.)
            &(cAlias+"->X5_FILIAL") := FWxFILIAL()
            &(cAlias+"->X5_TABELA") := 'ZK'
            &(cAlias+"->X5_CHAVE")  := cProxZK
            &(cAlias+"->X5_DESCRI") := Alltrim(cNomeFil)
            &(cAlias+"->X5_DESCSPA"):= Alltrim(cNomeFil)
            &(cAlias+"->X5_DESCENG"):= Alltrim(cNomeFil)            
            lRet := .T.
        Else
            lRet:=.F.
        Endif
    Else
        lRet := .F.
    Endif

    dbCloseArea()

Endif

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

RestArea(aArea)

Return lRet


/*/{Protheus.doc} fLogCont
    Mostra os logs dos contratos
    @type  Static Function
    @author user Geanlucas Rodrigues
    @since 27/09/2024    
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fLogCont(cArquivo)
    
    Local aArea     := FWGetArea()

    If !Empty(cArquivo)
        ShowMemo(cArquivo)
    EndIf
 
    FWRestArea(aArea)

Return 


/*/{Protheus.doc} GetCSS
    Altera as cores dos botões
    @type  Static Function
    @author user Geanlucas Rodrigues
    @since 09/10/2024    
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GetCSS(cClass)
    Local cCSS      := '' 
    Default cClass  := ''
    
    If cClass == 'oBtn1'

        // cCSS += "   TButton {  font: bold; "    
        cCSS += "   TButton {  "    
        cCSS += "               background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #FFB6C1, stop: 1 #8B0000); "   
        cCSS += "               color: #FFFFFF;     border-width: 1px;     border-style: solid;     border-radius: 3px; "    
        cCSS += "               border-color: #A52A2A; } "
        cCSS += "   TButton:focus { padding:0px; "
        cCSS += "                   outline-width:1px; "
        cCSS += "                   outline-style:solid; "
        cCSS += "                   outline-color: #DC143C; "
        cCSS += "                   outline-radius:3px; "
        cCSS += "                   border-color:#A52A2A;} "
        cCSS += "   TButton:hover { color: #FFFFFF; " 
        cCSS += "                   background-color : qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #FFB6C1, stop: 1 #8B0000); "   
        cCSS += "                   border-width: 1px; "    
        cCSS += "                   border-style: solid; "    
        cCSS += "                   border-radius: 3px; "    
        cCSS += "                   border-color: #A52A2A; } "
        cCSS += "   TButton:pressed {   color: #FFF; "   
        cCSS += "                       background-color : qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #8B0000, stop: 1 #FFB6C1); "   
        cCSS += "                       border-width: 1px;     border-style: solid;     border-radius: 3px;     border-color: #A52A2A; } "
        cCSS += "   TButton:disabled {  color: #FFFFFF; "    
        cCSS += "                       background-color: #FFB6C1; } "
    ElseIf cClass $ 'oBtn9/oBtnD'

        cCSS += "   TButton {  "
        cCSS += "               background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #3DAFCC, stop: 1 #0D9CBF); "   
        cCSS += "               color: #FFFFFF; "    
        cCSS += "               border-width: 1px; "    
        cCSS += "               border-style: solid; "    
        cCSS += "               border-radius: 3px; "    
        cCSS += "               border-color: #369CB5; } "
        cCSS += "   TButton:focus { padding:0px; "
        cCSS += "                   outline-width:1px; "
        cCSS += "                   outline-style:solid; "
        cCSS += "                   outline-color: #51DAFC; "
        cCSS += "                   outline-radius:3px; "
        cCSS += "                   border-color:#369CB5;} "
        cCSS += "   TButton:hover { color: #FFFFFF; "    
        cCSS += "                   background-color : qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #3DAFCC, stop: 1 #1188A6); "   
        cCSS += "                   border-width: 1px; "    
        cCSS += "                   border-style: solid; "    
        cCSS += "                   border-radius: 3px; "    
        cCSS += "                   border-color: #369CB5; } "
        cCSS += "   TButton:pressed {   color: #FFF; "    
        cCSS += "                       background-color : qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #1188A6, stop: 1 #3DAFCC); "   
        cCSS += "                       border-width: 1px; "   
        cCSS += "                       border-style: solid; "    
        cCSS += "                       border-radius: 3px; "    
        cCSS += "                       border-color: #369CB5; }"
        cCSS += "   TButton:disabled {  font: bold; "     
        cCSS += "                       background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #A9A9A9, stop: 1 #696969); "   
        cCSS += "                       color: #FFFFFF; "    
        cCSS += "                       border-width: 1px; "    
        cCSS += "                       border-style: solid; "    
        cCSS += "                       border-radius: 3px; "    
        cCSS += "                       border-color: #696969; } "
    ElseIf cClass $ 'oBtn2/oBtn3/oBtn4/oBtn10/oBtnA/oBtnB/oBtnC'
        
        cCSS += "   TButton {  "
        cCSS += "               background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #32CD32, stop: 1 #008000); "   
        cCSS += "               color: #FFFFFF; "    
        cCSS += "               border-width: 1px; "    
        cCSS += "               border-style: solid; "    
        cCSS += "               border-radius: 3px; "    
        cCSS += "               border-color: #228B22; } "
        cCSS += "   TButton:focus { padding:0px; "
        cCSS += "                   outline-width:1px; "
        cCSS += "                   outline-style:solid; "
        cCSS += "                   outline-color: #32CD32; "
        cCSS += "                   outline-radius:3px; "
        cCSS += "                   border-color:#228B22;} "
        cCSS += "   TButton:hover { color: #FFFFFF; "    
        cCSS += "                   background-color : qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #32CD32, stop: 1 #008000); "   
        cCSS += "                   border-width: 1px; "    
        cCSS += "                   border-style: solid; "    
        cCSS += "                   border-radius: 3px; "    
        cCSS += "                   border-color: #228B22; } "
        cCSS += "   TButton:pressed {   color: #FFF; "    
        cCSS += "                       background-color : qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #008000, stop: 1 #32CD32); "   
        cCSS += "                       border-width: 1px; "   
        cCSS += "                       border-style: solid; "    
        cCSS += "                       border-radius: 3px; "    
        cCSS += "                       border-color: #228B22; }"
        cCSS += "   TButton:disabled {  font: bold; "     
        cCSS += "                       background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #A9A9A9, stop: 1 #696969); "   
        cCSS += "                       color: #FFFFFF; "    
        cCSS += "                       border-width: 1px; "    
        cCSS += "                       border-style: solid; "    
        cCSS += "                       border-radius: 3px; "    
        cCSS += "                       border-color: #696969; } "
    EndIf
Return(cCSS)

/*/{Protheus.doc} VerJson()
    Carregar o json enviado pela API
    @type  Static Function
    @author user
    @since 31/10/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function VerJson()

    Local cJson := ''
    
    Local cJsonFormatado := ''
    
    DbSelectArea("P98")
    DbGoto(aListaD1[oListD1:nAt,len(aListaD1[oListD1:nAt])-1]) 

    //cJson := FWJsonSerialize(P98->P98_BODY)
    cJson := P98->P98_BODY
    cJsonFormatado := JsonFormatar(cJson)
    // Exibe o JSON formatado em tela
    oJsonShow  := MSDialog():New( 092,232,727,915,"Json Recebido",,,.F.,,,,,,.T.,,,.T. )
    oMGet1     := TMultiGet():New( 004,008,{|u| If(Pcount()>0,cJsonFormatado:=u,cJsonFormatado)},oJsonShow,320,284,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
    oJsonBt    := TButton():New( 292,144,"Sair",oJsonShow,{||oJsonShow:end()},037,012,,,,.T.,,"",,,,.F. )

    oJsonShow:Activate(,,,.T.)
Return

// Função para formatar o JSON
Static Function JsonFormatar(cJson)
    Local cResultado := ""
    Local nIndent := 0
    Local nLen := Len(cJson)
    Local i

    For i := 1 To nLen
        cChar := SubStr(cJson, i, 1)
        
        // Adiciona quebras de linha e indentação conforme necessário
        Do Case
            Case cChar == "{".Or.cChar == "["
                nIndent++
                cResultado += cChar + CRLF + Replicate(" ", nIndent * 4)
            Case cChar == "}".Or.cChar == "]"
                nIndent--
                cResultado += CRLF + Replicate(" ", nIndent * 4) + cChar
            Case cChar == ","
                cResultado += cChar + CRLF + Replicate(" ", nIndent * 4)
            Case cChar == ":"
                cResultado += cChar + " "
            Otherwise
                cResultado += cChar
        EndCase
    Next i

Return cResultado

/*/{Protheus.doc} fReprocess()
    Reprocessar Tabelas 
    @type  Static Function
    @author Geanlucas Sousa
    @since 05/11/2024
/*/
Static Function fReprocess()

    Local aArea     := FWGetArea()
    Local cUpdate   := ''
    Local cSelect   := ''
    Local cWhere    := ''
    Local cCampo1   := ''
    Local cCampo2   := ''
    Local cCampo3   := ''
    Local cCampo4   := ''
    Local cCampo5   := ''
    Local cCampo6   := ''
    Local cConteud1 := ''
    Local cConteud2 := ''
    Local cConteud3 := ''
    Local cConteud4 := ''
    Local cConteud5 := ''
    Local cConteud6 := ''
    Local cCpoContr := ''
    Local nOpca     := 0
    Local nA        := 0
    Local nB        := 0
    Local nC        := 0
    Local nTotal    := 0
    Local nPos      := 0
    Local lSucesso  := .F.
    Local aTab      := Separa(cTabRsg,'/')

    Local oDlgL1,oDlgL2,oDlgL3
    lOCAL oGrp1,oGrp2,oGrp3
    Local oBtnL1,oBtnL2,oBtnL3,oBtnL4,oBtnL5,oBtnL6

    Local oSay1a,oSay1b,oSay1c,oSay1d,oSay1e,oSay1f,oSay1g
    Local oMGet1b,oMGet1c,oMGet1d,oMGet1e,oMGet1f,oMGet1g

    Local oSay2a,oSay2b,oSay2c,oSay2d,oSay2e,oSay2f,oSay2g
    Local oMGet2b,oMGet2c,oMGet2d,oMGet2e,oMGet2f,oMGet2g

    Local oSay3a
    Local oMGet3b
    
    FWAlertWarning("Este Processo irá alterar o Status de processamento dos registros","Atenção !!")

    If FWAlertYesNo("Deseja Reprocessar TODOS os registros do conjunto de tabelas posicionados?", "Atenção!")
        For nA := 1 To Len(aTab)
            cUpdate := " UPDATE "+aTab[nA]+" SET "+PrefixoCPO(aTab[nA])+"_P98STA = '0' "
            If TCSQLEXEC(cUpdate) <> 0
                FWAlertError("Não foi possível alterar o STATUS da TABELA "+ aTab[nA] + CRLF + TCSqlError(),"ATENÇÂO !!!")
            Else
                lSucesso := .T.
            EndIf
        Next nA
    Else
        If !('CN9' $ cTabRsg)
            //aTabTmp

            oDlgL1     := MSDialog():New( 092,232,506,823,"Preencha os Parametros",,,.F.,,,,,,.T.,,,.T. )
            oGrp1      := TGroup():New( 004,004,180,286,'Tabela Posicionada:    <b>'+aTab[01]+'<b>',oDlgL1,CLR_BLACK,CLR_WHITE,.T.,.F. )

            oSay1a     := TSay():New( 015,010,{||"Informe os campos e conteudos da tabela <b>"+aTab[01]+'<b>'},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)

            oSay1b     := TSay():New( 035,010,{||"Campo 1:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
            oMGet1b    := TMultiGet():New( 035,040,{|u| If(Pcount()>0,cCampo1:=u,cCampo1)},oDlgL1,050,008,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

            oSay1c     := TSay():New( 045,010,{||"Conteudo do Campo 1 separados por (,) se necessário: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
            oMGet1c    := TMultiGet():New( 055,010,{|u| If(Pcount()>0,cConteud1:=u,cConteud1)},oDlgL1,270,010,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

            oSay1d     := TSay():New( 075,010,{||"Campo 2:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
            oMGet1d    := TMultiGet():New( 075,040,{|u| If(Pcount()>0,cCampo2:=u,cCampo2)},oDlgL1,050,008,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

            oSay1e     := TSay():New( 085,010,{||"Conteudo do Campo 2 separados por (,) se necessário: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
            oMGet1e    := TMultiGet():New( 095,010,{|u| If(Pcount()>0,cConteud2:=u,cConteud2)},oDlgL1,270,010,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

            oSay1f     := TSay():New( 115,010,{||"Campo 3:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
            oMGet1f    := TMultiGet():New( 115,040,{|u| If(Pcount()>0,cCampo3:=u,cCampo3)},oDlgL1,050,008,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

            oSay1g     := TSay():New( 125,010,{||"Conteudo do Campo 3 separados por (,) se necessário: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
            oMGet1g    := TMultiGet():New( 135,010,{|u| If(Pcount()>0,cConteud3:=u,cConteud3)},oDlgL1,270,010,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

            oBtnL1     := TButton():New( 184,060,"Confirmar",oDlgL1,{|| oDlgL1:end(nOpca:=1)},037,012,,,,.T.,,"",,,,.F. )
            oBtnL2     := TButton():New( 184,180,"Sair",oDlgL1,{|| oDlgL1:end(nOpca:=0)},037,012,,,,.T.,,"",,,,.F. )

            //oBtnL1:disable()
            oDlgL1:Activate(,,,.T.)
            

            // Grupo de Perguntas das tabelas filhas, se existirem 
            If Len(aTab) > 1

                oDlgL2     := MSDialog():New( 092,232,506,823,"Preencha os Parametros",,,.F.,,,,,,.T.,,,.T. )
                oGrp2      := TGroup():New( 004,004,180,286,'Tabela Posicionada:    <b>'+aTab[02]+'<b>',oDlgL2,CLR_BLACK,CLR_WHITE,.T.,.F. )

                oSay2a     := TSay():New( 015,010,{||"Informe os campos e conteudos da tabela <b>"+aTab[02]+'<b>'},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)

                oSay2b     := TSay():New( 035,010,{||"Campo 1:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
                oMGet2b    := TMultiGet():New( 035,040,{|u| If(Pcount()>0,cCampo4:=u,cCampo4)},oDlgL2,050,008,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

                oSay2c     := TSay():New( 045,010,{||"Conteudo do Campo 1 separados por (,) se necessário: "},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
                oMGet2c    := TMultiGet():New( 055,010,{|u| If(Pcount()>0,cConteud4:=u,cConteud4)},oDlgL2,270,010,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

                oSay2d     := TSay():New( 075,010,{||"Campo 2:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
                oMGet2d    := TMultiGet():New( 075,040,{|u| If(Pcount()>0,cCampo5:=u,cCampo5)},oDlgL2,050,008,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

                oSay2e     := TSay():New( 085,010,{||"Conteudo do Campo 2 separados por (,) se necessário: "},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
                oMGet2e    := TMultiGet():New( 095,010,{|u| If(Pcount()>0,cConteud5:=u,cConteud5)},oDlgL2,270,010,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

                oSay2f     := TSay():New( 115,010,{||"Campo 3:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
                oMGet2f    := TMultiGet():New( 115,040,{|u| If(Pcount()>0,cCampo6:=u,cCampo6)},oDlgL2,050,008,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

                oSay2g     := TSay():New( 125,010,{||"Conteudo do Campo 3 separados por (,) se necessário: "},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
                oMGet2g    := TMultiGet():New( 135,010,{|u| If(Pcount()>0,cConteud6:=u,cConteud6)},oDlgL2,270,010,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

                oBtnL3     := TButton():New( 184,060,"Confirmar",oDlgL2,{|| oDlgL2:end(nOpca:=1)},037,012,,,,.T.,,"",,,,.F. )
                oBtnL4     := TButton():New( 184,180,"Sair",oDlgL2,{|| oDlgL2:end(nOpca:=0)},037,012,,,,.T.,,"",,,,.F. )

                //oBtnL3:disable()
                oDlgL2:Activate(,,,.T.)

            EndIf
        Else

            // Grupo de Perguntas para Contratos
            oDlgL3     := MSDialog():New( 092,232,506,823,"Preencha os Parametros",,,.F.,,,,,,.T.,,,.T. )
            oGrp3      := TGroup():New( 004,004,180,286,'Tabelas Posicionadas:    <b>'+cTabRsg+'<b>',oDlgL3,CLR_BLACK,CLR_WHITE,.T.,.F. )

            oSay3a     := TSay():New( 015,010,{||"Informe os CNPJ's separados por (/) se necessário "},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,188,008)
            oMGet3b    := TMultiGet():New( 025,010,{|u| If(Pcount()>0,cCpoContr:=u,cCpoContr)},oDlgL3,270,050,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

            oBtnL5     := TButton():New( 184,060,"Confirmar",oDlgL3,{|| oDlgL3:end(nOpca:=1)},037,012,,,,.T.,,"",,,,.F. )
            oBtnL6     := TButton():New( 184,180,"Sair",oDlgL3,{|| oDlgL3:end(nOpca:=0)},037,012,,,,.T.,,"",,,,.F. )

            //oBtnL5:disable()
            oDlgL3:Activate(,,,.T.)

        EndIf
        
        If !('CN9' $ cTabRsg) .AND. !Empty(cCampo1) .AND. !Empty(cConteud1)
            For nB := 1 To Len(aTab)
                cWhere := " WHERE "

                If nB == 1
                    cWhere += cCampo1+" IN ('"+StrTran(cConteud1, ",", "','")+"')"
                    If !Empty(cCampo2)
                        cWhere += cCampo2+" IN ('"+StrTran(cConteud2, ",", "','")+"')"
                    ElseIf !Empty(cCampo3)
                        cWhere += cCampo3+" IN ('"+StrTran(cConteud3, ",", "','")+"')"
                    EndIf
                Else
                    cWhere += cCampo4+" IN ('"+StrTran(cConteud4, ",", "','")+"')"
                    If !Empty(cCampo5)
                        cWhere += cCampo5+" IN ('"+StrTran(cConteud5, ",", "','")+"')"
                    ElseIf !Empty(cCampo6)
                        cWhere += cCampo6+" IN ('"+StrTran(cConteud6, ",", "','")+"')"
                    EndIf
                EndIf

                For nA := 1 To Len(aTab)
                    nPos := Ascan(aTabTmp,{|x| x[2] == aTab[nA]})
                    cSelect := " SELECT COUNT(*) FROM "+aTabTmp[nPos,01]+ cWhere 

                    If Select('TRB') > 0
                        dbSelectArea('TRB')
                        dbCloseArea()
                    EndIf

                    PlsQuery(cSelect, "TRB")
                    DbSelectArea("TRB")

                    Count To nTotal

                    If nTotal > 0 
                        If FWAlertYesNo("Serão processados "+cValToChar(nTotal)+" da tabela "+aTabTmp[nPos,01]+"." + CRLF + "Desejar continuar ?", "Atenção!")

                            cUpdate := " UPDATE "+aTabTmp[nPos,01]+" SET "+PrefixoCPO(aTabTmp[nPos,02])+"_P98STA = '0' " + cWhere

                            If TCSQLEXEC(cUpdate) <> 0
                                FWAlertError("Não foi possível alterar o STATUS da TABELA "+ aTabTmp[nPos,01] + CRLF + TCSqlError(),"ATENÇÂO !!!")
                            Else
        lSucesso := .T.
                            EndIf

                        EndIf
                    Else
                        FWAlertError("Não foram encontrados registros na tabela "+ aTab[nA] + CRLF + "QUERY= "+cQuery ,"ATENÇÂO !!!")
                    EndIf
                Next nA
            Next nB
        Else
            If !Empty(cCpoContr)

                cWhere := " WHERE "
                cWhere += cCampo1+" IN ('"+StrTran(cCpoContr, "/", "'/'")+"')"

                cTabCont := ""
                For nC := 1 To Len(aTab)
                    nPos := Ascan(aTabTmp,{|x| x[2] == aTab[nC]})
                    cTabCont += "'"+aTabTmp[nPos,01]+"'"
                    If nC < Len(aTab)
                        cTabCont += ","
                    EndIf
                Next nC

                // Continuar Montando a query de contratos 
                cSelect := " SELECT COUNT(*) FROM "+aTabTmp[nPos,01]+ cWhere 

                If Select('TRB') > 0
                    dbSelectArea('TRB')
                    dbCloseArea()
                EndIf

                PlsQuery(cSelect, "TRB")
                DbSelectArea("TRB")

                Count To nTotal

                If nTotal > 0 
                    If FWAlertYesNo("Serão processados "+cValToChar(nTotal)+" da tabela "+aTabTmp[nPos,01]+"." + CRLF + "Desejar continuar ?", "Atenção!")

                        //Montar Update de contratos
                        cUpdate := " UPDATE "+aTabTmp[nPos,01]+" SET "+PrefixoCPO(aTabTmp[nPos,02])+"_P98STA = '0' " + cWhere

                        // If TCSQLEXEC(cUpdate) <> 0
                        //     FWAlertError("Não foi possível alterar o STATUS da TABELA "+ aTabTmp[nPos,01] + CRLF + TCSqlError(),"ATENÇÂO !!!")
                        // Else
                        //     lSucesso := .T.
                        // EndIf
                    EndIf
                Else
                    FWAlertError("Não foram encontrados registros na tabela "+ aTab[nA] + CRLF + "QUERY= "+cQuery ,"ATENÇÂO !!!")
                EndIf

            EndIf
        EndIf           

    EndIf 

    If lSucesso
        FWAlertSuccess('Reprocessamento Finalizado !', 'Sucesso')
    EndIf

    FWRestArea(aArea)

Return

/*/{Protheus.doc} fTables()
    Chama a rotina informando o parametro 
    @type  User Function
    @author Geanlucas Sousa
    @since 06/11/2024
/*/
User Function fTables()
   Local aPergs := {}
   Local cTab   := Space(3)
    
    aAdd(aPergs, {1, "Informe o Alias da Tabela ", cTab, "", ".T.", "", ".T.", 10, .T.})
    aAdd(aPergs, {8, "Chave",Space(15),"","","","",80,.F.})

    If ParamBox(aPergs, "Preencha")
        If Upper(MV_PAR01) == Decode64("UVJZ")
            fConfDados(MV_PAR02)
        Else
            fWindowTab(MV_PAR01)
        EndIf
    EndIf
Return

/*/{Protheus.doc} fWindowTab()
    Monta o Browse 
    @type  Static Function
    @author Geanlucas Sousa
    @since 06/11/2024
/*/
Static Function fWindowTab(cTab)

    Local aArea       := FWGetArea()
    //Fontes
    Local cFontUti    := "Tahoma"
    Local oFontAno    := TFont():New(cFontUti,,-38)
    Local oFontSub    := TFont():New(cFontUti,,-20)
    Local oFontSubN   := TFont():New(cFontUti,,-20,,.T.)
    Local oFontBtn    := TFont():New(cFontUti,,-14)
    Local aSeek       := {}
    Local cIndTmp     := GetNextAlias()
    Local cCampos     := "P98_TABELA"

    //Janela e componentes
    Private oDlgGrp
    Private oPanGrid    
    Private oGetGrid
    Private aColunas    := {}
    Private cAliasTab   := Upper(cTab)
    //Tamanho da janela
    Private aTamanho    := MsAdvSize()
    Private nJanLarg    := aTamanho[5]
    Private nJanAltu    := aTamanho[6]
     
    fMontaHead()
    
    If cAliasTab == 'P98'
        IndRegua(cAliasTab, cIndTmp, cCampos)
    EndIf

    //Criando a janela
    DEFINE MSDIALOG oDlgGrp TITLE " Ajusta Dados" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Labels gerais
        @ 004, 003 SAY "WH"                     SIZE 200, 030 FONT oFontAno  OF oDlgGrp /*COLORS RGB(149,179,215)*/ PIXEL
        @ 004, 050 SAY "IntegraMais"            SIZE 200, 030 FONT oFontSub  OF oDlgGrp /*COLORS RGB(031,073,125)*/ PIXEL
        @ 014, 050 SAY "Dados Transitórios "    SIZE 200, 030 FONT oFontSubN OF oDlgGrp /*COLORS RGB(031,073,125)*/ PIXEL
     
        //Botões
        @ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar" SIZE 050, 018 OF oDlgGrp ACTION (oDlgGrp:End(&(cAliasTab)->( MSUnlock() )))   FONT oFontBtn PIXEL
     
        //Dados
        @ 024, 003 GROUP oGrpDad TO (nJanAltu/2-003), (nJanLarg/2-003) PROMPT "Browse" OF oDlgGrp COLOR 0, 16777215 PIXEL
        oGrpDad:oFont := oFontBtn
            oPanGrid := tPanel():New(033, 006, "", oDlgGrp, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2 - 13),     (nJanAltu/2 - 45))
            oGetGrid := FWBrowse():New()
            oGetGrid:DisableConfig()
            oGetGrid:DisableReport()
            oGetGrid:DisableSaveConfig()
            oGetGrid:SetFontBrowse(oFontBtn)
            oGetGrid:SetAlias(cAliasTab)
            oGetGrid:SetSeek(,aSeek)
            oGetGrid:SetDataTable()
            oGetGrid:SetFilterDefault("")
            oGetGrid:SetDBFFilter(.T.)
            oGetGrid:SetUseFilter(1)
            oGetGrid:SetEditCell(.T., {|| .T.})  
            oGetGrid:lHeaderClick := .F.
            If cAliasTab == 'P98'
                oGetGrid:AddLegend(cAliasTab + "->P98_STATUS == '0'", "YELLOW", "Prontos para Migrar")
                oGetGrid:AddLegend(cAliasTab + "->P98_STATUS == '1'", "GREEN",  "Migrados")
                oGetGrid:AddLegend(cAliasTab + "->P98_STATUS >= '2'", "RED",    "Erro na Migração")
            EndIf
            oGetGrid:SetColumns(aColunas)
            oGetGrid:SetOwner(oPanGrid)

            Reclock(cAliasTab,.F.)
            
            oGetGrid:Activate()
    ACTIVATE MsDialog oDlgGrp CENTERED
        
    FWRestArea(aArea)
Return

/*/{Protheus.doc} fMontaHead()
    Monta a tela 
    @type  Static Function
    @author Geanlucas Sousa
    @since 06/11/2024
/*/     
Static Function fMontaHead()
    Local aStruct   := {}
    Local aHeadAux  := {}
    Local nAtual    := 0
    Local nI        := 0

    DbSelectArea(cAliasTab)
    aStruct   := FWSX3Util():GetListFieldsStruct( cAliasTab , /* bAvalCampo */, /* lViewUsado */ )
     
    //Adicionando colunas
    //[1] - Campo da Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - Máscara
    //[7] - Editável? .T. = sim, .F. = não

    For nI := 1 To Len(aStruct)
        If aStruct[nI,1] == "P98_BODY"
            aAdd(aHeadAux, {aStruct[nI,1], FWSX3Util():GetDescription( aStruct[nI,1] )  , "C", aStruct[nI,3],  aStruct[nI,4], "", .T.})
        Else
            aAdd(aHeadAux, {aStruct[nI,1], FWSX3Util():GetDescription( aStruct[nI,1] )  , aStruct[nI,2], aStruct[nI,3],  aStruct[nI,4], "", .T.})
        EndIf
    Next
     
    //Percorrendo e criando as colunas
    For nAtual := 1 To Len(aHeadAux)
        oColumn := FWBrwColumn():New()
        oColumn:SetData(&("{|| " + cAliasTab + "->" + aHeadAux[nAtual][1] +"}"))
        oColumn:SetTitle(aHeadAux[nAtual][2])
        oColumn:SetType(aHeadAux[nAtual][3])
        oColumn:SetSize(aHeadAux[nAtual][4])
        oColumn:SetDecimal(aHeadAux[nAtual][5])
        oColumn:SetPicture(aHeadAux[nAtual][6])
   
        //Se for ser possível ter o duplo clique
        If aHeadAux[nAtual][7]
            oColumn:SetEdit(.T.)
            oColumn:SetReadVar(aHeadAux[nAtual][1])
        EndIf
   
        aAdd(aColunas, oColumn)

        aDel(aHeadAux[nAtual], 7)
        aSize(aHeadAux[nAtual], Len(aHeadAux[nAtual]) - 1)
    Next
    
Return aHeadAux
     
Static Function fConfDados(cKey)
    Local aArea
    Local cPrmRun := alltrim(SuperGetMV("TI_XKEYINC",.F.,'VkVOQU5DSU8vR0VBTi9TQVJBSVZB'))
    Private lProgInic := .F.
    
    lContinua := .t. //FWIsAdmin()
    aArea := FwGetArea()

    //Se deu tudo certo, abre a tela
    If lContinua
        If Alltrim(cKey) $ Decode64(cPrmRun) //fLogin()
      
            fMontaTela()
            
        EndIf
    Else
        FWAlertError("Somente usuários admin podem acessar a rotina!", "Atenção")
    EndIf

    FwRestArea(aArea)
Return

/*/{Protheus.doc} fMontaTela
Função que realiza a montagem da tela
@type  Function
@author Geanlucas Sousa
@since 
@version version

/*/

Static Function fMontaTela()
    Local nLinObj       := 0
    Local nLargBtn      := 60
    Local cPastaTemp    := GetTempPath()
    Local bBkpF3        := {|| }
    Local bBkpF5        := {|| }
    Local bExecutar     := {|| fZeraLog(), fExecutar() }
    Local bHistoric     := {|| fZeraLog(), fAbreHist() }
    Local bAbrir        := {|| fZeraLog(), fAbrir() }
    Local bSalvar       := {|| fZeraLog(), fSalvar() }
    Local bFechar       := {|| oDlgSQL:End() }
	//Local bExportar     := {|| fZeraLog(), fExportar() }
    Local bExportar     := {|| fZeraLog(), fExport2() }
	//Local bIndentar     := {|| fZeraLog(), fIndentar() }
    Local bIndentar     := {|| fZeraLog(), FormatSQL(cMemoL) }
	Local bSelect       := {|| fZeraLog(), fGerSelect() }
	Local bUpdate       := {|| fZeraLog(), fGerUpdate() }
    Local bCampos       := {|| fZeraLog(), fConsSX3() }
    Local oMemoL
    Local oFont  := TFont():New("Consolas",, 28,, .F.,,,,, .F., .F.)   
    Local cStyle := "QFrame{ border-style:solid; border-width:3px; border-color:#003366; background-color:#373738 }"
    Private cFontPad    := "Tahoma"
    Private oFontBtn    := TFont():New(cFontPad, , -14)
	Private oFontBtnN   := TFont():New(cFontPad, , -14, , .T.)
    Private oFontMod    := TFont():New(cFontPad, , -38)
	Private oFontSub    := TFont():New(cFontPad, , -20)
	Private oFontSubN   := TFont():New(cFontPad, , -20, , .T.)
    Private cUltPasta  := cPastaTemp
    Private cLastQry   := cPastaTemp + "fConfDados.txt"
    Private cPastaHist := cPastaTemp + "historico_fConfDados\"
    Private lCentered
    Private oBtnExe
    Private oBtnHis
    Private oBtnAbr
    Private oBtnSal
    Private oBtnFec
	Private oBtnExp
	Private oBtnInd
	Private oBtnSel
	Private oBtnUpd
    Private oSayModulo, cSayModulo := 'WH'
    Private oSayTitulo, cSayTitulo := 'Integramais'
    Private oSaySubTit, cSaySubTit := 'Execucao de Queries SQL'
    Private oDlgSQL
    Private oPanSQL
    Private oPanResult
    Private oEditSQL, cEditSQL := "Digite aqui a query..."
    Private oSayLog, cSayLog
    Private aTamanho
    Private nJanLarg
    Private nJanAltu
    Private nJanAltMei
    Private nPosTop
    Private nPosLeft
    Private oEditResult
    Private oMResult
    Private aHeadResu  := {}
    Private lEmExecucao := .F.
    Private cAliasResu  := ""
    Private cMemoL  := "" 

    If lProgInic
        aTamanho  := GetScreenRes()
        nJanLarg  := aTamanho[1]
        nJanAltu  := aTamanho[2] - 80
        lCentered := .F.
        nPosTop   := 0
        nPosLeft  := -10
    Else
        aTamanho  := MsAdvSize()
        nJanLarg  := aTamanho[5]
        nJanAltu  := aTamanho[6]
        lCentered := .T.
        nPosTop   := 0
        nPosLeft  := 0
    EndIf
    nJanAltMei := nJanAltu/4

    //Se existir o arquivo, busca o conteúdo
    If File(cLastQry)
        oFile   := FwFileReader():New(cLastQry)
        If oFile:Open()
            //Busca o conteúdo do arquivo
            cArqConteu := oFile:FullRead()
            //cEditSQL   := cArqConteu
            cMemoL   := cArqConteu
            oFile:Close()
        EndIf
    EndIf

	//Define os atalhos do F3 e F5
    bBkpF3 := SetKey(VK_F3, bCampos)
	bBkpF5 := SetKey(VK_F5, bExecutar)

    //Cria a janela
    oDlgSQL := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cSayTitulo, , , , , CLR_BLACK, RGB(0, 51, 102), , , .T.)
        //Títulos e SubTítulos
        oSayModulo := TSay():New(004, 003, {|| cSayModulo}, oDlgSQL, "", oFontMod,  , , , .T., RGB(149, 179, 215), , 200, 30, , , , , , .F., , )
        oSayTitulo := TSay():New(004, 045, {|| cSayTitulo}, oDlgSQL, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 200, 30, , , , , , .F., , )
        oSaySubTit := TSay():New(014, 045, {|| cSaySubTit}, oDlgSQL, "", oFontSubN, , , , .T., RGB(031, 073, 125), , 300, 30, , , , , , .F., , )

		//Botões
        oBtnExe := TButton():New(001, (nJanLarg/2) - (nLargBtn * 5), "[F5] Executar",      oDlgSQL, bExecutar, nLargBtn,   012, , oFontBtnN, , .T., , , , , , )
        oBtnHis := TButton():New(001, (nJanLarg/2) - (nLargBtn * 4), "Ver Histórico",      oDlgSQL, bHistoric, nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
        oBtnAbr := TButton():New(001, (nJanLarg/2) - (nLargBtn * 3), "Abrir .sql",         oDlgSQL, bAbrir,    nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
        oBtnSal := TButton():New(001, (nJanLarg/2) - (nLargBtn * 2), "Salvar .sql",        oDlgSQL, bSalvar,   nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
        oBtnFec := TButton():New(001, (nJanLarg/2) - (nLargBtn * 1), "Fechar",             oDlgSQL, bFechar,   nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
		oBtnExp := TButton():New(015, (nJanLarg/2) - (nLargBtn * 4), "Export. Resultado",  oDlgSQL, bExportar, nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
		oBtnInd := TButton():New(015, (nJanLarg/2) - (nLargBtn * 3), "Indentar Query",     oDlgSQL, bIndentar, nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
		oBtnSel := TButton():New(015, (nJanLarg/2) - (nLargBtn * 2), "Gerar Select",       oDlgSQL, bSelect,   nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
		oBtnUpd := TButton():New(015, (nJanLarg/2) - (nLargBtn * 1), "Gerar Update",       oDlgSQL, bUpdate,   nLargBtn,   012, , oFontBtn,  , .T., , , , , , )

        //Observação
        nLinObj := 028
        oSayObs := TSay():New(nLinObj, 003, {|| "Para executar queries: ou 1 = Selecione o texto e aperte F5, ou 2 = Aperte F5 que irá executar todo o texto digitado"}, oDlgSQL, "", oFontBtn, , , , .T., RGB(150, 150, 150), , (nJanLarg/2) - 6, 10, , , , , , .F., , )

        //Cria o editor de consulta SQL   

        If __nHeight == NIL
            If oMainWnd == NIL
                oMainWnd := oWnd
            EndIf 
            __nHeight := oMainWnd:nHeight - 100
            __nWidth  := oMainWnd:nWidth - 30
        EndIf         
		nLinObj := 038

        oPanSQL := TPanelCss():New(nLinObj,003,nil,oDlgSQL,nil,nil,nil,nil,nil,(nJanLarg/2) - 3, nJanAltMei - 26)
        oPanSQL :setCSS(cStyle)        

        oMemoL := tMultiget():new(,, bSETGET(cMemoL), oPanSQL)
        oMemoL:Align := CONTROL_ALIGN_ALLCLIENT
        oMemoL:oFont:=oFont


        //Cria o Painel que conterá o resultado
        nLinObj := nJanAltMei + 12
        oPanResult := tPanel():New(nLinObj, 3, "", oDlgSQL, , , , RGB(000,000,000), RGB(200,200,200), (nJanLarg/2) - 3, (nJanAltu/2) - nLinObj - 10)

        //Log dos erros
        nLinObj := (nJanAltu/2) - 10
        oSayLog := TSay():New(nLinObj, 003, {|| cSayLog}, oDlgSQL, "", oFontBtn, , , , .T., RGB(254, 0, 0), , (nJanLarg/2) - 6, 10, , , , , , .F., , )

    //Ativa e exibe a janela
    oDlgSQL:Activate(, , , lCentered, {|| .T.}, , )

    //Volta o Backup dos atalhos
    SetKey(VK_F3, bBkpF3)
	SetKey(VK_F5, bBkpF5)
Return

/*/{Protheus.doc} fExecutar
Função que executa a instrução SQL
@type  Function
@author Geanlucas Sousa
@since 
@version version
/*/

Static Function fExecutar()
    Local cComeco    := ""
    Local cTextoSel  := cMemoL
    Local lContinua  := .T.
    Local cTexto     := cMemoL
    Local lInto      := .F.
    Local nPosicao   := 0
    Local cTextoNov  := ""
    Local lApostrofo := .F.
    Local cCaractere := ""
    Local cApenasSel := ""
    
    //Se estiver em execução, avisa que não é possível
    If lEmExecucao
        cSayLog := "Existe uma query em execução na memória, aguarde o término!"
        oSayLog:Refresh()
        FWAlertError(cSayLog, "Atenção")

    //Senão executa a query
    Else
        lEmExecucao := .T.
        //Se existir texto selecionado
        If ! Empty(cTextoSel)
            //Substitui o caractere interrogação por espaço vazio (-enter- e -tab-)
            cTextoSel := StrTran(cTextoSel, "?", '')

        //Senão, será todo o texto digitado
        Else
            cTextoSel := cTexto
        EndIf
        
        //Grava o texto na temporária do S.O. (arquivo temporário)
        fSalvArq(cLastQry)

        //Grava o log na pasta do histórico
        fSalvHis(cTextoSel)

        //Se houver texto selecionado
        If ! Empty(cTextoSel)

            //Busca o começo da query, até o primeiro espaço
            cComeco := Alltrim(Upper(cTextoSel))
            cComeco := SubStr(cComeco, 1, At(' ', cComeco))

            //Verifica se tem " INTO " na query, por causa do SELECT INTO no SQL SERVER
            lInto := " INTO " $ cTextoSel

            //Se a query é para ser transformada
            If nTransQry != 0
                For nPosicao := 1 To Len(cTextoSel)
                    cCaractere := SubStr(cTextoSel, nPosicao, 1)

                    //Se for um apóstrofo
                    If cCaractere == "'"
                        lApostrofo := ! lApostrofo

                    //Se não estiver dentro de um apóstrofo
                    ElseIf ! lApostrofo
                        //Se for maiúsculo
                        If nTransQry == 1
                            cCaractere := Upper(cCaractere)

                        //Se for minúsculo
                        ElseIf nTransQry == 2
                            cCaractere := Lower(cCaractere)
                        EndIf
                    EndIf

                    cTextoNov += cCaractere
                Next

                cTextoSel := cTextoNov
            EndIf

            //Se não for Select Into
            If ! lInto
                cApenasSel := Left( cTextoSel, RAt("FROM", Upper(cTextoSel))-1 )

                //Tratativa de campos de Log
                If "_USERGI" $ Upper(cApenasSel) .Or. "_USERLGI" $ Upper(cApenasSel) .Or."_USERGA" $ Upper(cApenasSel) .Or. "_USERLGA" $ Upper(cApenasSel) 
                    If FWAlertYesNo("Foi encontrado campos de Log (LGI/LGA) no Select. Deseja já traduzir seu conteúdo?", "Confirma?")
                        cTextoSel := fTrataLG(cTextoSel)
                    EndIf
                EndIf
            EndIf

            //Se a query for um Select
            If "SELECT" $ cComeco .And. ! lInto
                //Se não tiver WHERE nem TOP
                If ! "WHERE" $ Upper(cTextoSel) .And. ! "TOP " $ Upper(cTextoSel)
                    lContinua := FWAlertYesNo("Não foi encontrado os comandos WHERE e TOP na query, isso pode causar uma lentidão na busca, deseja continuar?", "Executar SELECT")
                EndIf

                //Se for continuar, chama a execução da query
                If lContinua
                    RptStatus({|| fSelecionar(cTextoSel)}, "Processando", "Buscando Registros...")
                EndIf

            //Se for uma manipulação
            ElseIf "UPDATE" $ cComeco .Or. "INSERT" $ cComeco .Or. "DELETE" $ cComeco .Or. lInto
                lContinua := FWAlertYesNo("Comandos de manipulação de dados podem ser prejudiciais para integridade de dados na base, você deseja continuar?", "Atenção")

                //Se for continuar, chama a execução da query
                If lContinua
                    RptStatus({|| fManipular(cTextoSel)}, "Processando", "Atualizando Registros...")
                EndIf

            //Senão, não encontrou
            Else
                cSayLog := "Comando não reconhecido!"
                oSayLog:Refresh()
                FWAlertError(cSayLog, "Atenção")
            EndIf
        Else
            cSayLog := "Selecione o texto da query que será executada"
            oSayLog:Refresh()
            FWAlertInfo(cSayLog, "Atenção")
        EndIf

        lEmExecucao := .F.
    EndIf
    
Return

/*/{Protheus.doc} fAbrir
Função para abrir um arquivo
@type  Function
@author Geanlucas Sousa
@since 
@version version

/*/

Static Function fAbrir()
    Local aArea   := FwGetArea()
    Local cDirIni := cUltPasta
    Local cTipArq := "Arquivos query (*.sql) | Arquivos texto (*.txt)"
    Local cTitulo := "Selecione um arquivo"
    Local lSalvar := .F.
    Local cArqSel := ""
    Local oFile
    Local cArqConteu := ""
 
    //Chama a função para buscar arquivos
    cArqSel := tFileDialog(;
        cTipArq,;  // Filtragem de tipos de arquivos que serão selecionados
        cTitulo,;  // Título da Janela para seleção dos arquivos
        ,;         // Compatibilidade
        cDirIni,;  // Diretório inicial da busca de arquivos
        lSalvar,;  // Se for .T., será uma Save Dialog, senão será Open Dialog
        ;          // Se não passar parâmetro, irá pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT será possível pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY será possível selecionar o diretório
    )

    //Se o arquivo existir
    If ! Empty(cArqSel) .And. File(cArqSel)

        //Tenta abrir o arquivo
        oFile   := FwFileReader():New(cArqSel)
        If oFile:Open()
            //Busca o conteúdo do arquivo
            cArqConteu  := oFile:FullRead()
            //oEditSQL:Load(cArqConteu)
            //oEditSQL:Refresh()
            //oPanSQL:Load(cArqConteu)
            //oPanSQL:Refresh() 
            cMemoL := cArqConteu
            oFile:Close()

            cUltPasta := SubStr(cArqSel, 1, RAt("\", cArqSel))
        Else
            cSayLog := "Não foi possível abrir o arquivo"
            oSayLog:Refresh()
            FWAlertError(cSayLog, "Atenção")
        EndIf
    EndIf
 
    FwRestArea(aArea)
Return

/*/{Protheus.doc} fSalvar
Função para salvar um arquivo acionado pelo botão
@type  Function
@author Geanlucas Sousa
@since
@version version
/*/

Static Function fSalvar()
    Local aArea   := FwGetArea()
    Local cDirIni := cUltPasta
    Local cTipArq := "Arquivos query (*.sql) | Arquivos texto (*.txt)"
    Local cTitulo := "Digite um nome do arquivo e selecione o local"
    Local lSalvar := .T.
    Local cArqSel := ""
 
    //Chama a função para buscar arquivos
    cArqSel := tFileDialog(;
        cTipArq,;  // Filtragem de tipos de arquivos que serão selecionados
        cTitulo,;  // Título da Janela para seleção dos arquivos
        ,;         // Compatibilidade
        cDirIni,;  // Diretório inicial da busca de arquivos
        lSalvar,;  // Se for .T., será uma Save Dialog, senão será Open Dialog
        ;          // Se não passar parâmetro, irá pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT será possível pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY será possível selecionar o diretório
    )

    //Se o arquivo existir
    If ! Empty(cArqSel)
        //Salva o arquivo
        fSalvArq(cArqSel)

        //Atualiza a última pasta
        cUltPasta := SubStr(cArqSel, 1, RAt("\", cArqSel))
    EndIf
 
    FwRestArea(aArea)
Return

/*/{Protheus.doc} fSalvArq
Função que salva o arquivo em uma pasta
@type  Function
@author Geanlucas Sousa
@since 
@version version

/*/

Static Function fSalvArq(cArquivo)
    Local oFWriter
    Local cTexto   := cMemoL
    
    //Grava o arquivo com o conteúdo textual
    oFWriter := FWFileWriter():New(cArquivo, .T.)
    oFWriter:Create()
    oFWriter:Write(cTexto)
    oFWriter:Close()
Return

/*/{Protheus.doc} fSalvHis
Função que salva o arquivo na pasta de histórico
@type  Function
@author Geanlucas Sousa
@since 09/07/2022
@version version

/*/

Static Function fSalvHis(cTexto)
    Local oFWriter
    Local cArquivo := cPastaHist + Left(cTexto, 3) + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-") + ".txt"
    
    //Se a pasta não existir, será criada
    If ! ExistDir(cPastaHist)
        MakeDir(cPastaHist)
    EndIf

    //Grava o arquivo com o conteúdo textual
    oFWriter := FWFileWriter():New(cArquivo, .T.)
    oFWriter:Create()
    oFWriter:Write(cTexto)
    oFWriter:Close()
Return

/*/{Protheus.doc} fConsSX3
Função para abrir a lista de campos do dicionário
@type  Function
@author Geanlucas Sousa
@since 
@version version

/*/

Static Function fConsSX3()
    Local lOk     := .F.
    Local aCampos := {}
    Local cTexto  := ""
    Local nAtual
    
    //Chama a consulta
    lOk := u_fConsSX3()

    //Se a consulta for confirmada
    If lOk
        //Se existir o retorno
        If ! Empty(__cRetorn)
            __cRetorn := Alltrim(__cRetorn)
            aCampos := StrTokArr(__cRetorn, ",")

            //Percorre os campos
            For nAtual := 1 To Len(aCampos)
                If ! Empty(aCampos[nAtual])
                    cTexto += "    " + aCampos[nAtual] + "," + CRLF
                EndIf
            Next

            //Atualiza o texto, com o que já existia
            //cEditSQL := cTexto + CRLF + oEditSQL:RetText()
            cMemoL := cTexto
            //oEditSQL:Load(cEditSQL)
            //oEditSQL:Refresh()
        EndIf
    EndIf
Return

/*/{Protheus.doc} fGerSelect
Função que gera uma query SQL
@type  Function
@author Geanlucas Sousa
@since 
@version version

/*/

Static Function fGerSelect()
    Local aPergs   := {}
    Local cTabela  := Space(20)
    Local cCampos  := Space(100)
    Local nLinhas  := 0
    Local nOrden   := 1
    Local cQuery   := ""
    
    //Adiciona os parâmetros
    aAdd(aPergs, {1, "Tabela",                          cTabela, "@!",     ".T.",        "", ".T.", 070, .T.})
    aAdd(aPergs, {1, "Campos (separados por vírgula)",  cCampos, "@!",     ".T.",        "", ".T.", 110, .F.})
    aAdd(aPergs, {1, "Número de Linhas (SQL Server)",   nLinhas, "@E 999", "Positivo()", "", ".T.", 040, .F.})
    aAdd(aPergs, {2, "Ordenação",                       nOrden,  {"1=Sem Ordenação", "2=RecNo Decrescente", "3=RecNo Crescente"},   090, ".T.", .F.})
    
    //Se a pergunta foi confirmada
    If ParamBox(aPergs, "Informe os parâmetros", , , , , , , , , .F., .F.)
        cTabela := Alltrim(MV_PAR01)
        cCampos := Alltrim(MV_PAR02)
        nLinhas := MV_PAR03
        nOrden  := Val(cValToChar(MV_PAR04))

        //Monta a query
        cQuery := " SELECT " + CRLF

        //Se houver quantidade de linhas
        If nLinhas > 0
            cQuery += " TOP " + cValToChar(nLinhas) + " " + CRLF
        EndIf

        //Se houver campos
        If ! Empty(cCampos)
            cQuery += "     " + cCampos + " " + CRLF
        Else
            cQuery += "     * " + CRLF
        EndIf

        //Agora monta o from
        cQuery += " FROM " + CRLF

        //Se o alias tiver só 3 no tamanho, busca com RetSQLName
        If Len(cTabela) == 3
            cQuery += "     " + RetSQLName(cTabela) + " T " + CRLF

        //Senão, será o nome da tabela inteira
        Else
            cQuery += "     " + cTabela + " " + CRLF
        EndIf

        //Agora por último, monta o WHERE default
        cQuery += " WHERE " + CRLF
        
        //Se a tabela for de 3 caracteres, filtra o campo de filial
        If Len(cTabela) == 3
            cQuery += "     " + IIf(SubStr(cTabela, 1, 1) == "S", SubStr(cTabela, 2), cTabela) + "_FILIAL = '" + FWxFilial(cTabela) + "' AND " + CRLF
        EndIf

        //Filtro de campo deletado
        cQuery += "     T.D_E_L_E_T_ = ' ' " + CRLF

        //Se a ordenação for diferente da padrão
        If nOrden != 1
            cQuery += " ORDER BY " + CRLF

            //Se for decrescente
            If nOrden == 2
                cQuery += "     T.R_E_C_N_O_ DESC " + CRLF

            //Se for crescente
            ElseIf nOrden == 3
                cQuery += "     T.R_E_C_N_O_ ASC " + CRLF
            EndIf
        EndIf

        //Atualiza o texto, com o que já existia
        cMemoL := cQuery
        //cEditSQL := cQuery + CRLF + oEditSQL:RetText()
        //oEditSQL:Load(cEditSQL)
        //oEditSQL:Refresh()
    EndIf
Return

/*/{Protheus.doc} fManipular
Executa uma query de manipulação na base de dados
@type  Function
@author Geanlucas Sousa
@since 
@version version

/*/

Static Function fManipular(cQuery)
    Local nStatus   := 0
    Local cMensagem := ""
    Local cInicio   := Time()
    Local cTermino  := ""
    Local aQuery    := {}
    Local nAtual    := 0

    //Se a grid existe, exclui ela
    If Type("oMResult") != "U"
        oMResult := Nil
        FreeObj(oMResult)
    EndIf

    //Se o label existe, exclui ele
    If Type("oEditResult") != "U"
        oEditResult := Nil
        FreeObj(oEditResult)
    EndIf

    //Se tiver ponto e vírgula, quebra a query para poder executar mais de um comando
    If ";" $ cQuery
        aQuery := StrTokArr(cQuery, ";")
    Else
        aQuery := {cQuery}
    EndIf

    //Define a régua
    SetRegua(1 + Len(aQuery))
    IncRegua()

    //Agora irá executar as queries
    For nAtual := 1 To Len(aQuery)
        If ! Empty(aQuery[nAtual])
            nStatus  := TCSQLExec(aQuery[nAtual])

            //Se houve erro
            If (nStatus < 0)
                cMensagem += "#" + cValToChar(nAtual) + " Erro na execução da query: " + CRLF + CRLF
                cMensagem += TCSQLError()
                cMensagem += CRLF + CRLF
            Else
                cMensagem += "#" + cValToChar(nAtual) + " Comando executado com sucesso!" + CRLF
            EndIf
        EndIf
    Next
    cTermino := Time()

    //Cria o label avisando do resultado
    oEditResult := TSimpleEditor():Create(oPanResult)
    oEditResult:lAutoIndent := .T.
    oEditResult:TextFamily("Consolas")
    oEditResult:nWidth := oPanResult:nWidth
    oEditResult:nHeight := oPanResult:nHeight
    oEditResult:TextFormat(2) //1=Html; 2=Plain Text
    oEditResult:TextSize(09)
    oEditResult:Load(cMensagem)
    oEditResult:Refresh()
    oEditResult:lReadOnly := .T.

    //Atualiza o log com o tempo total
    fAtuLog(cInicio, cTermino, 0)
Return

/*/{Protheus.doc} fZeraLog
Função acionada para zerar o log do rodapé
@type  Function
@author Geanlucas Sousa
@since 19/12/2020
@version version

/*/

Static Function fZeraLog()
    cSayLog := ""
    oSayLog:Refresh()
Return

/*/{Protheus.doc} fZeraLog
Função para atualizar o log com o tempo de execução da query
@type  Function
@author Geanlucas Sousa
@since 19/12/2020
@version version

/*/

Static Function fAtuLog(cInicio, cTermino, nQtdLinhas)
    cSayLog := "Inicio: " + cInicio
    cSayLog += " | Termino: " + cTermino
    cSayLog += " | Tempo Total: " + ElapTime(cInicio, cTermino)
    If nQtdLinhas != 0
        cSayLog += " | Quantidade de Linhas: " + cValToChar(nQtdLinhas)
    EndIf
    If ! Empty(cObserv)
        cSayLog += " | Obs: " + cObserv
    EndIf
    oSayLog:Refresh()
Return

/*/{Protheus.doc} fGerUpdate
Função que gera uma query SQL de atualização (update)
@type  Function
@author Geanlucas Sousa
@since 19/12/2020
@version version

/*/

Static Function fGerUpdate()
    Local aPergs     := {}
    Local cTabela    := Space(20)
    Local cCampo     := Space(20)
    Local cConteud   := Space(100)
    Local cQuery     := ""
    Local cTipoCampo := ""
    
    //Adiciona os parâmetros
    aAdd(aPergs, {1, "Tabela",                                        cTabela,  "@!",     ".T.",        "", ".T.", 070, .T.})
    aAdd(aPergs, {1, "Campo",                                         cCampo,   "@!",     ".T.",        "", ".T.", 100, .T.})
    aAdd(aPergs, {1, "Conteúdo",                                      cConteud, "",       ".T.",        "", ".T.", 100, .T.})
    
    //Se a pergunta foi confirmada
    If ParamBox(aPergs, "Informe os parâmetros", , , , , , , , , .F., .F.)
        cTabela   := Alltrim(MV_PAR01)
        cCampo    := Alltrim(MV_PAR02)
        cConteud  := Alltrim(MV_PAR03)

        //Monta a query
        cQuery := " UPDATE " + CRLF

        //Se o alias tiver só 3 no tamanho, busca com RetSQLName
        If Len(cTabela) == 3
            cQuery += "     " + RetSQLName(cTabela) + " " + CRLF

        //Senão, será o nome da tabela inteira
        Else
            cQuery += "     " + cTabela + " " + CRLF
        EndIf

        //Agora monta a atualização
        cQuery += " SET " + CRLF
        cQuery += "     " + cCampo + " = "

        //Se o campo existe no dicionário
        If GetSX3Cache(cCampo, "X3_TITULO") != ""
            //Busca o tipo do campo
            cTipoCampo := GetSX3Cache(cCampo, "X3_TIPO")

            //Se for data
            If cTipoCampo == 'D'
                //Se o conteúdo tiver barra
                If "/" $ cConteud
                    cConteud := dToS(cToD(cConteud))
                EndIf
            EndIf

            //Se o tipo do campo for caractere ou data
            If cTipoCampo $ 'C,D'
                //Se o conteúdo já tiver apóstrofo
                If "'" $ cConteud
                    cQuery += cConteud
                Else
                    cQuery += "'" + cConteud + "'"
                EndIf

            //Senão, atualiza com conteúdo default
            Else
                cQuery += cConteud
            EndIf

        //Senão, pega exatamente como o usuário digitou
        Else
            cQuery += cConteud
        EndIf
        cQuery += " " + CRLF

        //Agora por último, monta o WHERE default
        cQuery += " WHERE " + CRLF
        
        //Se a tabela for de 3 caracteres, filtra o campo de filial
        If Len(cTabela) == 3
            cQuery += "     " + IIf(SubStr(cTabela, 1, 1) == "S", SubStr(cTabela, 2), cTabela) + "_FILIAL = '" + FWxFilial(cTabela) + "' AND " + CRLF
        EndIf

        //Filtro de campo deletado
        cQuery += "     D_E_L_E_T_ = '' " + CRLF

        //Atualiza o texto, com o que já existia
        //cEditSQL := cQuery + CRLF + oEditSQL:RetText()
        cMemoL := cQuery
        //oEditSQL:Load(cEditSQL)
        //oEditSQL:Refresh()
    EndIf
Return

/*/{Protheus.doc} fSelecionar
Executa uma query de seleção na base de dados
@type  Function
@author Geanlucas Sousa
@since 19/12/2020
@version version

/*/

Static Function fSelecionar(cQuery)
    Local nStatus   := 0
    Local cMensagem := ""
    Local cInicio   := Time()
    Local cTermino  := ""
    Local aEstrut   := {}
    Local nCampo    := 0
    Local cCampo
    Local cTitulo
    Local cMascara
    Local nQtdLinhas := 0
    Local cAliasGrid := GetNextAlias()
    Local cMsgCpoGrd := ""
    Local nTamanCpo  := 0
    Local cTipoCpo   := ""

    SetRegua(3)
    cObserv := ""

    //Se tiver aberto o alias, fecha ele
    If Select(cAliasGrid) > 0
        (cAliasGrid)->(DbCloseArea())
    EndIf
    cAliasResu := cAliasGrid

    //Se a grid existe, exclui ela
    If Type("oMResult") != "U"
        oMResult := Nil
        FreeObj(oMResult)
    EndIf

    //Se o label existe, exclui ele
    If Type("oEditResult") != "U"
        oEditResult := Nil
        FreeObj(oEditResult)
    EndIf

    //Agora irá executar a query
    cQuery := StrTran(cQuery, "?", ' ')
    cQuery := StrTran(cQuery, CHR(10)+CHR(13), ' ')
    IncRegua()
    nStatus  := TCSQLExec(cQuery)
    cTermino := Time()

    //Se houve erro
    If (nStatus < 0)
        cMensagem := "Erro na execução da query de SELECT: " + CRLF + CRLF
        cMensagem += TCSQLError()

        //Cria o label avisando do resultado
        oEditResult := TSimpleEditor():Create(oPanResult)
        oEditResult:lAutoIndent := .T.
        oEditResult:TextFamily("Consolas")
        oEditResult:nWidth := oPanResult:nWidth
        oEditResult:nHeight := oPanResult:nHeight
        oEditResult:TextFormat(2)
        oEditResult:TextSize(09)
        oEditResult:Load(cMensagem)
        oEditResult:Refresh()
        oEditResult:lReadOnly := .T.
    Else

        //Executa a query
        IncRegua()
        TCQuery cQuery New Alias "TMP_SQL"
        Count To nQtdLinhas
        TMP_SQL->(DbGoTop())
        cTermino := Time()
        
        //Percorre a estrutura e retira campos reservados
        aEstrutTmp   := TMP_SQL->(DbStruct())
        aEstrut      := {}
        For nCampo := 1 To Len(aEstrutTmp)
            cCampo    := Alltrim(aEstrutTmp[nCampo][1])
            cTipoCpo  := aEstrutTmp[nCampo][2]
            nTamanCpo := aEstrutTmp[nCampo][3]

            //Se o campo não for um reservado, adiciona na estrutura que será usada na grid
            If ! cCampo $ "R_E_C_N_O_ , R_E_C_D_E_L_ , D_E_L_E_T_, S_T_A_M_P_, I_N_S_D_T_, D_E_L_E_T_E_D_"
                If Len(cCampo) <= 10
                    aAdd(aEstrut, aClone(aEstrutTmp[nCampo]))
                Else
                    cObserv += "Campo '" + cCampo + "' maior que 10 caracteres; "
                EndIf

                //Caso algum campo tenha sido alterado na SX3
                If cTipoCpo == "C" .And. nTamanCpo > 254
                    If Empty(cMsgCpoGrd)
                        cMsgCpoGrd := "Campos maiores que 254 caracteres (conteúdo cortado na grid): " + cCampo
                    Else
                        cMsgCpoGrd += ", " + cCampo
                    EndIf
                EndIf
            EndIf
        Next

        //Se existem campos grandes, adiciona na observação do rodapé
        If ! Empty(cMsgCpoGrd)
            cObserv += cMsgCpoGrd
        EndIf

        //Percorre a estrutura, para montar o cabeçalho da grid
        aHeadResu := {}
        For nCampo := 1 To Len(aEstrut)
            cCampo := aEstrut[nCampo][1]

            //Se o campo existir no dicionário, busca o título e a máscara dele
            If GetSX3Cache(cCampo, "X3_TITULO") != ""
                cTitulo  := Alltrim(cCampo)
                cMascara := ""
            Else
                cTitulo  := cCampo
                cMascara := ""
            EndIf

            //Adiciona no cabeçalho que será usado na grid
            aAdd(aHeadResu, {cCampo, , cTitulo, cMascara})
        Next

        //Cria a temporária que vai ser usada na grid
        oTempTable := FWTemporaryTable():New(cAliasGrid)
        oTempTable:SetFields(aEstrut)
		oTempTable:Create()

        //Agora copia os dados da query para a temporária
        DbSelectArea(cAliasGrid)
        Append From TMP_SQL
        TMP_SQL->(DbCloseArea())
        (cAliasGrid)->(DbGoTop())

        //Cria a grid
        oMResult := MsSelect():New(cAliasGrid, /*cCampo*/, /*cCpo*/, aHeadResu, /*lInv*/, /*cMar*/, {0, 0, oPanResult:nHeight / 2, oPanResult:nWidth / 2}, /*cTopFun*/, /*cBotFun*/, oPanResult)
        oMResult:oBrowse:SetCSS(fCSSGrid())
        oMResult:oBrowse:Refresh()
    EndIf

    //Atualiza o log com o tempo total
    fAtuLog(cInicio, cTermino, nQtdLinhas)
Return

/*/{Protheus.doc} fExportar
Função para exportar o resultado da query para arquivo
@type  Function
@author Geanlucas Sousa
@since 19/12/2020
@version version

/*/

Static Function fExportar()
    Local aArea     := FwGetArea()
    Local cDirIni   := cUltPasta
    Local cTipArq   := "Planilha do Excel - requer PRINTER mais novo (*.xlsx) | Planilha do Excel em XML (*.xml) | Arquivo texto (*.txt)"
    Local cTitulo   := "Selecione um local para gerar"
    Local lSalvar   := .T.
    Local cArqSel   := ""
    Local cExtensao := ""
    Local cPasta    := ""
    Local cArquivo  := ""
    Private cDelim  := ""
 
    //Se tiver grid
    If Type("oMResult") != "U"
        //Chama a função para buscar arquivos
        cArqSel := tFileDialog(;
            cTipArq,;  // Filtragem de tipos de arquivos que serão selecionados
            cTitulo,;  // Título da Janela para seleção dos arquivos
            ,;         // Compatibilidade
            cDirIni,;  // Diretório inicial da busca de arquivos
            lSalvar,;  // Se for .T., será uma Save Dialog, senão será Open Dialog
            ;          // Se não passar parâmetro, irá pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT será possível pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY será possível selecionar o diretório
        )

        //Se o arquivo existir
        If ! Empty(cArqSel)
            //Pega a extensão do arquivo
            cExtensao := Alltrim(Upper(cArqSel))
            cExtensao := SubStr(cExtensao, RAt(".", cExtensao) + 1)

            //Separa a pasta do arquivo
            cPasta   := SubStr(cArqSel, 1, RAt('\', cArqSel))
            cArquivo := StrTran(cArqSel, cPasta, '')

            //Se for texto
            If cExtensao == "TXT"
                DbSelectArea(cAliasResu)
                (cAliasResu)->(DbGoTop())

                //Realiza a exportação
                Copy To (cPasta + cArquivo) DELIMITED WITH (cDelim)

                //Abre o arquivo
                ShellExecute("OPEN", cArquivo, "", cPasta, 1)
            
            //Senão, se for planilha do Excel antiga
            ElseIf cExtensao == "XML"
                RptStatus({|| fExcel(cArqSel, 1)}, "Exportando", "Gerando Excel...")

            //Senão, se for planilha do Excel
            ElseIf cExtensao == "XLSX"
                RptStatus({|| fExcel(cArqSel, 2)}, "Exportando", "Gerando Excel...")

                //Abre o arquivo
                ShellExecute("OPEN", cArquivo, "", cPasta, 1)
            EndIf

            cUltPasta := SubStr(cArqSel, 1, RAt("\", cArqSel))
        EndIf

    Else
        cSayLog := "Para acionar a exportação, execute um SELECT"
        oSayLog:Refresh()
        FWAlertError(cSayLog, "Atenção")
    EndIf

    FwRestArea(aArea)
Return

/*/{Protheus.doc} fExcel
Função para o Excel da tabela temporária
@type  Function
@author Geanlucas Sousa
@since 19/12/2020
@version version

/*/

Static Function fExcel(cArquivo, nTipo)
	Local oFWMsExcel
	Local cWorkSheet := "fConfDados"
	Local cTitulo    := "Exportacao de dados"
	Local nTotal := 0
    Local nCampo
    Local aLinha
	
    //Define o tamanho da régua
	DbSelectArea(cAliasResu)
    (cAliasResu)->(DbGoTop())
    Count To nTotal
    SetRegua(nTotal)
    (cAliasResu)->(DbGoTop())
	
	//Cria a planilha do excel
    If nTipo == 1
        oFWMsExcel := FwMsExcel():New()
    ElseIf nTipo == 2
	    oFWMsExcel := FwMsExcelXlsx():New()
    EndIf
	
	//Criando a aba da planilha
	oFWMsExcel:AddworkSheet(cWorkSheet)
	
	//Criando a Tabela e as colunas
	oFWMsExcel:AddTable(cWorkSheet, cTitulo)
    For nCampo := 1 To Len(aHeadResu)
        //Pega o tipo do campo
        nTipo  := 1 //General
        nAlign := 1 //Left
        If GetSX3Cache(aHeadResu[nCampo][1], "X3_TIPO") == "N"
            nTipo  := 2 //Number
            nAlign := 3 //Right
        EndIf

        //Adiciona a coluna
        oFWMsExcel:AddColumn(cWorkSheet, cTitulo, aHeadResu[nCampo][3], nAlign, nTipo, .F.)
    Next
	
	//Percorrendo os dados da query
	While !((cAliasResu)->(EoF()))
		
		//Incrementando a regua
		IncRegua()

        //Cria uma nova linha
        aLinha := {}
        For nCampo := 1 To Len(aHeadResu)
            aAdd(aLinha, (cAliasResu)->(&(aHeadResu[nCampo][1])))
        Next
		
		//Adicionando uma nova linha
		oFWMsExcel:AddRow(cWorkSheet, cTitulo, aClone(aLinha))
		
		(cAliasResu)->(DbSkip())
	EndDo
	
	//Ativando o arquivo e gerando
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)
    oFWMsExcel:DeActivate()

    //Se for em XML, força abrir pelo Excel
    If nTipo == 1
        //Abrindo o excel e abrindo o arquivo xml
        oExcel := MsExcel():New()
        oExcel:WorkBooks:Open(cArquivo)
        oExcel:SetVisible(.T.)
        oExcel:Destroy()
    EndIf
Return

/*/{Protheus.doc} fExcel
Função para abrir uma URL com a query para indentação
@type  Function
@author Geanlucas Sousa
@since 19/12/2020
@version version

/*/

Static Function fIndentar()
    Local cTextoSel := cMemoL
    Local cLink     := "https://www.freeformatter.com/sql-formatter.html?sqlString="

    //Se tiver vazio o texto selecionado, mostra a mensagem
    If Empty(cTextoSel)
        cSayLog := "Selecione o texto para que seja possível indentar!"
        oSayLog:Refresh()
        FWAlertError(cSayLog, "Atenção")
    Else
        //Substitui o caractere interrogação por espaço vazio (-enter- e -tab-)
        cTextoSel := StrTran(cTextoSel, "?", '')

        //No link, será enviado a query
        cLink += cTextoSel
        ShellExecute("Open", cLink, "", "", 1)
    EndIf
Return

/*/{Protheus.doc} fAbreHist
Função para abrir a pasta do histórico de queries executadas
@type  Function
@author Geanlucas Sousa
@since 09/07/2022
@version version

/*/

Static Function fAbreHist()	
    ShellExecute("open", "explorer.exe", cPastaHist, "C:\", 1)
Return

/*/{Protheus.doc} fTrataLG
Função para tratar os logs de inclusão e alteração no Select
@type  Function
@author Geanlucas Sousa
@since 09/07/2022
@version version

/*/

Static Function fTrataLG(cQuery)
    Local nPosCorte  := RAt("FROM", Upper(cQuery))-1
    Local cApenasSel := Left(cQuery, nPosCorte)
    Local cRestante  := SubStr(cQuery, nPosCorte)
    Local cConvLGI   := "RTRIM( SUBSTRING(XXXXXXXXXX, 11, 1) + SUBSTRING(XXXXXXXXXX, 15, 1) + SUBSTRING(XXXXXXXXXX, 19, 1) + SUBSTRING(XXXXXXXXXX, 02, 1) + SUBSTRING(XXXXXXXXXX, 06, 1) + SUBSTRING(XXXXXXXXXX, 10, 1) + SUBSTRING(XXXXXXXXXX, 14, 1) + SUBSTRING(XXXXXXXXXX, 01, 1) + SUBSTRING(XXXXXXXXXX, 18, 1) + SUBSTRING(XXXXXXXXXX, 05, 1) + SUBSTRING(XXXXXXXXXX, 09, 1) + SUBSTRING(XXXXXXXXXX, 13, 1) + SUBSTRING(XXXXXXXXXX, 17, 1) + SUBSTRING(XXXXXXXXXX, 04, 1) + SUBSTRING(XXXXXXXXXX, 08, 1) ) + ' no dia ' + CONVERT(VARCHAR(10),CAST(DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(XXXXXXXXXX,12,1)) - 50, ASCII(SUBSTRING(XXXXXXXXXX,16,1)) - 50)),'1996-01-01') AS DATETIME),103) AS XXXXXXXXXX"
    Local cConvLGA   := "RTRIM( SUBSTRING(XXXXXXXXXX, 11, 1) + SUBSTRING(XXXXXXXXXX, 15, 1) + SUBSTRING(XXXXXXXXXX, 19, 1) + SUBSTRING(XXXXXXXXXX, 02, 1) + SUBSTRING(XXXXXXXXXX, 06, 1) + SUBSTRING(XXXXXXXXXX, 10, 1) + SUBSTRING(XXXXXXXXXX, 14, 1) + SUBSTRING(XXXXXXXXXX, 01, 1) + SUBSTRING(XXXXXXXXXX, 18, 1) + SUBSTRING(XXXXXXXXXX, 05, 1) + SUBSTRING(XXXXXXXXXX, 09, 1) + SUBSTRING(XXXXXXXXXX, 13, 1) + SUBSTRING(XXXXXXXXXX, 17, 1) + SUBSTRING(XXXXXXXXXX, 04, 1) + SUBSTRING(XXXXXXXXXX, 08, 1) ) + CASE WHEN SUBSTRING(XXXXXXXXXX, 03, 1) != ' ' THEN + ' no dia ' + CONVERT(VARCHAR,DATEADD(DAY,((ASCII(SUBSTRING(XXXXXXXXXX,12,1)) - 50) * 100 + (ASCII(SUBSTRING(XXXXXXXXXX,16,1)) - 50)),'19960101'),112) ELSE '' END AS XXXXXXXXXX"
    Local nPosicao   := 1
    Local cCampo     := ""
    Local cExpressao := ""

    //Percorre todo o texto, e onde tiver o campo, será realizado a tratativa
    While nPosicao < Len(cApenasSel)
        //Encontra o nome do campo
        cCampo := ""
        If SubStr(cApenasSel, nPosicao, 7) == "_USERGI" .Or.  SubStr(cApenasSel, nPosicao, 7) == "_USERGA"
            cCampo := SubStr(cApenasSel, nPosicao - 3, 10)

        ElseIf SubStr(cApenasSel, nPosicao, 8) == "_USERLGI" .Or. SubStr(cApenasSel, nPosicao, 8) == "_USERLGA"
            cCampo := SubStr(cApenasSel, nPosicao - 2, 10)
        EndIf

        //Se houver o campo, faz a conversão
        If ! Empty(cCampo)
            If Right(cCampo, 2) == "GI"
                cExpressao := StrTran(cConvLGI, "XXXXXXXXXX", cCampo)
                cApenasSel := StrTran(cApenasSel, cCampo, cExpressao)
                nPosicao += Len(cConvLGI) - 3

            ElseIf Right(cCampo, 2) == "GA"
                cExpressao := StrTran(cConvLGA, "XXXXXXXXXX", cCampo)
                cApenasSel := StrTran(cApenasSel, cCampo, cExpressao)
                nPosicao += Len(cConvLGA) - 3
            EndIf
        EndIf

        nPosicao++
    EndDo

    cQuery := cApenasSel + cRestante
Return cQuery

/*/{Protheus.doc} fConsSX3
Função para consulta genérica do dicionário
@author Geanlucas Sousa
@since 30/10/2024
@version 1.0
    @return lRetorn, retorno se a consulta foi confirmada ou não
    @obs O retorno da consulta é pública (__cRetorn) para ser usada em consultas específicas
/*/
                                                                                                                                                           
 
User Function fConsSX3()
    Local aArea := FwGetArea()
    Local nTamBtn := 50
    Local cMarca := "OK"

    Private cAliasPvt     := "SX3"
    Private aCampos       := {"X3_ARQUIVO", "X3_CAMPO", "X3_TITULO", "X3_DESCRIC"}
    Private nTamanRet     := 300
    Private cCampoRet     := "X3_CAMPO"

    Private oMAux
    Private aHeadRegs := {}
    Private cAliasTmp := cAliasPvt

    Private nJanLarg := 0800
    Private nJanAltu := 0500

    Private oDlgMark
    Private oGetPesq, cGetPesq := Space(100)
    Private oGetReto, cGetReto := Space(nTamanRet)

    Private lRetorn := .F.
    Public  __cRetorn := Space(nTamanRet)
     
    //Criando a estrutura para a MsSelect
    fCriaMsSel()

    DbSelectArea("SX3")
    SX3->(DbGoTop())
     
    //Criando a janela
    DEFINE MSDIALOG oDlgMark TITLE "Consulta de Dados" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Pesquisar
        @ 003, 003 GROUP oGrpPesqui TO 025, (nJanLarg/2)-3 PROMPT "Pesquisar: "    OF oDlgMark COLOR 0, 16777215 PIXEL
            @ 010, 006 MSGET oGetPesq VAR cGetPesq SIZE (nJanLarg/2)-12, 010 OF oDlgMark COLORS 0, 16777215  VALID (fVldPesq())      PIXEL
         
        //Dados
        @ 028, 003 GROUP oGrpDados TO (nJanAltu/2)-28, (nJanLarg/2)-3 PROMPT "Dados: "    OF oDlgMark COLOR 0, 16777215 PIXEL
            oMAux := MsSelect():New( cAliasTmp, "",, aHeadRegs,, cMarca, { 035, 006, (nJanAltu/2)-28-028, (nJanLarg/2)-6 } ,,, )
            oMAux:bAval := { || ( fGetMkA( cMarca ), oMAux:oBrowse:Refresh() ) }
            oMAux:oBrowse:lHasMark := .T.
            oMAux:oBrowse:lCanAllMark := .F.
            oMAux:oBrowse:SetCSS(u_zCSSGrid())
            @ (nJanAltu/2)-28-025, 006 SAY oSayReto PROMPT "Retorno:"     SIZE 040, 007 OF oDlgMark COLORS RGB(0,0,0) PIXEL
            @ (nJanAltu/2)-28-015, 006 MSGET oGetReto VAR cGetReto SIZE (nJanLarg/2)-12, 010 OF oDlgMark COLORS 0, 16777215      PIXEL
         
            //Populando os dados da MsSelect
            fPopula()
         
        //Ações
        @ (nJanAltu/2)-25, 003 GROUP oGrpAcoes TO (nJanAltu/2)-3, (nJanLarg/2)-3 PROMPT "Ações: "    OF oDlgMark COLOR 0, 16777215 PIXEL
            @ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*1)+06) BUTTON oBtnConf PROMPT "Confirmar" SIZE nTamBtn, 013 OF oDlgMark ACTION(fConfirm())     PIXEL
            @ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*2)+09) BUTTON oBtnLimp PROMPT "Limpar" SIZE nTamBtn, 013 OF oDlgMark ACTION(fLimpar())     PIXEL
            @ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*3)+12) BUTTON oBtnCanc PROMPT "Cancelar" SIZE nTamBtn, 013 OF oDlgMark ACTION(fCancela())     PIXEL
         
        oMAux:oBrowse:SetFocus()
    //Ativando a janela
    ACTIVATE MSDIALOG oDlgMark CENTERED
     
    FwRestArea(aArea)
Return lRetorn

Static Function fCriaMsSel()
    Local aAreaX3 := SX3->(FwGetArea())
 
    //Zerando o cabeçalho e a estrutura
    aHeadRegs := {}

    //                        Campo                Titulo            Mascara
    aAdd( aHeadRegs, {    "X3_ARQUIVO",     ,    "Tabela",        "@!" } )
    aAdd( aHeadRegs, {    "X3_CAMPO",       ,    "Campo",         "@!" } )
    aAdd( aHeadRegs, {    "X3_TITULO",      ,    "Titulo",        "@!" } )
    aAdd( aHeadRegs, {    "X3_DESCRIC",     ,    "Descricao",     "@!" } )
     
    FwRestArea(aAreaX3)
Return
 
Static Function fConfirm()
    //Setando o retorno conforme get e finalizando a tela
    lRetorn := .T.
    __cRetorn := cGetReto
     
    //Se o tamanho for menor, adiciona
    If Len(__cRetorn) < nTamanRet
        __cRetorn += Space(nTamanRet - Len(__cRetorn))
     
    //Senão se for maior, diminui
    ElseIf Len(__cRetorn) > nTamanRet
        __cRetorn := SubStr(__cRetorn, 1, nTamanRet)
    EndIf
     
    oDlgMark:End()
Return
 
Static Function fLimpar()
    //Zerando gets
    cGetPesq := Space(100)
    cGetReto := Space(nTamanRet)
    oGetPesq:Refresh()
    oGetReto:Refresh()
 
    //Atualiza grid
    fPopula()
     
    //Setando o foco na pesquisa
    oGetPesq:SetFocus()
Return
 
Static Function fCancela()
    //Setando o retorno em branco e finalizando a tela
    lRetorn := .F.
    __cRetorn := Space(nTamanRet)
    oDlgMark:End()
Return

Static Function fVldPesq()
    Local lRet := .T.
     
    //Se tiver apóstrofo ou porcentagem, a pesquisa não pode prosseguir
    If "'" $ cGetPesq .Or. "%" $ cGetPesq
        lRet := .F.
        FWAlertInfo("<b>Pesquisa inválida!</b><br>A pesquisa não pode ter <b>'</b> ou <b>%</b>.", "Atenção")
    EndIf
     
    //Se houver retorno, atualiza grid
    If lRet
        fPopula()
    EndIf
Return lRet
 
Static Function fPopula()
    Local cFiltro   := ""
    Local cPesquisa := ""

    //Se tiver vazio, limpa o filtro
    If Empty(cGetPesq)
        SX3->(DbClearFilter())
        SX3->(DbGoTop())

    //Senão, será filtrado os campos
    Else
        cPesquisa := Alltrim(Upper(cGetPesq))
        
        //Se for 3, filtra só a tabela
        If Len(cPesquisa) == 3
            cFiltro += "Upper(X3_ARQUIVO) == '" + cPesquisa + "' "
        Else
            cFiltro += "'" + cPesquisa + "' $ Upper(X3_ARQUIVO) .Or. "
            cFiltro += "'" + cPesquisa + "' $ Upper(X3_CAMPO)   .Or. "
            cFiltro += "'" + cPesquisa + "' $ Upper(X3_TITULO)  .Or. "
            cFiltro += "'" + cPesquisa + "' $ Upper(X3_DESCRIC) "
        EndIf
        SX3->(DbSetFilter({|| &(cFiltro)}, cFiltro))
    EndIf
    SX3->(DbGoTop())
    oMAux:oBrowse:Refresh()

Return

Static Function fGetMkA(cMarca)
    Local cChave  := Alltrim(&("SX3->X3_CAMPO")) + ", "
     
    //Se o tamanho do retorno +chave for maior que o retorno
    If Len(Alltrim(cGetReto) + cChave) > nTamanRet
        FWAlertInfo("Tamanho de Retorno Excedido!", "Atenção")
        
    //Atualiza chave
    Else
        cGetReto := Alltrim(cGetReto)+cChave
    EndIf
    cGetReto := cGetReto + Space(nTamanRet - Len(cGetReto))
     
    oGetReto:Refresh()
    oMAux:oBrowse:Refresh()
Return

/*/{Protheus.doc} Static Function fCSSGrid
Altera o tamanho do texto usado nas grids antigas (MsNewGetDados e MsSelect)
@type  Function
@author Geanlucas Sousa
@since 31/10/2024
@version version
@param nTamFonte, Numeric, Tamanho da fonte em pixels na grid
@example
/*/
Static Function fCSSGrid(nTamFonte)
    Local cCSSGrid := ""
    Default nTamFonte := 14
    
	cCSSGrid += "QHeaderView::section {" + CRLF
	cCSSGrid += "	background-color: #6E7D81;" + CRLF
	cCSSGrid += "	border: 1px solid #646769;" + CRLF
	cCSSGrid += "	border-bottom-color: #4B4B4B;" + CRLF
	cCSSGrid += "	border-right-color: #3F4548;" + CRLF
	cCSSGrid += "	border-left-color: #90989D;" + CRLF
	cCSSGrid += "	color: #FFFFFF;" + CRLF
	cCSSGrid += "	font-family: arial;" + CRLF
	cCSSGrid += "	height: 27px;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QHeaderView::section:pressed {" + CRLF
	cCSSGrid += "	background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #485154, stop: 1 #6D7C80);" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QTableView {" + CRLF
	cCSSGrid += "	selection-background-color: #1C9DBD;" + CRLF
	cCSSGrid += "	selection-color: #FFFFFF;" + CRLF
	cCSSGrid += "	alternate-background-color: #B2CBE7;" + CRLF
	cCSSGrid += "	background: #FFFFFF;" + CRLF
	cCSSGrid += "	color: #000000;" + CRLF
	cCSSGrid += "	font-size: " + cValToChar(nTamFonte) + "px;" + CRLF
	cCSSGrid += "	border: none;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar:horizontal {" + CRLF
	cCSSGrid += "	background-color: #F2F2F2;" + CRLF
	cCSSGrid += "	border: 1px solid #C5C9CA;" + CRLF
	cCSSGrid += "	margin: 0 15px 0px 16px;" + CRLF
	cCSSGrid += "	max-height: 16px;" + CRLF
	cCSSGrid += "	min-height: 16px;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-page:horizontal," + CRLF
	cCSSGrid += "QScrollBar::sub-page:horizontal {" + CRLF
	cCSSGrid += "	background: #F2F2F2;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::handle:horizontal {" + CRLF
	cCSSGrid += "	background-color: #B2B2B2;" + CRLF
	cCSSGrid += "	border: 3px solid #F2F2F2;" + CRLF
	cCSSGrid += "	border-radius: 7px;" + CRLF
	cCSSGrid += "	min-width: 20px;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-line:horizontal {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_hrz_btn_rgt_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "	border: 1px solid black;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-line:horizontal:pressed {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_hrz_btn_rgt_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-line:horizontal {" + CRLF
	cCSSGrid += "	border-top-width: 2px;" + CRLF
	cCSSGrid += "	border-right-width: 2px;" + CRLF
	cCSSGrid += "	border-bottom-width: 2px;" + CRLF
	cCSSGrid += "	border-left-width: 2px;" + CRLF
	cCSSGrid += "	width: 13px;" + CRLF
	cCSSGrid += "	subcontrol-position: right;" + CRLF
	cCSSGrid += "	subcontrol-origin: margin;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::sub-line:horizontal {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_hrz_btn_lft_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::sub-line:horizontal:pressed {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_hrz_btn_lft_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::sub-line:horizontal {" + CRLF
	cCSSGrid += "	border-top-width: 2px;" + CRLF
	cCSSGrid += "	border-right-width: 2px;" + CRLF
	cCSSGrid += "	border-bottom-width: 2px;" + CRLF
	cCSSGrid += "	border-left-width: 2px;" + CRLF
	cCSSGrid += "	width: 13px;" + CRLF
	cCSSGrid += "	subcontrol-position: left;" + CRLF
	cCSSGrid += "	subcontrol-origin: margin;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar:vertical {" + CRLF
	cCSSGrid += "	background-color: #F2F2F2;" + CRLF
	cCSSGrid += "	border-top-width: 0px;" + CRLF
	cCSSGrid += "	border-right-width: 0px;" + CRLF
	cCSSGrid += "	border-bottom-width: 0px;" + CRLF
	cCSSGrid += "	border-left-width: 0px;" + CRLF
	cCSSGrid += "	margin: 15px 0px 16px 0px;" + CRLF
	cCSSGrid += "	max-width: 16px;" + CRLF
	cCSSGrid += "	min-width: 16px;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-page:vertical," + CRLF
	cCSSGrid += "QScrollBar::sub-page:vertical {" + CRLF
	cCSSGrid += "	background: #F2F2F2;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::handle:vertical {" + CRLF
	cCSSGrid += "	background-color: #B2B2B2;" + CRLF
	cCSSGrid += "	border: 3px solid #F2F2F2;" + CRLF
	cCSSGrid += "	border-radius: 7px;" + CRLF
	cCSSGrid += "	min-height: 20px;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-line:vertical {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_vrt_btn_btm_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-line:vertical:pressed {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_vrt_btn_btm_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-line:vertical {" + CRLF
	cCSSGrid += "	border-top-width: 2px;" + CRLF
	cCSSGrid += "	border-right-width: 2px;" + CRLF
	cCSSGrid += "	border-bottom-width: 2px;" + CRLF
	cCSSGrid += "	border-left-width: 2px;" + CRLF
	cCSSGrid += "	height: 13px;" + CRLF
	cCSSGrid += "	subcontrol-position: bottom;" + CRLF
	cCSSGrid += "	subcontrol-origin: margin;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::sub-line:vertical {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_vrt_btn_top_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::sub-line:vertical:pressed {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_vrt_btn_top_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::sub-line:vertical {" + CRLF
	cCSSGrid += "	border-top-width: 2px;" + CRLF
	cCSSGrid += "	border-right-width: 2px;" + CRLF
	cCSSGrid += "	border-bottom-width: 2px;" + CRLF
	cCSSGrid += "	border-left-width: 2px;" + CRLF
	cCSSGrid += "	height: 13px;" + CRLF
	cCSSGrid += "	subcontrol-position: top;" + CRLF
	cCSSGrid += "	subcontrol-origin: margin;" + CRLF
	cCSSGrid += "}" + CRLF
Return cCSSGrid

  
/*/{Protheus.doc} fLogin
Função para montar a tela de login 
@author Geanlucas Sousa
@since 31/10/2024
/*/
  
Static Function fLogin()
    Local aArea     := FWGetArea()
    Local oGrpLog
    Local oBtnConf

    Private lRetorno := .F.
    Private oDlgPvt
    Private oSayUsr
    Private oGetUsr, cGetUsr := Space(25)
    Private oSayPsw
    Private oGetPsw, cGetPsw := Space(20)
    Private oGetErr, cGetErr := ""
    Private nJanLarg := 200
    Private nJanAltu := 200
      
    //Criando a janela
    DEFINE MSDIALOG oDlgPvt TITLE "Login" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Grupo de Login
        @ 003, 001     GROUP oGrpLog TO (nJanAltu/2)-1, (nJanLarg/2)-3         PROMPT "Login: "     OF oDlgPvt COLOR 0, 16777215 PIXEL
            //Label e Get de Usuário
            @ 013, 006   SAY   oSayUsr PROMPT "Usuário:"        SIZE 030, 007 OF oDlgPvt                    PIXEL
            @ 020, 006   MSGET oGetUsr VAR    cGetUsr           SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 PIXEL
          
            //Label e Get da Senha
            @ 033, 006   SAY   oSayPsw PROMPT "Senha:"          SIZE 030, 007 OF oDlgPvt                    PIXEL
            @ 040, 006   MSGET oGetPsw VAR    cGetPsw           SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 PIXEL PASSWORD
          
            //Get de Log, pois se for Say, não da para definir a cor
            @ 060, 006   MSGET oGetErr VAR    cGetErr        SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 NO BORDER PIXEL
            oGetErr:lActive := .F.
            oGetErr:setCSS("QLineEdit{color:#FF0000; background-color:#FEFEFE;}")
          
            //Botões
            @ (nJanAltu/2)-18, 006 BUTTON oBtnConf PROMPT "Confirmar"             SIZE (nJanLarg/2)-12, 015 OF oDlgPvt ACTION (fVldUsr()) PIXEL
            oBtnConf:SetCss("QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }")
    ACTIVATE MSDIALOG oDlgPvt CENTERED
      
    //Se a rotina foi confirmada e deu certo, atualiza o usuário e a senha
    If lRetorno
        cUsrLog := Alltrim(cGetUsr)
        cPswLog := Alltrim(cGetPsw)
    EndIf
      
    FWRestArea(aArea)
Return lRetorno
  
/*/{Protheus.doc} fLogin
Função para validar se o usuário existe
@author Geanlucas Sousa
@since 31/10/2025
/*/

  
Static Function fVldUsr()
    Local cUsrAux := Decode64('TWVzdHJl') 
    Local cPswAux := Decode64('V0gyMDI0') 
    Local cCodAux := ""
      
    If cUsrAux == Alltrim(cGetUsr) .And. cPswAux == Alltrim(cGetPsw)
        cCodAux := RetCodUsr()
        lRetorno := .T.
       
     //Senão atualiza o erro e retorna para a rotina
     Else
         cGetErr := "Usuário e/ou senha inválidos!"
         oGetErr:Refresh()
    EndIf
      
    //Se o retorno for válido, fecha a janela
    If lRetorno
        oDlgPvt:End()
    EndIf
Return

/*/{Protheus.doc} fCreateIdx
	Função responsável pela criação dos indices
	@type  Function
	@author Geanlucas Sousa
	@since 07/02/2025
/*/
Static Function fCreateIdx(cTab,cCpsIdx)

    Local aArea     := FWGetArea()
    Local cQry      := ''
    Local lRet      := .T.
    Local lCreate   := .T.
    Local cIdxName  := 'IDX_'+cTab+"_"+Alltrim(cCpsIdx)
    
    Default cCpsIdx   := ''
    
    // [1] Tabela, [2] Indice
    cQry := 'SELECT '+cIdxName
    cQry += ' FROM user_indexes'
    cQry += ' WHERE table_name = '+cTab

    If TCSQLEXEC(cQry) <> 0
        lCreate := .F.
    EndIf

    If lCreate
        cQry := 'CREATE INDEX '+cIdxName 
        cQry += ' ON '+cTab+FormatIn(cCpsIdx,'+')

        If TCSQLEXEC(cQry) <> 0
            FWAlertError("fCreateIdx - Não Foi Possível criar o indice da TABELA "+ cTab + CRLF + TCSqlError(),"ATENÇÂO !!!")
            lRet := .F.
        EndIf
    EndIf

    FWRestArea(aArea)

Return lRet

/*/{Protheus.doc} fDropTable
	Função responsável pela exclusão de tabelas
	@type  Function
	@author Geanlucas Sousa
	@since 07/02/2025
/*/
Static Function fDropTable(cTab)

    Local aArea     := FWGetArea()
    Local cScript   := " DROP TABLE "+cTab
    Local lRet      := .T.

    If Select(cTab) > 0
        (cTab)->(dbCloseArea())
    EndIf

    If TCSQLEXEC(cScript) <> 0
        FWAlertError("fDropTable - Não Foi Possível dropar a TABELA "+ cTab + CRLF + TCSqlError(),"ATENÇÂO !!!"   )
        lRet := .F.
    EndIf

    FWRestArea(aArea)

Return lRet

/*/{Protheus.doc} fVldCliFor
	Função checar campos de Clientes/Fornecedores 
	@type  Function
	@author Geanlucas Sousa
	@since 13/02/2025
/*/
Static Function fVldCliFor(aStruCps,cTabTmp,cTabOrig,cCliFor,cRecPag)

Local nX := 0
Local aAuxClF := {}

    For nX := 1 to len(aStruCps)
        cCombo := ""
        cCampo := alltrim(aStruCps[nX])
        nPosCh := Ascan(aX3Cache,{|x| alltrim(x[1]) == alltrim(cCampo)})

        If nPosCh > 0
            cCombo := aX3Cache[nPosCh,02]
        EndIF 

        If cTabOrig <> 'SE2' .AND. cRecPag <> 'P' .AND. (Alltrim(cCombo) == "SA1" .OR. (SUBSTR(cCampo,AT("_",cCampo)+1,6) $ Alltrim(cParamd) .AND. (Empty(cCombo) .OR. cCombo == "CLIFOR" ))) //.AND. lRecPag
            Aadd(aAuxClF,cCampo)
            fCreateIdx(cTabTmp,cCampo)
            cCliFor := 'C'
        ElseIf Alltrim(cCombo) $ "FOR/SA2" .OR. SUBSTR(cCampo,AT("_",cCampo)+1,6) $ "FORNEC/FORNECE" .OR. (cCampo == "E5_CLIFOR" .AND. cRecPag == 'P')// .AND. !lRecPag) 
            Aadd(aAuxClF,cCampo)
            cCliFor := 'F'
        ElseIf 'PH' $ cTabOrig .and. 'CONTR' $ cCampo
            Aadd(aAuxClF,cCampo)
            cCliFor := 'C'
        EndIf 
    Next nX 

Return aAuxClF

/*/{Protheus.doc} fCloseMig
	Função responsável por encerrar a migração e deletar todas as tabelas temporarias
	@type  Function
	@author Geanlucas Sousa
	@since 13/03/2025
/*/
Static Function fCloseMig()

    Local aArea     := FWGetArea()
    Local cAliasDel := ''
    Local cQuery    := ''
    Local lRet      := .T.
    Local nAls      := 0

    If FWAlertYesNo("Esse processo EXCLUI todas as tabelas temporarias."+CRLF+"Deseja Continuar?", "Atenção!")

        For nAls := 1 To Len(aX2Unq)

            cAliasDel := If(cEmpAnt=="00","BR",IF(cEmpAnt=="60","DM","MI"))+"P98"+aX2Unq[nAls,01]+cCodigo

            cQuery := "SELECT table_name "
            cQuery += "FROM user_tables "
            cQuery += "WHERE table_name = '"+cAliasDel+"'"

            If Select('TRB') > 0
                dbSelectArea('TRB')
                dbCloseArea()
            EndIf

            PlsQuery(cQuery, "TRB")
            DbSelectArea("TRB")

            If !TRB->(EoF())
                fDropTable(cAliasDel)
            EndIf

            cAliasDel := ''

        Next nAls

    EndIf

    FWRestArea(aArea)

Return lRet

/*/{Protheus.doc} LogWindow
	Monta a Tela de Acompanhamento do Processamento
	@type  Function
	@author Geanlucas Sousa
	@since 19/03/2025
/*/
User Function LogWindow(cTimeInic,cTable,nTotal,aLinhas,nQtdThreads)

Local nTempo    := 1000
    Local cChave    := "INCORPORADOR"
    Local lPronto   := .F.
    Local lOk       := .F. 
Local oDlg,oBtn1,oFont,oPanel1,oMargem,oBPS1,oBPS2

    Private lOnline := .F.

    lOnline:= U_JOnLine(cChave)

If lPronto

    oFont   := TFont():New(,,-15,.T.,.T.,,,,,)
    oDlg    := MSDialog():New( 092,232,506,823,"Monitor de Processamento - "+ Time(),,,.F.,,,,,,.T.,,,.T. )
    oPanel1 := TPanel():New( 002, 002, ,oDlg, , , , , , 14, 14, .F.,.T. )
    oPanel1 :align := CONTROL_ALIGN_TOP

    oBPS1  := THButton():New(002, 180, "Botão 1"    , oPanel1, {|| /*Função1()*/    }, 50, 10, oFont, "Descrição 1") 
    oBPS2  := THButton():New(002, 250, "Botão 2"    , oPanel1, {|| /*Função2()*/    }, 40, 10, oFont, "Descrição 2") 
    oBPS1:Disable()
    oBPS2:Disable()

    oMargem:= TSimpleEditor():New( 005,005,oDlg, 40, 40 )
    oMargem:Align := CONTROL_ALIGN_ALLCLIENT
        oMargem:Load(MontaHtml(cTimeInic,cTable,nTotal,aLinhas,nQtdThreads))

        oTimer := TTimer():New(nTempo,{|| fUpdTela(oTimer,oDlg,oMargem,cTimeInic,cTable,nTotal,aLinhas,nQtdThreads) },oDlg )
    oTimer:Activate()

    oBtn1   := TButton():New( 184,250,"Sair",oDlg,{|| oDlg:end()},037,012,,,,.T.,,"",,,,.F. )

Else

    oDlg := MSDialog():New( 001,001,001,001,"Monitor de Processamento - "+ Time(),,,.F.,,,,,,.T.,,,.T. )
    oTimer := TTimer():New(050, {||  oDlg:End() }, oDlg )
    oTimer:Activate()

EndIf

    oDlg:Activate(,,,.T.)

Return lOk

/*/{Protheus.doc} fUpdTela
	Atualiza a Tela de Acompanhamento do Processamento
	@type  Function
	@author Geanlucas Sousa
	@since 19/03/2025
/*/
Static Function fUpdTela(oTimer,oDlg,oMargem,cTimeInic,cTable,nTotal,aLinhas,nQtdThreads)
    
    Local cChaveSrv := "SRV_" + cChave 
    
    If oTimer == NIL
        Return
    EndIf 
    
    oTimer:Deactivate()   
    lOnline:= U_JOnLine(cChave)  
    cMsgSrv := U_JMsg(cChaveSrv)

    oMargem:Load(MontaHtml(cTimeInic,cTable,nTotal,aLinhas,nQtdThreads,cChaveSrv,cMsgSrv,lOnline))
    oMargem:Refresh()

    oDlg:cCaption := "Monitor de Processamento - " + cTitulo + " - " + Time() +If(lOnline," - (On Line) ", " - (Off Line)")
  
    oTimer:Activate()

Return

/*/{Protheus.doc} MontaHtml
	Monta o HTML da Tela de Acompanhamento do Processamento
	@type  Function
	@author Geanlucas Sousa
	@since 19/03/2025
/*/
Static Function MontaHtml(cTimeInic,cTable,nTotal,aLinhas,nQtdThreads,cChaveSrv,cMsgSrv,lOnline)
    // Local aInfo     := U_JSrvGetInfo(cChaveSrv)
Local cHtml     := ""
Local cTabs     := 'SC5/SC6' 
Local lRun      := .T.
Local nX        := 0
    Local nConc     := 0
Local nOcor     := 0
    Local nRest     := 0
Local nPRun     := Int((nConc / (nConc + nRest)) * 100)
    Local cTExec    := ElapTime(cTimeInic,Time())
    Local nRegAtual := 0

cHtml += "   <table align='CENTER'width=96% border=0 cellspacing=0 cellpadding=2 bordercolor='666633'>" + CRLF

If lRun
    cHtml += "      <tr><td width='150' align='LEFT'><font size= 3 ><b> Status : </b></font><font size=3 color='green'><b>EXECUTANDO</b></font></td></tr>" + CRLF
Else 
    cHtml += "      <tr><td width='150' align='LEFT'><font size= 3 ><b> Status : </b></font><font size=3 color='red'><b>FINALIZADO</b></font></td></tr>" + CRLF
EndIf 

cHtml += "      <tr><td width='150' align='LEFT'><font size= 3 ><b>Tabelas : </b></font><font size=3 color='#00008B'><b> " + cTabs +"</b></font></td></tr>" + CRLF
cHtml += "<br><br>" + CRLF
cHtml += "      <tr><td width='150' align='LEFT'><font size= 3 ><b>Total de Registros : </b></font><font size=3 color='#00008B'><b> " + cValtoChar(nTotal)  +"</b></font></td></tr>" + CRLF
    cHtml += "<br><br>" + CRLF
    cHtml += "      <tr><td width='150' align='LEFT'><font size= 3 ><b>Tempo de Execução : </b></font><font size=3 color='#00008B'><b> " + cTExec  +"</b></font></td></tr>" + CRLF
cHtml += "   </table>" + CRLF

cHtml += "<br><br>" + CRLF
cHtml += "<br><br>" + CRLF

cHtml += "   <table align='CENTER' width=96% border=1 cellspacing=0 cellpadding=2 bordercolor='#2F4F4F'>" + CRLF
cHtml += "      <tr>" + CRLF
    cHtml += "      <td width='100' align='LEFT'><font color='#4B0082'><b>FILA           </b></font></td> " + CRLF
cHtml += "      <td width='100' align='LEFT'><font color='#4B0082'><b>CONCLUIDOS     </b></font></td> " + CRLF
cHtml += "      <td width='100' align='LEFT'><font color='#4B0082'><b>OCORRENCIAS    </b></font></td> " + CRLF
cHtml += "      <td width='100' align='LEFT'><font color='#4B0082'><b>RESTANTES      </b></font></td> " + CRLF
cHtml += "      <td width='100' align='LEFT'><font color='#4B0082'><b>% CONCLUSÃO    </b></font></td> " + CRLF
    cHtml += "      <td width='100' align='LEFT'><font color='#4B0082'><b>RANGE TRHEAD   </b></font></td> " + CRLF
cHtml += "      </tr>" + CRLF

    For nX := 1 To nQtdThreads

        GetGlbVars( "_INTEGRAMAIS" + cTable + cValToChar( nX ), @nRegAtual)
        nConc := nRegAtual
        nIniRgThr := aLinhas[nX,01]
        nFimRgThr := aLinhas[nX,02]
        nRest := aLinhas[nX,02] - nConc
        nPRun := (nConc/aLinhas[nX,02])*100

    cHtml += "      <tr>" + CRLF
    cHtml += "      <td width='100' align='LEFT'><font color='#4B0082'><b>THREAD - 0"+cValToChar(nX)+" </b></font></td>"+ CRLF
    cHtml += "      <td width='100' align='CENTER'> " + Alltrim(Transform(nConc  , "@e 99,999,999,999")) +"</td>"       + CRLF
    cHtml += "      <td width='100' align='CENTER'> " + Alltrim(Transform(nOcor  , "@e 99,999,999,999")) +"</td>"       + CRLF
    cHtml += "      <td width='100' align='CENTER'> " + Alltrim(Transform(nRest  , "@e 99,999,999,999")) +"</td>"       + CRLF
    cHtml += "      <td width='100' align='CENTER'> " + Alltrim(Transform(nPRun  , "@e 999"))            + " % </td>"   + CRLF
        cHtml += "      <td width='100' align='CENTER'> " + Alltrim(Transform(nIniRgThr  , "@e 99,999,999,999")) +" a " + Alltrim(Transform(nFimRgThr  , "@e 99,999,999,999")) +"</td>"       + CRLF
    cHtml += "      </tr>" + CRLF

Next nX

cHtml += "   </table>" + CRLF

Return cHtml 

/*/{Protheus.doc} fVldAcess
Função para validar Acesso
@author Geanlucas Sousa
@since 31/10/2025
/*/

Static Function fVldAcess()

    Local cParam    := SuperGetMv('TI_TINCH2',.F.,Decode64('NDE4MjE0LzI3NjEwNS80NDY2NTAvMjk5NTgy'))
    Local cCodAux   := RetCodUsr()
    Local lRetorno  := .F.
      
    If cCodAux $ cParam
        lRetorno := .T.
    EndIf
      
Return lRetorno
/*/{Protheus.doc} _RBMigra
    Tela para Rollback de Migrações
    @type  Static Function
    @author user
    @since 05/05/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function _RBMigra()

    Local aArea :=    GetArea()

    Local cQuery := ""
    Local nCont 
    Local aTravas       := {{"SA1",""},{"SA2",""},{"CN9",""}}

    Private oOkT   	    := LoadBitmap(GetResources(),'br_verde')   
    Private oNoT   	    := LoadBitmap(GetResources(),'br_vermelho') 

    Private oRollB,oGrp1,oBtn1,oBtn2,oBtn3,oTabelas

    Private aTabelas := {}
    
    //Tabelas disponíveis para rollback de migrações

    cQuery := " SELECT PWU_TABELA,COUNT(*) AS QTD FROM " + RetSQLName("PWU") 
    cQuery += " WHERE PWU_CODP97='"+cCodigo+"' AND PWU_FILIAL='" + FwxFilial("PWU") + "' AND D_E_L_E_T_=' '  " 
    cQuery += " GROUP BY PWU_TABELA  " 
    cQuery += " ORDER BY 1  " 

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    PlsQuery(cQuery, "TRB")
    DbSelectArea("TRB")

    While !EOF()
        Aadd(aTabelas,{.F.,TRB->PWU_TABELA,TRB->QTD,0})
        Dbskip()
    EndDo 

    For nCont := 1 to len(aTabelas)
        cTabela := aTabelas[nCont,02]
        cQuery := "SELECT COUNT(*) AS QTD"
        cQuery += " FROM "+RetSQLName("PWU")
        cQuery += " WHERE PWU_CODP97='"+cCodigo+"' AND PWU_FILIAL=' ' AND D_E_L_E_T_=' ' AND PWU_TABELA='"+cTabela+"'"
        cQuery += " AND PWU_RECNDS <> 0"
        cQuery += " AND PWU_RECNDS IN(SELECT R_E_C_N_O_ FROM "+RetSQLName(cTabela)+" WHERE "+PrefixoCPO(cTabela)+"_FILIAL='"+cFilDest+"' AND D_E_L_E_T_=' ')"
        cQuery += " ORDER BY 1"

        PlsQuery(cQuery, "TRB")
        DbSelectArea("TRB")
        aTabelas[nCont,04] := TRB->QTD
    Next nCont 

    //oRollB     := MSDialog():New( 092,232,559,1062,"Tabelas Disponíveis",,,.F.,,,,,,.T.,,,.T. )
    oRollB     := MSDialog():New( 092,232,359,730,"Tabelas Disponíveis",,,.F.,,,,,,.T.,,,.T. )
    
    //oGrp1      := TGroup():New( 004,008,200,404,"Tabelas",oRollB,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oGrp1      := TGroup():New( 004,008,108,240,"Tabelas",oRollB,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,016,196,400},,, oGrp1 )
        oTabelas:= 	TCBrowse():New(012,012,223,090,, {'','Tabela','Qtd Registros PWU','Qtd Registros Tabela Final'},;
                                    {10,40,60,60},;
                                    oGrp1,,,,{|| /*HelpRelac(oList1:nAt)*/},{|| MarkRB(oTabelas:nAt) /*relactab(oList1:nAt,oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

        oTabelas:SetArray(aTabelas)
        oTabelas:bLine := {||{If(aTabelas[oTabelas:nAt,01],oOkT,oNoT),; 
                                aTabelas[oTabelas:nAt,02],;
                                aTabelas[oTabelas:nAt,03],;
                                aTabelas[oTabelas:nAt,04]}}

        oBtn1      := TButton():New( 113,030,"Verificar Registros",oRollB,{|| FWMsgRun(, {|| extrairRB(aTabelas[oTabelas:nAt,02])},"","Processando os dados...")},037,012,,,,.T.,,"",,,,.F. )
        oBtn2      := TButton():New( 113,090,"Rollback",oRollB,{|| FWMsgRun(, {|| ExecRB(aTravas)},"","Processando os dados...")},037,012,,,,.T.,,"",,,,.F. )
        oBtn3      := TButton():New( 113,150,"Sair",oRollB,{||oRollB:end()},037,012,,,,.T.,,"",,,,.F. )

    oRollB:Activate(,,,.T.)


    IF ValType(oRollB) == "O"
        FWFreeObj(oRollB)
        oRollB := Nil
    ENDIF

    
    RestArea(aArea)

Return

/*/{Protheus.doc} extrairRB
    Extrair em arquivos registros que serão realiados o rollback
    @type  Static Function
    @author user
    @since 05/05/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function extrairRB(cTabela)

    Local aArea := GetArea()
    Local cQuery 
    Local nCont 
    Local aAuxD := {}
    Local aCabc := {"PWU_CODIGO","PWU_DATA","PWU_HORA","PWU_USER","PWU_RESULT","PWU_RECN98","PWU_RECNDS","PWU_TABELA","PWU_CODP98","PWU_CODP97"}

    If MsgYesNo("Somente o registro posicionado?")
        cQuery := "SELECT PWU_CODIGO,PWU_DATA,PWU_HORA,PWU_USER,PWU_RESULT,PWU_RECN98,PWU_RECNDS,PWU_TABELA,PWU_CODP98,PWU_CODP97"
        cQuery += " FROM "+RetSQLName("PWU")
        cQuery += " WHERE PWU_CODP97='"+cCodigo+"' AND PWU_FILIAL=' ' AND D_E_L_E_T_=' ' AND PWU_TABELA='"+cTabela+"'"
        cQuery += " AND PWU_RECNDS <> 0"
        cQuery += " AND PWU_RECNDS IN(SELECT R_E_C_N_O_ FROM "+RetSQLName(cTabela)+" WHERE "+PrefixoCPO(cTabela)+"_FILIAL='"+cFilDest+"' AND D_E_L_E_T_=' ')"
        cQuery += " ORDER BY 1"

        PlsQuery(cQuery, "TRB")
        DbSelectArea("TRB")

        While !EOF()
            Aadd(aAuxD,{TRB->PWU_CODIGO,;
                        TRB->PWU_DATA,;
                        TRB->PWU_HORA,;
                        TRB->PWU_USER,;
                        TRB->PWU_RESULT,;
                        TRB->PWU_RECN98,;
                        TRB->PWU_RECNDS,;
                        TRB->PWU_TABELA,;
                        TRB->PWU_CODP98,;
                        TRB->PWU_CODP97})
            Dbskip()
        EndDo 

        If len(aAuxD) > 0
            ExpResult(aAuxD,aCabc)
        Else 
            MsgAlert("Não há mais registros na tabela de destino referente a esta incorporação")
        EndIF 
    Else
        For nCont := 1 to len(aTabelas)

            If aTabelas[nCont,01]
                aAuxD := {}
                cTabela := aTabelas[nCont,02]

                cQuery := "SELECT PWU_CODIGO,PWU_DATA,PWU_HORA,PWU_USER,PWU_RESULT,PWU_RECN98,PWU_RECNDS,PWU_TABELA,PWU_CODP98,PWU_CODP97"
                cQuery += " FROM "+RetSQLName("PWU")
                cQuery += " WHERE PWU_CODP97='"+cCodigo+"' AND PWU_FILIAL=' ' AND D_E_L_E_T_=' ' AND PWU_TABELA='"+cTabela+"'"
                cQuery += " AND PWU_RECNDS <> 0"
                cQuery += " AND PWU_RECNDS IN(SELECT R_E_C_N_O_ FROM "+RetSQLName(cTabela)+" WHERE "+PrefixoCPO(cTabela)+"_FILIAL='"+cFilDest+"' AND D_E_L_E_T_=' ')"
                cQuery += " ORDER BY 1"

                PlsQuery(cQuery, "TRB")
                DbSelectArea("TRB")

                While !EOF()
                    Aadd(aAuxD,{TRB->PWU_CODIGO,;
                                TRB->PWU_DATA,;
                                TRB->PWU_HORA,;
                                TRB->PWU_USER,;
                                TRB->PWU_RESULT,;
                                TRB->PWU_RECN98,;
                                TRB->PWU_RECNDS,;
                                TRB->PWU_TABELA,;
                                TRB->PWU_CODP98,;
                                TRB->PWU_CODP97})
                    Dbskip()
                EndDo 
                
                If len(aAuxD) > 0
                    ExpResult(aAuxD,aCabc)
                Else 
                    MsgAlert("Não há mais registros para a tabela "+cTabela+" referentes a esta incorporação para realizar o Rollback")
                EndIF 
            EndIf 
        Next nCont 
    EndIf 

    RestArea(aArea)

Return 

/*/{Protheus.doc} MarkRB(oTabelas:nAt)
    Marca/Desmarca linha para realização do rollback
    @type  Static Function
    @author user
    @since 05/05/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MarkRB(nLinha)

    Local aArea := GetArea()
    Local nPos1,nPos2,nPos3 := 0

    nPos1 := Ascan(aTabs,{|x| x[1] == aTabelas[nLinha,02]})
    nPos2 := Ascan(aTabs,{|x| x[2] == aTabelas[nLinha,02]})

    If aTabelas[nLinha,01]
        aTabelas[nLinha,01] := .F.
    Else 
        aTabelas[nLinha,01] := .T.
    EndIf 

    If nPos1 > 0
        nPos3 := Ascan(aTabelas,{|x| x[2] == aTabs[nPos1,2]})
    EndIF 

    If nPos2 > 0
        nPos3 := Ascan(aTabelas,{|x| x[2] == aTabs[nPos2,1]})
    EndIf   

    If nPos3 > 0 
        If aTabelas[nPos3,01]
            aTabelas[nPos3,01] := .F.
        Else 
            aTabelas[nPos3,01] := .T.
        EndIf 
    EndIF 

    oTabelas:refresh()
    oRollB:refresh()

    RestArea(aArea)
Return

/*/{Protheus.doc} ExecRB(aTravas)
    Executa Rollback das migrações, respeitando o parametro aTravas, para tratamentos especificos.
    @type  Static Function
    @author user
    @since 05/05/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ExecRB(aTravas)
    
    Local aArea     := GetArea()
    Local nCont,nX 
    Local aItens    := {} 
    Local cTabela   := ""


    For nCont := 1 to len(aTabelas)
        nPos := Ascan(aTravas,{|x| x[1] == aTabelas[nCont,02]})

        If aTabelas[nCont,01] .And. nPos == 0
            aItens := {}
            cTabela := aTabelas[nCont,02]

            cQuery := "SELECT PWU_RECN98,PWU_RECNDS"
            cQuery += " FROM "+RetSQLName("PWU")
            cQuery += " WHERE PWU_CODP97='"+cCodigo+"' AND PWU_FILIAL=' ' AND D_E_L_E_T_=' ' AND PWU_TABELA='"+cTabela+"'"
            cQuery += " AND PWU_RECNDS <> 0"
            cQuery += " AND PWU_RECNDS IN(SELECT R_E_C_N_O_ FROM "+RetSQLName(cTabela)+" WHERE "+PrefixoCPO(cTabela)+"_FILIAL='"+cFilDest+"' AND D_E_L_E_T_=' ')"
            cQuery += " ORDER BY 1"

            PlsQuery(cQuery, "TRB")
            DbSelectArea("TRB")

            While !EOF()
                Aadd(aItens,{TRB->PWU_RECN98,TRB->PWU_RECNDS})
                Dbskip()
            EndDo 


            For nX := 1 to len(aItens)
                DbSelectArea(cTabela)
                DbGoto(aItens[nX,02])
                Reclock(cTabela,.F.)
                DbDelete()
                &(cTabela+"->(Msunlock())")
                //U_TINCGRLG(nRecP98,0,"SE1",cRet,cMensagemErro,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
                cRet := "#ROLLBACK DE MIGRAÇÃO"
                cMensagemErro := ""
                U_TINCGRLG(aItens[nX,01],aItens[nX,02],cTabela,cRet,cMensagemErro,'1',.F.,cUsrLog,/*cTextoLog,*/Nil)

            Next nX 

        EndIF 

    Next nCont 

    MsgAlert("Processo finalizado!!!")
    aItens := {}
    
    RestArea(aArea)

Return 

Static Function FormatSql(cFormat)
    Local cQry := ""
    Local cAux := ""
    Local cWord:= ""
    Local aQry := {}
    Local nX   := 0
    Local cLinha:= ''
    Local cByte:= ""
    Local nSelect:= 0

    cFormat := ChangeQuery(cMemoL)

    aQry := StrTokArr(cFormat, CRLF)
    For nx := 1 to len(aQry)
        cLinha := aQry[nx]
        cLinha := StrTran(cLinha, CHR(9) , " ")
        cLinha := Alltrim(cLinha)
        cLinha := Upper(cLinha)
        cQry += cLinha+" "
    Next

    cAux := ""
    aQry := {}
    For nX:= 1 to len(cQry)
        cByte := Subs(cQry, nX    , 1)
        cByte2:= Subs(cQry, nX + 1, 1)
        cByte3:= Subs(cQry, nX + 2, 1)

        If Upper(cByte) $ "_ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
            cWord += cByte
        Else
            If len(cword) > 0 .and.  ;
                    (" " + cWord + "#"        $ " SELECT# FROM# WHERE#" .or.;
                    " " + cWord + cByte + "#"  $ " AND # OR # NOT # INNER # LEFT # RIHGT # ON #"   .or.;
                    " " + cWord + cByte + cByte2 + cByte3 + "#" $ " ORDER BY#" .or.;
                    " " + cWord + cByte + cByte2 + cByte3 + "#" $ " GROUP BY#" )

                cLinha:= Left(cAux, len(cAux) - len(cWord))
                If ! Empty(cLinha)
                    aadd(aQry, cLinha)
                EndIf

                cAux := cWord

            EndIf
            cWord:= ""
        EndIf
        cAux += cByte
        If nX==len(cQry) .and. ! Empty(cAux)
            cLinha:= cAux
            If ! Empty(cLinha)
                aadd(aQry, cLinha)
            EndIf
        EndIf
    Next

    nSelect := -1
    For nx := 1 to len(aQry)
        cLinha := aQry[nx]
        If "SELECT " $ cLinha
            nSelect++
        EndIf
        cLinha := Alltrim(cLinha) + " "
        cLinha := Upper(cLinha)

        cLinha := If(Left(cLinha, 4) == "AND "," " + cLinha, cLinha)
        cLinha := If(Left(cLinha, 3) == "OR " ," " + cLinha, cLinha)
        cLinha := If(Left(cLinha, 3) == "ON " ," " + cLinha, cLinha)
        cLinha := If(Left(cLinha, 4) == "NOT "," " + cLinha, cLinha)

        cLinha := StrTran(cLinha, "FROM "   ,  "FROM   ")
        cLinha := StrTran(cLinha, "WHERE "  ,  "WHERE ")
        cLinha := StrTran(cLinha, " AND "   , "       AND ")
        cLinha := StrTran(cLinha, " OR "    , "        OR ")
        cLinha := StrTran(cLinha, " ON "    , "        ON ")
        cLinha := StrTran(cLinha, " NOT "   , "       NOT ")
        cLinha := Repl(" ", Max(nSelect * 7, 0) ) + cLinha
        aQry[nx] := cLinha
        If "WHERE " $ cLinha
            nSelect--
        EndIf
    Next

    cQry := ""
    For nx:=1 to len(aQry)
        cQry += aQry[nx] + CRLF
    Next
    cMemoL := cQry
Return cMemoL


/*/{Protheus.doc} LstParam
Listagem de Parâmetros de uma determinada filial 

@author		Julio Saraiva
@since		19/02/2025
@version	1.0
/*/

Static Function fExport2()
Local cNameRel 		:= ""
Local cArqXls 		:= ""
Local aArea	    	:= GetArea()
Local cArqXlsRoot   := ""

If Type("oMResult") != "U"

    //cArqXlsRoot  := cGetFile('Todos os arquivos (*.xls)| *.xls', 'Informe o diretorio para a geração do excel', 1, Nil, .T.,  GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY + GETF_LOCALFLOPPY)		
    //cDir := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar, nOpcoes, lArvore)
    cMascara := 'Todos os arquivos (*.xls)| *.xls'
    cTitulo  := 'Informe o diretorio para a geração do excel'
    nMascpad  := 0
    cDirini   := "\"
    lSalvar   := .F. 
    nOpcoes   := GETF_LOCALHARD
    lArvore   := .F.
    
    cArqXlsRoot  := tFileDialog(cMascara, cTitulo, nMascpad, cDirIni, lSalvar, nOpcoes)
    cNameRel := "Query_WH_IntegraMais_" + DToS(Date()) + "_" + StrTran(Time(),":","") + ".xls"	

    If Empty(cArqXlsRoot)
        MsgAlert("Diretorio não informado!")
        Return
    EndIf 

    cArqXls := cArqXlsRoot + Lower(cNameRel)

    If File(cArqXls)
        FErase(cArqXls)
    EndIf 

    U_TIExcel(cAliasResu, cArqXlS)
    
    RestArea(aArea)

Endif

Return        

/*/{Protheus.doc} ParamCSV
Listagem de Parâmetros de uma determinada filial em csv para posterior importação na produção 

@author		Julio Saraiva
@since		07/05/2025
@version	1.0
/*/

Static Function ParamCSV()

Local cQry := ""
Local aArea	    	:= GetArea()
Local cAliasEx		:= GetNextAlias()
Local cNameRel 		:= ""
Local cArqCSVRoot   := ""
Local cLinha := ""

If !FWAlertYesNo("Deseja gerar os arquivos .csv dos parâmetros ZX5, SX5 e SX6 da Filial: " + cFilDest + " - " + Alltrim(cNomeFil) + " ?")
    RestArea(aArea)
    If ( Select(cAliasEx) > 0 )
        (cAliasEx)->( dbCloseArea() )
    EndIf
	Return .F.
Endif

// -- CSV da ZX5
cNameRel := "ZX5_" + Alltrim(cFilDest) + DToS(Date()) + "_" + StrTran(Time(),":","") + ".csv"
cQry := "SELECT ZX5_FILIAL,ZX5_TABELA,ZX5_CHAVE,ZX5_CHAVE2,ZX5_DESCRI FROM " + RetSQLName("ZX5") + " WHERE (ZX5_FILIAL='" + ALLTRIM(cFilDest) + "' OR ZX5_CHAVE2 LIKE '%" + ALLTRIM(cFilDest) + "%' ) AND D_E_L_E_T_ = ' ' "
dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)),cAliasEx, .F., .T.)

cArqCSVRoot  := TFileDialog('Todos os arquivos (*.csv)| *.csv', 'Informe o diretorio para a geração dos .csv',  , Nil, .F., GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY)
If Empty(cArqCSVRoot)
	MsgAlert("Diretorio não informado!")
    RestArea(aArea)
    If ( Select(cAliasEx) > 0 )
        (cAliasEx)->( dbCloseArea() )
    EndIf
	Return
EndIf 

// Faz a geração em CSV
If !(cAliasEx)->(eof())
    cLinha := "ZX5_FILIAL;ZX5_TABELA;ZX5_CHAVE;ZX5_CHAVE2;ZX5_DESCRI"
    GrvArq(cArqCSVRoot + cNameRel, cLinha, .T.)
Endif
While !(cAliasEx)->(eof())
    cLinha := (cAliasEx)->ZX5_FILIAL+";"+(cAliasEx)->ZX5_TABELA+";"+(cAliasEx)->ZX5_CHAVE+";"+(cAliasEx)->ZX5_CHAVE2+";"+(cAliasEx)->ZX5_DESCRI
    GrvArq(cArqCSVRoot + cNameRel, cLinha, .T.)
    (cAliasEx)->(dbSkip())
Enddo

If ( Select(cAliasEx) > 0 )
    (cAliasEx)->( dbCloseArea() )
EndIf

// -- CSV da SX5
cAliasEx := GetNextAlias()
cNameRel := "SX5_" + Alltrim(cFilDest) + DToS(Date()) + "_" + StrTran(Time(),":","") + ".csv"
cQry := "SELECT X5_FILIAL AS XPR1,X5_TABELA AS XPR2,X5_CHAVE AS XPR3,X5_DESCRI AS XPR4,X5_DESCSPA AS XPR5,X5_DESCENG AS XPR6"
cQry += " FROM " + RetSQLName("SX5") + " WHERE (X5_FILIAL='" + ALLTRIM(cFilDest) + "' OR X5_DESCRI LIKE '%" + ALLTRIM(cFilDest) + "%' ) AND D_E_L_E_T_ = ' ' "

dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)),cAliasEx, .F., .T.)

// Faz a geração em CSV
If !(cAliasEx)->(eof())
    cLinha := "X5_FILIAL;X5_TABELA;X5_CHAVE;X5_DESCRI;X5_DESCSPA;X5_DESCENG"
    GrvArq(cArqCSVRoot + cNameRel, cLinha, .T.)
Endif
While !(cAliasEx)->(eof())
    cLinha := (cAliasEx)->XPR1+";"+(cAliasEx)->XPR2+";"+(cAliasEx)->XPR3+";"+(cAliasEx)->XPR4+";"+(cAliasEx)->XPR5+";"+(cAliasEx)->XPR6
    GrvArq(cArqCSVRoot + cNameRel, cLinha, .T.)
    (cAliasEx)->(dbSkip())
Enddo

If ( Select(cAliasEx) > 0 )
    (cAliasEx)->( dbCloseArea() )
EndIf

// -- CSV da SX6
cAliasEx := GetNextAlias()
cNameRel := "SX6_" + Alltrim(cFilDest) + DToS(Date()) + "_" + StrTran(Time(),":","") + ".csv"
cQry := "SELECT X6_FIL AS XPR1,X6_VAR AS XPR2,X6_TIPO AS XPR3,X6_DESCRIC AS XPR4,X6_CONTEUD AS XPR5 FROM " + RetSQLName("SX6") + " WHERE (X6_FIL='" + ALLTRIM(cFilDest) + "' OR X6_CONTEUD LIKE '%" + ALLTRIM(cFilDest) + "%' ) AND D_E_L_E_T_ = ' ' "
dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)),cAliasEx, .F., .T.)

// Faz a geração em CSV
If !(cAliasEx)->(eof())
    cLinha := "X6_FIL;X6_VAR;X6_TIPO;X6_DESCRIC;X6_CONTEUD"
    GrvArq(cArqCSVRoot + cNameRel, cLinha, .T.)
Endif
While !(cAliasEx)->(eof())
    cLinha := (cAliasEx)->XPR1+";"+(cAliasEx)->XPR2+";"+(cAliasEx)->XPR3+";"+(cAliasEx)->XPR4+";"+STRTRAN((cAliasEx)->XPR5,";",",")
    GrvArq(cArqCSVRoot + cNameRel, cLinha, .T.)
    (cAliasEx)->(dbSkip())
Enddo

If ( Select(cAliasEx) > 0 )
    (cAliasEx)->( dbCloseArea() )
EndIf

FWAlertSuccess("Arquivos .CSV gerados com sucesso em " + cArqCSVRoot)
ShellExecute("open", "explorer.exe", SubStr(cArqCSVRoot,3,Len(Alltrim(cArqCSVRoot))), Left(cArqCSVRoot,3), 1)
RestArea(aArea)
RETURN

//-Uso: GrvArq(cDir + cArquivo, cLinha)
Static Function GrvArq(cArquivo, cLinha, lEnter)
	Local nHandle2 := 0
	Default lEnter := .t.
	If ! File(cArquivo)
		If (nHandle2 := &("MSFCreate(cArquivo,0)")) == -1
			Return
		EndIf
	Else
		If (nHandle2 := &("FOpen(cArquivo,2)")) == -1
			Return
		EndIf
	EndIf
	FSeek(nHandle2,0,2)
	If lEnter
		FWrite(nHandle2, cLinha + CRLF)
	Else
		FWrite(nHandle2, cLinha )
	EndIf
	FClose(nHandle2)
Return
