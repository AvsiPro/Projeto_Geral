#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'

 /*/{Protheus.doc} ImpEtqId
Impressão de etiquetas de identificação do volume temporário.

@author    Paulo Lima
@since    16/12/2021
@return    Nil
/*/
User Function ImpEtqId(aDados)

//	Local __cVolume 	:= aDados[1]
//	Local cPedido 		:= aDados[2]
//	Local cNota   		:= IF(len(aDados)>=3,aDados[3],nil)
//	Local cSerie  		:= IF(len(aDados)>=4,aDados[4],nil)
//	Local cID     		:= ""
	Local _lPrimeiro 	:= .T.

	If Upper(Alltrim(FunName())) == "ACDV177"
		If Type("_lPassou") == "U"
			Public _lPassou := .T.
		Else
			_lPrimeiro := .F.
		Endif
	Endif

	If _lPrimeiro
/*/
		cID := CBGrvEti('05',{__cVolume,cPedido,cNota,cSerie})

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
		
		MSCBSAYBAR(65,30,cID,"B","MB07",8.36,.F.,.T.,.F.,,2,2,.F.,.F.,"1",.T.)

		MSCBWrite("^FT350,770^A0B,32,34^FH\^FDVolume ^FS")
		MSCBWrite("^FT400,770^A0B,32,34^FH\^FD"+cID+"^FS")

		MSCBWrite("^FT420,490^A0B,33,36^FH\^FDPEDIDO^FS")
		MSCBWrite("^FT500,490^A0B,92,90^FH\^FD"+cPedido+"^FS")

		// linhas pallet
		MSCBWrite("^FO700,120^GB110,0,4^FS")
		MSCBWrite("^FO700,690^GB110,0,4^FS")
		
		//MSCBWrite("^FT770,670^A0B,29,29^FH\^FD"+allTrim(cTransp)+"^FS")
		
		// logotipo Ruby Rose
		MSCBWrite("^FO32,720^GFA,02016,02016,00032,:Z64:")		
		
		cTextoLog := "eJytlT2OEzEUgJ81K0yxkrPd0mBRU223BYovgUSDBNyAMsVo4uy2ewhughFCKTdHsMQFXLowfrzn+V00corFidJ88/n9aoJYOw6qmLiD2nkez3UusM7lva/yS/hc5a/SbZVf5U2V39xd13nzssrf3F1W+Zc887d2hceZ6zV/czFxs+Y/kP/r02npf0iL/F4Qf8S89BH9xEv9R8SljxgmfiU27COrevLjxK/htvjuiT/zMr+jN37hx2bmZf5Hp5Z+FDMv+/Po1dJPsCiQ9+/opPsodlo65ekh5tKBPPU3cnzps4j6eyw80seUb2lE77ciaEwykNJCEJgAQ1MaUeI79jHLYPj+2GAWGFUptORvW+IuN+wnEWTYiwDKpSG+tuzbfRO2XD/VY+49KNsNfgccH4xg3krKRx88pd/28SkOBdXWHOKW+2uVVT+pArvtfcqT44M+xJY5tUr9SOSPPFOfyNd28In/RmsWvMTXtiV/j05TA9GZsjdcP9rU+4kqTtxF5TGO/EjP9/FtuyPOXaQKovnzfqjf2CH+NnL91EXlmmgARt/18eHd19I/9kXSA+f5F58KDsyj4o3J/UKP86P4Bl575kk5mnOr7Tz/jv0OeBEjZOq/ha5sVe8HGg0lAdrxfrU8P/69GOJTrkjzT8BKgkzzbzCpqX6SmUdQxe9ofwSWLRp9lekKHjnzfVkuD6PvRZSnnaZ6ZfENdULsaeNPML9/SzHKwr/nyfvnuXzlHfRfea7zJp3hsc5FqPPm25n8Vs55fu7/9xz/Cw/"
		cTextoLog := cTextoLog + "TG8k=:3315"
		MSCBWrite(cTextoLog)

		MSCBInfoEti("Volume Temp.","100X200")

		MSCBEND() // OK

		MSCBCLOSEPRINTER()
/*/
	Endif

	If _lPrimeiro
/*/
		cID := CBGrvEti('05',{__cVolume,cPedido,cNota,cSerie})

		MSCBBEGIN(1,3)
		MSCBBOX(01,02,34,76,1)
		MSCBLineV(30,30,76,1)
		MSCBLineV(27,8,192,4)
		MSCBLineV(15,02,76,1)
		MSCBLineH(23,30,34,1)
		MSCBSAY(32,33,"VOLUME","R","2","25,23")
		MSCBSAY(29,33,"CODIGO","R","2","25,23")
		MSCBSAY(26,33, __cVolume, "R", "2", "25,23")
		If trim(cNota) == NIL
			MSCBSAY(22,05,"Pedido","R","2","25,23")
			MSCBSAY(19,05,cPedido,"R", "2", "25,23")
		Else
			MSCBSAY(22,05,"Nota","R","2","25,23")
			MSCBSAY(19,05,cNota+ ' '+cSerie,"R", "2", "25,23")
		EndIf
		MSCBSAYBAR(12,22,cId,"R","MB07",8.36,.F.,.T.,.F.,,2,2,.F.,.F.,"1",.T.)
		MSCBInfoEti("Volume Temp.","30X100")
		sConteudo := MSCBEND()
/*/
	Endif
	

	cVolume := aDados[1]
	
Return(_lPrimeiro)
