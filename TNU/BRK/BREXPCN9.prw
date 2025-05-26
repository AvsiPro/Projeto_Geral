#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "FWMVCDEF.CH"

//------------------------------------------------------------------------------
/*/{Protheus.doc} BREXPCN9

Programa para exportar contratos da empresa 010101 para a 020101 

@author		Rogério O Candisani
@since		04/03/2023
@version	
/*/
//------------------------------------------------------------------------------

user function BREXPCN9()

Local aContra   := {}
Local aAreaCN9  := GETAREA("CN9")
Local tmpCN9  	:= {}
Local tmpCNA  	:= {}
Local tmpCNB  	:= {}
Local tmpCNC  	:= {}
Local tmpCNN  	:= {}
Local tmpCPD  	:= {}
Local cContrato := ""
Local x         := 0 

Private aCab    := {} 
Private aPlan   := {} 
Private aItPlan := {}
Private aCron   := {}
Private aCli    := {}

aTmp	 	:= {}

//montar query para pegar informações do contrato 
tmpCN9:=GetNextAlias()

/* tabelas envolvidas no contrato CN9
CN9 – contratos
CNA – cabeçalho planilhas contratos
CNB – itens planilhas contratos
CNC – fornec / clientes X contratos
CNN – amarração usuário x contrato
CPD – amarração filial x contrato
*/

BeginSql Alias tmpCN9
SELECT CN9_FILIAL, CN9_TPCTO, CN9_DESC, CN9_DTINIC, CN9_NUMERO, CN9_DTASSI, CN9_UNVIGE, CN9_VIGE, CN9_DTFIM ,;
CN9_ASSINA, CN9_MOEDA, CN9_CONDPG, CN9_VLINI, CN9_VLATU, CN9_FLGREJ, CN9_INDICE, CN9_REVISA, CN9_FLGCAU,;
CN9_TPCAUC, CN9_MINCAU, CN9_TIPREV, CN9_SALDO, CN9_CODCLA, CN9_DTREV, CN9_VLREAJ, CN9_DTUST, CN9_SITUAC,;
CN9_VLDCTR, CN9_FILORI, CN9_ESPCTR, CN9_FILCTR, CN9_NATURE, CN9_PERI, CN9_UNPERI, CN9_MODRJ, CN9_PRORAT,;
CN9_PROXRJ, CN9_XCODCL, CN9_XLOJCL, CN9_XNOMCL, CN9_XREDCL
FROM %table:CN9% CN9
WHERE  %xFilial:CN9% = '0101001'  
		AND  CN9_NRCONT =  %exp:cContrato%
		AND GW2.%NotDel%
EndSql

DbSelectArea(tmpCN9)
DbGoTop()
While !EOF()

	AADD(aCab,{(tmpCN9)->CN9_FILIAL,;
				(tmpCN9)->CN9_TPCTO,;
				(tmpCN9)->CN9_DESC,;
				(tmpCN9)->CN9_DTINIC,;
				(tmpCN9)->CN9_NUMERO,;
				(tmpCN9)->CN9_DTASSI,;
				(tmpCN9)->CN9_UNVIGE,;
				(tmpCN9)->CN9_VIGE,;
				(tmpCN9)->CN9_DTFIM,;
				(tmpCN9)->CN9_ASSINA,;
				(tmpCN9)->CN9_MOEDA,;
				(tmpCN9)->CN9_CONDPG,;
				(tmpCN9)->CN9_VLINI,;
				(tmpCN9)->CN9_VLATU,;
				(tmpCN9)->CN9_FLGREJ,;
				(tmpCN9)->CN9_INDICE,;
				(tmpCN9)->CN9_REVISA,;
				(tmpCN9)->CN9_FLGCAU,;
				(tmpCN9)->CN9_TPCAUC,;
				(tmpCN9)->CN9_MINCAU,;
				(tmpCN9)->CN9_TIPREV,;
				(tmpCN9)->CN9_SALDO,;
				(tmpCN9)->CN9_CODCLA,;
				(tmpCN9)->CN9_DTREV,;
				(tmpCN9)->CN9_VLREAJ,;
				(tmpCN9)->CN9_DTUST,;
				(tmpCN9)->CN9_SITUAC,;
				(tmpCN9)->CN9_VLDCTR,;
				(tmpCN9)->CN9_FILORI,;
				(tmpCN9)->CN9_ESPCTR,;
				(tmpCN9)->CN9_FILCTR,;
				(tmpCN9)->CN9_NATURE,;
				(tmpCN9)->CN9_PERI,;
				(tmpCN9)->CN9_UNPERI,;
				(tmpCN9)->CN9_MODRJ,;
				(tmpCN9)->CN9_PRORAT,;
				(tmpCN9)->CN9_PROXRJ,;
				(tmpCN9)->CN9_XCODCL,;
				(tmpCN9)->CN9_XLOJCL,;




, , , CN9_XNOMCL, CN9_XREDCL
				
				 ,; 		
				})



	dBSkip()


Enddo 



/*
For x := 1 to len(aContra)
	cContra := ""
	DbSelectArea("CN9")
	DbSetOrder(1)
	If !CN9->(DbSeek(xFilial("CN9")+Alltrim(aContra[nCount,4])))

		aCab := {}
		AADD(aCab,aContra[nCount])
		cContra := Alltrim(aContra[nCount,4])

		aTmp1	 := {}
		aPlan    := {}
		nY := 0
		cArqPlan	:= "\import/CNA.csv" 
		

		FT_FUSE(cArqPlan)
		FT_FGOTOP()

		while !FT_FEOF(cArqPlan) 
			nY++
			cLinha := FT_FREADLN()
 			aAdd(aTmp1,Separa(cLinha,";",.T.))

			If Alltrim(aTmp1[nY,3]) == cContra

				AADD(aPlan,aTmp1[nY])

			EndIf
			FT_FSKIP()
		EndDo	


		aTmp2	 	:= {}
		aItPlan     := {}
		nY := 0
		cArqItP	:= "\import/CNB.csv" 
		

		FT_FUSE(cArqItP)
		FT_FGOTOP()

		while !FT_FEOF(cArqItP) 
			nY++
			cLinha := FT_FREADLN()
 			aAdd(aTmp2,Separa(cLinha,";",.T.))

			If Alltrim(aTmp2[nY,12]) == cContra

				AADD(aItPlan,aTmp2[nY])

			EndIf
			FT_FSKIP()
		EndDo	



		aTmp3	 := {}
		aCli     := {}
		nY := 0
		cArqCli	:= "\import/CNC.csv" 
		

		FT_FUSE(cArqCli)
		FT_FGOTOP()

		while !FT_FEOF(cArqCli) 
			nY++
			cLinha := FT_FREADLN()
 			aAdd(aTmp3,Separa(cLinha,";",.T.))

			If Alltrim(aTmp3[nY,3]) == cContra

				AADD(aCli,aTmp3[nY])

				EXIT
				Loop

			EndIf
			FT_FSKIP()
		EndDo	

		aCron     := {}
		/*aTmp4	 	:= {}
		
		nY := 0
		cArqCro	:= "import/cnf.csv" 
		

		FT_FUSE(cArqCro)
		FT_FGOTOP()

		while !FT_FEOF(cArqCro) 
			nY++
			cLinha := FT_FREADLN()
 			aAdd(aTmp4,Separa(cLinha,";",.T.))

			If Alltrim(aTmp4[nY,4]) == cContra

				AADD(aCron,aTmp4[nY])

			EndIf
			FT_FSKIP()
		EndDo*/


		U_CN300AUTO(aCab,aPlan,aItPlan,aCli,aCron)
	
	EndIf
	
	
Next nCount	
CN9->(DbCloseArea())
RESTAREA(aAreaCN9)

Return 

//------------------------------------------------------------------------------
/*/{Protheus.doc} CN300IMP

Programa para importar os contratos via MVC 

@author		Rogério O Candisani
@since		04/03/2023
@version	
/*/
//------------------------------------------------------------------------------

User Function CN300IMP(aCab,aPlan,aItPlan,aCli,aCron)

Local aErro := {}

Local oModel    := FWLoadModel("CNTA301") //Carrega o modelo
Local nNx
Local nNp
Local cNomRed := ""

//cContrat := CN300NUM()
 
oModel:SetOperation(MODEL_OPERATION_INSERT) // Seta operação de inclusão
 
oModel:Activate() // Ativa o Modelo

cDtIni := ctod(Alltrim(aCab[1][5]))
nVig   := Val(Alltrim(aCab[1][8])) 
dDataFim := MonthSum(cDtIni,nVig)

//ctod(Alltrim(aCab[1][9]))

DbSelectArea("SA1")
DbSetOrder(1)
If SA1->(DbSeek(xFilial("SA1")+Alltrim(aCli[1][4])+Alltrim(aCli[1][5])))

	cNomRed := Alltrim(SA1->A1_NREDUZ)
	cNomCli := Alltrim(SA1->A1_NOME)

EndIf
 
//Cabeçalho do contrato
oModel:SetValue( 'CN9MASTER'    , 'CN9_FILIAL'  , Alltrim(aCab[1][2])         )
oModel:SetValue( 'CN9MASTER'    , 'CN9_DTINIC'  , ctod(Alltrim(aCab[1][5]))   )
oModel:SetValue( 'CN9MASTER'    , 'CN9_NUMERO'  , Alltrim(aCab[1][4])         )
oModel:SetValue( 'CN9MASTER'    , 'CN9_ESPCTR'  , Alltrim(aCab[1][23])        )
oModel:SetValue( 'CN9MASTER'    , 'CN9_UNVIGE'  , Alltrim(aCab[1][7])         )
oModel:SetValue( 'CN9MASTER'    , 'CN9_VIGE'    , Val(Alltrim(aCab[1][8]))    )
oModel:SetValue( 'CN9MASTER'    , 'CN9_MOEDA'   , Alltrim(aCab[1][11])        )
oModel:SetValue( 'CN9MASTER'    , 'CN9_TPCTO'   , Alltrim(aCab[1][3])         )
oModel:SetValue( 'CN9MASTER'    , 'CN9_CONDPG'  , Alltrim(aCab[1][12])        )
oModel:SetValue( 'CN9MASTER'    , 'CN9_DTFIM'   , dDataFim                    ) 
oModel:SetValue( 'CN9MASTER'    , 'CN9_CODOBJ'  , Alltrim(aCab[1][13])        )
oModel:SetValue( 'CN9MASTER'    , 'CN9_FLGREJ'  , Alltrim(aCab[1][16])        )
oModel:SetValue( 'CN9MASTER'    , 'CN9_INDICE'  , Alltrim(aCab[1][17])        )
oModel:SetValue( 'CN9MASTER'    , 'CN9_CODJUS'  , Alltrim(aCab[1][19])        )
oModel:SetValue( 'CN9MASTER'    , 'CN9_CODCLA'  , Alltrim(aCab[1][20])        )
oModel:SetValue( 'CN9MASTER'    , 'CN9_SITUAC'  , Alltrim(aCab[1][21])        )
oModel:SetValue( 'CN9MASTER'    , 'CN9_VLDCTR'  , Alltrim(aCab[1][22])        )
oModel:SetValue( 'CN9MASTER'    , 'CN9_NATURE'  , Alltrim(aCab[1][24])        )
oModel:SetValue( 'CN9MASTER'    , 'CN9_DTASSI'  , ctod(Alltrim(aCab[1][6]))   )
oModel:SetValue( 'CN9MASTER'    , 'CN9_ASSINA'  , ctod(Alltrim(aCab[1][10]))  )
oModel:SetValue( 'CN9MASTER'    , 'CN9_XCODCL'  , Alltrim(aCli[1][4]))
oModel:SetValue( 'CN9MASTER'    , 'CN9_XLOJCL'  , Alltrim(aCli[1][5]))
oModel:SetValue( 'CN9MASTER'    , 'CN9_XNOMCL'  , cNomCli           )
oModel:SetValue( 'CN9MASTER'    , 'CN9_XREDCL'  , cNomRed           )
oModel:SetValue( 'CN9MASTER'    , 'CN9_XDTANI'  , ctod(Alltrim(aCab[1][31])))
oModel:SetValue( 'CN9MASTER'    , 'CN9_XPRDIS'  , Alltrim(aCab[1][26]))
//oModel:SetValue( 'CN9MASTER'    , 'CNB_XHISRJ'  , ) 
//oModel:SetValue( 'CN9MASTER'    , 'CN9_PROXRJ'  , ctod(Alltrim(aCab[1][25]))  )


//Cliente/Fornecedor do Contrato
oModel:SetValue( 'CNCDETAIL'    , 'CNC_CLIENT'   , Alltrim(aCli[1][4])   )
oModel:SetValue( 'CNCDETAIL'    , 'CNC_LOJACL'   , Alltrim(aCli[1][5])     )

//cItemP := '000' 
//Planilhas do Contrato
 For nNx := 1 to len(aPlan)

	If nNx > 1 
		//Cliente/Fornecedor do Contrato
		oModel:SetValue( 'CNCDETAIL'    , 'CNC_CLIENT'   , Alltrim(aCli[1][4])   )
		oModel:SetValue( 'CNCDETAIL'    , 'CNC_LOJACL'   , Alltrim(aCli[1][5])     )
		oModel:GetModel('CNADETAIL'):AddLine()
	Endif

	////ctod(Alltrim(aPlan[nNx,11]))
	
	oModel:LoadValue(   'CNADETAIL'     , 'CNA_CONTRA'  , Alltrim(aPlan[nNx,3])  )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_NUMERO'  , Alltrim(aPlan[nNx,4])  )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_CLIENT'  , Alltrim(aPlan[nNx,5])  )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_LOJACL'  , Alltrim(aPlan[nNx,6])  )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_TIPPLA'  , Alltrim(aPlan[nNx,10]) )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_FLREAJ'  , Alltrim(aPlan[nNx,13]) )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_DTINI'   , ctod(Alltrim(aPlan[nNx,7])))
	oModel:SetValue(    'CNADETAIL'     , 'CNA_VLTOT'   , Val(StrTran(StrTran(Alltrim(aPlan[nNx,8]),'.',''),',','.')) )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_SALDO'   , Val(StrTran(StrTran(Alltrim(aPlan[nNx,9]),'.',''),',','.')) )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_DTFIM'   , dDataFim  ) 
	oModel:SetValue(    'CNADETAIL'     , 'CNA_CRONOG'  , Alltrim(aPlan[nNx,12])     )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_INDICE'  , Alltrim(aPlan[nNx,14])     ) 
	oModel:SetValue(    'CNADETAIL'     , 'CNA_PROXRJ'  , ctod(Alltrim(aPlan[nNx,15]))     ) 
		


	For nNp := 1 to len(aItPlan)

		

		If Alltrim(aItPlan[nNp,3]) == Alltrim(aPlan[nNx,4])
			//cItemP := Soma1(cItemP)
		
			If Val(Alltrim(aItPlan[nNp,4])) > 1  
				oModel:GetModel('CNBDETAIL'):AddLine()
			Endif
			
			//Itens da Planilha do Contrato
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_NUMERO'      , Alltrim(aItPlan[nNp,3]) )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_ITEM'        , Alltrim(aItPlan[nNp,4]) )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_PRODUT'      , Alltrim(aItPlan[nNp,5]) )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_DESCRI'      , Alltrim(aItPlan[nNp,6]) )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_UM'          , Alltrim(aItPlan[nNp,7]) )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_XQMIN'       , Val(StrTran(StrTran(Alltrim(aItPlan[nNp,8]),'.',''),',','.'))   )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_QUANT'       , Val(StrTran(StrTran(Alltrim(aItPlan[nNp,9]),'.',''),',','.'))   )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_VLUNIT'      , Val(StrTran(StrTran(Alltrim(aItPlan[nNp,10]),'.',''),',','.'))  ) 
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_VLTOT'       , Val(StrTran(StrTran(Alltrim(aItPlan[nNp,11]),'.',''),',','.'))  )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_DTCAD'       , ctod(Alltrim(aItPlan[nNp,13])) )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_CONTA'       , Alltrim(aItPlan[nNp,14])        )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_SLDMED'      , Val(StrTran(StrTran(Alltrim(aItPlan[nNp,15]),'.',''),',','.'))  )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_TS'          , Alltrim(aItPlan[nNp,16])       )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_INDICE'      , Alltrim(aItPlan[nNp,17])       )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_TABPRC'      , Alltrim(aItPlan[nNp,18])       )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_PROXRJ'      , ctod(Alltrim(aItPlan[nNp,19])) )
			oModel:SetValue( 'CNBDETAIL'    , 'CNB_XHISRJ'      , Alltrim(aItPlan[nNp,21])       )
	
		EndIf		
	Next nNp
		

Next nNx



cItem := '000' 
//Cronograma Financeiro

oModel:GetModel('CNFDETAIL'):SetNoInserLine(.F.)
oModel:GetModel('CNFDETAIL'):SetNoUpdateLine(.F.)
For nNx := 1 to len(aCron)
		
	cItem := Soma1(cItem)
		
	If cItem <> '001'  
		oModel:GetModel('CNFDETAIL'):AddLine()
	EndIf		
 
 
	oModel:LoadValue( 'CNFDETAIL'   , 'CNF_NUMERO'  , Alltrim(aCron[nNx,3])  )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_PARCEL'  , Alltrim(aCron[nNx,5])  )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_COMPET'  , Alltrim(aCron[nNx,6])  )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_VLPREV'  , Val(StrTran(StrTran(Alltrim(aCron[nNx,7]),'.',''),',','.'))  )                                
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_SALDO'   , Val(StrTran(StrTran(Alltrim(aCron[nNx,8]),'.',''),',','.'))  ) 
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_DTVENC'  , Ctod(Alltrim(aCron[nNx,9]))  )                 
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_PRUMED'  , Ctod(Alltrim(aCron[nNx,10]))   )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_MAXPAR'  , Alltrim(aCron[nNx,11])  )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_TXMOED'  , Val(StrTran(StrTran(Alltrim(aCron[nNx,12]),'.',''),',','.'))  )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_PERIOD'  , Alltrim(aCron[nNx,13])  )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_DIAPAR'  , Alltrim(aCron[nNx,14])  )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_NUMPLA'  , Alltrim(aCron[nNx,15])  )

 Next nNx

 
//Validação e Gravação do Modelo
If oModel:VldData()
	oModel:CommitData()

	//U_CN300SITU(Alltrim(aCab[1][4]))

Else
	aErro := oModel:GetErrorMessage()
    Alert('Erro: Contrato: '+Alltrim(aCab[1][4]) + AllToChar( aErro[6] + ' '+ AllToChar( aErro[4] + Dtoc(DATE())+' - '+Time())))
Endif           
	
 
Return 
