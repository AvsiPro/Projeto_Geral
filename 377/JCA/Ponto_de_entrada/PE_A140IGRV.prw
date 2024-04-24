#INCLUDE 'PROTHEUS.CH'

/*
    Localização: Function ReadXML() - 
    Funcao para leitura de XMLs de NFe no diretorio de download e geracao da pre-nota de entrada.
    Em que ponto: Após a gravação dos registros importados na tabela SDS e SDT, 
    permite manipular os dados importados para a tabela SDS e SDT.

    Utilizado para manipular o xml da nota e gravar a informação da origem no produto
    no campo DT_ZORIG para posteriormente levar para o D1_ZORIG  e finalmente alterar
    o campo D1_CLASFIS de acordo com a origem do produto informada no xml.

    Solicitado pela usuária Priscila para o Analista Caio por email.

    Finalização 23/04/2024 - Venancio

*/
User Function A140IGRV()

Local cDoc   := ParamIxb[1] // Numero da Nota 
Local cSerie := ParamIxb[2] // SÃ©rie da Nota
Local cCod   := ParamIxb[3] // CÃ³digo do Fornecedor
Local cLoja  := ParamIxb[4] // Loja do Fornecedor
Local cError    := ''
Local cWarning  := ''
Local oXml      := If(len(ParamIxb)>4,ParamIxb[5],XmlParser( CKO->CKO_XMLRET, "_", @cError, @cWarning ))
Local aItens    := {}
Local nCont     := 0
Local nX        := 0
Local aTipICM   := BuscaS2()
Local aSDT      := {}

If len(ParamIxb) > 4
    If XmlChildEx(oXml,"_INFNFE") <> NIL
        If XmlChildEx(oXml:_INFNFE,"_DET") <> NIL
            If VALTYPE(oXml:_INFNFE:_DET) == "A"
                aItens := oXml:_INFNFE:_DET
                For nCont := 1 to len(aItens)
                    If XmlChildEx(aItens[nCont],"_IMPOSTO") <> NIL 
                        If XmlChildEx(aItens[nCont]:_IMPOSTO,"_ICMS") <> NIL
                            For nX := 1 to len(aTipICM) 
                                If XmlChildEx(aItens[nCont]:_IMPOSTO:_ICMS,"_ICMS"+aTipICM[nX]) <> NIL 
                                    cOrigem := &('aItens[nCont]:_IMPOSTO:_ICMS:_ICMS'+aTipICM[nX]+':_ORIG:TEXT')
                                    cItem   := strzero(val(aItens[nCont]:_NITEM:TEXT),4)
                                    cProd   := aItens[nCont]:_PROD:_CPROD:TEXT
                                    Aadd(aSDT,{cCod,cLoja,cDoc,cSerie,cItem,cProd,cOrigem})
                                EndIf 
                            Next nX 
                        EndIf 
                    EndIf 
                Next nCont 
            else 
                If XmlChildEx(oXml:_INFNFE:_DET,"_IMPOSTO") <> NIL 
                    If XmlChildEx(oXml:_INFNFE:_DET:_IMPOSTO,"_ICMS") <> NIL
                        For nX := 1 to len(aTipICM)
                            If XmlChildEx(oXml:_INFNFE:_DET:_IMPOSTO:_ICMS,"_ICMS"+aTipICM[nX]) <> NIL
                                cOrigem := &('oXml:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS'+aTipICM[nX]+':_ORIG:TEXT')
                                cItem   := strzero(val(oXml:_INFNFE:_DET:_NITEM:TEXT),4)
                                cProd   := oXml:_INFNFE:_DET:_PROD:_CPROD:TEXT
                                Aadd(aSDT,{cCod,cLoja,cDoc,cSerie,cItem,cProd,cOrigem})
                            EndIF 
                        Next nX 
                    EndIF  
                EndIF 
            EndIf 
        EndIF 
    EndIF 
else
    If XmlChildEx(oXml,"_NFEPROC") <> NIL
        If XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE,"_DET") <> NIL 
            If VALTYPE(oXml:_NFEPROC:_NFE:_INFNFE:_DET) == "A"
                aItens := oXml:_NFEPROC:_NFE:_INFNFE:_DET

                For nCont := 1 to len(aItens)
                    If XmlChildEx(aItens[nCont],"_IMPOSTO") <> NIL 
                        If XmlChildEx(aItens[nCont]:_IMPOSTO,"_ICMS") <> NIL
                            For nX := 1 to len(aTipICM) 
                                If XmlChildEx(aItens[nCont]:_IMPOSTO:_ICMS,"_ICMS"+aTipICM[nX]) <> NIL 
                                    cOrigem := &('aItens[nCont]:_IMPOSTO:_ICMS:_ICMS'+aTipICM[nX]+':_ORIG:TEXT')
                                    cItem   := strzero(val(aItens[nCont]:_NITEM:TEXT),4)
                                    cProd   := aItens[nCont]:_PROD:_CPROD:TEXT
                                    Aadd(aSDT,{cCod,cLoja,cDoc,cSerie,cItem,cProd,cOrigem})
                                EndIf 
                            Next nX 
                        EndIf 
                    EndIf 
                Next nCont 
            Else 
                If XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_DET,"_IMPOSTO") <> NIL 
                    If XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_IMPOSTO,"_ICMS") <> NIL
                        For nX := 1 to len(aTipICM)
                            If XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS,"_ICMS"+aTipICM[nX]) <> NIL
                                cOrigem := &('oXml:_NFEPROC:_NFE:_INFNFE:_DET:_IMPOSTO:_ICMS:_ICMS'+aTipICM[nX]+':_ORIG:TEXT')
                                cItem   := strzero(val(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_NITEM:TEXT),4)
                                cProd   := oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT
                                Aadd(aSDT,{cCod,cLoja,cDoc,cSerie,cItem,cProd,cOrigem})
                            EndIF 
                        Next nX 
                    EndIF  
                EndIF 
            EndIf 
        EndIf 
    EndIf 
EndIf 

For nCont := 1 to len(aSDT)
    //DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE+DT_ITEM
    DbSelectArea("SDT")
    DbSetOrder(8)
    If Dbseek(xFilial("SDT")+aSDT[nCont,01]+aSDT[nCont,02]+aSDT[nCont,03]+aSDT[nCont,04]+aSDT[nCont,05])
        Reclock("SDT",.F.)
        SDT->DT_ZORIG := aSDT[nCont,07]
        SDT->(Msunlock())
    EndIf 
Next nCont 

Return

/*/{Protheus.doc} BuscaS2()
    Busca tipos ICMS para validação no xml
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
Static Function BuscaS2()

Local aArea :=  GetArea()
Local aRet  :=  {}

DbSelectArea("SX5")
DbSetOrder(1)
If Dbseek(xFilial("SX5")+'S2')
    While !Eof() .And. SX5->X5_TABELA == 'S2'
        Aadd(aRet,Alltrim(SX5->X5_CHAVE))
        Dbskip()
    EndDo 

EndIf 

RestArea(aArea)

Return(aRet) 
