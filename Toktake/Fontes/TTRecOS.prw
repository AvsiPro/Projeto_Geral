#include "tbiconn.ch"
                    
// recuperar OS atraves dos arquivos XML
User Function TTRecOS()


Processa( { || Fproc() },"Aguarde...","Importando OS..")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTRECOS   ºAutor  ³Microsiga           º Data ³  06/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fproc()
 
Local cPath		:= "\_mobile\mobile\receive_backup\"	// alterar aqui o nome da pasta onde estao os XMLs das OS 
Local cPathProc	:= "\_mobile\mobile\receive_backup\processados\"              
Local aArquivos := Directory(cPath +"*.xml")
Local cError	:= "" 
Local cWarning	:= ""
Local cFile		:= ""
Local oXml
Local aPula		:= {}
Local nI
Local cNumOS	:= ""
Local nRecno	:= 0
Local cCodFil	:= ""
Local cCodEmp	:= "" 
Local nCount	:= 0


ProcRegua( Len(aArquivos) )

If !ExistDir( cPathProc )
	MakeDir( cPathProc )
EndIf

For nI := 1 To Len(aArquivos)

	IncProc("")
	
	nRecno := 0
	cNumOS := ""
	nTpForm := 0
	cForm := ""
	cDescFrm := ""
	cCodTec := ""
	cNomTec := ""
	dDtAg := dDatabase
	cHrAg := "18:00:00"   
	cCodCli := ""
	cLoja := ""
	cNomCli := ""
	cEndereco := ""
	cTabela := ""
	cPatrimo := ""
	cDescPatri := ""
	cRota := ""
	cDescRota := ""
	cTabela := ""
	cCodPa := "" 
	cStatus := ""
	cDescStatus := ""
	

	cFile := aArquivos[nI][1] 
 
	// Gera o objeto com dados do XML
	oXml := XmlParserFile( cPath+cFile, "_", @cError, @cWarning )
	If ValType(oXml) != "O"
		AADD( aPula, { cFile, cError,cWarning,"ERRO ABERTURA"  } )
		Loop
	EndIf
	cFile := Lower(cFile)
	                    
	cNumOS := StrToKarr( cFile,"." )[1]
	//cNumOS := PADL( cNumOS,TamSx3("ZG_NUMOS")[1],"0" )
	STATICCALL( MBM006, fRetFil, cNumOS,@nRecno,@cCodFil,@cCodEmp )
	
	If Empty( cCodFil )
		cCodFil := cFilAnt
	EndIf

	If nRecno == 0 
	
		// pegar os dados do xml
		cCodTec := oXml:_ATENDIMENTO:_ATENDENTE:TEXT
		cPatrimo := oXml:_ATENDIMENTO:_PATRIMONIO:TEXT
		cStatus := oXml:_ATENDIMENTO:_STATUS:TEXT
		cDescFrm := oXml:_ATENDIMENTO:_TIPO:TEXT
		cXStat := oXml:_ATENDIMENTO:_STATUS_HIST:_ACTE:TEXT
		cDtAux := SubStr( cXStat,1,10 )
		cDtAux := StrTran( cDtAux,"-","" )
		dDtAg := StoD( cDtAux )
		                      
		
		/*
		LEITURA DE MAQUINA
		SANGRIA
		ABASTECIMENTO
		MANUTENCAO
		ABASTECIMENTO BEBIDAS
		ENTREGAS
		INSTALACAO
		REMOCAO
		INVENTARIO
		*/
		If cDescFrm == "ABASTECIMENTO BEBIDAS"
			cForm		:= "08"
		ElseIf cDescFrm == "ABASTECIMENTO"
			cForm		:= "04"
		ElseIf cDescFrm == "SANGRIA"
			cForm		:= "03"
		ElseIf cDescFrm == "LEITURA DE MAQUINA"
			cForm		:= "02"
		ElseIf cDescFrm == "MANUTENCAO"
			cForm		:= "06" 
		ElseIf cDescFrm == "INSTALACAO"
			cForm		:= "16" 
		ElseIf cDescFrm == "REMOCAO"
			cForm		:= "17" 
		ElseIf cDescFrm	== "INVENTARIO"
			cForm		:= "21"
		EndIf
		
		// status
		If cStatus == "ACTE"
			cDescStatus := "Recebido pelo Agente"
		ElseIf cStatus == "OPEN"
			cDescStatus := "Criado"
		ElseIf cStauts == "COPE"
			cDescStatus := "Cancelado pela Central"
		ElseIf cStatus == "FIOK"
			cDescStatus := "Finalizado"
		EndIf
		
		dbSelectArea("AA1")
		dbSetOrder(1)
		MSSeek( xFilial("AA1") +AvKey( cCodTec,"AA1_NOMTEC" ) )
		cNomTec := AA1->AA1_NOMTEC
		cRota := AA1->AA1_LOCAL
		
		If !Empty(cRota)
			dbSelectArea( "ZZ1" )
			dbSetOrder(1)
			MSSeek( xFilial("ZZ1") +AvKey(cRota,"ZZ1_COD")  )
			cDescRota := ZZ1->ZZ1_DESCRI
			cEndereco := AllTrim(ZZ1->ZZ1_END) +"," +AllTrim(ZZ1->ZZ1_MUN) +"," +AllTrim(ZZ1->ZZ1_EST)
		EndIf
		                   
		If ! cDescFrm $ "INVENTARIO#CONFERENCIA"
			dbSelectArea("SN1") 
			dbSetOrder(2)
			MsSeek( xfilial("SN1") +AvKey( cPatrimo,"N1_CHAPA" ) ) 
			                           
			cDescPatri := SN1->N1_DESCRIC
			cCodPa := SN1->N1_XPA
			cTabela := SN1->N1_XTABELA
			cCodCli := SN1->N1_XCLIENT
			cLoja := SN1->N1_XLOJA
			
			If !Empty( cCodPA )
				dbSelectArea("ZZ1")
				MSSeek( xFilial("ZZ1") +AvKey(cCodPA,"ZZ1_COD")  )
				cEndereco := AllTrim(ZZ1->ZZ1_END) +"," +AllTrim(ZZ1->ZZ1_MUN) +"," +AllTrim(ZZ1->ZZ1_EST)
			EndIf
			              
			If !Empty( cCodCli )
				dbSelectArea("SA1")
				dbSetOrder(1)
				MSSeek( xFilial("SA1") +AvKey(cCodCli,"A1_COD") +AvKey(cLoja,"A1_LOJA") ) 
				
				cNomCli := SA1->A1_NOME
			EndIf
			  
		EndIf
		
	 	
		RecLock("SZG",.T.)
		SZG->ZG_FILIAL	:= cCodFil
		SZG->ZG_NUMOS	:= cNumOS
		SZG->ZG_TPFORM	:= Val(cForm)
		SZG->ZG_FORM	:= cForm
		SZG->ZG_DESCFRM	:= cDescFrm
		SZG->ZG_CODTEC	:= cCodTec
		SZG->ZG_AGENTED	:= cNomTec
		SZG->ZG_DTCRIAC := dDtAg-1
		SZG->ZG_HRCRIAC := "23:59:59"
		SZG->ZG_DATAINI	:= dDtAg
		SZG->ZG_HORAINI	:= cHrAg
		SZG->ZG_CLIFOR	:= cCodCli
		SZG->ZG_LOJA	:= cLoja
		SZG->ZG_DESCCF	:= cNomCli
		SZG->ZG_END		:= cEndereco
		SZG->ZG_PATRIM	:= cPatrimo
		SZG->ZG_PATRIMD := cDescPatri
		SZG->ZG_ROTA	:= cRota
		SZG->ZG_ROTAD	:= cDescRota
		SZG->ZG_MSG		:= ""
		SZG->ZG_TABELA	:= cTabela
		SZG->ZG_ENVIO	:= ""
		SZG->ZG_DOC		:= ""
		SZG->ZG_SERIE	:= ""
		SZG->ZG_TPDOC	:= ""
		SZG->ZG_TPCRIAC	:= "2"
		SZG->ZG_IDUSR	:= __cUserID 
		SZG->ZG_NOVOFRM	:= .T.
		SZG->ZG_STATUS	:= cStatus
		SZG->ZG_STATUSD := cDescStatus
		SZG->ZG_CODEMP	:= cEmpAnt
		SZG->ZG_CODFIL	:= cCodFil
		SZG->ZG_PA		:= cCodPa
		SZG->( MsUnLock() )
		
		nCount++
		
		
	EndIf
	
	//U_TTMAILN('microsiga@toktake.com.br','rjesus@toktake.com.br',"OS MOBILE: " +cnumOS +" -> OK",{},.F.,"","")
	CONOUT( "GRAVACAO DE OS: " +cNumOS ) 
	
	
	// mover arquivo
	FRename( cPath+cFile, cPathProc+cFile)	 

	
Next nI 

MsgInfo( "Total importado: " +cvaltochar(nCount) )


Return