#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER04  บAutor  ณAlexandre Venancio  บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Auditoria de dados informados em campo para o patrimonio   บฑฑ
ฑฑบ          ณna leitura de maquinas.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTOPER04()

Local aArea	:=	GetArea()
Local aParambox := {}
Local aRet		:= {}
Local cRota		:=	space(6)
Local cPatr		:=	space(6) 
Local dDatCns	:=	dDataBase
Local dLeitD	:=	ctod("  /  /  ")
Local dLeitA	:=	ctod("  /  /  ")
Local aAjuste	:=	{}
Private aLista	:=	{} 
Private aLeitura:=	{}

//Prepare Environment Empresa "01" Filial "01" Tables "SD3" 
If cEmpAnt <> "01"
	Return
EndIf

aAdd(aParamBox,{1,"Rota",cRota,"@!","","ZZ1","",50,.F.})
aAdd(aParamBox,{1,"Considerar M๊s",dDatCns,"99/99/99","","","",50,.F.})
aAdd(aParamBox,{1,"Patrim๔nio",cPatr,"@!","","SN1","",50,.F.})
aAdd(aParamBox,{1,"Leitura De",dLeitD,"@!","","99/99/99","",50,.F.})
aAdd(aParamBox,{1,"Leitura At้",dLeitA,"@!","","99/99/99","",50,.F.})
aAdd(aParamBox,{2,"Considerar?","0", {"0=Plano de Trabalho e Leituras","1=Plano de Trabalho","2=Leituras"},80,'',.T.})
aAdd(aParamBox,{2,"Trazer Horแrios?","2", {"1=Sim","2=Nใo"},60,'',.T.})
	       
If ParamBox(aParambox,'Parametros',aRet)
	If Empty(aRet[1])
		MsgAlert('Rota nใo preenchida','TTOPER04')
		Return
	EndIf
	If Empty(aRet[2])
		MsgAlert('M๊s a ser considerado nใo preenchido','TTOPER04')
		Return
	EndIf
	
	//If val(aRet[6]) == 0 .OR. val(aRet[6]) == 1
		//Roteiriza็ใo do abastecedor no m๊s
		aLista 		:= PreAcols(aRet[1],dtos(firstday(aRet[2]))) 
    //EndIf
    If val(aRet[6]) == 0 .OR. val(aRet[6]) == 2
    	If Empty(aRet[4]) .And. Empty(aRet[5])
			//Leitura dos patrimonios do abastecedor.
			aLeitura 	:= Leituras(aRet[3],dtos(aRet[2]),aRet[1],dtos(aRet[4]),dtos(aRet[5]))    
		Else
			//Leitura mensal da rota de todos os patrimonios.
			If Empty(aRet[3])
				For nX := 1 to len(aLista) 
					aAjuste := Leituras(aLista[nX,06],dtos(firstday(aRet[4])),aRet[1],dtos(aRet[4]),dtos(aRet[5]))
					For nY := 1 to len(aAjuste)
						Aadd(aLeitura,aAjuste[nY])
					Next nY
				Next nX  
			Else
				//Somente um patrimonio de um determinado periodo
				aLeitura 	:= Leituras(aRet[3],dtos(aRet[2]),aRet[1],dtos(aRet[4]),dtos(aRet[5])) 
			EndIf
		EndIf
	EndIf
	//Gerar a planilha.
	If len(aLista) > 0 .OR. len(aLeitura) > 0  
		Processa({||Planilha(aLista[1,8],dtos(firstday(aRet[2])),aRet[3],dtos(aRet[4]),dtos(aRet[5]),val(aRet[6]),aRet[7])},"Aguarde")
	EndIf 
EndIf

RestArea(aArea)

//Reset Environment

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER04  บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Busca informacoes do plano de trabalho                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PreAcols(cRota,cMes)
  
Local cQuery 
Local aAux	:=	{}

cQuery := "SELECT ZE_FILIAL,ZE_CLIENTE,ZE_LOJA,A1_NOME,A1_END,A1_BAIRRO,A1_MUN,ZE_FREQUEN,ZE_CHAPA,N1_DESCRIC,ZE_ROTA,AA1_NOMTEC,"
cQuery += " SUBSTRING(ZE_MENSAL,9,31) AS DIARIO,NL_DESCRIC,ZE_TIPOPLA"
cQuery += " FROM "+RetSQLNAme("SZE")+" ZE WITH(NOLOCK)"
cQuery += " INNER JOIN "+RetSQLNAme("SA1")+" A1 ON A1_COD=ZE_CLIENTE AND A1_LOJA=ZE_LOJA AND A1.D_E_L_E_T_=''" 
cQuery += " INNER JOIN "+RetSQLNAme("SN1")+" N1 ON N1_CHAPA=ZE_CHAPA AND N1.D_E_L_E_T_=''"    
cQuery += " LEFT JOIN "+RetSQLName("SNL")+" NL ON NL_FILIAL='"+xFilial("SNL")+"' AND NL_CODIGO=N1_LOCAL AND NL.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLNAme("AA1")+" AA1 ON AA1_LOCAL=ZE_ROTA AND AA1.D_E_L_E_T_=''"
cQuery += " WHERE ZE_MENSAL LIKE '"+substr(cMes,1,6)+"%' AND ZE.D_E_L_E_T_=''"
cQuery += " AND ZE_ROTA='"+cRota+"'"
cQuery += " ORDER BY ZE_FILIAL,ZE_ROTA"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTOPER04.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aAux,{TRB->ZE_FILIAL,TRB->ZE_CLIENTE,TRB->ZE_LOJA,TRB->A1_NOME,TRB->ZE_FREQUEN,TRB->ZE_CHAPA,TRB->DIARIO,TRB->ZE_ROTA,TRB->AA1_NOMTEC,;
    			TRB->N1_DESCRIC,If(!Empty(TRB->NL_DESCRIC),TRB->NL_DESCRIC,Alltrim(TRB->A1_END)+" / "+Alltrim(TRB->A1_BAIRRO)+" / "+Alltrim(TRB->A1_MUN)),;
    			TRB->ZE_TIPOPLA})
	DbSkip()
EndDo

Return(aAux)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER04  บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Busca informacoes de leituras                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Leituras(cPatrimonio,cMes,cRota,cDt1,cDt2)

Local aAux :=	{}
Local cQuery :=	'' 

If !Empty(cPatrimonio)
	cQuery := "SELECT ZN_FILIAL,ZN_TIPINCL,ZN_DATA,ZN_PATRIMO,ZN_TIPMAQ,ZN_NUMATU,ZN_COTCASH,ZN_BOTTEST,"
	cQuery += " ZN_BOTAO01,ZN_BOTAO02,ZN_BOTAO03,ZN_BOTAO04,ZN_BOTAO05,ZN_BOTAO06,ZN_BOTAO07,ZN_BOTAO08,"
	cQuery += " ZN_BOTAO09,ZN_BOTAO10,ZN_BOTAO11,ZN_BOTAO12,ZN_HORA,ZN_NUMOS,ZN_PARCIAL,ZN_AGENTE,ZN_NOMAGEN"
	cQuery += " FROM "+RetSQLname("SZN")+" WITH(NOLOCK)" 	
	cQuery += " WHERE (ZN_ROTA='"+cRota+"'"
	If Empty(cDt1) .And. Empty(cDt2)
		cQuery += " AND ZN_DATA='"+cMes+"'"
	Else 
		cQuery += " AND ZN_DATA BETWEEN '"+cDt1+"' AND '"+cDt2+"'"
	EndIf
	cQuery += " AND D_E_L_E_T_='' AND ZN_PATRIMO='"+cPatrimonio+"')"
	cQuery += " OR R_E_C_N_O_ IN(SELECT "+If(Empty(cDt1) .And. Empty(cDt2),"TOP 1 ","")+" R_E_C_N_O_ FROM "+RetSQLname("SZN")
	cQuery += " 					WHERE ZN_ROTA='"+cRota+"'"
	
	If Empty(cDt1) .And. Empty(cDt2)
		cQuery += "						 AND ZN_DATA<'"+cMes+"'"
	Else
		cQuery += "						 AND ZN_DATA<'"+cMes+"' AND ZN_DATA>='"+cDt2+"'"
	EndIf
	
	cQuery += "						 AND D_E_L_E_T_='' AND ZN_PATRIMO='"+cPatrimonio+"'
	If Empty(cDt1) .And. Empty(cDt2)
		cQuery += "						ORDER BY ZN_DATA DESC)"
	Else
		cQuery += "	)"
	EndIf
	
	cQuery += " ORDER BY 3 DESC,4"
Else
	For nX := 1 to len(aLista)  
		If nX > 1
			cQuery += " UNION ALL "
		EndIF
		
		//cQuery += " SELECT DISTINCT ZN_FILIAL,ZN_TIPINCL,ZN_DATA,ZN_PATRIMO,ZN_TIPMAQ,ZN_NUMATU,ZN_COTCASH,ZN_BOTTEST,"
		//cQuery += " ZN_BOTAO01,ZN_BOTAO02,ZN_BOTAO03,ZN_BOTAO04,ZN_BOTAO05,ZN_BOTAO06,ZN_BOTAO07,ZN_BOTAO08,"
		//cQuery += " ZN_BOTAO09,ZN_BOTAO10,ZN_BOTAO11,ZN_BOTAO12,ZN_HORA,ZN_NUMOS,ZN_PARCIAL,ZN_AGENTE,ZN_NOMAGEN"
		// Feito com * pois a query estava estourando o tamanho permitido pelo sql
		cQuery += " SELECT * "
		cQuery += " FROM "+RetSQLname("SZN")+" WITH(NOLOCK)" 	
		cQuery += " WHERE (ZN_ROTA='"+cRota+"' AND ZN_DATA='"+cMes+"' AND D_E_L_E_T_='' AND ZN_PATRIMO='"+aLista[nX,06]+"')"
		cQuery += " OR R_E_C_N_O_ IN(SELECT TOP 1 R_E_C_N_O_ FROM "+RetSQLname("SZN")
		cQuery += " WHERE ZN_ROTA='"+cRota+"' AND ZN_DATA<'"+cMes+"' AND D_E_L_E_T_='' AND ZN_PATRIMO='"+aLista[nX,06]+"'
		cQuery += "	ORDER BY ZN_DATA DESC)"
		
	Next nX
	
	cQuery += " ORDER BY 4,3 DESC"

EndIf

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTOPER04.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aAux,{TRB->ZN_FILIAL,TRB->ZN_TIPINCL,cvaltochar(stod(TRB->ZN_DATA)),TRB->ZN_PATRIMO,TRB->ZN_TIPMAQ,TRB->ZN_NUMATU,;
    			TRB->ZN_COTCASH,TRB->ZN_BOTTEST,TRB->ZN_BOTAO01,TRB->ZN_BOTAO02,TRB->ZN_BOTAO03,TRB->ZN_BOTAO04,;
    			TRB->ZN_BOTAO05,TRB->ZN_BOTAO06,TRB->ZN_BOTAO07,TRB->ZN_BOTAO08,TRB->ZN_BOTAO09,TRB->ZN_BOTAO10,;
    			TRB->ZN_BOTAO11,TRB->ZN_BOTAO12,TRB->ZN_HORA,TRB->ZN_NUMOS,TRB->ZN_PARCIAL,TRB->ZN_AGENTE,TRB->ZN_NOMAGEN})
	Dbskip()
EndDo

Return(aAux)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER04  บAutor  ณMicrosiga           บ Data ณ  05/19/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Gera a planilha                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Planilha(cRota,cMes,cPatrim,cDt1,cDt2,cTipo,cHorario)

Local oExcel := FWMSEXCEL():New()
Local cTitulo := "Auditoria"
Local cDir := "c:\temp\"
Local cCabeca := "Rota "+cRota+" / Abastecedor - "+aLista[1,9]
Local cArqXls := Alltrim(cPatrim)+dtos(ddatabase)+strtran(cvaltochar(time()),":")+".xml" 
Local aAux	:=	{}
Local cAuxP	:=	''  
Local aTotA	:=	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}   
Local aTrabd	:=	{}
Local aTrb2		:=	{}
Local nQtdDias	:=	0

If cTipo == 0 .OR. cTipo == 1
	oExcel:AddworkSheet(cTitulo) 
	
	oExcel:AddTable (cTitulo,cCabeca)
	
	oExcel:AddColumn(cTitulo,cCabeca,"Filial",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Cliente",1,1) 
	oExcel:AddColumn(cTitulo,cCabeca,"Loja",1,1) 
	oExcel:AddColumn(cTitulo,cCabeca,"Nome",1,1) 
	oExcel:AddColumn(cTitulo,cCabeca,"Endere็o",1,1) 
	oExcel:AddColumn(cTitulo,cCabeca,"Frequ๊ncia",1,1) 
	oExcel:AddColumn(cTitulo,cCabeca,"Patrim๔nio",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Modelo",1,1)
	
	
	For nX := stod(cMes) to lastday(stod(cMes))
		oExcel:AddColumn(cTitulo,cCabeca,substr(cvaltochar(nX),1,5),1,1) 
		If cvaltochar(cHorario) == '1'
			//Buscar horarios de atendimento dos patrimonios
			aTrb2 := StaticCall(TTOPER02,PlTrab,cRota,nX)
			For nY := 1 to len(aTrb2)
				Aadd(aTrabd,{nX,aTrb2[nY,6],aTrb2[nY,16]})
			Next nY     
		EndIf
		nQtdDias++
	Next nX 
	
	
	For nX := 1 to len(aLista)
	//oExcel:AddRow(cTitulo,"Rota",{aProd[1,6],"","",""}) 
		aAux := {}
		For nY := 1 to len(aLista[nX,07])
			If ascan(atrabd,{|x| cvaltochar(x[1])+x[2] == cvaltochar(stod(substr(cmes,1,6)+cvaltochar(strzero(ny,2))))+alista[nx,6]}) > 0
	        	aadd(aAux,If(substr(aLista[nX,07],nY,1)=="F","F/"+aTrabd[ascan(atrabd,{|x| cvaltochar(x[1])+x[2] == cvaltochar(stod(substr(cmes,1,6)+cvaltochar(strzero(ny,2))))+alista[nx,6]}),3],aTrabd[ascan(atrabd,{|x| cvaltochar(x[1])+x[2] == cvaltochar(stod(substr(cmes,1,6)+cvaltochar(strzero(ny,2))))+alista[nx,6]}),3]))
	  		Else
	  			aadd(aAux,If(substr(aLista[nX,12],1,1)=="6" .AND. substr(aLista[nX,07],nY,1)=="1","C",substr(aLista[nX,07],nY,1)))	
	  		EndIf
		Next nY 
		    
		If nQtdDias == 28    
			oExcel:AddRow(cTitulo,cCabeca, {aLista[nX,01],;
										aLista[nX,02],;
										aLista[nX,03],;
										aLista[nX,04],;
										aLista[nX,11],;
										aLista[nX,05],;
										aLista[nX,06],;
										aLista[nX,10],;
										If(aAux[01]=="0","",aAux[01]),;
										If(aAux[02]=="0","",aAux[02]),;
										If(aAux[03]=="0","",aAux[03]),;
										If(aAux[04]=="0","",aAux[04]),;
										If(aAux[05]=="0","",aAux[05]),;
										If(aAux[06]=="0","",aAux[06]),;
										If(aAux[07]=="0","",aAux[07]),;
										If(aAux[08]=="0","",aAux[08]),;
										If(aAux[09]=="0","",aAux[09]),;
										If(aAux[10]=="0","",aAux[10]),;
										If(aAux[11]=="0","",aAux[11]),;
										If(aAux[12]=="0","",aAux[12]),;
										If(aAux[13]=="0","",aAux[13]),;
										If(aAux[14]=="0","",aAux[14]),;
										If(aAux[15]=="0","",aAux[15]),;
										If(aAux[16]=="0","",aAux[16]),;
										If(aAux[17]=="0","",aAux[17]),;
										If(aAux[18]=="0","",aAux[18]),;
										If(aAux[19]=="0","",aAux[19]),;
										If(aAux[20]=="0","",aAux[20]),;
										If(aAux[21]=="0","",aAux[21]),;
										If(aAux[22]=="0","",aAux[22]),;
										If(aAux[23]=="0","",aAux[23]),;
										If(aAux[24]=="0","",aAux[24]),;    
										If(aAux[25]=="0","",aAux[25]),;
										If(aAux[26]=="0","",aAux[26]),;
										If(aAux[27]=="0","",aAux[27]),;
										If(aAux[28]=="0","",aAux[28])}) 
	
		ElseIf nQtdDias == 29
			oExcel:AddRow(cTitulo,cCabeca, {aLista[nX,01],;
										aLista[nX,02],;
										aLista[nX,03],;
										aLista[nX,04],;
										aLista[nX,11],;
										aLista[nX,05],;
										aLista[nX,06],;
										aLista[nX,10],;
										If(aAux[01]=="0","",aAux[01]),;
										If(aAux[02]=="0","",aAux[02]),;
										If(aAux[03]=="0","",aAux[03]),;
										If(aAux[04]=="0","",aAux[04]),;
										If(aAux[05]=="0","",aAux[05]),;
										If(aAux[06]=="0","",aAux[06]),;
										If(aAux[07]=="0","",aAux[07]),;
										If(aAux[08]=="0","",aAux[08]),;
										If(aAux[09]=="0","",aAux[09]),;
										If(aAux[10]=="0","",aAux[10]),;
										If(aAux[11]=="0","",aAux[11]),;
										If(aAux[12]=="0","",aAux[12]),;
										If(aAux[13]=="0","",aAux[13]),;
										If(aAux[14]=="0","",aAux[14]),;
										If(aAux[15]=="0","",aAux[15]),;
										If(aAux[16]=="0","",aAux[16]),;
										If(aAux[17]=="0","",aAux[17]),;
										If(aAux[18]=="0","",aAux[18]),;
										If(aAux[19]=="0","",aAux[19]),;
										If(aAux[20]=="0","",aAux[20]),;
										If(aAux[21]=="0","",aAux[21]),;
										If(aAux[22]=="0","",aAux[22]),;
										If(aAux[23]=="0","",aAux[23]),;
										If(aAux[24]=="0","",aAux[24]),;    
										If(aAux[25]=="0","",aAux[25]),;
										If(aAux[26]=="0","",aAux[26]),;
										If(aAux[27]=="0","",aAux[27]),;
										If(aAux[28]=="0","",aAux[28]),;
										If(aAux[29]=="0","",aAux[29])}) 
	
		ElseIf nQtdDias == 30
			oExcel:AddRow(cTitulo,cCabeca, {aLista[nX,01],;
										aLista[nX,02],;
										aLista[nX,03],;
										aLista[nX,04],;
										aLista[nX,11],;
										aLista[nX,05],;
										aLista[nX,06],;
										aLista[nX,10],;
										If(aAux[01]=="0","",aAux[01]),;
										If(aAux[02]=="0","",aAux[02]),;
										If(aAux[03]=="0","",aAux[03]),;
										If(aAux[04]=="0","",aAux[04]),;
										If(aAux[05]=="0","",aAux[05]),;
										If(aAux[06]=="0","",aAux[06]),;
										If(aAux[07]=="0","",aAux[07]),;
										If(aAux[08]=="0","",aAux[08]),;
										If(aAux[09]=="0","",aAux[09]),;
										If(aAux[10]=="0","",aAux[10]),;
										If(aAux[11]=="0","",aAux[11]),;
										If(aAux[12]=="0","",aAux[12]),;
										If(aAux[13]=="0","",aAux[13]),;
										If(aAux[14]=="0","",aAux[14]),;
										If(aAux[15]=="0","",aAux[15]),;
										If(aAux[16]=="0","",aAux[16]),;
										If(aAux[17]=="0","",aAux[17]),;
										If(aAux[18]=="0","",aAux[18]),;
										If(aAux[19]=="0","",aAux[19]),;
										If(aAux[20]=="0","",aAux[20]),;
										If(aAux[21]=="0","",aAux[21]),;
										If(aAux[22]=="0","",aAux[22]),;
										If(aAux[23]=="0","",aAux[23]),;
										If(aAux[24]=="0","",aAux[24]),;    
										If(aAux[25]=="0","",aAux[25]),;
										If(aAux[26]=="0","",aAux[26]),;
										If(aAux[27]=="0","",aAux[27]),;
										If(aAux[28]=="0","",aAux[28]),;
										If(aAux[29]=="0","",aAux[29]),;
										If(aAux[30]=="0","",aAux[30])}) 
	
		ElseIf nQtdDias == 31
			oExcel:AddRow(cTitulo,cCabeca, {aLista[nX,01],;
											aLista[nX,02],;
											aLista[nX,03],;
											aLista[nX,04],;
											aLista[nX,11],;
											aLista[nX,05],;
											aLista[nX,06],;
											aLista[nX,10],;
											If(aAux[01]=="0","",aAux[01]),;
											If(aAux[02]=="0","",aAux[02]),;
											If(aAux[03]=="0","",aAux[03]),;
											If(aAux[04]=="0","",aAux[04]),;
											If(aAux[05]=="0","",aAux[05]),;
											If(aAux[06]=="0","",aAux[06]),;
											If(aAux[07]=="0","",aAux[07]),;
											If(aAux[08]=="0","",aAux[08]),;
											If(aAux[09]=="0","",aAux[09]),;
											If(aAux[10]=="0","",aAux[10]),;
											If(aAux[11]=="0","",aAux[11]),;
											If(aAux[12]=="0","",aAux[12]),;
											If(aAux[13]=="0","",aAux[13]),;
											If(aAux[14]=="0","",aAux[14]),;
											If(aAux[15]=="0","",aAux[15]),;
											If(aAux[16]=="0","",aAux[16]),;
											If(aAux[17]=="0","",aAux[17]),;
											If(aAux[18]=="0","",aAux[18]),;
											If(aAux[19]=="0","",aAux[19]),;
											If(aAux[20]=="0","",aAux[20]),;
											If(aAux[21]=="0","",aAux[21]),;
											If(aAux[22]=="0","",aAux[22]),;
											If(aAux[23]=="0","",aAux[23]),;
											If(aAux[24]=="0","",aAux[24]),;    
											If(aAux[25]=="0","",aAux[25]),;
											If(aAux[26]=="0","",aAux[26]),;
											If(aAux[27]=="0","",aAux[27]),;
											If(aAux[28]=="0","",aAux[28]),;
											If(aAux[29]=="0","",aAux[29]),;
											If(aAux[30]=="0","",aAux[30]),;
											If(aAux[31]=="0","",aAux[31])})
		EndIf 
			
	
	Next nX
EndIf

If cTipo == 0 .OR. cTipo == 2
	cTitulo := 'LEITURAS'
	oExcel:AddworkSheet(cTitulo) 
	cCabeca := 'Leitura Patrim๔nio'
	oExcel:AddTable (cTitulo,cCabeca)
	
	oExcel:AddColumn(cTitulo,cCabeca,"Filial",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Tipo Inclusใo",1,1) 
	oExcel:AddColumn(cTitulo,cCabeca,"Data",1,1) 
	oExcel:AddColumn(cTitulo,cCabeca,"Patrim๔nio",1,1) 
	oExcel:AddColumn(cTitulo,cCabeca,"Tipo Maquina",1,1) 
	oExcel:AddColumn(cTitulo,cCabeca,"Numerador Atual",1,1) 
	oExcel:AddColumn(cTitulo,cCabeca,"Total Cash",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total Testes",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total P1",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total P2",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total P3",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total P4",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total P5",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total P6",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total P7",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total P8",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total P9",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total P10",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total P11",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total P12",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Hora Leitura",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Numero OS",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Total Parcial",1,1)
	
	If Len(aLeitura) > 0
		cAuxP := aLeitura[1,4]
		aTotA[1] := aLeitura[1,06] 
		aTotA[2] := aLeitura[1,07] 
		aTotA[3] := aLeitura[1,08] 
		aTotA[4] := aLeitura[1,09] 
		aTotA[5] := aLeitura[1,10] 
		aTotA[6] := aLeitura[1,11] 
		aTotA[7] := aLeitura[1,12] 
		aTotA[8] := aLeitura[1,13] 
		aTotA[9] := aLeitura[1,14] 
		aTotA[10] := aLeitura[1,15] 
		aTotA[11] := aLeitura[1,16] 
		aTotA[12] := aLeitura[1,17] 
		aTotA[13] := aLeitura[1,18] 
		aTotA[14] := aLeitura[1,19] 
		aTotA[15] := aLeitura[1,20] 
				
		For nX := 1 to len(aLeitura)
			If cAuxP != aLeitura[nX,04]
				oExcel:AddRow(cTitulo,cCabeca, {'Totais',;
											'',;
											'',;
											'',;
											'',;
											aTotA[1],;
											aTotA[2],;
											aTotA[3],;
											aTotA[4],;
											aTotA[5],;
											aTotA[6],;
											aTotA[7],;
											aTotA[8],;
											aTotA[9],;
											aTotA[10],;
											aTotA[11],;
											aTotA[12],;
											aTotA[13],;
											aTotA[14],;
											aTotA[15],;
											'',;
											'',;
											''})
				oExcel:AddRow(cTitulo,cCabeca, {'-',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											'',;
											''})
				cAuxP := aLeitura[nX,04]
				aTotA[1] := aLeitura[nX,06] 
				aTotA[2] := aLeitura[nX,07] 
				aTotA[3] := aLeitura[nX,08] 
				aTotA[4] := aLeitura[nX,09] 
				aTotA[5] := aLeitura[nX,10] 
				aTotA[6] := aLeitura[nX,11] 
				aTotA[7] := aLeitura[nX,12] 
				aTotA[8] := aLeitura[nX,13] 
				aTotA[9] := aLeitura[nX,14] 
				aTotA[10] := aLeitura[nX,15] 
				aTotA[11] := aLeitura[nX,16] 
				aTotA[12] := aLeitura[nX,17] 
				aTotA[13] := aLeitura[nX,18] 
				aTotA[14] := aLeitura[nX,19] 
				aTotA[15] := aLeitura[nX,20] 
				oExcel:AddRow(cTitulo,cCabeca, {aLeitura[nX,01],;
												aLeitura[nX,02],;
												aLeitura[nX,03],;
												aLeitura[nX,04],;
												aLeitura[nX,05],;
												aLeitura[nX,06],;
												aLeitura[nX,07],;
												aLeitura[nX,08],;
												aLeitura[nX,09],;
												aLeitura[nX,10],;
												aLeitura[nX,11],;
												aLeitura[nX,12],;
												aLeitura[nX,13],;
												aLeitura[nX,14],;
												aLeitura[nX,15],;
												aLeitura[nX,16],;
												aLeitura[nX,17],;
												aLeitura[nX,18],;
												aLeitura[nX,19],;
												aLeitura[nX,20],;
												aLeitura[nX,21],;
												aLeitura[nX,22],;
												aLeitura[nX,23]})
			Else
				oExcel:AddRow(cTitulo,cCabeca, {aLeitura[nX,01],;
												aLeitura[nX,02],;
												aLeitura[nX,03],;
												aLeitura[nX,04],;
												aLeitura[nX,05],;
												aLeitura[nX,06],;
												aLeitura[nX,07],;
												aLeitura[nX,08],;
												aLeitura[nX,09],;
												aLeitura[nX,10],;
												aLeitura[nX,11],;
												aLeitura[nX,12],;
												aLeitura[nX,13],;
												aLeitura[nX,14],;
												aLeitura[nX,15],;
												aLeitura[nX,16],;
												aLeitura[nX,17],;
												aLeitura[nX,18],;
												aLeitura[nX,19],;
												aLeitura[nX,20],;
												aLeitura[nX,21],;
												aLeitura[nX,22],;
												aLeitura[nX,23]})
				If nX > 1
					aTotA[1] -= aLeitura[nX,06] 
					aTotA[2] -= aLeitura[nX,07] 
					aTotA[3] -= aLeitura[nX,08] 
					aTotA[4] -= aLeitura[nX,09] 
					aTotA[5] -= aLeitura[nX,10] 
					aTotA[6] -= aLeitura[nX,11] 
					aTotA[7] -= aLeitura[nX,12] 
					aTotA[8] -= aLeitura[nX,13] 
					aTotA[9] -= aLeitura[nX,14] 
					aTotA[10]-= aLeitura[nX,15] 
					aTotA[11]-= aLeitura[nX,16] 
					aTotA[12]-= aLeitura[nX,17] 
					aTotA[13]-= aLeitura[nX,18] 
					aTotA[14]-= aLeitura[nX,19] 
					aTotA[15]-= aLeitura[nX,20]  
				EndIf
			EndIf
		Next nX
		
				oExcel:AddRow(cTitulo,cCabeca, {'Totais',;
											'',;
											'',;
											'',;
											'',;
											aTotA[1],;
											aTotA[2],;
											aTotA[3],;
											aTotA[4],;
											aTotA[5],;
											aTotA[6],;
											aTotA[7],;
											aTotA[8],;
											aTotA[9],;
											aTotA[10],;
											aTotA[11],;
											aTotA[12],;
											aTotA[13],;
											aTotA[14],;
											aTotA[15],;
											'',;
											'',;
											''})
	
	EndIf 

EndIf
										
oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTPROC20","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTPROC20", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  

Return