#INCLUDE 'PROTHEUS.CH'
#include "fileio.ch"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³INTEST30  ºAutor  ³Microsiga           º Data ³  17/01/22   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³  Digitacao do inventario atraves de arquivo excel.         º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CONEST01()

Local cTitulo := " LANCAMENTO DO INVENTARIO "
Local nOpc    := 0
Local aSay    := {}
Local aButton := {}   
Private cPerg := 'XXX190    '

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
Endif
 
ValidPerg()

aAdd( aSay, "Esse programa fará a leitura do arquivo de inventário e processa-lo" )

AADD( aButton, { 5,	.T., {|| Pergunte(cPerg,.T. ) }} )

aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )

aAdd( aButton, { 2, .T., {|| FechaBatch() }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc == 1
	Processa( {||  gerar() }, "Processando..." )
	//validsb1()
	//GeraB1()
Endif

Return          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³QFTEST01  ºAutor  ³Microsiga           º Data ³  03/13/17   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function gerar()

Local aArea			:=	GetArea()                          
Local cCodInv		:=	DTOS(ddatabase)
Private aVetor		:=	{}
Private cArqTxt 	:=	MV_PAR01
Private nHandle 	:=	FT_FUse(cArqTxt)


PRIVATE lMsErroAuto := .F.

// Posiciona na primeria linha
FT_FGoTop()

//Begin Transaction

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	aAux    := SEPARA(cLine,";") 
	aAux[1]	:= Alltrim(aAux[1]) 
	
    

    DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+aAux[2])  
	

		DbSelectArea("SB2")
		DbSetOrder(1)
		If !DbSeek(aAux[1]+Avkey(Alltrim(aAux[2]),"B2_COD")+Avkey(aAux[4],"B2_LOCAL"))
			CriaSB2(aAux[2],aAux[4])
		EndIf

        aVetor := {;
				{"B7_FILIAL" 	,aAux[1]			,Nil},;
				{"B7_COD"		,aAux[2]			,Nil},;
				{"B7_DOC"		,cCodInv			,Nil},;
				{"B7_QUANT"		,val(strtran(aAux[3],",","."))		,Nil},;
				{"B7_LOCAL"		,aAux[4]		    ,Nil},;
				{"B7_DATA"		,DDATABASE			,Nil} }

        lMsErroAuto	:=	.F.
	
        MSExecAuto({|x,y| mata270(x,y)},aVetor,.F.,3)
        
        If lMsErroAuto
            MostraErro()
        Endif		
		
	EndIF			

    	
	
	
	FT_FSKIP()
End

FT_FUSE()
       
//End Transaction

RestArea(aArea)

Return	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³QFTEST01  ºAutor  ³Microsiga           º Data ³  03/13/17   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()
//
Local J := 0
Local I := 0
PRIVATE APERG := {},AALIASSX1:=GETAREA()
//
//     "X1_GRUPO"	,"X1_ORDEM"	,"X1_PERGUNT"      			,"X1_PERSPA"				,"X1_PERENG"				,"X1_VARIAVL"	,"X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"	,"X1_VALID"	,"X1_VAR01"	,"X1_DEF01"	,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"	,"X1_VAR02"	,"X1_DEF02"	,"X1_DEFSPA2"	,"X1_DEFENG2"	,"X1_CNT02"	,"X1_VAR03"	,"X1_DEF03"	,"X1_DEFSPA3"	,"X1_DEFENG3"	,"X1_CNT03"	,"X1_VAR04"	,"X1_DEF04"	,"X1_DEFSPA4"	,"X1_DEFENG4"	,"X1_CNT04"	,"X1_VAR05"	,"X1_DEF05"	,"X1_DEFSPA5"	,"X1_DEFENG5"	,"X1_CNT05"	,"X1_F3"	,"X1_PYME"	,"X1_GRPSXG"	,"X1_HELP"
//
AADD(APERG,{CPERG  ,"01"		,"Origem?"     			,"Origem?"    		    	,"Origem?"     			,"mv_ch1"		,"C"		,80				,0 				,0 				,"G"		,""			,"mv_par01"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,"DIR"   		,"S"		,""				,""})
//
DBSELECTAREA("SX1")
DBSETORDER(1)
//
FOR I := 1 TO LEN(APERG)
	IF  !DBSEEK(CPERG+APERG[I,2])
		RECLOCK("SX1",.T.)
		FOR J := 1 TO len(APERG[I]) 
			IF  j <= LEN(APERG[I])
				FIELDPUT(J,APERG[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
RESTAREA(AALIASSX1)
//
RETURN()



/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 18/01/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function validsb1()

Local aArea			:=	GetArea()                          
Private aVetor		:=	{}
Private nHandlel	:=	fcreate('C:\temp\tim.txt', FO_READWRITE + FO_SHARED )

Private cArqTxt 	:=	MV_PAR01
Private nHandle 	:=	FT_FUse(cArqTxt)


PRIVATE lMsErroAuto := .F.

// Posiciona na primeria linha
FT_FGoTop()

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	aAux    := SEPARA(cLine,";") 

	DbSelectArea("SB1")
	DbSetOrder(1)
	If !DbSeek(xFilial("SB1")+aAux[2])
		FWrite(nHandlel,aAux[2]+CRLF,10000)
	EndIf

	FT_FSKIP()
End

Fclose(nHandle1)

FT_FUSE()

RestArea(aArea)

Return	

/*/{Protheus.doc} GeraB1
	(long_description)
	@type  Static Function
	@author user
	@since 18/01/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function GeraB1()

Local aArea	:=	GetArea()
Local nX 
Private cArqTxt 	:=	MV_PAR01
Private nHandle 	:=	FT_FUse(cArqTxt)
Private aAux		:=	{}
Private aCabec		:=	{}
Private aItens 		:=	{}
Private nCont		:=	1
Private nHandlel	:=	fcreate('C:\temp\IMPORTATIM2.txt', FO_READWRITE + FO_SHARED )

PRIVATE lMsErroAuto := .F.

// Posiciona na primeria linha
FT_FGoTop()

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	aAux    := SEPARA(cLine,";") 
	If nCont == 1
		Aadd(aCabec,aAux)
	Else
		DbSelectArea("SB1")
		DbSetOrder(1)
		If !DbSeek(xFilial("SB1")+aAux[1])
			Reclock("SB1",.T.)
			FWrite(nHandlel,aAux[1]+" nao encontrado"+CRLF,10000)
		Else
			Reclock("SB1",.F.)
			FWrite(nHandlel,aAux[1]+" atualizado"+CRLF,10000)
		EndIf

		SB1->B1_FILIAL := xFilial("SB1")
		For nX := 1 to len(aCabec[1])
			If Alltrim(aCabec[1,nX]) == "B1_PESO" 
				aAux[nX] := val(aAux[nX]) / 100
			ENDIF
			If Alltrim(aCabec[1,nX]) == "B1_IPI"
				aAux[nX] := VAL(aAux[nX]) //val(strtran(aAux[nX],",",".")) * 100
			endIf

			If Alltrim(aCabec[1,nX]) <> "B1_PESO" .AND. Alltrim(aCabec[1,nX]) <> "B1_IPI"
				&("SB1->"+Alltrim(aCabec[1,nX])) := Alltrim(aAux[nX])
			else
				&("SB1->"+Alltrim(aCabec[1,nX])) :=  aAux[nX]
			EndIf
		Next nX
		SB1->(Msunlock())
		
	EndIf
	nCont++
	FT_FSKIP()
End

FClose(nHandlel)

FT_FUSE()

RestArea(aArea)
	
Return


User Function xJTim

Private nHandle 	:=	FT_FUse(cArqTxt)


If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
Endif


// Posiciona na primeria linha
FT_FGoTop()

//Begin Transaction

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	aAux    := SEPARA(cLine,";") 
	aAux[1]	:= Alltrim(aAux[1]) 
	DbSelectArea("SB2")
	DbsetOrder(1)
	If !Dbseek(aAux[1]+Avkey(aAux[2],"B2_COD")+Avkey(aAux[4],"B2_LOCAL"))
		CriaSB2(aAux[2],aAux[4])
		Reclock("SB2",.F.)
		SB2->B2_QATU  := val(aAux[3])
		SB2->(Msunlock())
	else
		If SB2->B2_QATU <> val(aAux[3])
			Reclock("SB2",.F.)
			SB2->B2_QATU := Val(aAux[3])
			SB2->(MsUnlock())
		EndIf
	EndIf
		
	FT_FSKIP()
End

FT_FUSE()


Return
