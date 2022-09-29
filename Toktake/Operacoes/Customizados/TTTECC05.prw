#include "protheus.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTECC05	บAutor  ณJackson E. de Deus  บ Data ณ  04/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclui/remove patrimonio da base instalada				  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ04/03/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑณJackson       ณ13/10/14ณ01.01 |Tratamentos feitos na inclusao/remocao  ณฑฑ
ฑฑณ								  Inc. de execucao via rotina automatica  ณฑฑ
ฑฑณJackson       ณ04/11/14ณ01.02 |Alteracao na gravacao via execauto	  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTTECC05(nTipo,cCliente,cLoja,cNumChapa,dDtInst,cContrato,cDescLocal)

Local nRecSN1		:= 0
Local lRet			:= .T. 
Local lInstalado	:= .F.              
Local cProduto		:= ""
Local cBase			:= ""
Local cItem			:= ""
Local cNumNF		:= ""
Local cFornece		:= ""
Local cFornLj		:= ""
Local dDtContr 

Default nTipo		:= 0   
Default cCliente	:= ""
Default cLoja		:= ""
Default cNumChapa	:= ""
Default dDtInst		:= ctod("")
Default cContrato	:= ""

If cEmpAnt <> "01"
	Return
EndIf
If nTipo == 0 .Or. Empty(cCliente) .Or. Empty(cLoja) .Or. Empty(cNumChapa)
	Aviso("TTTECC05","Os parโmetros nใo foram corretamente informados.",{"Ok"})
	Return .F.
EndIf

/*
dbSelectArea("CN9")
dbSetOrder(1)
If dbSeek( xFilial("CN9") +AvKey(cContrato,"CN9_NUMERO") )
	dDtContr := CN9->CN9_DTINIC
EndIf
*/
dbSelectArea("SN1")
dbSetORder(2)
dbSeek( xFilial("SN1") +AvKey(cNumChapa,"N1_CHAPA") )
                          
cBase := SN1->N1_CBASE
cItem := SN1->N1_ITEM
cNumNF := SN1->N1_NFISCAL
cFornece := SN1->N1_FORNEC
cFornLj := SN1->N1_LOJA
cProduto := SN1->N1_PRODUTO


//dbSelectArea("AA3")
//dbSetOrder(7)	// plaqueta

// instalacao
If nTipo == 1
	/*
	If dbSeek( xFilial("AA3") +AvKey(cNumChapa,"AA3_CHAPA") )
		If AllTrim(AA3->AA3_CODCLI) <> AllTrim(cCliente) .Or. AllTrim(AA3->AA3_LOJA) <> AllTrim(cLoja)
			Remove(cNumChapa,AA3->AA3_CODCLI,AA3->AA3_LOJA,cProduto,cBase,cItem)  
		Else
			If AllTrim(AA3->AA3_CODCLI) == AllTrim(cCliente) .And. AllTrim(AA3->AA3_LOJA) == AllTrim(cLoja)
				lInstalado := .T.                                                                              
			EndIf
		EndIf
	EndIf
	
	If !lInstalado
		lRet := Inclui(cNumChapa,cCliente,cLoja,cProduto,cBase,cItem,dDtInst,cNumNF,cFornece,cFornLj,cContrato,dDtContr)
	EndIf
	*/
	
	dbSelectArea("AA3")
	dbSetOrder(7)
	If !dbSeek( xFilial("AA3") +AvKey(cNumChapa,"AA3_CHAPA") )
		Inclui(cNumChapa,cCliente,cLoja,cProduto,cBase,cItem,dDtInst,cNumNF,cFornece,cFornLj,cContrato,dDtContr)
	Else
		// transfere para o cliente e loja
		TransfAA3(1,cNumChapa,cCliente,cLoja,dDtInst,cDescLocal)
	EndIf
	
// remocao	
ElseIf nTipo == 2
	/*
	If dbSeek( xFilial("AA3") +AvKey(cNumChapa,"AA3_CHAPA") ) 
		If AllTrim(AA3->AA3_CODCLI) == AllTrim(cCliente) .And. AllTrim(AA3->AA3_LOJA) == AllTrim(cLoja)
			Remove(cNumChapa,cCliente,cLoja,cProduto,cBase,cItem)                                         
		EndIf
	EndIf
	*/
	
	// transfere para a tok take matriz
	TransfAA3(2,cNumChapa,cCliente,cLoja)
EndIf


Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTECC05  บAutor  ณMicrosiga           บ Data ณ  08/26/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TransfAA3(nOpc,cNumChapa,cCliente,cLoja,dDtInst,cDescLocal)

Local lRet := .T.           

Local aCab040 := {}
Local aItens040 := {}
Local nOpcAuto := 4 
Local nRecAA3 := 0
Private aRotina := {}
Private aHEader := {}
Private aCols := {}


dbSelectArea("AA3")
dbSetOrder(7)
If dbSeek( xFilial("AA3") +AvKey(cNumChapa,"AA3_CHAPA") )
	nRecAA3 := Recno()
	aRotina := STATICCALL( TECA040, MenuDef )

	//At040Trans("AA3",nRecAA3,2)	// CHAMADA DA TELA
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("AA3")
	While ( !Eof() .AND. (SX3->X3_ARQUIVO == "AA3") )
		uCampo := SX3->X3_CAMPO
		If ( SX3->X3_CONTEXT=="V" )
			M->&(uCampo) := ""//CriaVar(SX3->X3_CAMPO)
		Else
			M->&(uCampo) := AA3->(FieldGet(FieldPos(SX3->X3_CAMPO)))
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	End
			
	If GetEnvServer() $ "SCHEDULE#JVVXC9_AMC#CNP"
		
	Else
		//FillGetDados( nOpcAuto,"AA4",1,,,{|| .T. },,,,,,.T. )
	EndIf
	
	At040Grava(4,cCliente,cLoja)
	EvalTrigger()
	
	If nOpc == 1
		RecLock("AA3",.F.)
		AA3->AA3_DTINST := dDtInst
		AA3->AA3_SITE := cDescLocal
		MsUnLock()
	Else
		RecLock("AA3",.F.)
		AA3->AA3_DTINST := STOD("")
		AA3->AA3_DTGAR := STOD("")
		AA3->AA3_SITE := "TOK TAKE - TECNICA"
		//AA3->AA3_STATUS := "03"
		MsUnLock()		
	EndIf
EndIf  


Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInclui  บAutor  ณJackson E. de Deus    บ Data ณ  13/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclui o patrimonio na base instalada                      บฑฑ
ฑฑบ          ณ Primeira tentativa via execauto, segunda via reclock       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Inclui(cNumChapa,cCliente,cLoja,cProduto,cBase,cItem,dDtInst,cNumNF,cFornece,cFornLj,cContrato,dDtContr)

Local lRet := .T.
Local aCab040 := {}
Local aItens040 := {}
Local nOpcAuto := 3
Private lMsErroAuto := .F.
Private n := 0
Private aRotina := {}
Private aHEader := {}
Private aCols := {}

Aadd(aCab040, { "AA3_FILIAL"	, xFilial("AA3"), NIL } )                
Aadd(aCab040, { "AA3_CODCLI"	, cCliente		, NIL } )                
Aadd(aCab040, { "AA3_LOJA"		, cLoja			, NIL } )                
Aadd(aCab040, { "AA3_CODPRO"	, cProduto		, NIL } )                
Aadd(aCab040, { "AA3_NUMSER"	, cNumChapa		, NIL } )                 
Aadd(aCab040, { "AA3_CBASE"		, cBase			, NIL } ) 
Aadd(aCab040, { "AA3_ITEM"		, cItem			, NIL } ) 
Aadd(aCab040, { "AA3_CHAPA"		, cNumChapa		, NIL } )
Aadd(aCab040, { "AA3_DTINST"	, dDtInst		, NIL } )
Aadd(aCab040, { "AA3_DTVEND"	, dDtInst		, NIL } )
Aadd(aCab040, { "AA3_DTGAR"		, dDtInst		, NIL } )
Aadd(aCab040, { "AA3_NFAQUI"	, cNumNF		, NIL } )
Aadd(aCab040, { "AA3_FORNEC"	, cFornece		, NIL } )
Aadd(aCab040, { "AA3_LOJAFO"	, cFornLj		, NIL } )
Aadd(aCab040, { "AA3_STATUS"	, "01"			, NIL } )

If !Empty(cContrato)
	Aadd(aCab040, { "AA3_CONTRT"	, cContrato		, NIL } )
	//Aadd(aCab040, { "AA3_DTCTAM"	, dDtContr		, NIL } )
EndIf	
  
//MsExecAuto({|w, x, y, z| TECA040(w, x, y, z)}, , aCab040, aItens040, 3)     
TECA040(,aCab040,aItens040,nOpcAuto)
If lMsErroAuto  
	CONOUT( "ERRO AO INCLUIR MAQUINA " +cNumChapa )
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("AA3")
	While ( !Eof() .AND. (SX3->X3_ARQUIVO == "AA3") )
		uCampo := SX3->X3_CAMPO
		If ( SX3->X3_CONTEXT=="V" )
			M->&(uCampo) := ""//CriaVar(SX3->X3_CAMPO)
		Else
			M->&(uCampo) := AA3->(FieldGet(FieldPos(SX3->X3_CAMPO)))
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	End
	
	If GetEnvServer() $ "SCHEDULE#AMC_COMP#CNP"
		
	Else
		//FillGetDados( nOpcAuto,"AA4",1,,,{|| .T. },,,,,,.T. )
	EndIf
	//FillGetDados( nOpcAuto,"AA4",1,,,{|| .T. },,,,,,.T. )
	            
	M->AA3_FILIAL 	:= xFilial("AA3")
	M->AA3_CODCLI	:= cCliente
	M->AA3_LOJA		:= cLoja
	M->AA3_CODPRO	:= cProduto
	M->AA3_NUMSER	:= cNumChapa
	M->AA3_CBASE	:= cBase
	M->AA3_ITEM		:= cItem
	M->AA3_CHAPA	:= cNumChapa
	M->AA3_DTINST	:= dDtInst
	M->AA3_DTVEND	:= dDtInst
	M->AA3_DTGAR	:= dDtInst
	M->AA3_NFAQUI	:= cNumNF
	M->AA3_FORNEC	:= cFornece
	M->AA3_LOJAFO	:= cFornLj
	M->AA3_STATUS	:= "01"
	
	At040Grava(1)
	
	/*
	RecLock("AA3",.T.) 
	AA3->AA3_FILIAL	:= xFilial("AA3")
	AA3->AA3_CODCLI	:= cCliente
	AA3->AA3_LOJA	:= cLoja
	AA3->AA3_CODPRO	:= cProduto
	AA3->AA3_NUMSER	:= cNumChapa
	AA3->AA3_CBASE	:= cBase
	AA3->AA3_ITEM	:= cItem
	AA3->AA3_CHAPA	:= cNumChapa
	AA3->AA3_DTINST	:= dDtInst
	AA3->AA3_DTVEND	:= dDtInst
	AA3->AA3_DTGAR	:= dDtInst
	AA3->AA3_NFAQUI	:= cNumNF
	AA3->AA3_FORNEC	:= cFornece
	AA3->AA3_LOJAFO	:= cFornLj
	AA3->AA3_STATUS	:= "01"
	AA3->( MsUnLock() )
	*/
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRemove  บAutor  ณJackson E. de Deus    บ Data ณ  13/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Remove o patrimonio da base instalada.                     บฑฑ
ฑฑบ          ณ Primeira tentativa via execauto, segunda via reclock       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Remove(cNumChapa,cCliente,cLoja,cProduto,cBase,cItem)

Local lRet := .T.
Local aCab040 := {}
Local aItens040 := {}
Private lMsErroAuto := .F.

Aadd(aCab040, { "AA3_FILIAL"	, xFilial("AA3"), NIL } )                
Aadd(aCab040, { "AA3_CODCLI"	, cCliente		, NIL } )                
Aadd(aCab040, { "AA3_LOJA"		, cLoja			, NIL } )                
Aadd(aCab040, { "AA3_CODPRO"	, cProduto		, NIL } )                
Aadd(aCab040, { "AA3_NUMSER"	, cNumChapa		, NIL } )                 
Aadd(aCab040, { "AA3_CBASE"		, cBase			, NIL } ) 
Aadd(aCab040, { "AA3_ITEM"		, cItem			, NIL } ) 
Aadd(aCab040, { "AA3_CHAPA"		, cNumChapa		, NIL } )

MsExecAuto({|w, x, y, z| TECA040(w, x, y, z)}, , aCab040, aItens040, 5)  
//TECA040(,aCab040,aItens040,5)
If lMsErroAuto
	CONOUT( "ERRO AO REMOVER MAQUINA " +cNumChapa )
	//RecLock("AA3",.F.) 
	//AA3->( dbDelete() )
	//AA3->( MsUnLock() )
EndIf
      
Return lRet