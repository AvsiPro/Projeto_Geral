#include "tbiconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT40C    บAutor  ณJackson E. de Deusบ Data ณ  03/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Replica os lancamentos da SZ5 para SD3                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFAT40C()

Local nModo := 2

Prepare Environment Empresa "01" Filial "01"

If nModo == 1
	ReplUnit()
Else 
	ReplAgrp()
EndIf

Reset Environment

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT40C  บAutor  ณMicrosiga           บ Data ณ  11/30/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReplUnit()


Local cQuery := ""
Local lGrava := .F.

//cQuery := "SELECT SZ5.R_E_C_N_O_ RECZ5, SD3.R_E_C_N_O_ RECD3 FROM SZ5010 SZ5 WITH (NOLOCK)"
cQuery := "SELECT SZ5.R_E_C_N_O_ RECZ5, Z5_DOC  FROM SZ5010 SZ5 WITH (NOLOCK)"
//cQuery += " LEFT JOIN SD3010 SD3 WITH (NOLOCK) ON D3_FILIAL = Z5_FILIAL AND D3_XDOCSZ5 = Z5_DOC "
cQuery += " WHERE Z5_ORIGEM = 'TTPROC25'"
//cQuery += " AND Z5_EMISSAO >= '"+DtoS(FirstDay(Date()))+"' AND Z5_EMISSAO > '"+DTOS(GETMV("MV_ULMES"))+"' "
cQuery += " AND Z5_EMISSAO BETWEEN '20161230' AND '20170104' "
cQuery += " AND Z5_TRANSF = 'N' AND SZ5.D_E_L_E_T_ = '' " 
cQuery += " AND Z5_NUMOS <> '000000000249868' "
cQuery += " ORDER BY Z5_EMISSAO "

MPSysOpenQuery( cQuery , "TRBZ" )  

dbSelectArea("TRBZ")
While !EOF()
	lGrava := .F.
	cQuery2 := "SELECT R_E_C_N_O_ RECD3 FROM SD3010 WHERE D3_XDOCSZ5 = '"+TRBZ->Z5_DOC+"' AND D_E_L_E_T_ = '' "
	MPSYSOPENQUERY( cQuery2,"TRBY" )
	dbSelectArea("TRBY")
	If EOF()	
		//If Empty(TRBZ->RECD3)
			dbSelectArea("SZ5")
			dbGoTo(TRBZ->RECZ5)
			SLEEP(200)
			conout("#REPLICANDO LANCAMENTO SZ5 -> " +SZ5->Z5_DOC)
			lGrava := U_MAT240(SZ5->Z5_LOCAL,SZ5->Z5_COD,SZ5->Z5_TM,SZ5->Z5_EMISSAO,SZ5->Z5_QUANT,SZ5->Z5_NUMOS,SZ5->Z5_MOLA,SZ5->Z5_OBS,SZ5->Z5_ORIGEM,SZ5->Z5_CHAPA,SZ5->Z5_TIPO,.T.,SZ5->Z5_DOC )	
			dbSelectArea("SZ5")  
			If RecLock("SZ5",.F.)
				SZ5->Z5_TRANSF := IIF( lGrava,"S","X" )
				MsUnLock()
			EndIf
		//EndIf
	Else
		dbSelectArea("SZ5")
		dbGoTo(TRBZ->RECZ5)
		If SZ5->Z5_TRANSF == "N"
			RecLock("SZ5",.F.)
			SZ5->Z5_TRANSF := "S"
			MsUnLock()
		EndIf	
	EndIf
	
	dbSelectArea("TRBZ")
	TRBZ->(dbSkip())
End

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT40C  บAutor  ณMicrosiga           บ Data ณ  11/30/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReplAgrp( nOpc )

Local cQuery1 := ""
Local cQuery2 := ""
Local nTotRota := 0
Local nTotResid := 0
Local aMov := {}
Local nPos := 0
Local aRecnos := {}
Local nI,nJ
Local lOk := .F.
Default nOpc := 1

// Movimentos da Rota
/*
cQuery1 := "SELECT Z5_EMISSAO,Z5_LOCAL, Z5_COD, Z5_TM, Z5_QUANT, R_E_C_N_O_ Z5REC FROM SZ5010 SZ5 WITH (NOLOCK) "
//--LEFT JOIN SD3010 SD3 WITH (NOLOCK) ON D3_FILIAL = Z5_FILIAL AND D3_XDOCSZ5 = Z5_DOC 
cQuery1 += " WHERE Z5_ORIGEM = 'TTPROC25' "
cQuery1 += " AND Z5_EMISSAO >= '"+DtoS(FirstDay(Date()))+"' " 
cQuery1 += " AND Z5_EMISSAO > '"+DTOS(GETMV("MV_ULMES"))+"' "
cQuery1 += " AND Z5_TRANSF = 'N' "
cQuery1 += " AND SZ5.D_E_L_E_T_ = '' "
cQuery1 += " AND SUBSTRING(Z5_LOCAL,1,1) = 'R' "
//cQuery1 += " GROUP BY Z5_EMISSAO,Z5_LOCAL, Z5_COD, Z5_TM "

cQuery1 += " UNION ALL "

cQuery1 += " SELECT Z5_EMISSAO,Z5_LOCAL, Z5_COD, Z5_TM, Z5_QUANT, R_E_C_N_O_ Z5REC FROM SZ5010 SZ5 WITH (NOLOCK) "
//--LEFT JOIN SD3010 SD3 WITH (NOLOCK) ON D3_FILIAL = Z5_FILIAL AND D3_XDOCSZ5 = Z5_DOC 
cQuery1 += " WHERE Z5_ORIGEM = 'TTPROC25' "
cQuery1 += " AND Z5_EMISSAO >= '"+DtoS(FirstDay(Date()))+"' "
cQuery1 += " AND Z5_EMISSAO > '"+DTOS(GETMV("MV_ULMES"))+"' "
cQuery1 += " AND Z5_TRANSF = 'N' "
cQuery1 += " AND SZ5.D_E_L_E_T_ = '' "
cQuery1 += " AND SUBSTRING(Z5_LOCAL,1,1) IN ( 'P' ) "
//cQuery1 += " GROUP BY Z5_EMISSAO,Z5_LOCAL, Z5_COD, Z5_TM "
cQuery1 += " ORDER BY Z5_EMISSAO,Z5_LOCAL,Z5_COD "
*/

cQuery1 += " SELECT Z5_EMISSAO,Z5_LOCAL, Z5_COD, Z5_TM, Z5_QUANT, R_E_C_N_O_ Z5REC FROM SZ5010 SZ5 WITH (NOLOCK) "
cQuery1 += " WHERE Z5_ORIGEM IN ( 'TTPROC25','TTPROC57') "
cQuery1 += " AND Z5_EMISSAO >= '"+DtoS(FirstDay(Date()))+"' "
//cQuery1 += " AND Z5_EMISSAO > '"+DTOS(GETMV("MV_ULMES"))+"' "
cQuery1 += " AND Z5_EMISSAO >= '20170101' "
cQuery1 += " AND Z5_TRANSF = 'N' "
cQuery1 += " AND SZ5.D_E_L_E_T_ = '' "
cQuery1 += " AND SUBSTRING(Z5_LOCAL,1,1) IN ( 'P' ) "
cQuery1 += " ORDER BY Z5_EMISSAO,Z5_LOCAL,Z5_COD "

/*
// Movimentos dos Residentes
cQuery2 := "SELECT Z5_EMISSAO,Z5_LOCAL, Z5_COD, Z5_TM, Z5_QUANT FROM SZ5010 SZ5 WITH (NOLOCK) "
//--LEFT JOIN SD3010 SD3 WITH (NOLOCK) ON D3_FILIAL = Z5_FILIAL AND D3_XDOCSZ5 = Z5_DOC 
cQuery2 += " WHERE Z5_ORIGEM = 'TTPROC25' "
cQuery2 += " AND Z5_EMISSAO >= '"+DtoS(FirstDay(Date()))+"' "
cQuery2 += " AND Z5_EMISSAO > '"+DTOS(GETMV("MV_ULMES"))+"' "
cQuery2 += " AND Z5_TRANSF = 'N' "
cQuery2 += " AND SZ5.D_E_L_E_T_ = '' "
cQuery2 += " AND SUBSTRING(Z5_LOCAL,1,1) IN ( 'A' ) "

cQuery2 += " GROUP BY Z5_EMISSAO,Z5_LOCAL, Z5_COD, Z5_TM "
cQuery2 += " ORDER BY Z5_EMISSAO,Z5_TM "
*/
// Tudo
If nOpc == 1 
	MPSysOpenQuery( cQuery1, "TRBZ1" )

	//MPSysOpenQuery( cQuery2, "TRBZ2" ) 
	//nTotRota := TRBZ1->(LASTREC())
	//Conout( "MOVIMENTOS: " +cvaltochar(nTotRota) )
	//Conout( "MOVIMENTOS RESIDENTES: " +cvaltochar(nTotResid) )
	
	
	dbSelectArea("TRBZ1")
	While TRBZ1->(!EOF())
	    
	    nPos := Ascan( aMov, { |x| x[1] == TRBZ1->Z5_EMISSAO .And. x[2] == TRBZ1->Z5_LOCAL .And. x[3] == TRBZ1->Z5_COD .And. x[4] == TRBZ1->Z5_TM } )
	    If nPos == 0
	    	AADD( aMov, { TRBZ1->Z5_EMISSAO,TRBZ1->Z5_LOCAL,TRBZ1->Z5_COD, TRBZ1->Z5_TM,TRBZ1->Z5_QUANT, { TRBZ1->Z5REC } } )
	    Else
	    	aMov[nPos][5] += TRBZ1->Z5_QUANT
	    	AADD( aMov[nPos][6], TRBZ1->Z5REC  )
	    EndIf
	    	
		TRBZ1->( dbSkip() )
	End
	    
	CONOUT("TOTAL DE MOVIMENTOS: " +cvaltochar(Len(aMov)))
	For nI := 1 To Len( aMov )
		lOk := .F.
		// verificar se movimento na foi feito na SD3
		dbSelectArea("SB2")
		dbSetOrder(1)
		If !MSSeek( xFilial("SB2") +AvKey(aMov[nI][3],"B2_COD") +AvKey(aMov[nI][2],"B2_LOCAL") )
			CriaSB2( aMov[nI][3],aMov[nI][2] )
		EndIf
		
		lOk := MovSd3( STOD(aMov[nI][1]), aMov[nI][2], aMov[nI][3], aMov[nI][4], aMov[nI][5], "MOV ARMAZEM", "TTFAT40C" )
		If lOk
			CONOUT("MOVIMENTO SD3 - OK")              
			
			aRecnos := Aclone( aMov[nI][6] )
			dbSelectArea("SZ5")
			For nRecno := 1 To Len( aRecnos )
				dbGoTo( aRecnos[nRecno] )
				If RecLock("SZ5",.F.)
					SZ5->Z5_TRANSF := "S"
					MsUnLock()
				EndIf                      
			Next nRecno
		Else
			CONOUT("MOVIMENTO SD3 - ERRO")
		EndIf
	Next nI
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT40C  บAutor  ณMicrosiga           บ Data ณ  11/30/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MovSd3( dEmissao, cArmazem, cProduto, cTM, nQuant, cObs, cOrigem )

Local lOk := .T.
Local aMat240 := {}
Private lMsErroAuto := .F.

aMat240 := {} 
Aadd(aMat240, {'D3_FILIAL' , xFilial("SD3")	,Nil})
Aadd(aMat240, {'D3_TM'     , cTM			,Nil})
Aadd(aMat240, {'D3_COD'    , cProduto		,Nil})
Aadd(aMat240, {'D3_QUANT'  , nQuant			,Nil})
Aadd(aMat240, {'D3_LOCAL'  , cArmazem		,Nil})
Aadd(aMat240, {'D3_EMISSAO', dEmissao		,Nil})
Aadd(aMat240, {'D3_XORIGEM', cOrigem		,Nil})
Aadd(aMat240, {'D3_OBSQUAL', cObs			,Nil})

dbSelectArea("SB2")
dbSetOrder(1)
	                                                             
MSExecAuto( {|x,y| mata240(x,y)},aMat240,3 )
If lMsErroAuto
	lOk := .F.
EndIf          

Return lOk