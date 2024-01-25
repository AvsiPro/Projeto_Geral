#include  "rwmake.ch"
#include  "MSOLE.ch"
#Include 'FWMVCDef.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE 'PROTHEUS.CH'

/*
    Autorização de desconto Sinistro
    MIT 44_Sinistros_MULT007_Autorizacao de desconto

    DOC MIT
    https://docs.google.com/document/d/1Iyje3udB4TNaL8N14hgBz07bRcn1IEhu/edit
    DOC Entrega
    
    
*/

User Function JMULR002()

Local nOpcA := 0

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

Private cCadastro := "Integração Protheus Vs Ms-Word"
Private aSay   	:= {}
Private aButton := {}
Private CbTxt	  := ""
Private cDesc1	  := "Este programa tem como objetivo imprimir a carta de correcao"
Private cDesc2	  := "da "+AllTrim(SM0->M0_NOMECOM)
Private cString   := "SF2"
Private cTexto	  := ""
Private nomeprog  := "CORREC"
Private nLastKey  := 0
Private aInd	  := {}
Private titulo	  := "Emissao de carta de correcao"
Private nlin	  := 0
Private cPerg	  := PadR("CORREC",Len(SX1->(FieldGet(FieldPos("X1_GRUPO"))) ))

/*
ValidPerg()

If !( Pergunte ( cPerg ) )
	Return( Nil )
EndIf
*/
/*Í----------------------------------------------------À
//* Parametros do programa: 					       *
//Ã----------------------------------------------------Â
//* mv_par01	* Da Nota						?	   *
//* mv_par02	* Codigo Irregularidade 		?	   *
//* mv_par03	* Codigo Irregularidade 		?	   *
//* mv_par04	* Codigo Irregularidade 		?	   *
//* mv_par05	* Codigo Irregularidade 		?	   *
//* mv_par06	* Codigo Irregularidade 		?	   *
//* mv_par07	* Codigo Irregularidade 		?	   *
//* mv_par08	* Prefixo da Nota       		?	   *
//Ë----------------------------------------------------¢
*/

aAdd( aSay, "Esta rotina irá imprimir Carta de Correção" )

aAdd( aButton, { 5,.T.,{|| Pergunte(cPerg,.T. )}})
aAdd( aButton, { 1,.T.,{|| nOpca := 1,FechaBatch()}})
aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
FormBatch( cCadastro, aSay, aButton )

If nOpcA == 1
	Processa( {|| FISR01PROS() }, "Processando..." )
Endif

If nLastKey == 27
	Return
Endif

Return

/*/{Protheus.doc} FISR01PROS
	Processa a geração do arquivo
	@type  Static Function
	@author user
	@since 25/01/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function FISR01PROS()

Local cModelo, _cModelo

Local oWord     := Nil

cAliasA	:= GetNextAlias()

cPathCli := AllTrim(GetMv("MV_PATTERM"))   //   c:\wordtmp

nHandle := fCreate(cPathCli+"TESTE")

If nHandle <> -1 // Testa para ver se consegue ou nao criar o arquivo
	fClose(nHandle)
	fErase(cPathCli+"TESTE") // apaga o arquivo de teste de gravacao
Else
	If	!MontaDir(cPathCli)
		Aviso("","Diretorio "+cPathCli+" NAO encontrado.",{"OK"})
		Return NIL
	EndIf
EndIf

_cModelo    := GetMv("TI_XCARCOR", ,"DESCONTO1.DOT")

VarTipo := 1

//Copiando modelo da carta de correção para a maquina local
cMsg    := OemToAnsi("Copiando carta de correçao, aguarde...")
MsgRun(Padc(cMsg,100),,{|| CursorWait(),FISR01PRJM(_cModelo),CursorArrow()})

cModelo     := AllTrim(GetMv("MV_PATWORD"))+ _cModelo
If  !( File(cModelo) )
	Aviso("",cModelo+" nao encontrado no Servidor",{"OK"})
	Return NIL
EndIf

If  File(cPathCli+_cModelo)
	fErase(cPathCli+_cModelo)
	fErase(cPathCli + mv_par01 + ".DOT")
EndIf

If Select( cAliasA ) > 0
	dbSelectArea( cAliasA )
	dbCloseArea()
EndIf

cQry     := "SELECT SF2.F2_FILIAL,SF2.F2_DOC,SF2.F2_SERIE,SF2.F2_EMISSAO,"

MV_PAR02:='000000001'
MV_PAR01:= 'TTT'

cQry     += "  SF2.F2_TIPO, SF2.F2_CLIENTE, SF2.F2_LOJA "
cQry     += " FROM  "+RetSqlName("SF2")+" SF2"

cQry     += "  WHERE SF2.F2_FILIAL  = '"+ xFilial("SF2") +"'"
cQry     += "  AND   SF2.F2_DOC = '"+Mv_Par02+"'"
cQry     += "  AND   SF2.F2_SERIE = '"+Mv_Par01+"'"
cQry     += "  AND   SF2.D_E_L_E_T_ = ' '"

cQry := ChangeQuery(cQry) 


dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), cAliasA , .F., .T.)

dbSelectArea( cAliasA )
dbGoTop()

If !Eof()
	
	__CopyFile(cModelo   ,cPathCli+_cModelo   ) 

    oWord:=OLE_CreateLink( "TMsOleWord97" )
    OLE_SetProperty( oWord, oleWdVisible, .F. )

	OLE_NewFile( oWord, cPathCli + _cModelo )
	cMod := _cModelo
	
	OLE_SaveAsFile( oWord, cPathCli + mv_par02 + ".DOT" , , ,.F., oleWdFormatDocument )

	dDataAtual := ddatabase
	cRetorno := cValToChar(Day(dDataAtual))
	cRetorno += " de "
	cRetorno += MesExtenso(dDataAtual)
	cRetorno += " de "
	cRetorno += cValToChar(Year(dDataAtual))

	OLE_SetDocumentVar( oWord, "DataHora", cvaltochar(ddatabase)+" "+cvaltochar(time()) )			 
	OLE_SetDocumentVar( oWord, "nome",  'Alexandre Venâncio' )			 
	OLE_SetDocumentVar( oWord, "matricula", '172564' )	
	OLE_SetDocumentVar( oWord, "desc_motivo", 'PARAR NA AREA DE CRUZAMENTO DE VIAS' )	
	OLE_SetDocumentVar( oWord, "placa", 'DPX-5847' )	
	OLE_SetDocumentVar( oWord, "expedidor", 'PREFEITURA MUNICIPAL DA CIDADE' )
	OLE_SetDocumentVar( oWord, "valor", '175,20' )	
	OLE_SetDocumentVar( oWord, "cidade", 'São Paulo' )
	OLE_SetDocumentVar( oWord, "dataextenso", cRetorno )				 

	//OLE_ExecuteMacro(oWord,"Correcao")  				
	OLE_UpDateFields( oWord )
	OLE_SaveAsFile( oWord, cPathCli + mv_par02 + ".DOC" , , , .F., oleWdFormatDocument )
	Ole_CloseFile(oWord)
	Ole_CloseLink(oWord)
	fErase(cPathCli+_cModelo) 
	fErase(cPathCli + mv_par02 + ".DOT")
	Alert(OemToAnsi("Geração da carta concluída, o arquivo encontra-se em C:\WORDTMP"))
Else 
	Alert(OemToAnsi("Nota Fiscal não encontrada. Favor verificar."))
EndIf			

dbSelectArea(cAliasA)
dbCloseArea()

Return(nil)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FISR01PRJM ºAutor ³Fernando Salvatori  º Data ³  27/09/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criar Modelos locais para impressao                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EMISSAO DE PROPOSTA                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FISR01PRJM(cArqMod)

Local cLocLocal := "C:\WORDSTD\"    //Local dos modelos (Client)
Local cLocRede  := "\SYSTEM\DOTS\" //Local dos modelos (Server)

//Criando Diretorio para Modelo
MontaDir(cLocLocal)

If  !( File(cLocLocal+cArqMod) ) 
	__CopyFile(cLocRede+cArqMod   ,cLocLocal+cArqMod)
EndIf

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Luiz Carlos Vieira  º Data ³  03/22/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica as perguntas, adicionando-as caso nao existam.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()

Local i := 0, j := 0


_sAlias := Alias()
cPerg   := PADR(cPerg,Len(SX1->(FieldGet(FieldPos("X1_GRUPO")))))
//cPerg   := PADR(cPerg,6)
aRegs   :={}
i		:= 0
j		:= 0
dbSelectArea("SX1")
dbSetOrder(1)
// [1]GRUPO/[2]ORDEM/[3]PERGUNTA/[4]PREGUNTA(ESP)/[5]PERGUNTA(ING)/[6]VARIAVEL/[7]TIPO/[8]TAMANHO/[9]DECIMAL/[10]PRESEL/[11]GSC/[12]VALID/[13]VAR01/[14]DEF01/[15]DEFSPA1/[16]DEFENG1/[17]CNT01/[18]VAR02/[19]DEF02/[20]DEFSPA2/[21]DEFENG2/[22]CNT02/[23]VAR03/[24]DEF03/[25]DEFSPA3/[26]DEFENG3/[27]CNT03/[28]VAR04/[29]DEF04/[30]DEFSPA4/[31]DEFENG4/[32]CNT04/[33]VAR05/[34]DEF05/[35]DEFSPA5/[36]DEFENG5/[37]CNT05/[38]F3/[39]GRPSXG
//          1     2    3                      4                      5                      6        7   8  9 0 11  12 13         14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39
AADD(aRegs,{cPerg,"01","Prefixo da Nota    ?","Prefixo da Nota    ?","Prefixo da Nota    ?","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Da Nota            ?","Da Nota            ?","Da Nota            ?","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Códig. Irregular.  ?","Códig. Irregular.  ?","Códig. Irregular.  ?","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Códig. Irregular.  ?","Códig. Irregular.  ?","Códig. Irregular.  ?","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Códig. Irregular.  ?","Códig. Irregular.  ?","Códig. Irregular.  ?","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Códig. Irregular.  ?","Códig. Irregular.  ?","Códig. Irregular.  ?","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Códig. Irregular.  ?","Códig. Irregular.  ?","Códig. Irregular.  ?","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Códig. Irregular.  ?","Códig. Irregular.  ?","Códig. Irregular.  ?","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return

