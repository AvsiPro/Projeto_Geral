#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#Include 'TopConn.ch'
#include 'tbiconn.ch'
#Include 'totvs.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ROBEST04         ³ Autor ³: Rodrigo Barreto Data ³ 27/08/2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³   IMpressão de Etiquetas Caixa Projeto Oticas              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ROBEST04(lDnfB)
    
    Local aItens := {}

    Private aEtiqueta := {}
    Private aParamBox := {}
    Private cTpFrete  := ''
    Private cPedido   := ''
    Private Imprime   := IMP_SPOOL
    Private lFator    := .F.

    Default lDnfB     := .F.

    IF Select("SM0") == 0
        RpcSetType(3)
        RPCSetEnv("01","0101")
        Imprime := IMP_PDF
    ENDIF

    IF !lDnfB
        IF ValidPerg()
            //MV_PAR01 := '000001101'
            //MV_PAR02 := '000001101'
            //MV_PAR03 := '1'
            Processa({|| aItens := buscanf()},"Aguarde, buscando Notas")
            IF len(aItens) < 1 // == .F.
                RETURN
            ENDIF
            IF len(aItens) > 0
                Processa({|| ImpEtiq(aItens)},"Impressao de etiqueta","Aguarde...")
            ENDIF
        ENDIF
    ELSE
        Processa({|| aItens := buscanf()},"Aguarde, buscando Notas")
        IF len(aItens) > 0
                Processa({|| ImpEtiq(aItens)},"Impressao de etiqueta","Aguarde...")
        ENDIF
    ENDIF 
   
Return

/*/{Protheus.doc} buscanf()
    (long_description)
    @type  Static Function
    @author user
    @since 17/01/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function buscanf()

Local aRet := {}
Local cQuery 
Local nCont
Local nX 
Local lTpFret := .F.
Local aMedidas := {}

cQuery := " SELECT SF2.R_E_C_N_O_ AS REGF2,C5_XETIQUE,C5_PESOL,"
cQuery += " C5_VOLUME1,SC5.R_E_C_N_O_ AS REGC5,F2_DOC, C5_XOBS002,"
cQuery += " C5_NUM,F2_SERIE,C5_TRANSP"
cQuery += " FROM "+RetSQLName("SF2")+" SF2 "
cQuery += " INNER JOIN "+RetSQLName("SC5")+" SC5 
cQuery += " ON C5_FILIAL = F2_FILIAL
cQuery += " AND C5_CLIENTE = F2_CLIENTE
cQuery += " AND C5_LOJACLI = F2_LOJA
cQuery += " AND C5_NOTA = F2_DOC
cQuery += " AND C5_SERIE = F2_SERIE
cQuery += " AND C5_CONDPAG = F2_COND
cQuery += " AND C5_TIPOCLI = F2_TIPOCLI
//cQuery += " AND C5_XETIQUE != ' '
cQuery += " AND SC5.D_E_L_E_T_= ' '
cQuery += " WHERE F2_DOC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND F2_SERIE='"+MV_PAR03+"'"
//cQuery += " AND SF2.D_E_L_E_T_=' ' AND F2_CHVNFE<>' '"
cQuery += " AND F2_FILIAL='"+xFilial("SF2")+"'"
IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

WHILE !EOF()
    cPedido := TRB->C5_NUM

    Aadd(aRet,{ TRB->REGF2,;
                strtokarr(TRB->C5_XETIQUE,','),;
                TRB->C5_VOLUME1,;
                TRB->REGC5,;
                TRB->F2_DOC,;
                TRB->C5_PESOL,;
                TRB->C5_XOBS002,;
                TRB->F2_SERIE,;
                AllTrim(TRB->C5_TRANSP)})
    Dbskip()
ENDDO

FOR nCont := 1 TO len(aRet)

        cTpAux   := Upper(aRet[nCont,7])
        nPosIni  := At("<TPFRETE>",  cTpAux) + Len('<TPFRETE>')
        nPosFim  := At("</TPFRETE>", cTpAux)
        nLeitura := nPosFim - nPosIni

        IF At("<TPFRETE>",  cTpAux) == 0
            cTpFrete := '03220'
            lTpFret := .T.
        ELSE
            cTpFrete := SubStr(cTpAux, nPosIni, nLeitura)
        ENDIF

        DbSelectArea("SC5")
        SC5->(DbGoto(aRet[nCont,04]))

        DbSelectArea("Z51")
        Z51->(DbSetOrder(1))
        IF Z51->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
            Aadd(aMedidas, Z51->Z51_ALTURA)
            Aadd(aMedidas, Z51->Z51_LARGUR)
            Aadd(aMedidas, Z51->Z51_COMPRI)

            Reclock("Z51",.F.)
            Z51->Z51_NOTA   := aRet[nCont,05]
            Z51->Z51_SERIE  := aRet[nCont,08]
            Z51->(MsUnlock())
        ENDIF

        aEtiqueta := {}

        IF len(aMedidas) > 0
            Processa({|| aEtiqueta := U_ROBWS04(aRet[nCont,03], aRet[nCont,01], aRet[nCont,06], cTpFrete, aMedidas )},"Aguarde..."+CRLF+"Gerando Etiqueta")
            IF len(aEtiqueta) < 1 // == .F.
                MsgAlert("N�o foi poss�vel gerar as etiquetas, falta de retorno do correio")
                RETURN({})
            ENDIF
        ENDIF
        cVirg := ''
        cEtiqueta := ''
        
        Aadd(aRet[nCont], {})

        IF Len(aEtiqueta) > 0

            FOR nX := 1 TO Len(aEtiqueta)
                cEtiqueta += cVirg+aEtiqueta[nX,1]
                cVirg := ','

                Aadd(aRet[nCont,len(aRet[nCont])], aEtiqueta[nX,2])
            NEXT nX

            RecLock("SC5", .F.)

            SC5->C5_XETIQUE := cEtiqueta

            IF lTpFret
                SC5->C5_XOBS002 := ' <TpFrete>'+cTpFrete+'</TpFrete>' //grava como sedex
            ENDIF

            MsUnlock()

            aRet[nCont,02] := strtokarr(cEtiqueta,',')
            
        ELSE
            MsgAlert('Nao foi possivel gerar a etiqueta para a nota '+aRet[nCont,05], 'ROBFAT01')
        ENDIF
NEXT nCont

Return(aRet)

/*
    IMPRIME
*/
Static Function ImpEtiq(aItens)

    Local cImpress         := 'ZDesigner ZT230-300dpi ZPL' //Alltrim(MV_PAR04) //pego o nome da impressora

    // Local cSedex        := "\system\img\"+Iif(cTpFrete == '03220','expressa','pac')+".bmp"
    Local cSimCor          := "\system\img\correio.bmp"
    // Local cSimBras         := "\system\img\braspress-logo2.bmp"
    Local cRobsol          := "\system\img\robsol.bmp"
    Local lAdjustToLegacy  := .F.
    Local lDisableSetup    := .T.
    Local nLin             := 0
    Local nCol             := 0
    Local nR
    Local nX
    Local nZ
    Local aCont            :=  strtokarr(SuperGetMV("TI_CONTCOR",.F.,"9912446282/0074256874"),'/')
    Local cCorrCont        := aCont[1]
    Local cEndE            := ""
    Local cBairroE         := ""
    Local cCepE            := ""
    Local cMunE            := ""
    Local cEstE            := ""
    Local lTransp
    Local nPosIni          := 0
    Local nPosFim          := 0
    Local nLeitura         := 0
    Local lTpFret          := .F.

	//Fontes
	Local oF5FFF          := TFont():New('Arial' /*Fonte*/,,5 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF5TFF          := TFont():New('Arial' /*Fonte*/,,5 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF5FTF          := TFont():New('Arial' /*Fonte*/,,5 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF5FFT          := TFont():New('Arial' /*Fonte*/,,5 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF8FFF          := TFont():New('Arial' /*Fonte*/,,8 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF8TFF          := TFont():New('Arial' /*Fonte*/,,8 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF8FTF          := TFont():New('Arial' /*Fonte*/,,8 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF8FFT          := TFont():New('Arial' /*Fonte*/,,8 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF10FFF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10TFF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10FTF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10FFT          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF12FFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12TFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12FTF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12FFT          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF13FFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF13TFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF13FTF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF13FFT          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF15FFF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF15TFF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF15FTF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF15FFT          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF20FFF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF20TFF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF20FTF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF20FFT          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF25FFF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF25TFF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF25FTF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF25FFT          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )

    Private oPrinter       := NIL                 

    nEtiq := 1
    FOR nZ := 1 TO len(aItens)

        nPosIni  := At("<TPFRETE>",  Upper(aItens[nZ,7])) + Len('<TPFRETE>')
        nPosFim  := At("</TPFRETE>", Upper(aItens[nZ,7]))
        nLeitura := nPosFim - nPosIni

        IF At("<TPFRETE>",  Upper(aItens[nZ,7])) == 0
            cTpFrete := '03220'
            lTpFret := .T.
        ELSE
            cTpFrete := SubStr(Upper(aItens[nZ,7]), nPosIni, nLeitura)
        ENDIF

        FOR nR := 1 TO len(aItens[nZ,2])

            if aItens[nZ,9] $ 'T1/T16'
                lTransp := .T.
            else
                lTransp := .F.
            endif

            DbSelectArea('SF2')
            DbGotop()
            DbGoto(aItens[nZ,1])
            DbSelectArea("SA1")
            DbSetOrder(1)
            
            SA1->(DbSeek(xFilial('SA1')+SF2->(F2_CLIENTE+F2_LOJA)))
            
            oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",Imprime,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
            // oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_PDF,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
            
            oPrinter:StartPage()
            oPrinter:SetMargin(000,000,000,000)
            oPrinter:SetPaperSize(0,IF(lFator,100*2,100),IF(lFator,150*2,150))

            // oPrinter:Box(0,0,700,600,"-6")
            // oPrinter:Box(0,0,600,500,"-6")
            // oPrinter:Box(0,0,575,475,"-6")
            // oPrinter:Box(0,0,550,450,"-6")
            // oPrinter:Box(0,0,525,425,"-6")
            // oPrinter:Box(0,0,500,400,"-6")
            // oPrinter:Box(0,0,475,375,"-6")
            // oPrinter:Box(0,0,450,350,"-6")
            // oPrinter:Box(0,0,425,325,"-6")
            // oPrinter:Box(0,0,400,300,"-6")
            // oPrinter:Box(0,0,375,275,"-6")
            // oPrinter:Box(0,0,350,250,"-6")
            // oPrinter:Box(0,0,325,225,"-6")
            // oPrinter:Box(0,0,300,200,"-6")

            //Linha: 425
            //Coluna: 275

            // oPrinter:Box(0,0,425,275,"-6")

            // IF nEtiq > 4 //.Or. Mod(nZ,4) == 4 Mod(nR,4)
            //     //oPrinter:EndPage()
            //     nEtiq := 1

            // ENDIF

            // ************  SUPERIOR  ***********************//
            // oBrush1 := TBrush():New( , CLR_HRED)
            
           // cCepAux := strtokarr(SA1->A1_CEP,'')
            nValidador := 0

            FOR nX := 1 TO Len(SA1->A1_CEP)
                cCepAux    := SubsTr(SA1->A1_CEP,nX,1)
                nValidador += Val(cCepAux)
            NEXT nX

            cValid  := Val(SubsTr(cValToChar(nValidador+10),1,1)+'0')-nValidador
            if len(strtokarr(Alltrim(SA1->A1_END),',')) < 2
                MsgAlert("Cadastro no formato incorreto! Nota: " + SF2->F2_DOC, "Erro!")
                Return
            endif
            cNumEnd := strtokarr(Alltrim(SA1->A1_END),',')[2]
            cTel    := StrTran(Alltrim(SA1->A1_DDD)+Alltrim(SA1->A1_TEL),'-','')
            cCodigo := ''

            IF len(aItens[nZ,2]) >= 1 .AND. len(aItens[nZ,10]) >= 1
                cCodigo := SA1->A1_CEP+;        //cep destino
                    '00000'+;                   //complemento cep
                    SM0->M0_CEPENT+;            //cep remetente
                    '00000'+;                   // complemento cep
                    cValToChar(cValid)+;        //validador cep destino
                    '51'+;                      //IDV
                    aItens[nZ,2,nR]+;           //cod rastreamento
                    '00'+;                      //Servi�os Adicionais (AR, MP, DD, VD) 
                    aCont[2]+;                  //cartao postagem
                    cTpFrete+;                   //codigo do servico
                    aItens[nZ,10,nR]+;           //Informa��o de Agrupamento
                    cNumEnd+;                   //numero do logradouro
                    Alltrim(SA1->A1_COMPENT)+;  //complemento
                    '0'+;                       //valor declarado
                    cTel+;                      //DDD + Telefone Destinat�rio
                    '-00.000000'+;              //latitude
                    '-00.000000'+;              //logitude
                    '|'+;                       //pipe
                    ''                          //reserva para cliente
            ENDIF 

            nLin := 10 
            nCol := 23

            nCl1 := 10
            nCl2 := 290 
            
            nLl1 := 140
            nLl2 := 155

            // oPrinter:Fillrect( {nLl1,nCl1,nLl2,nCl2}, oBrush1, "-2")  
            //oPrinter:SayBitmap(nLin ,IF(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol,nCol+300) ,cLogo,70,030) 
            if lTransp
                // oPrinter:Say(nLin+15,nCol+030,"BRASPRESS",oF15FFF)
                oPrinter:Say(IF(lFator,nLin+15*2,nLin+15),IF(lFator,nCol+120,nCol+30),"BRASPRESS",IF(lFator,oF20FFF,oF15FFF))
                // oPrinter:SayBitmap(nLin-5,nCol+045,cSimBras,50,20) 
            else
                // oPrinter:SayBitmap(nLin-5,nCol+045,cSimCor,50,20)
                oPrinter:SayBitmap(IF(lFator,nLin+7,nLin-5),IF(lFator,nCol+45*2.5,nCol+045),cSimCor,IF(lFator,50*2,50),IF(lFator,20*2,20))
            endif
            
            oPrinter:SayBitmap(IF(lFator,nLin+170*2,nLin+220),IF(lFator,nCol+90*2,nCol+115),cRobsol,IF(lFator,35*2,45),IF(lFator,35*2,45)) 

            // oPrinter:SayBitmap(nLin ,nCol+130,cSedex,35,30) 
            //oPrinter:SayBitmap(nLin ,IF(nEtiq == 1 .or. nEtiq == 3,nCol+190,nCol+490) ,cExpr,40,40) 
            
            nLl1 := 175 - 15
            nLl2 := 230 - 15

            oPrinter:Box(IF(lFator,nLl1+65,nLl1-25),nCl1-5,IF(lFator,nLl2+70,nLl2-25),IF(lFator,nCl2-20,nCl2 - 100),"-6")

            nLl1 := 175
            nLl2 := 230

            // oPrinter:Fillrect({nLl1,nCl1,nLl1+10,nCl2},oBrush1,"-2")
            
            nCl1 := 5
            nLl1 := 65
            If !lTransp
                oPrinter:QRCode(IF(lFator,nLl1+50,nLl1),nCl1,cCodigo,IF(lFator,110,60)) //60
            endif
            //nCl1 := IF(nEtiq == 1 .or. nEtiq == 3,3.5,28.5)
            nCl1 := 1 
            nCl2 := 0.7 
            //nLl1 := IF(nEtiq == 1 .or. nEtiq == 2,8,42.8)

            nLl1 := 6.8 
            nLl2 := 22 

            IF AllTrim(aItens[nZ,2,nR]) != "" .and. !lTransp
                oPrinter:FwMSBAR("CODE128",IF(lFator,12,nLl1),nCl2,aItens[nZ,2,nR],oPrinter,.F.,Nil,Nil,IF(lFator,0.045,0.045),IF(lFator,0.7*2,0.7),Nil,Nil,"A",.F.)
            ENDIF

            oPrinter:FwMSBAR("CODE128",IF(lFator,25,nLl2-5),nCl2+0,SA1->A1_CEP,oPrinter,.F.,Nil,Nil,IF(lFator,0.045*1.5,0.045),IF(lFator,0.7*2,0.7),Nil,Nil,"A",.F.)
            // oPrinter:FwMSBAR("INT25",nLl2-5,nCl2+10,SA1->A1_CEP,oPrinter,.F.,Nil,Nil,0.025,0.7,Nil,Nil,"A",.F.)

            // oPrinter:FwMSBAR("CODABAR",nLl1,nCl2,aItens[nZ,2,nR],oPrinter,.F.,Nil,Nil,0.060,0.8,Nil,Nil,"A",.F.)
            
            // oPrinter:FwMSBAR("INT25",nLl2-5,nCl2+15,SA1->A1_CEP,oPrinter,.F.,Nil,Nil,0.025,0.7,Nil,Nil,"A",.F.)

            //****************  TEXTOS    ***********************//
            nLin += 10 //45

            oPrinter:Say(IF(lFator,nLin+60,nLin),IF(lFator,nCol+180,nCol+110),"NF: "+SF2->F2_DOC,IF(lFator,oF10FFF,oF5FFF))
            nLin += 10
            DbSelectArea("SC5")
            DbGoto(aItens[nZ,04])
            oPrinter:Say(IF(lFator,nLin+60,nLin),IF(lFator,nCol+180,nCol+110),"Pedido: "+SC5->C5_NUM,IF(lFator,oF10FFF,oF5FFF))
            
            nLin += 10
            oPrinter:Say(IF(lFator,nLin+60,nLin),IF(lFator,nCol+180,nCol+110),"Volume: "+cvaltochar(aItens[nZ,3]),IF(lFator,oF10FFF,oF5FFF))
            nLin += 10
            oPrinter:Say(IF(lFator,nLin+60,nLin),IF(lFator,nCol+180,nCol+110),"Peso (g): "+cvaltochar(aItens[nZ,6]*1000),IF(lFator,oF10FFF,oF5FFF))
            
            nLin := 35
            if !lTransp
                oPrinter:Say(IF(lFator,nLin+55,nLin),IF(lFator,nCol+95,nCol+42),"Contrato: "+cCorrCont,IF(lFator,oF10FFF,oF5FFF))
            endif
            nLin += 10
            
            if !lTransp
                oPrinter:Say(IF(lFator,nLin+55,nLin) ,IF(lFator,nCol+115,nCol+50),Iif(cTpFrete == '03220','SEDEX','PAC'),IF(lFator,oF12FFF,oF8FFF))
            endif
                
            //oPrinter:Say(nLin + 30,nCol,"PP: 561374",oF5FFF)
            
            //oPrinter:Say(nLin + IF(Mod(nR,4) == 1 .or. Mod(nR,4) ==2,38,46),IF(nEtiq == 1 .or. nEtiq == 3,nCol+100,nCol+400),aItens[nR,2,nR],oFont8n)
            if !lTransp
                oPrinter:Say(IF(lFator,nLin+90,nLin+29), IF(lFator,nCol+20,nCol+40),aItens[nZ,2,nR],IF(lFator,oF15FFF,oF12FFF))
            ENDIF
            nLin += 65
            nCol := 5

            oPrinter:Say(IF(lFator,nLin+100,nLin + 10),nCol,"Recebedor: ",IF(lFator,oF10FFF,oF5FFF))
            oPrinter:Say(IF(lFator,nLin+110,nLin + 20),nCol,"Assinatura: ",IF(lFator,oF10FFF,oF5FFF))
            oPrinter:Say(IF(lFator,nLin+110,nLin + 20),nCol+100,"Documento: ",IF(lFator,oF10FFF,oF5FFF))

            // *****    LINHAS ASSINATURAS  ******  //
            
            FOR nX := IF(lFator,nCol+40,nCol+25) TO IF(lFator,100,100)
                oPrinter:Say(IF(lFator,nLin+110,nLin+20),nX,'_',oF5FFF)
            NEXT nX
            
            FOR nX := IF(lFator,nCol+144,nCol+125) TO IF(lFator,270,190)
                oPrinter:Say(IF(lFator,nLin+110,nLin+20),nX,'_',oF5FFF)
            NEXT nX

            FOR nX := IF(lFator,nCol+41,nCol+25) TO IF(lFator,270,190)
                oPrinter:Say(IF(lFator,nLin+100,nLin+10),nX,'_',oF5FFF)
            NEXT nX

            // *****  FIM  LINHAS ASSINATURAS  ******  //

            nLin += 30
            nCol := 12
            
            // oPrinter:Say(nLin,nCol,"ENTREGA NO VIZINHO: ",oF5FFF)
            // oPrinter:Say(nLin + 15,nCol,"NAO AUTORIZADA",oF5FFF)

            nLin += 40
            nCol := 10

            oPrinter:Say(IF(lFator,nLin+60,nLin - 35) ,nCol," DESTINATARIO: ",IF(lFator,oF12FFF,oF8FFF))

            nLin += 15
            nCol := 10
            
            cnpj := IF(len(SA1->A1_CGC)<=11,Transform(SA1->A1_CGC,"@R 999.999.999-99"),Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"))
            oPrinter:Say(IF(lFator,nLin+55,nLin-41) ,nCol,Alltrim(SA1->A1_NOME),IF(lFator,oF10FFF,oF5FFF))

            IF (AllTrim(SA1->A1_ENDENT) != "")
                cEndE      := AllTrim(SA1->A1_ENDENT) + " " + AllTrim(SA1->A1_COMPENT)
                cBairroE   := SA1->A1_BAIRROE
                cCepE      := SA1->A1_CEPE
                cMunE      := SA1->A1_MUNE
                cEstE      := SA1->A1_ESTE
            ELSE
                cEndE      := AllTrim(SA1->A1_END) + " " + AllTrim(SA1->A1_COMPLEM)
                cBairroE   := SA1->A1_BAIRRO
                cCepE      := SA1->A1_CEP
                cMunE      := SA1->A1_MUN
                cEstE      := SA1->A1_EST
            ENDIF

            oPrinter:Say(IF(lFator,nLin + 65,nLin + 10 - 41),nCol,Alltrim(cEndE),IF(lFator,oF10FFF,oF5FFF)) //Endere�o
            oPrinter:Say(IF(lFator,nLin + 75,nLin + 20 - 41),nCol,Alltrim(cBairroE),IF(lFator,oF10FFF,oF5FFF)) //Bairro
            oPrinter:Say(IF(lFator,nLin + 85,nLin + 30 - 41),nCol,"CEP: "+Transform(cCepE,"@R 99999-999"),IF(lFator,oF10FFF,oF5FFF)) //CEP
            oPrinter:Say(IF(lFator,nLin + 85,nLin + 30 - 41),nCol+70,Alltrim(cMunE) + " / " +cEstE,IF(lFator,oF10FFF,oF5FFF)) //Municipio/Estado
            //oPrinter:Say(nLin+ 50,IF(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol+140,nCol+440),"BRASIL: ",oF5FFF)
            //oPrinter:Say(nLin+ 60,IF(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol+140,nCol+440),"CNPJ: "+cnpj,oF5FFF)
            //oPrinter:Say(nLin+ 70,IF(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol+140,nCol+440),"OBS.: ",oF5FFF)
            //oPrinter:Say(nLin+ 60,IF(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol+140,nCol+440),"OBS.: ",oF5FFF)

            nLin += 45
            nCol := 5

            //ESQUERDA
            oPrinter:Say(IF(lFator,nLin+120,nLin),nCol,"REMETENTE ",IF(lFator,oF12FFF,oF8FFF))
            oPrinter:Say(IF(lFator,nLin+130,nLin+7),nCol,Alltrim(SM0->M0_NOMECOM),IF(lFator,oF10FFF,oF5FFF))
            oPrinter:Say(IF(lFator,nLin+140,nLin+14),nCol,Alltrim(SM0->M0_FILIAL),IF(lFator,oF10FFF,oF5FFF))
            oPrinter:Say(IF(lFator,nLin+150,nLin+21),nCol,Alltrim(SM0->M0_ENDENT)+", "+Alltrim(SM0->M0_COMPENT),IF(lFator,oF10FFF,oF5FFF))
            oPrinter:Say(IF(lFator,nLin+160,nLin+28),nCol,Alltrim(SM0->M0_BAIRENT),IF(lFator,oF10FFF,oF5FFF))
            oPrinter:Say(IF(lFator,nLin+170,nLin+35),nCol,Transform(SM0->M0_CEPENT,"@R 99999-999"),IF(lFator,oF10FFF,oF5FFF))
            oPrinter:Say(IF(lFator,nLin+170,nLin+35),nCol+50,Alltrim(SM0->M0_CIDENT)+" / "+Alltrim(SM0->M0_ESTENT),IF(lFator,oF10FFF,oF5FFF))

            // *****   LINHAS DIVISORIAS  ******  //
            // nLin := 400
            // FOR nX := 1 TO 600 step 8
            //     oPrinter:Say(nLin,nX+4,'_',oF5FFF)
            // NEXT nX
            
            // nLin := 1
            // nCol := 300
            
            // FOR nX := 1 TO 1600 step 10
            //     oPrinter:Say(nLin,nCol,'|',oF8FFF)
            //     nLin += 15
            // NEXT nX
            // *****  FIM  LINHAS DIVISORIAS  ******  //

            oPrinter:EndPage()
            oPrinter:Print()
            
            nEtiq++
            /*IF Mod(nR,4) > 4
                oPrinter:EndPage()
            ENDIF*/
        NEXT nR
    NEXT nZ
    
Return

/*

Montagem da tela de perguntas

*/

Static Function ValidPerg()

    Local aParamBox    := {}
    Local lRet         := .F.
    Local cNotaDe      := space(TamSX3("F2_DOC")[1])
    Local cNotaAt      := space(TamSX3("F2_DOC")[1])
    Local cSerie       := space(TamSX3("F2_SERIE")[1])
        
    aAdd(aParamBox,{01,"Nota de"                       ,cNotaDe    ,""              ,"","SF2"    ,"", 60,.F.})    // MV_PAR01
    aAdd(aParamBox,{01,"Nota Ate"                      ,cNotaAt    ,""              ,"","SF2"    ,"", 60,.F.})    // MV_PAR02
    aAdd(aParamBox,{01,"Serie"                         ,cSerie     ,""              ,"",""       ,"", 60,.F.})    // MV_PAR03
    aAdd(aParamBox,{04,"Aumentar tamanho da impress�o?",.F.        ,"Marcar se sim.",90,""       ,.F.})           // MV_PAR04
    
    IF ParamBox(aParamBox,"Etiqueta de Produtos X NF",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
        lRet := .T.
        lFator := MV_PAR04
    ENDIF
    
Return lRet
