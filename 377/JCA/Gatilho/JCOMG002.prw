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


Local aPergs := {}
Local cMarca := space(4)
Local cDescM := ''
Local cCodigo:= SB1->B1_COD
Local lPerm  := .T.
Local cGrupo := SB1->B1_GRUPO

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

lPerm := SUPERGETMV( "TI_PERMCA", .F., "377" )

If !Empty(SB1->B1_XCODPAI)
    MsgAlert("Somente produtos Pai podem ser utilizados na cópia JCA")
Else 

    aAdd(aPergs, {1, "Marca",  cMarca,  "", ".T.", "ZPM", ".T.", 80,  .F.})

    If ParamBox(aPergs, "Informe o código da Marca a ser gerada para o produto")
        cMarca := MV_PAR01
        cDescM := Alltrim(Posicione("ZPM",1,xFilial("ZPM")+cMarca,"ZPM_DESC"))
        If !Dbseek(xFilial("SB1")+Alltrim(cCodigo)+Alltrim(cMarca))
            Processa({|| gerafilho(cMarca,cDescM,cCodigo,cGrupo)},"Aguarde!!!")
        else
            MsgAlert("Produto já existe com a marca selecionada.")
        Endif 
    ENDIF
ENDIF

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
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
Static Function gerafilho(cMarca,cDescM,cCodigo,cGrupo)

Local nCont  := 1
Local cTabela:= "SB1"
Local aHoBrw1:= {}
Local aAuxX3 := {}
Local cNewCd := ""
Local cCpoNcp := SuperGetMv("TI_CPONTCP",.F.,"B1_EMIN/B1_ESTSEG/B1_PE/B1_TIPE/B1_LE/B1_TOLER/B1_EMAX")

If DbSeek(xFilial("SB1")+cCodigo) //

    //aAuxX3 := FWSX3Util():GetAllFields( cTabela , .F. )
    aAuxX3 := FWSX3Util():GetListFieldsStruct( cTabela , .F. )

    For nCont := 1 to len(aAuxX3)
        lUsado := X3USO(GetSX3Cache(aAuxX3[nCont,1], "X3_USADO"))
        If lUsado .And. !Alltrim(aAuxX3[nCont,1]) $ cCpoNcp
            If Alltrim(aAuxX3[nCont,1]) == "B1_DESC"
                Aadd(aHoBrw1,{aAuxX3[nCont,1],Alltrim(&("SB1->"+aAuxX3[nCont,1]))+' '+cDescM})
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

    //oModel:SetValue("SB1MASTER","B1_GRUPO"    ,cGrupo)
    oModel:SetValue("SB1MASTER","B1_XCODPAI"  ,cCodigo)
    //oModel:SetValue("SB1MASTER","B1_ZMARCA"   ,cMarca)
    
    oModel:SetValue("SB5DETAIL","B5_FILIAL" ,xFilial("SB5"))
    oModel:SetValue("SB5DETAIL","B5_COD"    ,cNewCd)
    oModel:SetValue("SB5DETAIL","B5_CEME"   ,aHoBrw1[nCont,02])
    
    If oModel:VldData()
        oModel:CommitData()
        Dbseek(xFilial("SB1")+cNewCd)
        Reclock("SB1",.F.)
        SB1->B1_GRUPO := cGrupo
        SB1->B1_ZMARCA:= cMarca 
        SB1->(Msunlock())
        MsgAlert("Registro INCLUIDO!", "Atenção")
    Else
        VarInfo("",oModel:GetErrorMessage())
        MsgAlert((oModel:GetErrorMessage()[6]), "Atenção")
    EndIf       

    oModel:DeActivate()
    oModel:Destroy()

    oModel := NIL
else 
    MsgAlert("Código Pai inexistente")
EndIf     

Return
