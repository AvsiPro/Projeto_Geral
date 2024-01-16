#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"
#Include "rwmake.ch"
#Include "tbiconn.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*
    API
    Api de criação, alteração e exclusão de Vales - VT VR e VA
    Doc Mit   
    
*/

WSRESTFUL JWSBEN01 DESCRIPTION "EVENTO para manutneção vales VT VR e VA" //GPEA133

    //GPEA133 atualização de vale  tabela SM7 https://tdn.totvs.com/display/public/PROT/17693922+DRHROTPRT-11655+DT+Ajuste+preValid+modelo+GPEA133

    WSMETHOD POST DESCRIPTION "Manutenção de Vales - VT VR e VA"               WSSYNTAX "/JWSBEN01/{1 altera inclui 2 daleta}" //GPEA133

ENDWSRESTFUL

WsMethod POST WsReceive RECEIVE WsService JWSBEN01

    LOCAL lRet := .T.
    LOCAL lFilok := .F.
    LOCAL xConteudo := "" //conteudo
    LOCAL oResponse     := JsonObject():New()
    LOCAL oContra
    LOCAL n  := 0
    LOCAL nI := 0
    LOCAL nC := 0
    LOCAL nR := 0
    LOCAL cTpcpo := "" //tipo de campo
    LOCAL cCampo := ""
    LOCAL aFunci := {}
    PRIVATE cOperacao :=   "" //ALTERAR
    PRIVATE aSra := {}
    PRIVATE cErro := ""
    PRIVATE aErroRet := {}
    PRIVATE cEmpf := "" //esmpresa do cadastro
    PRIVATE cMatric := "" //matricula
    PRIVATE cTpBen  := ""
    PRIVATE cCodBen := ""

    RpcClearEnv()
    RpcSetType(3)
    RPCSetEnv('01','00020087')

    Self:SetContentType("application/json")

    oContra := JsonObject():New()

    cError := oContra:fromJson( self:getContent() )
    lOk := .F.

    If Empty(cError) .and. valtype(oContra["BENEFICIO"]) == "A" .and.  LEN(self:aURLParms) > 0
        cOperacao :=   ALLTRIM(::aURLParms[1]) //== "1" //ALTERAR
        If valtype(oContra["BENEFICIO"]) == "A"
            aFunci:= oContra:GetJSonObject('BENEFICIO')
            For nI := 1 to len(aFunci)
                IF nI == 1
                    IF !EMPTY(alltrim(oContra["BENEFICIO"][nI]["EMPRESA"])) .OR. alltrim(oContra["BENEFICIO"][nI]['EMPRESA']) != NIL
                        cEmpf := alltrim(oContra["BENEFICIO"][nI]["EMPRESA"])
                        //valido sigamat
                        MyOpenSM0()
                        SM0->( DBGOTOP() )
                        WHILE !SM0->( EOF() ) .AND. !lFilok
                            IF padl(cEmpf,8,"0") == ALLTRIM(SM0->M0_CODFIL)
                                cFilant := ALLTRIM(SM0->M0_CODFIL)
                                lFilok := .T.
                            ENDIF
                            SM0->( DBSKIP() )
                        ENDDO

                        IF !lFilok
                            lRet := .F.
                            oResponse['code'] := 2
                            oResponse['status'] := 404
                            oResponse['message'] := 'Confira a empresa digitada.'
                            oResponse['detailedMessage'] := ''
                        ENDIF
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 3
                        oResponse['status'] := 404
                        oResponse['message'] := 'Confira se a Empresa foi informada.'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ENDIF
                //valida funcinario na empresa e se não está demitido
                IF lRet
                    IF !EMPTY(alltrim(oContra["BENEFICIO"][nI]['MATRICULA'])) .OR. alltrim(oContra["BENEFICIO"][nI]['MATRICULA']) != NIL
                        cMatric := alltrim(oContra["BENEFICIO"][nI]['MATRICULA'])
                        cMatric :=  NewCGCCPF(cMatric)
                        IF LEN(cMatric) == 11 //CNPJ
                            cSeek := PADR(STRZERO( VAL(cMatric),11), TAMSX3('RA_CIC') [1]) //RA_FILIAL+RA_CIC 5
                            nInd := 5
                        ELSEIF LEN(ALLTRIM(cMatric)) == 6 //MATRICULA
                            cSeek := PADR(STRZERO( VAL(cMatric),6), TAMSX3('RA_MAT') [1]) //RA_FILIAL+RA_MAT+RA_NOME 1
                            nInd := 1
                        ELSE
                            lRet := .F.
                            oResponse['code'] := 3
                            oResponse['status'] := 404
                            oResponse['message'] := 'Parametro não tem a quantidade de caracteres esperada. Matricula com 6 ou CPF com 11.'
                            oResponse['detailedMessage'] := ''
                        ENDIF

                        SRA->( DBSETORDER(nInd) )//::aURLParms[2]
                        IF SRA->( DBSEEK( xFilial('SRA') + cSeek ) )
                            cMatric := SRA->RA_MAT
                        ELSE
                            lRet := .F.
                            oResponse['code'] := 4
                            oResponse['status'] := 403
                            oResponse['message'] := 'Matricula não encontrada'
                            oResponse['detailedMessage'] := ''
                        ENDIF

                    ELSE
                        lRet := .F.
                        oResponse['code'] := 5
                        oResponse['status'] := 404
                        oResponse['message'] := 'Matricula não foi informada'
                        oResponse['detailedMessage'] := ''
                    ENDIF

                    //valida codigo do benficio e tipo
                    IF !EMPTY(alltrim(oContra["BENEFICIO"][nI]['TIPO_BENEFICIO'])) .OR. alltrim(oContra["BENEFICIO"][nI]['TIPO_BENEFICIO']) != NIL

                        cTpBen := alltrim(oContra["BENEFICIO"][nI]['TIPO_BENEFICIO'])

                        IF !cTpBen $ ("0,1,2")
                            lRet := .F.
                            oResponse['code'] := 6
                            oResponse['status'] := 404
                            oResponse['message'] := 'Informe 0 para VT, 1 para refeição e 2 para alimentação.'
                            oResponse['detailedMessage'] := ''
                        ENDIF
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 7
                        oResponse['status'] := 404
                        oResponse['message'] := 'Informe o tipo de beneficio TIPO_BENEFICIO'
                        oResponse['detailedMessage'] := ''
                    ENDIF

                    IF !EMPTY(alltrim(oContra["BENEFICIO"][nI]['COD_BENEFICIO'])) .OR. alltrim(oContra["BENEFICIO"][nI]['COD_BENEFICIO']) != NIL
                        cCodBen := alltrim(oContra["BENEFICIO"][nI]['COD_BENEFICIO'])
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 8
                        oResponse['status'] := 404
                        oResponse['message'] := 'Informe o codigo do beneficio COD_BENEFICIO'
                        oResponse['detailedMessage'] := ''
                    ENDIF

                    IF lRet
                        IF cOperacao == "1"
                            IF valtype(oContra["BENEFICIO"][nI]['CAMPOS']) == "A"
                                //procura campo na SRA, pega tipo de campo.
                                nC := 0
                                For nC := 1 to len(oContra["BENEFICIO"][nI]['CAMPOS'])
                                    cCampo := ALLTRIM(oContra["BENEFICIO"][1]['CAMPOS'][nC]["CAMPO"])
                                    xConteudo := ALLTRIM(oContra["BENEFICIO"][1]['CAMPOS'][nC]["CONTEUDO"])
                                    CAMPO := ""

                                    SX3->( DBSETORDER(1) )
                                    SX3->( DBSEEK( 'SM7' ) )
                                    WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'SM7' .AND. EMPTY(CAMPO)
                                        //valida tipo de campo e conteudo informado
                                        aAux := {}
                                        IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V'
                                            IF alltrim(cCampo) ==  ALLTRIM(SX3->X3_CAMPO)
                                                CAMPO := ALLTRIM( SX3->X3_CAMPO)

                                                //CONVERTER PARA CARACTER
                                                cTpcpo := SX3->X3_TIPO
                                                IF cTpcpo == 'N'
                                                    xConteudo := Val(StrTran(strtran(xConteudo,"."),",","."))
                                                ELSEIF cTpcpo == 'D'
                                                    xConteudo := STOD(xConteudo)
                                                ENDIF
                                                aAux := {CAMPO,xConteudo}
                                                aadd(aSra,aAux)
                                            ENDIF
                                        ENDIF
                                        //CAMPO := ALLTRIM( SX3->X3_CAMPO)
                                        SX3->( DBSKIP() )
                                    ENDDO
                                NEXT nC
                            ENDIF
                        ENDIF

                        IF MYGPEA133()
                            oResponse['data']   := {}
                            AADD( oResponse['data'], JsonObject():New() )

                            IF cOperacao == "2"
                                oResponse['data'][1]['satus'] := "DELETADO MATRICULA " + cMatric +" CODIGO DO BENEFICIO "+cCodBen
                            ELSE
                                oResponse['data'][1]['satus'] := "Registro atualizado com sucesso, matricula " + cMatric +" codigo do bem "+ cCodBen

                                FOR nR := 1 to len(aSra)

                                    oResponse['data'][1][aSra[nR,1]] := aSra[nR,2]

                                NEXT nR
                            ENDIF

                            ConOut("retornou ok")
                            ::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
                        ELSE
                            IF LEN(aErroRet) > 0

                                lRet := .F.
                                oResponse['code'] := 15
                                oResponse['status'] := 404

                                n := 0
                                FOR n := 1 to len(aErroRet)
                                    IF n == 1
                                        cErro := aErroRet[n] + CHR(13)+CHR(10)
                                    ENDIF
                                    cErro +=  IF(!aErroRet[n] == NIL,aErroRet[n]+ CHR(13)+CHR(10),"")
                                NEXT n

                                oResponse['message'] := EncodeUTF8(cErro,"cp1252")
                                oResponse['detailedMessage'] := ''

                            ELSE
                                lRet := .F.
                                oResponse['code'] := 8
                                oResponse['status'] := 404
                                oResponse['message'] := 'Informe o codigo do beneficio COD_BENEFICIO'
                                oResponse['detailedMessage'] := ''
                            ENDIF
                        ENDIF
                    ENDIF
                ENDIF
            NEXT nC
        ENDIF
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

//----------------------------------------------------------
// Funcao Auxiliar para retirar a máscara do campo CNPJ/CPF:
//----------------------------------------------------------
Static Function NewCGCCPF(cCGCCPF)

    LOCAL aInvChar := {"/",".","-"}
    LOCAL nI

    For nI:=1 to Len(aInvChar)
        cCGCCPF := StrTran(cCGCCPF,aInvChar[nI])
    Next

Return cCGCCPF

STATIC FUNCTION MYGPEA133()
    Local oModel
    Local oSubMdl
    Local n := 0
    Local cModel := ""
    LOCAL lSra := .F.

    dbSelectArea("SRA")
    dbSetOrder(1)
    If SRA->(MsSeek(xFilial() + cMatric))

        CONOUT("Inicio: "+TIME())
        oModel := FWLoadModel("GPEA133")
        oModel:SetOperation(MODEL_OPERATION_UPDATE)
        oModel:Activate()

        IF cTpBen == "0"
            cModel := "GPEA133_MSM70"
        ELSEIF cTpBen == "1"
            cModel := "GPEA133_MSM71"
        ELSEIF cTpBen == "2"
            cModel := "GPEA133_MSM72"
        ENDIF

        oSubMdl := oModel:GetModel(cModel) //Substituir Id do subModelo utilizado para tabela SM7 conforme necessidade

        /*---nomenclatura conforme as opções do tipo de vale (M7_TPVALE)
            GPEA133_MSM70: Vale Transporte
            GPEA133_MSM71: Vale Refeição
        GPEA133_MSM72: Vale Alimentação ---*/

        dbSelectArea("SM7")
        dbSetOrder(3)
        If !SM7->(DbSeek(xFilial("SM7") + cMatric + cTpBen + cCodBen)) //M7_FILIAL+M7_MAT+M7_TPVALE+M7_CODIGO
            //Para inclusão de nova linha quando já houver dados
            oSubMdl:Addline()   //devido ao uso da operação UPDATE, sem este método, atualizará linha atual
        ENDIF

        IF cOperacao == "1"
            oSubMdl:SetValue("M7_CODIGO", cCodBen )    //-- Código
            FOR n := 1 TO LEN(aSra)
                oSubMdl:SetValue(   aSra[n,1]  ,  aSra[n,2]      )
            NEXT n

            //Para inclusão/alteração informar campos SM7 e respectivos conteúdos
            //        oSubMdl:SetValue("M7_QDIAINF", 2)       //-- Quantidade vales dia útil
            //      oSubMdl:SetValue("M7_CODIGO", "001")    //-- Código

        ELSEIF cOperacao == "2"
            //Para exclusão, posicionar na linha desejada
            oSubMdl:SeekLine({{"M7_CODIGO", cCodBen }})
            oSubMdl:DeleteLine()
        ELSE
            cErro := "Informe 1 para incluir ou alterar e 2 para deletar um ebenficio de VT VR e VA."

        ENDIF

        If oModel:VldData()
            oModel:CommitData()
            lSra := .T.
            ConOut("ok")
        Else
            aErroRet := oModel:GetErrorMessage()
            lSra := .F.
        EndIf

        oModel:DeActivate()
        CONOUT("Fim: "+TIME())
    EndIf

Return lSra

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
