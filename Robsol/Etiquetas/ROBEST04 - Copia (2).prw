#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#Include 'TopConn.ch'
#include 'tbiconn.ch'
#Include 'totvs.ch'

///#DEFINE IMP_SPOOL 6

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

    If Select("SM0") == 0
        RpcSetType(3)
        RPCSetEnv("01","0103")
    Endif

    If !lDnfB
        If ValidPerg()
            //MV_PAR01 := '000001101'
            //MV_PAR02 := '000001101'
            //MV_PAR03 := '1'
            Processa({|| aItens := buscanf()},"Aguarde, buscando Notas")
            If len(aItens) > 0
                Processa({|| ImpEtiq(aItens)},"Impressao de etiqueta","Aguarde...")
            EndIf
        EndIf
    else
        Processa({|| aItens := buscanf()},"Aguarde, buscando Notas")
        If len(aItens) > 0
            Processa({|| ImpEtiq(aItens)},"Impressao de etiqueta","Aguarde...")
        EndIf
    EndIf 
   
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
//cQuery += " AND C5_EMISSAO = F2_EMISSAO
//cQuery += " AND C5_XETIQUE != ' '
cQuery += " AND SC5.D_E_L_E_T_= ' '
cQuery += " WHERE F2_DOC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND F2_SERIE='"+MV_PAR03+"'"
//cQuery += " AND SF2.D_E_L_E_T_=' ' AND F2_CHVNFE<>' '"
cQuery += " AND F2_FILIAL='"+xFilial("SF2")+"'"
If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
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
EndDo

For nCont := 1 to len(aRet)
    //If Empty(aRet[nCont,02,01])

        cTpAux := Upper(aRet[nCont,7])
        nPosIni  := At("<TPFRETE>",  cTpAux) + Len('<TPFRETE>')
        nPosFim  := At("</TPFRETE>", cTpAux)
        nLeitura := nPosFim - nPosIni

        If At("<TPFRETE>",  cTpAux) == 0
            cTpFrete := '03220'
            lTpFret := .T.
        Else
            cTpFrete := SubStr(cTpAux, nPosIni, nLeitura)
        EndIf

        DbSelectArea("SC5")
        SC5->(DbGoto(aRet[nCont,04]))


        DbSelectArea("Z51")
        Z51->(DbSetOrder(1))
        If Z51->(Dbseek(SC5->C5_FILIAL+SC5->C5_NUM+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
            Aadd(aMedidas, Z51->Z51_ALTURA)
            Aadd(aMedidas, Z51->Z51_LARGUR)
            Aadd(aMedidas, Z51->Z51_COMPRI)

            Reclock("Z51",.F.)
            Z51->Z51_NOTA   := aRet[nCont,05]
            Z51->Z51_SERIE  := aRet[nCont,08]
            Z51->(MsUnlock())
        EndIf

        aEtiqueta := {}
        Processa({|| aEtiqueta := U_ROBWS04(aRet[nCont,03], aRet[nCont,01], aRet[nCont,06], cTpFrete, aMedidas )},"Aguarde..."+CRLF+"Gerando Etiqueta")
        cVirg := ''
        cEtiqueta := ''
        
        Aadd(aRet[nCont], {})

        If Len(aEtiqueta) > 0

            For nX := 1 To Len(aEtiqueta)
                cEtiqueta += cVirg+aEtiqueta[nX,1]
                cVirg := ','

                Aadd(aRet[nCont,len(aRet[nCont])], aEtiqueta[nX,2])
            Next nX

            RecLock("SC5", .F.)

            SC5->C5_XETIQUE := cEtiqueta

            If lTpFret
                SC5->C5_XOBS002 := ' <TpFrete>'+cTpFrete+'</TpFrete>' //grava como sedex
            EndIf

            MsUnlock()

            aRet[nCont,02] := strtokarr(cEtiqueta,',')
            
        Else
            MsgAlert('Nao foi possivel gerar a etiqueta para a nota '+aRet[nX,05], 'ROBFAT01')
        EndIf
   // EndIf
Next nCont

Return(aRet)
/*
    IMPRIME
*/
Static Function ImpEtiq(aItens)

    Local cImpress      := 'ZDesigner ZT230-200dpi ZPL' //Alltrim(MV_PAR04) //pego o nome da impressora

    Local cSedex        := "\system\img\"+Iif(cTpFrete == '03220','sedex','pac')+".bmp"
    Local cSimCor       := "\system\img\correio.bmp"
    Local oFont6        := TFont():New('Arial',6,6,,.F.,,,,.F.,.F.,.F.)
    Local oFont8        := TFont():New('Arial',8,8,,.F.,,,,.F.,.F.,.F.)
    Local oFont8N       := TFont():New('Arial',8,8,,.F.,,,,.T.,.F.,.F.)
    Local oFont10       := TFont():New('Arial',10,10,,.F.,,,,.F.,.F.,.F.)
    Local lAdjustToLegacy  := .F.
    Local lDisableSetup    := .T.
    Local nLin          := 0
    Local nCol          := 0
    Local nR
    Local nX
    Local nZ
    Local aCont     :=  strtokarr(SuperGetMV("TI_CONTCOR",.F.,"9912446282/0074256874"),'/')
    Local cCorrCont := aCont[1]

    //Private oPrinter := FWMSPrinter():New("correios_"+dtos(ddatabase)+strtran(time(),":")+".pdf",IMP_SPOOL,lAdjustToLegacy,"c:\temp\",lDisableSetup,,,Alltrim(cImpress),,,,.F., /*parametro que recebe a impressora*/)
    Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
   

    oPrinter:SetMargin(001,001,001,001)
    nEtiq := 1
    For nZ := 1 to len(aItens)
        For nR := 1 to len(aItens[nZ,2])
            DbSelectArea('SF2')
            DbGotop()
            DbGoto(aItens[nZ,1])
            DbSelectArea("SA1")
            DbSetOrder(1)
            
            SA1->(DbSeek(xFilial('SA1')+SF2->(F2_CLIENTE+F2_LOJA)))


            If nEtiq > 4 //.Or. Mod(nZ,4) == 4 Mod(nR,4)
                //oPrinter:EndPage()
                oPrinter:StartPage()
                nEtiq := 1
            EndIf
            

            // ************  SUPERIOR  ***********************//
            oBrush1 := TBrush():New( , CLR_HRED)

           // cCepAux := strtokarr(SA1->A1_CEP,'')
            nValidador := 0

            For nX := 1 To Len(SA1->A1_CEP)
                cCepAux := SubsTr(SA1->A1_CEP,nX,1)
                nValidador += Val(cCepAux)
            Next nX

            cValid  := Val(SubsTr(cValToChar(nValidador+10),1,1)+'0')-nValidador
            cNumEnd := strtokarr(Alltrim(SA1->A1_END),',')[2]
            cTel    := StrTran(Alltrim(SA1->A1_DDD)+Alltrim(SA1->A1_TEL),'-','')
            cCodigo := ''

            If len(aItens[nZ,2]) > 1
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
            EndIf 

            nLin := If(nEtiq == 1 .or. nEtiq == 2,10,410)
            nCol := 23

            nCl1 := If(nEtiq == 1 .or. nEtiq == 3,10,310)
            nCl2 := If(nEtiq == 1 .or. nEtiq == 3,290,590)
            
            
            nLl1 := If(nEtiq == 1 .or. nEtiq == 2,140,550)//165,565
            nLl2 := If(nEtiq == 1 .or. nEtiq == 2,155,565)//180,580

            oPrinter:Fillrect( {nLl1, nCl1, nLl2, nCl2 }, oBrush1, "-2")  
            //oPrinter:SayBitmap(nLin ,If(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol,nCol+300) ,cLogo,70,030) 
            oPrinter:SayBitmap(nLin-5 ,If(nEtiq == 1 .or. nEtiq == 3,nCol+080,nCol+370) ,cSimCor,35,20) 
            
            oPrinter:SayBitmap(nLin ,If(nEtiq == 1 .or. nEtiq == 3,nCol+215,nCol+515) ,cSedex,50,45) 
            //oPrinter:SayBitmap(nLin ,If(nEtiq == 1 .or. nEtiq == 3,nCol+190,nCol+490) ,cExpr,40,40) 
            
            
            nLl1 := If(nEtiq == 1 .or. nEtiq == 2,175,586)//200,600
            nLl2 := If(nEtiq == 1 .or. nEtiq == 2,230,641)//275,619//300,700

            oPrinter:Box( nLl1, nCl1, nLl2, nCl2, "-4")
            
            
            nLl1 := If(nEtiq == 1 .or. nEtiq == 2,175,586)//200,600
            nLl2 := If(nEtiq == 1 .or. nEtiq == 2,230,590)//275,619//300,700

            oPrinter:Fillrect( {nLl1, nCl1, nLl1+10, nCl2 }, oBrush1, "-2")
            
            nCl1 := If(nEtiq == 1 .or. nEtiq == 3,20,320)
            nLl1 := If(nEtiq == 1 .or. nEtiq == 2,75,485)
            
            oPrinter:QRCode(nLl1,nCl1,cCodigo, 75) //60
            
            //nCl1 := If(nEtiq == 1 .or. nEtiq == 3,3.5,28.5)
            nCl1 := If(nEtiq == 1 .or. nEtiq == 3,2,16.3)
            nCl2 := If(nEtiq == 1 .or. nEtiq == 3,1.4,27.4)
            //nLl1 := If(nEtiq == 1 .or. nEtiq == 2,8,42.8)

            nLl1 := If(nEtiq == 1 .or. nEtiq == 2, 6.8, (6.8*6)+0.8)
            nLl2 := If(nEtiq == 1 .or. nEtiq == 2, 22, 56)

            oPrinter:FwMSBAR("CODABAR" , nLl1, nCl2 ,aItens[nZ,2,nR],oPrinter,.F. ,Nil ,Nil ,0.060 ,0.8 ,Nil ,Nil,"A" ,.F. )
            
            oPrinter:FwMSBAR("INT25" , nLl2-5, nCl2+15 ,SA1->A1_CEP,oPrinter,.F. ,Nil ,Nil ,0.025 ,0.7 ,Nil ,Nil,"A" ,.F. )


            //****************  TEXTOS    ***********************//
            nLin+= 10 //45

            oPrinter:Say(nLin ,If(nEtiq == 1 .or. nEtiq == 3,nCol+155,nCol+455),"NF: "+SF2->F2_DOC,oFont8)
            nLin+= 10
            oPrinter:Say(nLin ,If(nEtiq == 1 .or. nEtiq == 3,nCol+155,nCol+455),"Pedido: "+cPedido,oFont8)
            nLin+= 10
            oPrinter:Say(nLin ,If(nEtiq == 1 .or. nEtiq == 3,nCol+155,nCol+455),"Volume: "+cvaltochar(aItens[nZ,3]),oFont8)
            nLin+= 10
            oPrinter:Say(nLin ,If(nEtiq == 1 .or. nEtiq == 3,nCol+155,nCol+455),"Peso (g): "+cvaltochar(aItens[nZ,6]*1000),oFont8)
            
            nLin := If(nEtiq == 1 .or. nEtiq == 2, 35, 435)
            oPrinter:Say(nLin ,If(nEtiq == 1 .or. nEtiq == 3,nCol+75,nCol+375),"Contrato: "+cCorrCont,oFont8)
            nLin+= 10
            oPrinter:Say(nLin ,If(nEtiq == 1 .or. nEtiq == 3,nCol+75,nCol+375),Iif(cTpFrete == '03220','SEDEX','PAC'),oFont8)
            
            //oPrinter:Say(nLin + 30,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),"PP: 561374",oFont8)
            
            //oPrinter:Say(nLin + If(Mod(nR,4) == 1 .or. Mod(nR,4) ==2,38,46),If(nEtiq == 1 .or. nEtiq == 3,nCol+100,nCol+400),aItens[nR,2,nR],oFont8n)
            oPrinter:Say(nLin +29, If(nEtiq == 1 .or. nEtiq == 3,nCol+75,nCol+375),aItens[nZ,2,nR],oFont10)

            nLin += if(nEtiq == 1 .or. nEtiq == 2,65,75)
            nCol := 22


            oPrinter:Say(nLin + 17, If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),"Recebedor: ",oFont6)
            oPrinter:Say(nLin + 27 ,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),"Assinatura: ",oFont6)
            oPrinter:Say(nLin + 27,If(nEtiq == 1 .or. nEtiq == 3,nCol+158,nCol+458),"Documento: ",oFont6)
            

            // *****    LINHAS ASSINATURAS  ******  //
            
            For nX := nCol+If(nEtiq == 1 .or. nEtiq == 3,32,332) to If(nEtiq == 1 .or. nEtiq == 3,170,470)
                oPrinter:Say(nLin+24,nX,'_',oFont6)
            Next nX
            
            For nX := nCol+If(nEtiq == 1 .or. nEtiq == 3,202,502) to If(nEtiq == 1 .or. nEtiq == 3,280,580)
                oPrinter:Say(nLin+24,nX,'_',oFont6)
            Next nX

            For nX := nCol+If(nEtiq == 1 .or. nEtiq == 3,32,332) to If(nEtiq == 1 .or. nEtiq == 3,280,580)
                oPrinter:Say(nLin+14,nX,'_',oFont6)
            Next nX

            // *****  FIM  LINHAS ASSINATURAS  ******  //

            nLin+= 30
            nCol:= 12
            
            oPrinter:Say(nLin + 10,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),"ENTREGA NO VIZINHO: ",oFont6)
            oPrinter:Say(nLin + 25,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),"NAO AUTORIZADA",oFont6)

            nLin+= 40
            nCol:= 10

            oPrinter:Say(nLin+ 2 ,If(nEtiq == 1 .or. nEtiq == 3,nCol + 6,nCol + 306)," DESTINATARIO: ",oFont8N)

            nLin+= 15
            nCol:= 12
            
            cnpj := If(len(SA1->A1_CGC)<=11,Transform(SA1->A1_CGC,"@R 999.999.999-99"),Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"))
            oPrinter:Say(nLin ,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),Alltrim(SA1->A1_NOME),oFont6)
            oPrinter:Say(nLin+ 10,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),Alltrim(SA1->A1_END),oFont6)
            oPrinter:Say(nLin+ 20,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),Alltrim(SA1->A1_BAIRRO),oFont6)
            oPrinter:Say(nLin+ 30,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),"CEP: "+Transform(SA1->A1_CEP,"@R 99999-999"),oFont6)
            oPrinter:Say(nLin+ 30,If(nEtiq == 1 .or. nEtiq == 3,nCol+50,nCol+350),Alltrim(SA1->A1_MUN) + " / " +SA1->A1_EST,oFont6)
            //oPrinter:Say(nLin+ 50,If(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol+140,nCol+440),"BRASIL: ",oFont6)
            //oPrinter:Say(nLin+ 60,If(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol+140,nCol+440),"CNPJ: "+cnpj,oFont6)
            //oPrinter:Say(nLin+ 70,If(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol+140,nCol+440),"OBS.: ",oFont6)
            //oPrinter:Say(nLin+ 60,If(Mod(nZ,4) == 1 .or. Mod(nZ,4) == 3,nCol+140,nCol+440),"OBS.: ",oFont6)


            nLin+= 45
            nCol:= 12

            //ESQUERDA
            oPrinter:Say(nLin ,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),"REMETENTE ",oFont8N)
            oPrinter:Say(nLin+10 ,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),Alltrim(SM0->M0_NOMECOM),oFont6)
            oPrinter:Say(nLin+20 ,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),Alltrim(SM0->M0_FILIAL),oFont6)
            oPrinter:Say(nLin+30 ,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),Alltrim(SM0->M0_ENDENT)+", "+Alltrim(SM0->M0_COMPENT),oFont6)
            oPrinter:Say(nLin+40 ,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),Alltrim(SM0->M0_BAIRENT),oFont6)
            oPrinter:Say(nLin+50 ,If(nEtiq == 1 .or. nEtiq == 3,nCol,nCol+300),Transform(SM0->M0_CEPENT,"@R 99999-999"),oFont6)
            oPrinter:Say(nLin+50 ,If(nEtiq == 1 .or. nEtiq == 3,nCol+50,nCol+350),Alltrim(SM0->M0_CIDENT)+" / "+Alltrim(SM0->M0_ESTENT),oFont6)

              
            
            // *****   LINHAS DIVISORIAS  ******  //
            nLin := 400
            For nX := 1 to 600 step 8
                oPrinter:Say(nLin,nX+4,'_',oFont8)
            Next nX
            
            nLin := 1
            nCol := 300
            
            For nX := 1 to 1600 step 10
                oPrinter:Say(nLin,nCol,'|',oFont10)
                nLin += 15
            Next nX
            // *****  FIM  LINHAS DIVISORIAS  ******  //

           //oPrinter:Print() 
            nEtiq++
            /*If Mod(nR,4) > 4
                oPrinter:EndPage()
            EndIf*/
        Next nR
    Next nZ

    oPrinter:EndPage()
    oPrinter:Print()
    
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
        
    aAdd(aParamBox,{01,"Nota de"             ,cNotaDe    ,""           ,"","SF2"    ,"", 60,.F.})    // MV_PAR01
    aAdd(aParamBox,{01,"Nota Ate"            ,cNotaAt    ,""           ,"","SF2"    ,"", 60,.F.})    // MV_PAR02
    aAdd(aParamBox,{01,"Serie"               ,cSerie    ,""            ,"",""       ,"", 60,.F.})    // MV_PAR03
    //aAdd(aParamBox,{01,"Quantidade Etiqueta" ,1          ,"@E 9999"     ,"",""       ,"", 60,.F.})    // MV_PAR04
    
    If ParamBox(aParamBox,"Etiqueta de Produtos X NF",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
        lRet := .T.
    EndIf
    
Return lRet
