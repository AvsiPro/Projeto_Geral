#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMXML000    บAutor  ณJackson E. de Deus บ Data ณ  17/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o xml da OS de retorno - devolve o resultado      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MXML000(cXmlAnswer)

Local cError := ""
Local cWarning := ""
Local oXml
Local aRet := {}  
Local nI,nJ,nK,nL,nM,nN
Local aRet := {}
Default cXmlAnswer := ""

If cEmpAnt <> "01"
	Return
EndIf

If Empty(cXmlAnswer)
	ConOut("## MXML000 -> FALTOU O PARAMETRO cXmlAnswer ##")
	Return
EndIf
               
oXml := XmlParser( cXmlAnswer, "", @cError, @cWarning )
If oXml == Nil
	MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)	
	ConOut("## MXML000 - OS " +" -> FALHA AO GERAR O OBJETO XML : "+cError+" / "+cWarning +" ##")
	Return
Endif
               
BEGIN SEQUENCE 
	cNo := "oXml"
	For nI := 1 To XmlChildCount(oXml)	// nivel 1 - raiz
		oNod1 := XmlGetChild(oXml, nI)
		cNo += ":_"+StrTran(StrTran(oNod1:REALNAME,":","_"),"-","_")
		For nJ := 1 To XmlChildCount(oNod1)		// nivel 2
			oNod2 := XmlGetchild( Eval( &( "{||"+cNo+"}" ) ) , nJ )
			If UPPER(oNod2:REALNAME) <> "RESPOSTAS"
				AADD( aRet, { UPPER(oNod2:REALNAME), ALLTRIM(oNod2:TEXT) } )   		    
			Else
				cNo3 := cNo +":_"+StrTran(StrTran(oNod2:REALNAME,":","_"),"-","_")
				For nK := 1 To XmlChildCount(oNod2)	// nivel 3
					oNod3 := XmlGetchild( Eval( &( "{||"+cNo3+"}" ) ) , nK )
					cNo4 := cNo3 +":_"+StrTran(StrTran(oNod3:REALNAME,":","_"),"-","_")
					          
					AADD( aRet, { UPPER(oNod3:REALNAME) }  )     
					nPosResp := Len(aRet)
					For nL := 1 To XmlChildCount(oNod3)	// nivel 4
						oNod4 := XmlGetchild( Eval( &( "{||"+cNo4+"}" ) ) , nL )
						    
						// somente um item
						If ValType(oNod4) == "O" .And. UPPER(oNod3:REALNAME) $ "ABASTECIMENTO#INVENTARIO#CONFERENCIA"
							AADD( aRet[nPosResp], { } )
					 		nPosMola := Len(aRet[nPosResp])
							For nN := 1 To XmlChildCount(oNod4)
								cNoItem := cNo4 +":_"+StrTran(StrTran(oNod4:REALNAME,":","_"),"-","_")
								oNod5 := XmlGetchild( Eval( &( "{||"+cNoItem+"}" ) ) , nN )
								
								AADD( aRet[nPosResp][nPosMola], { UPPER(oNod5:REALNAME), ALLTRIM(oNod5:TEXT) } )
							Next nN	
						// mais de um item
						ElseIf ValType(oNod4) == "A" .And. UPPER(oNod3:REALNAME) $ "ABASTECIMENTO#INVENTARIO#CONFERENCIA"
						    
							For nM := 1 To Len(oNod4)	// nivel 5
						 		AADD( aRet[nPosResp], { } )
						 		nPosMola := Len(aRet[nPosResp])
						 		
								For nN := 1 To XmlChildCount(oNod4[nM])	// nivel 6
									cNoMola := cNo4 +":_"+StrTran(StrTran(oNod4[1]:REALNAME,":","_"),"-","_") +"["+cvaltochar(nM)+"]"
									oNod5 := XmlGetchild( Eval( &( "{||"+cNoMola+"}" ) ) , nN )
									
									AADD( aRet[nPosResp][nPosMola], { UPPER(oNod5:REALNAME), ALLTRIM(oNod5:TEXT) } )
								Next nN	
							Next nM
						ElseIf ValType(oNod4) == "O"
							AADD( aRet[nPosResp], { UPPER(oNod4:REALNAME), ALLTRIM(oNod4:TEXT) } )	
						EndIf
					Next nL
				Next nK
			EndIf
		Next nJ	
	Next nI
RECOVER
	Conout("## MXML000 " +" -> ERRO NO PROCESSAMENTO DO XML ##")
END SEQUENCE

Return aRet