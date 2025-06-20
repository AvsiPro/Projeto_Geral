#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE IMP_SPOOL 2
#DEFINE ENTER CHR(13) + CHR(10)

Static nPosSel    := 1
Static nPosSerie  := 2
Static nPosNota   := 3
Static nPosParc   := 4
Static nPosCodC   := 5
Static nPosLoja   := 6
Static nPosNom    := 7
Static nPosDtE    := 8
Static nPosVlr    := 9
Static nPosVct    := 10
Static nPosVcR    := 11
Static nPosTip    := 12
Static nPosPor    := 13
Static nPosAge    := 14
Static nPosCnt    := 15
Static nPosCNPJ   := 16
Static nPosBor    := 17
Static nPosNNro   := 18
Static nPosNFTR   := 19
Static nPosFil    := 20



User Function ProcesBol(aVetor,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_lSche, _cDirArqBol, _lMail ,_lGerouPdf )
	Private  oObj
	Default  _cBanco		:= ""
	Default  _cAgencia		:= ""
	Default  _cConta		:= ""
	Default  _cSubcta		:= ""
	Default  _Tipo			:= ""
	Default  _EmisIni		:= Ctod("  /  /  ")
	Default  _EmisFim		:= Ctod("  /  /  ")
	Default  _cTitulo		:= ""
	Default  _lSche			:= .F.
	Default  _cDirArqBol 	:= ''
	Default  _lMail         := .F.

	If !_lSche
		oObj := MsNewProcess():New({|lEnd| _lGerouPdf := BOLITAU(aVetor,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_lSche, _cDirArqBol,_lMail) },"Processando","Gerando Boletos...",.T.)	//Processamento da gera��o de boletos
		oObj:Activate()
	Else
		_lGerouPdf := BOLITAU(aVetor,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_lSche, _cDirArqBol,_lMail)
	Endif

Return

/*/{Protheus.doc} BOLITAU
description
Rotina que faz a montagem do boleto
@type function
@version  1.0
@author Valdemir Rabelo
@since 16/01/2022
/*/
Static Function BOLITAU(aVetor,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_lSche, _cDirArqBol,_lMail)
	Local nCont     	:= 0
	Local _lRet			:=	.T.
	Local _aDelFiles	:= {}
	Local _aFiles		:= {}
	Local _cArquivo		:= ""
	Local _cArqRel		:= ""
	Local _aDir			:= {}
	Local lBoleto       := .F.
	Local _nx
	Local i
	Local nx
	Local lEnvPar       := GETMV("FS_EnvLink",.f., .T.)

	Private cDirLocal       := GETMV("FS_PathLoc",.f.,"C:\Temp\Boletos\")
	Private oPrint          := Nil
	Private oFont18N,oFont18,oFont16N,oFont16,oFont14N,oFont12N,oFont10N,oFont14,oFont12,oFont10,oFont08N
	Private _limpr          := .T.
	Private oFontTit        := oFont08N
	Private lAdjustToLegacy := .F.
	Private lDisableSetup   := .T.
	Private lDebug          := .F. 
	Private lPergDebug      := GetMV("FS_DEBUG01",.F.,.T.)
	Private _aBoletos       := {}

	Default  _cBanco		:= ""
	Default  _cAgencia		:= ""
	Default  _cConta		:= ""
	Default  _cSubcta		:= ""
	Default  _Tipo			:= ""
	Default  _EmisIni		:= Ctod("  /  /  ")
	Default  _EmisFim		:= Ctod("  /  /  ")
	Default  _cTitulo		:= ""
	Default  _lMail         := .F.

	oFont18N	:= TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)
	oFont18 	:= TFont():New("Arial",18,18,,.F.,,,,.T.,.F.)
	oFont16N	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
	oFont16 	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
	oFont14N	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
	oFont14 	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
	oFont12		:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
	oFont12N	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
	oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
	oFont10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
	oFont08		:= TFont():New("Arial",07,07,,.T.,,,,.T.,.F.)
	oFont08N	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
	oFont06N	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
	oFont06		:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
	oFont05		:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)

	nReq := 0
	nReq := Len(aVetor)

	dbSelectArea("SA1")
	dbSetOrder(1)

	if lPergDebug .and. !_lSche
		lDebug := MsgNoYes("Deseja apresentar os alertas para acompanhar o processo?","Informativo")
	Endif 

	If !_lSche
		If oObj != Nil
			oObj:SetRegua1(nReq)
			oObj:SetRegua2(nReq)
		EndIf
	Endif

	For i := 1 to Len(aVetor)
		If !_lSche
			oObj:IncRegua1("Processando, Analisando os Boletos... " )
		Endif
		If aVetor[i,nPosSel]
			nCont++

			DbSelectArea("SE1")
			DbSetOrder(1)	// E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			If !DbSeek(aVetor[i,nPosFil] + aVetor[i,nPosSerie] + aVetor[i,nPosNota] + aVetor[i,nPosParc] + aVetor[i,nPosTip])

				cMen := "Titulo nao Localizado - Prefixo: " + Alltrim(aVetor[i,nPosSerie]) + ", Numero: " + Alltrim(aVetor[i,nPosNota]) + ", Parcela: " + Alltrim(aVetor[i,nPosParc]) + ", Tipo: " +  Alltrim(aVetor[i,nPosTip])
				IF lDebug
					MsgAlert( cMen )
				ENDIF 
				If _lSche
					BrkClassGen():MsgConMon( cMen, .t.)
				Else
					FWAlertHelp( cMen, "Verifique se realmente existe o t�tulo" )
				Endif
				    _lRet := .F.
				Exit

			Endif

			if SA1->( DbSeek(xFilial("SA1") + SE1->(E1_CLIENTE + E1_LOJA )) )
				lBoleto := (SA1->A1_BLEMAIL=='1')
			endif

			_cArquivo 	:= ""
			if lBoleto

				dbSelectArea("SEE")
				dbSetOrder(1)	// EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
				If !dbSeek(xFilial("SEE") + _cBanco + _cAgencia + _cConta + _cSubcta )

					cMen := "Banco nao Localizado na SEE - Banco: " + Alltrim(_cBanco) + ", Agencia: " + Alltrim(_cAgencia) + ", Conta: " + Alltrim(_cConta) + ", Subconta: " +  Alltrim(_cSubcta)
					IF lDebug
						MsgAlert( cMen )
					ENDIF
					If _lSche
						BrkClassGen():MsgConMon( cMen, .t.)
					Else
						FWAlertHelp( cMen, "Verificar no cadastro de banos se o registro existe." )
					Endif
					_lRet := .F.
					Exit

				Endif

				_cDvAge		:= SEE->EE_DVAGE
				_cDvCta		:= SEE->EE_DVCTA
				_cCart		:= SEE->EE_CODCART
				_cProtesto	:= SEE->EE_DIASPRT
				_cCodEmp	:= SEE->EE_CODEMP

				aAdd(_aBoletos,{SE1->(Recno()), SE1->E1_NUM, SE1->E1_TIPO, SC5->(Recno()), SC5->C5_NUM, ""})

				_lRet	:=	CalcItau(_aBoletos,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_lSche)

				//Jonas, em caso de nosso numero n�o preenchido aborta impress�o
				If !_lRet
					cMen := "Boleto nao sera gerado. Erro na criacao do nosso numero do Titulo " + Alltrim( _cTitulo )
					IF lDebug
						MsgAlert( cMen )
					ENDIF
					If _lSche
						BrkClassGen():MsgConMon( cMen, .T. )
					Else
						MsgInfo( cMen )
					Endif
					_lRet := .F.
					Exit
				EndIf

				_cArquivo 	:= AllTrim(SE1->E1_FILIAL) + "_" + AllTrim(SE1->E1_NUM) + "_" + Alltrim(SE1->E1_PARCELA) + "_341"
				_cArqRel	:= AllTrim(SE1->E1_FILIAL) + "_" + AllTrim(SE1->E1_NUM) + "_" + Alltrim(SE1->E1_PARCELA) + "_341" + ".REL"

				aadd( _aDelFiles	, _cDirArqBol + "\" + _cArqRel )
				aadd( _aFiles		, _cDirArqBol + "\" + _cArquivo + ".PDF" )

				nPrintType 	:= 2
				lServer		:= If( _lSche, .F., .T. )

				//		  FWMsPrinter():New( < cFilePrintert >, [ nDevice], [ lAdjustToLegacy], [ cPathInServer], [ lDisabeSetup ], [ lTReport], [ @oPrintSetup], [ cPrinter], [ lServer], [ lPDFAsPNG], [ lRaw], [ lViewPDF], [ nQtdCopy] ) --> oPrinter
				oPrint := FWMSPrinter():New( _cArquivo, nPrintType, .F.,  _cDirArqBol,  .T.,         .F.,               ,        "PDF",    lServer,         .T.,     .F.,        .F.,             )
				oPrint:SetResolution(72)
				oPrint:SetPortrait()
				oPrint:SetPaperSize(DMPAPER_A4)
				oPrint:SetMargin(10,10,10,10)
				oPrint:StartPage()
				If !_lSche
					IF lDebug
						MsgAlert( "Ir� gerar o PDF no caminho: "+_cDirArqBol )
					ENDIF					
					oPrint:cPathPDF := _cDirArqBol
				Endif

				dbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1") + SE1->(E1_CLIENTE + E1_LOJA ))

				_cBcoLogo  := ""
				_cDigBanco := ""
				aBcos      := {{"341","7","Logo"+Alltrim(_cBanco)+".jpg"}}
				nF         := ASCan(aBcos ,{|x|, x[1] == _cBanco })
				If nF == 0
					cMen := Iif(Empty(_cBanco),"O numero do banco nao foi informado para o Titulo " + Alltrim( _cTitulo ),"Titulo " + Alltrim( _cTitulo) + " - Nao ha layout previsto para o banco " + _cBanco)
					IF lDebug
						MsgAlert( cMen )
					ENDIF
					If _lSche
						BrkClassGen():MsgConMon( cMen, .T.)
					Else
						MsgBox( cMen )
					Endif
					_lRet := .F.
					Exit
				Else
					_lContinua := .T.
					_cDigBanco := aBcos[nF,2]
					_cBcoLogo  := aBcos[nF,3]
				EndIf

				oPrint:SayBitmap(0020,0025,_cBcoLogo,0085,0020)

				oPrint:Say(0036,0110, "|" + _cBanco + "-" + _cDigBanco + "|" ,oFont18N,100)	// C�digo do Banco + D�gito

				cCgcSM0 := SM0->M0_CGC
				oPrint:Say (0036, 0448,"Comprovante de Entrega",oFont12N )	// Comprovante de Entrega
				BuzzBox  (0040,0025,0065,0320)	// Box Benefici�rio + Cnpj
				oPrint:Say (0046, 0026,"Benefici�rio",oFont06N )
				oPrint:Say (0056, 0026,Alltrim(Substr(SM0->M0_NOMECOM,1,30)),oFont05 )

				oPrint:Say (0046, 0135,"Endere�o",oFont06N )
				oPrint:Say (0053, 0135,Alltrim(Substr(SM0->M0_ENDCOB,1,30)) + " - " + UPPER(Alltrim(SM0->M0_BAIRCOB)),oFont05 )
				oPrint:Say (0060, 0135,"CEP: " + Alltrim(Substr(SM0->M0_CEPCOB,1,5)) + "-" + Alltrim(Substr(SM0->M0_CEPCOB,6,3)) + " - " + Alltrim(SM0->M0_CIDCOB) + " / " + Alltrim(SM0->M0_ESTCOB),oFont05 )

				oPrint:Say (0046,0265,"Cnpj" ,oFont06N,100)
				oPrint:Say (0056,0265,Transform(cCgcSM0,"@R 99.999.999/9999-99"),oFont05) //Cnpj do Benefici�rio
				BuzzBox  (0040,0320,0065,0410)	// Box Agencia / Codigo do Cedente
				oPrint:Say (0046, 0321,"Ag�ncia/C�digo do Benefici�rio",oFont06N )

				oPrint:Say (0056, 0331,Substr(Alltrim(_cAgencia),1,4) + "/" + Substr(Alltrim(_cConta),1,5) + "-" + Alltrim(_cDvCta),oFont06,100)

				BuzzBox  (0040,0410,0065,0480)	// N� do Documento
				oPrint:Say (0046, 0411,"N� do Documento",oFont06N )
				oPrint:Say (0056, 0411,SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA,oFont06 )
				BuzzBox  (0040,0480,0140,0560)	// Box de Selecao
				oPrint:Say (0050, 0481,"(  )Mudou-se"               ,oFont06N,100)
				oPrint:Say (0060, 0481,"(  )Ausente"                ,oFont06N,100)
				oPrint:Say (0070, 0481,"(  )N�o existe n� indicado"	,oFont06N,100)
				oPrint:Say (0080, 0481,"(  )Recusado"               ,oFont06N,100)
				oPrint:Say (0090, 0481,"(  )N�o procurado"          ,oFont06N,100)
				oPrint:Say (0100, 0481,"(  )Endere�o insuficiente"  ,oFont06N,100)
				oPrint:Say (0110, 0481,"(  )Desconhecido"           ,oFont06N,100)
				oPrint:Say (0120, 0481,"(  )Falecido"               ,oFont06N,100)
				oPrint:Say (0130, 0481,"(  )Outros(anotar no verso)",oFont06N,100)
				BuzzBox  (0065,0025,0090,0250)	// Box do Pagador
				oPrint:Say (0071, 0026,"Pagador",oFont06N )
				oPrint:Say (0081, 0026,Upper(SA1->A1_NOME),oFont06 )
				BuzzBox  (0065,0250,0090,0350)	// Box do Vencimento
				oPrint:Say (0071, 0251,"Vencimento",oFont06N )
				oPrint:Say (0081, 0301,Substr( DtoS(SE1->E1_VENCREA),7,2 ) + "/" + Substr( DtoS(SE1->E1_VENCREA),5,2 ) + "/" + Substr( DtoS(SE1->E1_VENCREA),1,4 ),oFont06 )
				BuzzBox  (0065,0350,0090,0480)	// Box do Valor do Documento
				oPrint:Say (0071, 0351,"Valor do Documento",oFont06N )
				aValImps:= ReterImp()//nValor,nValIR,nValCF,nValPI,nValCS,nValINS,nValISS
				oPrint:Say (0081, 0401,AllTrim(Transform(IIf(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDO+SE1->E1_ACRESC,(SE1->E1_SALDO+SE1->E1_ACRESC)- (aValImps[5] + aValImps[3]+aValImps[4]+aValImps[7]+aValImps[2] + aValImps[6])),"@E 999,999,999.99")),oFont06 )
				BuzzBox  (0090,0025,0140,0250)	// Box Recebi(emos) o Bloqueto / Titulo com as caracteristicas acima
				oPrint:Say (0107, 0026,"Box Recebi(emos) o Bloqueto / Titulo",oFont08N )
				oPrint:Say (0117, 0026,"com as caracteristicas acima",oFont08N )
				BuzzBox  (0090,0250,0115,0330)	// Box de Data
				oPrint:Say (0096, 0251,"Data",oFont06N )
				BuzzBox  (0090,0330,0115,0480)	// Box de Assinatura
				oPrint:Say (0096, 0331,"Assinatura",oFont06N )
				BuzzBox  (0115,0250,0140,0330)	// Box de Data
				oPrint:Say (0121, 0251,"Data",oFont06N )
				BuzzBox  (0115,0330,0140,0480)	// Box de Entregador
				oPrint:Say (0121, 0331,"Entregador",oFont06N )

				// 2� Parte
				oPrint:SayBitmap(0160,0025,_cBcoLogo,0085,0020)
				oPrint:Say(0176,0110, "|" + _cBanco + "-" + _cDigBanco + "|" ,oFont18N,100)	// C�digo do Banco + D�gito
				oPrint:Say (0176, 0470,"Recibo do Pagador",oFont12N )	// Recibo do Pagador
				BuzzBox  (0180,0025,0205,0425)	// Local de Pagamento
				oPrint:Say (0186, 0026,"Local de Pagamento",oFont06N )
				oPrint:Say  (0191, 0096,"AT� O VENCIMENTO, PREFERENCIALMENTE NO ITA�",oFont06N )
				oPrint:Say  (0201, 0096,"AP�S O VENCIMENTO, SOMENTE NO ITA� ",oFont06N )
				BuzzBox  (0180,0425,0205,0560)	// Vencimento
				oPrint:Say (0186, 0426,"Vencimento",oFont06N )
				oPrint:Say (0196, 0476,Substr( DtoS(SE1->E1_VENCREA),7,2 ) + "/" + Substr( DtoS(SE1->E1_VENCREA),5,2 ) + "/" + Substr( DtoS(SE1->E1_VENCREA),1,4 ),oFont06 )
				BuzzBox  (0205,0025,0230,0425)	// Beneficiario
				oPrint:Say (0211, 0026,"Benefici�rio",oFont06N )
				oPrint:Say (0221, 0026,ALLTRIM(SM0->M0_NOMECOM),oFont06 )
				oPrint:Say (0211, 0196,"Endere�o",oFont06N )
				oPrint:Say (0218, 0196,Alltrim(Substr(SM0->M0_ENDCOB,1,30)) + " - " + UPPER(Alltrim(SM0->M0_BAIRCOB)),oFont05 )
				oPrint:Say (0225, 0196,"CEP: " + Alltrim(Substr(SM0->M0_CEPCOB,1,5)) + "-" + Alltrim(Substr(SM0->M0_CEPCOB,6,3)) + " - " + Alltrim(SM0->M0_CIDCOB) + " / " + Alltrim(SM0->M0_ESTCOB),oFont05 )
				oPrint:Say (0211,0360,"Cnpj" ,oFont06N,100)
				oPrint:Say (0221,0361,Transform(cCgcSM0,"@R 99.999.999/9999-99"),oFont06) //Cnpj do Benefici�rio
				BuzzBox  (0205,0425,0230,0560)	// Agencia 	/ Codigo do Cedente
				oPrint:Say (0211, 0426,"Ag�ncia/C�digo de Benefici�rio",oFont06N )
				oPrint:Say (0221, 0436,Substr(Alltrim(_cAgencia),1,4) + "/" + Substr(Alltrim(_cConta),1,5) + "-" + Alltrim(_cDvCta),oFont06,100)
				BuzzBox  (0230,0025,0255,0100)	// Data do Documento
				oPrint:Say (0236, 0026,"Data do Documento",oFont06N )
				oPrint:Say (0246, 0056,Substr( DtoS(SE1->E1_EMISSAO),7,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),5,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),1,4 ),oFont06 )
				BuzzBox  (0230,0100,0255,0225)	// Nro. Documento + Parcela
				oPrint:Say (0236, 0101,"N� do Documento",oFont06N )
				oPrint:Say (0246, 0111,SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA,oFont06 )
				BuzzBox  (0230,0225,0255,0275)	// Especie Doc.
				oPrint:Say (0236, 0226,"Especie Doc.",oFont06N )
				oPrint:Say (0246, 0246,"DM",oFont06 )
				BuzzBox  (0230,0275,0255,0325)	// Aceite
				oPrint:Say (0236, 0276,"Aceite",oFont06N )
				oPrint:Say (0246, 0306,"N",oFont06 )
				BuzzBox  (0230,0325,0255,0425)	// Data do Processamento
				oPrint:Say (0236, 0326,"Data do Processamento",oFont06N )
				oPrint:Say (0246, 0356,Substr( DtoS(SE1->E1_EMISSAO),7,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),5,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),1,4 ),oFont06 )
				BuzzBox  (0230,0425,0255,0560)	// Nosso Numero
				oPrint:Say (0236, 0426,"Nosso Numero",oFont06N )
				oPrint:Say (0246, 0476,"109" + "/" + Substr(SE1->E1_NUMBCO,1, Len(Alltrim(SE1->E1_NUMBCO))-1) + "-" + Right(AllTrim(SE1->E1_NUMBCO),1),oFont06 )
				BuzzBox  (0255,0025,0280,0100)	// Uso do Banco
				oPrint:Say (0261, 0026,"Uso do Banco",oFont06N )
				BuzzBox  (0255,0100,0280,0165)	// Carteira
				oPrint:Say (0261, 0101,"Carteira",oFont06N )
				oPrint:Say (0271, 0131,_cCart,oFont06 )
				BuzzBox  (0255,0165,0280,0225)	// Especie
				oPrint:Say (0261, 0166,"Especie",oFont06N )
				oPrint:Say (0271, 0186,"R$",oFont06N )
				BuzzBox  (0255,0225,0280,0325)	// Quantidade
				oPrint:Say (0261, 0226,"Quantidade",oFont06N )
				BuzzBox  (0255,0325,0280,0425)	// Valor
				oPrint:Say (0261, 0326,"Valor",oFont06N )
				BuzzBox  (0255,0425,0280,0560)	// Valor do Documento
				oPrint:Say (0261, 0426,"Valor do Documento",oFont06N )
				oPrint:Say (0271, 0476,AllTrim(Transform(IIf(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDO+SE1->E1_ACRESC,(SE1->E1_SALDO+SE1->E1_ACRESC)-(aValImps[5] +aValImps[3]+aValImps[4]+aValImps[7]+aValImps[2] + aValImps[6])),"@E 999,999,999.99")),oFont06N )
				BuzzBox  (0280,0025,0380,0425)	// Instru��es (Todas as Informa��es deste Bloqueto s�o de Exclusiva Responsabilidade do Cedente)
				oPrint:Say (0286, 0026,"Instru��es (Todas as Informa��es deste Bloqueto s�o de Exclusiva Responsabilidade do Cedente)",oFont06N )
				/*If !Empty(SEE->EE_XJUROS)
					oPrint:Say  (0306,0026,"Juros mora de " + Alltrim(Transform(SEE->EE_XJUROS,"@E 99,999,999.99"))+ " % ao m�s ", oFont08,100)
				EndIf
				If !Empty(SEE->EE_XMULTA)	
					oPrint:Say  (0316,0026,"Multa por atraso do pagamento de R$ " + Alltrim(Transform(SEE->EE_XMULTA,"@E 99,999,999.99")), oFont08,100)
				Endif*/
				//oPrint:Say  (0326,0026,"Sr. Caixa n�o receber apos vencimento. ", oFont08,100)
			
				If !Empty(SE1->E1_DECRESC)
					oPrint:Say  (0336,0026,"Conceder Desconto de R$ ..... " + AllTrim(Transform((SE1->E1_DECRESC),"@E 99,999,999.99")), oFont08,100)
				EndIf
				oPrint:Say  (0346,0026,"Protestar apos " + Alltrim(_cProtesto) + " dias �teis do vencimento.", oFont08,100)
				BuzzBox  (0280,0425,0300,0560)	// (-) Desconto / Abatimento
				oPrint:Say (0286, 0426,"(-) Desconto / Abatimento",oFont06N )
				BuzzBox  (0300,0425,0320,0560)	// (-) Outras Dedu��es
				oPrint:Say (0306, 0426,"(-) Outras Dedu��es",oFont06N )
				BuzzBox  (0320,0425,0340,0560)	// (+) Mora / Multa
				oPrint:Say (0326, 0426,"(+) Mora / Multa",oFont06N )
				BuzzBox  (0340,0425,0360,0560)	// (+) Outros Acrescimos
				oPrint:Say (0346, 0426,"(+) Outros Acrescimos",oFont06N )
				BuzzBox  (0360,0425,0380,0560)	// (=) Valor Cobrado
				oPrint:Say (0366, 0426,"(=) Valor Cobrado",oFont06N )
				BuzzBox  (0380,0025,0450,0560)	// Pagador / Pagador Avalista
				oPrint:Say (0386, 0026,"Pagador",oFont06N )
				oPrint:Say (0396,0106,Upper(SA1->A1_NOME),oFont06 ,100)
				oPrint:Say (0406,0106,SA1->(If(Empty(A1_ENDCOB),A1_END,A1_ENDCOB) + " " + If(Empty(SA1->A1_BAIRROC),SA1->A1_BAIRRO,SA1->A1_BAIRROC)),oFont08 ,100)
				oPrint:Say (0416,0106,SA1->(If(Empty(SA1->A1_CEPC),SA1->A1_CEP,SA1->A1_CEPC) + " " + If(Empty(SA1->A1_MUNC),SA1->A1_MUN,SA1->A1_MUNC) + " " + If(Empty(SA1->A1_ESTC),SA1->A1_EST,SA1->A1_ESTC)),oFont08 ,100)
				oPrint:Say (0426,0106,SA1->(Transform(Alltrim(SA1->A1_CGC),"@R 99.999.999/9999-99") + " " + A1_INSCR),oFont08 ,100)
				oPrint:Say (0448, 0026,"Pagador Avalista",oFont08N )
				oPrint:Say (0455,0360,"Autentica��o Mec�nica",oFont06,100)
				
				// 3� Parte
				oPrint:SayBitmap(0480,0025,_cBcoLogo,0085,0020)
				_cCodBar := Alltrim(SE1->E1_CODBAR)
				_cNumBol := Alltrim(SE1->E1_CODDIG)
				_cCodBarLit := Left(_cNumBol,5) + "." + Substr(_cNumBol,6,5) + "   " +;
				Substr(_cNumBol,11,5) + "." + Substr(_cNumBol,16,6) + "   " +;
				Substr(_cNumBol,22,5) + "." + Substr(_cNumBol,27,6) + "   " +;
				Substr(_cNumBol,33,1) + "   " + Substr(_cNumBol,34)
				oPrint:Say(0496,0200,_cCodBarLit,oFont14N,100)
				oPrint:Say(0496,0110, "|" + _cBanco + "-" + _cDigBanco + "|" ,oFont18N,100)	// C�digo do Banco + D�gito
				BuzzBox  (0500,0025,0525,0425)	// Local de Pagamento
				oPrint:Say (0506, 0026,"Local de Pagamento",oFont06N )
				oPrint:Say  (0511, 0096,"AT� O VENCIMENTO, PREFERENCIALMENTE NO ITA�",oFont06N )
				oPrint:Say  (0521, 0096,"AP�S O VENCIMENTO, SOMENTE NO ITA� ",oFont06N )
				BuzzBox  (0500,0425,0525,0560)	// Vencimento
				oPrint:Say (0506, 0426,"Vencimento",oFont06N )
				oPrint:Say (0516, 0476,Substr( DtoS(SE1->E1_VENCREA),7,2 ) + "/" + Substr( DtoS(SE1->E1_VENCREA),5,2 ) + "/" + Substr( DtoS(SE1->E1_VENCREA),1,4 ),oFont06 )
				//oPrint:Say (0081, 0301,"CONT. APRES",oFont06 )
				BuzzBox  (0525,0025,0550,0425)	// Beneficiario
				oPrint:Say (0531, 0026,"Benefici�rio",oFont06N )
				oPrint:Say (0541, 0026,ALLTRIM(SM0->M0_NOMECOM),oFont06 )
				oPrint:Say (0531, 0196,"Endere�o",oFont06N )
				oPrint:Say (0538, 0196,Alltrim(Substr(SM0->M0_ENDCOB,1,30)) + " - " + UPPER(Alltrim(SM0->M0_BAIRCOB)),oFont05 )
				oPrint:Say (0545, 0196,"CEP: " + Alltrim(Substr(SM0->M0_CEPCOB,1,5)) + "-" + Alltrim(Substr(SM0->M0_CEPCOB,6,3)) + " - " + Alltrim(SM0->M0_CIDCOB) + " / " + Alltrim(SM0->M0_ESTCOB),oFont05 )
				oPrint:Say (0531,0360,"Cnpj" ,oFont06N,100) 
				oPrint:Say (0541,0361,Transform(cCgcSM0,"@R 99.999.999/9999-99"),oFont06) //Cnpj do Benefici�rio
				BuzzBox  (0525,0425,0550,0560)	// Agencia / Codigo do Cedente
				oPrint:Say (0531, 0426,"Ag�ncia/C�digo do Benefici�rio",oFont06N )
				oPrint:Say (0541, 0436,Substr(Alltrim(_cAgencia),1,4) + "/" + Substr(Alltrim(_cConta),1,5) + "-" + Alltrim(_cDvCta),oFont06,100)
				BuzzBox  (0550,0025,0575,0100)	// Data do Documento
				oPrint:Say (0556, 0026,"Data do Documento",oFont06N )
				oPrint:Say (0566, 0046,Substr( DtoS(SE1->E1_EMISSAO),7,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),5,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),1,4 ),oFont06 )
				BuzzBox  (0550,0100,0575,0225)	// Nro. Documento + Parcela
				oPrint:Say (0556, 0101,"N� do Documento",oFont06N )
				oPrint:Say (0566, 0111,SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA,oFont06 )
				BuzzBox  (0550,0225,0575,0275)	// Especie Doc.
				oPrint:Say (0556, 0226,"Especie Doc.",oFont06N )
				oPrint:Say (0566, 0246,"DM",oFont06 )
				BuzzBox  (0550,0275,0575,0325)	// Aceite
				oPrint:Say (0556, 0276,"Aceite",oFont06N )
				oPrint:Say (0566, 0296,"N",oFont06 )
				BuzzBox  (0550,0325,0575,0425)	// Data do Processamento
				oPrint:Say (0556, 0326,"Data do Processamento",oFont06N )
				oPrint:Say (0566, 0356,Substr( DtoS(SE1->E1_EMISSAO),7,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),5,2 ) + "/" + Substr( DtoS(SE1->E1_EMISSAO),1,4 ),oFont06 )
				BuzzBox  (0550,0425,0575,0560)	// Nosso Numero
				oPrint:Say (0556, 0426,"Nosso Numero",oFont06N )
				oPrint:Say (0566, 0476,"109" + "/" + Substr(SE1->E1_NUMBCO,1, Len(Alltrim(SE1->E1_NUMBCO))-1) + "-" + Right(AllTrim(SE1->E1_NUMBCO),1),oFont06 )
				BuzzBox  (0575,0025,0600,0100)	// Uso do Banco
				oPrint:Say (0581, 0026,"Uso do Banco",oFont06N )
				BuzzBox  (0575,0100,0600,0165)	// Carteira
				oPrint:Say (0581, 0101,"Carteira",oFont06N )
				oPrint:Say (0591, 0131,_cCart,oFont06 )
				BuzzBox  (0575,0165,0600,0225)	// Especie
				oPrint:Say (0581, 0166,"Especie",oFont06N )
				oPrint:Say (0591, 0186,"R$",oFont06N )
				BuzzBox  (0575,0225,0600,0325)	// Quantidade
				oPrint:Say (0581, 0226,"Quantidade",oFont06N )
				BuzzBox  (0575,0325,0600,0425)	// Valor
				oPrint:Say (0581, 0326,"Valor",oFont06N )
				BuzzBox  (0575,0425,0600,0560)	// Valor do Documento
				oPrint:Say (0581, 0426,"Valor do Documento",oFont06N )
				oPrint:Say (0591, 0476,AllTrim(Transform(IIf(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDO+SE1->E1_ACRESC,(SE1->E1_SALDO+SE1->E1_ACRESC)- (aValImps[5] +aValImps[3]+aValImps[4]+aValImps[7]+aValImps[2] + aValImps[6])),"@E 999,999,999.99")),oFont06N )
				BuzzBox  (0600,0025,0700,0425)	// Instru��es (Todas as Informa��es deste Bloqueto s�o de Exclusiva Responsabilidade do Cedente)
				oPrint:Say (0606, 0026,"Instru��es (Todas as Informa��es deste Bloqueto s�o de Exclusiva Responsabilidade do Cedente)",oFont06N )
				/*If !Empty(SEE->EE_XJUROS)
					oPrint:Say  (0626,0026,"Juros mora de " + Alltrim(Transform(SEE->EE_XJUROS,"@E 99,999,999.99"))+ " % ao m�s ", oFont08,100)
				EndIf
				If !Empty(SEE->EE_XMULTA)	
					oPrint:Say  (0636,0026,"Multa por atraso do pagamento de R$ " + Alltrim(Transform(SEE->EE_XMULTA,"@E 99,999,999.99")), oFont08,100)
				Endif*/
				//oPrint:Say  (0646,0026,"Sr. Caixa n�o receber apos vencimento. ", oFont08,100)
		
				If !Empty(SE1->E1_DECRESC)
					oPrint:Say  (0656,0026,"Conceder Desconto de R$ ..... " + AllTrim(Transform((SE1->E1_DECRESC),"@E 99,999,999.99")), oFont08,100)
				EndIf
				oPrint:Say  (0666,0026,"Protestar apos " + Alltrim(_cProtesto) + " dias �teis do vencimento.", oFont08,100)
				BuzzBox  (0600,0425,0620,0560)	// (-) Desconto / Abatimento
				oPrint:Say (0606, 0426,"(-) Desconto / Abatimento",oFont06N )
				BuzzBox  (0620,0425,0640,0560)	// (-) Outras Dedu��es
				oPrint:Say (0626, 0426,"(-) Outras Dedu��es",oFont06N )
				BuzzBox  (0640,0425,0660,0560)	// (+) Mora / Multa
				oPrint:Say (0646, 0426,"(+) Mora / Multa",oFont06N )
				BuzzBox(0660,0425,0680,0560)	// (+) Outros Acrescimos
				oPrint:Say(0666, 0426,"(+) Outros Acrescimos",oFont06N )
				BuzzBox(0680,0425,0700,0560)	// (=) Valor Cobrado
				oPrint:Say(0686, 0426,"(=) Valor Cobrado",oFont06N )
				BuzzBox(0700,0025,0770,0560)	// Pagador / Pagador Avalista
				oPrint:Say(0706, 0026,"Pagador",oFont06N )
				oPrint:Say(0716,0106,Upper(SA1->A1_NOME),oFont08 ,100)
				oPrint:Say(0726,0106,SA1->(If(Empty(A1_ENDCOB),A1_END,A1_ENDCOB) + " " + If(Empty(SA1->A1_BAIRROC),SA1->A1_BAIRRO,SA1->A1_BAIRROC)),oFont08 ,100)
				oPrint:Say(0736,0106,SA1->(If(Empty(SA1->A1_CEPC),SA1->A1_CEP,SA1->A1_CEPC) + " " + If(Empty(SA1->A1_MUNC),SA1->A1_MUN,SA1->A1_MUNC) + " " + If(Empty(SA1->A1_ESTC),SA1->A1_EST,SA1->A1_ESTC)),oFont08 ,100)
				oPrint:Say(0746,0106,SA1->(Transform(Alltrim(SA1->A1_CGC),"@R 99.999.999/9999-99") + "               " + A1_INSCR),oFont08 ,100)
				oPrint:Say(0768, 0026,"Pagador Avalista",oFont06N )
				oPrint:Say(0775,0350,"Autentica��o Mec�nica - Ficha de Compensa��o",oFont06,100)
				oPrint:FWMSBAR("INT25",66.2,2.0,_cCodBar,oPrint,.F.,,,,1.0,,,,.F.)  //28.0
				oPrint:EndPage()
				oPrint:Print()
				IF lDebug
				   if file(_cDirArqBol + _cArquivo + ".rel")
				      cMen := "Arquivo: "+_cDirArqBol + _cArquivo + ".rel - Encontrado!!!"
				   else 
				      cMen := "Arquivo: "+_cDirArqBol + _cArquivo + ".rel - N�o Encontrado!!!"
				   endif 
					MsgAlert( cMen )
				ENDIF				
				File2Printer( _cDirArqBol + _cArquivo + ".rel", "PDF" )	
				
				if lChk2
				    IF lDebug
					   MsgAlert( "Habilitado para gerar uma c�pia na maquina local") 
					endif 
					if File(_cDirArqBol + _cArquivo + ".pdf")
						__CopyFile(_cDirArqBol + _cArquivo + ".pdf", cDirLocal+_cArquivo + ".pdf")
						if lDebug
						   MsgAlert( "C�pia realizada na maquina local. Caminho: "+cDirLocal) 
						endif 
					endif 
				endif 
				_cArquivo := _cArquivo + ".pdf"      // Valdemir 21/03/2022

			Endif

			If (_lMail .or. lEnvPar)
				if lDebug
					MsgAlert( "Parametrizado para envio do e-mail") 
					BrkClassGen():MsgConMon( "Parametrizado para envio do e-mail")
				endif 
				DbSelectArea('SFT')
				SFT->(DbSetOrder(1))
				iF SFT->(DbSeek(xFilial('SFT')+'S'+SE1->E1_PREFIXO+SE1->E1_NUM+SA1->A1_COD+SA1->A1_LOJA))
					if lDebug
						MsgAlert( "Gerando link para ser adicionado ao corpo do e-mail") 
						BrkClassGen():MsgConMon( "Gerando link para ser adicionado ao corpo do e-mail") 
					endif
					cLink := 'https://nfe.prefeitura.sp.gov.br/contribuinte/notaprint.aspx?inscricao='+Alltrim(SM0->M0_INSCM)+'&nf='+ALLTRIM(SFT->FT_NFELETR)+'&verificacao='+ALLTRIM(SFT->FT_CODNFE)+'&returnurl=..%2fpublico%2fverificacao.aspx%3ftipo%3d0'
					cCodV := ALLTRIM(SFT->FT_CODNFE)
					cNFS  := ALLTRIM(SFT->FT_NFELETR)
				    Memowrite(cDirLocal+_cArquivo+"_link.txt",  cLink)       // Valdemir Rabelo 01/04/2022
				Else
					cLink := ''
					cCodV := ''
					cNFS  := ''
				EndIf
				if lDebug
					MsgAlert( "Vai ser enviado e-mail ao cliente")
					BrkClassGen():MsgConMon( "Vai ser enviado e-mail ao cliente") 
				endif
				U_BRENVBOL(SA1->A1_MAILFIN,SA1->A1_NOME,SA1->A1_CGC,SE1->E1_NUM,SE1->E1_PREFIXO,_cDirArqBol , _cArquivo, cLink,cCodV,cNFS)

			EndIf		

			If !_lSche            
				oObj:IncRegua2("Gerando os Boletos dos Titulos..." + Alltrim(SE1->E1_NUM) + " " + Alltrim(SE1->E1_PARCELA) )
			Endif	
			
			Sleep( 2000 )
		
		EndIf
	Next

	Sleep( 2000 )

	For _nx := 1 to Len( _aFiles )
		_aDir := DIRECTORY( _aFiles[ _nx ], "H")
		If Len( _aDir ) == 0 .or. _aDir[1,2] == 0 
			_lRet := .F.
			exit
		Endif	
	Next

	For nx := 1 to Len( _aDelFiles )
		fErase( _aDelFiles[nx] )
	Next
	/*  Conforme orienta��o do Claudio, n�o dever� excluir o arquivo da pasta
	If !_lRet
		For _nx := 1 to Len( _aFiles )
			fErase( _aFiles[_nx] )
		Next
	Endif
	*/
	
Return( _lRet )


/*/{@Protheus.doc} BuzzBox
description
Rotina Desenha um Box Sem Preenchimento 
@type function
@version  1.0
@author Valdemir Rabelo
@since 16/01/2022
/*/
Static Function BuzzBox(_nLinIni,_nColIni,_nLinFin,_nColFin) // < nRow>, < nCol>, < nBottom>, < nRight>

	oPrint:Line( _nLinIni,_nColIni,_nLinIni,_nColFin,CLR_BLACK, "-2")
	oPrint:Line( _nLinFin,_nColIni,_nLinFin,_nColFin,CLR_BLACK, "-2")
	oPrint:Line( _nLinIni,_nColIni,_nLinFin,_nColIni,CLR_BLACK, "-2")
	oPrint:Line( _nLinIni,_nColFin,_nLinFin,_nColFin,CLR_BLACK, "-2")

Return


/*/{@Protheus.doc} ReterImp
description
Rotina criada para Reter os Impostos conforme os Valores das parcelas
@type function
@version 1.0 
@author Valdemir Rabelo
@since 16/01/2022
/*/
Static Function ReterImp()
	Local nValor  := 0
	Local nValIR  := 0
	Local nValCF  := 0
	Local nValPI  := 0
	Local nValCS  := 0
	Local nValINS := 0
	Local nValISS := 0
	Local cQuery  := ""
	
	If Select("TRB") > 0
	   DbSelectArea("TRB")
	   DbCloseArea()
	EndIf                  
	
	cQuery := " SELECT E1_TIPO,E1_VALOR      " + CRLF
	cQuery += " FROM "+RetSqlName("SE1") + " " + CRLF
	cQuery += " WHERE E1_FILIAL		= '" + xfilial('SE1') + "'     " + CRLF
	cQuery += "  AND   E1_PREFIXO    = '" + SE1->E1_PREFIXO + "'   " + CRLF
	cQuery += "  AND   E1_NUM        = '" + SE1->E1_NUM + "'       " + CRLF
	cQuery += "  AND   E1_PARCELA    = '" + SE1->E1_PARCELA + "'   " + CRLF
	cQuery += "  AND   D_E_L_E_T_ <> '*' " + CRLF
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
	
	DbSelectArea("TRB") 
	DbGoTop()
	
	While TRB->(!Eof())
		If TRB->E1_TIPO=="NF"
			nValor:=TRB->E1_VALOR
		ElseIf TRB->E1_TIPO=="IR-"
			nValIR:=TRB->E1_VALOR
		ElseIf TRB->E1_TIPO=="CF-" 
			nValCF:=TRB->E1_VALOR
		ElseIf TRB->E1_TIPO=="PI-" 
			nValPI:=TRB->E1_VALOR
		ElseIf TRB->E1_TIPO=="CS-" 
			nValCS:=TRB->E1_VALOR
		ElseIf TRB->E1_TIPO=="IN-" 
			nValINS:=TRB->E1_VALOR 
		ElseIf TRB->E1_TIPO=="IS-" 
			nValISS:=TRB->E1_VALOR 
		EndIf
		TRB->(DbSkip())		
	End
	
	If Select("TRB") > 0
	   DbSelectArea("TRB")
	   DbCloseArea()
	EndIf             
	
Return ({nValor,nValIR,nValCF,nValPI,nValCS,nValINS,nValISS})


/*/{@Protheus.doc} CalcItau
description
Rotina p/ Tratamento Do Nosso Numero, Digitos VerIficaDores
Montagem da Linha Digitavel e Codigo de Barras.
@type function
@version  1.0
@author Valdemir Rabelo
@since 16/01/2022
/*/
Static Function CalcItau(_aBoletos,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_lSche)
	Local _aArea   := Getarea()
	Local _aImpBol := {}
	Local _nxx     := 0
	Local lRet     := .T.
	
	Default _cBanco   := ""
	Default _cAgencia := ""
	Default _cConta   := ""
	Default _cSubcta  := ""
	Default _Tipo     := ""
	Default _EmisIni  := Ctod(" / / ")
	Default _EmisFim  := Ctod(" / / ")
	Default _cTitulo  := ""
	
	For _nxx:=1 To Len(_aBoletos)
		If Empty(_aBoletos[_nxx][6])
			SF2->(DbGoTo(_aBoletos[_nxx][1]))
			SC5->(DbGoTo(_aBoletos[_nxx][4]))
			if Empty(_cTitulo)
			   _cTitulo := SF2->F2_DOC
			endif 
			lRet	:=	CodBco341(_aBoletos[_nxx,2],_aBoletos[_nxx,3],_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_lSche)
			
			If !lRet
				RestArea(_aArea)
				Return lRet
			EndIf
			_aBoletos[_nxx][6]:="Ok"
			aAdd(_aImpBol,{_aBoletos[_nxx,3],_aBoletos[_nxx,2]}) //serie/Doc
		EndIf
	Next _nxx

	RestArea(_aArea)
	
Return lRet



/*/{@Protheus.doc} CodBco341
description
Rotina para Atualiza��o do Nosso Numero, Codigo Barra e Linha Digitavel
@type function
@version  1.0
@author Valdemir Rabelo
@since 16/01/2022
/*/
Static Function CodBco341(_cNumeIni,cInull,_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_lSche)
	Local _cNumBar    := ""
	Local _cNossoNum  := ""
	Local lRet        := .T.

	private _cDigBar  := ""
	Private _cDigCor  := ""
	Private _nDigtc3  := 0
	Private _cDig1bar := 0

	Default _cBanco   := ""
	Default _cAgencia := ""
	Default _cConta   := ""
	Default _cSubcta  := ""
	Default _Tipo     := ""
	Default _EmisIni  := Ctod(" / / ")
	Default _EmisFim  := Ctod(" / / ")
	Default _cTitulo  := ""
	Default cInull    := ""

	_cParcIni	:= SE1->E1_PARCELA
	_cPrefixo	:= SE1->E1_PREFIXO
	_cNum    	:= SE1->E1_NUM
	_cParcFim	:= SE1->E1_PARCELA
	_cBanco   	:= SEE->EE_CODIGO
	_cAgencia 	:= SEE->EE_AGENCIA
	_cConta   	:= SEE->EE_CONTA
	_cDvCta   	:= SEE->EE_DVCTA

	_cNossoNum	:= Nosso341(_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_lSche)

	If Empty( _cNossoNum )
		cMen := "Nosso n�mero n�o preenchido para o Titulo " + Alltrim( _cTitulo ) + ", verifique se a tabela de parametros para o banco informado esta preenchida (SEE)."
		If _lSche
			BrkClassGen():MsgConMon( cMen, .T. )
		Else
			FWAlertInfo( cMen, "Aten��o!" )
		Endif

		Return .F.
	EndIf

	aValImps    := ReterImp()           //nValor,nValIR,nValCF,nValPI,nValCS,nValINS,nValISS
	_cNossoNum	:= Alltrim(_cNossoNum)
	_cNossoDig	:= Right(_cNossoNum,1)
	_cNossoNum	:= Left(_cNossoNum,Len(_cNossoNum)-1)
	_cDigBar	:= ""
	_cNumBar	:= _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar,_cNossoDig)   // Montagem do C�digo de Barras.
	_cNumBol	:= _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)               // Montagem da Linha Digitavel.

	If !Empty(_cNossoNum) .Or. !Empty(_cNumBar) .Or. !Empty(_cNumbol)

		Reclock("SE1",.F.)
		If Empty(SE1->E1_NUMBCO)
			SE1->E1_NUMBCO  := _cNossoNum + _cNossoDig
		EndIf
		SE1->E1_PORTADO	:= _cBanco
		SE1->E1_AGEDEP	:= _cAgencia
		SE1->E1_CONTA	:= _cConta
		SE1->E1_CODBAR  := _cNumBar
		SE1->E1_CODDIG  := _cNumBol
		SE1->E1_SITUACA := "0"
		SE1->(msunlock())
	EndIf

Return lRet



/*/{@Protheus.doc} _fNumBol
	description
	Rotina para Montagem da Linha Digitavel.
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
Static Function _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)
	Local _cNumBol := ""

	_cCampo1 := _cBanco + "9" + "109" + Left(_cNossoNum,2)
	_cDig1   := _fDigVer(_cCampo1,_cBanco)
	_cCampo2 := Substr(_cNossoNum,3) + _cNossoDig + Left(_cAgencia,3)
	_cDig2   := _fDigVer(_cCampo2,_cBanco)
	_cCampo3 := Substr(_cAgencia,4,1) + Strzero(Val(Alltrim(_cConta)),5) + Alltrim(_cDvCta) + "000"
	_cDig3   := _fDigVer(_cCampo3,_cBanco)
	_cCampo4 := _cDigBar
	_cCampo5 := Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero((IIf(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDO+SE1->E1_ACRESC,(SE1->E1_SALDO+SE1->E1_ACRESC)- (aValImps[5] + aValImps[3]+aValImps[4]+aValImps[7]+aValImps[2] + aValImps[6])))*100,10)
	_cNumBol := _cCampo1 + _cDig1 + _cCampo2 + _cDig2 + _cCampo3 + _cDig3 + _cCampo4 + _cCampo5

Return _cNumBol


/*/{@Protheus.doc} _fNumBar
	description
	Rotina para Montagem do C�digo de Barras.
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
Static Function _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,_cDigBar,_cNossoDig)
	Local _cNumBar,_cNossoNu1 := _cNossoNum,_nVez
	Private _cDigcor := ""

	For _nVez:=1 To Len(_cNossoNum)
		If Substr(_cNossoNum,_nVez,1) == "0"
			_cNossoNu1:=Right(_cNossoNu1,Len(_cNossoNu1)-1)
		Else
			Exit
		EndIf
	Next

	_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero((IIf(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDO+SE1->E1_ACRESC,(SE1->E1_SALDO+SE1->E1_ACRESC)- (aValImps[5] + aValImps[3]+aValImps[4]+aValImps[7]+aValImps[2] + aValImps[6])))*100,10) + "109" + _cNossoNum + _cNossoDig + Strzero(Val(Alltrim(_cAgencia)),4) + Strzero(Val(Alltrim(_cConta)),5) + Alltrim(_cDvCta) + "000"
	_cNumBar := Left(_cCampo1,4) + (_cDigBar:=_fDigBar(_cCampo1,_cBanco)) + Substr(_cCampo1,5)

Return _cNumBar



/*/{@Protheus.doc} _fDigVer
	description
	Rotina para calcular os Digitos Verificadores dos campos 1,2 e 3
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
Static Function _fDigVer(_cCampo,_cBanco)
	Local _nVez,_nFator,_nPeso,_nReturn,_nResult,_cResult

	_nFator := 0
	_nPeso	:= 2
	_nReturn:= 0

	For _nVez := Len(_cCampo) To 1 Step - 1
		_nResult := Val(Substr(_cCampo,_nVez,1)) * _nPeso
		_cResult := Strzero(_nResult,2)
		_nFator += Val(Substr(_cResult,1,1))
		_nFator += Val(Substr(_cResult,2,1))
		_nPeso := If(_nPeso == 2,1,2)
	Next

	_nReturn := mod(_nFator,10)

	If _nReturn > 0
		_nReturn := 10 - _nReturn
	EndIf

Return Str(_nReturn,1)


/*/{@Protheus.doc} _fDigBar
	description
	Rotina para calcular o Digito Verificador Centralizador
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
Static Function _fDigBar(_cCampo,_cBanco)
	Local _nVez,_nPeso,_nFator,_nResto

	If (_cBanco=="341")              // Itau
		_nPeso:=2
		_nFator:=0
		_nResto:=0

		For _nVez:=Len(_cCampo) to 1 Step -1
			_nFator+=Val(Substr(_cCampo,_nVez,1))*_nPeso
			_nPeso:=If(_nPeso<9,_nPeso+1,2)
		Next

		_nResto:=mod(_nFator,11)
		If _nResto==0.or._nResto==1.or._nResto==10.or._nResto==11
			_nResto:=1
		Else
			_nResto:=11-_nResto
		EndIf
	EndIf

Return Str(_nResto,1)


/*/{@Protheus.doc} Nosso341
	description
	Rotina para calcular o digito do Nosso Numero.
	@type function
	@version 1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
Static Function Nosso341(_cBanco,_cAgencia,_cConta,_cSubcta,_Tipo,_EmisIni,_EmisFim,_cTitulo,_lSche)
	Local _xConta     := ""
	Local _xAgencia   := ""
	Local _xCart      := ""
	Local _xNosso_num := ""
	Local _xVariavel  := ""
	Local _nPeso      := 2
	Local _nResult    := 0
	Local _cResult    := ""
	Local _nFator     := 0
	Local _nReturn    := 0
	Local _cRet		  := ""
	Local _nVez       := 0

	Default _cBanco   := ""
	Default _cAgencia := ""
	Default _cConta   := ""
	Default _cSubcta  := ""
	Default _Tipo     := ""
	Default _EmisIni  := Ctod(" / / ")
	Default _EmisFim  := Ctod(" / / ")
	Default _cTitulo  := ""

	If Empty(SE1->E1_NUMBCO)

		dbSelectArea("SEE")
		DbSetOrder(1)
		If DbSEEk(xFilial("SEE")+_cBanco+_cAgencia+_cConta+_cSubcta)

			RecLock("SEE",.f. )
			SEE->EE_FAXATU := soma1(SEE->EE_FAXATU,8)
			SEE->(MsUnlock())

			_xConta   	:= Alltrim(SEE->EE_CONTA)
			_xAgencia 	:= Left(SEE->EE_AGENCIA,4)
			_xCart    	:= "109"
			_xNosso_num := Right(SEE->EE_FAXATU,8)
			_xVariavel	:= _xAgencia+_xConta+_xCart+_xNosso_num

			For _nVez := Len(Alltrim(_xVariavel)) to 1 Step -1
				_nResult := Val(Substr(_xVariavel,_nVez,1))*_nPeso
				_cResult := Strzero(_nResult,2)
				_nFator  += Val(Substr(_cResult,1,1))
				_nFator  += Val(Substr(_cResult,2,1))
				_nPeso   := If(_nPeso==2,1,2)
			Next

			_nReturn := mod(_nFator,10)
			If _nReturn>0
				_nReturn:=10-_nReturn
			EndIf
			_cRet:=_xNosso_num+str(_nReturn,1)
		Else
			cMen := "N�o existe configura��o para o banco informado SEE do Titulo " + Alltrim(_cTitulo) + ", favor preencher."
			If _lSche
				BrkClassGen():MsgConMon( cMen, .T. )
			Else
				FWAlertInfo( cMen, "Aten��o!" )
			Endif
		Endif

	Else

		_cRet := SE1->E1_NUMBCO

	EndIf


Return(_cRet)



User Function RetValLi()
	Local aValImps 	:= ReterImp()
	Local nValLiq	:= 0

	If SE1->E1_PREFIXO <> "RPS"
		nValLiq := SE1->E1_SALDO + SE1->E1_ACRESC
	Else
		nValLiq := ( SE1->E1_SALDO + SE1->E1_ACRESC) - ( aValImps[5] + aValImps[3] + aValImps[4] + aValImps[7] + aValImps[2] + aValImps[6] )
	Endif

Return( nValLiq )



