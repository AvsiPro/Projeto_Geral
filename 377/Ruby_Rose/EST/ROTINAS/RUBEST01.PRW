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

User Function RUBEST01()

Local cTitulo := " LANÇAMENTO DO INVENTÝRIO "
Local nOpc    := 0
Local aSay    := {}
Local aButton := {}   
Private cPerg := 'XXX190    '

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("02","01")
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
Private nHle2	:=	fcreate('C:\trash\logF08.txt', FO_READWRITE + FO_SHARED )
PRIVATE lMsErroAuto := .F.

// Posiciona na primeria linha
FT_FGoTop()

//Begin Transaction

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	aAux    := SEPARA(cLine,";") 
	aAux[1]	:= Alltrim(aAux[1]) 
	
    DbSelectArea("SB7")
    DbSetOrder(3)
    If !Dbseek(Avkey(aAux[1],"B7_FILIAL")+Avkey(aAux[5],"B7_DOC")+Avkey(Alltrim(aAux[2]),"B7_COD")+Avkey(aAux[4],"B7_LOCAL"))

        DbSelectArea("SB1")
        DbSetOrder(1)
        If DbSeek(xFilial("SB1")+aAux[2])  
        

            DbSelectArea("SB2")
            DbSetOrder(1)
            If !DbSeek(Avkey(aAux[1],"B2_FILIAL")+Avkey(Alltrim(aAux[2]),"B2_COD")+Avkey(aAux[4],"B2_LOCAL"))
                CriaSB2(aAux[2],aAux[4])
            EndIf

            If SB1->B1_LOCALIZ != 'S'
                ReClock("SB1",.F.)
                SB1->B1_LOCALIZ := 'S'
                SB1->(MSUNLOCK())
            ENDIF

                aVetor := {;
                        {"B7_FILIAL" 	,aAux[1]			,Nil},;
                        {"B7_COD"		,aAux[2]			,Nil},;
                        {"B7_DOC"		,cCodInv			,Nil},;
                        {"B7_QUANT"		,val(strtran(aAux[3],",","."))		,Nil},;
                        {"B7_LOCAL"		,aAux[4]		    ,Nil},;
                        {"B7_DATA"		,DDATABASE			,Nil},;
                        {"B7_DOC"       ,aAux[5]            ,Nil},;
                        {"B7_LOTECTL"   ,aAux[6]            ,Nil},;
                        {"B7_DTVALID"   ,CTOD(aAux[7])      ,Nil},;
                        {"B7_LOCALIZ"   ,aAux[8]            ,Nil},;
                        {"B7_CONTAGE"   ,'1'                ,NIL} }
            

            lMsErroAuto	:=	.F.
            
            MSExecAuto({|x,y| mata270(x,y)},aVetor,.F.,3)
            
            If lMsErroAuto
                mostraerro("\system\",'erro_prod_'+alltrim(aAux[2])+'.txt')
                FWRITE(nHle2,"Produto com erro de lote "+aAux[2]+CRLF,1000)
            Endif		
        else

            FWRITE(nHle2,"Produto nao encontrado "+aAux[2]+CRLF,1000)	
        EndIF			

    ENDIF           
        
	
	FT_FSKIP()
End

FT_FUSE()
FCLOSE(nHle2)       
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
