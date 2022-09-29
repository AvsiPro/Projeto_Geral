/*
Importador de Inventario
*/
User Function TTEST02()

Local cFile := ""
Local aSays := {}
Local aButtons := {}
Local nOpca := 0
Local cType := "Arquivo CSV (*.CSV) |*.csv|"


//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" 

AADD( aSays,OemToAnsi("Importação de inventário" ) ) 
AADD( aSays,OemToAnsi("Selecione um arquivo para importação dos lançamentos" ) )

AADD( aButtons, { 5,.T.,{|| cFile := cGetFile(cType, OemToAnsi("Selecione o arquivo a ser importado"), 0, "C:\", .T., GETF_LOCALHARD, .F., .F.)  } } )
AADD( aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
AADD( aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
FormBatch( "Inventário", aSays, aButtons )

If nOpca == 1
	If Empty(cFile)
		MsgAlert("Selecione um arquivo válido!")
	Else
		Processa( {|lEnd| fImp(cFile),"Importação"} )
	EndIf		
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XCEST001  ºAutor  ³Microsiga           º Data ³  12/24/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fImp(cFile)

Local aInvent := {} 
Local aaax := {}
Local cLine := ""
Local aLinhas := {}
Local nHandle := FT_FUse(cFile)
Local aProd := {}
Local nCntOk := 0
Local nI := 0

FT_FGoTop()	
While !FT_FEOF()   
	cLine  := FT_FReadLn()
	aaax := strtokarr( cLine,";" )
	AADD( aLinhas, aaax )
	
	FT_FSKIP()
End

FT_FUSE()

If Empty(aLinhas) .Or. Len(aLinhas) == 1
	MsgAlert("Arquivo inválido")
	Return
EndIf

MsgInfo("Vai processar " +cvaltochar(Len(aLinhas)) +" registros")

ProcRegua(Len(aLinhas))

dbSelectArea("SB7")
dbSetOrder(3)	// documento produto local
         	
For nI := 2 To Len(aLinhas)
	
	IncProc("")

	aProd := aclone( aLinhas[nI] )
	
	If aProd[1] != cFilAnt
		cFilAnt := aProd[1]
	EndIf

	dbSelectArea("SB1")
	dbSetOrder(1)
	//If MSSEEK( xFilial("SB1") +avKey(aProd[2],"B1_COD") )
	
		aInvent := {{"B7_FILIAL"	,aProd[1]				,Nil},; 
		            {"B7_COD"		,aProd[2]				,Nil},;
		            {"B7_LOCAL"		,aProd[3]				,Nil},;
		            {"B7_QUANT"		,Val(aProd[4])			,Nil},;
		            {"B7_DOC"		,aProd[5]				,Nil},;
		            {"B7_DATA"		,STOD(aProd[6])			,Nil} }
		
		dbSelectArea("SB7")
		//dbSetOrder(1)	// FILIAL DATA CODIGO LOCAL LOCALIZ NUMSERI LOTECTL NUMLOTE B7_CONTAGE
		dbSetOrder(3)
		
	    //If !MSSeek( xFilial("SB7") +AvKey(dtos(aProd[6]),"B7_DATA") +AvKey(aProd[2],"B7_COD") +AvKey(aProd[3],"B7_LOCAL") ) 		            
		If !MsSeek( xFilial("SB7") +AvKey(aProd[5],"B7_DOC") +AvKey(aProd[2],"B7_COD") +AvKey(aProd[3],"B7_LOCAL") )
			//If procInv(aInvent)
			//	nCntOk++
			//Else
				dbSelectArea("SB7")	
				RecLock("SB7",.T.)
				SB7->B7_FILIAL := aProd[1]
				SB7->B7_COD := aProd[2]
				SB7->B7_LOCAL := aProd[3]
				SB7->B7_QUANT := Val(aProd[4])
				SB7->B7_DOC := aProd[5]
				SB7->B7_DATA := STOD(aProd[6])
				MsUnLock()
				nCntOk++
			//EndIf
		EndIf
	//EndIf
Next nI

MsgInfo("Total de lançamentos: " +cvaltochar(nCntOk))

Return
      

// processa o inventario
Static Function procInv(aInvent)
          
Local lOk := .T.
Private lMsErroAuto := .F.

MSExecAuto ({|x,y,z| MATA270(x,y,z)},aInvent,.T., 3)
If lMsErroAuto
    //MostraErro()
Else
	lOk := .T.
EndIf


Return lOK