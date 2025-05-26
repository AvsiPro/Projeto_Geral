#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#include "rwmake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "totvs.ch"

#define ENTER CHR(13)+CHR(10)


User Function BRWFFAT2()

	Private aSays 		:= {}
	Private aButtons 	:= {}
	Private cPerg       := "BRWFFAT"
	Private nOpca       := 0
	Private cCadastro	:= "Cobrança Brasil Risk"
	aErros := {}

	//If !Pergunte(cPerg,.f.)
	//		AjustaSX1(cPerg)
	//	Endif

	AADD(aSays,"Este programa tem o objetivo de realizar a cobrança via Workflow")
	AADD(aSays,"Clientes Selecionados")
	AADD(aSays,"")

	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T.) 	}} )
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()	}} )
	AADD(aButtons, { 2,.T.,{|o| nOpca:= 2,o:oWnd:End()	}} )

	//Iniciando log de processos
	ProcLogIni( aButtons )

	FormBatch( cCadastro, aSays, aButtons )

	If ( nOpca == 1 )
		If !empty(mv_par01) .and. !empty(mv_par02)
			Processa({|lEnd| COBRAN()} )

		Else
			MsgAlert("Você precisa preencher corretamente os parâmetros. Rotina foi abortada.", "COBRAN - Atenção")
			Return

		Endif

	Endif

Return	


Static Function COBRAN()

	Local cAlias := GETNEXTALIAS()
	Local cQuery        := ''
	Local aArea   		:= GetArea()
	Local _lRetorno 	:= .F.
	Local _nOpca 		:= 0
	Local bOk 			:= {|| _nOpca:=1,_lRetorno:=.T.,oDlg:End() }
	Local bCancel 		:= {|| _nOpca:=0,oDlg:End() }
	Local _cArqEmp 		:= ""
	Local _aStruTrb 	:= {}
	Local _aBrowse 		:= {}
	Local lRet			:= .T.
	Local SB1Reg  		:= 0
	Local cQry			:= ""
	Local nLoop			:= 0
	Local lContinua 	:= .T.
	Local aPed			:= {}
	Local aRet			:= {}
	Local cLoja         := ''     
	Local _nARet 		:= 0
	Local _nLoop8 		:= 0
	Local aArea         := GetArea()
	Local cAlias        := "TRB1"
	Local ncont         := 0
	Local _cFormPG
	Local _cClien
	Local _cLojaC
	Local _cSerie
	Local _cNota
	Local _cParc
	Local cNupv        := {}
	Local cDados       := {}
	//Local cDados1       := {}

	Private lInverte 	:= .F.
	Private cMarca 		:= GetMark()
	Private oBrwTrb
	Private cFiltro		:= ''
	Private oDlg
	Private cFilOri



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define campos do TRB ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aadd(_aStruTrb,{"OK" 			,"C",02,0})
	aadd(_aStruTrb,{"F2_DOC" 	    ,"C",11,0})
	aadd(_aStruTrb,{"F2_SERIE" 		,"C",06,0})
	aadd(_aStruTrb,{"F2_CLIENTE" 	,"D",8,0})
	aadd(_aStruTrb,{"A1_NOME" 		,"C",40,0})
    aadd(_aStruTrb,{"C5_NUM" 		,"C",06,0})	
	aadd(_aStruTrb,{"F2_EMISSAO" 	,"C",06,0})
	aadd(_aStruTrb,{"E1_TIPO" 		,"C",03,0})
	aadd(_aStruTrb,{"E1_CLIENTE" 		,"C",06,0})
	aadd(_aStruTrb,{"E1_LOJA" 		,"C",02,0})
	aadd(_aStruTrb,{"E1_PREFIXO" 		,"C",03,0})
	aadd(_aStruTrb,{"E1_NUM" 		,"C",09,0})
	aadd(_aStruTrb,{"E1_PARCELA" 		,"C",02,0})
	aadd(_aStruTrb,{"E1_NUMNOTA" 		,"C",09,0})
	


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define campos do MsSelect ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	aadd(_aBrowse,{"OK" ,			,"" })
	aadd(_aBrowse,{"F2_DOC",		,"Documento" })
	aadd(_aBrowse,{"F2_SERIE",		,"Serie" })
	aadd(_aBrowse,{"F2_CLIENTE",	,"Cliente" })
	aadd(_aBrowse,{"A1_NOME" ,		,"Nome Cliente" })
	aadd(_aBrowse,{"C5_NUM",		,"Pedido" })
	aadd(_aBrowse,{"F2_EMISSAO",	,"Emissão" })
	aadd(_aBrowse,{"E1_TIPO" ,		,"Tipo" })
	aadd(_aBrowse,{"E1_CLIENTE" ,	,"Nº Cliente" })
	aadd(_aBrowse,{"E1_LOJA" ,		,"Loja" })
	aadd(_aBrowse,{"E1_PREFIXO" ,	,"Prefixo" })
	aadd(_aBrowse,{"E1_NUM" ,	    ,"Numero" })
	aadd(_aBrowse,{"E1_PARCELA" ,	,"Parceça" })
	aadd(_aBrowse,{"E1_NUMNOTA" ,    ,"Fatura" })
	

	
	If Select("TRB") > 0

		TRB->(DbCloseArea())

	Endif

	_cArqEmp := CriaTrab(_aStruTrb)
	dbUseArea(.T.,__LocalDriver,_cArqEmp,"TRB")
	

	//Aqui você monta sua query que serve para gravar os dados no arquivo temporario...
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a Query 											                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	
	cQuery:= " SELECT F2_CHVNFE,F2_SERIE, F2_DOC, A1_CGC,F2_FILIAL,F2_CLIENTE,F2_LOJA,F2_FORMUL,F2_TIPO "
	cQuery+= " FROM "+RetSqlName("SF2") + " SF2 "
	cQuery+= " INNER JOIN " + RetSQLName("SA1") + " SA1 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA  AND SA1.D_E_L_E_T_ = ''"
	cQuery+= " WHERE SF2.D_E_L_E_T_ =' ' "
	cQuery+= " AND F2_CHVNFE <> ''  AND F2_EMISSAO = '"+DTOS(ddatabase)+"'"

	cQuery := ChangeQuery(cQuery)

	If Select("TRB1") > 0

		TRB1->(DbCloseArea())

	Endif


	TCQuery cQuery new Alias "TRB1"	

	IF Empty((cAlias)->F2_CHVNFE)
		Aviso("Aviso","Não existe registro para o Filtro Selecionado.",{'Ok'},2)
		lRet := .T.
	Else   

		While (cAlias)->(!Eof())

			RecLock("TRB",.T.)

			TRB->OK 		:= space(2)
			TRB->F2_DOC 	:= (cAlias)->F2_DOC
			TRB->F2_SERIE	:= (cAlias)->F2_SERIE
			TRB->F2_CLIENTE	:= (cAlias)->F2_CLIENTE
			TRB->F2_EMISSAO	:= (cAlias)->F2_EMISSAO
			TRB->A1_NOME 	:= (cAlias)->A1_NOME

			TRB->C5_NUM 	:= (cAlias)->C5_NUM
			TRB->E1_TIPO 	:= (cAlias)->E1_TIPO
			TRB->E1_CLIENTE := (cAlias)->E1_CLIENTE
			TRB->E1_LOJA 	:= (cAlias)->E1_LOJA
			TRB->E1_PREFIXO := (cAlias)->E1_PREFIXO
			TRB->E1_NUM 	:= (cAlias)->E1_NUM
			TRB->E1_PARCELA := (cAlias)->E1_PARCELA
			TRB->E1_NUMNOTA := (cAlias)->E1_NUMNOTA

			MsUnlock()

			(cAlias)->(DbSkip())

		Enddo



		@ 001,001 TO 400,700 DIALOG oDlg TITLE OemToAnsi("Lista de Clientes")

		@ 020,005 SAY OemToAnsi("Selecione os Clientes: ")

		oBrwTrb := MsSelect():New("TRB","OK","",_aBrowse,@lInverte,@cMarca,{031,001,170,350})
		oBrwTrb:oBrowse:lCanAllmark := .T.
		Eval(oBrwTrb:oBrowse:bGoTop)
		oBrwTrb:oBrowse:Refresh()                                                                                         


		Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,)) Centered VALID _lRetorno

		If _nOpca == 1

			TRB->(DbGotop())

			Do While TRB->(!Eof())
				ncont ++
				If !Empty(TRB->OK) //se usuario marcou o registro
					cNupv    := TRB->C5_NUM
					_cFormPG := TRB->E1_TIPO
					_cClien  := TRB->E1_CLIENTE
					_cLojaC  := TRB->E1_LOJA
					_cSerie  := TRB->E1_PREFIXO
					_cNota   := TRB->E1_NUM
					_cParc   := TRB->E1_PARCELA
					_cDoc    := TRB->F2_DOC

					u_PEDIPDF(cNupv)
					u_BOLEITAU(_cFormPG,_cClien,_cLojaC,_cSerie,_cNota,_cParc,)
					MONWORFLW(_cDoc)
				ENDIF

				SC5->(dbCloseArea())
				RestArea(aArea)	

				TRB->(DbSkip())
			EndDo
			ConfirmSX8()
		Endif
	Endif


	RestArea(aArea)

Return (lRet)



Static Function MONWORFLW(_cDoc)

	Local cMsg    := ""
	Local cPath   := ""
	Local aImgs   := {}
	Local _aAnexo   := {}
	Local _CMAILFROM	:= 'follha.totvs@brasilrisk.com.br                                                                                                                        '
	Local cHtml		:= ""

	cPath   := GetSrvProfString("StartPath",'')

	aAdd(aImgs, {"Pedido.pdf", cPath + "Pedido.pdf"})
	aAdd(aImgs, {"boletoitau.pdf", cPath + "boletoitau.pdf"})


	cHtml := "<!DOCTYPE html><html xmlns='http://www.w3.org/1999/xhtml' lang='pt-br' xml:lang='pt-br'>"
	cHtml += "	<head>"                                                                                 
	cHtml += "		<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>"
	cHtml += "	</head>"
	cHtml += "	<body style= 'font-family: Calibri;ms-text-size-adjust: 100%;webkit-text-size-adjust: 100%;margin: 0;>"
	cHtml += "			<header style='display: block;'>"
	cHtml += "				<table width='100%' border='0' cellpadding='0' cellspacing='2' bordercolor='#FFFFFF' bgcolor='#FFFFFF'>"
	cHtml += "					<tr >"
	cHtml += "        				<td  width='100%'>Caro cliente, "+"</td>"
	cHtml += "	  				</tr>"
	cHtml += '	 <br>'
	cHtml += "					<tr >"
	cHtml += "        				<td  width='100%'>Essa mensagem se refere á nota de Serviços abaixo: "+"."+"</td>"
	cHtml += "	  				</tr>"
	cHtml += '	 <br>'
	cHtml += "					<tr >"
	cHtml += "        				<td  width='100%'>Nr da fatura "+_cDoc+"."+"</td>"
	cHtml += "	  				</tr>"
	cHtml += '	 <br>'
	cHtml += "					<tr >"
	cHtml += "        				<td  width='100%'>Emitida Por:"+"</td>"
	cHtml += "	  				</tr>"
	cHtml += "					<tr>"
	cHtml += "        				<td  width='100%'>Emitente:BRASIL RISK GERENCIAMENTO DE RISCOS LTDA "+"</td>"
	cHtml += "	  				</tr>"
	cHtml += "					<tr>"
	cHtml += "        				<td  width='100%'>CNPJ: 19.404.076.0001-00"+"</td>"
	cHtml += "	  				</tr>"
	cHtml += "					<tr>"
	cHtml += "        				<td  width='100%'>CCM: 33371830"+"</td>"
	cHtml += "	  				</tr>"
	cHtml += '	 <br><br>'
	cHtml += "					<tr>"
	cHtml += "        				<td  width='100%'>Tomador de serviço:"+"</td>"
	cHtml += "	  				</tr>"
	cHtml += "					<tr>"
	cHtml += "        				<td  width='100%'>Razão Social JSL S/A"+"</td>"
	cHtml += "	  				</tr>"
	cHtml += "					<tr>"
	cHtml += "        				<td  width='100%'>CNPJ: 52548435002708"+"</td>"
	cHtml += "	  				</tr>"
	cHtml += '	 <br><br>'
	cHtml += "					<tr>"
	cHtml += "        				<td  width='100%'>Se preferir, visualize a nota fiscal de serviço no endereço:"+"</td>"
	cHtml += "	  				</tr>"
	cHtml += '	 <br><br>'
	cHtml += "					<tr>"
	cHtml += "        				<td  width='100%'>LINK NFE"+"</td>"
	cHtml += "	  				</tr>"
	cHtml += '	 <br><br>'
	cHtml += "					<tr>"
	cHtml += "        				<td  width='100%'>Alternativamente, acesso o portal link portal e verifique a autenticidade da nota fiscal informando:"+"</td>"
	cHtml += "	  				</tr>"
	cHtml += '	 <br><br>'
	cHtml += "					<tr>"
	cHtml += "        				<td  width='100%'>CNPJ do prestador de serviço = 6888683000141"+"</td>"
	cHtml += "	  				</tr>"
	cHtml += "					<tr>"
	cHtml += "        				<td  width='100%'>Numero da NFS "+_cDoc+"</td>"	
	cHtml += "	  				</tr>"
	cHtml += "	  			</table>"
	cHtml += "				<br />"
	cHtml += "				<table width='646' border='0' align='center' cellpadding='0' cellspacing='0'>
	cHtml += "		   		<tr>
	cHtml += "		   		</tr>
	cHtml += "				</table>
	cHtml += '	 <br>
	cHtml += "			</header>"
	cHtml += "	</body>"
	cHtml += "</html>"


	_cPara 	:= 'follha.totvs@brasilrisk.com.br'
	_cBCC	:= ""
	_cCC	:= 'follha.totvs@brasilrisk.com.br'
	_cTitulo:= ' Cobrança Brasil Risk '
	_aAnexo	:= aImgs
	_cMsg	:= cHtml
	_lAudit	:= .T.

	Processa({|| u_ENVWORK(_cPara,;										//_cPara
	_cCc,;										//_cCc
	"",;					   					//_cBmICROSIGACC
	_cTitulo,;									//_cTitulo
	_aAnexo,;									//_aAnexo
	_cMsg,;										//_cMsg
	.T.,;										//_lAudit
	_cMailFrom)},"Enviando e-mail...")

Return(Nil)
