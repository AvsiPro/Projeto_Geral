#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOPCONN.CH"

/*/
|---------------------------------------------------------------------------|
| Função =   ROMNOT() | Autor /Fabio  Sales    |    º Data =  15/02/10      |
|---------------------------------------------------------------------------|
| Descrição = RELATÓRIO ROMANEIO POR NOTA                                   |
|---------------------------------------------------------------------------|
| Historico	| Autor Jackson E. de Deus	  Data	  07/03/13					|
	| 			Alterado pois o salto de página estava errado.				|
|---------------------------------------------------------------------------|
| Uso       = Faturamento                                                   |
|---------------------------------------------------------------------------|
/*/

User Function ROMNOT( lNfSaida )
//----------------------------------------------------------------------//
//                        Declaracao de Variaveis                       //
//----------------------------------------------------------------------//

Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local titulo		:= "R O M A N E I O   P O R   N O T A "
Local nlLin         := 80
Local clPerg		:= "ROMNOT"
Local Cabec1		:= ""
Local Cabec2		:= ""
Local imprime		:= .T.
Local aOrd			:= {}
Local _cPa			:= ""
Local _endent		:= ""
Private lAbortPrint	:= .F.
Private limite		:= 80
Private tamanho		:= "M"
Private nomeprog	:= "ROMNOT" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo		:= 18
Private aReturn		:= { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
Private nLastKey	:= 0
Private m_pag		:= 01
Private wnrel		:= "ROMNOT" // Coloque aqui o nome do arquivo usado para impressao em disco
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
			AVISO("MENSSAGEM","O parametro Data esta em ordem Incorreta. 'Data de?' deve conter Data menor ou igual a 'Data ate?'.  ",{"OK",1})
		ElseIf(mv_par01 > mv_par02)
			AVISO("MENSSAGEM","O parametro Romaneio esta em ordem Incorreta.'Romaneio de ?' deve conter codigo menor ou igual a 'Romaneio ate Ate?'.  ",{"OK",1})
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
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nlLin,lNfSaida) },Titulo)
Return

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
Local clNota
Local clSerie
Local cQuery
Local _cdata	:= substr(dtoc(DATE()),1,2)+" de "+MesExtenso(Month(DATE())) + " de " + Str(Year(DATE()), 4)
Local clPag
Local cNomeEnt := ""
Local cEnd := ""
Local cBairro := ""
Local cMun := ""
Local cUF := ""
Local cCep := ""
Local cCodPa := ""

//----------------------------------------------------------------------//
// SETREGUA -> Indica quantos registros serao processados para a regua  //
//----------------------------------------------------------------------//

SetRegua(RecCount())
//query para extração de dados do romaneio//
If lNfSaida
	cQuery:="	SELECT		F2_FILIAL,F2_DOC DOC,F2_SERIE SERIE,F2_XCARGA CARGA,F2_XMOTOR,F2_CLIENTE CLIENTE,F2_LOJA,F2_XPLACA,F2_TRANSP,D2_COD PRODUTO,D2_UM UM,D2_PESO PESO,F2_EMISSAO,D2_QUANT QUANT,D2_PEDIDO PEDIDO,F2_TRANSP	"
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
	cQuery+="	ORDER BY	F2_XCARGA,F2_DOC " 
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'ROMN',.T.,.T.)
	
	TcSetField("ROMN","F2_EMISSAO","D",8)
	TcSetField("ROMN","D2_QUANT","N",14,2)
	TcSetField("ROMN","D2_PESO","N",14,3)

// nota devolucao	
Else

	cQuery:="	SELECT		F1_FILIAL,F1_DOC DOC,F1_SERIE SERIE,F1_XCARGA CARGA,F1_XMOTOR,F1_FORNECE CLIENTE,F1_LOJA,F1_XPLACA,F1_TRANSP,D1_COD PRODUTO,D1_UM UM,D1_PESO PESO,F1_EMISSAO,D1_QUANT QUANT,D1_PEDIDO PEDIDO,F1_TRANSP, D1_NFORI,D1_SERIORI	"
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
	cQuery+="	ORDER BY	F1_XCARGA,F1_DOC " 
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'ROMN',.T.,.T.)
	
	TcSetField("ROMN","F1_EMISSAO","D",8)
	TcSetField("ROMN","D1_QUANT","N",14,2)
	TcSetField("ROMN","D1_PESO","N",14,3)

EndIf
	
//----------------------------------------------------------------------//
//				³ Verifica o cancelamento pelo usuario...              //
//----------------------------------------------------------------------//

ROMN->(dbGoTOp())
While ROMN->(!EOF())
	
	nlPag:=1
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
	nlLin := 8
	
	If lAbortPrint
		@nlLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		exit
	Endif
	
	clRoman := ROMN->CARGA
	 
	@ nlLin++,00 PSAY	"NUM_ROMANEIO: " 	+ROMN->CARGA
	@ nlLin++,00 PSAY	"DATA DA GERACAO:" 	+IIF( _lNfSaida,DTOC(ROMN->F2_EMISSAO),DTOC(ROMN->F1_EMISSAO) ) 
	@ nlLin++,00 PSAY	"MOTORISTA:" +IIF( _lNfSaida,ROMN->F2_XMOTOR,ROMN->F1_XMOTOR)   + " PLACA DO CARRO: " +  IIF( _lNfSaida,ROMN->F2_XPLACA,ROMN->F1_XPLACA ) 
	@ nlLin++,00 PSAY	"TRANSPORTADORA: " +IIF( _lNfSaida,ROMN->F2_TRANSP ,ROMN->F1_TRANSP  )+ "-" + IIF( _lNfSaida,GETADVFVAL("SA4","A4_NREDUZ",XFILIAL("SA4")+ROMN->F2_TRANSP,1) ,GETADVFVAL("SA4","A4_NREDUZ",XFILIAL("SA4")+ROMN->F1_TRANSP,1)  )   
	
	WHILE ROMN->CARGA == clRoman
		// Se chegou na linha 55, pula a pagina
		If nlLin >= 55	//55		
				@ 63,000 PSAY __PrtThinLine()
				@ 64,00 PSAY ""+ SPACE(50)+" | CONTINUA NA OUTRA PAGINA  |"
				@ 65,00 PSAY __PrtThinLine()                         
				@ 66,60 PSAY "PÁGINA--> "+ alltrim(str(nlPag))
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
				nlPag++
				nlLin := 8
		EndIf
		        
		If lNfSaida
			DBSELECTAREA("SA1")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SA1")+ROMN->CLIENTE + ROMN->F2_LOJA)
			
			cNomeEnt := SA1->A1_NOME 
			cEnd := SA1->A1_END
			cBairro := SA1->A1_BAIRRO
			cMun := SA1->A1_MUN
			cUF := SA1->A1_EST
			cCep := SA1->A1_CEP
		Else 
			DBSELECTAREA("SA2")
			DBSETORDER(1)   
			DBSEEK(XFILIAL("SA2")+ROMN->CLIENTE + ROMN->F1_LOJA) 
			
			cNomeEnt := SA2->A2_NOME
			cEnd := SA2->A2_END
			cBairro := SA2->A2_BAIRRO
			cMun := SA2->A2_MUN
			cUF := SA2->A2_EST
			cCep := SA2->A2_CEP
		EndIf
		
	
		
		@ nlLin++,00 PSAY	__PrtFatLine()	// Imprime Linha
		@ nlLin++,00 PSAY	"NOTA: "+ROMN->DOC +SPACE(3)+ "SERIE  :"+SPACE(2)+ROMN->SERIE +SPACE(3)+ "Nº PEDIDO :"+SPACE(2)+ROMN->PEDIDO
		@ nlLin++,00 PSAY	"COD_CLIENTE:  "+ROMN->CLIENTE +SPACE(2)+"CLIENTE :  "+SPACE(2)+cNomeEnt + SPACE(2)+"LOJA: "+IIF( lNfSaida,ROMN->F2_LOJA,ROMN->F1_LOJA ) 
		@ nlLin++,00 PSAY	"ENDEREÇO:  "+ cEnd +"BAIRRO :  "+cBairro
		@ nlLin++,00 PSAY	"MUNICIPIO:  " +cMun + " ESTADO : " + cUF  +SPACE(2)+ "CEP : "+SUBSTR(cCep,1,5)+' - '+SUBSTR(cCep,6,3)
		              
		If lNfSaida
			DBSELECTAREA("SC5")
			DBSETORDER(1)
			DBSEEK(xFilial("SC5")+ROMN->PEDIDO)
			
			IF SC5->C5_XNFABAS = "1"
				_cPa := "P.A: "+SC5->C5_XCODPA+" - "+SC5->C5_XDCODPA
				DBSELECTAREA("ZZ1")
				DBSETORDER(1)
				DBSEEK(xfilial()+ SC5->C5_XCODPA)
				_endent := "End Entrega: "+alltrim(zz1->ZZ1_END)   +" - " + alltrim(zz1->ZZ1_BAIRRO)+" - " + alltrim(zz1->ZZ1_MUN)   +" - " + alltrim(zz1->ZZ1_EST)   +" - " + alltrim(zz1->ZZ1_CEP)
				DBSELECTAREA("SC5")
				
				@ nlLin++,00 PSAY	_cPa
				@ nlLin++,00 PSAY	_endent
			ENDIF
		// nota devolucao
		Else
		
			dbSelectArea("SF2")
			dbSetOrder(1)
			If MsSeek( xFilial("SF2") +ROMN->D1_NFORI+ROMN->D1_SERIORI+ROMN->CLIENTE+SF2->F2_LOJA )
				cCodPa := SF2->F2_XCODPA
			EndIf
			
			
			// TODO: VER FORMA PARA MOSTRAR DADOS DA PA
			If !Empty( cCodPA ) 
				DBSELECTAREA("ZZ1")
				DBSETORDER(1)
				DBSEEK(xfilial()+ cCodPA)
				
				_cPa := "P.A: "+cCodPA+" - "+Alltrim(ZZ1->ZZ1_DESCRI)
			
				_endent := "End Entrega: "+alltrim(zz1->ZZ1_END)   +" - " + alltrim(zz1->ZZ1_BAIRRO)+" - " + alltrim(zz1->ZZ1_MUN)   +" - " + alltrim(zz1->ZZ1_EST)   +" - " + alltrim(zz1->ZZ1_CEP)
			
				@ nlLin++,00 PSAY	_cPa
				@ nlLin++,00 PSAY	_endent
			EndIf
				
		EndIf
		
		@ nlLin++,00 PSAY	__PrtFatLine()
		@ nlLin++,00 PSAY	"|COD_PRODUTO"+SPACE(6)+"|PRODUTO"+SPACE(28)+"|QUANTIDADE    "+SPACE(3)+"|UNID_MEDIDA|"+SPACE(3)+"PESO_BRUTO |CUBAGEM |"
		//		@ nlLin++,00 PSAY	"|COD_PRODUTO"+SPACE(6)+"|PRODUTO"+SPACE(23)+"|UNID_MEDIDA"+SPACE(3)+"|QUANTIDADE    |SEG_UNID_MED"+SPACE(3)+"|QTD SEGUNDA UN|"+SPACE(3)+"PESO_BRUTO |CUBAGEM |"
		@ nlLin++,00 PSAY	__PrtFatLine()
		nlLin++
		
		clNota:= ROMN->DOC
		WHILE ROMN->DOC == clNota
			// Se chegou na linha 55, pula a pagina
			If nlLin >= 55	//55		
				@ 63,000 PSAY __PrtThinLine()
				@ 64,00 PSAY ""+ SPACE(50)+" | CONTINUA NA OUTRA PAGINA  |"
				@ 65,00 PSAY __PrtThinLine()                         
				@ 66,60 PSAY "PÁGINA--> "+ alltrim(str(nlPag))
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
				nlPag++
				nlLin := 8
			EndIf
				
			@ nlLin,01 PSAY	ROMN->PRODUTO
			
			DBSELECTAREA("SB1")
			DBSETORDER(1)
			
			IF DBSEEK(XFILIAL("SB1")+ROMN->PRODUTO)
				@ nlLin,19 PSAY  SB1->B1_DESC
			ENDIF
			@ nlLin,56 PSAY	 Transform(ROMN->QUANT,"@E 999,999.99")	 //picture
			@ nlLin,73 PSAY	 ROMN->UM
			
			

			_nPeso:= ROMN->PESO * ROMN->QUANT
			@ nlLin,84 PSAY	 Transform(_nPeso,"@E 999,999.999")	 //picture
			//			@ nlLin,113 PSAY	 Transform(_nPeso,"@E 999,999.999")	 //picture
			nlLin++
			_nPeso:=0
			// Se chegou na linha 55, pula a pagina
			If nlLin >= 55	//55
				@ 63,000 PSAY __PrtThinLine()
				@ 64,00 PSAY ""+ SPACE(50)+" | CONTINUA NA OUTRA PAGINA  |"
				@ 65,00 PSAY __PrtThinLine()                           
				@ 66,60 PSAY "PÁGINA--> "+ alltrim(str(nlPag))
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
				nlPag++
				nlLin:=8
			EndIf
			
			ROMN->(dbSkip())
			
		ENDDO
		
		nlLin := nlLin + 2
		
	ENDDO
	
	nlLin := 55
	
	@ nlLin++,000 PSAY __PrtThinLine()
	@ nlLin++,39 PSAY "CONFIRMA O EMBARQUE DA MERCADORIA ACIMA RELACIONADA"
	@ nlLin++,38 PSAY Replicate("=",53)
	@ nlLin++,38 PSAY "DATA   ->"+" "+_cdata +space(3)+"HORA  =>"+" "+Time()
	@ nlLin++,38 PSAY REPLICATE("=",53)
	nlLin:=nlLin + 2
	@ nlLin++,00 PSAY SPACE(02)+REPLICATE("_",40)+SPACE(5)+REPLICATE("_",40)+SPACE(5)+REPLICATE("_",40)
	@ nlLin++,00 PSAY SPACE(17)+ "MOTORISTA"+SPACE(36)+"CONFERENTE"+SPACE(35)+"RESPONSSÁVEL"
	@ nlLin++,00 PSAY	" "
	@ nlLin++,00 PSAY	"Sr. Transportador:"
	@ nlLin++,00 PSAY	" "
	@ nlLin++,00 PSAY	"É de sua responsabilidade a conferência da carga, antes do embarque das mercadorias."
	@ nlLin++,00 PSAY	"Os canhotos de entrega devem conter descrição de nome, RG e assinatura do recebedor."
	@ nlLin++,00 PSAY	"Devoluções somente serão aceitas se previamente autorizadas pela Administração de Vendas da Tok Take,"
	@ nlLin++,00 PSAY	"devendo ser indicado no verso da Nota Fiscal, o motivo da devolução, assinado pelo recebedor/motorista."
	@ nlLin++,00 PSAY	" "
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
ROMN->(dbCloseArea())

Return
