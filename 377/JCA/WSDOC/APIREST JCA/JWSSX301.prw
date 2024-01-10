#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"

/*/{Protheus.doc} GET
Retorna as consultas de um campo que possui consulta padrão ou combobox.

@param	Page	   , caracter, nome do campo EX: A1_TIPO, RAS_MAT, C6_TES
		PageSize   ,
		token      ,
		type 	   ,

@return cResponse  , caracter, JSON contendo a lista de de consulta desse campo.

/*/

WSRESTFUL JWSSX301 DESCRIPTION "Rest de campos"
    WSMETHOD GET DESCRIPTION "Obtem os dados dos campos na tabela SX3 e retorna sua consulta" WSSYNTAX "/JWSSX301/{CAMPO}"
ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSSX301
    LOCAL lRet := .T.
    LOCAL cTabSX5 := ""
    LOCAL aAux := {}
    LOCAL aAux3 := {}
    LOCAL aBox := {}
    LOCAL  n := 0
    LOCAL nX := 0
    LOCAL nLinha := 0
    LOCAL cCamSRA := "RA_FILIAL,RA_EMAIL,RA_CIC,RA_SITFOLH,RN_DESC,RN_VUNIATU,RA_TPCONTR,CC2_CODMUN"
    LOCAL oResponse     := JsonObject():New()
    LOCAL oCampo     := JsonObject():New()

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

    IF lRet .and. LEN(self:aURLParms) > 0
        cCampo := UPPER(ALLTRIM(::aURLParms[1]))

        SX3->( DBSETORDER(2) )
        IF SX3->( DBSEEK( cCampo ) )
            IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V'
                IF !EMPTY(ALLTRIM(SX3->X3_CBOX))
                    aBox := Separa(ALLTRIM(SX3->X3_CBOX),';',.T.)

                    oCampo['DADOS']   := {} //array(len(aBox))
                    FOR n := 1 to len(aBox)
                        aAux := Separa(ALLTRIM(aBox[n]),'=',.T.)
                        AADD( oCampo['DADOS'], JsonObject():New() )
                        oCampo['DADOS'][n]['codigo']        := aAux[1]
                        oCampo['DADOS'][n]['descri']        := aAux[2]
                    NEXT n

                    ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))

                ELSEIF !EMPTY(ALLTRIM(SX3->X3_F3))
                    //CONSULTA PADRÃO POR TABELA
                    IF LEN(ALLTRIM(SX3->X3_F3)) == 3
                        lX5 = .F.
                        SXB->( DBSETORDER(1) )
                        SXB->( DBSEEK( ALLTRIM(SX3->X3_F3)) )
                        WHILE !SXB->( EOF() ) .AND. ALLTRIM(SXB->XB_ALIAS) == ALLTRIM(SX3->X3_F3)
                            IF SXB->XB_COLUNA == "DB"
                                //pesquisA se a consulta não é SX5
                                IF ALLTRIM(SXB->XB_CONTEM) <> "SX5"
                                    //guarda a tabela e pesquisa os campos na SX3
                                    cAliastab := SUBSTR(ALLTRIM(SXB->XB_CONTEM),1,3)

                                    SX3->( DBSETORDER(1) )
                                    SX3->( DBSEEK( cAliastab ) )
                                    WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == cAliastab
                                        IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V' .AND. X3Obrigat(SX3->X3_CAMPO) .OR. "_MSBLQL" $ alltrim(SX3->X3_CAMPO) .OR. "_FILIAL" $ alltrim(SX3->X3_CAMPO) .OR. alltrim(SX3->X3_CAMPO) $ "("+cCamSRA+")"//(alltrim(SX3->X3_CAMPO) == "RA_FILIAL" .or. alltrim(SX3->X3_CAMPO) == "RA_EMAIL" .or. alltrim(SX3->X3_CAMPO) == "RA_CIC")
                                            aadd(aAux3,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO})
                                        ENDIF
                                        SX3->( DBSKIP() )
                                    ENDDO

                                    // query da tabela completa
                                    cQuery := " SELECT * "
                                    cQuery += "FROM "+ RetSQLName(cAliastab) + " "+cAliastab
                                    cQuery += "WHERE "+ cAliastab +".D_E_L_E_T_=''"

                                    If Select("TMP")<>0
                                        DbSelectArea("TMP")
                                        DbCloseArea()
                                    EndIf

                                    cQuery := ChangeQuery(cQuery)
                                    DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

                                    dbSelectArea("TMP")
                                    TMP->(dbGoTop())

                                    oCampo['DADOS']   := {} //array(len(aBox))

                                    While TMP->(!EOF())

                                        nLinha += 1

                                        AADD( oCampo['DADOS'], JsonObject():New() )

                                        FOR nX := 1 to len(aAux3)
                                            // IF !EMPTY(TMP->&(aAux3[nX,1]))
                                            IF aAux3[nX,2]=="C"
                                                oCampo['DADOS'][nLinha][aAux3[nX,1]] :=  EncodeUTF8(TMP->&(aAux3[nX,1]),"cp1252")

                                                IF "_MSBLQL" $ aAux3[nX,1]  
                                                    IF TMP->&(aAux3[nX,1]) == "1"
                                                        oCampo['DADOS'][nLinha]["BLOQUEADO"] :=  "SIM"
                                                    ELSE
                                                     oCampo['DADOS'][nLinha]["BLOQUEADO"] :=  "NAO"
                                                    ENDIF
                                                ENDIF
                                            ELSEIF aAux3[nX,2]=="D"
                                                oCampo['DADOS'][nLinha][aAux3[nX,1]] :=  TMP->&(aAux3[nX,1])
                                            ELSEIF aAux3[nX,2]=="N"
                                                oCampo['DADOS'][nLinha][aAux3[nX,1]] :=  TMP->&(aAux3[nX,1])
                                            ENDIF
                                            // ENDIF
                                        NEXT nX
                                        TMP->( DBSKIP() )
                                    ENDDO
                                    ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
                                ELSE
                                    lX5 = .T.
                                ENDIF
                            ELSEIF SXB->XB_COLUNA == "RE"
                                lRet:= .F.
                                oResponse['code'] := 4
                                oResponse['status'] := 411
                                oResponse['message'] := 'Esse campo possui uma consulta especifica.'
                                oResponse['detailedMessage'] := ''
                            ENDIF
                            IF lX5 .AND. SXB->XB_TIPO == "6"
                                cTabSX5 := ALLTRIM(SXB->XB_CONTEM)
                                //                                oCampo['DADOS']   := {} //array(len(aBox))

                                /*                               SX3->( DBSETORDER(1) )
                                SX3->( DBSEEK( 'SX5' ) )
                                WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == "SX5"
                                    aadd(aAux3,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO})
                                    SX3->( DBSKIP() )
                                ENDDO
                                */
                                aDadosSX5 := {}
                                aDadosSX5 := FWGetSX5(cTabSX5)
                                //aDadosSX5 := FWGetSX5("01")
                                IF LEN(aDadosSX5) > 0
                                    oCampo['DADOS']   := {} //array(len(aBox))

                                    nX := 0
                                    For nX:=1 To Len(aDadosSX5)
                                        AADD( oCampo['DADOS'], JsonObject():New() )
                                        //Obtém a filial(X5_FILIAL)
                                        cFil := aDadosSX5[nX][1]
                                        oCampo['DADOS'][nX]["FILIAL"] :=  EncodeUTF8(cFil,"cp1252")
                                        //Obtém a tabela(X5_TABELA)
                                        cTab := aDadosSX5[nX][2]
                                        oCampo['DADOS'][nX]["TABELA"] :=  EncodeUTF8(cTab,"cp1252")
                                        //Obtém a chave(X5_CHAVE)
                                        cChave := aDadosSX5[nX][3]
                                        oCampo['DADOS'][nX]["CHAVE"] :=  EncodeUTF8(cChave,"cp1252")
                                        //Obtém a descrição(X5_DESCRI)
                                        cDesc := aDadosSX5[nX][4]
                                        oCampo['DADOS'][nX]["DESCRICAO"] :=  EncodeUTF8(cDesc,"cp1252")
                                        //Exibe no console.log
                                        //ConOut("SX5->X5_FILIAL:'" + cFil + "', SX5->X5_TABELA:'" + cTab + "', SX5->X5_CHAVE:'" + cChave + "' , SX5->X5_DESCRI:'" + cDesc + "'")
                                    Next nX
                                    ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
                                ELSE
                                    lRet:= .F.
                                    oResponse['code'] := 15
                                    oResponse['status'] := 404
                                    oResponse['message'] := 'TABELA NÃO  LOCALIZADA NA SX5.'
                                    oResponse['detailedMessage'] := ''
                                ENDIF
                            ENDIF
                            SXB->( DBSKIP() )
                        ENDDO
                        //CONSULTA SX5
                    ELSEIF LEN(ALLTRIM(SX3->X3_F3)) == 2
                        //GUARDAR CONTEUDO DA F3_
                        cTabSX5 := ALLTRIM(SX3->X3_F3)
                        oCampo['DADOS']   := {} //array(len(aBox))

                        SX3->( DBSETORDER(1) )
                        SX3->( DBSEEK( 'SX5' ) )
                        WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == "SX5"
                            aadd(aAux3,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO})
                            SX3->( DBSKIP() )
                        ENDDO

                        SX5->( DBSETORDER(1) )
                        SX5->( DBSEEK( xFilial('SX5')+ALLTRIM(cTabSX5)) )
                        WHILE !SX5->( EOF() ) .AND. ALLTRIM(SX5->X5_TABELA) == ALLTRIM(cTabSX5)
                            nLinha += 1

                            AADD( oCampo['DADOS'], JsonObject():New() )
                            FOR nX := 1 to len(aAux3)

                                IF aAux3[nX,2]=="C"
                                    oCampo['DADOS'][nLinha][aAux3[nX,1]] :=  EncodeUTF8(SX5->&(aAux3[nX,1]),"cp1252")
                                ELSEIF aAux3[nX,2]=="D"
                                    oCampo['DADOS'][nLinha][aAux3[nX,1]] :=  SX5->&(aAux3[nX,1])
                                ELSEIF aAux3[nX,2]=="N"
                                    oCampo['DADOS'][nLinha][aAux3[nX,1]] :=  SX5->&(aAux3[nX,1])
                                ENDIF

                            NEXT nX
                            SX5->( DBSKIP() )
                        ENDDO
                        ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))

                    ELSEIF LEN(ALLTRIM(SX3->X3_F3)) == 6

                        cTabSX5 := ALLTRIM(SX3->X3_F3)
                        //oCampo['DADOS']   := {} //array(len(aBox))
                        lX5 = .F.
                        SXB->( DBSETORDER(1) )
                        SXB->( DBSEEK( ALLTRIM(cTabSX5)) )
                        WHILE !SXB->( EOF() ) .AND. ALLTRIM(SXB->XB_ALIAS) == ALLTRIM(cTabSX5)
                            IF SXB->XB_COLUNA == "DB"
                                cConsEsp :=  SUBSTR(ALLTRIM(SXB->XB_CONTEM),1,3)
                            ENDIF
                            SXB->( DBSKIP() )
                        ENDDO

                        SX3->( DBSETORDER(1) )
                        SX3->( DBSEEK( cConsEsp ) )
                        WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == cConsEsp
                            IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V' .AND. X3Obrigat(SX3->X3_CAMPO) .OR. "_MSBLQL" $ alltrim(SX3->X3_CAMPO) .OR. "_FILIAL" $ alltrim(SX3->X3_CAMPO) .OR. alltrim(SX3->X3_CAMPO) $ "("+cCamSRA+")"//(alltrim(SX3->X3_CAMPO) == "RA_FILIAL" .or. alltrim(SX3->X3_CAMPO) == "RA_EMAIL" .or. alltrim(SX3->X3_CAMPO) == "RA_CIC")
                                aadd(aAux3,{ALLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO})
                            ENDIF
                            SX3->( DBSKIP() )
                        ENDDO

                        // query da tabela completa
                        cQuery := " SELECT * "
                        cQuery += "FROM "+ RetSQLName(cConsEsp) + " "+cConsEsp
                        cQuery += "WHERE "+ cConsEsp +".D_E_L_E_T_=''"

                        If Select("TMP")<>0
                            DbSelectArea("TMP")
                            DbCloseArea()
                        EndIf

                        cQuery := ChangeQuery(cQuery)
                        DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

                        dbSelectArea("TMP")
                        TMP->(dbGoTop())

                        oCampo['DADOS']   := {} //array(len(aBox))

                        While TMP->(!EOF())

                            nLinha += 1

                            AADD( oCampo['DADOS'], JsonObject():New() )

                            FOR nX := 1 to len(aAux3)
                                // IF !EMPTY(TMP->&(aAux3[nX,1]))
                                IF aAux3[nX,2]=="C"
                                    oCampo['DADOS'][nLinha][aAux3[nX,1]] :=  EncodeUTF8(TMP->&(aAux3[nX,1]),"cp1252")

                                    IF "_MSBLQL" $ aAux3[nX,1]
                                        IF TMP->&(aAux3[nX,1]) == "1"
                                            oCampo['DADOS'][nLinha]["BLOQUEADO"] :=  "SIM"
                                        ELSE
                                            oCampo['DADOS'][nLinha]["BLOQUEADO"] :=  "NAO"
                                        ENDIF
                                    ENDIF
                                ELSEIF aAux3[nX,2]=="D"
                                    oCampo['DADOS'][nLinha][aAux3[nX,1]] :=  TMP->&(aAux3[nX,1])
                                ELSEIF aAux3[nX,2]=="N"
                                    oCampo['DADOS'][nLinha][aAux3[nX,1]] :=  TMP->&(aAux3[nX,1])
                                ENDIF
                                // ENDIF
                            NEXT nX
                            TMP->( DBSKIP() )
                        ENDDO
                        ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
                    ELSE
                        lRet:= .F.
                        oResponse['code'] := 4
                        oResponse['status'] := 412
                        oResponse['message'] := 'Esse campo possui uma consulta especifica.'
                        oResponse['detailedMessage'] := ''
                    ENDIF

                ELSE
                    lRet:= .F.
                    oResponse['code'] := 4
                    oResponse['status'] := 413
                    oResponse['message'] := 'Esse campo não possui consulta consulta.'
                    oResponse['detailedMessage'] := ''
                ENDIF
            ELSE
                lRet:= .F.
                oResponse['code'] := 4
                oResponse['status'] := 404
                oResponse['message'] := 'Campo virtual ou não utilizado.'
                oResponse['detailedMessage'] := ''
            ENDIF
        ELSE
            lRet:= .F.
            oResponse['code'] := 3
            oResponse['status'] := 404
            oResponse['message'] := 'Campo não localizado!'
            oResponse['detailedMessage'] := ''
        ENDIF
        //::SetResponse(FWJsonSerialize(aCampos, .F., .T.))
    ELSE
        lRet:= .F.
        oResponse['code'] := 2
        oResponse['status'] := 404
        oResponse['message'] := 'Informe um campo para pesquisa. EX: A1_COD , C6_TES'
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
