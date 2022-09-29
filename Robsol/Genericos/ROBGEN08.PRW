#INCLUDE 'PROTHEUS.CH'
#include "fileio.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
    Ajustar arquivos de cnab que foram com o id cnab errado
*/

User Function ROBGEN08()

Local cTitulo := " Ajuste de Arquivo de CNAB "
Local nOpc    := 0
Local aSay    := {}
Local aButton := {}   
Private cPerg := 'XXX008    '

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
Endif
 
ValidPerg()

aAdd( aSay, "Esse programa fará a leitura do arquivo de invent�rio e ajusta-lo" )

AADD( aButton, { 5,	.T., {|| Pergunte(cPerg,.T. ) }} )

aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )

aAdd( aButton, { 2, .T., {|| FechaBatch() }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc == 1
	Processa( {||  gerar() }, "Processando..." )
Endif

Return          

/*
Gerar novo arquivo
*/

Static Function gerar()

Local aArea			:=	GetArea()                          
Local cAux          :=  ''
Private aVetor		:=	{}
Private cArqTxt 	:=	MV_PAR01
Private nHandle1 	:=	FT_FUse(cArqTxt)
Private nHandle2	:=	fcreate(strtran(cArqTxt,'.ret','_new.ret'), FO_READWRITE + FO_SHARED )

// Posiciona na primeria linha
FT_FGoTop()

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
    cAux    := ''

    If substr(cLine,14,1) == "T"
        cAux := substr(cLine,106,25)
        If !'-' $ cAux
            cAux := PADR(strzero(VAL(CAUX),10),25)
            Fwrite(nHandle2,substr(cLine,1,105)+cAux+substr(cLine,131)+CRLF,1000000)
        Else   
            cAux := PADR(SUBSTR(CAUX,AT('-',CAUX)+1),25)
            Fwrite(nHandle2,substr(cLine,1,105)+cAux+substr(cLine,131)+CRLF,1000000)
        EndIf 
    else
        Fwrite(nHandle2,cLine+CRLF,1000000)
    EndIf
	FT_FSKIP()
End

FT_FUSE()
       

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

