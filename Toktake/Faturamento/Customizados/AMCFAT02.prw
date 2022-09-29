#Include 'Protheus.ch'

User Function AMCFAT02
	
	Local nI		:= 0
	Local cCab		:= ""
	Local nLin 		:= 0
	Local aDados 	:= {}
	Local aTemp 	:= {}
	Local nI 		:= 0
	Local cHeader	:= ""
	Local nRegs		:= 0
	Local cPed		:= ""
    Local lCliBlq	:=	.F.
	Local aPergs 	:= {}
	Local cCndPG 	:= space(3)
	Local aRet := {}
	
	If cEmpAnt <> "10"
		Return
	EndIf
	
	BEGIN TRANSACTION
	
	aCabec := {}
	aItens := {}
    
	aAdd( aPergs ,{1,"Cond. Pagto? ",cCndPG,"@!",'.T.','SE4','.T.',40,.F.})   
	
	If ParamBox(aPergs ,"Condição",aRet)
		cCndPG	:=	aRet[1]
		
		DbSelectArea("SA1")
		DbSetOrder(1)
		If Dbseek(xFilial("SA1")+Strzero(val(aList[oList:nAt,3]),6)+Strzero(val(aList[oList:nAt,4]),2))
			If SA1->A1_MSBLQL == '1'
				lCliBlq := .T.
				Reclock("SA1",.F.)
				SA1->A1_MSBLQL := '2'
				SA1->(Msunlock())
			EndIf
		EndIF
				
		aAdd( aCabec , { "C5_FILIAL" 	, xFilial("SC5")					, Nil } )
		aAdd( aCabec , { "C5_TIPO" 		, "N"								, Nil } )
		aAdd( aCabec , { "C5_CLIENTE"	, aList[oList:nAt,3] 				, Nil } )
		aAdd( aCabec , { "C5_LOJACLI"	, aList[oList:nAt,4] 				, Nil } )
		aAdd( aCabec , { "C5_NATUREZ"	, '10101005'	      				, Nil } )  //Natureza de locacao
		aAdd( aCabec , { "C5_TIPOCLI"	, "F"			      				, Nil } )
		aAdd( aCabec , { "C5_CONDPAG"	, cCndPG		     				, Nil } )
		aAdd( aCabec , { "C5_MENNOTA"	, "RESCISAO CONTRATUAL"				, Nil } )
		aAdd( aCabec , { "C5_XDTENTR"	, ddatabase							, Nil } )
				
		aLinha := {}
		
		aAdd( aLinha , { "C6_FILIAL"	, xFilial("SC6") 									, Nil })
		aAdd( aLinha , { "C6_ITEM"		, '01'												, Nil })
		aAdd( aLinha , { "C6_PRODUTO"	, '7000152' 		  								, Nil })
		aAdd( aLinha , { "C6_QTDVEN"	, 1													, Nil })
		aAdd( aLinha , { "C6_PRCVEN"	, nMulta											, Nil })
		aAdd( aLinha , { "C6_TES"		, "600"			    		          				, Nil })
		aAdd( aLinha , { "C6_ENTREG"	, ddatabase				              				, Nil })
		aAdd( aItens , aLinha )
					
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItens,3)
						
		If lMsErroAuto
			DisarmTransaction()
			MostraErro()
		EndIf
		
		cNf := STATICCALL(AMCFSR01,GeraNF,SC5->C5_NUM,SC5->C5_CONDPAG)
		MsgAlert("Pedido Gerado "+SC5->C5_NUM+" - Nota de Débito gerada "+cNf+" PDF gerado na pasta C:\Temp")
		
		//Alterações realizadas por Ronaldo Gomes - 19/04/2017
		//MV_PAR01 := 'D'
		MV_PAR01 := cFilAnt+'D'
		MV_PAR02 := cNf
		
		//U_AMCFIN01(.T.)    
		U_AMCFIN04(.T.)    
		
		
		If lCliBlq       
			lCliBlq := .F.
			DbSelectArea("SA1")
			DbSetOrder(1)
			If Dbseek(xFilial("SA1")+Strzero(val(aDados[nI,2]),6)+Strzero(val(aDados[nI,3]),2))
				Reclock("SA1",.F.)
				SA1->A1_MSBLQL := '1'
				SA1->(Msunlock())
			EndIF
		EndIF
	
	EndIf
	
	END TRANSACTION

Return