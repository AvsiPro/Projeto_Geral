#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*///#INCLUDE 'APVT100.CH'

*********************************************************************************************************************
*********************************************************************************************************************
// Função: fImpEtq() - Impressão da Etiqueta de Expedição      ///teste para impressão após geração NF pelo ACD    //    FOI COLOCADO NO MENÚ DO FINANCEIRO PARA TESTES
*********************************************************************************************************************
*********************************************************************************************************************
/*/
USER Function x_xImpEtq()//xImpEtq()
	//Local cAlias		:= GetNextAlias()
	Local nQtdVol		:= 1
	Local nQtdIni		:= 1
    Local cFila 		:= '000001'
    //Local cVolume 	  := '00000x'
    Local cPedido 		:= '0000007'
    Local cNome 		:= 'TESTE PRESENTES LIMITADA'
    Local cEnder 		:= 'RUA CORONEL DE OLIVEIRA LIMA, 482'
    Local cBairro 		:= 'CENTRO'
    Local cCidade 		:= 'SANTO ANDRE'
    Local cEstado 		:= 'SP'
    Local cCep 			:= '09010000'
    Local cDdd 			:= '11'
    Local cTel 			:= '8539-4661'
    Local cNota 		:= '0068886'
    Local cTpTransp 	:= 'Transportadora:'
    Local cOrdemPal 	:= 1
    Local cTransp 		:= 'Bom Jesus Transportes'
   
	ConOut("GEREXNS ANTES [ " + cFila + " ]")
    
    If !MsgYesNo("Imprimir Etiqueta ?","ATENÇÃO","YESNO")	
         MsgAlert("Cancelada pelo Operador!")
		Return
	EndIf
    
	dbselectArea("CB5")
	if dbSeek(xFilial("CB5")+cFila)
		ConOut("GEREXNS ACHOU A FILA NO CB5 [ " + cFila + " ]")
	else
		ConOut("GEREXNS NAO ACHOU A FILA NO CB5 [ " + cFila + " ]")
	endif
	If !CB5SetImp(cFila)
		Alert('Codigo do tipo de impressao invalido. A etiqueta não será impressa.')
		Return .f.
	EndIF

    MSCBCHKSTATUS(.f.) //OK
	
    	MSCBBEGIN(1,5,97) //OK 
		MSCBWrite("^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ")					
		MSCBWrite("^XA")
		MSCBWrite("^MMT")
		MSCBWrite("^PW1059")
		MSCBWrite("^LL1772")
		MSCBWrite("^LS0")		
		//dados da NELIDA - cabeçalho				
		MSCBWrite("^FT100,715^A0B,33,39^FH\^FDNELIDA DO BRASIL COM.E IMPOR. LTDA ^FS")
		MSCBWrite("^FT130,715^A0B,25,23^FH\^FDRua da Alfandega , 200 - Sao Paulo / SP Brasil - CEP 03006.030 ^FS")
		MSCBWrite("^FT162,715^A0B,32,34^FH\^FD+55 11 3227-0120 ^FS")
		// linha 		
		//MSCBLINEV(27,8,192,4)		
		MSCBWrite("^FO175,040^GB0,680,4^FS")
				
				
		//MSCBWrite("^FT240,700^A0B,25,23^FH\^FDNr Controle ^FS")
		//MSCBWrite("^FT240,800^A0B,25,23^FH\^FD"+cVolume+"^FS")
		
		MSCBWrite("^FT240,350^A0B,33,36^FH\^FDNr Pedido ^FS")
		MSCBWrite("^FT240,170^A0B,33,36^FH\^FD"+cPedido+"^FS")		
		
		MSCBWrite("^FT300,780^A0B,25,23^FH\^FDDest.: ^FS")
		MSCBWrite("^FT300,700^A0B,33,36^FH\^FD"+Alltrim(cNome)+"^FS")
		MSCBWrite("^FT350,780^A0B,25,23^FH\^FDEnd.: ^FS")
		MSCBWrite("^FT350,700^A0B,33,36^FH\^FD"+Alltrim(cEnder)+"^FS")		
		MSCBWrite("^FT390,700^A0B,33,36^FH\^FD"+Alltrim(cBairro)+"^FS")
		MSCBWrite("^FT440,780^A0B,25,23^FH\^FDCidade: ^FS")
		MSCBWrite("^FT440,700^A0B,33,36^FH\^FD"+Alltrim(cCidade)+" / "+Alltrim(cEstado)+"^FS")
		
		MSCBWrite("^FT440,290^A0B,37,38^FH\^FDCEP: "+Substr(cCep,1,5)+"-"+Substr(cCep,6,3)+" ^FS")
		
		MSCBWrite("^FT490,780^A0B,25,23^FH\^FDFone: ^FS")
		MSCBWrite("^FT490,700^A0B,33,36^FH\^FD("+cDdd+") "+cTel+" ^FS")
		
		MSCBWrite("^FT550,490^A0B,33,36^FH\^FDNota Fiscal ^FS")
		MSCBWrite("^FT630,490^A0B,92,90^FH\^FD"+cNota+"^FS")
		
		MSCBWrite("^FT580,780^A0B,43,45^FH\^FDVolume ^FS")
		MSCBWrite("^FT630,770^A0B,43,45^FH\^FD"+cValtoChar(nQtdIni)+" de "+cValtoChar(nQtdVol)+"^FS")
		
		MSCBWrite("^FT600,150^A0B,29,29^FH\^FD"+Substr(Time(),1,5)+"^FS")
		MSCBWrite("^FT625,150^A0B,29,29^FH\^FD"+DToc(Date())+"^FS")		
		
		MSCBWrite("^FT720,670^A0B,25,23^FH\^FD"+allTrim(cTpTransp)+"^FS")
		 
		// linhas pallet
		MSCBWrite("^FO700,120^GB110,0,4^FS")
		//MSCBWrite("^FO700,330^GB110,0,4^FS")
		MSCBWrite("^FO700,690^GB110,0,4^FS")
		//MSCBWrite("^FO700,872^GB110,0,4^FS")		
		//MSCBWrite("^FO700,1150^GB110,0,4^FS")
		
		If cOrdemPal = 1
			MSCBWrite("^FT770,670^A0B,29,29^FH\^FD"+allTrim(cTransp)+"^FS")
		ElseIf cOrdemPal = 2
			MSCBWrite("^FT770,670^A0B,29,29^FH\^FD"+allTrim(cTransp)+"^FS")
		ElseIf cOrdemPal = 3
			MSCBWrite("^FT770,670^A0B,29,29^FH\^FD"+allTrim(cTransp)+"^FS")
		ElseIf cOrdemPal = 4
			MSCBWrite("^FT770,670^A0B,29,29^FH\^FD"+allTrim(cTransp)+"^FS")
		Else 
			MSCBWrite("^FT660,670^A0B,29,29^FH\^FD"+allTrim(cTransp)+"^FS")
		EndIf
		
		// logotipo Ruby Rose
//		MSCBWrite("^FO32,736^GFA,06656,06656,00016,:Z64:")		
		MSCBWrite("^FO32,720^GFA,02016,02016,00032,:Z64:")		
		     //    ^FO18, 15^GFA,  405, 2016,   32,:Z64:
		
		cTextoLog := "eJytlT2OEzEUgJ81K0yxkrPd0mBRU223BYovgUSDBNyAMsVo4uy2ewhughFCKTdHsMQFXLowfrzn+V00corFidJ88/n9aoJYOw6qmLiD2nkez3UusM7lva/yS/hc5a/SbZVf5U2V39xd13nzssrf3F1W+Zc887d2hceZ6zV/czFxs+Y/kP/r02npf0iL/F4Qf8S89BH9xEv9R8SljxgmfiU27COrevLjxK/htvjuiT/zMr+jN37hx2bmZf5Hp5Z+FDMv+/Po1dJPsCiQ9+/opPsodlo65ekh5tKBPPU3cnzps4j6eyw80seUb2lE77ciaEwykNJCEJgAQ1MaUeI79jHLYPj+2GAWGFUptORvW+IuN+wnEWTYiwDKpSG+tuzbfRO2XD/VY+49KNsNfgccH4xg3krKRx88pd/28SkOBdXWHOKW+2uVVT+pArvtfcqT44M+xJY5tUr9SOSPPFOfyNd28In/RmsWvMTXtiV/j05TA9GZsjdcP9rU+4kqTtxF5TGO/EjP9/FtuyPOXaQKovnzfqjf2CH+NnL91EXlmmgARt/18eHd19I/9kXSA+f5F58KDsyj4o3J/UKP86P4Bl575kk5mnOr7Tz/jv0OeBEjZOq/ha5sVe8HGg0lAdrxfrU8P/69GOJTrkjzT8BKgkzzbzCpqX6SmUdQxe9ofwSWLRp9lekKHjnzfVkuD6PvRZSnnaZ6ZfENdULsaeNPML9/SzHKwr/nyfvnuXzlHfRfea7zJp3hsc5FqPPm25n8Vs55fu7/9xz/Cw/"
		cTextoLog := cTextoLog + "TG8k=:3315"
		MSCBWrite(cTextoLog)
		//
		MSCBWrite("^PQ1,0,1,Y^XZ")
		
		//incrementa volume
		nQtdIni++

		MSCBInfoEti("Primaria","100X200") //OK

		MSCBEND() // OK

	MSCBCLOSEPRINTER()


	ConOut("GEREXNS ETIQUETA [ " + cFila + " ]")
Return

 /*/{Protheus.doc} ImpEtqId
Impressão de etiquetas de identificação do volume temporário.  ********** TESTES DE IMPRESSÃO *********

@author    Paulo Lima
@since    16/12/2021
@return    Nil
/*/
User Function xImpEtq() //ImpEtqId(aDados) ETIQUETA TEMPORARIA

	Local _lPrimeiro 	:= .T.
	//Local sConteudo
	Local cFila			:= "000001"
	Local cTransp		:= "TRANSP. DEUS E FIEL"

	Local cVolume		:= "0000000038"
    Local cPedido 		:= '000017'

	ConOut("GEREXNS ANTES [ " + cFila + " ]")
    
    If !MsgYesNo("Imprimir Etiqueta ?","ATENÇÃO","YESNO")	
         MsgAlert("Cancelada pelo Operador!")
		Return
	EndIf
    
	dbselectArea("CB5")
	if dbSeek(xFilial("CB5")+cFila)
		ConOut("GEREXNS ACHOU A FILA NO CB5 [ " + cFila + " ]")
	else
		ConOut("GEREXNS NAO ACHOU A FILA NO CB5 [ " + cFila + " ]")
	endif
	If !CB5SetImp(cFila)
		Alert('Codigo do tipo de impressao invalido. A etiqueta não será impressa.')
		Return .f.
	EndIF

	If _lPrimeiro
		//cID := CBGrvEti('05',{__cVolume,cPedido,cNota,cSerie})

		MSCBCHKSTATUS(.f.) //OK
		
		MSCBBEGIN(1,5,97)
		MSCBWrite("^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ")					
		MSCBWrite("^XA")
		MSCBWrite("^MMT")
		MSCBWrite("^PW1059")
		MSCBWrite("^LL1772")
		MSCBWrite("^LS0")	
		
		//dados da NELIDA - cabeçalho				
		MSCBWrite("^FT100,715^A0B,33,39^FH\^FD=== ETIQUETA TEMPORARIA ===^FS")
		//MSCBWrite("^FT130,715^A0B,25,23^FH\^FDRua da Alfandega , 200 - Sao Paulo / SP Brasil - CEP 03006.030 ^FS")
		MSCBWrite("^FT162,715^A0B,32,34^FH\^FDPECL^FS")
		// linha 		
		MSCBWrite("^FO175,040^GB0,680,4^FS")
		
		MSCBSAYBAR(65,30,cPedido,"B","MB07",8.36,.F.,.T.,.F.,,2,2,.F.,.F.,"1",.T.)

		MSCBWrite("^FT350,770^A0B,32,34^FH\^FDVolume ^FS")
		MSCBWrite("^FT400,770^A0B,32,34^FH\^FD"+cVolume+"^FS")

		MSCBWrite("^FT420,490^A0B,33,36^FH\^FDPEDIDO^FS")
		MSCBWrite("^FT500,490^A0B,92,90^FH\^FD"+cPedido+"^FS")

		// linhas pallet
		MSCBWrite("^FO700,120^GB110,0,4^FS")
		MSCBWrite("^FO700,690^GB110,0,4^FS")
		
		MSCBWrite("^FT770,670^A0B,29,29^FH\^FD"+allTrim(cTransp)+"^FS")
		
		// logotipo Ruby Rose
		MSCBWrite("^FO32,720^GFA,02016,02016,00032,:Z64:")		
		
		cTextoLog := "eJytlT2OEzEUgJ81K0yxkrPd0mBRU223BYovgUSDBNyAMsVo4uy2ewhughFCKTdHsMQFXLowfrzn+V00corFidJ88/n9aoJYOw6qmLiD2nkez3UusM7lva/yS/hc5a/SbZVf5U2V39xd13nzssrf3F1W+Zc887d2hceZ6zV/czFxs+Y/kP/r02npf0iL/F4Qf8S89BH9xEv9R8SljxgmfiU27COrevLjxK/htvjuiT/zMr+jN37hx2bmZf5Hp5Z+FDMv+/Po1dJPsCiQ9+/opPsodlo65ekh5tKBPPU3cnzps4j6eyw80seUb2lE77ciaEwykNJCEJgAQ1MaUeI79jHLYPj+2GAWGFUptORvW+IuN+wnEWTYiwDKpSG+tuzbfRO2XD/VY+49KNsNfgccH4xg3krKRx88pd/28SkOBdXWHOKW+2uVVT+pArvtfcqT44M+xJY5tUr9SOSPPFOfyNd28In/RmsWvMTXtiV/j05TA9GZsjdcP9rU+4kqTtxF5TGO/EjP9/FtuyPOXaQKovnzfqjf2CH+NnL91EXlmmgARt/18eHd19I/9kXSA+f5F58KDsyj4o3J/UKP86P4Bl575kk5mnOr7Tz/jv0OeBEjZOq/ha5sVe8HGg0lAdrxfrU8P/69GOJTrkjzT8BKgkzzbzCpqX6SmUdQxe9ofwSWLRp9lekKHjnzfVkuD6PvRZSnnaZ6ZfENdULsaeNPML9/SzHKwr/nyfvnuXzlHfRfea7zJp3hsc5FqPPm25n8Vs55fu7/9xz/Cw/"
		cTextoLog := cTextoLog + "TG8k=:3315"
		MSCBWrite(cTextoLog)

		MSCBInfoEti("Volume Temp.","30X100")

		MSCBEND() // OK

		MSCBCLOSEPRINTER()

		ConOut("GERETQID ETIQUETA [ " + cFila + " ]")
	Endif
	
Return()
