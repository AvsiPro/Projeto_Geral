#INCLUDE 'PROTHEUS.CH'
#include "fileio.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
    Importar planilha com estrutura de produtos para SG1
*/

User Function ROBGEN09()

Local cTitulo := " Importar estrutura de produtos "
Local nOpc    := 0
Local aSay    := {}
Local aButton := {}   
Private cPerg := 'XXX008    '

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
Endif
 
ValidPerg()

aAdd( aSay, "Esse programa far� a leitura do arquivo de importa��o de estruturas" )

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
Local aAux          :=  {}
Local nCont         :=  0
Private aVetor		:=	{}
Private aCabec      :=  {}
Private cArqTxt 	:=	MV_PAR01
Private nHandle1 	:=	FT_FUse(cArqTxt)

// Posiciona na primeria linha
FT_FGoTop()

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
    aAux    := separa(cLine,";")
    If nCont < 1
        Aadd(aCabec,aAux)
    else
        If len(aAux) > 1
            Aadd(aVetor,aAux)    
            DbSelectArea("SB1")
            DbSetOrder(1)
            If !Dbseek(xFilial("SB1")+aAux[1])
                MsgAlert("Produto principal inv�lido na linha "+cvaltochar(nCont))
                aVetor := {}
                exit 
            EndIf 
            If !Dbseek(xFilial("SB1")+aAux[2])
                MsgAlert("Produto componente inv�lido na linha "+cvaltochar(nCont))
                aVetor := {}
                exit 
            EndIf
        EndIf 
        
    EndIf 

    nCont++
	FT_FSKIP()
End

If len(aVetor) > 0 .And. len(aCabec) > 0
    GeraSG1()
    MsgAlert("Processo finalizado")
Else 
    MsgAlert("Erro na estrutura do arquivo")
EndIf 

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


/*/{Protheus.doc} GeraSG1
description)
    @type  Static Function
    @author user
    @since 23/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraSG1()
    
Local aArea :=  GetArea()
Local nCont :=  0
Local nK    :=  0

DbSelectArea("SG1")
For nCont := 1 to len(aVetor)

    If !Dbseek(xFilial("SG1")+Avkey(aVetor[nCont,01],"G1_COD")+Avkey(aVetor[nCont,02],"G1_COMP"))
        Reclock("SG1",.T.)
    ELSE
        Reclock("SG1",.F.)
    ENDIF 

    SG1->G1_FILIAL := xFilial("SG1")
        
    For nK := 1 to len(aCabec[1])
        &("SG1->"+aCabec[1,nK]) := If(nK == 3,val(aVetor[nCont,nK]),aVetor[nCont,nK])        
    Next nK 
    
    SG1->G1_INI    := DDATABASE
    SG1->G1_FIM    := CTOD('31/12/2030')
    SG1->G1_FIXVAR := 'V'
    SG1->G1_REVFIM := 'ZZZ'
    SG1->G1_VLCOMPE:= 'N'
    SG1->G1_USAALT := '1'

    SG1->(MsUnlock())

Next nCont 

RestArea(aArea)

Return
