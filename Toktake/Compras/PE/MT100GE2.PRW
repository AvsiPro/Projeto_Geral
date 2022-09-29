
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦MT100GE2()  ¦ Autor ¦ Ricardo Souza	    ¦ Data ¦25.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ ponto de entrada executado apòs a gravação do contas a     ¦¦¦
¦¦¦			 ¦ pagar													  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function  MT100GE2()
   
Local aAreage2 := GetArea()
Local cQuery
Local clFornece
Local clLoja
Local clDoc
Local clsql
Local clFilial
Local clEstoque:="" 
Local nlTotNot := 0 
Local nlTotComp:= 0
Local nlTotDesc:= 0
Local CRLF     := CHR(13)  
Local llFlag   := .T. // Verifica se Houve bloqueio.
Local ctrl     := .T. // para gravar divergência por cond pgto apenas 1 vez na tabela de Log.
Local clblqQtde:= .T. // verificar se hou divergência po quantidade entre nota e pedido.
Local clBlqConSega:= .T. // vefica se houve divergência por Nota e conferência Sega.
Local cTesPcNf := SuperGetMV("MV_TESPCNF")

// AMC
If cEmpAnt == "10"
	Return
EndIf

  	  			
If 	GetMv("MV_XDIVNF")==.T. .And. (SF1->F1_TIPO=="N")
 
 	DbSelectArea("SF1")
 		 
	clSql := " SELECT D1_DOC " +CRLF
	clSql +=	"  ,D1_ITEM     " +CRLF 
	clSql +=	"  ,D1_PEDIDO   " +CRLF 
	clSql +=	"  ,C7_NUM      " +CRLF 
	clSql +=	"  ,D1_TES      " +CRLF
	clSql +=	"  ,D1_COD      " +CRLF
	clSql +=	"  ,C7_ITEM     " +CRLF
	clSql +=	"  ,D1_ITEMPC   " +CRLF
	clSql +=	"  ,'PRCUNIT' = D1_VUNIT - CASE WHEN D1_VALDESC <> 0 THEN D1_VALDESC/D1_QUANT ELSE 0 END " +CRLF
	clSql +=	"  ,C7_PRECO    " +CRLF
	clSql +=	"  ,D1_QUANT    " +CRLF
	clSql +=	"  ,C7_QUANT    " +CRLF
	clSql +=	"  ,D1_XCLASPN  " +CRLF
	clSql +=	"  ,D1_VUNIT    " +CRLF
	clSql +=	"  ,D1_VALDESC  " +CRLF
	clSql +=	"  ,D1_TOTAL    " +CRLF
	clSql +=	"  ,D1_FORNECE  " +CRLF
	clSql +=	"  ,D1_LOJA    	" +CRLF
	clSql +=	"  ,C7_COND    	" +CRLF
	clSql +=	"  ,F4_ESTOQUE  " +CRLF
	clSql +=	"  ,F4_XBLQFIN  " +CRLF
	clSql += " FROM "+RetSqlName("SD1")+" AS SD1  		 " +CRLF
	clSql += " INNER JOIN "+RetSqlName("SC7")+" AS SC7 ON " +CRLF
	clSql +=	"  D1_FORNECE=C7_FORNECE " +CRLF
	clSql +=	"  AND D1_COD=C7_PRODUTO " +CRLF
	clSql +=	"  AND D1_PEDIDO=C7_NUM  " +CRLF
	clSql +=	"  AND D1_ITEMPC=C7_ITEM " +CRLF
	clSql += " INNER JOIN "+ RetSqlName("SF4") +" AS SF4 ON   " +CRLF
	clSql += "  D1_FILIAL=F4_FILIAL   " +CRLF
	clSql +=	"  AND D1_TES=F4_CODIGO  " +CRLF
	clSql += " WHERE SD1.D_E_L_E_T_ ='' " +CRLF
	clSql +=	"  AND SC7.D_E_L_E_T_=''   " +CRLF
	clSql +=	"  AND D1_FILIAL='" + SF1->F1_FILIAL + "'   " +CRLF
	clSql +=	"  AND D1_DOC='" + SF1->F1_DOC + "'			" +CRLF
	clSql +=	"  AND D1_SERIE='" + SF1->F1_SERIE  + "'  	" +CRLF
	clSql +=	"  AND D1_FORNECE='" + SF1->F1_FORNECE + "' " +CRLF
	clSql +=	"  AND D1_LOJA='" + SF1->F1_LOJA + "' 		" +CRLF
	clSql +=	"  AND D1_DTDIGIT='" + Dtos(SF1->F1_DTDIGIT) + "' " +CRLF
	clSql +=	"  AND D1_TIPO='" + SF1->F1_TIPO + "'		" +CRLF
	
	If Select("BLQFIN") > 0 
		dbSelectArea("BLQFIN") 
		DbCloseArea() 
	EndIf

  	/*----------------------------------| 		    			           
	|   Cria a query e dar um apelido 	|
	|----------------------------------*/ 
	
	MemoWrite("BlqFin.SQL",clSql)					
	dbUseArea(.T.,"TopConn",TcGenQry(,,clSql),"BLQFIN",.F.,.T.)
	clChave	  := (SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_TIPO)
				  
        DbSelectArea("BLQFIN")
        dbGotop()
                
	Do While BLQFIN->(!Eof())
	
		If !BLQFIN->D1_TES  $  cTesPcNf 
			//If BLQFIN->(F4_XBLQFIN)=='S'
				clEstoque := BLQFIN->F4_ESTOQUE
				
				/*---------------------------------------------------------------------|
				| avalia se a divergência entre a nota fiscal e o pedido de compra	   |
				|---------------------------------------------------------------------*/
				
		    	If  (((BLQFIN->(D1_QUANT - C7_QUANT) / BLQFIN->C7_QUANT) * 100) > GetMv("MV_XDIVNF1"))    
		    		llFlag		:=.F. 
		    		clblqQtde	:= .F.
					GravLZ4(clChave,BLQFIN->D1_PEDIDO,BLQFIN->D1_FORNECE,BLQFIN->D1_LOJA,"2",BLQFIN->D1_COD,Transform(BLQFIN->C7_QUANT,"@E 999,999.9999"),Transform(BLQFIN->D1_QUANT,"@E 999,999.9999"),"quantidade",BLQFIN->D1_ITEM,0)
				EndIf
				
				/*-------------------------------------------------------------------------------------|
				| avalia se a divergência entre o preço unitário do item na nota e do pedido de compra |
				|-------------------------------------------------------------------------------------*/ 
				
		    	If  ((( (Round(BLQFIN->PRCUNIT,2) - Round(BLQFIN->C7_PRECO,2)) / Round(BLQFIN->C7_PRECO,2)) * 100) > GetMv("MV_XDIVPC"))
			    	llFlag	:=.F. 
		    		GravLZ4(clChave,BLQFIN->D1_PEDIDO,BLQFIN->D1_FORNECE,BLQFIN->D1_LOJA,"1",BLQFIN->D1_COD,Transform(Round(BLQFIN->C7_PRECO,2),"@E 999,999.9999"),Transform(Round(BLQFIN->PRCUNIT,2),"@E 999,999.9999"),"Preco Unitario",BLQFIN->D1_ITEM,(BLQFIN->D1_XCLASPN * (Round(BLQFIN->PRCUNIT,2) - Round(BLQFIN->C7_PRECO,2))))
		    	EndIf
		    	
		  		/*-------------------------------------------------------------------------------------|
				| avalia se a divergência entre a condição de pagamento da nota e do pedido de compra  |
				|-------------------------------------------------------------------------------------*/ 
		    	
		    	If ctrl ==.T.
			    	If  ccondicao <> BLQFIN->C7_COND 
			    		llFlag	:=.F.
			    		ctrl :=.F.           
						GravLZ4(clChave,BLQFIN->D1_PEDIDO,BLQFIN->D1_FORNECE,BLQFIN->D1_LOJA,"3","XXXXXXX",BLQFIN->C7_COND,ccondicao,"Condição de Pgto","XXXX",0)
					EndIf
				endif
				
				/*------------------------------------------------------------------------|
				| Avalia a divergênci entre a quantidade da nota e a quantidade entregue  |
				|------------------------------------------------------------------------*/
				If clEstoque=='S'
			    	If  ((BLQFIN->(D1_QUANT - D1_XCLASPN ) / BLQFIN->D1_QUANT )* 100) > GetMv("MV_XDIVNF2").Or. ;
			    	((BLQFIN->(D1_QUANT - D1_XCLASPN ) / BLQFIN->D1_QUANT )* 100) < - GetMv("MV_XDIVNF3")
			    		llFlag	:=.F.
			    		clBlqConSega:= .F.		
			    		GravLZ4(clChave,BLQFIN->D1_PEDIDO,BLQFIN->D1_FORNECE,BLQFIN->D1_LOJA,"4",BLQFIN->D1_COD,Transform(BLQFIN->D1_QUANT,"@E 999,999.9999"),Transform(BLQFIN->D1_XCLASPN,"@E 999,999.9999"),"Conferencia Cega",BLQFIN->D1_ITEM,BLQFIN->(D1_QUANT - D1_XCLASPN )* BLQFIN->D1_VUNIT)
			    	EndIf
				EndIf
			//EndIf 
		EndIf
		nlTotNot := nlTotNot  + BLQFIN->D1_TOTAL
		nlTotComp:= nlTotComp + BLQFIN->(C7_PRECO * D1_QUANT)
		nlTotDesc:= nlTotDesc + BLQFIN->D1_VALDESC
		BLQFIN->(DbSkip())
    EndDo
    	    			   	 		
	clFornece:= SF1->F1_FORNECE
	clLoja	 := SF1->F1_LOJA
	clDoc	 := SF1->F1_DOC
	clSeri	 := SF1->F1_SERIE
	cltipo	 := SF1->F1_TIPO
	clFilial := SF1->F1_FILIAL
	
	/*-------------------------------------------------------------------------------------|
	|se houver qualquer tipo de divergência o título principal será bloqueado e somente os |
	|de impostos serão desbloqueados.													   |	  
	|-------------------------------------------------------------------------------------*/
	If  llFlag==.F.
		DbSelectArea("SF1")
		If  RecLock("SF1",.F.)
				Replace SF1->F1_XSTDIV With "B"
				Replace SF1->F1_XESTSIM With clEstoque // define se alimenta estoque					
			MsUnLock()
		EndIf 					
		Aviso("Mensagem"," Nota " + SF1->F1_DOC + "  -  " + SF1->F1_SERIE + "  Apresenta divergência acima do permitido, o seu pagamento será bloqueado. ",{"OK"},2)				
		SE2->E2_XCHNFE 	:=   clChave
		Begin Transaction
			cQuery :="  UPDATE "+RetSqlName("SE2") +" "+CRLF
			cQuery +="  SET 	E2_DATALIB = '"+DTOS(DDATABASE)+"',E2_USUALIB='"+CUSERNAME+"', "+CRLF  
			cQuery +="  		E2_XCHNFE = '"+ clChave +"' 	 "+CRLF
			cQuery +="  WHERE E2_MSFIL='"+clFilial+"' 			 "+CRLF
			cQuery +="  		AND E2_FORORI  = '"+clFornece+"' "+CRLF
			cQuery +="  		AND E2_LOJORI  = '"+clLoja+"' 	 "+CRLF
			cQuery +="  		AND E2_NUM   	= '"+clDoc+"' 	 "+CRLF
			cQuery +="  		AND D_E_L_E_T_ <> '*' 			 "+CRLF
			clsql:=	TcSqlExec(cQuery)
		End Transaction
		
		/*---------------------------------------------------------------------------------------------|
		| somente irá executar este trecho de código se o Bloqueio foi somente por divergência de Preço|
		|---------------------------------------------------------------------------------------------*/
		
		If clblqQtde == .T. .And. clBlqConSega = .T. .And. ctrl ==.T.
		   
		/*----------------------------------------------------------------------------------------------|
		| Se a divergência foi apenas por preço unitário será comparado o total da nota menos o desconto|
		| com o total do pedido de compra e se for menor o Igual chamará a função de desbloqueio.		|
		|----------------------------------------------------------------------------------------------*/										
			If (nlTotNot - nlTotDesc) <= nlTotComp
				U_TTBLQ001(clFilial,clDoc,clSeri,clFornece,clLoja,cltipo,"L","","","",0)
				DbSelectArea("SF1")
				RecLock("SF1",.F.)
					Replace SF1->F1_XSTDIV With "L"
					Replace SF1->F1_XESTSIM With clEstoque
				MsUnLock() 	
			EndIf
		EndIf
					
	/*----------------------------------------------------------------------------------------------|
	| 	  Se não houve nenhuma divergência todos os titulo referente a nota serão desbloqueados   	|		
	|----------------------------------------------------------------------------------------------*/
											
	ElseIf llFlag==.T.
		DbSelectArea("SF1") 
		If RecLock("SF1",.F.)
			Replace SF1->F1_XSTDIV With "V" // status da nota sem divergencia
			Replace SF1->F1_XESTSIM With clEstoque 
			MsUnLock()
		EndIf
		SE2->E2_DATALIB := dDataBase
		SE2->E2_USUALIB := cUsername
		SE2->E2_XCHNFE 	:= clChave						
		Begin Transaction			
			cQuery :="  UPDATE "+RetSqlName("SE2") +"			 "+CRLF
			cQuery +="  SET  E2_DATALIB = '"+DTOS(DDATABASE)+"',E2_USUALIB='"+CUSERNAME+"', "+CRLF
			cQuery +="  		E2_XCHNFE = '"+ clChave +"' 	 "+CRLF
			cQuery +="  WHERE E2_MSFIL='"+clFilial+"' 			 "+CRLF
			cQuery +="  		AND E2_FORORI  = '"+clFornece+"' "+CRLF
			cQuery +="  		AND E2_LOJORI  = '"+clLoja+"' 	 "+CRLF
			cQuery +="  		AND E2_NUM   	= '"+clDoc+"' 	 "+CRLF
			cQuery +="  		AND D_E_L_E_T_ <> '*' 			 "+CRLF				
			clsql :=	TcSqlExec(cQuery)				
		End Transaction
		Aviso("Menssagem","Nota classificada sem divergencia,Seu pagamento não foi bloqueado",{"OK"},1)
	EndIf
EndIf
clEstoque:=""
RestArea(aAreage2)
	 
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦GravLZ4()  ¦ Autor ¦ Ricardo Souza	    ¦ Data ¦26.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função que efetuará a gravação na tabela de Log     		  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras/TokeTake                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function GravLZ4(Chavenf,Pedido,Fornece,Loja,TipOp,CodProd,ValCor,ValInf,Obsrv,clItem,TotDiv) 
	DbSelectArea("SZ4")
	RecLock("SZ4",.T.)
		
		SZ4->Z4_FILIAL 	:= xFilial("SZ4")
		SZ4->Z4_CHAVENF := Chavenf
		SZ4->Z4_DATA 	:= dDatabase
		SZ4->Z4_HORA 	:= Time() 
		SZ4->Z4_USER 	:= cUserName
		SZ4->Z4_PEDIDO  := Pedido
		SZ4->Z4_FORNECE := Fornece
		SZ4->Z4_LOJA    := Loja		
		DbSelectArea("SA2")
		DbSetOrder(1)
		If DbSeek(Xfilial("SA2") + Fornece + Loja )
			SZ4->Z4_NOME := SA2->A2_NOME
		EndIf		
		SZ4->Z4_OPER	:= TipOp 
		SZ4->Z4_ITEM 	:= clItem
		SZ4->Z4_PRODUTO := CodProd		
	   	DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(Xfilial("SB1") + CodProd )
			SZ4->Z4_DESC := SB1->B1_DESC    
		EndIf
		SZ4->Z4_VLRCORR := ValCor
		SZ4->Z4_VLRINF  := ValInf
		SZ4->Z4_TOTDIV  := TotDiv
		SZ4->Z4_OBS     := Obsrv
		SZ4->Z4_STATUS  := "1"				
	MsUnLock()
	SZ4->(DbCommit())
Return
			