#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMXML003    บAutor  ณJackson E. de Deus บ Data ณ  08/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Separa os dados do xml de acordo com o form e processa	  บฑฑ
ฑฑบ          ณ                                     						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MXML003(cNumeroOS)

Local aDadosOS := {}
Local cForm := ""

If cEmpAnt <> "01"
	Return
EndIf

dbSelectArea("SZG")
dbSetOrder(1)
If !MsSeek( xFilial("SZG") +AvKey(cNumeroOS,"ZG_NUMOS") )
	Return
EndIf

cForm := AllTrim(SZG->ZG_FORM)
aDadosOS := U_MXML000(SZG->ZG_RESPOST)

// conferencia cega
If cForm == "01"
	ExecFrm1(cNumeroOS,aDadosOS)

// leitura/sangria
ElseIf cForm == "02" .OR. cForm == "03"
	ExecFrm2(cNumeroOS,aDadosOS)
	
// abastecimento	
ElseIf cForm == "04" .OR. cForm == "08"
	ExecFrm4(cNumeroOS,aDadosOS)
    	
// entrega
ElseIf cForm == "13"
	ExecFrm13(cNumeroOS,aDadosOS)

// manutencao / instalacao / remocao
ElseIf cForm == "06" .Or. cForm == "16" .Or. cForm == "17"
	ExecFrm6(cNumeroOS,aDadosOS)
EndIf			  
			
Return      
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecFrm1   บAutor  ณMicrosiga           บ Data ณ  06/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExecFrm1(cNumeroOS,aDadosOS)

dbSelectArea("SZG")
dbSetOrder(1)
If !MsSeek( xFilial("SZG") +AvKey(cNumeroOS,"ZG_NUMOS") )
	Return
EndIf

U_TTPROC36(SZG->ZG_DOC,SZG->ZG_SERIE,SZG->ZG_CLIFOR,SZG->ZG_LOJA,aDadosOS)

dbSelectArea("SZG")
RecLock("SZG",.F.)
SZG->ZG_PROC := "BR_VERDE"
MsUnLock() 


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecFrm2   บAutor  ณMicrosiga           บ Data ณ  06/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExecFrm2(cNumeroOS,aDadosOS,cForm)

Local aProc := {}
Local aLeitura := {}
Local aSangria := {}
Local nI
Local nJ
Local aSZN	:= {}
Local nTotSel := 0
Local nTotCash := 0
Local nParcial := 0
Local nTeste := 0
Local nNumAnt := 0
Local nTpPrc := 0
Local nPos := 0
Local cGlenvie := ""
Local cGlenvre := ""
Local clacrcof := ""
Local clacccof := ""
Local clacrced := ""
Local claccced := ""
Local clacrmoe := ""
Local claccmoe := ""
Local nTroco := 0
Local nQtd5 := 0 
Local nQtd10 := 0
Local nQtd25 := 0
Local nQtd50 := 0
Local nQtd100 := 0
Local cbanana := ""   
Local cpos := ""
Local clog1 := ""
Local clog2 := ""
Local clog3 := ""
Local clog4 := ""
Local clog5 := ""
Local cP	:= ""
Local cMsgErro := ""
Local lSendMail := .F.
Local lAbast := .F. 
Default cForm := ""

 
dbSelectArea("SZG")
dbSetOrder(1)
If !MsSeek( xFilial("SZG") +AvKey(cNumeroOS,"ZG_NUMOS") )
	Return
EndIf


If AllTrim(SZG->ZG_FORM) == "04" .OR. AllTrim(SZG->ZG_FORM) == "08"
	lAbast := .T.
EndIf 

If !lAbast
	cForm := AllTrim(SZG->ZG_FORM)
EndIf

      
For nI := 1 To Len(aDadosOS)
	If aDadosOS[nI][1] == "LEITURA"
		For nJ := 2 To Len(aDadosOS[nI])
			If aDadosOS[nI][nJ][1] == "CHKMAILCLI"  
				AADD( aLeitura, { aDadosOS[nI][nJ][1], IIF(aDadosOS[nI][nJ][2]=="S",.T.,.F.) } ) 
			Else 
				AADD( aLeitura, { aDadosOS[nI][nJ][1], Val(aDadosOS[nI][nJ][2])  } ) 
			EndIf
		Next nJ
		
		For nJ := 1 To Len( aLeitura )
			If aLeitura[nJ][1] == "CONT_TOTSALE"
				nTotSel := aLeitura[nJ][2]
			ElseIf aLeitura[nJ][1] == "CONT_TOTCASH"
				nTotCash := aLeitura[nJ][2]
			ElseIf aLeitura[nJ][1] == "CONT_PARCIAL"
				nParcial := aLeitura[nJ][2]
			ElseIf aLeitura[nJ][1] == "CONT_TESTES"
				nTeste := aLeitura[nJ][2]
			ElseIf aLeitura[nJ][1] == "CHKMAILCLI"
				lSendMail := aLeitura[nJ][2]
			EndIf
		Next nJ
			
	ElseIf aDadosOS[nI][1] == "SANGRIA"
		For nJ := 2 To Len(aDadosOS[nI])
			AADD( aSangria, { aDadosOS[nI][nJ][1], aDadosOS[nI][nJ][2]  } )
		Next nJ
	EndIf
Next nI	
	
// leitura    
If cForm == "02" .And. !Empty(aLeitura)
	// obtem o numerador anterior
	nNumAnt := U_TTPROG02(SZG->ZG_PATRIM)
  	If Valtype(nNumAnt) == "C" 
  		nNumAnt := Val(nNumAnt)
  	EndIf
  		nTpPrc := 2
		aSZN := { {	"ZN_NUMOS"		, cNumeroOS			},;
			{	"ZN_TIPINCL"	, "ABASTEC"			},;
			{	"ZN_NUMANT"		, nNumAnt			},;
			{	"ZN_AGENTE"		, SZG->ZG_AGENTE	},;
			{	"ZN_CLIENTE"	, SZG->ZG_CLIFOR	},;
			{	"ZN_LOJA"		, SZG->ZG_LOJA 		},;
			{	"ZN_DATA"		, SZG->ZG_DATAFIM	},;
			{	"ZN_HORA"		, SZG->ZG_HORAFIM	},;	
			{	"ZN_PATRIMO"	, SZG->ZG_PATRIM	},;
			{	"ZN_NUMATU"		, nTotSel			},;
			{	"ZN_PARCIAL"	, nParcial			},;	
			{	"ZN_COTCASH"	, nTotCash			},;	
			{	"ZN_BOTTEST"	, nTeste			},;
			{	"ZN_TRPLACA"	, ""				},;
			{	"ZN_VALIDA"		, "S"				},;
			{	"ZG_EOS"		, IIF(lSendMail,"S","")	}}
			
	// Ps
	For nI := 1 To Len(aLeitura)
		If "CONT_P" $ aLeitura[nI][1] .And. aLeitura[nI][1] <> "CONT_PARCIAL"
			nPos := At( "P",aLeitura[nI][1] )
			cP := PadL( SubStr( aLeitura[nI][1],nPos+1 ),2,"0" )
			AADD( aSZN, { "ZN_BOTAO"+cP, aLeitura[nI][2] } )
		EndIf
	Next nI
	If !Empty(aSZN)
		U_TTPROC17(nTpPrc,,aSZN,@cMsgErro)
	EndIf	  		    
EndIf
	               
// sangria leitura
If cForm == "03" .And. !Empty(aSangria)
	// obtem o numerador anterior
	nNumAnt := U_TTPROG02(SZG->ZG_PATRIM)
  	If Valtype(nNumAnt) == "C" 
  		nNumAnt := Val(nNumAnt)
  	EndIf              
	  	  			  				
	// sangria		
	nTpPrc := 3
		aSZN := { {	"ZN_NUMOS"		, cNumeroOS			},;
				{	"ZN_TIPINCL"	, "SANGRIA"			},;
				{	"ZN_NUMANT"		, nNumAnt			},;
				{	"ZN_AGENTE"		, SZG->ZG_AGENTE	},;
				{	"ZN_CLIENTE"	, SZG->ZG_CLIFOR	},;
				{	"ZN_LOJA"		, SZG->ZG_LOJA 		},;
				{	"ZN_DATA"		, SZG->ZG_DATAFIM	},;
				{	"ZN_HORA"		, SZG->ZG_HORAFIM	},;	
				{	"ZN_PATRIMO"	, SZG->ZG_PATRIM	},;
				{	"ZN_NUMATU"		, nTotSel			},;
				{	"ZN_PARCIAL"	, nParcial			},;	
				{	"ZN_COTCASH"	, nTotCash			},;	
				{	"ZN_BOTTEST"	, nTeste			},;
				{	"ZN_TRPLACA"	, ""				},;
				{	"ZN_VALIDA"		, "S"				},;
				{	"ZG_EOS"		, IIF(lSendMail,"S","")	}}

	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "lacr_gleenv_colocado"})
	If nPos > 0
		cGlenvie := aSangria[nPos][2]
	EndIf
	
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "lacr_gleenv_retirado"})
	If nPos > 0
		cGlenvre := aSangria[nPos][2]
	EndIf
	// lacre cofre somente em maquinas XM/XS			
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "lacr_cofre_retirado"})
	If nPos > 0
		clacrcof := aSangria[nPos][2]
	EndIf	
		
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "lacr_cofre_colocado"})
	If nPos > 0
		clacccof := aSangria[nPos][2]
	EndIf
	
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "lacr_cedula_retirado"})
	If nPos > 0
		clacrced := aSangria[nPos][2]
	EndIf	
		
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "lacr_cedula_colocado"})
	If nPos > 0
		claccced := aSangria[nPos][2]
	EndIf
	
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "lacr_moedeiro_retirado"})
	If nPos > 0
		clacrmoe := aSangria[nPos][2]
	EndIf	
		
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "lacr_moedeiro_colocado"})
	If nPos > 0
		claccmoe := aSangria[nPos][2]
	EndIf

	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "qtd05"})
	If nPos > 0
		nQtd5 := Val(aSangria[nPos][2])
		nTroco += nQtd5 * 0.05
	EndIf
		
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "qtd10"})
	If nPos > 0
		nQtd10 := Val(aSangria[nPos][2])
		nTroco += nQtd10 * 0.10
	EndIf
		
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "qtd25"})
	If nPos > 0
		nQtd25 := Val(aSangria[nPos][2])
		nTroco += nQtd25 * 0.25
	EndIf
	
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "qtd50"})
	If nPos > 0
		nQtd50 := Val(aSangria[nPos][2])
		nTroco += nQtd50 * 0.50
	EndIf
			
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "qtd100"})
	If nPOs > 0
		nQtd100 := Val(aSangria[nPos][2])
		nTroco += nQtd100 * 1
	EndIf
		
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "bananinha"})
	If nPos > 0
		cbanana := aSangria[nPos][2]
	EndIf
		
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "numero_pos"})
	If nPos > 0
		cpos := aSangria[nPos][2]
	EndIf
		
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "log1"})
	If nPos > 0
		clog1 := aSangria[nPos][2]
	EndIf
		
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "log2"})
	If nPos > 0
		clog2 := aSangria[nPos][2]
	EndIf
		
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "log3"})
	If nPOs > 0
		clog3 := aSangria[nPos][2]
	EndIf
		
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "log4"})
	If nPOs > 0
		clog4 := aSangria[nPos][2]
	EndIf
		
	nPos := Ascan(aSangria,{|x| lower(Alltrim(x[1])) == "log5"})
	If nPos > 0
		clog5 := aSangria[nPos][2]                                                                            
	EndIf						
		
	AADD( aSZN, {	"ZN_GLENVIE"	, IIF(Empty(clacccof),cGlenvie,clacccof) })	// se nao tem lacre de cofre - grava lacre gleenview
	AADD( aSZN, {	"ZN_GLENVRE"	, IIF(Empty(clacrcof),cGlenvre,clacrcof) }) 	
	AADD( aSZN, {	"ZN_LACRMOE"	, IIF(Empty(clacrced),clacrmoe,clacrced) })
	AADD( aSZN, {	"ZN_LACCMOE"	, IIF(Empty(claccced),claccmoe,claccced) })
	AADD( aSZN, {	"ZN_LACRCED"	, clacrced	})
	AADD( aSZN, {	"ZN_LACCCED"	, claccced	})						
	AADD( aSZN, {	"ZF_RETMOE1"	, nQtd5		})
	AADD( aSZN, {	"ZF_RETMOE2"	, nQtd10	})
	AADD( aSZN, {	"ZF_RETMOE3"	, nQtd25	})
	AADD( aSZN, {	"ZF_RETMOE4"	, nQtd50	})
	AADD( aSZN, {	"ZF_RETMOE5"	, nQtd100	})
	AADD( aSZN, {	"ZN_TROCO"		, nTroco	})
	AADD( aSZN, {	"ZN_BANANIN"	, cbanana	}) 				
	AADD( aSZN, {	"ZZN_NRSERI"	, cpos		})				
	AADD( aSZN, {	"ZN_LOGC01"		, clog1		}) 
	AADD( aSZN, {	"ZN_LOGC02"		, clog2		}) 
	AADD( aSZN, {	"ZN_LOGC03"		, clog3		}) 
	AADD( aSZN, {	"ZN_LOGC04"		, clog4		}) 
	AADD( aSZN, {	"ZN_LOGC05"		, clog5		}) 			
	AADD( aSZN, {	"ZN_MABAST1"	, nQtd5		})
	AADD( aSZN, {	"ZN_MABAST2"	, nQtd10	})
	AADD( aSZN, {	"ZN_MABAST3"	, nQtd25	})
	AADD( aSZN, {	"ZN_MABAST4"	, nQtd50	})
	AADD( aSZN, {	"ZN_MABAST5"	, nQtd100	})
	  
	// Ps - SOLICITADO POR FELIPE BORGES MEDINA EM 22/06/2016 17:25 - ANTES NAO GRAVAVA ESSES DADOS NO LANCAMENTO DA SANGRIA
	For nI := 1 To Len(aLeitura)
		If "CONT_P" $ aLeitura[nI][1] .And. aLeitura[nI][1] <> "CONT_PARCIAL"
			nPos := At( "P",aLeitura[nI][1] )
			cP := PadL( SubStr( aLeitura[nI][1],nPos+1 ),2,"0" )
			AADD( aSZN, { "ZN_BOTAO"+cP, aLeitura[nI][2] } )
		EndIf
	Next nI
	
	If !Empty(aSZN)
		U_TTPROC17(nTpPrc,,aSZN,@cMsgErro)
	EndIf
EndIf

If !lAbast	       
	dbSelectArea("SZG")
	RecLock("SZG",.F.)
	SZG->ZG_PROC := "BR_VERDE"
	MsUnLock()
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecFrm4   บAutor  ณMicrosiga           บ Data ณ  06/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExecFrm4(cNumeroOS,aDadosOS)

Local cMsgErro := ""

U_TTPROC25(aDadosOS,@cMsgErro) 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecFrm13   บAutor  ณMicrosiga           บ Data ณ  06/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExecFrm13(cNumeroOS,aDadosOS)

Local cMsgErro := ""

U_TTPROC29(aDadosOS,@cMsgErro)

If !Empty(cMsgErro)
	CONOUT("#MXML003 - OS: " +cNumeroOS +" - " +cMsgErro)
EndIf

dbSelectArea("SZG")
RecLock("SZG",.F.)
SZG->ZG_PROC := "BR_VERDE"
MsUnLock() 			      

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecFrm6   บAutor  ณMicrosiga           บ Data ณ  07/14/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExecFrm6(cNumeroOS,aDadosOS)


Local cMsgErro := ""

U_TTPROC26(aDadosOS,@cMsgErro)

If !Empty(cMsgErro)
	CONOUT("#MXML003 - OS: " +cNumeroOS +" - " +cMsgErro)
EndIf

dbSelectArea("SZG")
RecLock("SZG",.F.)
SZG->ZG_PROC := "BR_VERDE"
MsUnLock() 	

Return