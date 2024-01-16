#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"
#INCLUDE "FWMVCDEF.CH"

/*
    API
    Api de pesquisa PLANO DE SAUDE, ODONTOLOGICO e Outros beneficios  - GESTÃO DE PESSOAS
    Doc Mit   
    
*/

WSRESTFUL JWSBENPS DESCRIPTION "Rest de PLANO DE SAUDE, ODONTOLOGICO e Outros beneficios  - GESTÃO DE PESSOAS"
    WSMETHOD GET DESCRIPTION "Obtem os dados da RHK RHL RHM e RH1" WSSYNTAX "/JWSBENPS/{EMPRESA/MATRICULA/}"
ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSBENPS

    LOCAL lRet          := .T.
    LOCAL cTabela       := ""
    LOCAL aCampos       := {}
    LOCAL nX            := 0
    LOCAL nLinha        := 0
    LOCAL oResponse     := JsonObject():New()
    LOCAL oCampo        := JsonObject():New()
    LOCAL lBen          := .T.
    LOCAL lOb           := .T.
    LOCAL lFilok        := .F.

    RpcClearEnv()
    RpcSetType(3)
    RPCSetEnv('01','00020087')

    ::SetContentType("application/json")


    IF !MyOpenSM0()
        lRet:= .F.
        oResponse['code'] := 1
        oResponse['status'] := 500
        oResponse['message'] := 'Falha ao abrir ambiente de trabalho!'
        oResponse['detailedMessage'] := ''
    ENDIF
    ConOut("passou emoresa")

    If LEN(self:aURLParms) > 0
        MyOpenSM0()
        SM0->( DBGOTOP() )
        WHILE !SM0->( EOF() ) .and. !lFilok
            IF padl(::aURLParms[1],8,"0") == ALLTRIM(SM0->M0_CODFIL)
                cFilant := ALLTRIM(SM0->M0_CODFIL)
                lFilok := .T.
            ENDIF
            SM0->( DBSKIP() )
        ENDDO

        IF !lFilok
            lRet := .F.
            oResponse['code'] := 2
            oResponse['status'] := 404
            oResponse['message'] := 'Confira a filial digitada.'
            oResponse['detailedMessage'] := ''
        ENDIF
    ENDIF

    IF lRet
        //PESQUISA PLANO DE SAUDE E ADONTOLOGICP
        cTabela := "RHK"
        oStruSTAB  := FWFormStruct( 1, cTabela , /* bAvalCampo */, /* lViewUsado */ )
        aFields   := oStruSTAB:aFields //oStruTAB:GetStruct():GetFields()
        aCampos := {}
        nX := 0
        For nX := 1 To Len( aFields )
            AADD(aCampos,{aFields[nX,3],aFields[nX,4],aFields[nX,14]})
        Next nX

        //CONSULTA RHK PELA EMPRESA E MATRICULA
        IF LEN(self:aURLParms) == 2
            cSeek := alltrim(::aURLParms[2])
            DBSELECTAREA("RHK")
            RHK->( DBSETORDER(1) )//::aURLParms[2] RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR
            IF RHK->( DBSEEK( xFilial(cTabela) + cSeek ) ) //.AND. lRet]
                oCampo['DADOS']   := {}
                nLinha := 0
                WHILE !RHK->( EOF() ) .AND. RHK->RHK_MAT == cSeek
                    AADD( oCampo['DADOS'], JsonObject():New() )

                    nLinha += 1
                    //verifica 1 ass medica 2 assis odontologica
                    IF RHK->RHK_TPFORN == "1"
                        oCampo['DADOS'][nLinha]["DESC_TIPO"] :=  EncodeUTF8("Assistência Médica","cp1252")
                        //BUSCA DADOS NA RFO tipo 1
                    ELSEIF RHK->RHK_TPFORN == "2"
                        oCampo['DADOS'][nLinha]["DESC_TIPO"] :=  EncodeUTF8("Assistência Odontológica","cp1252")
                    ENDIF

                    FOR nX := 1 to len(aCampos)
                        IF !aCampos[nX,3]
                            IF aCampos[nX,2]=="C"
                                oCampo['DADOS'][nLinha][aCampos[nX,1]] :=  EncodeUTF8(RHK->&(aCampos[nX,1]),"cp1252")
                            ELSEIF aCampos[nX,2]=="D"
                                oCampo['DADOS'][nLinha][aCampos[nX,1]] :=  DTOS(RHK->&(aCampos[nX,1]))
                            ELSEIF aCampos[nX,2]=="N"
                                oCampo['DADOS'][nLinha][aCampos[nX,1]] :=  RHK->&(aCampos[nX,1])
                            ENDIF
                        ENDIF
                    NEXT nX
                    RHK->( DBSKIP() )
                ENDDO

                RHK->(DBCLOSEAREA())

                DBSELECTAREA("RHL")
                //pesquisa dependentes tabela rhl
                cTabela := "RHL"//UPPER(ALLTRIM(::aURLParms[2]))
                oStruSRHL  := FWFormStruct( 1, cTabela , /* bAvalCampo */, /* lViewUsado */ )
                aFields   := oStruSRHL:aFields//oStruTAB:GetStruct():GetFields()
                nX := 0
                aCampos := {}
                nX := 0

                For nX := 1 To Len( aFields )
                    AADD(aCampos,{aFields[nX,3],aFields[nX,4],aFields[nX,14]})
                Next nX

                RHL->( DBSETORDER(1) )//::aURLParms[2] RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO
                IF RHL->( DBSEEK( xFilial(cTabela) + cSeek ) )

                    //tabela para buscar nome do dependente
                    DbSelectArea("SRB")

                    oCampo['DEPEN']   := {}
                    nLinha := 0
                    WHILE !RHL->( EOF() ) .AND. RHL->RHL_MAT == cSeek
                        AADD( oCampo['DEPEN'], JsonObject():New() )

                        nLinha += 1
                        //RB_FILIAL+RB_MAT+RB_COD
                        oCampo['DEPEN'][nLinha]["NOME"] := EncodeUTF8(GetAdvFVal("SRB","RB_NOME",xFilial("SRB")+RHL->(RHL_MAT+RHL_CODIGO),1,"Erro"),"cp1252")
                        //verifica se 1 ass medica 2 assis odontologica
                        IF RHL->RHL_TPFORN == "1"
                            oCampo['DEPEN'][nLinha]["DESC_TIPO"] :=  EncodeUTF8("Assistência Médica","cp1252")
                            //BUSCA DADOS NA RFO tipo 1
                        ELSEIF RHL->RHL_TPFORN == "2"
                            oCampo['DEPEN'][nLinha]["DESC_TIPO"] :=  EncodeUTF8("Assistência Odontológica","cp1252")
                        ENDIF

                        FOR nX := 1 to len(aCampos)
                            IF !aCampos[nX,3]
                                IF aCampos[nX,2]=="C"
                                    oCampo['DEPEN'][nLinha][aCampos[nX,1]] :=  EncodeUTF8(RHL->&(aCampos[nX,1]),"cp1252")
                                ELSEIF aCampos[nX,2]=="D"
                                    oCampo['DEPEN'][nLinha][aCampos[nX,1]] :=  DTOS(RHL->&(aCampos[nX,1]))
                                ELSEIF aCampos[nX,2]=="N"
                                    oCampo['DEPEN'][nLinha][aCampos[nX,1]] :=  RHL->&(aCampos[nX,1])
                                ENDIF
                            ENDIF
                        NEXT nX
                        RHL->( DBSKIP() )
                    ENDDO
                ENDIF
                RHK->(DBCLOSEAREA())
                SRB->(DBCLOSEAREA())

                DBSELECTAREA("RHM")

                //pesquisa agregados tabela RHM
                cTabela := "RHM"//UPPER(ALLTRIM(::aURLParms[2]))
                oStruSRHM  := FWFormStruct( 1, cTabela , /* bAvalCampo */, /* lViewUsado */ )
                aFields   := oStruSRHM:aFields//oStruTAB:GetStruct():GetFields()
                nX := 0
                aCampos := {}
                nX := 0
                For nX := 1 To Len( aFields )
                    AADD(aCampos,{aFields[nX,3],aFields[nX,4],aFields[nX,14]})
                Next nX

                RHM->( DBSETORDER(1) )//::aURLParms[2] RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO
                IF RHM->( DBSEEK( xFilial(cTabela) + cSeek ) )
                    oCampo['AGREG']   := {}
                    nLinha := 0
                    WHILE !RHM->( EOF() ) .AND. RHM->RHM_MAT == cSeek
                        AADD( oCampo['AGREG'], JsonObject():New() )

                        nLinha += 1
                        //verifica se 1 ass medica 2 assis odontologica
                        IF RHM->RHM_TPFORN == "1"
                            oCampo['AGREG'][nLinha]["DESC_TIPO"] :=  EncodeUTF8("Assistência Médica","cp1252")
                            //BUSCA DADOS NA RFO tipo 1
                        ELSEIF RHM->RHM_TPFORN == "2"
                            oCampo['AGREG'][nLinha]["DESC_TIPO"] :=  EncodeUTF8("Assistência Odontológica","cp1252")
                        ENDIF

                        FOR nX := 1 to len(aCampos)
                            IF !aCampos[nX,3]
                                IF aCampos[nX,2]=="C"
                                    oCampo['AGREG'][nLinha][aCampos[nX,1]] :=  EncodeUTF8(RHM->&(aCampos[nX,1]),"cp1252")
                                ELSEIF aCampos[nX,2]=="D"
                                    oCampo['AGREG'][nLinha][aCampos[nX,1]] :=  DTOS(RHM->&(aCampos[nX,1]))
                                ELSEIF aCampos[nX,2]=="N"
                                    oCampo['AGREG'][nLinha][aCampos[nX,1]] :=  RHM->&(aCampos[nX,1])
                                ENDIF
                            ENDIF
                        NEXT nX
                        RHM->( DBSKIP() )
                    ENDDO
                ENDIF
                SHM->(DBCLOSEAREA())
                //::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
            ELSE
                lBen := .F.
            ENDIF

            DBSELECTAREA("RI1")
            //PESQUISO OUTROS BENEFICIOS RI1
            cTabela := "RI1"//UPPER(ALLTRIM(::aURLParms[2]))
            oStruRI1  := FWFormStruct( 1, cTabela , /* bAvalCampo */, /* lViewUsado */ )
            aFields   := oStruRI1:aFields//oStruTAB:GetStruct():GetFields()
            aCampos := {}
            nX := 0
            For nX := 1 To Len( aFields )
                AADD(aCampos,{aFields[nX,3],aFields[nX,4],aFields[nX,14]})
            Next nX

            //PESQUISO OUTROS BENEFICIOS RI1
            RI1->( DBSETORDER(1) )//::aURLParms[2] RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR
            IF RI1->( DBSEEK( xFilial(cTabela) + cSeek ) ) //.AND. lRet] RI1_FILIAL+RI1_MAT+RI1_BENEF+RI1_TABELA+DTOS(RI1_DINIPG)+DTOS(RI1_DFIMPG)
                oCampo['OUTROS']   := {}
                nLinha := 0
                WHILE !RI1->( EOF() ) .AND. RI1->RI1_MAT == cSeek
                    AADD( oCampo['OUTROS'], JsonObject():New() )

                    nLinha += 1
                 
                    nX := 0

                    FOR nX := 1 to len(aCampos)
                        IF !aCampos[nX,3]
                            IF aCampos[nX,2]=="C"
                                oCampo['OUTROS'][nLinha][aCampos[nX,1]] :=  EncodeUTF8(RI1->&(aCampos[nX,1]),"cp1252")
                            ELSEIF aCampos[nX,2]=="D"
                                oCampo['OUTROS'][nLinha][aCampos[nX,1]] :=  DTOS(RI1->&(aCampos[nX,1]))
                            ELSEIF aCampos[nX,2]=="N"
                                oCampo['OUTROS'][nLinha][aCampos[nX,1]] :=  RI1->&(aCampos[nX,1])
                            ENDIF
                        ENDIF
                    NEXT nX
                    RI1->( DBSKIP() )
                ENDDO

            RI1->(DBCLOSEAREA())
            ELSE
                lOb := .F.
            ENDIF
            ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
        ENDIF

        IF !lBen .and. !lOb
            lRet:= .F.
            oResponse['code'] := 2
            oResponse['status'] := 404
            oResponse['message'] := 'Não foi encontrado plano de saúde, odontologico ou outros beneficios para esse funcionário!'
            oResponse['detailedMessage'] := ''
        ENDIF

        If !lRet
            SetRestFault( oResponse['code'],;
                oResponse['message'],;
                .T.,;
                oResponse['status'],;
                oResponse['detailedMessage'];
                )
        EndIf
    ENDIF

    RpcClearEnv()
RETURN lRet


STATIC FUNCTION MyOpenSM0()
    LOCAL lOpen := .F.
    LOCAL i := 0

    IF !EMPTY(  SELECT('SM0'))
        lOpen := .T.
    ELSE

        FOR i := 1 TO 20
            dbUseArea(  .T., , 'SIGAMAT.EMP',   'SMO',  .T.,    .F.)
            IF !EMPTY(  SELECT('SM0'))
                lOpen := .T.
                dbSetIndex('SIGAMAT.IND')
                EXIT
            ENDIF
            Sleep(500)
        NEXT
    ENDIF
RETURN lOpen
