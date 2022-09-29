#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN130Inc  ºAutor  ³Alexandre Venancio  º Data ³  08/26/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE utilizado na geracao da medicao.                        º±±
±±º          ³criado para calculo da pro-rata dos contratos de locacao.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN130Inc()
Local aExp1 :=	PARAMIXB[1]
Local aExp2 :=	PARAMIXB[2]
Local aExp3 :=	PARAMIXB[3]
Local aExp4 :=	PARAMIXB[4]
Local cProR	:=	If(cEmpAnt == "01",POSICIONE("CNB",1,XFILIAL("CNB")+M->CND_CONTRA+Space(3)+M->CND_NUMERO,"CNB_XPRORA"),"")	
Local aProR	:=	{}
Local aAux	:=	{}  
Local nProR	:=	0
Local nDias	:=	0
Local nRata	:=	0
Local cRata	:=	''   
Local nTotC	:=	0
Local nSubC	:=	0
Local nValor	:=	0
Local cComp1 := CTOD(SUBSTR(CN9->CN9_XPCOMP,1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+M->CND_COMPETE)-1)),3))
//Local cComp2 := cComp1 + 30 
Local cComp2	:=	If(SUBSTR(CN9->CN9_XPCOMP,1,2) > substr(CN9->CN9_XPCOMP,4,2),CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+M->CND_COMPET))),3)),CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+M->CND_COMPET)-1)),3)))										  	
Local lDataAs	:=	CN9->CN9_DTASSI >= cComp1 .And. CN9->CN9_DTASSI  <= cComp2 
Local nInic		:=	0
//Validações do usuário.     

If cEmpAnt == "01"
	
	M->CND_XINSUM := POSICIONE("CNA",1,XFILIAL("CNA")+M->CND_CONTRA+Space(3)+M->CND_NUMERO,"CNA_XINSUM")
	//M->CND_OBS 	:= "Periodo de Faturamento "+cvaltochar(cComp1)+" A "+cvaltochar(cComp2)+CHR(13)+CHR(10)
	
	If !Empty(cProR) .Or. lDataAs 
		If lDataAs	
			nInic	:=	cComp2 - CN9->CN9_DTASSI
			For nX := 1 to len(aCols)
				
				nV	:=	ACOLS[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLUNIT"})] * (nInic/30)
				ACOLS[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_QUANT"})]	:= 1
				ACOLS[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLUNIT"})] 	:= round(nV,2)
				ACOLS[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_PERC"})]		:= round((1 / ACOLS[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_QTDSOL"})]) * 100,2)
				ACOLS[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLTOT"})] 	+= round(ACOLS[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLUNIT"})],2)
			Next nX
			For nX := 1 to len(aExp2) 
				nV	:=	AEXP2[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLUNIT"})] * (nInic/30)
	
				AEXP2[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_QUANT"})] 	:= 1
				AEXP2[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLUNIT"})] 	:= round(nV,2)
				AEXP2[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_PERC"})]    	:= round((1 / AEXP2[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_QTDSOL"})]) * 100,2)
				AEXP2[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLTOT"})] 	+= round(AEXP2[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLUNIT"})],2)
			Next nX
	
		EndIf
		aProR := StrtokArr(cProR,"|")
		For nX := 1 to len(aProR)
			If !Empty(aProR[nX])
				aAux := StrtokArr(aProR[nX],",")
				If ctod(aAux[4]) >= cComp1 .And. ctod(aAux[4]) <= cComp2
					If aAux[1] != "R"
						nSubC += Val(aAux[3]) * -1
						nDias := cComp2 - ctod(aAux[4])    //CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+'/'+M->CND_COMPETE) 
					Else
						nDias := ctod(aAux[4]) - CTOD(SUBSTR(CN9->CN9_XPCOMP,1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+M->CND_COMPETE)-1)),3)) //CTOD(SUBSTR(CN9->CN9_XPCOMP,1,2)+'/'+M->CND_COMPETE)  
					EndIf
			
					nProR	:=	Val(aAux[3]) / 30
					 	
					
			
				 	If nDias < 0
				 		nDias += 30
				 	EndIf
				 	
				 	nRata += nProR * nDias
				 	nValor	:=	nProR	*	nDias
				 	cRata += 'Pro-rata ref patrimonio '+aAux[2]+' no valor de R$ '+transform(nValor,"@E 999,999,999.99") 
				 	cRata += ' - Periodo '+cvaltochar(ctod(aAux[4]))+' A '+cvaltochar(cComp2)+' / '
				EndIf
			EndIf
		 Next nX  
		 M->CND_OBS += Alltrim(cRata)
		
		For nP := 1 to len(aCols)
			ACOLS[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_QUANT"})]	:= 1
			ACOLS[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLUNIT"})] 	+= round(nRata + nSubC,2)
			ACOLS[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_PERC"})]		:= round((1 / ACOLS[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_QTDSOL"})]) * 100,2)
			ACOLS[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLTOT"})] 	+= round(ACOLS[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLUNIT"})],2)
			nTotC	+=	ACOLS[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLUNIT"})]
		Next nP
		
		For nP := 1 to len(aExp2)
			AEXP2[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_QUANT"})] 	:= 1
			AEXP2[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLUNIT"})] 	+= round(nRata + nSubC,2)
			AEXP2[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_PERC"})]    	:= round((1 / AEXP2[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_QTDSOL"})]) * 100,2)
			AEXP2[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLTOT"})] 	+= round(AEXP2[nP,Ascan(aHeader,{|x| Alltrim(x[2]) == "CNE_VLUNIT"})],2)
		Next nP                    
		M->CND_VLTOT	:=	round(nTotC + nSubC,2)
	EndIf
EndIf	 	
//M->CND_CONTRA
//M->CND_OBS := 'PRO-RATA REF PATRIMONIO 1106'   
/*
*/
Return {aExp1,aExp2,aExp3,aExp4}
