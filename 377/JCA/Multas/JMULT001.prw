//Bibliotecas
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'
 
//VariÃ¡veis EstÃ¡ticas
STATIC cTitulo    :=    "Cadastro de Tipo Connect"
 
USER FUNCTION JMULT001()

    LOCAL aArea      :=    GetArea()
    LOCAL oBrowse
    LOCAL cFunBkp    :=    FunName()
     
    SetFunName("JMULT001")
     
    //InstÃ¢nciando FWMBrowse - Somente com dicionÃ¡rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("ZPD")
 
    //Setando a descriÃ§Ã£o da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "ZPD->ZPD_STATUS = '1'", "ORANGE", "Aguardando Liberação" )

    oBrowse:AddLegend( "ZPD->ZPD_STATUS = '2'", "GREEN" ,   "Liberado" )

    oBrowse:AddLegend( "ZPD->ZPD_STATUS = '3'", "RED"   ,   "Bloqueado" )

    oBrowse:AddLegend( "ZPD->ZPD_STATUS = '4'", "BROWN" ,   "Titulo Gerado" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("ZPD->ZPD_CODIGO >= '000000' .And. ZPD->ZPD_CODIGO <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
RETURN Nil

 
STATIC FUNCTION MenuDef()

    LOCAL aRot    :=    {}
     
    //Adicionando opÃ§Ãµes
    ADD OPTION aRot TITLE 'Visualizar'          ACTION 'VIEWDEF.JMULT001' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'             ACTION 'U_ZPDLeg'         OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Negociação'          ACTION 'U_xJMult01'       OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Gerar Movimentação'  ACTION 'VIEWDEF.JMULT001' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Aprovações'          ACTION 'U_xJMult02'       OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Excluir'             ACTION 'VIEWDEF.JMULT001' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 6
 
RETURN aRot

 
STATIC FUNCTION ModelDef()

    //CriaÃ§Ã£o do objeto do modelo de dados
    LOCAL oModel    :=    Nil
     
    //CriaÃ§Ã£o da estrutura de dados utilizada na interface
    LOCAL oStZPD    :=    FWFormStruct(1, "ZPD")
     
    //Editando caracterÃ­sticas do dicionÃ¡rio
    oStZPD:SetProperty('ZPD_CODIGO',  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                                 //Modo de EdiÃ§Ã£o
    oStZPD:SetProperty('ZPD_CODIGO',  MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZPD", "ZPD_CODIGO")'))      //Ini PadrÃ£o
     
    //Instanciando o modelo, nÃ£o Ã© recomendado colocar nome da USER FUNCTION (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("JMULT001M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulÃ¡rios para o modelo
    oModel:AddFields("FORMZPD",/*cOwner*/,oStZPD)
     
    //Setando a chave primÃ¡ria da rotina
    oModel:SetPrimaryKey({'ZPD_FILIAL','ZPD_CODIGO'})
     
    //Adicionando descriÃ§Ã£o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descriÃ§Ã£o do formulÃ¡rio
    oModel:GetModel("FORMZPD"):SetDescription("Formulario do Cadastro "+cTitulo)
RETURN oModel

 
STATIC FUNCTION ViewDef()
    // LOCAL aStruZPD    := ZPD->(DbStruct())
     
    //CriaÃ§Ã£o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    LOCAL oModel    :=    FWLoadModel("JMULT001")
     
    //CriaÃ§Ã£o da estrutura de dados utilizada na interface do cadastro de Autor
    LOCAL oStZPD    :=    FWFormStruct(2, "ZPD")  //pode se usar um terceiro parÃ¢metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZPD_NOME|SZPD_DTAFAL|'}
     
    //Criando oView como nulo
    LOCAL oView     :=    Nil
 
    //Criando a view que serÃ¡ o retorno da funÃ§Ã£o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulÃ¡rios para interface
    oView:AddField("VIEW_ZPD", oStZPD, "FORMZPD")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando tÃ­tulo do formulÃ¡rio
    oView:EnableTitleView('VIEW_ZPD', 'Dados - '+cTitulo )  
     
    //ForÃ§a o fechamento da janela na confirmaÃ§Ã£o
    oView:SetCloseOnOk({||.T.})
     
    //O formulÃ¡rio da interface serÃ¡ colocado dentro do container
    oView:SetOwnerView("VIEW_ZPD","TELA")
     
    /*
    //Tratativa para remover campos da visualizaÃ§Ã£o
    FOR nAtual := 1 TO Len(aStruZPD)
        cCampoAux := Alltrim(aStruZPD[nAtual][01])
         
        //Se o campo atual nÃ£o estiver nos que forem considerados
        IF Alltrim(cCampoAux) $ "ZPD_CODIGO;"
            oStZPD:RemoveField(cCampoAux)
        ENDIF
    NEXT
    */
RETURN oView

 
USER FUNCTION ZPDLeg()

    LOCAL aLegenda    :=    {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_LARANJA" ,           "Aguardando Liberação"  })
    AADD(aLegenda,{"BR_VERDE"   ,           "Liberado"              })
    AADD(aLegenda,{"BR_VERMELHO",           "Rejeitado"             })
    AADD(aLegenda,{"BR_MARROM"  ,           "Titulos Gerado"        })
    
     
    BrwLegenda(cTitulo, "Status", aLegenda)
RETURN

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 03/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xJMult01

Local nOpc := 0

Private aVinculo := {'','1=RH','2=CPAG','3=CREC'}
Private cVinculo := ''
Private aTipoOc  := {'','M=Multa','S=Sinistro'}
Private cTipoOc  := ''
Private cNome    := ''
Private cCodigo  :=  ""
Private nVlrMul  :=  0
Private nVlrNeg  :=  0
Private nQtdPar  :=  0
Private dIniPgt  :=  ctod(' / / ')
Private cCodRes  :=  space(6)
Private cVerba   :=  space(3)

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oGet1","oCBox1")
SetPrvt("oGet3","oGet4","oGet5","oGet6","oGet7","oBtn1","oBtn2","oSay9","oCBox2")

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf


cCodigo := GetSXENum("ZPD","ZPD_CODIGO")

oDlg1      := MSDialog():New( 092,232,694,1556,"Negociação",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 016,020,236,624,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
    oSay1      := TSay():New( 032,044,{||"Codigo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet1      := TGet():New( 032,092,{|u| If(Pcount()>0,cCodigo:=u,cCodigo)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    oGet1:Disable()
    
    oSay2      := TSay():New( 032,196,{||"Tipo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oCBox1     := TComboBox():New( 032,228,{ |u| If(PCount()>0,cTipoOc:=u,cTipoOc) },aTipoOc,072,010,oGrp1,,{|| Libok(1)},,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
    

    oSay9      := TSay():New( 032,336,{||"Vinculo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oCBox2     := TComboBox():New( 032,368,{ |u| If(PCount()>0,cVinculo:=u,cVinculo) },aVinculo,072,010,oGrp1,,{|| Libok(2)},,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
    
    oSay10     := TSay():New( 032,448,{||"Verba"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet9      := TGet():New( 032,475,{|u| If(Pcount()>0,cVerba:=u,cVerba)},oGrp1,060,008,'@R 999',{|| Libok(8)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRV","",,)
    oGet9:disable()

    oSay4      := TSay():New( 072,044,{||"Valor Multa"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet3      := TGet():New( 072,092,{|u| If(Pcount()>0,nVlrMul:=u,nVlrMul)},oGrp1,060,008,'@E 999,999.99',{|| Libok(3)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay5      := TSay():New( 072,168,{||"Valor Negociado"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
    oGet4      := TGet():New( 072,220,{|u| If(Pcount()>0,nVlrNeg:=u,nVlrNeg)},oGrp1,060,008,'@E 999,999.99',{|| Libok(4)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay6      := TSay():New( 072,296,{||"Qtd Parcelas"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet5      := TGet():New( 072,348,{|u| If(Pcount()>0,nQtdPar:=u,nQtdPar)},oGrp1,060,008,'@E 9,999',{|| Libok(5)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay7      := TSay():New( 072,424,{||"Data Inicio Pagto"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
    oGet6      := TGet():New( 072,484,{|u| If(Pcount()>0,dIniPgt:=u,dIniPgt)},oGrp1,060,008,'',{|| Libok(6)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
    oSay8      := TSay():New( 108,044,{||"Cod. Responsavel"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
    oGet7      := TGet():New( 108,092,{|u| If(Pcount()>0,cCodRes:=u,cCodRes)},oGrp1,060,008,'',{|| Libok(7)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA","",,)

    oSay3      := TSay():New( 108,168,{||"Nome"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet2      := TGet():New( 108,204,{|u| If(Pcount()>0,cNome:=u,cNome)},oGrp1,396,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    oGet2:Disable()
        
    
    oBtn1      := TButton():New( 252,220,"Salvar",oDlg1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 252,360,"Sair",oDlg1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

    oBtn1:disable()

oDlg1:Activate(,,,.T.)

If nOpc == 1
    Confirmsx8()
    DbSelectArea("ZPD")
    Reclock("ZPD",.T.)
    ZPD->ZPD_FILIAL := xFilial("ZPD")
    ZPD->ZPD_CODIGO := cCodigo
    ZPD->ZPD_TIPO   := cTipoOc
    ZPD->ZPD_VINCUL := cVinculo
    ZPD->ZPD_MULTA  := nVlrMul
    ZPD->ZPD_VERBA  := cVerba
    ZPD->ZPD_VALOR  := nVlrNeg
    ZPD->ZPD_PARCEL := nQtdPar
    ZPD->ZPD_DTINIC := dIniPgt
    ZPD->ZPD_RESPON := cCodRes
    ZPD->ZPD_STATUS := '1'
    ZPD->ZPD_TABELA := If(cVinculo=='1','SRC',If(cVinculo=='2','SE2','SE1'))
    ZPD->ZPD_SOLICI := cusername
    ZPD->ZPD_DTSOLI := ddatabase
    ZPD->ZPD_HORASO := cvaltochar(time())
    ZPD->(Msunlock())    
ENDIF

Return

/*/{Protheus.doc} Libok
    Libera o botão ok para salvar o cadastro da negociação da multa.
    @type  Static Function
    @author user
    @since 04/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Libok(nOpcao)


Local nOk := 0
Local nTot := If(cVinculo == '1',8,7)

If nOpcao == 7
    If !Empty(cCodRes)
        cNome := Posicione("SRA",1,xFilial("SRA")+cCodRes,"RA_NOME")
    Else 
        cNome:=""
    EndIf 
EndIf

If nOpcao == 2
    If cVinculo == '1'
        oGet9:enable()
    else
        cVerba := space(3)
        oGet9:disable()
    EndIf 
EndIf 

If !Empty(cTipoOc)
    nOk++
EndIf 

If !Empty(cVinculo)
    nOk++
ENDIF

If nVlrMul <> 0
    nOk++
EndIf 

If nVlrNeg  <> 0
    nOk++
EndIf 

If nQtdPar  <> 0
    nOk++
EndIf

If !Empty(dIniPgt)
    nOk++
EndIf 

If !Empty(cCodRes)
    nOk++
EndIf 

If !Empty(cVerba)
    nOk++
EndIf 


If nOk == nTot
    oBtn1:enable()
Else
    oBtn1:disable()
EndIf 

oDlg1:refresh()

Return

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 04/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xJMult02

Local aParamBox	:= {}

Private aList   := {}
Private oList 
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')  
Private oMb   	:= LoadBitmap(GetResources(),'br_laranja')  

Private aCombo  :=  {'0=Todos','1=RH','2=Contas a Pagar','3=Contas a Receber'}
Private cCombo  :=  ''
Private cAprova :=  SUPERGETMV( "IT_XAPROV", .F., '377' ) //ULTIMO PARAMETRO POR FILIAL (4)

SetPrvt("oDlg1","oGrp1","oBrw1","oBtn1","oBtn2","oBtn3")

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

If !Alltrim(cusername) $ cAprova
    MsgAlrt("Usuário sem permissão para realizar aprovações")
Else 
    aAdd(aParamBox,{02,"Tipo de Aprovação"              ,cCombo     ,aCombo             ,80,""   ,.F.})

    If ParamBox(aParamBox,"Registros",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
        cCombo := MV_PAR01 
    Else 
        Return
    EndIf 

    aList := Busca(cCombo)

    If len(aList) == 0
        Aadd(aList,{.f.,'','','','','','','',0,.F.})
    EndIf 

    oDlg1      := MSDialog():New( 092,232,594,1273,"Aprovação de Negociação",,,.F.,,,,,,.T.,,,.T. )

        oGrp1      := TGroup():New( 004,004,212,508,"Itens",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,208,504},,, oGrp1 ) 
        oList    := TCBrowse():New(012,008,495,195,, {'','Código','Tipo','Nome','Valor','Qtd Parcelas','Data Inicio','Solicitante'},;
                                                        {10,50,50,100,60,50,50,100},;
                                                        oGrp1,,,,{|| /*FHelp(oList:nAt)*/},{|| inverte(1)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList:SetArray(aList)
        oList:bLine := {||{ If(aList[oList:nAt,01],oOk,If(Empty(aList[oList:nAt,10]),oNo,oMb)),;
                                aList[oList:nAt,02],; 
                                aList[oList:nAt,03],;
                                aList[oList:nAt,04],; 
                                Transform(aList[oList:nAt,05],"@E 999,999.99"),;
                                aList[oList:nAt,06],; 
                                stod(aList[oList:nAt,07]),;
                                aList[oList:nAt,08]}}
        
        oBtn1      := TButton():New( 220,072,"Aprovar Selecionados",oDlg1,{|| aprovrej(1)},084,012,,,,.T.,,"",,,,.F. )
        oBtn2      := TButton():New( 220,220,"Rejeitar Selecionados",oDlg1,{|| aprovrej(2)},084,012,,,,.T.,,"",,,,.F. )
        oBtn3      := TButton():New( 220,392,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

        MENU oMenuP POPUP 
        MENUITEM "Marcar/Desmarcar Todos" ACTION (Processa({|| inverte(2)},"Aguarde"))
        ENDMENU                                                                           

        oList:bRClicked := { |oObject,nX,nY| oMenuP:Activate( nX, (nY-10), oObject ) }

    oDlg1:Activate(,,,.T.)
EndIf 

Return

/*/{Protheus.doc} Busca
    (long_description)
    @type  Static Function
    @author user
    @since 04/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca(cCombo)

Local aArea := GetArea()
Local aRet  := {}

cQuery := "SELECT ZPD_CODIGO,ZPD_VINCUL,RA_NOME,ZPD_VALOR,ZPD_PARCEL,ZPD_DTINIC,ZPD_SOLICI,ZPD.R_E_C_N_O_ AS RECZPD"
cQuery += " FROM "+RetSQLName("ZPD")+" ZPD"
cQuery += " INNER JOIN "+RetSQLName("SRA")+" RA ON RA_FILIAL=ZPD_FILIAL AND RA_MAT=ZPD_RESPON AND RA.D_E_L_E_T_=' '"
cQuery += " WHERE ZPD_FILIAL BETWEEN ' ' AND 'ZZ' AND ZPD.D_E_L_E_T_=' '"
cQuery += " AND ZPD_STATUS='1'"

If cCombo == "1"
    cQuery += " AND ZPD_VINCUL = '1'"
ElseIf cCombo == "2"
    cQuery += " AND ZPD_VINCUL = '2'"
ElseIf cCombo == "3"
    cQuery += " AND ZPD_VINCUL = '3'"
EndIf 

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("TIINCP01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aRet,{.F.,;
                TRB->ZPD_CODIGO,;
                If(TRB->ZPD_VINCUL=="1","RH",If(TRB->ZPD_VINCUL=="2","C.PAGAR","C.RECEBER")),;
                TRB->RA_NOME,;
                TRB->ZPD_VALOR,;
                TRB->ZPD_PARCEL,;
                TRB->ZPD_DTINIC,;
                TRB->ZPD_SOLICI,;
                TRB->RECZPD,;
                ''})
    Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)


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
    If Empty(aList[oList:nAt,10])
        If aList[oList:nAt,01]
            aList[oList:nAt,01] := .F.
        Else 
            aList[oList:nAt,01] := .T.
        EndIf
    Else 
        If aList[oList:nAt,10] == "A"
            MsgAlert("Liberação já executada para item")
        Else 
            MsgAlert("Rejeição já executada para item")
        EndIf 
    EndIf
Else 
    For nX := 1 to len(aList)
        If Empty(aList[nX,10])
            If aList[nx,01]
                aList[nX,01] := .F.
            Else 
                aList[nX,01] := .T.
            EndIf 
        EndIf 
    Next nX 
EndIf 

oList:refresh()
oDlg1:refresh()

Return 

/*/{Protheus.doc} aprovrej
    (long_description)
    @type  Static Function
    @author user
    @since 04/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function aprovrej(nOpcao)

Local aArea := GetArea()
Local nX    := 0

For nX := 1 to len(aList)
    If aList[nX,01]
        DbSelectArea("ZPD")
        Dbgoto(aList[nX,09])
        Reclock("ZPD",.F.)
        ZPD->ZPD_STATUS := If(nOpcao==1,"2","3")
        ZPD->ZPD_APROVA := cusername
        ZPD->ZPD_DTAPRO := ddatabase 
        ZPD->ZPD_HORAAP := cvaltochar(time())
        ZPD->(Msunlock())
        aList[nX,10] := If(nOpcao==1,"A","R")
        aList[nX,01] := .F.
    EndIf 
Next nX 

oList:refresh()
oDlg1:refresh()

RestArea(aArea)

Return
