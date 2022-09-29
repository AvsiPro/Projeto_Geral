#include 'protheus.ch'
#include 'tbiconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINT01  บAutor  ณMicrosiga           บ Data ณ  09/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Validacao de moedas retornadas nas rotas tesouraria.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFINT01(cRota,dDia)
                  
Local aArea		:=	GetArea()
Local cError	:= ""
Local cWarning	:= ""    
Local aResp		:=	{}
Local cQuery 
Local aMoed05	:=	{0}
Local aMoed10	:=	{0}
Local aMoed25	:=	{0}
Local aMoed50	:=	{0}
Local aMoed1r	:=	{0} 
Local lEntrou	:=	.F.
Local cFile		:= ""
Local aDados	:= {}
Local nM5		:= 0
Local nM10		:= 0
Local nM25		:= 0
Local nM50		:= 0
Local nM1		:= 0
Local lXml		:= .F.

//Prepare Environment Empresa "01" Filial "01" Tables "SZG" 

cQuery := "SELECT ISNULL(CONVERT(VARCHAR(8000), CONVERT(VARBINARY(8000), ZG_RESPOST)),'') AS CONT, ZG_NUMOS, ZG_NOVOFRM FROM "+RetSQLName("SZG")
cQuery += " WHERE ZG_DATAINI = '"+DTOS(dDia)+"' AND ZG_DATAFIM='"+dtos(dDia)+"' AND ( ZG_TPFORM = '3' OR ZG_FORM = '04' OR ZG_FORM = 08 ) AND ZG_ROTA='"+cRota+"' AND D_E_L_E_T_=''"

// ALTERAR PARA PEGAR A DATA DO CONTADOR - DATA FIM

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
//MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")    

While !EOF()
	nM5		:= 0
	nM10	:= 0
	nM25	:= 0
	nM50	:= 0
	nM1		:= 0
	/*
	If TRB->ZG_NOVOFRM == "F"
		lXml := .T.
	Else
		lXml := .F.	
	EndIf
	
	If Date() == stod("20160513")
		lXml := .F.
	EndIf
	
	If lXml
		oXml := XmlParser( TRB->CONT, "_", @cError, @cWarning )
		If oXml == Nil
			cFile := "\_keeple\xml_retorno\" +AllTrim(TRB->ZG_NUMOS) +"_" +"xml_os.xml"
			If File(cFile)
				oXml := XmlParserFile( cFile, "_", @cError, @cWarning )
			Else
				adoc := { val(TRB->ZG_NUMOS) }
				AADD( aDados, "6241D1E1C9517582E2CBFE491E908A10C7C3DFCE" )
				AADD( aDados, "42CB7AEE2B2FFA173B53" ) 
				AADD( aDados, ADOC )
				cResWS := U_WSKPC006(aDados)   
				cResWS := U_WSKPF001(cResWS)
				cResWS := encodeUtf8(cResWS)
				MemoWrite( cFile, cResWS )
				oXml := XmlParser( cResWS, "_", @cError, @cWarning )
			EndIf
		EndIf
		
		If oXml <> Nil	// tratamento Jackson 09/06/2015
			ARESP := oXml:_FORMANSWERS:_FORMANSWER:_ITEMANSWERS:_ITEMANSWER
			
			For nX := 1 to len(aResp)
				If 'QUANTIDADE' $ upper(Alltrim(aResp[nX]:_ITEM:TEXT))
					If '05' $ right(upper(Alltrim(aResp[nX]:_ITEM:TEXT)),2)
						//aMoed05[1] += val(aResp[nX]:_ANSWER:TEXT)	
						If nM5 == 0
							nM5 := val(aResp[nX]:_ANSWER:TEXT)
							CONOUT( "TESOUSARIA;"+ZG_NUMOS+"5->"+aResp[nX]:_ANSWER:TEXT  )	
						EndIf
					ElseIf '10' $ right(upper(Alltrim(aResp[nX]:_ITEM:TEXT)),2)
						//aMoed10[1] += val(aResp[nX]:_ANSWER:TEXT)
						If nM10 == 0
							nM10 := val(aResp[nX]:_ANSWER:TEXT)
							CONOUT( "TESOUSARIA;"+ZG_NUMOS+"10->"+aResp[nX]:_ANSWER:TEXT  )		
						EndIf
					ElseIf '25' $ right(upper(Alltrim(aResp[nX]:_ITEM:TEXT)),2)
						//aMoed25[1] += val(aResp[nX]:_ANSWER:TEXT)
						If nM25 == 0
							nM25 := val(aResp[nX]:_ANSWER:TEXT)	
							CONOUT( "TESOUSARIA;"+ZG_NUMOS+"25->"+aResp[nX]:_ANSWER:TEXT  )	
						EndIf
					ElseIf '50' $ right(upper(Alltrim(aResp[nX]:_ITEM:TEXT)),2)
						//aMoed50[1] += val(aResp[nX]:_ANSWER:TEXT)
						If nM50 == 0
							nM50 := val(aResp[nX]:_ANSWER:TEXT)
							CONOUT( "TESOUSARIA;"+ZG_NUMOS+"05->"+aResp[nX]:_ANSWER:TEXT  )		
						EndIf
					ElseIf '00' $ right(upper(Alltrim(aResp[nX]:_ITEM:TEXT)),2)
						//aMoed1r[1] += val(aResp[nX]:_ANSWER:TEXT)
						If nM1 == 0
							nM1 := val(aResp[nX]:_ANSWER:TEXT)	
							CONOUT( "TESOUSARIA;"+ZG_NUMOS+"1->"+aResp[nX]:_ANSWER:TEXT  )	
						EndIf
					EndIf 
					lEntrou := .T.
				Endif
			Next nX
		Else
			Conout( "#TTFINT01 -> ERRO AO ABRIR XML: " +AllTrim(TRB->ZG_NUMOS) )	
		EndIf
			
	// novo form
	Else
	*/
		dbSelectArea("SZN")
		dbSetORder(4)
		MsSeek( xFilial("SZN") +AvKey(TRB->ZG_NUMOS,"ZN_NUMOS") +AvKey("SANGRIA","ZN_TIPINCL") )
		If !Found()
			MsSeek( xFilial("SZN") +AvKey(TRB->ZG_NUMOS,"ZN_NUMOS") +AvKey("AUDITORIA","ZN_TIPINCL") )
		EndIf
		If Found()
			nM5 := SZN->ZN_MABAST1
			nM10 := SZN->ZN_MABAST2
			nM25 := SZN->ZN_MABAST3
			nM50 := SZN->ZN_MABAST4
			nM1 := SZN->ZN_MABAST5
			lEntrou := .T.
		EndIf
	//EndIf	
	
	
	If nM5 > 0
		aMoed05[1] += nM5
	EndIf
	
	If nM10 > 0
		aMoed10[1] += nM10
	EndIf
	
	If nM25 > 0
		aMoed25[1] += nM25
	EndIf
	
	If nM50 > 0
		aMoed50[1] += nM50
	EndIf
	
	If nM1 > 0
		aMoed1r[1] += nM1
	EndIf

	DbSelectArea("TRB") 
	dBSKIP()
EndDo

If lEntrou 
	nRecnoSZF := FindSZF(dDia,cRota)
	DbSelectArea("SZF")
	If nRecnoSZF > 0
		dbGoTo(nRecnoSZF)
		Reclock("SZF",.F.)
		SZF->ZF_RETMOE1 := SZF->ZF_MOEDA01 - aMoed05[1]
		SZF->ZF_RETMOE2 := SZF->ZF_MOEDA02 - aMoed10[1]
		SZF->ZF_RETMOE3 := SZF->ZF_MOEDA03 - aMoed25[1]
		SZF->ZF_RETMOE4 := SZF->ZF_MOEDA04 - aMoed50[1]
		SZF->ZF_RETMOE5 := SZF->ZF_MOEDA05 - aMoed1r[1]
		MsUnLock()
	EndIf
EndIf
	
//reset Environment                                 

RestArea(aArea)

Return
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINT01  บAutor  ณMicrosiga           บ Data ณ  09/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FindSZF(dData,cRota)		

Local nRecno := 0
Local cQuery := ""

cQuery := "SELECT R_E_C_N_O_ ZFREC FROM " +RetSqlName("SZF") +" ZF "
cQuery += " WHERE ZF_FILIAL='"+xFilial("SZF")+"' AND ZF_DATA='"+dtos(dData)+"' AND ZF_ROTA='"+cRota+"' AND D_E_L_E_T_='' "
cQuery += " AND (ZF_MOEDA01 <> '' OR ZF_MOEDA02 <> '' OR ZF_MOEDA03 <> '' OR ZF_MOEDA04 <> '' OR ZF_MOEDA05 <> '')"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB") 

If !EOF()
	nREcno := TRB->ZFREC
EndIf

TRB->( dbCloseArea() )

Return nRecno