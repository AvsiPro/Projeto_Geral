#INCLUDE "FINR290.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE CRLF CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinR290CP() ³ Autor ³ Fabio Sales		³ Data ³  2709.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao dos Juros devidos e não pagos baseado              ³±±
±±³            no relatório FINR290()                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINR290CP()	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function TTFINR06()
	Local oReport	
	If FindFunction("TRepInUse") .And. TRepInUse()
		oReport := ReportDef()
		oReport:PrintDialog()
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ReportDef³ Autor ³ Fabio Sales           ³ Data ³ 03.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impress„o do Arquivo de Envio de Titulos ao Banco  - SE1   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

Static Function ReportDef()

	Local oReport  
	Local oSection1
	Local cAliasQry1 := GetNextAlias()
	Local aTam1,aTam2,aTam3
	
	
	oReport := TReport():New("TTFINR06",STR0004,"FIN290C",; 
	{|oReport| ReportPrint(oReport,@cAliasQry1)},STR0001+STR0002+STR0003)
	
	oReport:SetPortrait(.T.)
	
	pergunte("FIN290C",.F.)
	
	
	oSection1 := TRSection():New(oReport,STR0031,{"SE1","SA1","SED"}) //'Titulos'
	
	aTam1 := TamSX3("E1_CLIENTE")
	aTam2 := TamSX3("E1_LOJA")
	nTamCli :=	aTam1[1] + aTam2[1] + 1                   
	aTam1 := TamSX3("E1_PREFIXO")
	aTam2 := TamSX3("E1_NUM")
	aTam3 := TamSX3("E1_PARCELA")
	nTamTit :=	aTam1[1] + aTam2[1] + aTam3[1] + 5
	
	TRCell():New(oSection1,"E1_PORTADO","SE1",STR0017,,3,.F.,			{|| (cAliasQry1)->E1_PORTADO })
	TRCell():New(oSection1,"CLIENTE"   ,"SE1",STR0018,,nTamCli,.F.,		{|| (cAliasQry1)->E1_CLIENTE })
	TRCell():New(oSection1,"CLIENTE"   ,"SE1","LOJA",,nTamCli,.F.,		{|| (cAliasQry1)->E1_LOJA })
	TRCell():New(oSection1,"A1_NREDUZ" ,"SA1",STR0019,,,.F.,			{|| (cAliasQry1)->A1_NREDUZ  })
	TRCell():New(oSection1,"TITULO"    ,"SE1",STR0020,,nTamTit,.F.,		{|| (cAliasQry1)->E1_NUM  })
	TRCell():New(oSection1,"TITULO"    ,"SE1","PREFIXO",,nTamTit,.F.,	{|| (cAliasQry1)->E1_PREFIXO })
	TRCell():New(oSection1,"E1_VENCTO" ,"SE1",STR0021,,,.F.,			{|| (cAliasQry1)->E1_VENCTO })
	TRCell():New(oSection1,"ATRASO"    ,	 ,STR0022,,4,.F.,)
	TRCell():New(oSection1,"E1_BAIXA"  ,"SE1",STR0023,,,.F.,			{|| (cAliasQry1)->E1_BAIXA })   //SOMENTE PARA BAIXADO
	TRCell():New(oSection1,"E1_VALOR"  ,"SE1",STR0024+CRLF+STR0025,"@E 99,999,999.99",13,.F.,)
	TRCell():New(oSection1,"E1_SALDO"  ,"SE1",STR0026+CRLF+STR0025,"@E 99,999,999.99",13,.F.,)
	TRCell():New(oSection1,"E1_DEV"    ,"SE1",STR0027+CRLF+STR0028,"@E 99,999,999.99",13,.F.,)
	TRCell():New(oSection1,"E1_PAG"    ,"SE1",STR0027+CRLF+STR0029,"@E 99,999,999.99",13,.F.,)
	TRCell():New(oSection1,"E1_DIF"    ,"SE1",STR0030,"@E 99,999,999.99",13,.F.,)
	TRCell():New(oSection1,"D2_CCUSTO" ,"SD2","CENTRO_DE_CUSTO",,,.F.,	{|| (cAliasQry1)->D2_CCUSTO })
	TRCell():New(oSection1,"E1_MSFIL" ,"SE1","FILIAL","@!",02,.F.,	{|| (cAliasQry1)->E1_MSFIL })
	
	#IFNDEF TOP
		TRPosition():New ( oSection1, "SA1" , 1 ,{|| xfilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA) } , .T. ) 
		TRPosition():New ( oSection1, "SED" , 1 ,{|| xfilial("SED")+SE1->(E1_NATUREZ) } , .T. ) 
	#ENDIF
	
Return oReport                                         

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Fabio Sales            ³ Data ³  27.09.10³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/  

Static Function ReportPrint(oReport, cAliasQry1 )
	Local oSection1 := oReport:Section(1)
	Local cQuery	:= ""
	Local cFiltro	:= ""
	Local nDias		:= 0
	Local nValorTit	:= 0
	Local nSaldoTit := 0
	Local nJDevido 	:= 0
	Local nJPago	:= 0
	Local nJuroDif	:= 0
	Local nDecs		:= MsDecimais(mv_par09)    
	Local aJuroCalc	:= {0,0}      && array de juros (1 - juros devido, 2 - juros pago)
	Local lBaixados	:= Iif( mv_par08 == 2, .T., .F. )
	Local oBreak
	Local clTit	
	Local clPrefi
	Local clCli
	Local clLoja
	
	Private dBaixa := dDataBase
	
	dbSelectArea("SE1")
	dbSetorder(4)     
	
	#IFDEF TOP
	
		oSection1:BeginQuery()
	
			&& Baixados?
			If mv_par08 == 2
				cQuery += " AND E1_SALDO = 0 "
			Else
				cQuery += " AND E1_SALDO <> 0 "	
			EndIf
	
			&&nao imprime de outra moeda 	                                   
			If mv_par10 == 2
				cQuery += " AND E1_MOEDA = " + STR(mv_par09,2)
			EndIf
			
			cQuery += " AND E1_TIPO NOT IN " + FormatIn(MVABATIM,"|")			
			cQuery += " ORDER BY " + SqlOrder(IndexKey())	
			cQuery := "%" + cQuery + "%"
	
			BeginSql Alias cAliasQry1
	
				SELECT  SE1.*, 
						SA1.A1_NREDUZ,SD2.D2_DOC,SD2.D2_SERIE,
						SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_CCUSTO   
				FROM %table:SA1% SA1 ,
					%table:SE1% SE1
					LEFT OUTER JOIN %table:SED% SED 
						ON	(  &&	ED_FILIAL 	= 	%xFilial:SED% AND                                  
								ED_CODIGO 	=	E1_NATUREZ AND
								SED.%NotDel% )
						LEFT OUTER JOIN  %table:SD2% SD2
						   ON  	(&&D2_FILIAL 	= %xFilial:SD2% AND                                  
					 			D2_DOC 		=	E1_NUM	AND
								D2_SERIE 	= 	RIGHT(E1_PREFIXO,1) AND 
								D2_CLIENTE 	=	E1_CLIENTE	AND
								D2_LOJA 	= 	E1_LOJA AND 
								SED.%NotDel% )    							
	
				WHERE E1_MSFIL BETWEEN %exp:MV_PAR12% AND %exp:MV_PAR13% AND
				
						E1_PORTADO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02% AND
						E1_TIPO <> 'JP' AND
						E1_CLIENTE between %exp:mv_par05% AND %exp:mv_par06% AND
						E1_BAIXA between %exp:mv_par03% AND %exp:mv_par04% AND
						SE1.%NotDel% AND
						
						&&A1_FILIAL 	= %xFilial:SA1% AND                                  
					 	A1_COD 		=	E1_CLIENTE	AND
						A1_LOJA 	= 	E1_LOJA     AND
											 
						SA1.%NotDel% 						
						%Exp:cQuery%
			EndSql
	
		oSection1:EndQuery()	
	
	#ELSE
	
		cAliasQry1 := "SE1"
	
		cFiltro := '!Eof() .And. SE1->E1_FILIAL == "'+ cFilial+'" .And. SE1->E1_PORTADO <="'+ MV_PAR02+'"'
		cFiltro := 'SE1->E1_TIPO!="JP" .And. '
		cFiltro += 'DTOS(SE1->E1_VENCTO)>="'+ DTOS(mv_par03) +'".And.DTOS(SE1->E1_VENCTO)<="'+ DTOS(mv_par04) +'" .And. '
		cFiltro += 'SE1->E1_CLIENTE>="'+ mv_par05 +'" .And. SE1->E1_CLIENTE<="'+ mv_par06 +'" .And. '
		cFiltro += If(lBaixados, 'SE1->E1_SALDO==0','SE1->E1_SALDO!=0 ') 
		cFiltro += If(mv_par10==2, ' .And. SE1->E1_MOEDA==mv_par09',"") //nao imprime de outra moeda 	
		&& Nao considera abatimentos                                                                    
		cFiltro += " .And. !(SE1->E1_TIPO $ '" + MVABATIM + "') "
	
		oSection1:SetFilter(cFiltro,(cAliasQry1)->(IndexKey()))	
		
	#ENDIF                                        
	
	oBreak := TRBreak():New ( oSection1 ,  oSection1:Cell("Bco")  , "Sub Total" , .F. ) 
	
	oSection1:Cell("ATRASO"):SetBlock(		{|| nDias } )
	oSection1:Cell("E1_VALOR"):SetBlock(	{|| nValorTit } )
	oSection1:Cell("E1_SALDO"):SetBlock(	{|| nSaldoTit } )
	oSection1:Cell("E1_DEV"):SetBlock(		{|| nJDevido } )
	oSection1:Cell("E1_PAG"):SetBlock(		{|| nJPago } )
	oSection1:Cell("E1_DIF"):SetBlock(		{|| nJuroDif } )
	     
	If lBaixados .And. (cAliasQry1)->(!Eof())
		oSection1:Cell("Saldo"+CRLF+"Título"):Disable()
		oReport:SetTitle( STR0004 + " " + GetMv("MV_MOEDA"+Str(mv_par09,1)) + STR0009 )
		
		TRFunction():New(oSection1:Cell("E1_VALOR")	,"T_VALOR"	,"SUM",oBreak,,,,.T.,.F.)
		TRFunction():New(oSection1:Cell("E1_DEV")	,"T_J_DEV"	,"SUM",oBreak,,,,.T.,.F.)
		TRFunction():New(oSection1:Cell("E1_PAG")	,"T_J_PAG"	,"SUM",oBreak,,,,.T.,.F.)
		TRFunction():New(oSection1:Cell("E1_DIF")	,"T_DIF"	,"SUM",oBreak,,,,.T.,.F.)
	ElseIf (cAliasQry1)->(!Eof())
	//	oSection1:Cell("DT.Pagto"):Disable()
		oSection1:Cell("E1_DEV"):Disable()
		oSection1:Cell("E1_PAG"):Disable()
		oReport:SetTitle( STR0004 + GetMv("MV_MOEDA"+Str(mv_par09,1)) + STR0007 )	
		TRFunction():New(oSection1:Cell("E1_SALDO")	,"T_SALDO"	,"SUM",oBreak,,,,.T.,.F.)
	  	TRFunction():New(oSection1:Cell("E1_DIF")	,"T_DIF"	,"SUM",oBreak,,,,.T.,.F.)
		oSection1:Cell("E1_DIF"):SetTitle(STR0027+CRLF+STR0028)
	EndIf
	
	oSection1:SetTotalInLine(.F.)
	oReport:SetMeter((cAliasQry1)->(LastRec()))
			                   
	(cAliasQry1)->(dbGoTop())
	
	oSection1:Init()
	
	While (cAliasQry1)->(!Eof())		
			
		nSaldoTit := xMoeda((cAliasQry1)->(E1_SALDO+E1_SDACRES-E1_SDDECRE),(cAliasQry1)->E1_MOEDA,mv_par09,(cAliasQry1)->E1_EMISSAO,nDecs+1)

		&& Titulo Baixado
		If lBaixados
			If (cAliasQry1)->E1_BAIXA > DataValida((cAliasQry1)->E1_VENCTO,.T.)
				nDias := (cAliasQry1)->E1_BAIXA - (cAliasQry1)->E1_VENCTO
			Else
				nDias := (cAliasQry1)->E1_BAIXA - DataValida((cAliasQry1)->E1_VENCTO,.T.)
			Endif
		ElseIf dDataBase > DataValida((cAliasQry1)->E1_VENCTO,.T.)
			nDias  := (dDataBase - (cAliasQry1)->E1_VENCTO)	&& sem data valida, para considerar final de semana em atraso
		Else
			nDias  := 0
		Endif

		If nDias <= 0     
			(cAliasQry1)->( dbSkip() )
			loop
		EndIf                      

		nValorTit := xMoeda((cAliasQry1)->E1_VALOR,(cAliasQry1)->E1_MOEDA,mv_par09,(cAliasQry1)->E1_EMISSAO,nDecs+1)
      
		If lBaixados
			dBaixa := (cAliasQry1)->E1_BAIXA  
		Else
			dBaixa := dDataBase		&& data p/calculo de juros n„o pagos (fa070juros)
		Endif

		aJuroCalc := FR290Juros(mv_par09, lBaixados , (cAliasQry1)->E1_VENCTO , cAliasQry1)     && moeda selecionada
		nJDevido := aJuroCalc[1]
		nJPago	:= aJuroCalc[2]

		If lBaixados
			nJuroDif := ( nJDevido - nJPago )
  		Else
  			nJuroDif := nJDevido
  		Endif      

		If ( nJuroDif >= mv_par07 )    && Valor minimo de juros a ser listado
			oSection1:PrintLine()
		EndIf 
		clTit	:=(cAliasQry1)->E1_NUM
		clPrefi	:=(cAliasQry1)->E1_PREFIXO
		clCli	:=(cAliasQry1)->E1_CLIENTE
		clLoja	:=(cAliasQry1)->E1_LOJA
		While	(cAliasQry1)->E1_NUM==	clTit .AND.(cAliasQry1)->E1_PREFIXO== clPrefi .AND. (cAliasQry1)->E1_CLIENTE==clCli .AND. ;
			 	(cAliasQry1)->E1_LOJA==clLoja .AND. (cAliasQry1)->(!Eof())				
			(cAliasQry1)->( dbSkip() )
		EndDo
		clTit	:=""
		clPrefi	:=""
		clCli	:=""
		clLoja	:=""
		oReport:IncMeter()		
   	EndDo  
	oSection1:Finish()
Return