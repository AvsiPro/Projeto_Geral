#include 'protheus.ch'
#include 'parmtype.ch'
#include 'tbiconn.ch'
#Include "TopConn.ch"
#include "fileio.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± ºPrograma ³  PROCTXT  ºAutor³ AVSIPRO Rodrigo Barreto	    º Data Ini³ 20/01/2023       º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± ºDesc.    ³ Processa Rertono CNAB FOLHA e altera o status na ZZ1                           ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± ºUso      ³ ROBSOL  	                                                    		  		  ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

user function PROCTXT()

    Local aArea    := GetArea()
    Local nI,nX := 0
    Local cLinha  := ""
    Local cRetBan,cRetpg := ""
    Local cTitZZ1 := "" //Dados ZZ1
    Local cArqAux := ""
    Local cCgcFun   := "" //cgc funcionário
    Local dDtZZ1
    Local cBanco, cAgencia, cDgAge, cConta, cDgCon, cHistBaixa, cCodFor := "" //dados bancarios baixa
    Local cCgcFil := "" //cnpj para pesquisar filial retorno
    Local aRet := {}
    Local nValor, nValE2  := 0
    Local lPrim   := .T.
    Local aDados  := {}
    Private aVcto   := {}
    Private lMsErroAuto := .F.

    //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0201"

    //Chamando o cGetFile para pegar um arquivo txt ou xml, mostrando o servidor
    cArqAux := cGetFile( 'Arquivo *.RET|*.RET ',; //[ cMascara],
        'Selecao de Arquivos',;                  //[ cTitulo],
        0,;                                      //[ nMascpadrao],
        'C:\',;  	                              //[ cDirinicial],
        .F.,;                                    //[ lSalvar],
        GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes],
        .T.)                                     //[ lArvore]

    If !File(cArqAux)
        MsgStop("O arquivo " +cArqAux + " nÃ£o foi encontrado. A importaÃ§Ã£o serÃ¡ abortada!","ATENCAO")
        Return
    EndIf

    FT_FUSE(cArqAux)
    ProcRegua(FT_FLASTREC())
    FT_FGOTOP()

    While !FT_FEOF()

        IncProc("Lendo arquivo ...")

        cLinha := FT_FREADLN()
        //
        AADD(aDados,cLinha)

        FT_FSKIP()
    EndDo
    lPrim := .T.

    For nI := 1 to Len(aDados)

        If lPrim
            cCgcFil := SUBSTR(aDados[nI],19,14)
            OpenSm0()
            SM0->(dbGoTop())
            While !SM0->(Eof())
                If cCgcFil == alltrim(SM0->M0_CGC)
                    cFilant  :=  alltrim(SM0->M0_CODFIL)
                    // lDeuCerto := .T.
                    lPrim := .F.
                    nI += 1
                    Exit //Forca a saida
                Endif
                SM0->(dbskip())
            EndDO
        EndIf

        If !lPrim
            If SUBSTR(aDados[nI],9,1) == "C"
                //dados banco baixa
                cBanco := SUBSTR(aDados[nI],1,3)
                cAgencia := PADR(SUBSTR(aDados[nI],54,4),5)
                cDgAge := SUBSTR(aDados[nI],58,1)
                nI += 1
                If cFilant == '0103'
                    cConta := PADR("101",10)
                    cDgCon := "5"
                ElseIf cFilant == '0101'
                    cConta := PADR("11",10)
                    cDgCon := "6"
                EndIf
            EndIf
            //Dados ZZ1
            If SUBSTR(aDados[nI],14,1) == "A"
                //PEGAR DADOS PARA FILTRO ZZ1
                cTitZZ1 := SUBSTR(aDados[nI],85,9)
                //data vencimento ZZ1
                dDtZZ1 := CTOD(SUBSTR(aDados[nI],155,2)+"/"+SUBSTR(aDados[nI],157,2)+"/"+SUBSTR(aDados[nI],159,4) )
                //Retorno banco
                cRetBan := SUBSTR(aDados[nI],231,2)
                nValor := VAL(SUBSTR(aDados[nI],163,13) + "." + SUBSTR(aDados[nI],176,2))
                nI += 1


                If SUBSTR(aDados[nI],14,1) == "B"
                    //cgc Funcionário
                    cCgcFun := SUBSTR(aDados[nI],22,11)
                    If SUBSTR(aDados[nI + 1],14,1) == "Z"
                        cRetPg := SUBSTR(aDados[nI + 1],231,2)
                        nI += 1
                    Else
                        cRetpg := "99"
                    EndIf
                EndIf
                //1 banco , 2 agencia , 3 digito agencia , 4 conta , 5 dg conta , 6 titulo zz1 , 7 retorno banco, 8 valor pago, 9 DATA ZZ1,10 cgc funionoario, 11 retorno pagamento
                aadd( aRet ,{cBanco , cAgencia, cDgAge, cConta, cDgCon , cTitZZ1 , cRetBan , nValor, dDtZZ1, cCgcFun, cRetPg})
            EndIf
        EndIf
    Next nI

    If len(aRet) > 0 .and. !empty(cRetPg)

        lPrim := .T.
        DbSelectArea("ZZ1")
        DBSetOrder(1)

        For nX := 1 to len(aRet)
            //ZZ1_FILIAL+ZZ1_PREFIX+ZZ1_NUM+ZZ1_PARCE+ZZ1_TIPO+ZZ1_CGC
            If DbSeek(xFilial("ZZ1")+"FOL"+aRet[nX,6]+"0"+"FOL"+aRet[nX,10])
                If aRet[nX][11] == "00"
                    RecLock("ZZ1", .F.)
                    ZZ1->ZZ1_DTPAG := aRET[nX][9]
                    nValE2 += aRET[nX][8]
                    If lPrim
                        cIdTit := ZZ1->ZZ1_ID
                        lPrim := .F.
                    EndIf
                    MsUnLock()
                Else
                    RecLock("ZZ1", .F.)
                    ZZ1->ZZ1_DTPAG := CTOD('01/01/1990')
                    MsUnLock()
                EndIf
                
            EndIf
        Next nX

        If !lPrim
            cHistBaixa := "BX via retorno cnab de folha: "
            cCodFor := If(cFilant == "0103","FOLHAMG  ","FOLHA    ")
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            //³Monta array com os dados da baixa a pagar do título³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            aBaixa := {}
            AADD(aBaixa, {"E2_FILIAL" , xFilial('SE2') , Nil})
            AADD(aBaixa, {"E2_PREFIXO" , "FOL", Nil})
            AADD(aBaixa, {"E2_NUM" , cIdTit , Nil})
            AADD(aBaixa, {"E2_PARCELA" , "  " , Nil})
            AADD(aBaixa, {"E2_TIPO" , "FOL" , Nil})
            AADD(aBaixa, {"E2_FORNECE" , cCodFor, Nil})
            AADD(aBaixa, {"E2_LOJA" , "0001" , Nil})
            AADD(aBaixa, {"AUTMOTBX" , "NOR" , Nil})
            AADD(aBaixa, {"AUTBANCO" , cBanco , Nil})
            AADD(aBaixa, {"AUTAGENCIA" , cAgencia , Nil})
            AADD(aBaixa, {"AUTCONTA" , cConta , Nil})
            AADD(aBaixa, {"AUTDTBAIXA" , dDtZZ1 , Nil})
            AADD(aBaixa, {"AUTDTCREDITO", dDtZZ1 , Nil})
            AADD(aBaixa, {"AUTHIST" , cHistBaixa , Nil})
            AADD(aBaixa, {"AUTVLRPG" , nValE2 , Nil})

            DbSelectArea("SE2")
            DbSetOrder(1)

            If DbSeek(xFilial("SE2")+"FOL"+cIdTit+"  "+"FOL"+cCodFor+"0001")
                ACESSAPERG("FIN080", .F.)
                MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 3)

                If lMsErroAuto
                    MOSTRAERRO()
                    DisarmTransaction()
                    Alert("Falha nas Baixas do Titulo")
                    Return .F.
                EndIf
            EndIf
        EndIf
        ZZ1->(DBCloseArea())
        RestArea(aArea)
    
    Else
        alerta("Não foram localizados pagamentos no arquivo processado, verifique se existe segmento Z.")
    EndIf
Return
