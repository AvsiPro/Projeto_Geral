#Include "PROTHEUS.CH"
#include "rwmake.ch"
#include "Topconn.ch"   

#include "TOTVS.CH"

////*//////////////////////////////////////////////////////
//                                                       //
//    Relatorio pedido de venda                          //                                             
//                                                       //
//     Pedido de venda   - Gabriel Melo    13/08/2020    //
//                                                       //
/////////////////////////////////////////////////////*/////



User Function PEDIPDF(cNupv)

	PRIVATE cData := dtoc(Date())
	PRIVATE cTime := Time()

	Private cTitulo := "Impressao - Relatorio de Pedido"
	Private oPrn, oArial07, oArial09b, oArial14B
	Private nPag :=0
	PRIVATE cPasta := ""
	PRIVATE lSrvUnix	:= IsSrvUnix()
	PRIVATE _cArq_Bole	:= ""
	PRIVATE cLocal	:= IIF( lSrvUnix, "/spool" , "\spool" )	
	PRIVATE lAdjustToLegacy := .T.
	PRIVATE lDisableSetup  := .T. 

	Define Font oArial10  Name "Arial" Size 0,10 of oPrn   
	Define Font oArial12 Name "Arial" Size 0,12 of oPrn 
	Define Font oArial13 Name "Arial" Size 0,13 of oPrn
	Define Font oArial14 Name "Arial" Size 0,14 of oPrn
	Define Font oArial10B Name "Arial" Size 0,10 of oPrn BOLD
	Define Font oArial12B Name "Arial" Size 0,12 of oPrn BOLD
	Define Font oArial13B Name "Arial" Size 0,13 of oPrn BOLD
	Define Font oArial14B Name "Arial" Size 0,14 of oPrn BOLD
	Define Font oArial20B Name "Arial" Size 0,16 of oPrn BOLD


	itens(cNupv)


Return

Static Function itens(cNupv)

	Local nLin := 1400
	Local nSOMA := 0   
	Local (cAliasQry) := GetNextAlias()

	BeginSQL Alias cAliasQry
		%NoPARSER%
		SELECT SC5.C5_FILIAL, SC5.C5_NUM, SC5.C5_EMISSAO, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_CLIENT, C5_CONDPAG, SC5.C5_STATUS, SC5.C5_FRETE, SC5.C5_VEND1, SC5.C5_TPFRETE, SC6.C6_PRODUTO, SC6.C6_DESCRI, 
		SC6.C6_QTDVEN, SC6.C6_PRCVEN, SC6.C6_VALOR, SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_UM,
		SA1.A1_COD, SA1.A1_NOME, SA1.A1_LOJA, SA1.A1_NREDUZ, SA1.A1_CGC, SA1.A1_INSCR, SA1.A1_END, SA1.A1_BAIRRO,A1_ENDENT,A1_BAIRROE,
		SA1.A1_MUN, SA1.A1_EST, SA1.A1_CEP, SA1.A1_EMAIL, SA1.A1_DDD, SA1.A1_TEL, SA1.A1_TRANSP, SA1.A1_CONTATO, SA1.A1_COMPLEM, SA1.A1_CEPE, SA1.A1_MUNE, SA1.A1_ESTE
		FROM %Table:SC5% SC5, %Table:SC6% SC6, %Table:SB1% SB1, %Table:SA1% SA1
		WHERE SC5.C5_FILIAL = %xFilial:SC5%
		AND SC6.C6_FILIAL = %xFilial:SC6% 
		AND SB1.B1_FILIAL = %xFilial:SB1%
		AND SC6.C6_NUM = SC5.C5_NUM
		AND SC6.C6_CLI+SC6.C6_LOJA = SA1.A1_COD+SA1.A1_LOJA
		AND SB1.B1_COD = SC6.C6_PRODUTO     
		AND  SC5.%notDel%  
		AND  SC6.%notDel% 
		AND  SB1.%notDel%          
		AND  SC5.C5_NUM = %exp:cNupv%

		ORDER BY %ORDER:SC5%
	EndSQl

	DBSELECTAREA( (cAliasQry) )
	((cAliasQry))->( DBGOTOP() )

	cOrcamento	:= (cAliasQry)->C5_NUM 
	cCliente	:= (cAliasQry)->C5_CLIENTE  
	cLoja		:= (cAliasQry)->C5_LOJACLI
	cClient		:= (cAliasQry)->C5_CLIENT 
	cLojaEnt	:= (cAliasQry)->C5_LOJACLIENT            
	cEmissao	:= STOD((cAliasQry)->C5_EMISSAO)
	cNomeCli	:= (cAliasQry)->A1_NREDUZ 

	cPasta		:= GetMV("MV_XBOLPED") 
	cPasta		:= cPasta + IF(SUBS(cPasta,Len(cPasta),1) == "\", "", "\")

	_cArq_Bole 		:= "Pedido" + ".pdf"
	_cArq_Bole		:= strtran(_cArq_Bole, " ", "_")

	oPrn := FWMSPrinter():New(_cArq_Bole, 6, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
	oPrn:SetPortrait()

	meucabec()


	oPrn:Say(455,100,cOrcamento,oArial20B)
	oPrn:Say(455,500,DTOC(cEmissao),oArial20B)
	oPrn:Say(850,400,(cAliasQry)->A1_NOME,oArial10)  
	oPrn:Say(900,250,(cAliasQry)->A1_CGC,oArial10)


	While (cAliasQry)->(!EOF())

		If  nLin > 3200 

			oPrn:EndPage()
			meucabec()
			nLin := 1400

		Endif 


		If  (cAliasQry)->C5_NUM <> cOrcamento 
			nSomaTotal := nSOMA
			nLin := nLin + 50
			oPrn:Say(nLin,1500,"Valor Total Geral: ",oArial14B,,CLR_BLUE)		
			oPrn:Say(nLin,2060,Transform(nSOMATotal,"@E 999,999,999.99"),oArial14B) 

			cOrcamento	:= (cAliasQry)->C5_NUM 
			cCliente	:= (cAliasQry)->C5_CLIENTE  
			cLoja		:= (cAliasQry)->C5_LOJACLI
			cClient		:= (cAliasQry)->C5_CLIENT 
			cLojaEnt	:= (cAliasQry)->C5_LOJAENT 
			cNomeCli	:= (cAliasQry)->A1_NREDUZ
			cEmissao	:= STOD((cAliasQry)->C5_EMISSAO)

			oPrn:EndPage()
			meucabec()
			nLin := 1400

			oPrn:Say(455,100,cOrcamento,oArial20B)
			oPrn:Say(455,500,DTOC(cEmissao),oArial20B)
			oPrn:Say(850,400,(cAliasQry)->A1_NOME,oArial10)  
			oPrn:Say(900,250,(cAliasQry)->A1_CGC,oArial10)

		Endif


		oPrn:Say(nLin,0040,(cAliasQry)->C6_PRODUTO,oArial12)
		oPrn:Say(nLin,0220,SUBSTR((cAliasQry)->C6_DESCRI,01,50),oArial10)
		oPrn:Say(nLin,1410,(cAliasQry)->B1_UM,oArial12)
		oPrn:Say(nLin,1570,cValtochar((cAliasQry)->C6_QTDVEN),oArial12)
		oPrn:Say(nLin,1670,Transform((cAliasQry)->C6_PRCVEN,"@E 9,999,999.99"),oArial12)
		oPrn:Say(nLin,1950,Transform((cAliasQry)->C6_VALOR,"@E 99,999,999.99"),oArial12)

		oPrn:Say(nLin,0040,"__________________________________________________________________________________________________________________________________",oArial12)

		nSOMA := nSOMA + (cAliasQry)->C6_VALOR  

		nLin := nLin + 50

		(cAliasQry)->(dbSkip())

	EndDo    
	nSomaTotal := nSOMA
	nLin := nLin + 50

	oPrn:Say(nLin,1300,"Valor Total Geral: ",oArial14B,,CLR_BLUE)

	oPrn:Say(nLin,1900,Transform(nSOMATotal,"@E 99,999,999.99"),oArial14B) 

	cOrcamento := (cAliasQry)->C5_NUM 

	nLin := nLin + 100 

	nLin := nLin + 50  

	(cAliasQry)->(dbCloseArea())

	oPrn:EndPage()

	oPrn:Preview()


	cPath_Temp := GetTempPath()
	cFileOrige := cPath_Temp + "totvsprinter\" + _cArq_Bole
	cFileDesti := cPasta     + _cArq_Bole
	lFile := file( cFileOrige )

	lCopiou := __CopyFile( cFileOrige , cFileDesti )


Return


Static Function meucabec()       
	Local nLinIni1 := 0050
	Local nLinFim1 := 0450
	Local nColIni1 := 0100
	Local nColFim1 := 0330
	nPag++
	oPrn:StartPage()

	oPrn:SayBitMap(nLinIni1,nColIni1, "logoromed.png",nLinFim1, nColFim1)


	oPrn:Say(0410,100,"ORCAMENTO:", oArial14B)
	oPrn:Say(0410,500,"DATA:", oArial14B)
	oPrn:Line(0550,0100,0550,2900)
	oPrn:Say(0850,100,"Razao social:", oArial12B)  
	oPrn:Say(0900,100,"CNPJ:", oArial12B)   
	oPrn:Say(1200,100,"RELACAO DE PRODUTOS:", oArial14B,,CLR_BLUE) 	
	oPrn:Line(1250,0000,1250,3050)
	oPrn:Say(1300,0040,"Codigo", oArial13B,,CLR_BLUE)
	oPrn:Say(1300,0220,"Descricao do Produto", oArial13B,,CLR_BLUE)
	oPrn:Say(1300,1410,"UN", oArial13B,,CLR_BLUE)  
	oPrn:Say(1300,1540,"QTDE", oArial13B,,CLR_BLUE)  
	oPrn:Say(1300,1670,"Valor", oArial13B,,CLR_BLUE)
	oPrn:Say(1300,1950,"Total", oArial13B,,CLR_BLUE)
	oPrn:Line(1350,0040,1350,3000) 

Return