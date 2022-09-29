#INCLUDE 'PROTHEUS.CH'    
#INCLUDE "TOPCONN.CH" 

/*/
|---------------------------------------------------------------------------|
| Função =   ROMCARG() | Autor /Fabio  Sales    |    º Data =  15/02/10     |
|---------------------------------------------------------------------------|
| Descrição = RELATÓRIO ROMANEIO DE CARGA                                   |
|---------------------------------------------------------------------------|
| Uso       = Faturamento                                                   |
|---------------------------------------------------------------------------|
/*/

USER  Function ROMCARG( lNfSaida )

	//----------------------------------------------------------------------//
	//                        Declaracao de Variaveis                       //
	//----------------------------------------------------------------------//	

	Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
	Local titulo		:= "R O M A N E I O    D E    C A R G A"
	Local nlLin         := 80
	Local clPerg		:= "ROMCARG"
	Local Cabec1		:= ""
	LoCAL Cabec2        := ""
	Local imprime		:= .T.
	Local aOrd			:= {}
	Private lAbortPrint	:= .F.
	Private limite		:= 80
	Private tamanho		:= "M"
	Private nomeprog	:= "ROMCARG" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo		:= 18
	Private aReturn		:= { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey	:= 0
	Private m_pag		:= 01
	Private wnrel		:= "ROMCARG" // Coloque aqui o nome do arquivo usado para impressao em disco
	Default lNfSaida	:= .T.
	
		PutSx1(clPerg,"01","Romaneio  de?","","","mv_ch1","C",10,00,00,"G","","","","","mv_Par01","","","","","","","","","","","","","","","","",{"Digite o codigo do romaneio apartir"+ chr(13) + chr(10) + " se deseja imprimir"},{},{},"")
		PutSx1(clPerg,"02","Romaneio Ate","","","mv_ch2","C",10,00,00,"G","","","","","mv_Par02","","","","","","","","","","","","","","","","",{"Digite o codigo do romaneio ate onde "+ chr(13) + chr(10) + "se deseja imprimir"},{},{},"")
		PutSx1(clPerg,"07","Data de ?","","","mv_ch3","D",08,00,00,"G","","","","","mv_Par03","","","","","","","","","","","","","","","","",{"Informe a data final"+ chr(13) + chr(10) + " para impressão"},{},{},"")
		PutSx1(clPerg,"08","'Data Ate?","","","mv_ch4","D",08,00,00,"G","","","","","mv_Par04","","","","","","","","","","","","","","","","",{"Informe a data final "+ chr(13) + chr(10) + "para impressão"},{},{},"")
	   	
	//----------------------------------------------------------------------//
	//                 Monta a interface padrao com o usuario...            //
	//----------------------------------------------------------------------//	
	
   	If !Pergunte(clPerg,.T.)
  		Return
 	Else    
	 	While (mv_par01 > mv_par02) .or. (mv_par03 > mv_par04)  	
	   		If (mv_par03 > mv_par04)
	   			AVISO("MENSAGEM","O parametro Data esta em ordem Incorreta. 'Data de?' deve conter Data menor ou igual a 'Data ate?'.  ",{"OK",1})
			ElseIf(mv_par01 > mv_par02)
				AVISO("MENSAGEM","O parametro Romaneio esta em ordem Incorreta.'Romaneio de ?' deve conter codigo menor ou igual a 'Romaneio ate Ate?'.  ",{"OK",1})
		 	EndIf
		   	If !Pergunte(clPerg,.T.)
			 	Return
			EndIf
		EndDo  
	EndIf 
	wnrel := SetPrint("SF2",NomeProg,,@titulo,cDesc1,cDesc2,"",.T.,aOrd,.T.,Tamanho)
	
	If nLastKey == 27
		Return
	Endif                            
	
	SetDefault(aReturn,"")
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//----------------------------------------------------------------------//
	// Processamento. RPTSTATUS monta janela com a regua de processamento.  //
	//----------------------------------------------------------------------//	
	RptStatus( {|| RunReport( Cabec1,Cabec2,Titulo,nlLin,lNfSaida) },Titulo )
	
Return()

/*/
|---------------------------------------------------------------------------|
|ºFunção =   RUNREPORT | Autor /Fabio  Sales    |    º Data =  15/02/10     |
|---------------------------------------------------------------------------|
|ºDescrição = Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS    |
|          	  monta a janela com a regua de processamento.                  |
|---------------------------------------------------------------------------|
| Uso       = Faturamento                                                   |
|---------------------------------------------------------------------------|
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nlLin,lNfSaida)
	Local clRoman
	Local nlLpag
	Local clNota
	Local clSerie
	Local cQuery
	Local _cdata	:= substr(dtoc(DATE()),1,2)+" de "+MesExtenso(Month(DATE())) + " de " + Str(Year(DATE()), 4)
	Local alRnota	:={} 
	
	//----------------------------------------------------------------------//
	// SETREGUA -> Indica quantos registros serao processados para a regua  //
	//----------------------------------------------------------------------//
	
	SetRegua(RecCount())
	
	//query para extração de dados do romaneio//
	
	If lNfSaida
	
		cQuery:="	SELECT		F2_FILIAL,F2_DOC DOC,F2_SERIE SERIE,F2_XCARGA CARGA,F2_XMOTOR,F2_XPLACA,F2_TRANSP,D2_COD PRODUTO,D2_UM UM,D2_PESO PESO,F2_EMISSAO,D2_ITEM,F2_TRANSP,SUM(D2_QUANT) AS QUANT	" 
		cQuery+="	FROM		"+RetSQLName("SF2")+" SF2, "+RetSQLName("SD2")+" SD2							"                             
		cQuery+="	WHERE		F2_FILIAL   ='"+xFilial("SF2")+"'												"	
		cQuery+="			AND	D2_FILIAL   ='"+xFilial("SD2")+"'												" 
		cQuery+="			AND F2_XCARGA	BETWEEN '"+MV_PAR01+"'			AND '"+MV_PAR02+"'					" 
		cQuery+="			AND D2_EMISSAO	BETWEEN '"+DTOS(MV_PAR03)+"'	AND '"+DTOS(MV_PAR04)+"'			"
		cQuery+="			AND D2_FILIAL=F2_FILIAL																"
		cQuery+="			AND D2_DOC=F2_DOC																	"
		cQuery+="			AND D2_SERIE=F2_SERIE																"
		cQuery+="			AND D2_CLIENTE=F2_CLIENTE															"
		cQuery+="			AND D2_LOJA=F2_LOJA																	"
		cQuery+="			AND D2_EMISSAO=F2_EMISSAO															"
		cQuery+="			AND F2_XCARGA<>''															   		"
		cQuery+="			AND SF2.D_E_L_E_T_=' '																"  
		cQuery+="			AND SD2.D_E_L_E_T_=' '																"
		cQuery+="	GROUP BY	F2_FILIAL,F2_DOC,F2_SERIE,F2_XCARGA,F2_XMOTOR,F2_XPLACA,F2_TRANSP,D2_COD,D2_UM,D2_PESO,F2_EMISSAO,D2_ITEM,F2_TRANSP " 
		cQuery+="	ORDER BY	F2_XCARGA,D2_COD                                                                " 
				
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'CAR',.T.,.T.)
		        
		TcSetField("CAR","F2_EMISSAO","D",8)
		TcSetField("CAR","D2_QUANT","N",14,2)
		TcSetField("CAR","D2_PESO","N",14,3)
	
	// nota devolucao
	Else
	
		cQuery:="	SELECT		F1_FILIAL,F1_DOC DOC,F1_SERIE SERIE,F1_XCARGA CARGA,F1_XMOTOR,F1_XPLACA,F1_TRANSP,D1_COD PRODUTO,D1_UM UM,D1_PESO PESO,F1_EMISSAO,D1_ITEM,F1_TRANSP,SUM(D1_QUANT) AS QUANT	" 
		cQuery+="	FROM		"+RetSQLName("SF1")+" SF1, "+RetSQLName("SD1")+" SD1							"                             
		cQuery+="	WHERE		F1_FILIAL   ='"+xFilial("SF1")+"'												"	
		cQuery+="			AND	D1_FILIAL   ='"+xFilial("SD1")+"'												" 
		cQuery+="			AND F1_XCARGA	BETWEEN '"+MV_PAR01+"'			AND '"+MV_PAR02+"'					" 
		cQuery+="			AND D1_EMISSAO	BETWEEN '"+DTOS(MV_PAR03)+"'	AND '"+DTOS(MV_PAR04)+"'			"
		cQuery+="			AND D1_FILIAL=F1_FILIAL																"
		cQuery+="			AND D1_DOC=F1_DOC																	"
		cQuery+="			AND D1_SERIE=F1_SERIE																"
		cQuery+="			AND D1_FORNECE=F1_FORNECE															"
		cQuery+="			AND D1_LOJA=F1_LOJA																	"
		cQuery+="			AND D1_EMISSAO=F1_EMISSAO															"
		cQuery+="			AND F1_XCARGA<>''															   		"
		cQuery+="			AND SF1.D_E_L_E_T_=' '																"  
		cQuery+="			AND SD1.D_E_L_E_T_=' '																"
		cQuery+="	GROUP BY	F1_FILIAL,F1_DOC,F1_SERIE,F1_XCARGA,F1_XMOTOR,F1_XPLACA,F1_TRANSP,D1_COD,D1_UM,D1_PESO,F1_EMISSAO,D1_ITEM,F1_TRANSP " 
		cQuery+="	ORDER BY	F1_XCARGA,D1_COD                                                                " 
				
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'CAR',.T.,.T.)
		        
		TcSetField("CAR","F1_EMISSAO","D",8)
		TcSetField("CAR","D1_QUANT","N",14,2)
		TcSetField("CAR","D1_PESO","N",14,3)     
	
	EndIf	
	
	
	   //----------------------------------------------------------------------//
	   //				³ Verifica o cancelamento pelo usuario...              //
	   //----------------------------------------------------------------------//
		  
	CAR->(dbGoTOp())
 	While CAR->(!EOF())
 	
 		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)	
	 	nlLin := 08
	 	nlPag:=1
	 
		If lAbortPrint
			@nlLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		 	exit
		Endif
		
		cNumCarg := CAR->CARGA 
		 
		@ nlLin++,00 PSAY	"NUM_ROMANEIO: " 	+cNumCarg 
		@ nlLin++,00 PSAY	"DATA DA GERACAO:" 	+IIF( _lNfSaida,DTOC(CAR->F2_EMISSAO),DTOC(CAR->F1_EMISSAO) )  
		@ nlLin++,00 PSAY	"MOTORISTA:" +IIF( _lNfSaida,CAR->F2_XMOTOR,CAR->F1_XMOTOR)   + " PLACA DO CARRO: " +  IIF( _lNfSaida,CAR->F2_XPLACA,CAR->F1_XPLACA ) 
		@ nlLin++,00 PSAY	"TRANSPORTADORA: " +IIF( _lNfSaida,CAR->F2_TRANSP ,CAR->F1_TRANSP  )+ "-" + IIF( _lNfSaida,GETADVFVAL("SA4","A4_NREDUZ",XFILIAL("SA4")+CAR->F2_TRANSP,1) ,GETADVFVAL("SA4","A4_NREDUZ",XFILIAL("SA4")+CAR->F1_TRANSP,1)  )    
		@ nlLin++,00 PSAY	__PrtFatLine()
		@ nlLin++,00 PSAY	"|COD_PRODUTO"+SPACE(6)+"|PRODUTO"+SPACE(23)+"|UNID_MEDIDA"+SPACE(3)+"|QUANTIDADE    |SEG_UND_MED"+SPACE(3)+"|QTD SEGUNDA   |"+SPACE(3)+"QUANT_ITEM |PESO_BRUTO |  CUBAGEM"
		@ nlLin,000 PSAY __PrtThinLine()
		nlLin++
	   
		clRoman := cNumCarg
	
		  
		WHILE CAR->CARGA == clRoman
			
			@ nlLin,01 PSAY	CAR->PRODUTO	//CAR->D2_COD 
	    	
       		DBSELECTAREA("SB1")                                 
			DBSETORDER(1)
		  
			IF DBSEEK(XFILIAL("SB1")+CAR->PRODUTO)
				@ nlLin,19 PSAY  SB1->B1_DESC 
			ENDIF
		
			@ nlLin,52 PSAY	 CAR->UM 
			nPeso := CAR->PESO	//CAR->D2_PESO
			_nQtdPro := 0 
			_nItens  := 0
			_cProd   := CAR->PRODUTO	//CAR->D2_COD
			
			DBSELECTAREA("CAR")                                 
			While ! Eof() .AND. CAR->CARGA == clRoman .AND.  CAR->PRODUTO == _cProd
				_nQtdPro := _nQtdPro + CAR->QUANT	//CAR->D2_QUANT
				_nItens++
				clNota := CAR->DOC	//CAR->F2_DOC
				clSerie:= CAR->SERIE	//CAR->F2_SERIE
				
				nlNota  := AScan(alRnota,{|aX| aX[1] == Trim(clNota)})
				nlSerie := AScan(alRnota,{|aX| aX[2] == Trim(clSerie)})    
		    	If 	nlNota <=0 .and. nlSerie<=0
		       		AADD(alRnota,{clNota,clSerie})                                      
		    	Endif
				Dbskip()
			Enddo
			_nPeso:=nPeso * _nQtdPro
			                      
			@ nlLin,64 PSAY	 Transform(_nQtdPro,"@E 999,999.99")
			@ nlLin,85 PSAY	 Transform(_nItens,"@E 999")
			@ nlLin,95 PSAY  Transform(_nPeso,"@E 999,999.999")												
			nlLin++
			_nPeso	 := 0
		
			if nlLin > 54
				@ 63,000 PSAY __PrtThinLine()
				@ 64,00 PSAY ""+ SPACE(50)+" | CONTINUA NA OUTRA PAGINA  |"
				@ 65,00 PSAY __PrtThinLine()
				@ 66,60 PSAY "PÁGINA--> "+ alltrim(str(nlPag))
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)	
				nlPag++
				nlLin:=8
			Endif
		ENDDO
		@ nlLin++,00 PSAY __PrtThinLine()
		@ nlLin++,45 PSAY "RELAÇÃO DE NOTAS DO ROMANEIO(NOTA / SERIE)"
		@ nlLin++,00 PSAY __PrtThinLine()
		_nlCol:=0
		For nI := 1 to Len(alRnota)
			IF NI > 1
				@nlLin,_nlCol PSAY ","
				_nlCol:=_nlCol + 1
			ENDIF
			@nlLin,_nlCol PSAY alRnota[nI][1]
			_nlCol:=_nlCol + 10
			@nlLin,_nlCol PSAY "/"
			_nlCol:=_nlCol + 2
			@nlLin,_nlCol PSAY alRnota[nI][2]
			_nlCol:=_nlCol + 6 
			if _nlCol > 95
				nlLin++
				_nlCol:=0
			Endif					   
		Next nI
		alRnota:={}
		nlLin:=55
		@ nlLin++,000 PSAY __PrtThinLine()
		@ nlLin++,39 PSAY "CONFIRMA O EMBARQUE DA MERCADORIA ACIMA RELACIONADA"
		@ nlLin++,38 PSAY Replicate("=",53)
		@ nlLin++,38 PSAY "DATA   ->"+" "+_cdata +space(3)+"HORA  =>"+" "+Time()
		@ nlLin++,38 PSAY REPLICATE("=",53)
		nlLin:=nlLin + 2  
		@ nlLin++,00 PSAY SPACE(02)+REPLICATE("_",40)+SPACE(5)+REPLICATE("_",40)+SPACE(5)+REPLICATE("_",40)
		@ nlLin++,00 PSAY SPACE(17)+ "SEPARADOR"+SPACE(36)+"CONFERENTE"+SPACE(35)+"RESPONSÁVEL"          
		@ nlLin++,00 PSAY __PrtThinLine()		 
	  	@ nlLin,60 PSAY "PÁGINA--> "+ alltrim(str(nlPag)) //Imprimi o número da página
	  
	ENDDO
	//----------------------------------------------------------------------//
	//                 Finaliza a execucao do relatorio...                  //
	//----------------------------------------------------------------------//
	
	SET DEVICE TO SCREEN
	
	//----------------------------------------------------------------------//
	// Se impressao em disco, chama o gerenciador de impressao...           //
	//----------------------------------------------------------------------//
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	CAR->(dbCloseArea())
Return  