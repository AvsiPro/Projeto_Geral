
/*--------------------------|
|BIBLIOTECAS DE FUNÇÕES		|
|--------------------------*/  
 #INCLUDE "RWMAKE.CH"      // 
 #INCLUDE "TOPCONN.CH"     //
/*-------------------------*/

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTCOMR05() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦18.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ CONTROLE DE ALÇADA								          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦COMPRAS	                                             	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTCOMR05()
	Local oReport
	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO PRINCIPAL D EIMPRESSÀO   							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ COMPRAS                                               	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "ALCADA"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("ALCADA","RELATORIO DE PEDIDOS DE ALCADAS","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRAR TODOS OS PEDIDOS CO ALCADAS")
	
	/*-------------------------| 		    			           
	| seção dos titulo a pagar | 
	|-------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("PEDIDOS DE ALCADAS"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/ 
		
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL	"			,"@!"			,02)
	TRCell():New(oSection1,"NUM"		,"TRB","NUMERO_PEDIDO"		,"@!"			,06)
	TRCell():New(oSection1,"FORNECE"	,"TRB","FORNECEDOR	"		,"@!"			,06)
	TRCell():New(oSection1,"NOME"		,"TRB","FORNECEDOR	"		,"@!"			,40)				
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA		"		,"@!"			,04)
	TRCell():New(oSection1,"PRODUTO"	,"TRB","PRODUTO	"			,"@!"			,15)
	TRCell():New(oSection1,"DESC"		,"TRB","DESC_PROD	"		,"@!"			,30)	
	TRCell():New(oSection1,"QUANT"		,"TRB","QUANTIDADE	"		,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"QUJE"		,"TRB","QTDE_ENTREGUE	"	,"@E 999,999,999.99",14)	
	TRCell():New(oSection1,"SALDOS"		,"TRB","SALDO_PED	"		,"@E 999,999,999.99",14)		
	TRCell():New(oSection1,"PRECO"		,"TRB","PREÇO_UNITARIO"		,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"TOTAL"		,"TRB","TOTAL_PED	"		,"@E 999,999,999.99",14)	
	TRCell():New(oSection1,"TOT_ENT"	,"TRB","TOTAL_ENTREGUE"		,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"TOT_SALDO"	,"TRB","TOTAL_SALDO		"	,"@E 999,999,999.99",14) 	
	TRCell():New(oSection1,"TOTAL_R"	,"TRB","TOTAL_REAL		"	,"@E 999,999,999.99",14)	
	TRCell():New(oSection1,"RESIDUO"	,"TRB","RESIDUO_ELIMINADO"	,"@!"			,10)		
	TRCell():New(oSection1,"LIBAPRO"	,"TRB","COD_APROVADOR	"	,"@!"			,10)
	TRCell():New(oSection1,"NIVEL"   	,"TRB","NIVEL_APROVADOR"	,"@!"			,10)
	TRCell():New(oSection1,"NOMEAP"		,"TRB","NOME_APROVADOR"		,"@!"			,35)	
	
	TRCell():New(oSection1,"LIBAPRO2"	,"TRB","COD_APROVADOR2	"	,"@!"			,10)
	TRCell():New(oSection1,"NIVEL2"   	,"TRB","NIVEL_APROVADOR2"	,"@!"			,10)
	TRCell():New(oSection1,"NOME2"		,"TRB","NOME_APROVADOR2"	,"@!"			,35)
	
	TRCell():New(oSection1,"LIBAPRO3"	,"TRB","COD_APROVADOR3	"	,"@!"			,10)
	TRCell():New(oSection1,"NIVEL3"   	,"TRB","NIVEL_APROVADOR3"	,"@!"			,10)
	TRCell():New(oSection1,"NOME3"		,"TRB","NOME_APROVADOR3"	,"@!"			,35)
	TRCell():New(oSection1,"USUINC"		,"TRB","COMPRADOR"			,"@!"			,35)	
				
	TRCell():New(oSection1,"DATAENT"	,"TRB","DT.ENTREGA"			,,08)	
	TRCell():New(oSection1,"DATALIB"	,"TRB","DATALIB	"			,,08)	  
	TRCell():New(oSection1,"VENCREAL"	,"TRB","VENC_REAL/PREVISTO"	,,08)	 	
			
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ FABIO SALES	    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO RESPONSÁVEL PELA IMPRESSÃO DO RELATÓRIO			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ COMPRAS                                               	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function PrintReport(oReport)
	    
	Local oSection1 := oReport:Section(1)
	
	/*-----------------------------------------------------------------| 		    			           
	| seleção dos dados a serem impressos/carrega o arquivo temporário | 
	|-----------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	
	/*-------------------------| 		    			           
	| imprime a primeira seção | 
	|-------------------------*/
	
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

	/*-----------------------------------------------------------| 		    			           
	| seleciona os dados a serem impressos/criacao do temporário | 
	|-----------------------------------------------------------*/ 

Static Function fSelDados()

	Local alParc 
	Local clvenclec
	Local clniv1
    Local clniv2
   	Local clped 
  	Local clFil  	
  	Local cCampo
	Local cUsuarioI
  	

	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {} 
				    
	AADD(_aStru,{"FILIAL"	,"C",02,0})
	AADD(_aStru,{"NUM"	,"C",06,0})
	AADD(_aStru,{"FORNECE"	,"C",06,0})			
	AADD(_aStru,{"NOME"	,"C",40,0})	
	AADD(_aStru,{"LOJA"		,"C",04,0})		
	AADD(_aStru,{"PRODUTO"	,"C",15,0})	
	AADD(_aStru,{"DESC"	,"C",30,0})	
	AADD(_aStru,{"QUANT"	,"N",14,2})
	AADD(_aStru,{"PRECO"	,"N",14,2})
	AADD(_aStru,{"TOTAL"	,"N",14,2})	
	AADD(_aStru,{"QUJE"	,"N",14,2})	
	AADD(_aStru,{"SALDOS"	,"N",14,2})	
	AADD(_aStru,{"TOT_ENT"	,"N",14,2})	
	AADD(_aStru,{"TOT_SALDO","N",14,2})		   	
	AADD(_aStru,{"TOTAL_R","N",14,2})
	AADD(_aStru,{"LIBAPRO"	,"C",10,0})	
	AADD(_aStru,{"NIVEL"	,"C",10,0})	   
	AADD(_aStru,{"NOMEAP","C",35,0})	
	AADD(_aStru,{"RESIDUO","C",05,0})
	AADD(_aStru,{"DATALIB"	,"D",8,0}) 
	AADD(_aStru,{"DATAENT"	,"D",8,0})
	AADD(_aStru,{"VENCREAL"	,"D",8,0})
	
	AADD(_aStru,{"NIVEL2"	,"C",10,0})	   
	AADD(_aStru,{"LIBAPRO2"	,"C",10,0})	
	AADD(_aStru,{"NOME2"	,"C",35,0})	
		
	AADD(_aStru,{"NIVEL3"	,"C",10,0})	   
	AADD(_aStru,{"LIBAPRO3"	,"C",10,0})	
	AADD(_aStru,{"NOME3"	,"C",35,0})
	AADD(_aStru,{"USUINC"	,"C",15,0})	
		
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"LIBAPRO",,,"Selecionando Registros...")
	                     
	/*-----------------------------------------------------| 		    			           
	| Montagem da query com os titulos a receber em aberto |
	|-----------------------------------------------------*/

	cQuery := " SELECT	CR_FILIAL,CR_NUM,CR_DATALIB,CR_LIBAPRO,AK_NOME,C7_PRODUTO,B1_DESC,C7_QUANT,C7_PRECO,C7_TOTAL,C7_FORNECE,C7_LOJA,A2_NOME,C7_RESIDUO, "
	cQuery += " CR_NIVEL,C7_COND,C7_DATPRF,C7_QUJE,(C7_QUANT-C7_QUJE) AS SALDO,(C7_QUJE * C7_PRECO ) AS TOT_ENT,((C7_QUANT-C7_QUJE)* C7_PRECO) AS TOT_SALDO, "
	cQuery += " 'TOTAL_REAL' = CASE WHEN C7_RESIDUO='S' THEN (C7_QUJE * C7_PRECO ) ELSE  C7_TOTAL END,C7_USERLGI "  
	cQuery += " FROM "+RetSqlName("SCR")+" SCR INNER JOIN "+RetSqlName("SAK")+" SAK ON CR_LIBAPRO=AK_COD INNER JOIN "
	cQuery += " "+RetSqlName("SC7")+" SC7 ON CR_FILIAL=C7_FILIAL AND CR_NUM=C7_NUM INNER JOIN "+RetSqlName("SB1")+" SB1  ON C7_PRODUTO=B1_COD "
	cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON C7_FORNECE=A2_COD AND C7_LOJA=A2_LOJA "
	cQuery += " WHERE 	CR_TIPO='PC' AND CR_LIBAPRO BETWEEN '"+mv_par01+"' AND '" + mv_par02 +"' AND "
	cQuery += " CR_DATALIB BETWEEN '"+ DTOS(mv_par03)+"' AND '" + DTOS(mv_par04) + "' AND "
	cQuery += " CR_FILIAL BETWEEN '"+ mv_par05 +"' AND '" + mv_par06 +"' AND SCR.D_E_L_E_T_='' "
	cQuery += " AND SAK.D_E_L_E_T_='' AND SC7.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' AND SA2.D_E_L_E_T_='' "
	cQuery += " ORDER BY CR_LIBAPRO "
	
	If Select("ALC") > 0
		dbSelectArea("ALC")
		DbCloseArea()
	EndIf								
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"ALC",.F.,.T.)
	
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/

	TcSetField("ALC","C7_QUANT 	","N",14,2)
	TcSetField("ALC","C7_PRECO 	","N",14,2)
	TcSetField("ALC","C7_TOTAL ","N",14,2)
	TcSetField("ALC","C7_QUJE","N",14,2)
	TcSetField("ALC","SALDO","N",14,2)	
	TcSetField("ALC","TOT_ENT","N",14,2)	
	TcSetField("ALC","TOT_SALDO","N",14,2)	
	TcSetField("ALC","CR_DATALIB","D",08,0)
	TcSetField("ALC","C7_DATPRF","D",08,0)
	TcSetField("ALC","TOTAL_REAL","N",14,2)
						
	dbSelectArea("ALC")
	dbGotop()
		
	While ALC->(!Eof())
	 
		alParc := CONDICAO(ALC->C7_TOTAL,ALC->C7_COND,,ALC->C7_DATPRF)
		clvenclec:=alParc[1,1]
		
				
		cCampo :="C7_USERLGI" 
		cUsuarioI := FWLeUserlg(cCampo)	
		
		/*----------------------------------------------------------------------------------------------------------------------------------------\
		| As linhas comentadas abaixo foram substituídas pelas duas linhas acima por motivo de mudanças na função de                              |
		| retorno do nome do usuário gravado no campo reservado XX_USERLGI.Post http://www.tdn.totvs.com/dosearchsite.action?queryString=embaralha|
		|-----------------------------------------------------------------------------------------------------------------------------------------|                                                                                                          |
		|cCampo :="ALC->C7_USERLGI"                             |
		|cUserLG :=Embaralha(&cCampo,1)                         |
		|cUsuarioI:= If(!Empty(cUserLg),Subs(cUserLg,1,15),"")  |
		\------------------------------------------------------*/
						
				     	      		       
	     DbSelectArea("TRB")
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/
	    RecLock("TRB",.T.) 	    	    
	     	TRB->FILIAL		:= ALC->CR_FILIAL	     	
	     	TRB->NUM		:= ALC->CR_NUM	     	
	     	TRB->FORNECE	:= ALC->C7_FORNECE	     	
	      	TRB->NOME		:= ALC->A2_NOME	      	
	      	TRB->LOJA		:= ALC->C7_LOJA
	      	TRB->PRODUTO	:= ALC->C7_PRODUTO
	        TRB->DESC		:= ALC->B1_DESC	        	        	        
	        TRB->QUANT		:= ALC->C7_QUANT
	        TRB->PRECO		:= ALC->C7_PRECO
	        TRB->TOTAL		:= ALC->C7_TOTAL	        
	        TRB->LIBAPRO	:= ALC->CR_LIBAPRO	        
	        TRB->NIVEL		:= ALC->CR_NIVEL	        	        	        
	        TRB->NOMEAP 	:= ALC->AK_NOME 
	        TRB->DATALIB	:= ALC->CR_DATALIB
	        TRB->DATAENT    := ALC->C7_DATPRF
	        TRB->VENCREAL	:= clvenclec	        	        
	        TRB->QUJE  		:= ALC->C7_QUJE
	        TRB->SALDOS		:= ALC->SALDO	 	        
	        TRB->TOT_ENT  	:= ALC->TOT_ENT
	        TRB->TOT_SALDO	:= ALC->TOT_SALDO
   	        TRB->RESIDUO	:= ALC->C7_RESIDUO 
   	        TRB->TOTAL_R	:= ALC->TOTAL_REAL
   	        TRB->USUINC		:= cUsuarioI
   	        clniv1:= ALC->CR_NIVEL 
   	        clped := ALC->CR_NUM
   	        clFil:= ALC->CR_FILIAL
   	        
   	        /*************************************************************************************************************************************\
   	        | 	    Query incluida no dia 19/10/2011 por Fabio Sales para puxar o outro nível de liberação de acordo com os parâmetro defidos      |
   	        \*************************************************************************************************************************************/

   	        
		 	cQuery1 := " SELECT TOP 1 CR_LIBAPRO,AK_NOME, CR_NIVEL "
			cQuery1 += " FROM "+RetSqlName("SCR")+" SCR INNER JOIN "+RetSqlName("SAK")+" SAK ON CR_FILIAL=AK_FILIAL AND CR_LIBAPRO=AK_COD WHERE "
			cQuery1 += " CR_FILIAL='" + clfil + "' AND CR_NUM='" + clped + "' AND CR_NIVEL<>'" + clniv1 + "' AND SCR.D_E_L_E_T_='' AND SAK.D_E_L_E_T_='' "  // alterado em 13/04/2012 por Fabio Sales para não considerar os aprovadores deletados
					
			If Select("ALC1") > 0
				dbSelectArea("ALC1")
				DbCloseArea()
			EndIf								
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"ALC1",.F.,.T.)
   	        dbSelectArea("ALC1")
   	        If ALC1->(!Eof())
	   	        TRB->NIVEL2		:= ALC1->CR_NIVEL	   	       
		       	TRB->LIBAPRO2	:= ALC1->CR_LIBAPRO
		       	TRB->NOME2		:= ALC1->AK_NOME
		 	Else 
		 		TRB->NIVEL2		:= ''
		       	TRB->LIBAPRO2	:= ''
		       	TRB->NOME2		:= ''
		    EndIf
		    
   	        clniv2:= ALC1->CR_NIVEL 
   	        
   	        cQuery2 := " SELECT TOP 1 CR_LIBAPRO,AK_NOME, CR_NIVEL "			
			cQuery2 += " FROM "+RetSqlName("SCR")+" SCR INNER JOIN "+RetSqlName("SAK")+" SAK ON CR_FILIAL=AK_FILIAL AND CR_LIBAPRO=AK_COD WHERE CR_FILIAL='" + clfil + "' "
			cQuery2 += " AND CR_NUM='" + clped + "' AND CR_NIVEL<>'" + clniv1 + "' AND CR_NIVEL<>'" + clniv2 + "' AND SCR.D_E_L_E_T_='' AND SAK.D_E_L_E_T_='' " // alterado em 13/04/2012 por Fabio Sales para não considerar os aprovadores deletados
   	         
   			If Select("ALC2") > 0
				dbSelectArea("ALC2")
				DbCloseArea()
			EndIf								
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"ALC2",.F.,.T.)
   	        dbSelectArea("ALC2")
   	        If ALC2->(!Eof())
	   	        TRB->NIVEL3		:= ALC2->CR_NIVEL	   	       
		       	TRB->LIBAPRO3	:= ALC2->CR_LIBAPRO
		       	TRB->NOME3		:= ALC2->AK_NOME
		 	Else 
		 		TRB->NIVEL3		:= ''
		       	TRB->LIBAPRO3	:= ''
		       	TRB->NOME3	:= ''
		    EndIf
		    clniv1	:= ''
		    clniv2	:=''
   	        clped 	:= ''
   	        clFil	:= ''
	      MsUnlock()
	      	      
	      cCampo 	:=""
		  cUserLG 	:=""
		  cUsuarioI	:=""
	    	      
	      dbSelectArea("ALC")
	      ALC->(DbSkip())
	Enddo
	
	If Select("ALC") > 0
		dbSelectArea("ALC")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg) 

	PutSx1(cPerg,'01','Aprovador de      ?','','','mv_ch1','C',06,0,0,'G','','SAK','','','mv_par01',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'02','Aprovador ate     ?','','','mv_ch2','C',06,0,0,'G','','SAK','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Liberação de      ?','','','mv_ch3','D',08,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Liberação ate     ?','','','mv_ch4','D',08,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Filial de      	?','','','mv_ch5','C',02,0,0,'G','','SM0','','','mv_par05',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'06','Filial ate     	?','','','mv_ch6','C',02,0,0,'G','','SM0','','','mv_par06',,,'','','','','','','','','','','','','','')
		
Return
