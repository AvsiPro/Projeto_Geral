#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "fileio.ch"
#INCLUDE "TOPCONN.CH"

User Function ImpXMLNFE(cArqXML,lGeraOS)

Local aArq
Local cFile			:= ""
Local cType         := ""
Local I
Local _cCad			:= "Importa��o de XML"
Local _nOpc			:= 0
Local _aSay			:= {}
Local _aButton		:= {}

Private cPath		:= SuperGetMV("MV_XXMLPR",.T.,"\system\xml\")
Private cPathLocal	:= SuperGetMV("MV_XXMLPL",.T.,"")
Private cPathSchema := SuperGetMV("MV_XXMLPRS",.T.,"\system\xml\schemas\")
Private lBlqCHV		:= SuperGetMV("MV_XBLQCHV",.T.,.F.)
Private cTpChkProd	:= SuperGetMV("MV_XXMLPRD",.T.,"1")	// 1 - SA5 | 2 - EAN | 3 - Ambos
Private cLocPath	:= ""
Private lExecMenu	:= .F.				// Controla as Mensagens do programa - Se executado do menu ou via Job
Private cNomArq		:= ""
Private cArqLog		
Private nHdl		:= 0
Private lExistArq	:= .F.
Private lIniLog		:= .F.
Private llRet		:= .F.
Private lAtivaOS	:= SuperGetMV("MV_XWSK018",.T.,.F.)
Default cArqXML		:= ""
Default lGeraOS		:= .F.

cType := "Arquivo XML (*.XML) |*.xml|"



// Verifica se foi executado do menu
IF FunName() $ "IMPXMLNFE" .Or. IsInCallStack("U_TTCOMC07")
	lExecMenu := .T.
EndIf                     

// -> Caso seja executado via Job
If !lExecMenu
	While .T.
	     aArq := directory(cPath+"*.xml")
	     // -> Verifica se existem arquivos
	     If Len(aArq) == 0
	    	//ConOut("N�o existem arquivos para serem importados.")
	    	GeraLog("N�o existem arquivos para serem importados.") 	
	    	Exit
	     EndIf
	     // -> Processa arquivos
	     For nI := 1 To Len(aArq)
			cFile := Lower(aArq[nI][1])
			cArqLog := StrTran(cFile,".xml",".log")
			If File(cFile,2)
				CpyT2S(cFile,cPath)
			Else
				MsgAlert(OemToAnsi("O arquivo '") + cFile + OemToAnsi("' n�o foi encontrado. N�o ser� poss�vel continuar com a importa��o."))
				Return
			EndIf
	                     
			// Nome do arquivo
			cNomArq := xGetFile(cFile, @cLocPath)
			ConOut("Importando arquivo XML -> "+aArq[nI][1])
			XMLNFE(cFile)
	     Next nI
	
		If ! lJob	// Se nao for chamado como job sai apos a primeira iteracao
			Exit
	    EndIf
	    
	    Sleep(5000) // Aguarda 5 segundos para iniciar a verificacao!
	    
	EndDo
	
Else
	// Se for executado via Menu
	// Verifica se foi executado via Tela de escolha de Arquivos XML
	If IsInCallStack("U_TTCOMC07")
		If cArqXML <> ""
			cFile := Lower(cArqXML)
		EndIf
		If File(cFile,2)
			CpyT2S(cFile,cPath)
		Else
			MsgAlert(OemToAnsi("O arquivo '") + cFile + OemToAnsi("' n�o foi encontrado. N�o ser� poss�vel continuar com a importa��o."))
			Return
		EndIf            
		// Nome do arquivo
		cNomArq := xGetFile(cFile, @cLocPath)
		// Arquivo de Log - Salva no Servidor
		cArqLog := cPath +StrTran(cNomArq, ".xml",".log")
	    If Alltrim(cNomArq) <> ""
			MsAguarde({ || XMLNFE(cNomArq,lGeraOS)},"Importando arquivo XML...")
		EndIf
	Else
		Aadd(_aSay,"Importa��o de XML")          								   
		Aadd(_aSay,"")                                                             
		Aadd(_aSay,"Para prosseguir com a importa��o, clique em <Ok>.")            
		Aadd(_aSay,"Para sair desta rotina, clique em <Cancelar>")                 
		Aadd(_aButton,{1,.T.,{|| _nOpc := 1, FechaBatch()}})                       
		Aadd(_aButton,{2,.T.,{|| FechaBatch()}})                                   
		FormBatch(_cCad,_aSay,_aButton)                                            
	
		If _nOpc == 1                                                                	
			cFile := cGetFile(cType, OemToAnsi("Selecione o arquivo a ser importado"), 0, "C:\", .T., GETF_LOCALHARD, .F., .F.)          
			If !Empty(cFile)
				cFile := Lower(cFile)
				If File(cFile,2)
					CpyT2S(cFile,cPath)
				Else
					MsgAlert(OemToAnsi("O arquivo '") + cFile + OemToAnsi("' n�o foi encontrado. N�o ser� poss�vel continuar com a importa��o."))
					Return
				EndIf
				// Nome do arquivo
				cNomArq := xGetFile(cFile, @cLocPath)
				// Arquivo de Log - Salva no Servidor
				cArqLog := cPath +StrTran(cNomArq, ".xml",".log")
			    If Alltrim(cNomArq) <> ""
					MsAguarde({ || XMLNFE(cNomArq,lGeraOS)},"Importando arquivo XML...")
				EndIf
			EndIf
		EndIf
	EndIf
EndIf	


Return llRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XMLNfe �Autor  �Jackson E. de Deus  	 � Data �  05/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Faz o processamento de todo o arquivo e gera a Pr�-Nota.   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ImpXMLNFE()                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function XMLNfe(cFile,lGeraOS)

Local cError		:= ""
Local cWarning		:= ""
Local oXml			:= NIL
Local oXmlWS		:= NIL	// Objeto XML que ser� utilizado na abertura da OS no Keeple
Local cPathProc		:= ""	// Path de destino dos xmls processados
Local lCadOk		:= .F.
Local nI                      
Local llVld			:= .F.
Local cRetChv		:= ""
Local aPergs		:= {}	// Utilizado no ParamBox no inicio da execu��o
Local aRet			:= {}	// Utilizado no ParamBox no inicio da execu��o
Local aOpcoes		:= {}	// Opcoes do Parambox
Local cTagAnt		:= ""
Local cTagAtu		:= ""
Local lPrimeira		:= .T.

Private cNum				// Numero da Nota
Private cFornec		:= ""   // Fornecedor
Private cLjFornec	:= ""	// Loja
Private cNomeFor	:= ""
Private cEstFor 
Private cDtEmissao
Private	cForCond	:=	""
Private cForEst		:=	""
Private cCNPJ_FIL			// Cnpj da Loja
Private cCNPJ_FOR			// Cnpj da Loja
Private cDtEmissao
Private cCcd				// Centro de Custo
Private cFilorig			// Filial de Origem
Private nDescVar
Private nDescNota
Private nDescItens
Private nIcms
Private nIcmsRet
Private nIcmsRepa
Private nIcmsSubs
Private nSeguro
Private nFrete
Private nAdicional
Private nIcmsPer
Private nIcmsBase
Private cSerie		:= ""	// S�rie
Private cTipo		:= "N"	// Tipo
Private nCont
Private cCodigo
Private cDescProd
Private cUM
Private bLote
Private cLote
Private cValidade
Private cCodBarra
Private nQuant
Private nPrcUnLiq
Private nDescItem			// %
Private nValDesc			// $
Private nItem		:= 0
Private bMed
Private nContLote			// Contador do For
Private nTotalMed			// Len do Array Med
Private nQtdeLote			// Qtde do Lote Atual
Private nDescLote			// Desconto do Lote Atual
Private nValLote			// Valor do Lote Atual
Private nDescTT				// Acumulado do Desconto
Private nValorTT			// Acumulado
Private cUnidad				// Unidade do fornecedor
Private nFator				// Fator de Conversao
Private nNumItens
Private nNumUnid
Private nTotalMerc
Private cNumTitulo
Private nValor
Private cVencimento
Private nDescDia
Private nDescFin
Private nJurosDia
Private nMulta
Private nAcrescimo
Private cChave_NFe	:= ""	// Chave de Acesso da NFe
Private aCabec		:= {}	// Array de cabecalho da NF - para ExecAuto
Private aItens		:= {}	// Array de itens da NF - para ExecAuto
Private aLinha		:= {}	// Array de linhas da NF - para ExecAuto	
Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .T.
Private cFound		:= 0	// Resultado de Busca
Private aItensXML			// Itens do arquivo XML 
Private aRotina		:= {{"Visualizar"	,"A103NFiscal('SF1',Recno(),2)"	,0,1}}
Private aProdInt	:= {}	// produtos internos
Private aPedido		:= {}	// Dados dos Pedidos de Compra do Fornecedor 
Private aRelaProd	:= {}	// Relacao Itens NF x Itens Empresa
Private cNumPed		:= ""	// Numero do Pedido de Compra
Private lExistXPed	:= .F.	// controle - se existe a TAG xPed no XML
Private nExistTag	:= 0	// qtd de Tags xPed que existem no arquivo XML
Private lVzRelaPrd	:= .T.	// controle - se existe a relacao de itens nf x itens empresa
Private cItemPC		:= ""	// Item do Pedido de Compra - para ser usado nos istens do Array para o ExecAuto
Private cPedEmissao			// Data de Emissao do Pedido de Compra
Private cPedAtual	:= ""	// N�mero do Pedido Atual - para ser usado nos itens do Array para o ExecAuto
Private lPedTotal	:= .F.	// vari�vel de controle - Importa��o utilizando somente um Pedido
Private lPedParc	:= .F.	// vari�vel de controle - Importa��o utilizando mais de um Pedido
Private lPedSem		:= .F.	// vari�vel de controle - Importa��o sem Pedido
Private cPedTotVlr	:= ""	// Valor Total do Pedido de Compra - Somente para Importa��o com somente 1 Pedido
 

MsProcTxt("Iniciando leitura do arquivo..")
// Gera o objeto com dados do XML
oXml := XmlParserFile( cPath+cFile, "_", @cError, @cWarning )
If ValType(oXml) != "O"
     Alert(cFile+" - "+cError)
     Return()
Endif

// Objeto XML para ser utilizado no WS do Keeple - copiado pois o Objeto original tera sua estrutura modificada
oXmLWS := oXML

cVersaoNFE := oXML:_nfeProc:_versao:TEXT

// -> Verifica se NF est� autorizada na Sefaz
MsProcTxt("Verificando a chave de acesso na Sefaz..")
cChave_NFe := SubStr(oxml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4)

If Empty(cChave_NFe)
	MsgAlert("A chave de acesso n�o foi informada!","XMLNFE")
	Return
EndIf                                

If lBlqCHV
	ConsNFeChave(cChave_NFe,@cRetChv)
	If !"AUTORIZADO" $ cRetChv
		cRetChv += +CRLF +"Chave NFe: " +cChave_NFe
		MsgAlert(cRetChv,"XMLNfe")
		Return  
	EndIf
EndIf
	
// Mostra op��o de escolha ao usu�rio - Utiliza Pedido Total ou Parcial
aOpcoes := { "Pedido Total", "Pedido Parcial" }//{ "Pedido Total", "Pedido Parcial", "Sem Pedido" }
aAdd(aPergs ,{2,"Tipo de Importa��o"	,"Pedido Parcial",aOpcoes,50,".T.",.T.})	// Tipo de Importa��o

If !ParamBox(aPergs ,"Tipo de Importa��o",aRet)
	Return
EndIf

// Prepara vari�veis l�gicas
For nI := 1 To Len(aRet)
	If aRet[nI] == "Pedido Total"
		lPedTotal := .T.
	ElseIf aRet[nI] == "Pedido Parcial"
		lPedTotal := .F.
	ElseIf aRet[nI] == "Sem Pedido"
		lPedSem	:= .T.	
	EndIf
Next nI

// Se a Tag NFEPROC:NFE:INFNFE:_DET for Objeto
If ValType(oXml:_NfeProc:_Nfe:_InfNfe:_DET) = "O"
     XmlNode2Arr(oXml:_NfeProc:_Nfe:_InfNfe:_DET, "_DET")
EndIf

// Gera Array com os dados dos produtos do XML
aItensXML	:= oXML:_nfeProc:_NFe:_infNFe:_Det
aItensXML	:= IIf(ValType(aItensXML)=="O", {aItensXML}, aItensXML)

If Len(aItensXML) == 0
	MsgAlert("Erro na estrutura dos Itens do arquivo XML!", "XMLNfe")
	Return
EndIf

// Inicializa as variaveis de controle
nError := 0
cFilorig := "XX"

cCNPJ_FIL := oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT

MsProcTxt("Verificando filial: " +cEmpAnt)
OpenSm0()
SM0->(dbGoTop())
While !SM0->(Eof())
     If cEmpAnt != SM0->M0_CODIGO
          SM0->(dbskip()) // ignora filiais que nao sejam da empresa ativa.
          loop
     Endif
     
     If cCNPJ_FIL == SM0->M0_CGC
          cFilorig := SM0->M0_CODFIL
          Exit //Forca a saida
     Endif
     
     SM0->(dbskip())
EndDo


cCNPJ_FOR := oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
MsProcTxt("Verificando fornecedor: " +cCNPJ_FOR)
DBSelectArea("SA2")
DBSetOrder(3)
If DbSeek(xFilial("SA2")+cCNPJ_FOR)
	cFornec		:= SA2->A2_COD
	cLjFornec	:= SA2->A2_LOJA
	cEstFor		:= SA2->A2_EST
	cNomeFor	:= SA2->A2_NOME
	cForCond	:= SA2->A2_COND
Else
	If lExecMenu
		Alert(OemToAnsi("Fornecedor inexistente! " + cCNPJ_FOR +CRLF))
	EndIf
     GeraLog("Fornecedor inexistente!" + cCNPJ_FOR +CRLF)
     cError += "Fornecedor inexistente!" + cCNPJ_FOR +CRLF
     nError += 1
Endif

cNum	:= PadL(Alltrim(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,"0") //Nro da Nota
cSerie	:= PadR(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text,3," ")


// -> Verifica se j� existe essa NF na base de dados
MsProcTxt("Verificando exist�ncia da Nota Fiscal: " +cNum)
DBSelectArea("SF1")
DbSetorder(1)
If DbSeek(cFilorig+AvKey(cNum,"F1_DOC")+AvKey(cSerie,"F1_SERIE")+AvKey(cFornec,"F1_FORNECE")+AvKey(cLjFornec,"F1_LOJA")+AvKey(cTipo,"F1_TIPO")/*,.T.*/)
	If lExecMenu
		Alert(OemToAnsi("A Nota Fiscal " +cNum +"/" +cSerie +" j� consta no sistema."))
		GeraLog("A Nota Fiscal " +cNum +"/" +cSerie +" j� consta no sistema."  +CRLF)
		FClose(nHdl)
		Return()
	Else
		ConOut("Nao importada. Nota Fiscal j� consta no sistema." + cFornec+"/"+cLjFornec +CRLF)
		GeraLog("Nao importada. Nota Fiscal j� consta no sistema." + cFornec+"/"+cLjFornec +CRLF)
		FClose(nHdl)
		Return()
	EndIf
EndIf     

nNumItens	:= Len(oXml:_NfeProc:_Nfe:_InfNfe:_DET)

If cVersaoNFE == "2.00"                                   
	cDtEmissao	:= oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dEmi:Text
Else
	cDtEmissao	:= oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dhEmi:Text
EndIf

cDtEmissao	:= Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4)

// Valor Mercadorias
nTotalMerc	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:Text)
              
// -> Inicializa a variavel para realizar o somatorio de descontos da nota.
//nDescTT = 0 
//nTotalBrt = Val(Substr(cBuffer,69,12))/100

//nDescVar	:= Val(Substr(cBuffer,1,13))/100
nDescNota	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:Text)

//nDescItens	:= Val(Substr(cBuffer,29,13))/100
//nIcms			:= Val(Substr(cBuffer,1,13))/100
//nIcmsRet		:= Val(Substr(cBuffer,14,13))/100
//nIcmsRepa		:= Val(Substr(cBuffer,117,13))/100

cNumTitulo      := cNum
nValor          := Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:Text)

If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT , "VOUTRO" ) != Nil
	nAcrescimo := Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:Text)
Else
     nAcrescimo := 0
Endif

cVencimento := ""

If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE , "_COBR" ) != Nil
// Voltar mas tem que alterar para aceitar varias parcelas.
// cVencimento	:= oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP:_DVENC:Text
// cVencimento	:= Substr(cVencimento,9,2)+"/"+Substr(cVencimento,6,2)+"/"+Substr(cVencimento,1,4)
EndIf

nFrete	:= 0
nSeguro	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VSeg:Text)

nIcmsSubs	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:Text)

// Se for importa��o com Pedido, verifica se XML possui as tags xPed e nItemPed
//MsProcTxt("Buscando informa��es do Pedido de Compra...") 
If !lPedSem
	MsProcTxt("Verificando tags xPed do arquivo XML...") 
	For nCont := 1 To nNumItens
		If XmlChildEx(oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD, "_xPed") != Nil .And. XmlChildEx(oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD, "_nItemPed") != Nil
		    nExistTag++	
		EndIf
	Next
	                    
	// Verifica se Todas as TAGS possuem o numero do Pedido de Compras e o numero do Item
	If nExistTag == nNumItens
	    lExistxPed := .T.
	EndIf
	
	If lExistxPed
		// Verifica se � o mesmo Pedido de Compra em todas as TAGS
		cTagAnt := ""
		cTagAtu	:= ""
		lPrimeira := .T.
		For nCont := 1 To nNumItens                                        
			If lPrimeira
				cTagAnt := oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD:_xPed:Text
			EndIf
			
			If !lPrimeira
				cTagAtual := oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD:_xPed:Text
				If cTagAtual <> cTagAnt
					lPedUnico := .F.
					Exit
				EndIf
			EndIf
			lPrimeira := .F.			
		Next
	
		// Vai utilizar o mesmo numero de Pedido para todos os itens
		If lPedUnico
			lPedTotal := .T.
			cNumPed := oXml:_NfeProc:_Nfe:_InfNfe:_DET[1]:_PROD:_xPed:Text
			
			// Busca itens do pedido de compra com base no pedido de compra do XML
			// Alimenta Array aPedido
			ItensPed()	
		EndIf
	Else                                                                
		// Mostra tela para que o usu�rio escolha o Pedido - somente se for Pedido Total
		// Alimenta Array aPedido - IMPORTANTE - Utilizado em v�rios lugares no programa
		If lPedTotal
			buscaPed()	
		EndIf	
	EndIf  
EndIf
 
MsProcTxt("Verificando cadastro de Produtos x Fornecedor...")
// Verifica Produtos - amarra��o
lCadOk	:= ValProd(cFornec, cLjFornec, aItensXML)

// Se cancelou, sai do programa pois sem o relacionamento nao pode continuar
If !lCadOK
	Return     
EndIf
                                         

// Se Itens est�o Ok - Processa
If lCadOk
	For nCont := 1 To nNumItens
		If !lExecMenu
			ConOut("Processando Item: " +CValToChar(nCont) +" C�d.: "+oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_xProd:Text)
		Else
			MsProcTxt("Processando Item: " +CValToChar(nCont) +" C�d.: "+oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_xProd:Text)
		EndIf

		cCodBarra	:= oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_CEAN:Text
		cCodForn	:= PadR(oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_CPROD:Text,TamSX3("A5_CODPRF")[1])
		nQuant		:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_QCOM:Text)
		cUnidad		:= AllTrim(oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD:_UCOM:TEXT)
		nPrcUnBrt   := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_VUNCOM:Text)
		nPrcTtBrt   := nQuant * nPrcUnBrt
	     
		If XmlChildEx(oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD, "_VDESC") != Nil
			nValDesc     := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_VDESC:Text)
		Else
			nValDesc     := 0
		EndIf
	     
		/*-------------------------------------------------------------------+
		| -> Busca o Codigo interno do produto.								 |
		| Ordem de busca:													 |
		| Busca na tabela SA5 - Produto x Fornecedor						 |
		| Busca na tabela SB1 - pelo EAN (c�digo de barras)					 |
		+-------------------------------------------------------------------*/		
		// Caso o produto ja tenha a amarra��o, vai entrar aqui
		dbSelectArea("SA5")
		dbSetOrder(5)
		bOkItem := .F. 
		If !bOkItem .And. !Empty(cCodForn)     
			If SA5->(dbSeek(xFilial("SA5")+ cCodForn ))			
				While AllTrim(SA5->A5_CODPRF) == AllTrim(cCodForn)
					If SA5->(A5_FORNECE+A5_LOJA) == cFornec+cLjFornec
						bOkItem := .T.
						cCodigo := SA5->A5_PRODUTO
						Exit                      						
					Endif
					DbSkip()
				EndDo
			EndIf
		EndIf
	     
		// Caso o produto ainda nao tenha a amarracao mas tenha o c�digo EAN, vai entrar aqui
		If bOkItem == .F. .And. !Empty(cCodBarra)
			dbSelectArea("SB1")
			dbSetOrder(5)	// filial+ean
			If SB1->(dbSeek(xFilial("SB1")+cCodBarra))
				cCodigo := SB1->B1_COD               
	   			// Verifica se existe uma amarracao para o produto encontrado
				dbSelectArea("SA5")
				dbSetOrder(2)
				If !DBSeek(xFilial("SA5")+cCodigo+cFornec+cLjFornec)
					// Inclui a amarracao do produto X Fornecedor
					RecLock("SA5",.T.)
					A5_FILIAL     := xFilial("SA5")
					A5_FORNECE    := cFornec
					A5_LOJA       := cLjFornec
					A5_NOMEFOR    := SA2->A2_NOME
					A5_PRODUTO    := cCodigo
					A5_NOMPROD    := SB1->B1_DESC
					A5_CODPRF     := cCodForn
					MSUnLock()
	                    
					GeraLog("Produto sem amarracao: "+AllTrim(cCodForn)+" -> "+AllTrim(cCodigo)+" -> Incluido" +CRLF)
					cError += "Produto sem amarracao: "+AllTrim(cCodForn)+" -> "+AllTrim(cCodigo)+" -> Incluido" +CRLF
					bOkItem := .T.
				Else
					If Alltrim(SA5->A5_CODPRF) == "" .Or. AllTrim(SA5->A5_CODPRF) == "0" // Atualiza a amarracao se nao tiver o codigo do fornecedor cadastrado.         
						RecLock("SA5",.F.)
						A5_CODPRF     := cCodForn
						MSUnLock()
	                         
						GeraLog("Produto sem amarracao: "+AllTrim(cCodForn)+" ->: "+AllTrim(cCodigo)+" -> Atualizado" + CRLF)
						cError += "Produto sem amarracao: "+AllTrim(cCodForn)+" ->: "+AllTrim(cCodigo)+" -> Atualizado" + CRLF
						bOkItem := .T.
					EndIf
				EndIf
			EndIf
	    EndIf
	        
	    /*----------------------------------------------------------------------------------------------+
 		| -> Busca o Pedido de Compra																	|
 		| Primeiro Verifica se o Array aRelaProd (rela��o de produto xml x produto pedido)				|
 		| Se Array esteja vazio, procura em Array aPedido, que deve ser preenchido quando houver pedido	|
 		| Se Array aRelaProd possuir informa��o, procura o n�mero do item nele.							|
 		+----------------------------------------------------------------------------------------------*/
	    If !lPedSem		// Somente se for importa��o com Pedido de Compra
		    cPedAtual := ""
		    
		    // -> Se utiliza Pedido Total, � somente um Pedido
		    If lPedTotal
		    	cPedAtual := cNumPed
		    // Caso contr�rio, tem que procurar o Item atual no Array aRelaProd para encontrar a qual Pedido pertence	
		    Else
		    	If Len(aRelaProd) > 0
			    	For nI := 1 To Len(aRelaProd)	
		    			If AllTrim(cCodigo) == Alltrim(aRelaProd[nI][3])
							cPedAtual := aRelaProd[nI][1]	 
							Exit 
						EndIf
					Next nI
		    	EndIf
		    EndIf
	    EndIf
	    
 		/*----------------------------------------------------------------------------------------------+
 		| -> Busca o Item do Pedido de Compra															|
 		| Primeiro Verifica se o Array aRelaProd (rela��o de produto xml x produto pedido)				|
 		| Se Array esteja vazio, procura em Array aPedido, que deve ser preenchido quando houver pedido	|
 		| Se Array aRelaProd possuir informa��o, procura o n�mero do item nele.							|
 		+----------------------------------------------------------------------------------------------*/
 		If !lPedSem		// Somente se for importa��o com Pedido de Compra
	 		cItemPC := ""
			If bOkItem
		 		//If lVzRelaPrd .And. Len(aRelaProd) == 0
		 		If Len(aRelaProd) > 0 
					For nI := 1 To Len(aRelaProd)
						// Se codigo do Produto estiver em aRelaProd
						If AllTrim(cCodigo) == Alltrim(aRelaProd[nI][3])
							cItemPC := aRelaProd[nI][2]	 
							Exit                                                              
						EndIf	
					Next nI
					
				// Caso aRelaProd possua informa��o	
				Else
		    		If Len(aPedido) > 0
		 				For nI := 1 To Len(aPedido)
							If AllTrim(cCodigo) == AllTrim(aPedido[nI][3])
								cItemPC := aPedido[nI][2]
								Exit
							EndIf
						Next nI
		             EndIf
				EndIf
			Else     
			/*Trata os casos onde nao existe a amarracao na SA5 e o xml veio sem o EAN*/
				If Len(aRelaProd) > 0 
					For nI := 1 To Len(aRelaProd)
						// Se codigo do Produto estiver em aRelaProd
						If AllTrim(cCodForn) == Alltrim(aRelaProd[nI][4])
							cCodigo := aRelaProd[nI][3]	 
							Exit                                                              
						EndIf	
					Next nI
					
				// Caso aRelaProd possua informa��o	
				Else
		    		If Len(aPedido) > 0
		 				For nI := 1 To Len(aPedido)
							If AllTrim(cCodForn) == AllTrim(aPedido[nI][4])
								cCodigo := aPedido[nI][3]
								Exit
							EndIf
						Next nI
		             EndIf
				EndIf
				// Inclui a amarracao do produto X Fornecedor
				RecLock("SA5",.T.)
				A5_FILIAL     := xFilial("SA5")
				A5_FORNECE    := cFornec
				A5_LOJA       := cLjFornec
				A5_NOMEFOR    := SA2->A2_NOME
				A5_PRODUTO    := cCodigo
				A5_NOMPROD    := SB1->B1_DESC
				A5_CODPRF     := cCodForn
				MSUnLock()
                    
				GeraLog("Produto sem amarracao: "+AllTrim(cCodForn)+" -> "+AllTrim(cCodigo)+" -> Incluido" +CRLF)
				cError += "Produto sem amarracao: "+AllTrim(cCodForn)+" -> "+AllTrim(cCodigo)+" -> Incluido" +CRLF
				bOkItem := .T.
			EndIf        
	    EndIf
	    
		If !bOkItem
			GeraLog("Produto sem amarracao: "+AllTrim(cCodForn)+" - "+AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_xProd:Text) +" - Codigo de barras: "+AllTrim(cCodBarra) +CRLF)
			cError += "Produto sem amarracao: "+AllTrim(cCodForn)+" - "+AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_xProd:Text) +" - Codigo de barras: "+AllTrim(cCodBarra) +CRLF
			nError += 1
	 	Else 
			//IIf(lExistCod,cCodigo := RetPrd(cFornec,cLjFornec,cCodForn),Nil)
			// Posiciona no produto encontrado
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+cCodigo)
        
	        If SB1->B1_MSBLQL = '1'
	        	GeraLog("Produto Bloqueado: "+AllTrim(cCodigo)+" - "+AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_xProd:Text) +" - Codigo de barras: "+AllTrim(cCodBarra) +CRLF)
	        	cError += "Produto Bloqueado: "+AllTrim(cCodigo)+" - "+AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_xProd:Text) +" - Codigo de barras: "+AllTrim(cCodBarra) +CRLF
	
				If lExecMenu
					Alert(OemToAnsi("Este produto: "+cCodigo +" est� bloqueado."))
					GeraLog("Este produto: "+cCodigo +" est� bloqueado.")
				Else
					ConOut("Este produto: "+cCodigo +" est� bloqueado.")
					GeraLog("Este produto: "+cCodigo +" est� bloqueado.")
				EndIf
	
	            nError += 1
	        Endif
	        nFator := 1
			
		    // Se a Unidade de medida do fornecedor for diferente da unidade de medida da empresa 
			If UPPER(cUnidad) <> SB1->B1_UM
				nFator := SB1->B1_CONV        
				
				// Converte de Unidade -> Kilo [Multiplica a Qtd pelo fator de convers�o do produto]
				If UPPER(cUnidad) $ "UN|PT"
					If SB1->B1_UM $ "KG|ML"
						nQuant := nQuant*nFator
					EndIf
				// Converte de Kilo -> Unidade [Divide a Qtd pelo fator de convers�o do produto]
				ElseIf UPPER(cUnidad) $ "KG|ML"
					If SB1->B1_UM $ "UN|PT"
						nQuant := nQuant/nFator
					EndIf
				// Converte de Caixa -> Unidade
				ElseIf UPPER(cUnidad) $ "CX"
					/*---------------------------------------------------------------------
					// De Unidade para Caixa - divide | de Caixa para Unidade - multiplica
					-----------------------------------------------------------------------
					Ex:            
					Qtd do Prod. = 250 
					Fator Conv. = 30
									
					UN			->		CX
					250/30
									
					CX			->		UN
					250*30
					7500
					---------------------------------------------------------------------*/
					// [Multiplica a Qtd pelo fator de convers�o do produto]
					If cUnidad == AllTrim(SB1->B1_SEGUM) .And. ( AllTrim(SB1->B1_UM) == "UN" .OR. AllTrim(SB1->B1_UM) == "PT" )
						nQuant := nQuant*nFator																								
					EndIf	
				EndIf
			EndIf	
	               
			//Verifica se possui Node _Med
			bMed := XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod , "_MED" ) != Nil
	     
	     	If bMed
				// Converte o Node Med em array para os casos que existe informacao de mais de um lote do mesmo produto.          
	            If ValType(oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD:_MED) = "O"
	   				XmlNode2Arr(oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD:_MED, "_MED")
	       		EndIf
	
				nTotalMed := len(oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD:_MED)
			Else
				nTotalMed := 1
				nQtdeLote := nQuant
				cLote     := ""
				cValidade := ""
			Endif
	                 
	          // Acumuladores
			nDescTT   := 0
			nValorTT := 0
			
			For nContLote := 1 to nTotalMed
				nItem++
				aLinha    := {}
	                           
				If bMed
					cLote     := oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_MED[nContLote]:_NLote:Text
					cValidade := oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_MED[nContLote]:_DVal:Text
					cValidade := Substr(cValidade,9,2)+"/"+Substr(cValidade,6,2)+"/"+Substr(cValidade,1,4)
					nQtdeLote := val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[nCont]:_Prod:_MED[nContLote]:_QLote:Text)
	            EndIf
	            
				If nContLote != nTotalMed
					nDescLote := Round(nValDesc/nQuant*nQtdeLote,2) // Desconto do Lote Atual
					nValLote := Round(nPrcTtBrt/nQuant*nQtdeLote,2) // Valor do Lote Atual
					nDescTT   += nDescLote
					nValorTT += nValLote                    
	            Else
					nDescLote := nValDesc - nDescTT // Desconto do Lote Atual - Diferenca
					nValLote := nPrcTtBrt - nValorTT // Valor do Lote Atual - Diferenca
	            EndIf
	               
				// -> Alimenta Array dos Itens
				Aadd(aLinha,	{"D1_ITEM"		, STRZERO(nItem,4)		, Nil})
				Aadd(aLinha,	{"D1_FILIAL"	, cFilorig				, Nil})
				Aadd(aLinha,	{"D1_COD"		, cCodigo				, Nil})
				Aadd(aLinha,	{"D1_QUANT"		, nQtdeLote				, Nil})
				Aadd(aLinha,	{"D1_VUNIT"		, nValLote/nQtdeLote	, Nil})
				Aadd(aLinha,	{"D1_TOTAL"		, nValLote				, Nil}) //Valor total proporcional
				Aadd(aLinha,	{"D1_VALDESC"	, nDescLote				, Nil}) //Valor Desconto proporcional /*nValDesc/nQuant*nQuantLt*/
				
				// Caso seja importa��o sem Pedido, n�o adiciona o Pedido/Item
				If !lPedSem
					Aadd(aLinha,	{"D1_PEDIDO"	, cPedAtual				, Nil}) // Numero do Pedido de Compra
					Aadd(aLinha,	{"D1_ITEMPC"	, cItemPC				, Nil}) // Numero do Item do Pedido de Compra
				EndIf
				
				// Incluir sempre no ultimo elemento do array de cada item
				Aadd(aLinha,{"AUTDELETA"	, "N"					,Nil}) 
				Aadd(aItens,aLinha)
	          Next
	     EndIf
	Next
	
EndIf
	
// -> Verifica se Array de Itens est� com mesma quantidade de itens do XML
If Len(aItens) != Len(aItensXML)
	nError++
	GeraLog("Inconsist�ncia - Houve problema na busca de todos os produtos." +CRLF)
	cError += "Inconsist�ncia - Houve problema na busca de todos os produtos." +CRLF
EndIf

// -> Alimenta Array do cabe�alho
If nError == 0   
	aadd(aCabec,	{"F1_TIPO"		, "N"									,NIL})
	aadd(aCabec,	{"F1_FORMUL"	, "N"									,NIL})
	aadd(aCabec,	{"F1_DOC"		, cNum									,NIL})
	aadd(aCabec,	{"F1_SERIE"		, cSerie								,NIL})
	aadd(aCabec,	{"F1_EMISSAO"	, ctod(cDtEmissao)						,NIL})
	aadd(aCabec,	{"F1_FORNECE"	, cFornec								,NIL})
	aadd(aCabec,	{"F1_LOJA"		, cLjFornec								,NIL})
	aadd(aCabec,	{"F1_ESPECIE"	, "SPED"								,NIL})
	aAdd(aCabec,	{"F1_COND"		, cForCond								,NIL})
	aAdd(aCabec,	{"F1_EST"		, cEstFor 								,NIL})
	aadd(aCabec,	{"F1_SEGURO"	, nSeguro								,NIL})
	aadd(aCabec,	{"F1_FRETE"		, nFrete								,NIL})
	aadd(aCabec,	{"F1_VALMERC"	, nTotalMerc							,NIL})
	aadd(aCabec,	{"F1_VALBRUT"	, nTotalMerc+nSeguro+nFrete+nIcmsSubs	,NIL})
	aAdd(aCabec,	{"F1_CHVNFE"	, cChave_NFe        					,NIL})
 
	MsProcTxt("Salvando Nota Fiscal na base de dados")
	BeginTran()
     
	/* Alteracao da filial corrente. */
	cFilAtu := cFilAnt
	cFilAnt := cFilOrig
	MATA140(aCabec,aItens,3)		// Pr�-Nota
	//MATA103(aCabec,aItens,3,.t.)	// Documento de Entrada
	cFilAnt := cFilAtu
     
	If !lMsErroAuto
		EndTran() 
		// Salva Log na tabela SZL
		If FindFunction("U_TTGENC01")
			U_TTGENC01(xFilial("SF1"),"IMPXMLNFE","Importa��o de NFe","",SF1->F1_DOC,"",cusername,dtos(ddatabase),time(),,"NFe importada com sucesso.",SF1->F1_FORNECE,SF1->F1_LOJA,"SF1")	
		EndIf
		If lExecMenu .And. !IsInCallStack("U_TTCOMC07")
			If MsgYesNo("O arquivo XML foi importado com sucesso!" +CRLF +"Deseja visualizar a Pr�-Nota?")
				A103NFiscal('SF1',Recno(),1)
			EndIf
			
			If MsgYesNO("Deseja gerar a Confer�ncia cega para essa Nfe?")
				lGeraOs := .T.
			EndIf
		EndIf
		GeraLog("Nota Fiscal incluida com sucesso." +CRLF)
		// Retorno
		llRet := .T.
		
		/*----------------------------------------+ 
		| Gera OS no Web Service do Equipe Remota |
		+----------------------------------------*/
		If lGeraOS .And. lAtivaOS
			If FindFunction("U_TTCOMC09")
			    U_TTCOMC09()               
		    EndIf
		EndIf
	Else
		If lExecMenu
			MostraErro()
			GeraLog("Erro no ExecAuto." +CRLF)
		EndIf
		GeraLog("Erro na Inclusao da Nota Fiscal." +CRLF)
		cError += "Erro na Inclusao da Nota Fiscal." +CRLF
		lMsErroAuto := .F.
		FRename(cPath+cFile, cPath+substr(cFile,1,at(".xml",cFile)-1) +".auto")
		nError += 1
		DisarmTransaction()	// desfaz as alteracoes ja efetuadas.
	EndIf   
	MSUnlockAll()
EndIf
 		
// -> Se houve erros
If nError > 0           
	If lExecMenu
		VerErro(cError)
	Else
		ConOut("Houve erros na importa��o. Tente novamente.")
	EndIf                                                    
	cError += "Houve erros na importa��o. Tente novamente." +CRLF
	FRename(cPath+cFile, cPath+substr(cFile,1,at(".xml",cFile)-1) +".err")
Else
	FRename(cPath+cFile, cPath+substr(cFile,1,at(".xml",cFile)-1) +".imp")
	// Atribui ao final do path
	If cEmpAnt == "01"
		cPathLocal += "TT\"
	ElseIf cEmpAnt == "11"
		cPathLocal += "DDC\"
	EndIf
	// Move o arquivo xml para o diret�rio de arquivos processados
	cArqXML := xGetFile(cFile, cPathLocal)
	// Altera o nome do diretorio de destino para Path + Filial + CNPJ do Fornecedor
	cPathProc += cPathLocal +cFilOrig +"\" +cCNPJ_FOR +"\"      
	// Se nao existir o diretorio da filial, cria
	If !ExistDir(cPathLocal+cFilOrig)
		MakeDir(cPathLocal +cFilOrig)
	EndIf
	// Se nao existir o diretorio do fornecedor (cnpj), cria
	If !ExistDir(cPathLocal +cFilOrig +"\" +cCNPJ_FOR)
		MakeDir(cPathLocal +cFilOrig +"\" +cCNPJ_FOR)
		FRename(cPathLocal +cArqXML, cPathProc+cArqXML)
	Else
		FRename(cPathLocal +cArqXML, cPathProc+cArqXML)					
	EndIf
Endif


nItem	:= 0
//nErrorItem := 0
aCabec	:= {}
aItens	:= {}
aLinha	:= {}

// Fecha Arquivo de Log
FClose(nHdl)

lExistArq	:= .F.
lIniLog		:= .F.


Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xGetFile �Autor  �Jackson E. de Deus   � Data �  05/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Separa Arquivo do Path                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � XMLNfe()                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xGetFile(cArq, cPath)

Local cBarra  := "\"
Local nPos    := AT(cBarra,cArq)

Default cArq := ""
Default cPath := "" 

While nPos > 0                     
	cPath += SubStr(cArq, 1, nPos)
	cArq  := SubStr(cArq, nPos + 1)
	nPos := AT(cBarra, cArq)
Enddo

Return cArq



  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraLog   �Autor  �Jackson E. de Deus  � Data �  05/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Alimenta arquivo de Log durante a execu��o do programa.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GeraLog(cTexto)

Local cCabec	:= ""
Local cTime		:= TIME()

// Monta cabe�alho do Log
cCabec += "Log de importa��o de arquivo XML" +CRLF +CRLF
cCabec += "Arquivo: " +cArqLog	+CRLF           
cCabec += "Data: "+DTOC(Date()) +CRLF
cCabec += "Hora: "+cTime		+CRLF +CRLF
cCabec += "Ocorr�ncias" +CRLF +CRLF

// Verifica se arquivo j� foi criado
If !lExistArq
	nHdl := FCreate(cArqLog)
	
	If nHdl == -1
		If lExecMenu
			Alert(OemToAnsi("Erro ao gerar o arquivo de Log." +CRLF +"O Log n�o ser� gerado."))
			Return
		EndIf
	Else
		lExistArq := .T.
	EndIf
	
EndIf
     
// Verifica se o cabe�alho do Log ja foi iniciado
If !lIniLog
	FWrite(nHdl, cCabec)
	lIniLog := .T.
Else
	FWrite(nHdl, cTexto)	
EndIf


Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValProd �Autor  �Jackson E. de Deus  		� Data � 02/05/13���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina que verifica a amarracao entre					  ���
���          � Produto X Fornecedor								          ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValProd(cCodFrn, cLojaFrn, aItensXML)
 
Local aArea		:= GetArea()
Local aAreaAux	:= Array(0)
Local cQuery	:= ""
Local cProdsForn := ""
Local aAux		:= {}
Local nI		:= 0
Local aItensCad := Array(0)
Local aItens	:= {}
Local cCodItem	:= ""
Local cDescItem	:= ""
Local lFound	:= .F.
Local lRet		:= .F.
Local cNumItem	:= ""

If lPedSem
	// prepara a variavel cProdsForn
	For nI := 1 To Len(aItensXML)
		If nI <> Len(aItensXML)
			cProdsForn += "'"	                      
			cProdsForn += PadR(aItensXML[nI]:_Prod:_cProd:Text,TamSX3("A5_CODPRF")[1])
			cProdsForn += "',"    
		Else
			cProdsForn += "'"	                      
			cProdsForn += PadR(aItensXML[nI]:_Prod:_cProd:Text,TamSX3("A5_CODPRF")[1])
			cProdsForn += "'"
	    EndIf        
	Next nI
	
	// Busca os produtos na tabela SA5
	cQuery += "SELECT A5_PRODUTO, A5_NOMPROD, A5_CODPRF " +CRLF
	cQuery += "FROM " +RetSqlName("SA5") + " SA5 " +CRLF
	cQuery += "WHERE  " +CRLF
	cQuery += "A5_FORNECE = '"+cCodFrn+"' " +CRLF
	cQuery += "AND A5_LOJA = '"+cLojaFrn+"' " +CRLF
	cQuery += "AND A5_CODPRF IN ("+cProdsForn+") " +CRLF
	cQuery += "AND D_E_L_E_T_ = '' " +CRLF
	cQuery += "ORDER BY A5_PRODUTO " +CRLF
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("TRBSA5") > 0
		TRBSA5->(dbCloseArea())
	EndIf
	                         
	TCQuery cQuery New Alias "TRBSA5"
	
	dbSelectArea("TRBSA5")
	dbGotop()
	While !EOF()
		AADD(aAux, {TRBSA5->A5_PRODUTO,;	// [1] produto interno
					TRBSA5->A5_NOMPROD,;	// [2] descricao
					TRBSA5->A5_CODPRF})		// [3] produto fornecedor
		dbSkip()
	End
	dbCloseArea()
	
	// Nao possui nenhum cadastro para os produtos
	If Len(aAux) == 0                             
		For nI := 1 To Len(aItensXML)
			cNumItem	:= AllTrim(aItensXML[nI]:_nITEM:Text)
			cCodItem	:= PadR(aItensXML[nI]:_prod:_cProd:Text,TamSX3("A5_CODPRF")[1])
			cDescItem	:= AllTrim(aItensXML[nI]:_prod:_xProd:Text)
			AADD(aItensCad, {cCodItem, cDescItem, cNumItem})
		Next nI
    // Possui cadastros - verifica entao qual cadastro ainda nao existe
	Else
		For nI := 1 To Len(aItensXML)
			cNumItem	:= AllTrim(aItensXML[nI]:_nITEM:Text)
			cCodItem	:= PadR(aItensXML[nI]:_prod:_cProd:Text,TamSX3("A5_CODPRF")[1])
			cDescItem	:= AllTrim(aItensXML[nI]:_prod:_xProd:Text)
			// Procura no array aAux o item do xml
		 	nRes := aScan(aAux, { |x| Alltrim(x[3]) == cCodItem } )
		 	If nRes == 0
		 		aAdd(aItensCad, {cCodItem, cDescItem, cNumItem})
		 	EndIf
		Next nI	
	EndIf

// Com pedido de compras - deve relacionar os itens do xml com os itens do pedido
Else
	For nI := 1 To Len(aItensXML)
		cNumItem	:= AllTrim(aItensXML[nI]:_nITEM:Text)
		cCodItem	:= PadR(aItensXML[nI]:_prod:_cProd:Text,TamSX3("A5_CODPRF")[1])
		cDescItem	:= AllTrim(aItensXML[nI]:_prod:_xProd:Text)
		aAdd(aItensCad, {cCodItem, cDescItem, cNumItem})
	Next
EndIf


// Verifica o Array aItensXML 
/*
If ValType(aItensXML) == 'A' .And. Len(aItensXML) > 0
		dbSelectArea("SA5")
		SA5->(dbSetOrder(1))	// fornecedor + loja + produto
		SA5->(dbGoTop())
		// Procura ocorrencia do fornecedor/loja na SA5 - PRODUTO X FORNECEDOR
		If SA5->(dbSeek(xFilial("SA5")+cCodFrn+cLojaFrn))
			aAreaAux := GetArea()
			For nI := 1 To Len(aItensXML)                              
				cNumItem	:= AllTrim(aItensXML[nI]:_nITEM:Text)
				cCodItem	:= PadR(aItensXML[nI]:_prod:_cProd:Text,TamSX3("A5_CODPRF")[1])
				cDescItem	:= AllTrim(aItensXML[nI]:_prod:_xProd:Text)
				While (SA5->(A5_FILIAL+A5_FORNECE+A5_LOJA) == xFilial("SA5")+cCodFrn+cLojaFrn) .And. SA5->(!Eof()) .And. !lFound
					If SA5->A5_CODPRF == cCodItem
						lFound := .T.
					EndIf
					SA5->(dbSkip())
				EndDo

				If !lFound
					aAdd(aItensCad, {cCodItem, cDescItem, cNumItem})
				Else
					lFound := .F.
				EndIf
				RestArea(aAreaAux)
			Next
		Else
			For nI := 1 To Len(aItensXML)
				cNumItem	:= AllTrim(aItensXML[nI]:_nITEM:Text)
				cCodItem	:= PadR(aItensXML[nI]:_prod:_cProd:Text,TamSX3("A5_CODPRF")[1])
				cDescItem	:= AllTrim(aItensXML[nI]:_prod:_xProd:Text)
				aAdd(aItensCad, {cCodItem, cDescItem, cNumItem})
			Next
		EndIf
		SA5->(dbCloseArea())	
EndIf
*/

RestArea(aArea)


If Len(aItensCad) > 0
	lRet := CadProd(cCodFrn, cLojaFrn, aItensCad) 
EndIf          


Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CadProd �Autor  �Jackson E. de Deus	 � Data �  02/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina principal de cadastro de ProdutosXFornecedores.	  ���
���          � 							                                  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CadProd(cCodFrn, cLojaFrn, aItensCad)
	
	
	Local aArea	:= GetArea()
	Local aDimension	:= MsAdvSize() /* 1 - Linha inicial da area de trabalho
	  									  2 - Coluna inicial da area de trabalho
										  3 - Linha final da area de trabalho
										  4 - Coluna final da area de trabalho
										  5 - Coluna final da dialog
										  6 - Linha final da dialog
										  7 - Linha inicial dialog
										*/
	Local cExbText		:= ""
	Local cAlias		:= "SA2"
	Local aExbEnch		:= {"A2_COD", "A2_LOJA", "A2_NOME", "NOUSER"}
	Local lRet			:= .F.
	Local oArial10N		:= TFont():New("Arial",10,10,,.T.,,,,.F.,.F.)
	Private aInfo 		:= Array(0)
	Private aObjects	:= Array(0)
	Private aPosObj		:= Array(0)
	Private oDlg		:= Nil
	Private oEnch		:= Nil
	Private oMsNGet		:= Nil
	Private aHeaderAux	:= Array(0)
	Private aColsAux	:= Array(0)
    
    // Tecla F4 -> Mostra os Pedidos de Compra em aberto para o Fornecedor atual
    // Caso seja importa��o sem Pedido, n�o habilita
    // Usu�rio busca o Produto atrav�s do F3
	If !lPedSem
		//SetKey(VK_F4, { || ProdutosXML(aItensCad) })		// opc 2 - Itens do XML
		SetKey(VK_F4, { || ProdutosPC() })					// opc 1 - Itens do Pedido de Compra	
	EndIf
	
	If !lPedSem
		cExbText := "Relacionamento Nota Fiscal x Pedido de Compra"
    Else
		cExbText := "Cadastro de Produtos X Fornecedor"
	EndIf
	
	aAdd(aObjects,{000, 050, .T., .F. })	// 1 - largura em pixels
	aAdd(aObjects,{000, 100, .T., .T. })	// 2 - altura em pixels
	aAdd(aObjects,{000, 015, .T., .F. })	// 3 - se for verdadeiro, ignora a largura preenchida no parametro 1 e utiliza a largura disponivel da tela
											// 4 - se for verdadeiro, ignora a altura preenchida no parametro 2 e utiliza a altura disponivel da tela

	aInfo := {aDimension[1],aDimension[2],aDimension[3],aDimension[4], 3 /*distancia horizontal*/, 3 /*distancia vertical*/}
	aPosObj := MsObjSize(aInfo,aObjects)

	FillHeader()
	FillCols(aItensCad)   

	dbSelectArea(cAlias)
	&(cAlias)->(dbSetOrder(1))
	&(cAlias)->(dbGoTop())
	&(cAlias)->(dbSeek(xFilial(cAlias)+cCodFrn+cLojaFrn))

	RegToMemory("SA2",.F.,.T.,.F.) /* cria variaveis de memoria ( M-> ) */
/*	1 - alias em que a funcao se baseia para criar as variaveis de memoria
	2 - .T. = variaveis inicializadas com conteudo padrao; .F. = variaveis inicializadas conforme registro posicionado
	3 - .T. = utiliza dicionario de dados; .F. = utiliza CriaVar()
	4 - indica se ira executar o inicializados padrao dos campos
*/

	oDlg := MSDialog():New(aDimension[7],aDimension[1],aDimension[6],aDimension[5], OemToAnsi(cExbText),,,,,,,, oMainWnd, .T.)

	@ aPosObj[2][2], 02 To (aDimension[3]/100*5), (aDimension[5]/2) Pixel Of oDlg
	
	// Cabe�alho
	@ 010, 05 Say "C�digo Fornecedor"		Pixel Of oDlg
	@ 008, 55 MsGet opCodFor				Var cFornec 	Picture "@!" Size 40,0.5 Pixel Of oDlg F3 "SA2"
	opCodFor:lReadOnly := .T. 
	
	@ 010, 105 Say "Nome"		Pixel Of oDlg
	@ 008, 120 MsGet opNomeFor	Var cNomeFor 	Picture "@!" Size 140,0.5 Pixel Of oDlg
	opNomeFor:lReadOnly := .T.
	
	@ 010, 270 Say "Loja"   Pixel Of oDlg
	@ 008, 285 MsGet opLjFor Var cLjFornec 	Picture "@!" Size 30,0.5 Pixel Of oDlg 
	opLjFor:lReadOnly := .T.  
	
	@ 010, 320 Say "Estado"   Pixel Of oDlg
	@ 008, 340 MsGet opEstFor Var cEstFor 	Picture "@!" Size 15,0.5 Pixel Of oDlg 
	opEstFor:lReadOnly := .T.   
	
	@ 010, 360 Say "Emiss�o"   Pixel Of oDlg
	@ 008, 385 MsGet opEmissao Var cDtEmissao 	Picture "@!" Size 40,0.5 Pixel Of oDlg 
	opEmissao:lReadOnly := .T. 
   
	// Grid			
	oMsNGet	:= MsNewGetDados():New( (aDimension[3]/100*5+5),aPosObj[2][2],aPosObj[2][3],(aDimension[5]/2), GD_UPDATE, /*"U_LinOk"*/ , /*"U_TudoOk"*/ ,,{"T_CODPROD"}/*{"T_CODPROD"}*/,, 999 , "U_ValCProd"/*"U_FieldOk"*/ ,/*"AllwaysTrue"*/ ,/*"U_DelOk"*/ , oDlg, aHeaderAux, aColsAux)	

	// Rodap�
	If !lPedSem	
		@ 260, 03 To 275,230 Pixel Of oDlg
		@ 264, 10 Say "Pedido de Compra: " Size 55,15  Pixel Of oDlg
		@ 264, 57 Say  IIF(lPedTotal, cNumPed,) Size 40,15 Pixel Of oDlg 
		
		@ 264, 105 Say "Emiss�o: " Size 55,15  Pixel Of oDlg
		@ 264, 127 Say  IIF(lPedTotal, cPedEmissao,) Size 40,15 Pixel Of oDlg 
		
		@ 264, 175 Say "Total: R$" Size 55,15  Pixel Of oDlg
		@ 264, 195 Say  IIF(lPedTotal, Transform(cPedTotVlr,"@E 999,999.99"),) Picture "@E 999,999.99" Size 40,15 Pixel Of oDlg 
	EndIf
	
	
	oDlg:Activate(,,, .T.,,,EnchoiceBar(oDlg, {|| Iif( CadOk(), (Iif (GravaFrn(), (lRet := .T., oDlg:End()), Nil)), Nil ) }, {|| Iif(ExitCad(), oDlg:End(), Nil)}))
	
	RestArea(aArea)
	                    
	
	
Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FillHeader�Autor  �Jackson E. de Deus  	� Data � 02/05/12 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de preenchimento do aHeader auxiliar (utilizada     ���
���          � na rotina 'CadProdMO').                                    ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FillHeader()
	Local aArea	:= GetArea()
	Local lFound:= .F.

	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))

         
    // Item do XML
   	SX3->(dbGoTop())
	If SX3->(dbSeek("SC7"))
		While SX3->(!Eof()) .And. !lFound
			If X3USO(X3_USADO).And.cNivel>=X3_NIVEL
				If AllTrim(X3_CAMPO)=="C7_ITEM"
					aAdd(aHeaderAux,{AllTrim(X3_TITULO), "T_XMLITE", X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT})
					lFound := .T.
				EndIf
			EndIf
			SX3->(dbSkip())
		EndDo
	EndIf
   	lFound := .F.
   	
   	// Codigo do produto do fornecedor
	SX3->(dbGoTop())
	If SX3->(dbSeek("SA5"))
		While SX3->(!Eof()) .And. !lFound
			If X3USO(X3_USADO).And.cNivel>=X3_NIVEL
				If AllTrim(X3_CAMPO)=="A5_CODPRF"
					aAdd(aHeaderAux,{AllTrim(X3_TITULO), "T_CODPRF", X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT})
					lFound := .T.
				EndIf
			EndIf
			SX3->(dbSkip())
		EndDo
	EndIf

	// Descri��o do Produto do Fornecedor
	lFound := .F.
	SX3->(dbGoTop())
	If SX3->(dbSeek("SB1"))
		While SX3->(!Eof()) .And. !lFound
			If X3USO(X3_USADO).And.cNivel>=X3_NIVEL
				If AllTrim(X3_CAMPO)=="B1_DESC"
					aAdd(aHeaderAux,{AllTrim(X3_TITULO), "T_DESCPRF", X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT})
					lFound := .T.
				EndIf
			EndIf
			SX3->(dbSkip())
		EndDo
	EndIf
    
    // Somente vai adicionar caso seja importa��o com Pedido de Compra
	If !lPedSem
		lFound := .F.
		// N�mero do Pedido de Compra
		SX3->(dbGoTop())
		If SX3->(dbSeek("SC7"))
			While SX3->(!Eof()) .And. !lFound
				If /*X3USO(X3_USADO).And.*/cNivel>=X3_NIVEL
					If AllTrim(X3_CAMPO)=="C7_NUM"
						aAdd(aHeaderAux,{AllTrim(X3_TITULO), "T_NUMPED", X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT})
						lFound := .T.
					EndIf
				EndIf
				SX3->(dbSkip())
			EndDo
		EndIf
		
		lFound := .F.
		// Item do Pedido de Compra
		SX3->(dbGoTop())
		If SX3->(dbSeek("SC7"))
			While SX3->(!Eof()) .And. !lFound
				If X3USO(X3_USADO).And.cNivel>=X3_NIVEL
					If AllTrim(X3_CAMPO)=="C7_ITEM"
						aAdd(aHeaderAux,{AllTrim(X3_TITULO), "T_PCITEM", X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT})
						lFound := .T.
					EndIf
				EndIf
				SX3->(dbSkip())
			EndDo
		EndIf
	EndIf
	
	lFound := .F.
	// Codigo do Produto	
	SX3->(dbGoTop())
	If SX3->(dbSeek("SB1"))
		While SX3->(!Eof()) .And. !lFound
			If X3USO(X3_USADO).And.cNivel>=X3_NIVEL
				If AllTrim(X3_CAMPO)=="B1_COD"
					aAdd(aHeaderAux,{AllTrim(X3_TITULO), "T_CODPROD", X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "ExistCpo('SB1')", X3_USADO, X3_TIPO, "SB1", X3_CONTEXT})
					lFound := .T.
				EndIf
			EndIf
			SX3->(dbSkip())
		EndDo
	EndIf
	
	lFound := .F.
	// Desc. do Produto
	SX3->(dbGoTop())
	If SX3->(dbSeek("SB1"))
		While SX3->(!Eof()) .And. !lFound
			If X3USO(X3_USADO).And.cNivel>=X3_NIVEL
				If AllTrim(X3_CAMPO)=="B1_DESC"
					aAdd(aHeaderAux,{AllTrim(X3_TITULO), "T_DESCPROD", X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT})
					lFound := .T.
				EndIf
			EndIf
			SX3->(dbSkip())
		EndDo
	EndIf

	RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FillCols  �Autor  �Jackson E. de Deus   � Data �  02/05/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de preenchimento do aCols auxiliar (utilizada	      ���
���          � na rotina 'CadProd').                                    ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FillCols(aItensCad)

Local aArea		:= GetArea()
Local nI		:= 0
Local cXMLItem	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_XMLITE" })
Local nCodFrn	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_CODPRF" })
Local nDescFrn	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_DESCPRF" })
Local nNumPed	:= IIF(!lPedSem, aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_NUMPED" }), )
Local nPCItem	:= IIF(!lPedSem, aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_PCITEM" }), )
Local nCodProd	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_CODPROD" })
Local nDescProd	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_DESCPROD" })

Local cProdForn	:= ""                                            

                                     

// Alimenta Acols com dados do XML
For nI := 1 To Len(aItensCad)
	
	// Se for importa��o com Pedido de Compras, adiciona 8 colunas, caso contr�rio, ser�o somente 7
	// Retira Numedo do Pedido de Compra e Item do Pedido de Compra
	IIf(!lPedSem, aAdd(aColsAux, {,,,,,,,.F.}), aAdd(aColsAux, {,,,,,,.F.}))

	aColsAux[nI][cXMLItem]	:= PadL(aItensCad[nI][3], 4, "0")					// Item do XML
	aColsAux[nI][nCodFrn]	:= aItensCad[nI][1]									// Cod. Produto do XML
	aColsAux[nI][nDescFrn]	:= aItensCad[nI][2]									// Desc. do Produto do XML
	
	// S� vai adicionar se for importa��o com Pedido de Compra
	IIf(!lPedSem, 	aColsAux[nI][nNumPed]	:= Space(TamSX3("C7_NUM")[1]), )	// Num. Pedido
	IIf(!lPedSem, 	aColsAux[nI][nPCItem]	:= Space(TamSX3("C7_ITEM")[1]), )	// Item Pedido
	
	aColsAux[nI][nCodProd]	:= Space(TamSX3("B1_COD")[1])						// Cod. do Produto interno
	aColsAux[nI][nDescProd]	:= Space(TamSX3("B1_DESC")[1])						// Desc. do Produto
	
Next

/*
Comentado pois o preenchimento ser� feito com os dados do XML
// Alimenta Acols com dados do Pedido
For nI := 1 To Len(aPedido)
	
	aAdd(aColsAux, {,,,,,.F.})
	aColsAux[nI][nPCItem]	:= aPedido[nI][2]					//Space(TamSX3("C7_ITEM")[1])	// Item do Pedido de Compras
	aColsAux[nI][nCodProd]	:= aPedido[nI][3]					//Space(TamSX3("B1_COD")[1])  //
	aColsAux[nI][nDescProd]	:= aPedido[nI][4]					//Space(TamSX3("B1_DESC")[1]) //
	aColsAux[nI][nCodFrn]	:= Space(TamSX3("A5_CODPRF")[1])	//aItensCad[nI][1]
	aColsAux[nI][nDescFrn]	:= Space(TamSX3("A5_NOMPROD")[1])	//aItensCad[nI][2]

Next nI
*/

RestArea(aArea)

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �buscaPed �Autor  �Jackson E. de Deus   � Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela para escolha do Pedido de Compra.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function buscaPed()


Local oLbx
Local cTitulo := "Selecionar Pedido de Compra"
Local aDados
Local cPedido
Local oButton
Local oButton2
Local oDlg
Local opNomeFor

// Busca os itens do pedido               
aDados := Pedidos()       

 
If Len(aDados) > 0


	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 250,500 PIXEL
		
		@ 05, 05  Say "Fornecedor"		Pixel Of oDlg
		@ 04, 38 MsGet opNomeFor	Var cNomeFor 	Picture "@!" Size 140,0.5 Pixel Of oDlg
		opNomeFor:lReadOnly := .T.

		@ 18,00 LISTBOX oLbx FIELDS HEADER "Loja", "Pedido", "Emiss�o", "Origem" /*"Produto", "Descri��o", "Qtd", "Dt Emiss�o"*/ SIZE 250,090 OF oDlg PIXEL
		//oLbx := TListBox():New(10,10,, aDados)
		
		oLbx:SetArray( aDados )
		oLbx:bLine := {|| {aDados[oLbx:nAt,10],aDados[oLbx:nAt,1],aDados[oLbx:nAt,8], aDados[oLbx:nAt,11] } }

		// Na escolha, atribui o valor na variavel cProd
    	oLbx:bChange := {|| cPedido := aDados[oLbx:nAt,1] }
		oLbx:blDblClick := {|| ItensPed(aDados[oLbx:nAt,1],@oDlg) }    	

		oButton2 := tButton():New(110,220,'Confirmar',oDlg,{ || ItensPed(cPedido,@oDlg)},30,12,,,,.T.)
		oButton := tButton():New(110,185,'Fechar',oDlg,{ || oDlg:End()},30,12,,,,.T.)
		
	ACTIVATE MSDIALOG oDlg CENTER

Else
	MsgInfo("N�o existe Pedido de Compra Pendente para esse Fornecedor.")
EndIf


Return

 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ItensPed �Autor  �Jackson E. de Deus   � Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Alimenta Array aPedido que � utilizado no aCols.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ItensPed(cPedido,oDlg)

Local cQuery := ""
Local nI 

aPedido := {}
/*------------------------------------------------------------------------------+
|	Layout do Array																|
|																				|
|	Para XML com TAG xPED														|
|	[Pedido][Item][Codigo interno]												|
|																				|
|	Para XML sem TAG xPED														|
|	[Pedido][Item][Codigo interno][Desc. Prod Interno][Observa�ao][Dt Emiss�o]	|
|																				|
+------------------------------------------------------------------------------*/                    


// Se n�o existe as TAGS xPED no XML, alimenta Array aPedido com base no Pedido de Compra escolhido
If !lExistxPed

	// Monta Query de consulta                 
	cQuery := "SELECT "
	cQuery += "C7_NUM AS PEDIDO, "
	cQuery += "C7_ITEM AS ITEM, "
	cQuery += "C7_PRODUTO AS CODPROD, "
	cQuery += "C7_DESCRI AS DESCRI, "
	cQuery += "C7_OBS AS OBS, "
	cQuery += "C7_EMISSAO AS EMISSAO "
	
	cQuery += "FROM " +RetSqlName("SC7") +" AS SC7 " 
	
	cQuery += "WHERE " 
	
	cQuery += "C7_FORNECE		= '"+cFornec+"' "
	cQuery += "AND C7_LOJA		= '"+cLjFornec+"' "
	cQuery += "AND C7_FILIAL	= '"+xFilial("SC7")+"' "
	//cQuery += "AND C7_PENDEN <> 'N' "
	//cQuery += "AND C7_ENCER
	
	//cQuery += "AND C7_EMITIDO	= 'S' "
	//cQuery += "AND C7_QTDACLA <> C7_QUANT " 
	cQuery += "AND C7_NUM		= '"+cPedido+"' "
	cQuery += "AND D_E_L_E_T_	= '' "
	
	cQuery += "ORDER BY ITEM"
	
	// Se j� est� aberta, fecha
	If Select("TSC7") <> 0
		TSC7->(dbCloseArea())
	EndIf
	
	// Executa Query     
	TCQuery cQuery New Alias "TSC7"
	
	dbSelectArea("TSC7")
	dbGoTop()
	While !EOF()
		
		AADD( aPedido, { TSC7->PEDIDO,;				// [1]
							TSC7->ITEM,;			// [2]
							TSC7->CODPROD,;			// [3]
							TSC7->DESCRI,;			// [4]
							TSC7->OBS,;				// [5]
							TSC7->EMISSAO } )		// [6]
		TSC7->(Dbskip())
		
	End             
	dbCloseArea()
	
	
	// -> Pega Total do Pedido
	cQuery := "SELECT SUM(C7_TOTAL) AS TOTAL "
	cQuery += "FROM " +RetSqlName("SC7") +" AS SC7 " 
	
	cQuery += "WHERE " 
	cQuery += "C7_FORNECE		= '"+cFornec+"' "
	cQuery += "AND C7_LOJA		= '"+cLjFornec+"' "
	cQuery += "AND C7_FILIAL	= '"+xFilial("SC7")+"' "
	cQuery += "AND C7_NUM		= '"+cPedido+"' "
	//cQuery += "AND C7_PENDEN <> 'N' "
	cQuery += "AND D_E_L_E_T_	= '' "
	
	// Se j� est� aberta, fecha
	If Select("TRB") <> 0
		TRB->(dbCloseArea())
	EndIf
	
	// Executa Query     
	TCQuery cQuery New Alias "TRB"
	
	dbSelectArea("TRB")
	dbGoTop()
	While !EOF()
	
		cPedTotVlr := TRB->TOTAL
		TRB->(Dbskip())
		
	End
	dbCloseArea()
	
	// Salva na variavel private o valor do Pedido de Compra escolhido
	cNumPed		:= cPedido
	cPedEmissao := StoD(aPedido[1][6])
	cPedEmissao := DtoC(cPedEmissao)
 

// Caso contr�rio varre o XML para alimenta��o do Array
Else
	// Adiciona no Array o numero do Pedido + Item
	For nI := 1 To Len(aItensXML)
		//AADD(aPedido, { oXml:_NfeProc:_Nfe:_InfNfe:_DET[nI]:_PROD:_xPed:TEXT, oXml:_NfeProc:_Nfe:_InfNfe:_DET[nI]:_PROD:_nItemPed:TEXT, "" })	 
		//cPedido += oXml:_NfeProc:_Nfe:_InfNfe:_DET[nI]:_PROD:_xPed:TEXT
	Next nI

EndIf


	
// Fecha Janela
If IsInCallStack("buscaPed")
	oDlg:End()
EndIf


Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ProdutosPC �Autor  �Jackson E. de Deus  � Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela de escolha do Item do Pedido de Compra, para fazer o  ���
���          � relacionamento com o item do XML.                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProdutosPC()

Local oLbx
Local cTitulo := "Pedidos de Compra - <F4>"
Local aDados
Local cProd
Local oButton
Local oButton2
Local oDlg
Local cNumItem := ""
Local cNumPed  := ""
Private lProdEnt := .F.
Private lResid := .F.

// Busca os itens do pedido               
aDados := Pedidos()       

 
If Len(aDados) > 0

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 250,500 PIXEL
		
		@ 05, 05  Say "Selecione o Item do Pedido de Compra"		Pixel Of oDlg
	
		@ 18,00 LISTBOX oLbx FIELDS HEADER ;
		"Numero PC", "Tipo", "Item", "Produto","Descri��o",  "Quantidade", "Qtd Entregue", "Unidade", "Segunda UM", ;
		"Armazem", "Observacoes", "Loja", "Razao Social", "Centro Custo", "% Desc Item", "Nome Usuario", "ACC";
		  SIZE 250,090 OF oDlg PIXEL
		//oLbx := TListBox():New(10,10,, aDados)
		
		oLbx:SetArray( aDados )
		oLbx:bLine := {|| {aDados[oLbx:nAt,1],;		// Pedido
							aDados[oLbx:nAt,12],;	// Tipo
							aDados[oLbx:nAt,2],;	// Item
							aDados[oLbx:nAt,3],;	// Produto
							aDados[oLbx:nAt,4],;	// Descri��o
							aDados[oLbx:nAt,5],;	// Quantidade
							aDados[oLbx:nAt,23],;	// Quantidade ja entregue
							aDados[oLbx:nAt,13],;	// Unidade
							aDados[oLbx:nAt,14],;	// Seg UM
							aDados[oLbx:nAt,15],;	// Armazem
							aDados[oLbx:nAt,16],;	// Observacoes
							aDados[oLbx:nAt,10],;	// Loja
							aDados[oLbx:nAt,17],;	// Razao Social
							aDados[oLbx:nAt,18],;	// Centro Custo
							aDados[oLbx:nAt,20],;	// % Desc Item
							aDados[oLbx:nAt,21],;	// Nome Usuario							
							aDados[oLbx:nAt,19] } }	// ACC

		// Na escolha, atribui o valor na variavel cProd
    	oLbx:bChange := {|| cNumPed := aDados[oLbx:nAt,1],  cNumItem := aDados[oLbx:nAt,2], cProd := aDados[oLbx:nAt,3], lProdEnt := aDados[oLbx:nAt,22], lResid := aDados[oLbx:nAt,24] }
        oLbx:blDblClick := { || VldClck(cNumPed,cNumItem,cProd,@oDlg) }
        
		oButton2 := tButton():New(110,220,'Confirmar',oDlg,{ || VldClck(cNumPed,cNumItem,cProd,@oDlg) },30,12,,,,.T.)
		oButton := tButton():New(110,185,'Fechar',oDlg,{ || oDlg:End()},30,12,,,,.T.)
		
		
	ACTIVATE MSDIALOG oDlg CENTER

Else
	MsgInfo("N�o existe Pedido de Compra Pendente para esse Fornecedor.")
EndIf


Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMPXMLNFE �Autor  �Microsiga           � Data �  05/29/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VldClck(cNumPed,cNumItem,cProd,oDlg)
                      
// Verifica Residuo
If lProdEnt == .T. 
	MsgInfo("Item eliminado via elimina��o de res�duos. " +CRLF +"Escolha outro item.")
	Return
Else
	RefreshTela(cNumPed,cNumItem,cProd,@oDlg) 
EndIf
            

// Verifica Quantidade entregue
If lProdEnt == .T. 
	MsgInfo("O Produto j� est� totalmente entregue." +CRLF +"Escolha outro item.")
	Return
Else
	RefreshTela(cNumPed,cNumItem,cProd,@oDlg) 
EndIf


Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Pedidos    �Autor  �Jackson E. de Deus�    Data � 02/05/13  ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna Array com os dados dos Pedidos para o Fornecedor.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Pedidos()

Local cQuery	:= ""
Local cItens	:= ""
Local cProd		:= ""
Local cNewProd  := ""
Local nPosSpace := 0
Local cMaskEsp	:= Space(1)
Local aDados	:= {}
Local nI
Local nJ
Local nRes		:= 0
//Local nPosNAT := oMsnGet:oBrowse:NAT 


// Monta Query de consulta                 
cQuery += "SELECT "
cQuery += "C7_TIPO AS TIPO, "
cQuery += "C7_UM AS UM, "
cQuery += "C7_SEGUM AS SEGUM, "
cQuery += "C7_LOCAL AS ARMLOCAL, "
cQuery += "C7_OBS AS OBS, "
cQuery += "C7_XFORNEC RAZAO, "
cQuery += "C7_CC AS CC, "
cQuery += "C7_ACCPROC AS ACC, "
cQuery += "C7_USER AS USUARIO, "
cQuery += "C7_FORNECE AS FORNECE, "
cQuery += "C7_LOJA AS LOJA, "
cQuery += "C7_NUM AS PEDIDO, "
cQuery += "C7_ITEM AS ITEM, "
cQuery += "C7_PRODUTO AS CODPROD, "
cQuery += "C7_DESCRI AS DESCRI, "
cQuery += "C7_QUANT AS QTD, "
cQuery += "C7_DESC AS DESCONTO, "
cQuery += "C7_CONTA AS CONTA, "
cQuery += "C7_ITEMCTA AS ITEMCONTA, "
cQuery += "C7_EMISSAO AS EMISSAO, "
cQuery += "C7_ORIGEM AS ORIGEM, "
cQuery += "C7_QUJE AS QTDENT, "
cQuery += "C7_RESIDUO AS RESID "

cQuery += "FROM " +RetSqlName("SC7") +" AS SC7 " 

cQuery += "WHERE " 

cQuery += "C7_FORNECE		= '"+cFornec+"' "
cQuery += "AND C7_LOJA		= '"+cLjFornec+"' "
cQuery += "AND C7_FILIAL	= '"+xFilial("SC7")+"' "
cQuery += "AND C7_QUJE < C7_QUANT "
//cQuery += "AND C7_PENDEN <> 'N' "
//cQuery += "AND C7_ENCER <> 'E' "
//cQuery += "AND C7_EMITIDO	= 'S' "
//cQuery += "AND C7_QTDACLA <> C7_QUANT "

// Se foi executada atrav�s da fun��o CadProd (atrav�s do F4)
If IsInCallStack("CadProd")
	// Se for importa��o de Pedido Total, deve mostrar somente itens do Pedido escolhido
	If lPedTotal
		cQuery += "AND C7_NUM		= '"+cNumPed+"' "	
	EndIf
EndIf

cQuery += "AND D_E_L_E_T_	= '' "
	
cQuery += " ORDER BY C7_EMISSAO DESC"

// Se j� est� aberta, fecha
If Select("TSC7") <> 0
	TSC7->(dbCloseArea())
EndIf

// Executa Query     
TCQuery cQuery New Alias "TSC7"

dbSelectArea("TSC7")
dbGoTop()
While !EOF()
    
    // Se n�o foi executada via fun��o CadProd (Tela de escolha de Pedido)
	If !IsInCallStack("CadProd")
		
		// Verifica Array - procura Pedido j� existente (Evita Pedido duplicado nessa tela)
		nRes := aScan(aDados, { |x| Alltrim(x[1]) == Alltrim(TSC7->PEDIDO) } )
				    
		// Pedido ainda n�o est� no Array, adiciona no Array (evita duplicidade)                                                        
		If nRes == 0
		
			AADD( aDados, { TSC7->PEDIDO,;				// [1] 
							TSC7->ITEM,;				// [2]
							TSC7->CODPROD,;				// [3]
							TSC7->DESCRI,;				// [4]
							TSC7->QTD,;					// [5]
							TSC7->CONTA,;				// [6]
							TSC7->ITEMCONTA,;			// [7]
							StoD(TSC7->EMISSAO),;		// [8]
							TSC7->FORNECE,;				// [9]
							TSC7->LOJA,;				// [10]
							TSC7->ORIGEM,;				// [11]
							TSC7->TIPO,;				// [12]
							TSC7->UM,;					// [13]
							TSC7->SEGUM,;				// [14]
							TSC7->ARMLOCAL,;			// [15]
							TSC7->OBS,;					// [16]
							TSC7->RAZAO,;				// [17]
							TSC7->CC,;					// [18]
							TSC7->ACC,;					// [19]
							TSC7->DESCONTO,;			// [20]
							TSC7->USUARIO } )			// [21] 
								
		EndIf                             
		
	// Se foi executada via fun��o CadProd (Tela de Relacionamento)	
	Else
		AADD( aDados, { TSC7->PEDIDO,;									// [1] 
							TSC7->ITEM,;								// [2]
							TSC7->CODPROD,;								// [3]
							TSC7->DESCRI,;								// [4]
							TSC7->QTD,;									// [5]
							TSC7->CONTA,;								// [6]
							TSC7->ITEMCONTA,;							// [7]
							StoD(TSC7->EMISSAO),;						// [8]
							TSC7->FORNECE,;								// [9]
							TSC7->LOJA,;								// [10]
							TSC7->ORIGEM,;								// [11]
							TSC7->TIPO,;								// [12]
							TSC7->UM,;									// [13]
							TSC7->SEGUM,;								// [14]
							TSC7->ARMLOCAL,;							// [15]
							TSC7->OBS,;									// [16]
							TSC7->RAZAO,;								// [17]
							TSC7->CC,;									// [18]
							TSC7->ACC,;									// [19]
							TSC7->DESCONTO,;							// [20]
							TSC7->USUARIO,;								// [21]
							IIF(TSC7->QTDENT == TSC7->QTD,.T.,.F.),;	// [22]
							TSC7->QTDENT,;								// [23]
							IIF(TSC7->RESID == "S",.T.,.F.) })			// [24]										
							 
			
	
	EndIf	  
						
	TSC7->(Dbskip())
	
End             
dbCloseArea()

// Se Array estiver vazio, preenche com "" todas as posicoes
If Len(aDados) == 0
	AFill( aDados, "", 1, 23 )
EndIf


Return aDados



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  RefreshTela �Autor  �Jackson E. de Deus � Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza os campos da MsNewGetDados.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RefreshTela(cNumPed,cNumItem,cProd,oDlg)

Local nPosNAT	:= oMsnGet:oBrowse:NAT                                                        
Local nPosPed	:= IIF(!lPedSem, aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_NUMPED" }), )	// Somente Importa��o com Pedido 
Local nPosItem	:= IIF(!lPedSem, aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_PCITEM" }), )	// Somente Importa��o com Pedido 
Local nPosCOL	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_CODPROD" })
Local nPosDesc	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_DESCPROD" })                   


If AllTrim(cProd) <> ""
    
    // Preenche o n�mero do Pedido
	IIF(nPOsPed > 0, oMsnGet:Acols[nPosNAT][nPosPed] := cNumPed, )
                                  
	// Preenche o n�mero do Item
	IIF(nPosItem > 0, oMsnGet:Acols[nPosNAT][nPosItem] := cNumItem, )
    
	// Preenche c�digo do produto	
	oMsnGet:Acols[nPosNAT][nPosCOL] := cProd
	
	// Preenche descri��o do Produto
	oMsnGet:Acols[nPosNAT][nPosDesc] := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC")			


EndIf	


// Fecha Janela
oDlg:End()


Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValCProd�Autor  �Jackson E. de Deus       � Data � 02/05/13 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de validacao do aCols auxiliar (utilizada na rotina ���
���          � 'CadProd'.												  ���
���          � Alimenta a descricao do produto no aCols auxiliar.		  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ValCProd()

Local aArea		:= GetArea()
Local nDescProd	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_DESCPROD" })
Local lRet		:= .F.

If Empty(AllTrim((M->T_CODPROD)))
	lRet := .T.
Else
	oMsNGet:aCols[oMsNGet:oBrowse:nRowPos][nDescProd] := GetAdvFVal("SB1","B1_DESC", xFilial("SB1")+M->T_CODPROD, 1, Space(TamSX3("B1_DESC")[1]))
	lRet := .T.
EndIf

RestArea(aArea)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CadOk     �Autor  �Jackson E. de Deus  � Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se todos os itens foram preenchidos na rotina	  ���
���          � CadProd			                                          ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CadOk()

Local nI		:= 0
Local nCodProd	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_CODPROD" })
Local lRet		:= .T.

For nI := 1 To Len(oMsNGet:aCols)

	If Empty(AllTrim(oMsNGet:aCols[nI][nCodProd]))
		lRet := .F.
		Exit
	EndIf
	
Next

If !lRet
	Alert(OemToAnsi("H� itens n�o preenchidos na coluna " +cValToChar(nCodProd) +"." +CRLF +"Preencha todos os itens para prosseguir."))
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ExitCad   �Autor  �Jackson E. de Deus  � Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Confirmacao de cancelamento de cadastro da rotina CadProd. ���
���          �                                               			  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ExitCad()

Local lRet		:= .T.//.F.

//lRet := ApMsgYesNo(OemToAnsi("O cadastro n�o foi efetuado e a importa��o ser� interrompida." +CRLF +"Confirma o cancelamento?"))

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaFrn  �Autor  �Jackson E. de Deus  � Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gravacao de dados. Utilizada na rotina CadProd.	 		  ���
���          �                                        			          ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaFrn()

Local aArea		:= GetArea()
Local nCodPrf	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_CODPRF" })
Local nDescPrf	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_DESCPRF" })
Local nNumPed	:= IIF(!lPedsem, aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_NUMPED" }), )
Local nPCItem	:= IIF(!lPedSem, aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_PCITEM" }), )
Local nCodProd	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_CODPROD" })
Local nDescProd	:= aScan(aHeaderAux, {|x| AllTrim(Upper(x[2]))=="T_DESCPROD" })


Local nI		:= 0 
Local nJ		:= 0
Local aReg		:= { {"A5_FORNECE", Nil, Nil}, {"A5_LOJA", Nil, Nil}, {"A5_NOMEFOR", Nil, Nil}, {"A5_PRODUTO", Nil, Nil}, {"A5_NOMPROD", Nil, Nil}, {"A5_CODPRF", Nil, Nil} }
Local lRet		:= .T.
Local _cCodProd	:= "" 
Local _cCodForn	:= ""
Local _cItem	:= ""

dbSelectArea("SA5")
dbSetOrder(1)	// filial + fornecedor + loja + produto
For nI := 1 To Len(oMsNGet:aCols)
    
    // Numero do Pedido de Compra
    _cPedido := IIF(!lPedSem, oMsNGet:aCols[nI][nNumPed], )
       
    // Item do Pedido de Compra
    _cItem := IIF(!lPedSem, oMsNGet:aCols[nI][nPCItem], )
    
	// Codigo do Produto
	_cCodProd := oMsNGet:aCols[nI][nCodProd]

	// Codigo do Produto do fornecedor
	_cCodForn := Alltrim(oMsNGet:aCols[nI][nCodPrf])

	// Verifica se j� existe a amarra��o para esse produto
	If DBSeek(xFilial("SA5")+cFornec+cLjFornec+AvKey(_cCodProd,"A5_PRODUTO"))
		
		// Se existe, atualiza o c�digo do produto do fornecedor
		If RecLock("SA5", .F.)
   			SA5->A5_CODPRF		:= _cCodForn	//Alltrim(oMsNGet:aCols[nI][nCodPrf])
   			SA5->(MsUnlock())
      	EndIf
	
	Else
	
		// Caso n�o exista, cria agora
   		If RecLock("SA5", .T.)
   			SA5->A5_FILIAL		:= xFilial("SA5")
  			SA5->A5_FORNECE		:= M->A2_COD
   			SA5->A5_LOJA		:= M->A2_LOJA
   			SA5->A5_NOMEFOR		:= M->A2_NOME
   			SA5->A5_PRODUTO		:= _cCodProd	//oMsNGet:aCols[nI][nCodProd]
   			SA5->A5_NOMPROD		:= oMsNGet:aCols[nI][nDescProd]
   			SA5->A5_CODPRF		:= _cCodForn	//Alltrim(oMsNGet:aCols[nI][nCodPrf])
   			SA5->(MsUnlock())
       	EndIf
       	
	EndIf
    
    // Se for Importa��o sem, n�o necessita de Numero do Pedido nem Item do Pedido
    If !lPedSem
    
    	// Se for Parcial, o Array aPedido n�o foi alimentado
    	If !lPedTotal
    		AADD(aRelaProd, {_cPedido,_cItem,_cCodProd,_cCodForn})	

		// Se for Total
		Else
			// Adiciona em Array aRelaProd a rela��o entre Pedido x Item x Produto x Produto Fornecedor
		    For nJ := 1 To Len(aPedido) 
		        
	        // Se n�o existe TAG xPED no XML
	    	//If !lExistxPed
		    	If aPedido[nJ][3] == _cCodProd    
		    		//				Pedido			Item			Produto		Produto Fornecedor
		    		If !lPedSem
			    		AADD(aRelaProd, {aPedido[nJ][1],_cItem,_cCodProd,_cCodForn}) 
			    	Else
			    		AADD(aRelaProd, {aPedido[nJ][1],"",_cCodProd,_cCodForn}) 
			    	EndIf
		    	EndIf        
			    		    	
		    	// Altera variavel logica pois caso o programa n�o entre nessa rotina, o array aRelaProd estar� vazio
				// e dever� ser alimentado de outra forma
		    	lVzRelaPrd := .F.
		    	
			Next nJ		
		
    	EndIf
 
	EndIf      
	
Next nI

SA5->(dbCloseArea())

RestArea(aArea)

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ConsNFeChave �Autor  �Jackson E. de Deus  � Data � 02/05/13 ���
�������������������������������������������������������������������������͹��
���Desc.     � Consulta NF-e atraves da chave                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ConsNFeChave(cChaveNFe,cRetChv)

Local cIdEnt	:= ""
Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWS
Default cChaveNfe := ""

If Empty(cChaveNFe)
	Return
EndIf
 
// Obtem o codigo da Entidade
GetIdEnt(@cIdEnt)
         
oWs:= WsNFeSBra():New()
oWs:cUserToken   := "TOTVS"
oWs:cID_ENT		 := cIdEnt
ows:cCHVNFE		 := cChaveNFe
oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"

If oWs:ConsultaChaveNFE()
	cRetChv := oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE +CRLF	// AUTORIZADO O USO DA NF-E ?
Else
	IIf(Empty(GetWscError(3)),cRetChv := GetWscError(1), cRetChv := GetWscError(3))
	MsgStop(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),"ConsNFeChave")
	Return
EndIf

Return 



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetIdEnt �Autor  �Jackson E. de Deus   � Data �  25/10/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Obtem o codigo da entidade.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GetIdEnt(cIdEnt)

Local aArea  := GetArea()
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
Local lUsaGesEmp := IIF(FindFunction("FWFilialName") .And. FindFunction("FWSizeFilial") .And. FWSizeFilial() > 2,.T.,.F.)


//������������������������������������������������������������������������Ŀ
//�Obtem o codigo da entidade                                              �
//��������������������������������������������������������������������������
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"
	
oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM		
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := IIF(lUsaGesEmp,FWFilialName(),Alltrim(SM0->M0_NOME))
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"

If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),/*{STR0114}*/{"Ok"},3)
EndIf

RestArea(aArea)

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerErro �Autor  �Jackson E. de Deus    � Data �  08/01/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Mostra o erro na tela.                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VerErro(cError)

Local oDlg
Local cMemo
Local oFont 

DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15

DEFINE MSDIALOG oDlg TITLE "Erro na importa��o" From 3,0 to 340,417 PIXEL

@ 5,5 GET oMemo  VAR cError SIZE 200,145 OF oDlg PIXEL 
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga

ACTIVATE MSDIALOG oDlg CENTER

Return