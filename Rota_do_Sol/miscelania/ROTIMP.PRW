#include "totvs.ch"
#include "fwmvcdef.ch"
#Include "TopConn.ch"


/*
+----------------------------------------------------------------------------+
!Descricao         ! Programas Com Funcoes Distintas no sistema              !
+------------------+---------------------------------------------------------+
!Programa          ! ROTMIS                                                  !
+------------------+---------------------------------------------------------+
!Autor             ! Marcio Da Silva                                         !
+------------------+---------------------------------------------------------+
!Empresa           ! TOTVS                                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 26/08/2023                                              !
+------------------+---------------------------------------------------------+
*/
User Function ROTIMP() //importcao de ativo FI

//	fRotImp1() // Importacao Ativo Fixo
//	fRotImp2() // Importacao Contas a Pagar
	//fRotImp3() // Importacao Lancamentos Contabeis
	//fRotImp4() // Importacao CLientes
	//fRotImp5() // Importacao Fornecedores
	//fRotImp6() // Importacao Produtos
	//fRotImp7() // Importacao Contas a Receber
	//fRotImp8() // Importacao Contas a Receber
//	fRotImp9() // Importacao Contas a Receber
	fRotIm10() // Importacao Contas a Receber

Return()


/**********************************************************************************
* fRotImp1  - Importacao de ATIVO FIXO                         *
*********************************************************************************
CAMPOS PLANILHA SEM RELACIONAMENTO PROTHEUS
NR_ATIVO,TIPO_ATIVO, CATEGORIA_ATIVO



CAMPOS OBRIGATORIOS PROTHEUS
N1_GRUPO - GRUPOO ATIVO
N1_PATRIMON - CLASSIFICACAO ATIVO
N1_AQUISIC
N1_QUANT
N3_TPSALDO
N3_TPDEPREC




*/
Static Function fRotImp1()
***************
private INCLUI		:= .T.

oModel      := Nil

alert('Importacao ATIVO FIXO')
Procregua(1252)
sArq := "C:\IMP_ROTA\SN1.TXT"
if file(sArq)
	If (_nHa := FT_FUse(AllTrim(sArq)))== -1
		msgbox("Arquivo Aberto, Favor Fechar!")
		Return
	EndIf
	FT_FGOTOP()
	//While !FT_FEOF() .And. tLaco
        Incproc()
		sLinha := Alltrim(FT_FREADLN())
		sCampo := ''
		aCampo := {}
		While Len(sLinha) > 0 
			nPos := AT(";",sLinha)
			If nPos > 0 
				sCampo := Left(sLinha,nPos - 1)
				sResto := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := sResto
			Else
				sCampo := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := ''
			EndIf
			Aadd(aCampo,Alltrim(sCampo) ) 
		EndDo

		sN3_TIPO	:= '01'
		sN3_CCONTAB := aCampo[7]
		sN3_CDEPRC  := aCampo[8]

		sN3_HISTOR  := aCampo[35]
		nN3_CUSTBEM := Val(aCampo[26])
		nN3_VORIG1  := Val(aCampo[25])



		begin transaction	

			oModel := FWLoadModel("ATFA012")
			oModel:SetOperation(MODEL_OPERATION_INSERT )
			oModel:Activate()

			oModel:SetValue( "SN1MASTER",  "N1_FILIAL", 	fwxFilial("SN1")	)
			oModel:SetValue( "SN1MASTER",  "N1_GRUPO", 		'0003'				)
			oModel:SetValue( "SN1MASTER",  "N1_CBASE", 		aCampo[1]			)
			oModel:SetValue( "SN1MASTER",  "N1_ITEM", 		'0001'				)
			oModel:SetValue( "SN1MASTER",  "N1_TIPO", 		aCampo[2]			)
			oModel:SetValue( "SN1MASTER",  "N1_AQUISIC", 	dDataBase			)
			oModel:SetValue( "SN1MASTER",  "N1_QUANTD", 	Val(aCampo[15])		)
			oModel:SetValue( "SN1MASTER",  "N1_DESCRIC", 	aCampo[16]			)
			oModel:SetValue( "SN1MASTER",  "N1_PLACA", 		aCampo[6]			)
			oModel:SetValue( "SN1MASTER",  "N1_NSERIE", 	aCampo[36]			)
			oModel:SetValue( "SN1MASTER",  "N1_NFISCAL", 	aCampo[17]			)
			oModel:SetValue( "SN1MASTER",  "N1_AQUISIC", 	dDataBase			)

			sN3_TIPO	:= '01'
			sN3_CCONTAB := aCampo[8]
			sN3_CDEPRC  := aCampo[9]
			sN3_CCUSTO  := aCampo[10]
			sN3_HISTOR  := aCampo[35]
			nN3_CUSTBEM := Val(aCampo[26])
			nN3_VORIG1  := Val(aCampo[25])
			//item
			oModel:GetModel("SN3DETAIL"):AddLine()
			oModel:SetValue( "SN3DETAIL",  "N3_TIPO", 		sN3_TIPO			)
			oModel:SetValue( "SN3DETAIL",  "N3_HISTOR", 	aCampo[16]			)
			oModel:SetValue( "SN3DETAIL",  "N3_CCONTAB", 	sN3_CCONTAB)
			oModel:SetValue( "SN3DETAIL",  "N3_CDEPREC", 	sN3_CDEPRC)
			oModel:SetValue( "SN3DETAIL",  "N3_CCUSTO", 	sN3_CCUSTO)
			oModel:SetValue( "SN3DETAIL",  "N3_VORIG1", 	nN3_VORIG1)



			if oModel:VldData()
				oModel:CommitData()
			else
				disarmTransaction()
				mostraErro()
			endIf
			oModel:DeActivate()
			oModel:Destroy()
			oModel:= nil

		end transaction

		FT_FSKIP()
	//EndDo
EndIf
alert('acabou')
Return()



/*
	cCBASE	 			:= aZ04_Atual[1]
	cPatrim				:= aZ04_Atual[2]
	cGrupo				:= aZ04_Atual[3]
	cITEM				:= getMaxItemN1(cCBASE)
	cDescPreCad			:= allTrim(aZ04_Atual[4]) 
	cDescriFull			:= allTrim(aZ04_Atual[4]) + " " + cValToChar(nValor) + " " + cValToChar(dDataBase)
	nQUANTD				:= 1		

	aAdd(aCabecalho,{"N1_FILIAL" 	, fwxFilial("SN1") 		,nil})
	aAdd(aCabecalho,{"N1_GRUPO" 	, cGrupo 				,nil})
	aAdd(aCabecalho,{"N1_CBASE" 	, cCBASE 				,nil})
	aAdd(aCabecalho,{"N1_ITEM" 		, cITEM 				,nil})
	aAdd(aCabecalho,{"N1_AQUISIC" 	, dDataBase 			,nil})
	aAdd(aCabecalho,{"N1_QUANTD" 	, 1 					,nil})
	aAdd(aCabecalho,{"N1_DESCRIC" 	, cDescPreCad			,nil})	
	aAdd(aCabecalho,{"N1_PATRIM" 	, cPatrim 				,nil})
	aAdd(aCabecalho,{"N1_ZZDESCR" 	, cDescriFull 			,nil})
	aAdd(aCabecalho,{"N1_CHAPA" 	, Alltrim(Str(Val(cCBASE)))        		,nil})

//	aAdd(aItem,{"N3_TIPO" 		, "13" 													,nil}) 
//	aAdd(aItem,{"N3_HISTOR" 	, "VALOR INTEGRACAO INVESTIMENTO " + cValToChar(dDataBase)		,nil})  
	aAdd(aItem,{"N3_TIPO" 		, cTipoIt												,nil}) 
	aAdd(aItem,{"N3_HISTOR" 	, cDescIt												,nil})  
	aAdd(aItem,{"N3_CUSTBEM" 	, cCCINVE												,nil}) 
	aAdd(aItem,{"N3_SUBCCON" 	, cITINVE												,nil}) 	
	aAdd(aItem,{"N3_CLVLCON" 	, cCLINVE												,nil})	
	aAdd(aItem,{"N3_CDEPREC" 	, cCTDEPR												,nil})	//-20230221
	aAdd(aItem,{"N3_VORIG1" 	, nValor												,nil}) 	
	aAdd(aItem,{"N3_ZZDESCR" 	, cDescriFull											,nil}) 	

	aItem:= FwVetByDic(aItem, "SN3")

	aAdd(aItens, aItem)

*/

**************************
Static Function fRotImp2() //importcao de Contas A PAGAR
*************
/* 
-VINCULO PELO CGC AO FORNECEDOR, VARIOS CADASTROS DE cpf, como tambem codigos invalidos
- Numero dos titulos invalidos
-- ORIGEM TITULO ?????
-- COLOCAR O CAMPO DESCRICAO - EM E2_OBS
-- QUANTIA_TOT_HEADER ???
-- VERIFICAR TODOS OS CAMPOS


--TOTAL FORA DOS PADROES
*/

***************
oModel      		:= Nil
alert('Importacao PAGAR ')
sArq := "C:\IMP_ROTA\SE2.TXT"
tLaco := .T.
if file(sArq)
	If (_nHa := FT_FUse(AllTrim(sArq)))== -1
		msgbox("Arquivo Aberto, Favor Fechar!")
		Return
	EndIf
	FT_FGOTOP()
//	While !FT_FEOF() .And. tLaco
		sLinha := Alltrim(FT_FREADLN())
		sLinha := StrTran(sLinha, "'", "")
		sLinha := StrTran(sLinha, ",", ".")
		sCampo := ''
		aCampo := {}
		While Len(sLinha) > 0 
			nPos := AT(";",sLinha)
			If nPos > 0 
				sCampo := Left(sLinha,nPos - 1)
				steste := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := steste
			Else
				sCampo := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := ''
			EndIf
			Aadd(aCampo,{Alltrim(sCampo)} ) 

		EndDo
		DbSelectArea('SA2')
		DbSetorder(11)
		DbSeek(xFilial('SA2')+StrZero(Val(aCampo[14,1]),6),.t.)
		If SA2->A2_XCODLEG == StrZero(Val(aCampo[14,1]),6)
			RecLock('SA2', .F.)
			SA2->A2_MSBLQL = '2'
			MsUnlock('SA2')

			DbSelectArea('SED')
			DbSetorder(1)
			DbSeek(xFilial('SED')+Alltrim(aCampo[5,1]),.t.)
			iF xFilial('SED')+Alltrim(aCampo[5,1]) <> SED->ED_FILIAL + Alltrim(SED->ED_CODIGO)
				aCampo[5,1] := 'OUTROS'
			EndIf	
			cParcela := IIF(Alltrim(aCampo[3,1])=='','001',STRZERO(VAL(aCampo[3,1]),3))
			DbSelectArea('SE2')
			DbSetOrder(6)
			DbSeek(xFilial('SE2')+ SA2->A2_COD + SA2->A2_LOJA + aCampo[1,1] + STRZERO(VAL(aCampo[2,1]),9) + 'ZZZ',.T.)
			DbSkip(-1)
			If xFilial('SE2')  + SA2->A2_COD     + SA2->A2_LOJA + aCampo[1,1]        + STRZERO(VAL(aCampo[2,1]),9) == ;
				SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM
				cParcela := STRZERO(VAL(SE2->E2_PARCELA)+1,3)
			EndIf
			aVetSE2 := {}
			aAdd(aVetSE2, {"E2_FILIAL"	,xFilial("SE1") ,Nil})  
			aAdd(aVetSE2, {"E2_NUM"		,STRZERO(VAL(aCampo[2,1]),9)      ,Nil})   
			aAdd(aVetSE2, {"E2_PREFIXO"	,aCampo[1,1]          ,Nil})  
			aAdd(aVetSE2, {"E2_PARCELA"	,cParcela  ,Nil})  //Padl(cDados, 6, '0')
			aAdd(aVetSE2, {"E2_TIPO"    ,Alltrim(aCampo[4,1])          ,Nil})
			//aAdd(aVetSE2, {"E2_TIPO"    ,aCampo[4,1]           ,Nil})
			aAdd(aVetSE2, {"E2_NATUREZ"	,aCampo[5,1],Nil})  
			aAdd(aVetSE2, {"E2_FORNECE"	,SA2->A2_COD    ,Nil})  
			aAdd(aVetSE2, {"E2_LOJA"	,SA2->A2_LOJA   ,Nil}) 
			aAdd(aVetSE2, {"E2_NOMFOR"	,SA2->A2_NOME   ,Nil}) 
			aAdd(aVetSE2, {"E2_HIST"	,Left(aCampo[12,1],39)   ,Nil}) 
			aAdd(aVetSE2, {"E2_EMISSAO"	,stod(aCampo[8,1]) ,Nil}) 
			aAdd(aVetSE2, {"E2_VENCTO"	,stod(aCampo[9,1]),Nil}) 
			aAdd(aVetSE2, {"E2_VENCREA"	,DataValida(stod(aCampo[9,1]),.T.),Nil}) 
			aAdd(aVetSE2, {"E2_VALOR"	,val(aCampo[11,1]) ,Nil}) 
			aAdd(aVetSE2, {"E2_MOEDA"	,1              ,Nil}) 
			iF Alltrim(aCampo[4,1]) == 'PA'
				aAdd(aVetSE2, {"AUTBANCO"	,'CX1' 				,Nil})  
				aAdd(aVetSE2, {"AUTAGENCIA"	,'00001'			,Nil})   
				aAdd(aVetSE2, {"AUTCONTA"	,'0000000001'       ,Nil})  
			EndIf	

			//Inicia o controle de transação
			Begin Transaction
				//Chama a rotina automática
				lMsErroAuto := .F.
				MSExecAuto({|x,y| FINA050(x,y)}, aVetSE2, 3)
				If lMsErroAuto
					MostraErro()
					if MsgBox ("Deseja Sair do Programa apos o Erro?","Escolha","YESNO")
						tLaco := .F.
					EndIf
				EndIf
			End Transaction
		else
			alert('nao achou' + aCampo[14,1])	
			if MsgBox ("Deseja Sair do Programa apos o Erro?","Escolha","YESNO")
				tLaco := .F.
			EndIf
		EndIf
		FT_FSKIP()
//	EndDo
EndIf
alert('acabou')
Return()



**************************
Static Function fRotImp3() //importcao de Contas
*************
Local Nx := 1
Local _lOk := .T.
Local aItens := {}
Local aCab := {}
PRIVATE lMsErroAuto := .T.

_lOk := .T.
aItens := {}
aCab := { {'DDATALANC' ,ctod('01/03/2023') ,NIL},;
{'CLOTE' ,'000000' ,NIL},;
{'CSUBLOTE' ,'001' ,NIL},;
{'CDOC' , STRZERO( seconds() ,6) ,NIL},;
{'CPADRAO' ,'' ,NIL},;
{'NTOTINF' ,0 ,NIL},;
{'NTOTINFLOT' ,0 ,NIL} }


alert('Inicio Importacao lancamento contabeis')
sArquivo := "\miscelania\sldctb.txt"
if file(sArquivo)
   If (_nHa := FT_FUse(AllTrim(sArquivo)))== -1
      msgbox("Arquivo Aberto, Favor Fechar!")
      Return
   EndIf

   FT_FGOTOP()
   While !FT_FEOF()
//	sLinha := '                    ;01/03/2023;2450102001          ;      ;SALDO CONTÁBIL REF.: 03/2023;      ;   ;-63033973,75;   ;   ;
//  sLinha += '3110101010          ;01/03/2023;                    ;      ;SALDO CONTÁBIL REF.: 03/2023;      ;   ;-790816,50;   ;   ;

		sLinha := Alltrim(FT_FREADLN())

		aLinha := StrTokArr(sLinha, ";")
		cDEBITO := ''
		cCREDITO := ''
		cCT2_DC  := ''

		iF !Empty(Alltrim(aLinha[1]))	
			cCT2_DC  := '1'
			sConta := PADL(Alltrim(aLinha[1]),TamSX3( "CT1_CONTA" )[1])
			DbSelectArea("CT1")
			DbSetOrder(1)
			iF DbSeek(xFilial("CT1") + sConta)
				cDEBITO := CT1->CT1_CONTA
			Else
				sConta := PADL(Alltrim(aLinha[1]),TamSX3( "CT1_RES" )[1])
				DbSetOrder(2)
				iF DbSeek(xFilial("CT1") + sConta)
					cDEBITO := CT1->CT1_CONTA
				EndIf		
			EndIf		
		EndIf		
		iF !Empty(Alltrim(aLinha[3]))	
			cCT2_DC  := '2'
			sConta := PADL(Alltrim(aLinha[3]),TamSX3( "CT1_CONTA" )[1])
			DbSelectArea("CT1")
			DbSetOrder(1)
			iF DbSeek(xFilial("CT1") + sConta)
				cCREDITO := CT1->CT1_CONTA
			Else
				sConta := PADL(Alltrim(aLinha[3]),TamSX3( "CT1_RES" )[1])
				DbSetOrder(2)
				iF DbSeek(xFilial("CT1") + sConta)
					cCREDITO := CT1->CT1_CONTA
				EndIf		
			EndIf		
		EndIf		
		If !Empty(cCREDITO) .And. !Empty(cDEBITO)
			cCT2_DC  := '3'
		EndIf
		nCT2_VALOR := VAL(aLinha[8])
		nCT2_VALOR := iif(nCT2_VALOR<0, nCT2_VALOR*(-1), nCT2_VALOR)
		iF nCT2_VALOR > 0 
			aAdd(aItens,{ {'CT2_FILIAL' ,xFilial("CT2") , NIL},;
			{'CT2_LINHA' ,Strzero(Nx,3) , NIL},;
			{'CT2_MOEDLC' ,'01' , NIL},;
			{'CT2_DC' ,cCT2_DC , NIL},;
			{'CT2_DEBITO' ,cDEBITO , NIL},;
			{'CT2_CREDIT' ,cCREDITO , NIL},;
			{'CT2_VALOR' , nCT2_VALOR , NIL},;
			{'CT2_ORIGEM' ,'MSEXECAUT', NIL},;
			{'CT2_HP' ,'' , NIL},;
			{'CT2_HIST' ,aLinha[5], NIL} } )

			Nx += 1

		EndIF
		FT_FSKIP()
	EndDo
	If Len(aItens) > 0 
		MSExecAuto( {|X,Y,Z| CTBA102(X,Y,Z)} ,aCab ,aItens, 3)
		If lMsErroAuto <> Nil
			If !lMsErroAuto
				_lOk := .T.
				If !IsBlind()
					MsgInfo('Inclusão com sucesso!')
				EndIf
			Else
				MostraErro()
				_lOk := .F.
				If !IsBlind()
					MsgAlert('Erro na inclusao!')
				Endif
			EndIf
		EndIf
	EndIf
Else
	MsgAlert('Arquivo Nao Encontrado!')
EndIF

Return


/**********************************************************************************
* ROTIMP4.PRW  - Importacao de Clientes                                          *
*********************************************************************************
A1_TIPO - NAO ENCONTRADO
A1_TELEFONE - CAMPO INVALIDOS
A1_NATUREZ - NAO ENCONTRADO - 
A1_NREDUZ - TAMANHO DO CAMPO 

CADASTRO DE CLIENTES DUPLICADO
*/
Static Function fRotImp4()
***************
Local lDeuCerto   := .F.

oModel      := Nil

nA1_COD  	:= 0
alert('Inicio Importacao CLIENTES - SA1')
sArq := "C:\IMP_ROTA\SA1.TXT"
DbSelectArea('SA1')
DbSetOrder(1)
DBGOTOP()
if file(sArq)
	If (_nHa := FT_FUse(AllTrim(sArq)))== -1
		msgbox("Arquivo Aberto, Favor Fechar!")
		Return
	EndIf
	tLaco := .T.

	FT_FGOTOP()
	//While !FT_FEOF() .And. 	tLaco
		sLinha := Alltrim(FT_FREADLN())
		//STRTRAN (<cString>, <cProcura>, [<cSubstitui>], [<nIn¡cio>], [<nCont>])

		aCampo := {}
		While Len(sLinha) > 0 
			nPos := AT(";",sLinha)
			If nPos > 0 
				sCampo := Left(sLinha,nPos - 1)
				sRestL := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := sRestL
			Else
				sCampo := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := ''
			EndIf
			Aadd(aCampo,Alltrim(sCampo) ) 
		EndDo

		sA1_CGC  := fTrCarac(aCampo[16])

		nA1_LOJA := 1 
		sA1_COD  := ''
		sA1_PESSOA := ''
		iF Len(Alltrim(sA1_CGC)) >12
			sA1_CGC  := IIF(Len(sA1_CGC)> 14, Subs(sA1_CGC,2,len(sA1_CGC)), sA1_CGC)
			sA1_PESSOA := 'J'
			DbSelectArea('SA2')
			DbSetOrder(3)
			DbSeek(xFilial('SA2')+Left(Alltrim(sA1_CGC),8),.T.)
			While !Eof() .And. left(Alltrim(SA2->A2_CGC),8) == Left(Alltrim(sA1_CGC),8)
				sA1_COD  := SA1->A1_COD
				nA1_LOJA += 1 
				DbSkip()
			EndDo	
		Else
			sA1_PESSOA := 'F'
			DbSelectArea('SA1')
			DbSetOrder(3)
			DbSeek(xFilial('SA1')+Alltrim(sA1_CGC),.T.)
			While !Eof() .And. Alltrim(SA1->A1_CGC) == Alltrim(sA1_CGC)
				sA1_COD  := SA1->A1_COD
				nA1_LOJA += 1 
				DbSkip()
			EndDo	
		EndIf	
		wLaco := .T.
		While wLaco
			nA1_COD  	+= 1
			//sA1_COD := GETSXENUM("SA1","A1_COD")
			sA1_COD := StrZero(nA1_COD,6)
			
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+sA1_COD,.T.)
			wLaco = IIF(xFilial("SA1")+sA1_COD == SA1->A1_FILIAL + SA1->A1_COD,.T.,.F.)
		EndDo
		nA1_LOJA := 1 
		sCT1_CONTA := Subs(aCampo[34],9,10)
		DbSelectArea("CT1")
        dbSetOrder(1)
		DbSeek(xFilial("CT1")+sCT1_CONTA,.T.)
		iF Empty(sCT1_CONTA) .Or. xFilial("CT1")+sCT1_CONTA == CT1->CT1_FILIAL+CT1->CT1_CONTA 
			lDeuCerto := .F.
			oModel := FWLoadModel("MATA030")
			oModel:SetOperation(3)
			oModel:Activate()
			oSA1Mod:= oModel:getModel("MATA030_SA1")
			oSA1Mod:setValue("A1_TIPO"		,'F'   	) //VERIFICAR
			oSA1Mod:setValue("A1_COD"		,sA1_COD) 
			oSA1Mod:setValue("A1_LOJA"		,StrZero(nA1_LOJA,4)) // Codigo 
			oSA1Mod:setValue("A1_CGC"	    ,sA1_CGC   	)
			oSA1Mod:setValue("A1_NREDUZ"	,LEFT(aCampo[2],15)   	) //VERIFICAR
			oSA1Mod:setValue("A1_NOME"	    ,LEFT(aCampo[3],40)   	) //VERIFICAR
			oSA1Mod:setValue("A1_PESSOA"    ,sA1_PESSOA   	)
			oSA1Mod:setValue("A1_INSCR"		,Alltrim(aCampo[17])   	)
			oSA1Mod:setValue("A1_END"		,Alltrim(aCampo[23])+', '+alltrim(aCampo[25])   	)
			oSA1Mod:setValue("A1_BAIRRO"    ,Alltrim(aCampo[24])   	)
			oSA1Mod:setValue("A1_MUN"		,aCampo[27]   	)
			oSA1Mod:setValue("A1_EST"		,aCampo[28]   	)
			DbSelectArea('CC2')
			DbSetOrder(4)
			DbSeek(xFilial('CC2')+Alltrim(aCampo[28]) + Alltrim(aCampo[27]) ,.T.)
			If !xFilial('CC2') +Alltrim(aCampo[28]) + Alltrim(aCampo[27]) == ;
				CC2->CC2_FILIAL+CC2->CC2_EST        + Alltrim(CC2->CC2_MUN)                                                                                                                                      
				Alert(xFilial('CC2') +Alltrim(aCampo[28]) + Alltrim(aCampo[27]) + '- Nao Encontrada!')
			EndIF
			oSA1Mod:setValue("A1_COD_MUN"	,CC2->CC2_CODMUN   	)               
			oSA1Mod:setValue("A1_CEP"		,aCampo[29]   	)
			oSA1Mod:setValue("A1_PAIS"		,'105'   	)
			If oModel:VldData()
				If oModel:CommitData()
					lDeuCerto := .T.
				Else
					lDeuCerto := .F.
				EndIf
			Else
				lDeuCerto := .F.
			EndIf
			If ! lDeuCerto

				aErro := oModel:GetErrorMessage()
				MostraErro()
	/*

				AutoGrLog("Id do formulário de origem:"  + ' [' + AllToChar(aErro[01]) + ']')
				AutoGrLog("Id do campo de origem: "      + ' [' + AllToChar(aErro[02]) + ']')
				AutoGrLog("Id do formulário de erro: "   + ' [' + AllToChar(aErro[03]) + ']')
				AutoGrLog("Id do campo de erro: "        + ' [' + AllToChar(aErro[04]) + ']')
				AutoGrLog("Id do erro: "                 + ' [' + AllToChar(aErro[05]) + ']')
				AutoGrLog("Mensagem do erro: "           + ' [' + AllToChar(aErro[06]) + ']')
				AutoGrLog("Mensagem da solução: "        + ' [' + AllToChar(aErro[07]) + ']')
				AutoGrLog("Valor atribuído: "            + ' [' + AllToChar(aErro[08]) + ']')
				AutoGrLog("Valor anterior: "             + ' [' + AllToChar(aErro[09]) + ']')
	*/

				tLaco := .F.
			EndIf
			oModel:DeActivate()
			FreeUsedCode()
		EndIF
		FT_FSKIP()
	//EndDo
EndIF
Return









/**********************************************************************************
* fRotImp5  - Importacao de Fornecedores                                      *
*********************************************************************************
CAMPOS OBRIGATORIOS PROTHEUS Q NAO VIERAM

Campos Nao Encontrados No Protheus
TIPO DE CONTRIBUINTE
MEI - Y/N
TIPO DE FORNECEDOR
PRATICAR DESCONTO SEMPRE
ASSOCIACAO DE COBRANCA
LOCAL DE ENTREGA
LOCAL DE FATURAMENTO
DATA_INICIO
DATA_FIM






*/
Static Function fRotImp5()
***************
Local lDeuCerto   	:= .F.
oModel      := Nil

alert('Inicio Importacao FORNECEDOR - SA2')
sArq := "C:\IMP_ROTA\SA2.TXT"
nA2_LOJA := 0 
DbSelectArea('SA2')
DbSetOrder(1)
DBGOTOP()
if file(sArq)
	If (_nHa := FT_FUse(AllTrim(sArq)))== -1
		msgbox("Arquivo Aberto, Favor Fechar!")
		Return
	EndIf
	nA2_COD  :=0
	tLaco := .T.

	FT_FGOTOP()
//	While !FT_FEOF() .And. tLaco
		sLinha := Alltrim(FT_FREADLN())
		//aCampo := StrTokArr(sLinha, ";")

		aCampo := {}
		While Len(sLinha) > 0 
			nPos := AT(";",sLinha)
			If nPos > 0 
				sCampo := Left(sLinha,nPos - 1)
				sRestL := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := sRestL
			Else
				sCampo := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := ''
			EndIf
			Aadd(aCampo,Alltrim(sCampo) ) 
		EndDo

		//aCampo := StrTokArr(sLinha, ";")

		sA2_COD   := Subs(aCampo[6],2,8)
		sA2_LOJA  := Subs(aCampo[6],11,4)
		sA2_CGC  := fTrCarac(aCampo[6])

		sA2_CGC  := IIF(Len(sA2_CGC)>12,Subs(sA2_CGC,2,len(sA2_CGC)),sA2_CGC)


		DbSelectArea('SA2')
		DbSetOrder(3)
		DbSeek(xFilial('SA2')+Alltrim(sA2_CGC),.T.)
		If !Alltrim(SA2->A2_CGC) == Alltrim(sA2_CGC)
			lDeuCerto := .F.
			oModel  := FwLoadModel ("MATA020M")
			oModel:SetOperation(3)
			oModel:Activate()
			oSA2Mod:= oModel:getModel("SA2MASTER")
			oSA2Mod:setValue("A2_COD"		,sA2_COD                    ) 
			oSA2Mod:setValue("A2_LOJA"		,sA2_LOJA ) // Codigo 
			oSA2Mod:setValue("A2_NOME"		,aCampo[2]   	)
			oSA2Mod:setValue("A2_NREDUZ"	,aCampo[2]   	)
			oSA2Mod:setValue("A2_TIPO"		,'J'   	)
			oSA2Mod:setValue("A2_CGC"		,sA2_CGC   	)
			oSA2Mod:setValue("A2_INSCR"		,iif(Empty(aCampo[7]),'ISENTO', Alltrim(aCampo[7]))   	)
			oSA2Mod:setValue("A2_INSCRM"	,iif(Empty(aCampo[8]),'ISENTO', Alltrim(aCampo[8]))   	)
			oSA2Mod:setValue("A2_MSBLQL"	,'1'   	)
			oSA2Mod:setValue("A2_END"		,Alltrim(aCampo[20])+', '+ Alltrim(aCampo[21])   	)
			oSA2Mod:setValue("A2_COMPLEM"	,Alltrim(aCampo[22])   	)
			oSA2Mod:setValue("A2_BAIRRO"	,aCampo[23]   	)
			oSA2Mod:setValue("A2_EST"		,aCampo[25]   	)
			oSA2Mod:setValue("A2_REGESIM"	,iif(aCampo[11] == 'S','1','2')   	)
			oSA2Mod:setValue("A2_FOMEZER"	,iif(aCampo[11] == 'S','1','2')   	)

			DbSelectArea('CC2')
			DbSetOrder(4)
			DbSeek(xFilial('CC2')+Alltrim(aCampo[25]) + Alltrim(aCampo[24]) ,.T.)
			If !xFilial('CC2') +Alltrim(aCampo[25]) + Alltrim(aCampo[24]) == ;
				CC2->CC2_FILIAL+CC2->CC2_EST        + Alltrim(CC2->CC2_MUN)                                                                                                                                      
				Alert(xFilial('CC2') +Alltrim(aCampo[25]) + Alltrim(aCampo[24]) + '- Nao Encontrada!')
			EndIF
			oSA2Mod:setValue("A2_COD_MUN"	,CC2->CC2_CODMUN   	)            
			oSA2Mod:setValue("A2_MUN"	    ,CC2->CC2_MUN   	)            
			oSA2Mod:setValue("A2_CEP"	    ,fTrCarac(aCampo[26])   	)            
			oSA2Mod:setValue("A2_PAIS"		,'105'   	)


			If oModel:VldData()
				If oModel:CommitData()
					lDeuCerto := .T.
				Else
					lDeuCerto := .F.
				EndIf
			Else
				lDeuCerto := .F.
			EndIf
			If ! lDeuCerto
				aErro := oModel:GetErrorMessage()
	/*
				AutoGrLog("Id do formulário de origem:"  + ' [' + AllToChar(aErro[01]) + ']')
				AutoGrLog("Id do campo de origem: "      + ' [' + AllToChar(aErro[02]) + ']')
				AutoGrLog("Id do formulário de erro: "   + ' [' + AllToChar(aErro[03]) + ']')
				AutoGrLog("Id do campo de erro: "        + ' [' + AllToChar(aErro[04]) + ']')
				AutoGrLog("Id do erro: "                 + ' [' + AllToChar(aErro[05]) + ']')
				AutoGrLog("Mensagem do erro: "           + ' [' + AllToChar(aErro[06]) + ']')
				AutoGrLog("Mensagem da solução: "        + ' [' + AllToChar(aErro[07]) + ']')
				AutoGrLog("Valor atribuído: "            + ' [' + AllToChar(aErro[08]) + ']')
				AutoGrLog("Valor anterior: "             + ' [' + AllToChar(aErro[09]) + ']')
				nI := 0
//		tLaco := .F.

				FOR nI := 1 TO 20
					AutoGrLog("Valor Campo: "             + ' [' + AllToChar(aCampo [nI,1] ) + ']')
				Next nI
	*/

				MostraErro()
//				aAdd(aErroLog, {aCampo [16,1],AllToChar(aErro[04])	, AllToChar(aErro[06])		, nil})
			EndIf
			oModel:DeActivate()
			FreeUsedCode()
		EndIf	
		FT_FSKIP()
//	EndDo
EndIF
/*
Alert('ListErro -- > ' + strZero(LEN(aErroLog),4))
sCl     := chr(13) + CHR(10)
sNomeArq:='\miscelania\erfornece.txt'   //arquivo a gerar texto
If File(sNomeArq)
	Ferase(sNomeArq)
Endif
sHandle:=MsFCreate(SNomeArq)
For nI := 1 To LEN(aErroLog)
	sGrava:= 'Erro Importacao- >' + aErroLog[nI,1] + '-'  + aErroLog[nI,2] + '-' + aErroLog[nI,3] + sCl
	FWrite(sHandle,sGrava,len(sGrava))
Next X
FClose(sHandle)
*/
alert('FINALIZADO')
Return


/**********************************************************************************
* fRotImp6  - Importacao de Produtos                                      *
*********************************************************************************
VERIFICAR - PROBLEMA NA EXPORTACAO 
B1_UNIDADE = ESTA VINDO VAZIA


CAMPOS FALTANTES = B1_TIPO -> PI,PA....
B1_UNIDADE - > NAO TEM
B1_LOCAL   -> LOCAL DE ARMAZENAZEM

ENTENDER ARQUIVO ENVIADO
*/
Static Function fRotImp6()
***************
Local aErroLog		:= {}
Local lDeuCerto   	:= .F.
oModel      := Nil

alert('Inicio Importacao FORNECEDOR - SA2')
sArq := "C:\IMP_ROTA\SB1.TXT"
nA2_LOJA := 0 
DbSelectArea('SB1')
DbSetOrder(1)
DBGOTOP()
if file(sArq)
	If (_nHa := FT_FUse(AllTrim(sArq)))== -1
		msgbox("Arquivo Aberto, Favor Fechar!")
		Return
	EndIf
	nA2_COD  :=0
	tLaco := .T.

	FT_FGOTOP()
//	While !FT_FEOF() .And. tLaco
		sLinha := Alltrim(FT_FREADLN())
		//aCampo := StrTokArr(sLinha, ";")

		aCampo := {}
		While Len(sLinha) > 0 
			nPos := AT(";",sLinha)
			If nPos > 0 
				sCampo := Left(sLinha,nPos - 1)
				sRestL := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := sRestL
			Else
				sCampo := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := ''
			EndIf
			Aadd(aCampo,Alltrim(sCampo) ) 
		EndDo

		//aCampo := StrTokArr(sLinha, ";")

			oModel  := FwLoadModel ("MATA010")
			oModel:SetOperation(3)
			oModel:Activate()
			oModel:SetValue("SB1MASTER","B1_COD"        ,StrZero(Val(aCampo[15]),9)	)
			oModel:SetValue("SB1MASTER","B1_DESC"       ,aCampo[16]   	)
			oModel:SetValue("SB1MASTER","B1_TIPO"       ,'PI'   	        )  //VERIFICAR
			oModel:SetValue("SB1MASTER","B1_UM"     	,aCampo[46]         )  //VERIFICAR
			oModel:SetValue("SB1MASTER","B1_LOCPAD" 	,"01"				)  // VERIFICAR
	 		oModel:SetValue("SB1MASTER","B1_PICM" 		,0					)
			oModel:SetValue("SB1MASTER","B1_IPI" 		,0					)
			oModel:SetValue("SB1MASTER","B1_PESO" 		,1	)   // VERIFICAR
 			oModel:SetValue("SB1MASTER","B1_POSIPI"		,'0'	) // VERIFICAR
			oModel:SetValue("SB1MASTER","B1_ORIGEM"    	,'0'   	) // VERIFICAR
 			oModel:SetValue("SB1MASTER","B1_GRUPO"     	,''   	) // VERIFICAR
			oModel:SetValue("SB1MASTER","B1_MSBLQL"    	,'2'            	)
			oModel:SetValue("SB1MASTER","B1_CONTRAT" 	,"N"				)
			oModel:SetValue("SB1MASTER","B1_LOCALIZ" 	,"N"				)
			oModel:SetValue("SB1MASTER","B1_CODBAR" 	,""					)
			oModel:SetValue("SB1MASTER","B1_IRRF" 		,"N"				)
			oModel:SetValue("SB1MASTER","B1_CONTSOC" 	,"N"				)
			oModel:SetValue("SB1MASTER","B1_MRP" 		,"N"				)
			If oModel:VldData()
				If oModel:CommitData()
					lDeuCerto := .T.
				Else
					lDeuCerto := .F.
				EndIf
			Else
				lDeuCerto := .F.
			EndIf
			If ! lDeuCerto
				aErro := oModel:GetErrorMessage()
				/*
				AutoGrLog("Id do formulário de origem:"  + ' [' + AllToChar(aErro[01]) + ']')
				AutoGrLog("Id do campo de origem: "      + ' [' + AllToChar(aErro[02]) + ']')
				AutoGrLog("Id do formulário de erro: "   + ' [' + AllToChar(aErro[03]) + ']')
				AutoGrLog("Id do campo de erro: "        + ' [' + AllToChar(aErro[04]) + ']')
				AutoGrLog("Id do erro: "                 + ' [' + AllToChar(aErro[05]) + ']')
				AutoGrLog("Mensagem do erro: "           + ' [' + AllToChar(aErro[06]) + ']')
				AutoGrLog("Mensagem da solução: "        + ' [' + AllToChar(aErro[07]) + ']')
				AutoGrLog("Valor atribuído: "            + ' [' + AllToChar(aErro[08]) + ']')
				AutoGrLog("Valor anterior: "             + ' [' + AllToChar(aErro[09]) + ']')
				nI := 0
				FOR nI := 1 TO 10
					AutoGrLog("Valor Campo: "             + ' [' + AllToChar(aCampo [nI,1] ) + ']')
				Next nI
				*/
				aAdd(aErroLog, {StrZero(val(aCampo [1,1]),06)	,AllToChar(aErro[04])	, AllToChar(aErro[06])		, nil})
			EndIf
			oModel:DeActivate()
			FreeUsedCode()
		FT_FSKIP()

//	EndDo
EndIF
/*
Alert('ListErro -- > ' + strZero(LEN(aErroLog),4))
sCl     := chr(13) + CHR(10)
sNomeArq:='\miscelania\erfornece.txt'   //arquivo a gerar texto
If File(sNomeArq)
	Ferase(sNomeArq)
Endif
sHandle:=MsFCreate(SNomeArq)
For nI := 1 To LEN(aErroLog)
	sGrava:= 'Erro Importacao- >' + aErroLog[nI,1] + '-'  + aErroLog[nI,2] + '-' + aErroLog[nI,3] + sCl
	FWrite(sHandle,sGrava,len(sGrava))
Next X
FClose(sHandle)
*/
alert('FINALIZADO')
Return




*********************************
Static Function fTrCarac(sVarRet) // Troca de cartacters
***************
	sVarRet := StrTran(sVarRet,"/","")
	sVarRet := StrTran(sVarRet,".","")
	sVarRet := StrTran(sVarRet,"-","")
Return(sVarRet)



/**********************************************************************************
* fRotImp6  - Importacao de Clientes/Contas a Receber                         *
*********************************************************************************
E1_NATUREZ , Nao informado

*/
Static Function fRotImp7()
***************
Local lMsErroAuto 	:= .f.
oModel      := Nil

alert('Importacao Contas Receber')
Procregua(1252)
sArq := "C:\IMP_ROTA\SE1.TXT"
if file(sArq)
	If (_nHa := FT_FUse(AllTrim(sArq)))== -1
		msgbox("Arquivo Aberto, Favor Fechar!")
		Return
	EndIf
	FT_FGOTOP()
	//While !FT_FEOF() .And. tLaco
        Incproc()
		sLinha := Alltrim(FT_FREADLN())
		sLinha := StrTran(sLinha, "'", "")
		sLinha := StrTran(sLinha, ",", ".")
		sCampo := ''
		aCampo := {}
		While Len(sLinha) > 0 
			nPos := AT(";",sLinha)
			If nPos > 0 
				sCampo := Left(sLinha,nPos - 1)
				steste := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := steste
			Else
				sCampo := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := ''
			EndIf
			Aadd(aCampo,{Alltrim(sCampo)} ) 
		EndDo
		DbSelectArea('SA1')
		DbSetorder(3)
		DbSeek(xFilial('SA1')+aCampo[13] ,.t.)
		If !xFilial('SA1')+aCampo[13] == SA1->A1_FILIAL+Left(SA1->A1_CGC,LEN(aCampo[13]))
			Alert('Cliente Nao Cadastrado! - '+xFilial('SA1')+'/'+aCampo[13] )
		Else	
			aVetSE1 := {}
			aAdd(aVetSE1, {"E1_FILIAL"	,xFilial("SE1") ,Nil})  
			aAdd(aVetSE1, {"E1_NUM"		,STRZERO(VAL(aCampo[4]),9)      ,Nil})   
			aAdd(aVetSE1, {"E1_PREFIXO"	,'IMP'          ,Nil})  
			aAdd(aVetSE1, {"E1_PARCELA"	,''             ,Nil})  //Padl(cDados, 6, '0')
			aAdd(aVetSE1, {"E1_TIPO"    ,'BOL'           ,Nil})
			aAdd(aVetSE1, {"E1_NATUREZ"	,'',Nil})   // VERIFICAR
			aAdd(aVetSE1, {"E1_CLIENTE"	,SA1->A1_COD    ,Nil})  
			aAdd(aVetSE1, {"E1_LOJA"	,SA1->A1_LOJA   ,Nil}) 
			aAdd(aVetSE1, {"E1_NOMCLI"	,SA1->A1_NOME   ,Nil}) 
			aAdd(aVetSE1, {"E1_HIST"	,'IMPORTACAO'   ,Nil}) 
			aAdd(aVetSE1, {"E1_EMISSAO"	,ctod(aCampo[3]) ,Nil}) 
			aAdd(aVetSE1, {"E1_VENCTO"	,ctod(aCampo[11]),Nil}) 
			aAdd(aVetSE1, {"E1_VENCREA"	,DataValida(ctod(aCampo[11]),.T.),Nil}) 
			aAdd(aVetSE1, {"E1_VALOR"	,VAL(aCampo[23]),Nil}) 
			aAdd(aVetSE1, {"E1_MOEDA"	,1              ,Nil}) 
/*
			iF Alltrim(aCampo[4,1]) == 'RA'
				aAdd(aVetSE1, {"CBCOAUTO"	,'CX1' 				,Nil})  
				aAdd(aVetSE1, {"CAGEAUTO"	,'00001'			,Nil})   
				aAdd(aVetSE1, {"CCTAAUTO"	,'0000000001'       ,Nil})  
			EndIf	
*/			
			//Inicia o controle de transação
			Begin Transaction
				//Chama a rotina automática
				lMsErroAuto := .F.
				MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 3)
				If lMsErroAuto
					MostraErro()
					alert(sLinha)
//					if MsgBox ("Deseja Sair do Programa apos o Erro?","Escolha","YESNO")
//						tLaco := .F.
//					EndIf
				EndIf
			End Transaction
		EndIf	
		FT_FSKIP()
	//EndDo
EndIf
alert('acabou')
Return()




/**********************************************************************************
* fRotImp8  - Saldos Iniciais                         *
*********************************************************************************

*/
Static Function fRotImp8()
***************
Local nOpc	      	:= 3
Local nI 			:= 0 
Local lMsErroAuto 	:= .f.
oModel      := Nil

alert('Importacao Contas Receber')
Procregua(1252)
sArq := "C:\IMP_ROTA\SB9.TXT"
cLocPad := '01'
if file(sArq)
	If (_nHa := FT_FUse(AllTrim(sArqSB1)))== -1
		msgbox("Arquivo Aberto, Favor Fechar!")
		Return
	EndIf
	FT_FGOTOP()
	aIniSB9 := {}
	aIniSD5 := {}
	wLaco   := .T.
	While !FT_FEOF() .And. Empty(sMsg)
		sLinha := Alltrim(FT_FREADLN())
		sLinha := StrTran(sLinha, "'", "")
		sLinha := StrTran(sLinha, ",", ".")
		sCampo := ''
		aCampo := {}
		While Len(sLinha) > 0 
			nPos := AT(";",sLinha)
			If nPos > 0 
				sCampo := Left(sLinha,nPos - 1)
				steste := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := steste
			Else
				sCampo := Subs(sLinha,nPos + 1, len(sLinha))
				sLinha := ''
			EndIf
			Aadd(aCampo,Alltrim(sCampo) ) 
		EndDo
		aCampo[1] := StrZero(Val(aCampo[1]),9)
		nPos := aScan(aIniSB9, {|x|x[1]==Alltrim(aCampo[1])})
		If nPos > 0 
			aIniSB9[nPos,3] += Val(aCampo[3])
		Else
			AADD(aIniSB9,{Alltrim(aCampo[1]),cLocPad,Val(aCampo[3]),Val(aCampo[7,1])})
		EndIf
		AADD(aIniSD5,{Alltrim(aCampo[1,1]),cLocPad,STRZERO(VAL(aCampo[4,1]),10),dDataBase,Val(aCampo[6,1]) ,STOD(aCampo[5,1])})
		FT_FSKIP()
	EndDo

	For nI := 1 to Len(aIniSB9)	
		dbSelectArea('SB1')
		dbSetOrder(1)
		dbSeek(xFilial('SB1')+Alltrim(aIniSB9[nI,1]),.t.)
		If xFilial('SB1')+Alltrim(aIniSB9[nI,1]) == SB1->B1_FILIAL + Alltrim(SB1->B1_COD)
			dbSelectArea('SB9')
			dbSetOrder(1)
			dbSeek(xFilial('SB9')+Alltrim(aIniSB9[nI,1]),.t.)
			If !xFilial('SB9')+Alltrim(aIniSB9[nI,1]) == SB9->B9_FILIAL + Alltrim(SB9->B9_COD)
				sB1_COD := ''
				If 	SB1->B1_MSBLQL == '1'
					sB1_COD := SB1->B1_COD
					RecLock("SB1", .F.)
					SB1->B1_MSBLQL := '2'
					MsUnlock("SB1")
				EndIf
				lMsErroAuto := .F.
				aRotAuto := {{"B9_COD",SB1->B1_COD ,NIL},;
				{"B9_LOCAL",cLocPad,NIL},;
				{"B9_QINI" ,aIniSB9[nI,3],NIL},;
				{"B9_VINI1" ,ROUND(aIniSB9[nI,3]*aIniSB9[nI,4],6),NIL}}
				MSExecAuto({|x,y| mata220(x,y)},aRotAuto,3) //Inclusão
				If lMsErroAuto
					MostraErro()
				EndIf
				If !Empty(sB1_COD) 
					RecLock("SB1", .F.)
					SB1->B1_MSBLQL := '1'
					MsUnlock("SB1")
				EndIf
			EndIf
		Else
			Alert(aIniSB9[nI,1] + '- Produto  SB9 Nao Encontrado!')	
		EndIf
	Next nI
	For nI := 1 to Len(aIniSD5)	
		dbSelectArea('SB1')
		dbSetOrder(1)
		dbSeek(xFilial('SB1')+Alltrim(aIniSD5[nI,1]),.t.)
		If xFilial('SB1')+Alltrim(aIniSD5[nI,1]) == SB1->B1_FILIAL + Alltrim(SB1->B1_COD)
			dbSelectArea('SD5')
			dbSetOrder(2)
			dbSeek(xFilial('SD5')+SB1->B1_COD+cLocPad+Alltrim(aIniSD5[nI,3]),.t.)
			If !xFilial('SD5')+SB1->B1_COD+cLocPad+Alltrim(aIniSD5[nI,3]) == SD5->D5_FILIAL + SD5->D5_PRODUTO + SD5->D5_LOCAL + Alltrim(SD5->D5_LOTECTL)
				sB1_COD := ''
				If 	SB1->B1_MSBLQL == '1'
					sB1_COD := SB1->B1_COD
					RecLock("SB1", .F.)
					SB1->B1_MSBLQL := '2'
					MsUnlock("SB1")
				EndIf
				aVetor 			:= {}
				nOpc			:= 3
				lMsErroAuto 	:= .F.
				DbSelectArea("SD5")
				aadd(aVetor,{"D5_PRODUTO" 	,SB1->B1_COD 					,NIL})
				aadd(aVetor,{"D5_LOCAL" 	,cLocPad 						,NIL})
				aadd(aVetor,{"D5_LOTECTL" 	,aIniSD5[nI,3]  					,NIL})
				aadd(aVetor,{"D5_DATA" 		,dDataBase						,NIL})
				aadd(aVetor,{"D5_QUANT" 	,aIniSD5[nI,5]	 				,NIL})
				aadd(aVetor,{"D5_DTVALID" 	,aIniSD5[nI,6]	 				,NIL})
				MSExecAuto({|x,y| Mata390(x,y)},aVetor,nOpc)
				If lMsErroAuto
					MostraErro()
					alert('produto - saldo--' + SB1->B1_COD )
				EndIf
				If !Empty(sB1_COD) 
					RecLock("SB1", .F.)
					SB1->B1_MSBLQL := '1'
					MsUnlock("SB1")
				EndIf
			EndIf
		Else
			Alert(aIniSD5[nI,1] + '- Produto SD5 Nao Encontrado!')	
		EndIf
	Next nI
EndIf
alert('acabou')
return()


**************************
Static Function fRotImp9()
***************
oModel      := Nil

alert('Inicio Importacao Z04')
sArq := "C:\IMP_ROTA\Z04_TXT.TXT"
DbSelectArea('Z04')
if file(sArq)
	If (_nHa := FT_FUse(AllTrim(sArq)))== -1
		msgbox("Arquivo Aberto, Favor Fechar!")
		Return
	EndIf
	FT_FGOTOP()
	While !FT_FEOF() 
		sLinha := Alltrim(FT_FREADLN())
		//aCampo := StrTokArr(sLinha, ";")
		//;Z04_GRUPO;Z04_PATRIM;Z04_CBASE;Z04_INCLUS;Z04_QUANTD;Z04_DESCRI                     ;Z04_BLOQ;Z04_STATUS
		//;1005     ;I         ;11144510 ;45291     ;1         ;JUROS E ENCARGOS CAPITALIZAVEIS;N;

		//Z04_FILIAL + Z04_CBASE

//Z04_GRUPO;Z04_PATRIM;Z04_CBASE;Z04_INCLUS;Z04_QUANTD;Z04_DESCRI;Z04_BLOQ;Z04_STATUS
//2007;I;10889816;31/12/2023;1;PISTAS / TRABALHOS INICIAIS;N;
		aCampo := StrTokArr(sLinha, ";")
		sZ04_GRUPO := aCampo[1]
		sZ04_PATRIM  := aCampo[2]
		sZ04_CBASE  := aCampo[3]
		sZ04_INCLUS  := CTOD(aCampo[4])
		sZ04_QUANTD  := aCampo[5]
		sZ04_DESCRI  := aCampo[6]

		DbSelectArea('Z04')
		DbSetOrder(1)
		DbSeek(xFilial("Z04") + Alltrim(sZ04_CBASE),.T.)
		iF !xFilial("Z04") + Alltrim(sZ04_CBASE) == Z04->Z04_FILIAL + Alltrim(Z04->Z04_CBASE)
			RecLock('Z04', .T.)
				Z04->Z04_FILIAL	 := xFilial('Z04') 
				Z04->Z04_GRUPO 	 := sZ04_GRUPO  
				Z04->Z04_PATRIM	 := sZ04_PATRIM 
				Z04->Z04_CBASE 	 := sZ04_CBASE  
				Z04->Z04_INCLUS	 := sZ04_INCLUS 
				Z04->Z04_QUANTD	 := Val(sZ04_QUANTD )
				Z04->Z04_DESCRI	 := sZ04_DESCRI 
			MsUnlock('Z04')
		EndIf 
		FT_FSKIP()
	EndDo
EndIF
Return()




**************************
Static Function fRotIm10()
***************
oModel      := Nil

alert('Inicio Importacao Z05')
sArq := "C:\IMP_ROTA\Z05_TXT.TXT"
DbSelectArea('Z05')
if file(sArq)
	If (_nHa := FT_FUse(AllTrim(sArq)))== -1
		msgbox("Arquivo Aberto, Favor Fechar!")
		Return
	EndIf
	FT_FGOTOP()
	While !FT_FEOF() 
		sLinha := Alltrim(FT_FREADLN())
		aCampo := StrTokArr(sLinha, ";")
		sZ05_CBASE  := aCampo[2]
		sZ05_CCINVE := aCampo[4]


		DbSelectArea('Z05')
		DbSetOrder(1)
		DbSeek(xFilial("Z05") + PadR( sZ05_CBASE , TAMSX3("Z05_CBASE")[1] ) + Alltrim(sZ05_CCINVE)    ,.T.)
		iF ! xFilial("Z05") + PadR( sZ05_CBASE , TAMSX3("Z05_CBASE")[1] ) + Alltrim(sZ05_CCINVE)  == ;
			Z05->Z05_FILIAL + Z05->Z05_CBASE + Alltrim(Z05->Z05_CCINVE)
			RecLock('Z05', .T.)
				Z05->Z05_FILIAL := xFilial('Z05') 
				Z05->Z05_CBASE  := sZ05_CBASE
				Z05->Z05_CCINVE := sZ05_CCINVE
			MsUnlock('Z05')
		EndIf 
		FT_FSKIP()
	EndDo
EndIF
Return()
