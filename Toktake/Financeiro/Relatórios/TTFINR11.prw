#INCLUDE "TOPCONN.CH"   
#INCLUDE "TBICONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR11  บAutor  ณAlexandre Venancio  บ Data ณ  16/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consolidado contas a receber          					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFINR11()                                                                                                                                                                                                                                                                 //VALLIQ E O CONTEUDO DE E1_VALOR - E1 SALDO                                                                                            "E1_CCC",
	Local oReport       //    1			  2			3           4           5            6             7            8          9             10        11            12         13          14          15          16         17           18         19         20           21           22          23         24          25           26          27          28          29         30         31       32         33      34          	 35         36                                                                   //CTT_DESC01
	Private aCampos	:=	{"E1_PREFIXO","E1_NUM","E1_PARCELA","E1_TIPO","E1_PORTADO","E1_SITUACA","E1_NATUREZ","ED_DESCRIC","E1_EMISSAO","E1_EMIS1","E1_VENCORI","E1_VENCREA","E1_BAIXA","E5_MOTBX","E5_HISTOR","E1_VALOR","E1_DESCONT","E1_JUROS","E1_MULTA","E1_ACRESC","E1_DECRESC","E1_VALLIQ","E1_SALDO","E5_BANCO","E1_XRETCNB","E1_PEDIDO","E1_USERLGA","E1_CLIENTE","E1_LOJA","A1_NOME","A1_CGC","A1_NREDUZ"} //,"A1_END"} //,"E1_CREDIT","CT1_DESC01"}

If cEmpAnt == "01"
	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()
	Else
		Alert("Esta op็ใo ainda nใo estแ disponํvel")
	EndIf
ENDIF
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR11  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Local clDesc	:="Consolida็ใo dos titulos a pagar e receber"
	Local clTitulo	:="Indicadores"
	Local clProg	:="TTFINR11"
	Local aAux		:=	{}
	Private cPerg	:="TTFINR11"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New(clProg,clTitulo,cPerg,{|oReport| PrintReport(oReport)},clDesc)
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Consolidacao"),{"TRB"})

    For nX := 1 to len(aCampos)
    	aAux := StrtokArr(aCampos[nX],"_")
		TRCell():New(oSection1,aAux[2]		,"TRB",aAux[2]	,PesqPict(If(len(aAux[1])==2,"S"+aAux[1],aAux[1]),aCampos[nX]),TamSX3(aCampos[nX])[1])	
	Next nX
		

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR01  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	/*----------------------------------------------------------------------------| 		    			           
	|sele็ao dos dados a serem impressos/carrega o arquivo temporario de trabalho | 
	|----------------------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	
	/*-----------------------------|
	| impressao da primeira se็ao  | 
	|-----------------------------*/
	
	DbSelectArea("TRB")
	DbGoTop()
	oReport:SetMeter(RecCount())
	oSection1:Init()         
	While  !Eof()
		If oReport:Cancel()
			Exit
		EndIf
		oSection1:PrintLine()
		DbSelectArea("TRB")
		DbSkip()            
		oReport:IncMeter()
	EndDo
	oSection1:Finish()		
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR01  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fSelDados()
	
Local aRet		:=	{}
Local aAux		:=	{}
Local aAux2		:=	{}
	
_aStru	:= {} 

For nX := 1 to len(aCampos)
	aAux := StrtokArr(aCampos[nX],"_")
	aAux2:= TamSX3(aCampos[nX])
	AADD(_aStru,{aAux[2]	,aAux2[3],aAux2[1],aAux2[2]})
Next nX		                     

_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)

clQuery := " SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_PORTADO,E1_SITUACA,E1_NATUREZ,ED_DESCRIC,E1_EMISSAO,E1_EMIS1,E1_VENCORI,E1_VENCREA,"
clQuery += " E1_BAIXA,E5_MOTBX,E5_HISTOR,"
clQuery += " E1_VALOR,E1_DESCONT,E1_JUROS,E1_MULTA,E1_ACRESC,E1_DECRESC,E1_VALOR-E1_SALDO AS E1_VALLIQ,E1_SALDO,"
clQuery += " E5_BANCO,E1_XRETCNB,E1_PEDIDO,E1_USERLGA,"
clQuery += " E1_CLIENTE,E1_LOJA,A1_NOME,A1_CGC,A1_NREDUZ,A1_END,E1_CCC,CTT_DESC01,E1_CREDIT,CT1_DESC01 "
clQuery += " FROM "+RetSQLName("SE1")+" E1"  
clQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_FILIAL='' AND ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
clQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
clQuery += " LEFT JOIN "+RetSQLName("CTT")+" CTT ON CTT_FILIAL='' AND CTT_CUSTO=E1_CCC AND CTT.D_E_L_E_T_=''"
clQuery += " LEFT JOIN "+RetSQLName("CT1")+" CT1 ON CT1_CONTA=E1_CREDIT AND CT1.D_E_L_E_T_=''"
clQuery += " LEFT JOIN "+RetSQLName("SE5")+" E5 ON E5_NUMERO=E1_NUM AND E5_PARCELA=E1_PARCELA AND E5_PREFIXO=E1_PREFIXO AND E5_CLIFOR=E1_CLIENTE AND E5_LOJA=E1_LOJA AND E5.D_E_L_E_T_=''"
clQuery += " WHERE E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
clQuery += " AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
clQuery += " AND E1.D_E_L_E_T_='' ORDER BY E1_EMISSAO"

If Select("TRBROTA") > 0
	dbSelectArea("TRBROTA")
	DbCloseArea()
EndIf

MemoWrite("TTPROR01.SQL",clQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"TRBROTA",.F.,.T.)

dbSelectArea("TRBROTA")
dbGotop()

Do While TRBROTA->(!Eof())					    				
				
	DbSelectArea("TRB")
	
	RecLock("TRB",.T.)   
 
	For nX := 1 to len(aCampos)
		aAux := StrtokArr(aCampos[nX],"_")
		aAux2:= TamSX3(aCampos[nX])

		&(TRB->(aAux[2])) 	:= If(aAux2[3]=="D",stod(TRBROTA->&(aCampos[nX])),TRBROTA->&(aCampos[nX]))
	Next nX		                     
				
	MsUnlock()	
	
	dbSelectArea("TRBROTA")
	DbSkip()
Enddo 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR08  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValPerg(cPerg)

PutSx1(cPerg,'01','Emissใo De?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'02','Emissใo At้?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'03','Vencimento De?','','','mv_ch3','D',8, 0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'04','Vencimento At้?','','','mv_ch4','D',8, 0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')

Return                                        