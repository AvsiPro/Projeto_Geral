#Include "protheus.ch"
#Include "topconn.ch"

/*/{Protheus.doc} WGENM001
Função generica que le as tabelas Z90 e Z91 
para montar o json de cada api dinamicamente
@type user function
@author Alexandre Venâncio
@since 08/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WGENM001(cCodigo,lVisual)

    Local aArea     := GetArea()
    Local aCabec    := {}
    Local aItens    := {}
    Local cJson     := ""
    Local aRet      := {}

    Default cCodigo := '000001'
    Default lVisual := .F.

    If Empty(FunName())
        RpcSetType(3)
        RpcSetEnv('T1','D MG 01 ')
    EndIf

    aCabec := BuscaZ90(cCodigo)
    aItens := BuscaZ91(cCodigo)
    cJson  := MontaJson(aItens)

    If lVisual
        U__VerJson(cJson)
    Else 
        Aadd(aRet,cJson)
        Aadd(aRet,aCabec)
        Aadd(aRet,aItens)
    EndIf 

    RestArea(aArea)
    
Return(aRet)

/*/{Protheus.doc} WGENM002
Executa a rotina de integração através da chamada do Browse
@type user function
@author user
@since 15/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WGENM002(cCodigo)

    Local aArea := GetArea()
    Local cChamada := ""

    If !Empty(Z90->Z90_EXECUT)
        If !"U_" $ Alltrim(Z90->Z90_EXECUT)
            cChamada := "U_"+Alltrim(Z90->Z90_EXECUT)
        else 
            cChamada := Alltrim(Z90->Z90_EXECUT)
        endif 

        If !"()" $ cChamada 
            cChamada := cChamada+"('"+Alltrim(cCodigo)+"')"
        Else 
            cChamada := strtran(cChamada,"()","('"+Alltrim(cCodigo)+"')")
        EndIf 


        &(cChamada)
    Else 
        MsgAlert("Não há uma rotina configurada para executar esta integração.")
    EndIf 

    RestArea(aArea)

Return

/*/{Protheus.doc} WGENM003
Importar Json pronto para montar a estrutura na tabela com os campos da api de destino
@type user function
@author user
@since 15/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WGENM003()

    Local aArea     := GetArea()
    Local cJsonT    := space(100000)
    Local aItemZ91  := {}
    Local oModel    := FWModelActive()
    Local nOpcao    := 0
    Local oModelItm := oModel:GetModel("Z91DETAIL")
    
    Private oFontMod    := TFont():New('Arial', , -18)
    //Local nOperacao := oModel:GetOperation()
    
    If Empty(FunName())
        RpcSetType(3)
        RpcSetEnv('T1','D MG 01 ')
    EndIf
    
    Private oDlg1,oGrp1,oMGet1,oGrp2,oMGet2,oBtn1,oBtn2,oBtn3

    oDlg1      := MSDialog():New( 092,232,718,1346,"Importar Json",,,.F.,,,,,,.T.,,,.T. )
    
    oGrp1      := TGroup():New( 004,004,272,272,"Original",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        oMGet1     := TMultiGet():New( 012,008,{|u| if(pcount() > 0, cJsonT := u, cJsonT )},oGrp1,260,256,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
    
    oGrp2      := TGroup():New( 004,276,272,544,"Protheus",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oMGet2     := TMultiGet():New( 012,280,,oGrp2,260,256,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )

        oSay1      := TSay():New( 140,350,{||""},oGrp2,,oFontMod,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,332,008)
        
    oBtn1      := TButton():New( 284,176,"Carga",oDlg1,{|| aItemZ91 := CriaJson(cJsonT) },037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 284,260,"Salvar",oDlg1,{|| oDlg1:end(nOpcao:= 1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( 284,340,"Sair",oDlg1,{|| oDlg1:end(nOpcao:= 0)},037,012,,,,.T.,,"",,,,.F. )

    oBtn2:disable()

    oDlg1:Activate(,,,.T.)


    If nOpcao == 1
        CargaItm(aItemZ91,oModelItm)
    EndIF 

    RestArea(aArea)

Return 
/*/{Protheus.doc} BuscaZ90
    Busca os dados de informação principal da API de destino
    @type  Static Function
    @author user
    @since 08/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaZ90(cCodigo)

    Local aArea := GetArea()
    Local aRet  := {}

    DbSelectArea("Z90")
    DbSetOrder(1)
    If Dbseek(xFilial("Z90")+cCodigo)
        Aadd(aRet,Z90->Z90_VERBO)
        Aadd(aRet,Z90->Z90_URLDEV)
        Aadd(aRet,Z90->Z90_URLQA)
        Aadd(aRet,Z90->Z90_URLPRD)
        Aadd(aRet,Z90->Z90_ENDDEV)
        Aadd(aRet,Z90->Z90_ENDQA)
        Aadd(aRet,Z90->Z90_ENDPRD)
        Aadd(aRet,Z90->Z90_DESC)
        Aadd(aRet,Z90->Z90_TIPO)
        Aadd(aRet,Z90->Z90_MODCOM)
        Aadd(aRet,Z90->Z90_REQAUT)
        Aadd(aRet,Z90->Z90_HEADDV)
        Aadd(aRet,Z90->Z90_HEADQA)
        Aadd(aRet,Z90->Z90_HEADPR)
        Aadd(aRet,Z90->Z90_CALLBA)
        Aadd(aRet,Z90->Z90_ULTEXC)
        Aadd(aRet,Z90->Z90_QUERY)
    Else 

    EndIf 

    RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} BuscaP91
    Busca os dados referentes aos campos a serem enviados para a api com seu relacionamento local
    @type  Static Function
    @author user
    @since 08/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaZ91(cCodigo)

    Local aArea := GetArea()
    Local aRet  := {}

    DbSelectArea("Z91")
    DbSetOrder(1)
    If Dbseek(xFilial("Z91")+cCodigo)
        While !Eof() .And. Z91->Z91_COD == cCodigo
            Aadd(aRet,{ Alltrim(Z91->Z91_CPOPAI),;
                        Alltrim(Z91->Z91_TIPPAI),;
                        Alltrim(Z91->Z91_CPODES),;
                        Alltrim(Z91->Z91_CPOORI),;
                        Alltrim(Z91->Z91_CNTFIX),;
                        Alltrim(Z91->Z91_TIPCNT),;
                        Alltrim(Z91->Z91_ITEM),;
                        Alltrim(Z91->Z91_MAXLEN)})
            Dbskip()
        EndDo 
    Else 

    EndIf 

    RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} MontaJson(aItens)
    Monta o Json ja fazendo o de/para dos campos
    @type  Static Function
    @author user
    @since 08/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MontaJson(aItens)

    Local aArea := GetArea()
    Local cJson := ""
    Local oJson := JsonObject():New()
    Local nCont := 0
    Local nX    := 0
    Local nZ    := 0
    Local cCpoDes := ''
    Local cFilDes := ''
    Local oItem := Nil
    Local oFilho:= Nil 

    //Primeira vez pega somente os itens da raiz
    For nCont := 1 to len(aItens)
        If Empty(aItens[nCont,01]) .And. Empty(aItens[nCont,02])
            oJson[&("aItens[nCont,03]")] := If(!Empty(aItens[nCont,05]),aItens[nCont,05],aItens[nCont,04])
        EndIf 
    Next nCont 

    //Segunda vez pega os "pais" da raiz e para os demais "pais" já monta a estrutura restante
    For nCont := 1 to len(aItens)
        If Empty(aItens[nCont,01]) .And. aItens[nCont,06] == "P"
            oJson[&("aItens[nCont,03]")] := {} 
            cCpoDes := aItens[nCont,03]
            oItem := JsonObject():New()
            oFilho := Nil 

            For nX := 1 to len(aItens)
                If AllTrim(aItens[nX,01]) == AllTrim(cCpoDes)
                    oItem[aItens[nX,03]] := If(!Empty(aItens[nX,05]), aItens[nX,05], If(aItens[nX,06] == "P",{},aItens[nX,04]))

                    If aItens[nX,06] == "P"
                        cFilDes := aItens[nX,03]
                        oFilho := JsonObject():New()
                        For nZ := 1 to len(aItens)
                            If AllTrim(aItens[nZ,01]) == AllTrim(cFilDes)
                                oFilho[aItens[nZ,03]] := If(!Empty(aItens[nZ,05]), aItens[nZ,05], If(aItens[nZ,06] == "P",{},aItens[nZ,04]))
                            EndIf 
                        Next nZ 
                        Aadd(oItem[aItens[nX,03]],oFilho)
                    EndIf 
                EndIf
            Next nX

            // Adiciona o objeto no array
            aAdd(oJson[cCpoDes], oItem)
        
        EndIf 
    Next nCont 

    cJson := oJson:toJson()


    RestArea(aArea)

Return(cJson)

/*/{Protheus.doc} CriaJson
    Cria o objeto do json do conteúdo copiado
    @type  Static Function
    @author user
    @since 22/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function CriaJson(cJson)

    Local aArea   := GetArea()
    Local oJson   := JsonObject():New()
    Local aNames  := {}
    Local nCont   := 1
    Local nX      := 1
    Local keyVal  := ""
    Local keyType := ""
    Local aRet    := {}
    Local aAux    := {}
    Local aAux2   := {}
    Local aName2  := {}

    oJson:FromJson(cJson)

    aNames := oJson:GetNames()

    For nCont := 1 to len(aNames)
        oJson:GetJsonValue(aNames[nCont],@keyVal,@keyType)
        If keyType == "A"
            Aadd(aRet,{aNames[nCont],{}})
            aAux := oJson:GetJsonObject(aNames[nCont])
            aName2 := aAux[1]:GetNames()

            For nX := 1 to len(aName2)
                aAux2 := {}
                aAux[1]:GetJsonValue(aName2[nX],@keyVal,@keyType)
                Aadd(aAux2,aName2[nX])
                Aadd(aAux2,keyVal)
                Aadd(aRet[len(aRet),2],aAux2)
            Next nX 
            
        ElseIf keyType == "O"

        Else 
            Aadd(aRet,{aNames[nCont],keyVal})
        EndIF 
    Next nCont

    oSay1:settext("")

    If valtype(oJson) == "J"
        oSay1:settext("Json OK")
        oBtn2:enable()
    Else 
        oSay1:settext("Problema ao carregar o Json")
        oBtn2:disable()
    EndIf 

    oDlg1:refresh()

    RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} CargaItm
    Carrega os itens do json copiado para o grid na inclusão
    @type  Static Function
    @author user
    @since 22/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function CargaItm(aItemZ91,oModelItm)

    Local aArea := GetArea()    
    Local nCont,nX,nZ,nW,nY,nP   
    Local aErro     := {}
    Local cPai      := ""
    Local cPaiOri   := ""
    Local cCpoDst   := ""
    Local nLines    := 1 
    Local cCodZ90   := Z90->Z90_COD 
    Local cTipoD    := ''
    Local aItemJs   := {}

    If len(aItemZ91) > 0 
        For nCont := 1 to len(aItemZ91)

            
            PulaLinha(oModelItm,nLines)

            cCpoDst := aItemZ91[nCont,1]

            If valtype(aItemZ91[nCont,02]) <> "A"

                cTipoD := TipoDado(aItemZ91[nCont,02],valtype(aItemZ91[nCont,02]))

                CpoApi(@oModelItm,cCodZ90,cCpoDst,cTipoD,cPai,'')

                aErro := Grava(oModelItm) 
            Else 
            
                cTipoD := TipoDado(aItemZ91[nCont,02],valtype(aItemZ91[nCont,02]))
                cTipPai:= valtype(aItemZ91[nCont,02])

                CpoApi(oModelItm,cCodZ90,cCpoDst,cTipoD,cPai,cTipPai)

                aErro := Grava(oModelItm) 

                If cPai <> aItemZ91[nCont,1]
                    cPai := aItemZ91[nCont,1]
                    cPaiOri := aItemZ91[nCont,1]
                EndIf 

                For nX := 2 to len(aItemZ91[nCont])

                    For nZ := 1 to len(aItemZ91[nCont,nX])

                        PulaLinha(oModelItm,nLines)

                        cCpoDst := aItemZ91[nCont,nX,nZ,1]

                        If valtype(aItemZ91[nCont,nX,nZ,02]) <> "A"

                            cTipoD := TipoDado(aItemZ91[nCont,nX,nZ,02],valtype(aItemZ91[nCont,nX,nZ,02]))

                            CpoApi(@oModelItm,cCodZ90,cCpoDst,cTipoD,cPai,'')
                            aErro := Grava(oModelItm)
                        Else 
                            cTipoD := TipoDado(aItemZ91[nCont,nX,nZ,02],valtype(aItemZ91[nCont,nX,nZ,02]))

                            cCpoDst :=  aItemZ91[nCont,nX,nZ,01]
                            cTipPai:= valtype(aItemZ91[nCont,nX,nZ,02])
                
                            CpoApi(oModelItm,cCodZ90,cCpoDst,cTipoD,cPaiOri,cTipPai)

                            aErro := Grava(oModelItm) 

                            If cPai <> cCpoDst 
                                cPai := cCpoDst
                            EndIf 

                            For nW := 2 to len(aItemZ91[nCont,nX,nZ])
                                For nY := 1 to len(aItemZ91[nCont,nX,nZ,nW])
                                    

                                    If Valtype(aItemZ91[nCont,nX,nZ,nW,nY]) == "J"
                                        aItemJs := aItemZ91[nCont,nX,nZ,nW,nY]:GetNames()

                                        For nP := 1 to len(aItemJs)
                                            PulaLinha(oModelItm,nLines)

                                            cCmpo  := aItemJs[nP]
                                            cConteudo := aItemZ91[nCont,nX,nZ,nW,nY]:GetJsonText(aItemJs[nP])
                                            cTipoD := TipoDado(cConteudo,valtype(cConteudo))

                                            CpoApi(@oModelItm,cCodZ90,cCmpo,cTipoD,cPai,'')
                                            aErro := Grava(oModelItm)
                                        Next nP 
                                    Else 

                                        PulaLinha(oModelItm,nLines)

                                        cCpoDst := aItemZ91[nCont,nX,nZ,nW,nY,1]

                                        If valtype(aItemZ91[nCont,nX,nZ,02]) <> "A"
                                            
                                            cTipoD := TipoDado(aItemZ91[nCont,nX,nZ,02],valtype(aItemZ91[nCont,nX,nZ,02]))
                                            CpoApi(@oModelItm,cCodZ90,cCpoDst,cTipoD,cPai,'')

                                            aErro := Grava(oModelItm)
                                        EndIf 
                                    EndIF 
                                Next nY 
                            Next nW 
                        EndIf 
                    Next nZ 
                Next nX 
            Endif 

            nLines++

        Next nCont 

        oModelItm:GoLine( 1 )
    EndIF 
    
    RestArea(aArea)

Return

/*/{Protheus.doc} Grava
    Grava a Linha no grid
    @type  Static Function
    @author user
    @since 22/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Grava(oModelItm)

    Local aRet := {}

    If !oModelItm:VldData()
        aRet := oModelItm:GetErrorMessage()
    EndIF

Return(aRet)

/*/{Protheus.doc} CpoApi
    (long_description)
    @type  Static Function
    @author user
    @since 22/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function CpoApi(oModelItm,cCodZ90,cCpoDst,cTipoD,cPai,cTipPai)
    
    oModelItm:setValue("Z91_COD"     , cCodZ90  )
    oModelItm:setValue("Z91_CPODES"  , cCpoDst  )

    oModelItm:setValue("Z91_TIPCNT"  , cTipoD   )
    oModelItm:setValue("Z91_CPOPAI"  , cPai     )

    If !Empty(cTipPai)
        oModelItm:setValue("Z91_TIPPAI"  , If(cTipPai=="A",'1','2')     )
    EndIF 
                
Return

/*/{Protheus.doc} PulaLinha
    Inclui novas linhas no grid
    @type  Static Function
    @author user
    @since 22/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function PulaLinha(oModelItm,nLines)
    
    IF nLines > 1 
        oModelItm:addLine()
    EndIf 

Return

/*/{Protheus.doc} TipoDado
    Verifica o tipo de dado do campo
    @type  Static Function
    @author user
    @since 22/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function TipoDado(cConteudo,cStr)

    Local aArea := GetArea()
    Local cRet  := ''

    If cStr == "C"
        If upper(cConteudo) == 'STRING'
            cRet := "S"
        ElseIf valtype(stod(strtran(substr(cConteudo,1,10),"-"))) == "D"
            cRet := "D"
        Else 
            cRet := "S"
        EndIf 
    ElseIf cStr == "N"
        cRet := "N"
    ElseIf cStr == "L"
        cRet := "B"
    ElseIf cStr == "D"
        cRet := "D"
    ElseIf cStr == "A"
        cRet := "P"
    ElseIf cStr == "J"
        cRet := "P"
    EndIf 
     
    RestArea(aArea)

Return(cRet) 
