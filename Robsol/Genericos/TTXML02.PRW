#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "fileio.ch"
#INCLUDE "TOPCONN.CH"
    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTXML02   บAutor  ณMicrosiga           บ Data ณ  08/05/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ    Alexandre Venancio                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTXML02
Local lRet			:= .T.
Local nCont			:= 0

Private cPathL		:= "C:\xml_imp\" 	//Diretorio padrao onde devem estar os arquivos xmls para serem importados
Private cPath		:=	"\spool\"
Private aItensXML	:=	{}
Private aList4		:=	{}
Private nItem		:= 0
Private aCabec		:= {}
Private aItens		:= {}
Private aLinha		:= {}
Private lExistArq	:= .F.
Private lIniLog		:= .F.
Private aItensCad	:=	{}          
Private aAuxDeP		:=	{}
Private cCNPJ_FOR
Private cNum,nVlrCFST,nVlrDesc,nVlrICM,nVlrOutro,nVlrPIS,nVlrPISS,nVlrTotal
Private cSerie,cDtEmissao,cHoraEm,nVlrCofins,cNumTitulo,cCmp,cFornec,cLjFornec
Private aArquivo
Private cCondPg

If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf

cfilelog        :=  dtos(ddatabase)+strtran(cvaltochar(time()),":")+'.txt'
nHandlel	    :=	fcreate('C:\xml_imp\'+cfilelog, FO_READWRITE + FO_SHARED )

FWrite(nHandlel,"#######################################################"+CRLF,1000)
FWrite(nHandlel,"Inicio :"+cvaltochar(time())+CRLF,1000)

aArquivo	:= directory(cPathL+"*.XML","D")		//Varredura no Diretorio padrao onde devem se encontrar os xmls para importacao
aCondPg	 	:= CondPgto()


If !ExistDir( cPathL+"\Processados" )
	MakeDir( cPathL+"\Processados" )
EndIf

If !ExistDir( cPathL+"\Erros" )
	MakeDir( cPathL+"\Erros" )
EndIf

For nCont := 1 To Len(aArquivo)

	cFile := Lower(aArquivo[nCont][1])
	If Alltrim(cFile) != "." .And. Alltrim(cFile) != ".." .And. aArquivo[nCont,05] <> "D"
		If File(cPathL+cFile,2)
			CpyT2S(cPathL+cFile,cPath)
			FWrite(nHandlel,"-------------------"+CRLF,1000)
			FWrite(nHandlel,"Arquivo :"+cvaltochar(cFile)+CRLF,1000)
			Processa( {|| lRet := XMLNfe(cFile)},"Processando o arquivo "+Alltrim(cFile)+", aguarde" )	
			If lRet
				FWrite(nHandlel,"	Processado com sucesso"+CRLF,1000)
				//fclose(nHandlel)
				FRename(cPathL+cFile,cPathL+"processados\"+STRTRAN(UPPER(cFile),".XML",".PROC"))
			Else
				FWrite(nHandlel,"	Nใo processado"+CRLF,1000)
				//fclose(nHandlel)
				FRename(cPathL+cFile,cPathL+"Erros\"+cFile)
			EndIf
		EndIf
	EndIF
Next nCont

FWrite(nHandlel,"#######################################################"+CRLF,1000)
FWrite(nHandlel,"Finalizou :"+cvaltochar(time())+CRLF,1000)
FWrite(nHandlel,"#######################################################"+CRLF,1000)

fclose(nHandlel)

WinExec('NOTEPAD '+"C:\xml_imp\" + cfilelog,1)
//MsgAlert("Finalizado")

Return
                       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO11    บAutor  ณMicrosiga           บ Data ณ  04/26/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function XMLNfe(cFile)

Local aArea			:= GetArea()
Local lRet			:= .T.                       
Local cError		:= ""
Local cWarning		:= ""
Local oXml			:= NIL

Private cTesCli		:=	""

aItensCad 	:= {}
aList4		:= {}
cCondPg		:=	''

oXml := XmlParserFile( cPath+cFile, "_", @cError, @cWarning )

If ValType(oXml) != "O"
     MsgAlert(cFile+" - "+cError)
     Return(.F.)
Endif


cVersaoNFE := oXML:_nfeProc:_versao:TEXT

cTipNf := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_TPNF:TEXT
If cTipNf <> "1"
	//MsgAlert("Esta rotina processa somente seus XMLดs de saํda")
	FWrite(nHandlel,"Esta rotina processa apenas xmls de saํda"+CRLF,1000)
	Return(.F.)
EndIf
// -> Verifica se NF estแ autorizada na Sefaz
cChave_NFe := SubStr(oxml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4)
cProtocol  := oxml:_NFEPROC:_PROTNFE:_INFPROT:_NPROT:TEXT

If Empty(cChave_NFe)
	MsgAlert("A chave de acesso nใo foi informada!","XMLNFE")
	Return(.F.)
EndIf   
	         
// Se a Tag NFEPROC:NFE:INFNFE:_DET for Objeto
If ValType(oXml:_NfeProc:_Nfe:_InfNfe:_DET) = "O"
     XmlNode2Arr(oXml:_NfeProc:_Nfe:_InfNfe:_DET, "_DET")
EndIf

// Gera Array com os dados dos produtos do XML
aItensXML	:= oXML:_nfeProc:_NFe:_infNFe:_Det
aItensXML	:= IIf(ValType(aItensXML)=="O", {aItensXML}, aItensXML)

If Len(aItensXML) == 0
	MsgAlert("Erro na estrutura dos Itens do arquivo XML!", "XMLNfe")
	Return(.F.)
EndIf

// Inicializa as variaveis de controle
nError := 0
cFilorig := "XX"
//cnpj
cCNPJ_FIL := oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT


//OpenSm0()
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

cFilant := cFilorig 
//Opensm0(cempant+cFilant)
//Openfile(cempant+cFilant)

If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_DEST , "_CNPJ" ) != Nil
	cCNPJ_CLI := oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
Else
	cCNPJ_CLI := oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT
EndIf

cEstD := oXml:_NFEPROC:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT
//Verificando fornecedor: " +cCNPJ_FOR)                  
cNum	:= PadL(Alltrim(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,"0") //Nro da Nota
cSerie	:= Alltrim(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text) //STRZero(val(Alltrim(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text)),3)
cNatOp	:= PadR(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_NATOP:Text,45," ")

If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE , "_COBR") != Nil
	If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_COBR, "_DUP") != Nil
		aDupAux := oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP
		If valtype(aDupAux) == "O"
			cCondPg := "001"
		Else
			If len(aDupAux) == 1
				cCondPg := "001"
			Else
				nPos := Ascan(aCondPg,{|x| cvaltochar(len(aDupAux))+"X" $ x[2] })
				If nPos > 0 
					cCondPg := aCondPg[nPos,01]
				Else
					cCondPg := '001'
				EndIf
			Endif
		EndIf
	Else
		cCondPg := '001'
	EndIf
else
	cCondPg := '001'
EndIf

DBSelectArea("SA1")
DBSetOrder(3)
If DbSeek(xFilial("SA1")+cCNPJ_CLI) 
	cFornec		:= SA1->A1_COD
	cLjFornec	:= SA1->A1_LOJA
	cEstFor		:= SA1->A1_EST
	cNomeFor	:= SA1->A1_NOME
	cForCond	:= SA1->A1_COND  
	cEndFor		:= Alltrim(SA1->A1_END)+" - "+Alltrim(SA1->A1_BAIRRO)+" - "+Alltrim(SA1->A1_MUN)+" - "+cEstFor
	cIE_CLI		:= SA1->A1_INSCR
	//cTesCli		:= SA1->A1_XTES
EndIf

If !Empty(cFornec)
	nNumItens	:= LEN(aItensXML) 
	
	cDtEmissao	:= oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dhEmi:Text
	cDtEmissao	:= CTOD(Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4))
	
	//Base ICMS
	nBaseIcm	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:Text)
	//Valor ICMS
	nVlrIcm		:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:Text)
	// Valor Mercadorias
	nTotalMerc	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:Text)  
	//Base ST
	nBaseSt		:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:Text)	
	// -> Inicializa a variavel para realizar o somatorio de descontos da nota.
	nDescNota	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:Text)
	//Valor IPI
	nVlrIPI 	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:Text)
	
	cNumTitulo      := cNum
	nValor          := Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:Text)
	
	If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT , "VOUTRO" ) != Nil
		nAcrescimo := Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:Text)
	Else
	     nAcrescimo := 0
	Endif
	
	cVencimento := ""
	
	nFrete	:= val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:Text)
	
	nSeguro	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VSeg:Text)
	//Valor ST
	nIcmsSubs	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:Text)
	 
	Aadd(aList4,{nBaseIcm,nVlrIcm,nBaseSt,nIcmsSubs,nTotalMerc,nFrete,nSeguro,nDescNota,nAcrescimo,nVlrIPI,nValor}) 
	
	
	// Verifica Produtos - amarra็ใo
	lCadOk	:= ValProd(cFornec, cLjFornec, aItensXML)
	
	dDataBase := cDtEmissao
    gerarnf()
	//lRet := GERAPV(cFile)
Else
	FWrite(nHandlel,"Cliente nใo encontrado na base - cnpj "+cCNPJ_CLI+CRLF,1000)
	conout("Cliente inexistente para o cnpj "+cCNPJ_CLI)
	lRet := .F.
EndIf

nItem	:= 0
aCabec	:= {}
aItens	:= {}
aLinha	:= {}

lExistArq	:= .F.
lIniLog		:= .F.

oXml := NIL

RestArea(aArea)
	
Return lRet

/*/{Protheus.doc} gerarnf
    (long_description)
    @type  Static Function
    @author user
    @since 28/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gerarnf()

Local aArea :=  GetArea()
Local nX 

DbSelectArea("Z52")
Reclock("Z52",.T.)
//cCNPJ_CLI
Z52->Z52_FILIAL :=  cFilant
Z52->Z52_DOC    :=  cNum
Z52->Z52_SERIE  :=  cSerie
Z52->Z52_CLIENT :=  cFornec
Z52->Z52_LOJA   :=  cLjFornec
Z52->Z52_COND   :=  cCondPg
Z52->Z52_EMISSA :=  cDtEmissao
Z52->Z52_EST    :=  cEstD
//Aadd(aList4,{nBaseIcm,nVlrIcm,nBaseSt,nIcmsSubs,nTotalMerc,nFrete,nSeguro,nDescNota,nAcrescimo,nVlrIPI,nValor}) 

Z52->Z52_FRETE  :=  aList4[1,6]
Z52->Z52_SEGURO :=  aList4[1,7]
Z52->Z52_VALBRU :=  aList4[1,5]
Z52->Z52_VALICM :=  aList4[1,2]
Z52->Z52_BASEIC :=  aList4[1,1]
Z52->Z52_VALIPI :=  aList4[1,10]
Z52->Z52_BASEIP :=  aList4[1,1]
Z52->Z52_VALMER :=  aList4[1,5]
Z52->Z52_CHVNFE :=  cChave_NFe
Z52->(MsUnlock())

FOR nX := 1 to len(aItensCad)  
    DbSelectArea("Z53")
    Reclock("Z53",.T.)
	Z53->Z53_FILIAL :=  cFilant
    Z53->Z53_ITEM   :=  aItensCad[nX,01]
    Z53->Z53_COD    :=  aItensCad[nX,02]
    Z53->Z53_UM     :=  'PC'
    Z53->Z53_QUANT  :=  aItensCad[nX,05]
    Z53->Z53_PRCVEN :=  aItensCad[nX,06]
    Z53->Z53_TOTAL  :=  aItensCad[nX,07]
    Z53->Z53_DOC    :=  cNum
    Z53->Z53_SERIE  :=  cSerie
    Z53->Z53_EMISSA :=  cDtEmissao
    Z53->Z53_CLIENT :=  cFornec
    Z53->Z53_LOJA   :=  cLjFornec
    Z53->(MsUnlock())
Next nX 

RestArea(aArea)

Return


//Gerapv - 
Static Function GERAPV(cFile)

Local aArea		:=	GetArea()
Local lRet		:=	.F.
Local aCabec    := {}
Local aItens   	:= {}   
Local aLinha    := {}
Local cDoc 		:= GetSxeNum("SC5", "C5_NUM")
Local nX		:=	0

aadd(aCabec, {"C5_NUM"		, cDoc			,Nil})
aadd(aCabec, {"C5_TIPO"		, "N"			,Nil})
aadd(aCabec, {"C5_CLIENTE"	, cFornec		,Nil})
aadd(aCabec, {"C5_LOJACLI"	, cLjFornec		,Nil})
aadd(aCabec, {"C5_LOJAENT"	, cLjFornec		,Nil})
aadd(aCabec, {"C5_EMISSAO"	, dDatabase		,Nil}) // Data de emissao
aadd(aCabec, {"C5_TIPOCLI"	, 'F'			,Nil}) // Tipo de cliente
aadd(aCabec, {"C5_TIPOPV" 	, '1'			,Nil}) //
aadd(aCabec, {"C5_MOEDA"  	, 1				,Nil})  // Moeda
aadd(aCabec, {"C5_CONDPAG"	, cCondPg		,Nil})
aadd(aCabec, {"C5_NATUREZ"  ,"11010007"     ,Nil})  
aadd(aCabec, {"C5_VEND1"    , '000001'      ,Nil})


FOR nX := 1 to len(aItensCad)  
	aLinha := {}
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+aItensCad[nX,02])
	
      aadd(aLinha,{"C6_ITEM",    aItensCad[nX,01], Nil})
      aadd(aLinha,{"C6_PRODUTO", aItensCad[nX,02], Nil})
      aadd(aLinha,{"C6_QTDVEN",  aItensCad[nX,05], Nil})
      aadd(aLinha,{"C6_PRCVEN",  aItensCad[nX,06], Nil})
      aadd(aLinha,{"C6_PRUNIT",  aItensCad[nX,06], Nil})
      aadd(aLinha,{"C6_VALOR",   aItensCad[nX,07], Nil})
      //aadd(aLinha,{"C6_TES",     '502'			 , Nil})
	  aadd(aLinha,{"C6_TES",     '999'			 , Nil})
      //aadd(aLinha,{"C6_OP"	,    '01'			 , Nil})
      aadd(aLinha,{"C6_LOCAL",   SB1->B1_LOCPAD	 , Nil})
      
      
      aadd(aItens, aLinha)

NEXT      

lMsErroAuto := .F.            

Begin Transaction 

         
 MSExecAuto({|a, b, c| MATA410(a, b, c)}, aCabec, aItens, 3)
 
If !lMsErroAuto
	ConOut("Incluํdo com sucesso! " + cDoc)
	ConfirmSX8()
	lRet := .T.
Else
	//mostraerro()
	MostraErro(cPathL,strtran(Alltrim(cFile),".xml","")+"_erro.txt")
	FWrite(nHandlel,"Erro na geracao do pedido"+CRLF,1000)
	ConOut("Erro na inclusใo!")
	lRet := .F.
EndIf

End Transaction 

//Libera็ใo de pedido
If lRet
	DbSelectArea("SC5")
	DbSetOrder(1)
	If DbSeek(xFilial("SC5")+cDoc) 
		SC6->(DbSelectArea("SC6"))
		        SC6->(DbSetOrder(1))
		        SC6->(DbGoTop())
		        SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		        
				Do While SC6->(!EOF()) .And. SC6->C6_NUM == SC5->C5_NUM
					DbSelectArea("SA1")
					SA1->(DbSetOrder(1))
			        SA1->(DbGoTop())
			        SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		
					DbSelectArea("SE4")
					SE4->(DbSetOrder(1))
			        SE4->(DbGoTop())
			        SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
		
					DbSelectArea("SB1")
					SB1->(DbSetOrder(1))
			        SB1->(DbGoTop())
			        SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
		
					DbSelectArea("SB2")
					SB2->(DbSetOrder(1))
			        SB2->(DbGoTop())
			        SB2->(DbSeek(xFilial("SB2")+SC6->C6_PRODUTO))
		
					DbSelectArea("SF4")
					SF4->(DbSetOrder(1))
			        SF4->(DbGoTop())
			        SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))
		
					//Faz libera็ใo do pedido de venda
					MaLibDoFat( SC6->(RecNo()),SC6->C6_QTDVEN,.F.   ,.F.          ,.T.     ,.T.     ,.T.     , .T.          )
					SC6->(DbSkip())
				EndDo
				
				lRet := MyPVLNFS(cDoc,cSerie)
	EndIF
endif

RestArea(aArea)

Return lRet
//Fim GeraPv - 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO11    บAutor  ณMicrosiga           บ Data ณ  04/26/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValProd(cCodFrn, cLojaFrn, aItensXML)
 
Local aArea			:= GetArea()
Local cProdsForn 	:= ""
Local nI			:= 0
Local cCodItem		:= ""
Local cDescItem		:= ""
Local lRet			:= .F.
Local cNumItem		:= ""            
Local cTes			:= ''

cBarra := ''
cProdsForn := ''
For nI := 1 To Len(aItensXML)
	cNumItem	:= Strzero(val(aItensXML[nI]:_nITEM:Text),2)
	cCodItem	:= Alltrim(aItensXML[nI]:_prod:_cProd:Text)
	
	dbSelectArea("SB1")
	DbSetOrder(1)
	Dbseek(xFilial("SB1")+cCodItem)
	                          
	
	If Ascan(aAuxDeP,{|x| Alltrim(x[1])+x[3] == Alltrim(cCodItem)+cNum}) > 0
		cTes	 := aAuxDeP[Ascan(aAuxDeP,{|x| Alltrim(x[1])+x[3] == Alltrim(cCodItem)+cNum}),05]
		cCodItem := aAuxDeP[Ascan(aAuxDeP,{|x| Alltrim(x[1])+x[3] == Alltrim(cCodItem)+cNum}),02]
	EndIf
	
	cDescItem	:= AllTrim(aItensXML[nI]:_prod:_xProd:Text)
	cCfop		:= AllTrim(aItensXML[nI]:_prod:_CFOP:Text) 
	cNCM		:= AllTrim(aItensXML[nI]:_prod:_NCM:Text)
	nQtdC		:= val(aItensXML[nI]:_prod:_QTRIB:Text) 
	nQtdP		:= val(aItensXML[nI]:_prod:_QCOM:Text) 
	cUNd		:= AllTrim(aItensXML[nI]:_prod:_UCOM:Text)  
	
	If XmlChildEx( aItensXML[nI]:_prod, "_VOUTRO" ) != Nil
		cOutro := AllTrim(aItensXML[nI]:_prod:_VOUTRO:Text)
	Else
		cOutro := 0
	Endif
	If XmlChildEx( aItensXML[nI]:_prod, "_CEST" ) != Nil
		cCest	:= AllTrim(aItensXML[nI]:_prod:_CEST:Text)
	Else
		cCest	:=	''
	EndIF
	nVlrUn		:= val(aItensXML[nI]:_prod:_VUNCOM:Text)
	nVlrSeg 	:= val(aItensXML[nI]:_prod:_VUNTRIB:Text)
	nVlrTo		:= val(aItensXML[nI]:_prod:_VPROD:Text)
	
	cProdsForn += cBarra + Alltrim(cCodItem)
	cBarra := "','"   
	aAdd(aItensCad, {cNumItem,cCodItem,PadR('',TamSX3("B1_COD")[1]), cDescItem,nQtdP,nVlrUn,nVlrTo,cCfop,cNCM,cUNd,cOutro,cCest,cNum,cSerie,nVlrSeg,nQtdC,cTes})
Next    

RestArea(aArea)

Return lRet

/*
	Gera a nota fiscal

*/
Static Function MyPVLNFS(cC5Nump,cSerie)

Local aArea		:=	GetArea()
Local lRet 		:=	.F.
Local aPvlDocS 	:=	{}
Local nPrcVen 	:=	0
Local cC5Num  	:=	cC5Nump
//Local cSerie  	:=	"1"
Local cEmbExp 	:=	""
Local cDocA    	:=	""
Local cBakF2	:=	""

DbSelectArea("SX5")
DbSetOrder(1)
If DbSeek("010101"+cSerie)
	cBakF2 := Alltrim(SX5->X5_DESCRI)
	Reclock("SX5",.F.)
	SX5->X5_DESCRI := cNum
	SX5->(Msunlock())
EndIf 

    SC5->(DbSetOrder(1))
    SC5->(MsSeek(xFilial("SC5")+cC5Num))

    SC6->(dbSetOrder(1))
    SC6->(MsSeek(xFilial("SC6")+SC5->C5_NUM))

    //ษ necessแrio carregar o grupo de perguntas MT460A, se nใo serแ executado com os valores default.
    Pergunte("MT460A",.F.)

    // Obter os dados de cada item do pedido de vendas liberado para gerar o Documento de Saํda
    While SC6->(!Eof() .And. C6_FILIAL == xFilial("SC6")) .And. SC6->C6_NUM == SC5->C5_NUM

        SC9->(DbSetOrder(1))
        SC9->(MsSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM))) //FILIAL+NUMERO+ITEM

        SE4->(DbSetOrder(1))
        SE4->(MsSeek(xFilial("SE4")+SC5->C5_CONDPAG) )  //FILIAL+CONDICAO PAGTO

        SB1->(DbSetOrder(1))
        SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))    //FILIAL+PRODUTO

        SB2->(DbSetOrder(1))
        SB2->(MsSeek(xFilial("SB2")+SC6->(C6_PRODUTO+C6_LOCAL))) //FILIAL+PRODUTO+LOCAL

        SF4->(DbSetOrder(1))
        SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))   //FILIAL+TES

        nPrcVen := SC9->C9_PRCVEN
        If ( SC5->C5_MOEDA <> 1 )
            nPrcVen := xMoeda(nPrcVen,SC5->C5_MOEDA,1,dDataBase)
        EndIf

		If !Empty(SC9->C9_BLEST) .Or. !Empty(SC9->C9_BLCRED)
			Reclock("SC9",.F.)
			SC9->C9_BLEST	:=	""
			SC9->C9_BLCRED	:=	""
			SC9->(Msunlock())
		EndIf
		
    	AAdd(aPvlDocS,{ SC9->C9_PEDIDO,;
                    	SC9->C9_ITEM,;
                    	SC9->C9_SEQUEN,;
                    	SC9->C9_QTDLIB,;
                    	nPrcVen,;
                    	SC9->C9_PRODUTO,;
                    	.F.,;
                    	SC9->(RecNo()),;
                    	SC5->(RecNo()),;
                    	SC6->(RecNo()),;
                    	SE4->(RecNo()),;
                    	SB1->(RecNo()),;
                    	SB2->(RecNo()),;
                    	SF4->(RecNo())})
		//EndIf

        SC6->(DbSkip())
    EndDo

	SetFunName("MATA461")
    
    cDocA := MaPvlNfs(  /*aPvlNfs*/         aPvlDocS,;  // 01 - Array com os itens a serem gerados
                       /*cSerieNFS*/       cSerie,;    // 02 - Serie da Nota Fiscal
                       /*lMostraCtb*/      .F.,;       // 03 - Mostra Lan็amento Contแbil
                       /*lAglutCtb*/       .F.,;       // 04 - Aglutina Lan็amento Contแbil
                       /*lCtbOnLine*/      .F.,;       // 05 - Contabiliza On-Line
                       /*lCtbCusto*/       .T.,;       // 06 - Contabiliza Custo On-Line
                       /*lReajuste*/       .F.,;       // 07 - Reajuste de pre็o na Nota Fiscal
                       /*nCalAcrs*/        0,;         // 08 - Tipo de Acr้scimo Financeiro
                       /*nArredPrcLis*/    0,;         // 09 - Tipo de Arredondamento
                       /*lAtuSA7*/         .T.,;       // 10 - Atualiza Amarra็ใo Cliente x Produto
                       /*lECF*/            .F.,;       // 11 - Cupom Fiscal
                       /*cEmbExp*/         cEmbExp,;   // 12 - N๚mero do Embarque de Exporta็ใo
                       /*bAtuFin*/         {||},;      // 13 - Bloco de C๓digo para complemento de atualiza็ใo dos tํtulos financeiros
                       /*bAtuPGerNF*/      {||},;      // 14 - Bloco de C๓digo para complemento de atualiza็ใo dos dados ap๓s a gera็ใo da Nota Fiscal
                       /*bAtuPvl*/         {||},;      // 15 - Bloco de C๓digo de atualiza็ใo do Pedido de Venda antes da gera็ใo da Nota Fiscal
                       /*bFatSE1*/         {|| .T. },; // 16 - Bloco de C๓digo para indicar se o valor do Titulo a Receber serแ gravado no campo F2_VALFAT quando o parโmetro MV_TMSMFAT estiver com o valor igual a "2".
                       /*dDataMoe*/        dDatabase,; // 17 - Data da cota็ใo para conversใo dos valores da Moeda do Pedido de Venda para a Moeda Forte
                       /*lJunta*/          .F.)        // 18 - Aglutina Pedido Iguais
    
    If !Empty(cDocA)
        Conout("Documento de Saํda: " + cSerie + "-" + cDocA + ", gerado com sucesso!!!")
		DbSelectArea("SF2")
		DbSetOrder(1)
		If DbSeek(xFilial("SF2")+cDocA+cSerie)
			Reclock("SF2",.F.)
			SF2->F2_CHVNFE := cChave_NFe
			SF2->(Msunlock())
			DbSelectArea("SF3")
			DbSetOrder(4)
			If Dbseek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
				Reclock("SF3",.F.)
				SF3->F3_CHVNFE := cChave_NFe
				SF3->(Msunlock())
			EndIf
			DbSelectArea("SFT")
			DbSetOrder(1)
			If Dbseek(xFilial("SFT")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA)
				While !EOF() .AND. SFT->FT_NFISCAL == SF2->F2_DOC .AND. SFT->FT_SERIE==SF2->F2_SERIE
					Reclock("SFT",.F.)
					SFT->FT_CHVNFE :=  cChave_NFe
					SFT->(Msunlock())
					DBSKIP()
				ENDDO
			ENDIF
		EndIF

        lRet := .T.
	else
		FWrite(nHandlel,"Erro na geracao da nota de saida"+CRLF,1000)
    EndIf

RestArea(aArea)

Return lRet

/*/{Protheus.doc} CondPgto()
	(long_description)
	@type  Static Function
	@author user
	@since date
	@version version
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function CondPgto()

Local aArea	:=	GetArea()
Local aAux  := {}

cQuery := "SELECT E4_CODIGO,E4_DESCRI"
cQuery += " FROM "+RetSQLName("SE4")
cQuery += " WHERE D_E_L_E_T_=' ' AND E4_FILIAL='"+xfilial("SE4")+"'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
	Aadd(aAux,{TRB->E4_CODIGO,Alltrim(TRB->E4_DESCRI)})
	Dbskip()
EndDo

RestArea(aArea)

Return(aAux)
