#INCLUDE 'PROTHEUS.CH'
/*
    xx Gatilho campo Grupo para produto para criar sequencial do codigo de acordo
    xx com grupo selecionado
    xxxMIT 44_ESTOQUE_EST001 - Codificação de Produtos
    
    DOC MIT
    xxxhttps://docs.google.com/document/d/10vxbtI4iBcPuf7l3qImxY1BYB1OKtP3Q/edit
    DOC ENTREGA
    https://docs.google.com/document/d/1qU10HGIjy-NU6P6bpPoa5rTvqtE3AaQX/edit

*/
User Function JCOMG002()


Local cCodigo:= SB1->B1_COD
Local lPerm  := .T.
Local cGrupo := SB1->B1_GRUPO
Local aAuxX3    :=  {}
Local aAuxBZ    :=  {}
Local nCont 
Local nZ 

Private cMarca  := space(4)
Private cCodFab := space(15)
Private cDescM := ''

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

lPerm := SUPERGETMV( "TI_PERMCA", .F., "377" )

If !Empty(SB1->B1_XCODPAI)
    MsgAlert("Somente produtos Pai podem ser utilizados na cópia JCA")
Else 

    //aAdd(aPergs, {1, "Marca",  cMarca,  "", ".T.", "ZPM", ".T.", 80,  .F.})
    If Telafilho(cCodigo)
        If !Dbseek(xFilial("SB1")+Alltrim(cCodigo)+Alltrim(cMarca))
            Processa({|| gerafilho(cMarca,cDescM,cCodigo,cGrupo,cCodFab)},"Aguarde!!!")

            aFilSBZ := BuscaFBZ(cCodigo)

            For nZ := 1 to len(aFilSBZ)

                aAuxX3 := {}
                aAuxBZ := {}

                DbSelectArea("SBZ")
                DbSetOrDer(1)
                If Dbseek(aFilSBZ[nZ]+cCodigo)
                    aAuxX3    := FWSX3Util():GetAllFields( 'SBZ' , .F. )
                    aAuxBZ    := {}
                    For nCont := 1 to len(aAuxX3)
                        Aadd(aAuxBZ,{aAuxX3[nCont],&('SBZ->'+aAuxX3[nCont])})
                    Next nCont 

                Endif 

                If len(aAuxBZ) > 0
                    DbSelectArea("SBZ")
                    Dbgotop()
                    DbSetOrDer(1)
                    If !Dbseek(aFilSBZ[nZ]+alltrim(cCodigo)+cMarca)
                        Reclock("SBZ",.T.)
                    else
                        Reclock("SBZ",.F.)
                    EnDIf 

                    For nCont := 1 to len(aAuxBZ)
                        If Alltrim(aAuxBZ[nCont,01]) == "BZ_COD"
                            &('SBZ->'+aAuxBZ[nCont,01]) := alltrim(aAuxBZ[nCont,02])+cMarca
                        else
                            &('SBZ->'+aAuxBZ[nCont,01]) := aAuxBZ[nCont,02]
                        EndIf 
                    Next nCont 

                    SBZ->(Msunlock())
                endIf 
            Next nZ 

            DbSelectArea("SB1")
            DbSetOrder(1)
            Dbseek(xFilial("SB1")+alltrim(cCodigo)+cMarca)
        else
            MsgAlert("Produto já existe com a marca selecionada.")
        Endif
    EndIF 

ENDIF

Return

/*/{Protheus.doc} nomeStaticFunction
    Tela para o usuario informar o codigo da marca e codigo do fabricante do produto filho
    @type  Static Function
    @author user
    @since 15/04/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Telafilho(cCodigo)

Local nOpc      := 0
Local lRet      := .T.

SetPrvt("oDlg1","oSay3","oSay4","oSay5","oGrp1","oSay1","oSay2","oGet1","oGet2","oBtn1","oBtn2")

oDlg1      := MSDialog():New( 123,587,402,1273,"Cópia de Produtos JCA",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,076,032,264,"Código PAI",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        oSay1      := TSay():New( 018,084,{||cCodigo},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
        oSay2      := TSay():New( 018,124,{||SB1->B1_DESC},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,136,008)

        oSay3      := TSay():New( 044,100,{||"Marca"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet1      := TGet():New( 044,160,{|u| If(Pcount()>0,cMarca:=u,cMarca)},oDlg1,060,008,'@!',{|| DesMrk(cMarca)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZPM","",,)
        oSay4      := TSay():New( 064,080,{||cDescM},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)

        oSay5      := TSay():New( 084,100,{||"Código Fabricante"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
        oGet2      := TGet():New( 084,160,{|u| If(Pcount()>0,cCodFab:=u,cCodFab)},oDlg1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

    oBtn1      := TButton():New( 112,108,"Confirmar",oDlg1,{|| oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 112,184,"Cancelar",oDlg1,{|| oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpc == 1
    If Empty(cMarca) 
        MsgAlert("Não foi informada a marca para o novo produto.")
        lRet := .F.
    EndIf 

    If Empty(cCodFab)
        MsgAlert("Não foi informado o código do fabricante para o novo produto.")
        lRet := .F.
    EndIF 
Else 
    lRet := .F.
EndIf 

Return(lRet)

/*/{Protheus.doc} nomeStaticFunction
    Valida se a marca informada e valida
    @type  Static Function
    @author user
    @since 15/04/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function DesMrk(cMarca)

Local lRet := .T.

If !Empty(cMarca)
    If ExistCPO("ZPM",cMarca)
        oSay4:settext("")

        cDescM := Alltrim(Posicione("ZPM",1,xFilial("ZPM")+cMarca,"ZPM_DESC"))

        oSay4:settext(cDescM)
    Else 
        MsgAlert("Marca inexistente.")
        lRet := .F.
    EndIf 
endIF 

Return(lRet)

/*/{Protheus.doc} nomeStaticFunction
    Gera o produto filho 
    @type  Static Function
    @author user
    @since 18/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gerafilho(cMarca,cDescM,cCodigo,cGrupo,cCodFab)

Local aArea  := GetArea()
Local nCont  := 1
Local cTabela:= "SB1"
Local aHoBrw1:= {}
Local aAuxX3 := {}
Local cNewCd := ""
Local cCpoNcp := SuperGetMv("TI_CPONTCP",.F.,"B1_EMIN/B1_ESTSEG/B1_PE/B1_TIPE/B1_LE/B1_TOLER/B1_EMAX")
Local nRecSB1 := 0

DbSelectArea("SB1")
DbSetOrder(1)

If DbSeek(xFilial("SB1")+cCodigo) //

    aAuxX3 := FWSX3Util():GetListFieldsStruct( cTabela , .F. )

    For nCont := 1 to len(aAuxX3)
        lUsado := X3USO(GetSX3Cache(aAuxX3[nCont,1], "X3_USADO"))
        If lUsado .And. !Alltrim(aAuxX3[nCont,1]) $ cCpoNcp
            /*If Alltrim(aAuxX3[nCont,1]) == "B1_DESC"
                Aadd(aHoBrw1,{aAuxX3[nCont,1],Alltrim(&("SB1->"+aAuxX3[nCont,1]))}) //+' '+cDescM solicitado pela priscila para retirar 12/04/24*/
            If Alltrim(aAuxX3[nCont,1]) == "B1_FABRIC"
                Aadd(aHoBrw1,{aAuxX3[nCont,1],cCodFab})
            Else
                Aadd(aHoBrw1,{aAuxX3[nCont,1],&("SB1->"+aAuxX3[nCont,1])})
            EndIf 
        EndIf
    Next nCont

    oModel  := FwLoadModel ("MATA010")
    oModel:SetOperation(3) //MODEL_OPERATION_INSERT
    oModel:Activate()
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oStruSB1	:= FWFormStruct(2, 'SB1')

    oView:SetContinuousForm(.T.)
    oView:CreateHorizontalBox( 'BOXFORMSB1', 10)
    oView:AddField('FORMSB1' , oStruSB1,'SB1MASTER' )
    oView:SetOwnerView('FORMSB1','BOXFORMSB1')
    oView:EnableTitleView("FORMSB1", FwX2Nome("SB1"))
    oStruSB5:= FWFormStruct(2, 'SB5')
    oView:AddField('FORMSB5' , oStruSB5,'SB5DETAIL' )

    cNewCd := Alltrim(SB1->B1_COD)+cMarca

    oModel:SetValue("SB1MASTER","B1_COD"      ,cNewCd)
    
    For nCont := 1 to len(aHoBrw1)
        If !Alltrim(aHoBrw1[nCont,01]) $ 'B1_COD'
            oModel:SetValue("SB1MASTER",aHoBrw1[nCont,01]      ,aHoBrw1[nCont,02])
        EndIf
    Next nCont
    
    nCont := Ascan(aHoBrw1,{|x| Alltrim(x[1]) == "B1_CONTA"})
    oModel:SetValue("SB1MASTER",aHoBrw1[nCont,01]      ,aHoBrw1[nCont,02])
    nCont := Ascan(aHoBrw1,{|x| Alltrim(x[1]) == "B1_DESC"})

    oModel:SetValue("SB1MASTER","B1_GRUPO"    ,cGrupo)
    oModel:SetValue("SB1MASTER","B1_XCODPAI"  ,cCodigo)
    oModel:SetValue("SB1MASTER","B1_ZMARCA"   ,cMarca)
    
    oModel:SetValue("SB5DETAIL","B5_FILIAL" ,xFilial("SB5"))
    oModel:SetValue("SB5DETAIL","B5_COD"    ,cNewCd)
    oModel:SetValue("SB5DETAIL","B5_CEME"   ,aHoBrw1[nCont,02])
    
    If oModel:VldData()
        oModel:CommitData()
        //Acrescentado este trecho pois o setvalue nesses campos não esta acontecendo no padrao
        Dbseek(xFilial("SB1")+cNewCd)
        Reclock("SB1",.F.)
        SB1->B1_GRUPO := cGrupo
        SB1->B1_ZMARCA:= cMarca 
        SB1->B1_FABRIC := cCodFab
        SB1->(Msunlock())
        MsgAlert("Registro INCLUIDO!", "Atenção")
        nRecSB1 := SB1->(Recno())
    Else
        VarInfo("",oModel:GetErrorMessage())
        MsgAlert((oModel:GetErrorMessage()[6]), "Atenção")
    EndIf       

    oModel:DeActivate()
    oModel:Destroy()

    oModel := NIL

    DbSelectArea("SB1")
    DbSetOrder(1)
    Dbgoto(nRecSB1)
else 
    MsgAlert("Código Pai inexistente")
EndIf     

RestArea(aArea)

Return


/*/{Protheus.doc} BuscaFBZ(cBkpSb1)
    Busca filiais em que o produto existe para atualizar os filhos
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function BuscaFBZ(cCodigo)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery 

cQuery := "SELECT BZ_FILIAL"
cQuery += " FROM "+RetSQLName("SBZ")+" BZ"
cQuery += " WHERE BZ_COD='"+cCodigo+"'"
cQuery += " AND D_E_L_E_T_=' '"


If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf             

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)  

dbSelectArea("TRB")

While !EOF()
    Aadd(aRet,TRB->BZ_FILIAL)

    Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)
