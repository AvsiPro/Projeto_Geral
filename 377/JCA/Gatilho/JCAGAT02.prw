#INCLUDE 'PROTHEUS.CH'
/*
    xx Gatilho campo Grupo para produto para criar sequencial do codigo de acordo
    xx com grupo selecionado
    xxxMIT 44_ESTOQUE_EST001 - Codifica��o de Produtos
    xxxhttps://docs.google.com/document/d/10vxbtI4iBcPuf7l3qImxY1BYB1OKtP3Q/edit
    
*/
User Function JCAGAT02()

Local aAuxX3 := {}
Local nCont  := 1
Local cTabela:= "SB1"
Local aHoBrw1:= {}
Local aPergs := {}
Local cMarca := space(4)
Local cDescM := ''

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

aAdd(aPergs, {1, "Marca",  cMarca,  "", ".T.", "ZPM", ".T.", 80,  .F.})

If ParamBox(aPergs, "Informe a natureza para movimento banc�rio")
    cMarca := MV_PAR01
    cDescM := Alltrim(Posicione("ZPM",1,xFilial("ZPM")+cMarca,"ZPM_DESC"))


    If DbSeek(xFilial("SB1")+SB1->B1_COD) //

        //aAuxX3 := FWSX3Util():GetAllFields( cTabela , .F. )
        aAuxX3 := FWSX3Util():GetListFieldsStruct( cTabela , .F. )

        For nCont := 1 to len(aAuxX3)
            lUsado := X3USO(GetSX3Cache(aAuxX3[nCont,1], "X3_USADO"))
            If lUsado
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


        oModel:SetValue("SB1MASTER","B1_COD"      ,Alltrim(SB1->B1_COD)+'-'+cMarca)
        oModel:SetValue("SB1MASTER","B1_ZMARCA"   ,cMarca)
        
        For nCont := 1 to len(aHoBrw1)
            If !Alltrim(aHoBrw1[nCont,01]) $ 'B1_COD'
                oModel:SetValue("SB1MASTER",aHoBrw1[nCont,01]      ,aHoBrw1[nCont,02])
            EndIf
        Next nCont
        
        nCont := Ascan(aHoBrw1,{|x| Alltrim(x[1]) == "B1_CONTA"})
        oModel:SetValue("SB1MASTER",aHoBrw1[nCont,01]      ,aHoBrw1[nCont,02])
        nCont := Ascan(aHoBrw1,{|x| Alltrim(x[1]) == "B1_DESC"})

        oModel:SetValue("SB5DETAIL","B5_FILIAL" ,xFilial("SB5"))
        oModel:SetValue("SB5DETAIL","B5_COD"    ,Alltrim(SB1->B1_COD)+'-'+cMarca)
        oModel:SetValue("SB5DETAIL","B5_CEME"   ,aHoBrw1[nCont,02])
        
        If oModel:VldData()
            oModel:CommitData()
            MsgAlert("Registro INCLUIDO!", "Aten��o")
        Else
            VarInfo("",oModel:GetErrorMessage())
        EndIf       

        oModel:DeActivate()
        oModel:Destroy()

        oModel := NIL
    else 
        MsgAlert("C�digo Pai inexistente")
    EndIf 
ENDIF

Return
