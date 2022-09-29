#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTTMK04G  ºAutor  ³Microsiga           º Data ³  09/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho para preencher corretamente a data prevista de finaº±±
±±º          ³lizacao do chamado do call center.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTTMK04G()

Local aArea		:=	GetArea()
Local nPosAssu	:= 	Ascan(aHeader,{|x|AllTrim(x[2])=="UD_ASSUNTO"}) 
Local nPosOCorr	:= 	Ascan(aHeader,{|x|AllTrim(x[2])=="UD_OCORREN"})
Local cCodOcorr := 	aCols[n,nPosOCorr]
Local cPrazo 	:= 	Posicione("SU9",2,xFilial("SU9")+cCodOcorr,"U9_PRAZO")
Local lAux		:= 	.T.
Local nDias		:=	0
Local nHoras	:=	0
Local nSobra	:=	val(cPrazo)
Local dDtRet    :=	date()
Local aHora		:=	{}
Local nCont		 := 0 
Local lEdi1		 := .F.       

While !empty(procname(nCont))
	If alltrim(UPPER(procname(nCont))) $ "U_TTTMKA31"
		lEdi1 := .T.
		Exit
	EndIf 
	nCont++
EndDo

If !lEdi1

	While lAux
		nSobra -= 24
		
		If nSobra >= 24 
			nDias++
			loop
		EndIf
		        
		If nSobra < 24 .And. nSobra > 0
			If nSobra + val(substr(time(),1,2)) > 24
				nDias++
				nSobra := nSobra + val(substr(time(),1,2))
				loop 
			else 
				nDias++
				nSobra := if(nSobra<0,nSobra * (-1),nSobra)
				lAux := .F. 
				exit
			EndIf
		EndIf	
			        
		If nSobra == 0
			nDias++
			lAux := .F.  
			exit
		EndIf
		               
		If nSobra < 0
			If somahoras(time(),nSobra*(-1)) > 24 //val(substr(time(),1,2)) + (nSobra * (-1)) > 24
				nSobra := val(substr(time(),1,2)) + (nSobra * (-1)) 
				nDias++                                              
				If nSobra == 24 
					nSobra := 99
					exit
				Else
					loop
				EndIf
			Else
				nSobra := nSobra * (-1)
				lAux := .F.
				exit
			EndIf
		EndIf
	EndDo
				
	M->UC_PENDENT:= datavalida(dDtRet + nDias)
	  
	If nSobra != 99
		nHora := SomaHoras(time(),nSobra)
	Else       
		nHora := '00.'+substr(time(),4,2)
	EndIf
	
	aHora := strtokarr(cvaltochar(nHora),".")
	
	M->UC_HRPEND := Strzero(val(aHora[1]),2)+":"+Strzero(val(aHora[2]),2) //strtran(cvaltochar(nHora),".",":")	// CORRIGIR
//	If SubStr(M->UC_HRPEND,1,2) == "24"
//		M->UC_HRPEND := "00"+
//	EndIf
//	M->UC_HRPEND := STRTRAN(M->UC_HRPEND,"24","00")
	/*Local nDias 	:= 	Val(cPrazo)/10
	Local nDias2	:=	round(nDias,0)
	Local dDtRet    := 	M->UC_DATA
	Local nCont		:=	0
	Local aHora		:=	strtokarr(cvaltochar(nDias),".")
	
	While nCont < nDias2
		dDtRet++
		If dow(dDtRet) != 1 .AND. dow(dDtRet) != 7
			nCont++
		EndIF
	EndDo
			
		
	M->UC_PENDENT := dDtRet
	
	If len(aHora) > 1
		nHora := 8+val(aHora[2])
		M->UC_HRPEND := strzero(nHora,2)+":00"
	Else
		M->UC_HRPEND := substr(time(),1,5)     
	EndIf
 
                                 */

	oGetTmk:oBrowse:Refresh(.T.) 
	oGetTmk:Refresh()  
EndIf

RestArea(aArea)

Return