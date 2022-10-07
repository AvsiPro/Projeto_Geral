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
    Private cTpFrete  := ''
    Private cPedido   := ''

    Default lDnfB     := .F.

    IF Select("SM0") == 0
        RpcSetType(3)
        RPCSetEnv("01","0103")
    ENDIF

    IF !lDnfB
        IF ValidPerg()
            //MV_PAR01 := '000001101'
            //MV_PAR02 := '000001101'
            //MV_PAR03 := '1'
            Processa({|| aItens := buscanf()},"Aguarde, buscando Notas")
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
cQuery += " C5_NUM,F2_SERIE"
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
                TRB->F2_SERIE})
    Dbskip()
ENDDO

FOR nCont := 1 TO len(aRet)

        cTpAux := Upper(aRet[nCont,7])
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
    Local cRobsol          := "\system\img\robsol.bmp"
    Local oFont6           := TFont():New('Arial',5,5,,.F.,,,,.F.,.F.,.F.)
    Local oFont8           := TFont():New('Arial',5,5,,.F.,,,,.F.,.F.,.F.)
    Local oFont8N          := TFont():New('Arial',8,8,,.F.,,,,.T.,.F.,.F.)
    Local oFont10          := TFont():New('Arial',8,8,,.F.,,,,.F.,.F.,.F.)
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

    Private oPrinter       := NIL                 

    nEtiq := 1
    FOR nZ := 1 TO len(aItens)
        FOR nR := 1 TO len(aItens[nZ,2])
            DbSelectArea('SF2')
            DbGotop()
            DbGoto(aItens[nZ,1])
            DbSelectArea("SA1")
            DbSetOrder(1)
            
            SA1->(DbSeek(xFilial('SA1')+SF2->(F2_CLIENTE+F2_LOJA)))
            
            //oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
            oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
            
            oPrinter:StartPage()
            oPrinter:SetMargin(000,000,000,000)
            oPrinter:SetPaperSize(0,100,150)

            // IF nEtiq > 4 //.Or. Mod(nZ,4) == 4 Mod(nR,4)
            //     //oPrinter:EndPage()
            //     nEtiq := 1

            // ENDIF
            

            // ************  SUPERIOR  ***********************//
            // oBrush1 := TBrush():New( , CLR_HRED)
            

           // cCepAux := strtokarr(SA1->A1_CEP,'')
            nValidador := 0

            FOR nX := 1 TO Len(SA1->A1_CEP)
                cCepAux := SubsTr(SA1->A1_CEP,nX,1)
                nValidador += Val(cCepAux)
            NEXT nX

            cValid  := Val(SubsTr(cValToChar(nValidador+10),1,1)+'0')-nValidador
            cNumEnd := strtokarr(Alltrim(SA1->A1_END),',')[2]
            cTel    := StrTran(Alltrim(SA1->A1_DDD)+Alltrim(SA1->A1_TEL),'-','')
            cCodigo := ''

            IF len(aItens[nZ,2]) >= 1 .AND. len(aItens[nZ,9]) >= 1
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
                    aItens[nZ,9,nR]+;           //Informa��o de Agrupamento
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
            oPrinter:SayBitmap(nLin-5,nCol+045,cSimCor,50,20) 
            
            oPrinter:SayBitmap(nLin+220,nCol+115,cRobsol,45,45) 

            // oPrinter:SayBitmap(nLin ,nCol+130,cSedex,35,30) 
            //oPrinter:SayBitmap(nLin ,IF(nEtiq == 1 .or. nEtiq == 3,nCol+190,nCol+490) ,cExpr,40,40) 
            
            
            nLl1 := 175 - 15
            nLl2 := 230 - 15

            oPrinter:Box(nLl1-25,nCl1-5,nLl2-25,nCl2 - 100,"-6")
            

            nLl1 := 175
            nLl2 := 230

            // oPrinter:Fillrect({nLl1,nCl1,nLl1+10,nCl2},oBrush1,"-2")
            
            nCl1 := 5
            nLl1 := 65
            
            oPrinter:QRCode(nLl1,nCl1,cCodigo,60) //60
            
            //nCl1 := IF(nEtiq == 1 .or. nEtiq == 3,3.5,28.5)
            nCl1 := 1 
            nCl2 := 0.7 
            //nLl1 := IF(nEtiq == 1 .or. nEtiq == 2,8,42.8)

            nLl1 := 6.8 
            nLl2 := 22 

            IF AllTrim(aItens[nZ,2,nR]) != ""
                oPrinter:FwMSBAR("CODE128",nLl1,nCl2,aItens[nZ,2,nR],oPrinter,.F.,Nil,Nil,0.045,0.7,Nil,Nil,"A",.F.)
            ENDIF

            oPrinter:FwMSBAR("CODE128",nLl2-5,nCl2+0,SA1->A1_CEP,oPrinter,.F.,Nil,Nil,0.0164,0.7,Nil,Nil,"A",.F.)
            // oPrinter:FwMSBAR("INT25",nLl2-5,nCl2+10,SA1->A1_CEP,oPrinter,.F.,Nil,Nil,0.025,0.7,Nil,Nil,"A",.F.)

            // oPrinter:FwMSBAR("CODABAR",nLl1,nCl2,aItens[nZ,2,nR],oPrinter,.F.,Nil,Nil,0.060,0.8,Nil,Nil,"A",.F.)
            
            // oPrinter:FwMSBAR("INT25",nLl2-5,nCl2+15,SA1->A1_CEP,oPrinter,.F.,Nil,Nil,0.025,0.7,Nil,Nil,"A",.F.)


            //****************  TEXTOS    ***********************//
            nLin += 10 //45

            oPrinter:Say(nLin,nCol+90+20,"NF: "+SF2->F2_DOC,oFont8)
            nLin += 10
            DbSelectArea("SC5")
            DbGoto(aItens[nZ,04])
            oPrinter:Say(nLin,nCol+90+20,"Pedido: "+SC5->C5_NUM,oFont8)
            
            nLin += 10
            oPrinter:Say(nLin,nCol+90+20,"Volume: "+cvaltochar(aItens[nZ,3]),oFont8)
            nLin += 10
            oPrinter:Say(nLin,nCol+90+20,"Peso (g): "+cvaltochar(aItens[nZ,6]*1000),oFont8)
            
            nLin := 35
            oPrinter:Say(nLin,nCol+42,"Contrato: "+cCorrCont,oFont8)
            nLin += 10
            oPrinter:Say(nLin ,nCol+50,Iif(cTpFrete == '03220','SEDEX','PAC'),oFont10)
            
            //oPrinter:Say(nLin + 30,nCol,"PP: 561374",oFont8)
            
            //oPrinter:Say(nLin + IF(Mod(nR,4) == 1 .or. Mod(nR,4) ==2,38,46),IF(nEtiq == 1 .or. nEtiq == 3,nCol+100,nCol+400),aItens[nR,2,nR],oFont8n)
            oPrinter:Say(nLin +29, nCol+40,aItens[nZ,2,nR],oFont10)

            nLin += 65
            nCol := 5


            oPrinter:Say(nLin + 10,nCol,"Recebedor: ",oFont6)
            oPrinter:Say(nLin + 20,nCol,"Assinatura: ",oFont6)
            oPrinter:Say(nLin + 20,nCol+100,"Documento: ",oFont6)
            

            // *****    LINHAS ASSINATURAS  ******  //
            
            FOR nX := nCol+28 TO 100
                oPrinter:Say(nLin+20,nX,'_',oFont6)
            NEXT nX
            
            FOR nX := nCol+125 TO 190
                oPrinter:Say(nLin+20,nX,'_',oFont6)
            NEXT nX

            FOR nX := nCol+26 TO 190
                oPrinter:Say(nLin+10,nX,'_',oFont6)
            NEXT nX

            // *****  FIM  LINHAS ASSINATURAS  ******  //

            nLin += 30
            nCol := 12
            
            // oPrinter:Say(nLin,nCol,"ENTREGA NO VIZINHO: ",oFont6)
            // oPrinter:Say(nLin + 15,nCol,"NAO AUTORIZADA",oFont6)

            nLin += 40
            nCol := 10

            oPrinter:Say(nLin - 35 ,nCol," DESTINATARIO: ",oFont8N)

            nLin += 15
            nCol := 10
            
            cnpj := IF(len(SA1->A1_CGC)<=11,Transform(SA1->A1_CGC,"@R 999.999.999-99"),Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"))
            oPrinter:Say(nLin - 15 - 28 + 2 ,nCol,Alltrim(SA1->A1_NOME),oFont6)

            IF (AllTrim(SA1->A1_ENDENT) != "")
                cEndE      := SA1->A1_ENDENT
                cBairroE   := SA1->A1_BAIRROE
                cCepE      := SA1->A1_CEPE
                cMunE      := SA1->A1_MUNE
                cEstE      := SA1->A1_ESTE
            ELSE
                cEndE      := SA1->A1_END
                cBairroE   := SA1->A1_BAIRRO
                cCepE      := SA1->A1_CEP
                cMunE      := SA1->A1_MUN
                cEstE      := SA1->A1_EST
            ENDIF

            oPrinter:Say(nLin+ 10 - 15 - 28 + 2,nCol,Alltrim(cEndE),oFont6) //Endere�o
            oPrinter:Say(nLin+ 20 - 15 - 28 + 2,nCol,Alltrim(cBairroE),oFont6) //Bairro
            oPrinter:Say(nLin+ 30 - 15 - 28 + 2,nCol,"CEP: "+Transform(cCepE,"@R 99999-999"),oFont6) //CEP
            oPrinter:Say(nLin+ 30 - 15 - 28 + 2,nCol+50,Alltrim(cMunE) + " / " +cEstE,oFont6) //Municipio/Estado
            //oPrinter:Say(nLin+ 50,IF(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol+140,nCol+440),"BRASIL: ",oFont6)
            //oPrinter:Say(nLin+ 60,IF(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol+140,nCol+440),"CNPJ: "+cnpj,oFont6)
            //oPrinter:Say(nLin+ 70,IF(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol+140,nCol+440),"OBS.: ",oFont6)
            //oPrinter:Say(nLin+ 60,IF(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol+140,nCol+440),"OBS.: ",oFont6)


            nLin += 45
            nCol := 5

            //ESQUERDA
            oPrinter:Say(nLin,nCol,"REMETENTE ",oFont8N)
            oPrinter:Say(nLin+7,nCol,Alltrim(SM0->M0_NOMECOM),oFont6)
            oPrinter:Say(nLin+14,nCol,Alltrim(SM0->M0_FILIAL),oFont6)
            oPrinter:Say(nLin+21,nCol,Alltrim(SM0->M0_ENDENT)+", "+Alltrim(SM0->M0_COMPENT),oFont6)
            oPrinter:Say(nLin+28,nCol,Alltrim(SM0->M0_BAIRENT),oFont6)
            oPrinter:Say(nLin+35,nCol,Transform(SM0->M0_CEPENT,"@R 99999-999"),oFont6)
            oPrinter:Say(nLin+35,nCol+50,Alltrim(SM0->M0_CIDENT)+" / "+Alltrim(SM0->M0_ESTENT),oFont6)

              
            
            // *****   LINHAS DIVISORIAS  ******  //
            // nLin := 400
            // FOR nX := 1 TO 600 step 8
            //     oPrinter:Say(nLin,nX+4,'_',oFont8)
            // NEXT nX
            
            // nLin := 1
            // nCol := 300
            
            // FOR nX := 1 TO 1600 step 10
            //     oPrinter:Say(nLin,nCol,'|',oFont10)
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
        
    aAdd(aParamBox,{01,"Nota de"             ,cNotaDe    ,""            ,"","SF2"    ,"", 60,.F.})    // MV_PAR01
    aAdd(aParamBox,{01,"Nota Ate"            ,cNotaAt    ,""            ,"","SF2"    ,"", 60,.F.})    // MV_PAR02
    aAdd(aParamBox,{01,"Serie"               ,cSerie     ,""            ,"",""       ,"", 60,.F.})    // MV_PAR03
    //aAdd(aParamBox,{01,"Quantidade Etiqueta" ,1          ,"@E 9999"     ,"",""       ,"", 60,.F.})    // MV_PAR04
    
    IF ParamBox(aParamBox,"Etiqueta de Produtos X NF",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
        lRet := .T.
    ENDIF
    
Return lRet
