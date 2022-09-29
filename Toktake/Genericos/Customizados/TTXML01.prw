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
ฑฑบPrograma  ณTTXML01   บAutor  ณMicrosiga           บ Data ณ  08/05/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTXML01

Local aAux1			:= {}
Private cPathL		:= "C:\xml_imp\" 	//Diretorio padrao onde devem estar os arquivos xmls para serem importados
Private aArquivo	:= directory(cPathL+"*.*","D")		//Varredura no Diretorio padrao onde devem se encontrar os xmls para importacao
Private cPath		:=	"\spool\"
Private aItensXML	:=	{}
Private cCNPJ_FOR
Private cNum,nVlrCFST,nVlrDesc,nVlrICM,nVlrOutro,nVlrPIS,nVlrPISS,nVlrTotal
Private cSerie,cDtEmissao,cHoraEm,nVlrCofins,cNumTitulo,cCmp,cFornec,cLjFornec
Private aList4	:=	{}
Private nItem	:= 0
Private aCabec	:= {}
Private aItens	:= {}
Private aLinha	:= {}
Private lExistArq	:= .F.
Private lIniLog		:= .F.
Private aItensCad	:=	{}          
Private cArqDeP		:=	"c:\00\DEPARAAMC.txt"
Private aAuxDeP		:=	{}
Private nHandle 	:=	FT_FUse(cArqDeP) 
                                       
While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
   	aAux1   := StrTokArr(cLine,"/")
   	Aadd(aAuxDeP,{aAux1[1],aAux1[2],strzero(val(aAux1[3]),9),strzero(val(aAux1[4]),2),aAux1[5]})
	FT_FSKIP()
End              

FT_FUse()

For nI := 1 To Len(aArquivo)

	cFile := Lower(aArquivo[nI][1])
	If Alltrim(cFile) != "." .And. Alltrim(cFile) != ".." .And. aArquivo[nI,05] <> "D"
		If File(cPathL+cFile,2)
			CpyT2S(cPathL+cFile,cPath)
			//Aadd(aArq,{cFile,'C:\xml_imp\'})
			//Processa({} XMLNfe(cFile)
			Processa( {|| XMLNfe(cFile),"Carregando dados, aguarde"} )	
		EndIf
	EndIF
Next nI

MsgAlert("Finalizado")

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
                       
Local cError		:= ""
Local cWarning		:= ""
Local oXml			:= NIL
Local oXmlWS		:= NIL	// Objeto XML que serแ utilizado na abertura da OS no Keeple

aItensCad := {}
aList4		:= {}

oXml := XmlParserFile( cPath+cFile, "_", @cError, @cWarning )

If ValType(oXml) != "O"
     MsgAlert(cFile+" - "+cError)
     Return()
Endif


cVersaoNFE := oXML:_nfeProc:_versao:TEXT

// -> Verifica se NF estแ autorizada na Sefaz
cChave_NFe := SubStr(oxml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4)
cProtocol  := oxml:_NFEPROC:_PROTNFE:_INFPROT:_NPROT:TEXT

If Empty(cChave_NFe)
	MsgAlert("A chave de acesso nใo foi informada!","XMLNFE")
	Return
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
	Return
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
//Verificando fornecedor: " +cCNPJ_FOR)                  
cNum	:= PadL(Alltrim(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,"0") //Nro da Nota
cSerie	:= Alltrim(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text) //STRZero(val(Alltrim(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text)),3)
cNatOp	:= PadR(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_NATOP:Text,45," ")

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
EndIf

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

CFNFS()

nItem	:= 0
aCabec	:= {}
aItens	:= {}
aLinha	:= {}

lExistArq	:= .F.
lIniLog		:= .F.
	
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

Static Function ValProd(cCodFrn, cLojaFrn, aItensXML)
 
Local aArea		:= GetArea()
Local aAreaAux	:= Array(0)
Local cQuery	:= ""
Local cProdsForn := ""
Local aAux		:= {}
Local nI		:= 0
Local aItens	:= {}
Local cCodItem	:= ""
Local cDescItem	:= ""
Local lFound	:= .F.
Local lRet		:= .F.
Local cNumItem	:= ""            
Local cTes		:= ''

cBarra := ''
cProdsForn := ''
For nI := 1 To Len(aItensXML)
	cNumItem	:= Strzero(val(aItensXML[nI]:_nITEM:Text),2)
	cCodItem	:= Alltrim(aItensXML[nI]:_prod:_cProd:Text)
	                                                                                 //+x[4] +cNumItem
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO13    บAutor  ณMicrosiga           บ Data ณ  05/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CFNFS()

Local aCabec    := {}
Local aItem     := {} 
Local aItensT   := {}   
Local aLinha    := {}
Local dVencCmp	:= ""
Local cNatz		:= ""
Local cDescPag  := ""
Local cCaminho  :=  "C:\01\"
Local cArqv		:=	cvaltochar(cNum)+".txt"

aadd(aCabec,{"F2_TIPO"   	,"N"})
aadd(aCabec,{"F2_FORMUL" 	,"S"})
aadd(aCabec,{"F2_DOC"    	,cNum})
//aadd(aCabec,{"F2_SERIE" 	,cSerie})
aadd(aCabec,{"F2_SERIE" 	,cSerie})
aadd(aCabec,{"F2_EMISSAO"	,cDtEmissao})
aadd(aCabec,{"F2_DAUTNFE"	,cDtEmissao})

aadd(aCabec,{"F2_CLIENTE"	,cFornec}) 
aadd(aCabec,{"F2_CLIENT"	,cFornec}) 

aadd(aCabec,{"F2_TIPOCLI"	,"R"}) 
aadd(aCabec,{"F2_LOJA"   	,cLjFornec})
aadd(aCabec,{"F2_LOJENT"   	,cLjFornec})
aadd(aCabec,{"F2_ESPECIE"	,"SPED"}) 
aadd(aCabec,{"F2_COND"		,"001"})
aadd(aCabec,{"F2_DESCONT"	,0})
aadd(aCabec,{"F2_VALBRUT"	,nValor}) 
aadd(aCabec,{"F2_VALFAT"	,nValor})      
aadd(aCabec,{"F2_FRETE"		,0})
aadd(aCabec,{"F2_TPFRETE"	,"C"})
aadd(aCabec,{"F2_SEGURO"	,0})
aadd(aCabec,{"F2_DESPESA"	,0}) 
aadd(aCabec,{"F2_PREFIXO"	,"001"}) 
aadd(aCabec,{"F2_HORA"		,cHoraEm})
aadd(aCabec,{"F2_HAUTNFE"	,cHoraEm})
aadd(aCabec,{"F2_CHVNFE"	,cChave_NFe})

//aadd(aCabec,{"F2_SERSAT"	,cSrPDV})

FOR nX := 1 to len(aItensCad)  
	aLinha := {}
 //	aAdd(aItensCad, {cNumItem,cCodItem,PadR('',TamSX3("B1_COD")[1]), cDescItem,nQtdP,nVlrUn,nVlrTo,cCfop,cNCM,cUNd,cOutro,cCest,cNum,cSerie,0,0})	
	aadd(aLinha,{"D2_ITEM" 		,aItensCad[nX,01],Nil})
    aadd(aLinha,{"D2_COD" 		,aItensCad[nX,02],Nil})
    aadd(aLinha,{"D2_QUANT"		,aItensCad[nX,05],Nil})
    aadd(aLinha,{"D2_PRCVEN"	,aItensCad[nX,06],Nil})
    aadd(aLinha,{"D2_TOTAL"		,aItensCad[nX,07],Nil})
    aadd(aLinha,{"D2_TES"		,aItensCad[nX,17],Nil})
    aadd(aLinha,{"D2_CF"		,aItensCad[nX,08],Nil})
    //aadd(aLinha,{"D2_ESPECIE"	,"SATCE"		 ,Nil}) 
	
	aadd(aItensT,aLinha)

NEXT      

lMsErroAuto := .F.            

Begin Transaction 

dDiaBkp   := dDataBase
dDataBase := cDtEmissao
         
MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItensT,3) //Inclusao 

dDataBase := dDiaBkp

If lMsErroAuto
	mostraerro(cCaminho,cArqV)
Else  
	FRename(cPathL+cFile,"c:\xml_proc\"+cFile)     
	clQuery := " UPDATE "+RetSqlName("SF3")
	clQuery += " SET F3_PROTOC='"+cProtocol+"',F3_CODRSEF='100',F3_DESCRET='Autorizado o uso da NF-e',F3_CODRET='M'"
	clQuery += " WHERE D_E_L_E_T_='' "
	clQuery += " AND F3_FILIAL='"+xFilial("SF3")+"' "
	clQuery += " AND F3_CLIEFOR='"+cFornec+"' AND F3_LOJA='"+cLjFornec+"'"
	clQuery += " AND F3_SERIE='"+cSerie+"' AND F3_NFISCAL='"+cNum+"'"
	clsql   :=	TcSqlExec(clQuery)	

	/*
	clQuery := " UPDATE "+RetSqlName("SFT")
	clQuery += " SET FT_CHVNFE='"+cChave_NFe+"',FT_ESPECIE='SATCE',FT_SERSAT='"+cSrPDV+"'"
	clQuery += " WHERE D_E_L_E_T_='' "
	clQuery += " AND FT_FILIAL='"+xFilial("SFT")+"' "
	clQuery += " AND FT_TIPOMOV='S' AND FT_CLIEFOR='000001   ' AND FT_LOJA='01  '"
	clQuery += " AND FT_SERIE='"+cSerie+"' AND FT_NFISCAL='"+cNum+"'"
	clsql   :=	TcSqlExec(clQuery)	
	
	clQuery := " UPDATE "+RetSqlName("SF3")
	clQuery += " SET F3_CHVNFE='"+cChave_NFe+"',F3_ESPECIE='SATCE',F3_SERSAT='"+cSrPDV+"'"
	clQuery += " WHERE D_E_L_E_T_='' "
	clQuery += " AND F3_FILIAL='"+xFilial("SF3")+"' "
	clQuery += " AND F3_CLIEFOR='000001   ' AND F3_LOJA='01  '"
	clQuery += " AND F3_SERIE='"+cSerie+"' AND F3_NFISCAL='"+cNum+"'"
	clsql   :=	TcSqlExec(clQuery)	
	
	clQuery := " UPDATE "+RetSqlName("SF2")
	clQuery += " SET F2_CHVNFE='"+cChave_NFe+"',F2_ESPECIE='SATCE',F2_SERSAT='"+cSrPDV+"'"
	clQuery += " WHERE D_E_L_E_T_='' "
	clQuery += " AND F2_FILIAL='"+xFilial("SF2")+"' "
	clQuery += " AND F2_CLIENTE='000001   ' AND F2_LOJA='01  '"
	clQuery += " AND F2_SERIE='"+cSerie+"' AND F2_DOC='"+cNum+"'"
	clsql   :=	TcSqlExec(clQuery)	
	
	clQuery := " UPDATE "+RetSqlName("SD2")
	clQuery += " SET D2_ORIGLAN=''"
	clQuery += " WHERE D_E_L_E_T_='' "
	clQuery += " AND D2_FILIAL='"+xFilial("SD2")+"' "
	clQuery += " AND D2_CLIENTE='000001   ' AND D2_LOJA='01  '"
	clQuery += " AND D2_SERIE='"+cSerie+"' AND D2_DOC='"+cNum+"'"
	clsql   :=	TcSqlExec(clQuery)	
	   */
EndIf
    /*
	If cCmp == "01"
		dVencCmp	:= cDtEmissao
		cNatz	:= "1013"
		cDescPag	:= "PAGTO A VISTA"
	Elseif cCmp == "03"
		dVencCmp	:= cDtEmissao+1
		cNatz	:= "1014"
		cDescPag	:= "PAGTO DEBITO"
	Else
		dVencCmp	:= cDtEmissao+30
		cNatz	:= "1015"       
		cDescPag	:= "PAGTO CREDITO"	
	Endif
	
	aFin040	:= {}
	
	AADD( aFin040, {"E1_FILIAL"		,	xFilial("SE1")	,Nil})
	AADD( aFin040, {"E1_PREFIXO"	,	cSerie			,Nil})
	AADD( aFin040, {"E1_NUM"		,	cNum			,Nil})
	//AADD( aFin040, {"E1_PARCELA"	,		,Nil})
	AADD( aFin040, {"E1_TIPO"		,	"CF "	   		,Nil})
	AADD( aFin040, {"E1_NATUREZ"	,	cNatz			,Nil})
	AADD( aFin040, {"E1_EMISSAO"	,	cDtEmissao      ,Nil})
	AADD( aFin040, {"E1_CLIENTE"	,	"000001   "		,Nil})
	AADD( aFin040, {"E1_LOJA"		,	"01  "			,Nil})
	AADD( aFin040, {"E1_VALOR"		,	nVlrTotal 		,Nil})		
	AADD( aFin040, {"E1_VLRREAL"	,	nVlrTotal		,Nil})		
	AADD( aFin040, {"E1_SALDO"		,	nVlrTotal 		,Nil})			
	AADD( aFin040, {"E1_VENCTO"		,	dVencCmp		,Nil})
	AADD( aFin040, {"E1_VENCREA"	,	dVencCmp		,Nil})
	AADD( aFin040, {"E1_VENCORI"	,	dVencCmp		,Nil})
	AADD( aFin040, {"E1_XTIPO"		,	cDescPag		,Nil})
	
	//Invocando rotina automแtica para cria็ใo
	//MSExecAuto({|x,y| Fina040(x,y)}, aFin040, 3)
	lMsErroAuto := .F.
	
	MsExecAuto( { |a,b, c, d,e, f, g | FINA040(a,b, c, d,e, f, g)} , aFin040, 3,,,,, ) // 3 - Inclusao, 4 - Altera็ใo, 5 - Exclusใo
	
	If lMsErroAuto
		mostraerro()
	Else   
		FRename(cPathL+cFile,"c:\xml_proc\"+cFile)
	//EndIf*/

End Transaction 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO13    บAutor  ณMicrosiga           บ Data ณ  05/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ItemCfCan(cChvCan)

Local cQuery 
Local aRet		:=	{}

cQuery := "SELECT FT_ITEM,FT_PRODUTO,FT_QUANT,FT_PRCUNIT,FT_TOTAL,FT_TES,FT_CFOP,FT_NFISCAL,FT_SERIE,FT_EMISSAO" 
cQuery += " FROM "+RetSQLName("SFT")
cQuery += " WHERE FT_CHVNFE='"+cChvCan+"' AND FT_FILIAL='"+xFilial("SFT")+"'"
cQuery += " AND FT_CLIEFOR='000001' AND FT_LOJA='01'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
    
DbSelectArea("TRB")  

While !EOF()
	Aadd(aRet,{TRB->FT_ITEM,TRB->FT_PRODUTO,TRB->FT_QUANT,TRB->FT_PRCUNIT,TRB->FT_TOTAL,;
				TRB->FT_TES,TRB->FT_CFOP,TRB->FT_NFISCAL,TRB->FT_SERIE,STOD(TRB->FT_EMISSAO)})
	Dbskip()
EndDo

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO13    บAutor  ณMicrosiga           บ Data ณ  05/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CupomCanc()

Local aCabec    := {}
Local aItem     := {} 
Local aItensT   := {}   
Local aLinha    := {}
Local dVencCmp	:= ""
Local cNatz		:= ""
Local cDescPag  := ""
Local cCaminho  :=  "C:\01\"
Local cArqv		:=	cvaltochar(cNum)+".txt"



DbSelectArea("SF2")
DbSetOrder(2)
/*
INDICE 2 SF2
F2_FILIAL F2_CLIENTE F2_LOJA F2_DOC F2_SERIE F2_TIPO F2_ESPECIE
*/
If Dbseek(xFilial("SF2")+'000001   01  '+aItensCad[1,8]+aItensCad[1,9]+"N")
	Reclock("SF2",.F.)
	DbDelete()
	SF2->(Msunlock())
EndIf

DbSelectArea("SD2")
DbSetOrder(3)
/*
INDICE 3 SD2
D2_FILIAL D2_DOC D2_SERIE D2_CLIENTE D2_LOJA D2_COD D2_ITEM
*/
For nX := 1 to len(aItensCad)
	If DbSeek(xFilial("SD2")+aItensCad[nX,8]+aItensCad[nX,9]+'000001   01  '+aItensCad[nX,2]+aItensCad[nX,1])
		Reclock("SD2",.F.)
		DbDelete()
		SD2->(Msunlock())
	EndIf
Next nX

DbSelectArea("CD2")
DbSetOrder(1)
/*
INDICE 1 CD2
CD2_FILIAL CD2_TPMOV(S) CD2_SERIE CD2_DOC CD2_CODCLI CD2_LOJCLI CD2_ITEM CD2_CODPRO
*/
If DbSeek(xFilial("CD2")+'S'+aItensCad[1,9]+aItensCad[1,8]+'000001   01  ')
	While !EOF() .And. CD2->CD2_FILIAL==xFilial("CD2") .And. CD2->CD2_SERIE==aItensCad[1,9] .And. CD2->CD2_DOC==aItensCad[1,8] .And. CD2->CD2_CODCLI=='000001   '  .And. CD2->CD2_LOJCLI =='01  '
		Reclock("CD2",.F.)
		DbDelete()
		CD2->(Msunlock())
		Dbskip()
	EndDo
EndIf

/*
INDICE 1 SFT
FT_FILIAL FT_TIPOMOV(S) FT_SERIE FT_NFISCAL FT_CLIEFOR FT_LOJA FT_ITEM FT_PRODUTO


PREENCHER FT_NFISCAN E F3_NFISCAN COM O NUMERO DO CUPOM QUE FEZ O CANCELAMENTO (PROXIMO NUMERO)

FT_OBSERV	NF CANCELADA
FT_DTCANC	DATA CANCELAMENTO



*/
DbSelectArea("SFT")
DbSetOrder(1)
For nX := 1 to len(aItensCad)
	If DbSeek(xFilial("SFT")+'S'+aItensCad[nX,9]+aItensCad[nX,8]+'000001   01  '+aItensCad[nX,1]+aItensCad[nX,2])
		Reclock("SFT",.F.)
		SFT->FT_OBSERV 	:= 'NF CANCELADA'
		SFT->FT_DTCANC 	:= cDtEmissao
		SFT->FT_NFISCAN	:= cNum
		SFT->(Msunlock())
	EndIf
Next nX

DbSelectArea("SF3")
DbSetOrder(4)
/*
INDICE 4 SF3
F3_FILIAL F3_CLIEFOR F3_LOJA F3_NFISCAL F3_SERIE
F3_OBSERV	NF CANCELADA
F3_DTCANC	DATA CANCELAMENTO
F3_DESCRET	Cancelamento autorizado
F3_CODRET	M
PREENCHER FT_NFISCAN E F3_NFISCAN COM O NUMERO DO CUPOM QUE FEZ O CANCELAMENTO (PROXIMO NUMERO)

*/
If DbSeek(xFilial("SF3")+'000001   01  '+aItensCad[1,8]+aItensCad[1,9]) 
	While !EOF() .And. SF3->F3_FILIAL==xFilial("SF3") .And. SF3->F3_CLIEFOR == '000001   ' .AND. SF3->F3_LOJA == '01  ' .AND. SF3->F3_SERIE == aItensCad[1,9] .And. SF3->F3_NFISCAL == aItensCad[1,8] 
	
		Reclock("SF3",.F.)
		SF3->F3_OBSERV	:=	'NF CANCELADA'
		SF3->F3_DTCANC	:=	cDtEmissao
		SF3->F3_DESCRET	:=	'Cancelamento autorizado'
		SF3->F3_CODRET	:=	'M'
		SF3->F3_NFISCAN	:= 	cNum
		SF3->(Msunlock())   
		DBSKIP()
	EndDo
	
EndIf


/*
SE1 
INDICE 1
FILIAL PREFIXO NUMERO PARCELA TIPO
*/
DbSelectArea("SE1")
DbSetOrder(1)
If DbSeek(xFilial("SE1")+aItensCad[1,9]+STRZERO(VAL(aItensCad[1,8]),9)+'   CF ')
	Reclock("SE1",.F.)
	DbDelete()
	SE1->(Msunlock())
EndIf

aadd(aCabec,{"F2_TIPO"   	,"N"})
//aadd(aCabec,{"F2_FORMUL" 	,"N"})
aadd(aCabec,{"F2_DOC"    	,cNum})
aadd(aCabec,{"F2_SERIE" 	,cSerie})
aadd(aCabec,{"F2_EMISSAO"	,cDtEmissao})
aadd(aCabec,{"F2_CLIENTE"	,"000001   "}) 
aadd(aCabec,{"F2_TIPOCLI"	,"R"}) 
aadd(aCabec,{"F2_LOJA"   	,"01  "})
aadd(aCabec,{"F2_COND"		,"001"})
aadd(aCabec,{"F2_DESCONT"	,0})
aadd(aCabec,{"F2_VALBRUT"	,nVlrTotal}) 
aadd(aCabec,{"F2_VALFAT"	,nVlrTotal})      
aadd(aCabec,{"F2_FRETE"		,0})
aadd(aCabec,{"F2_SEGURO"	,0})
aadd(aCabec,{"F2_DESPESA"	,0}) 
aadd(aCabec,{"F2_PREFIXO"	,"001"}) 
//aadd(aCabec,{"F2_HORA"		,cHoraEm})
aadd(aCabec,{"F2_CHVNFE"	,cChave_NFe})
aadd(aCabec,{"F2_SERSAT"	,cSrPDV})

//FOR nX := 1 to len(aItensCad)  
	aLinha := {}
 	aadd(aLinha,{"D2_ITEM" 		,strzero(1,2)	,Nil})
    aadd(aLinha,{"D2_COD" 		,'C9999999     ',Nil})
    aadd(aLinha,{"D2_QUANT"		,1				,Nil})
    aadd(aLinha,{"D2_PRCVEN"	,nVlrTotal		,Nil})
    aadd(aLinha,{"D2_TOTAL"		,nVlrTotal		,Nil})
    aadd(aLinha,{"D2_TES"		,'800'			,Nil})
    aadd(aLinha,{"D2_CF"		,'5405'			,Nil})
 	
	aadd(aItensT,aLinha)

//NEXT      

lMsErroAuto := .F.            

Begin Transaction 

dDataBase := cDtEmissao
         
MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItensT,3)  

If lMsErroAuto
	mostraerro(cCaminho,cArqV)
Else
	clQuery := " UPDATE "+RetSqlName("SFT")
	clQuery += " SET FT_CHVNFE='"+cChave_NFe+"',FT_ESPECIE='SATCE',FT_SERSAT='"+cSrPDV+"',FT_TIPO='L',FT_OBSERV='NF CANCELADA',FT_DTCANC='"+DTOS(cDtEmissao)+"'"
	clQuery += " WHERE D_E_L_E_T_='' "
	clQuery += " AND FT_FILIAL='"+xFilial("SFT")+"'"
	clQuery += " AND FT_TIPOMOV='S' AND FT_CLIEFOR='000001   ' AND FT_LOJA='01  '"
	clQuery += " AND FT_SERIE='"+cSerie+"' AND FT_NFISCAL='"+cNum+"'"
	clsql   :=	TcSqlExec(clQuery)	
	
	clQuery := " UPDATE "+RetSqlName("SF3")
	clQuery += " SET F3_CHVNFE='"+cChave_NFe+"',F3_ESPECIE='SATCE',F3_SERSAT='"+cSrPDV+"',F3_TIPO='L',F3_OBSERV='NF CANCELADA',F3_DTCANC='"+DTOS(cDtEmissao)+"'"
	clQuery += " WHERE D_E_L_E_T_='' "
	clQuery += " AND F3_FILIAL='"+xFilial("SF3")+"'"
	clQuery += " AND F3_CLIEFOR='000001   ' AND F3_LOJA='01  '"
	clQuery += " AND F3_SERIE='"+cSerie+"' AND F3_NFISCAL='"+cNum+"'"
	clsql   :=	TcSqlExec(clQuery)	
	
	clQuery := " UPDATE "+RetSqlName("SF2")
	clQuery += " SET F2_CHVNFE='"+cChave_NFe+"',F2_ESPECIE='SATCE',F2_SERSAT='"+cSrPDV+"'"
	clQuery += " WHERE D_E_L_E_T_='' "
	clQuery += " AND F2_FILIAL='"+xFilial("SF2")+"'"
	clQuery += " AND F2_CLIENTE='000001   ' AND F2_LOJA='01  '"
	clQuery += " AND F2_SERIE='"+cSerie+"' AND F2_DOC='"+cNum+"'"
	clsql   :=	TcSqlExec(clQuery)	
	
	clQuery := " UPDATE "+RetSqlName("SD2")
	clQuery += " SET D2_ORIGLAN=''"
	clQuery += " WHERE D_E_L_E_T_='' "
	clQuery += " AND D2_FILIAL='"+xFilial("SD2")+"'"
	clQuery += " AND D2_CLIENTE='000001   ' AND D2_LOJA='01  '"
	clQuery += " AND D2_SERIE='"+cSerie+"' AND D2_DOC='"+cNum+"'"
	clsql   :=	TcSqlExec(clQuery)	
	FRename(cPathL+cFile,"c:\xml_proc\"+cFile)
EndIf

End Transaction

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO13    บAutor  ณMicrosiga           บ Data ณ  05/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT920IT

/*
If SD2->D2_COD == "1" 
//C๓digo do produto   
	SD2->D2_VALICM := 500   
	SD2->D2_PICM   := 12
Endif*/

MsgAlert("chegou")

Return 