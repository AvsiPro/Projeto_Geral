#include 'protheus.ch'
#include 'parmtype.ch'
#include "totvs.ch"
#include "fileio.ch"
#INCLUDE  'TBICONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTWS03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  WS Generico para consultas                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Busca o planograma de todas as maquinas                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function PRTWS03(cAtivo,nChamada,dDtini,dDtfim)
                     
Local aAuxP				:= {}
Private oRestClient 	:= FWRest():New("http://vmpay.vertitecnologia.com.br")
Private aHeader 		:= {}
Private aLinhas			:= {}
Private aRetorno		:= {} 

//Buscar Maquinas                         
Maquinas()
nPosMaq := Ascan(aHeader,{|x| Alltrim(x[2]) == Alltrim(cAtivo)})

If nPosMaq > 0 
	If nChamada == 1
		//Buscar Instalações    
		Instalacoes(aHeader[nPosMaq,01],nPosMaq)       
		
		//Buscar id de Planogramas por maquina
		Planograma(aHeader[nPosMaq,01],aHeader[nPosMaq,03],nPosMaq)
		
		//Buscar Planograma da maquina
		//PlanoMaq(aHeader[nPosMaq,01],aHeader[nPosMaq,03],aHeader[nPosMaq,04],nPosMaq)
		
		aRetorno := aHeader[nPosMaq]
		nP := 0       
		For nJ := 1 to len(aRetorno[4]) step 11  
			If nJ+10 > len(aRetorno[4])
				exit
			EndIf
			Aadd(aAuxP,{.F.,cAtivo,aRetorno[4,nJ+3],aRetorno[4,nJ+4],aRetorno[4,nJ+5],aRetorno[4,nJ+6],aRetorno[4,nJ+7],aRetorno[4,nJ+10]})
		Next nJ 
		
		aList3 := {}
		
		For nJ := 1 to len(aAuxP)               
			aAux2 := {}
			Aadd(aAux2,aAuxP[nJ,01])
			Aadd(aAux2,aAuxP[nJ,02])
			//nPosn := Ascan(aAuxP[nJ],{|x| substr(x,1,3) == "upc"})
			aAux1 := strtokarr(aAuxP[nJ,len(aAuxP[nJ])],":")
			aAux3 := strtokarr(aAux1[2],"-")
			
			For nK := 3 to len(aAuxP[nJ])-1
				aAux1 := strtokarr(aAuxP[nJ,nK],":")
				If aAux1[1] == 'name' .And. val(aAux1[2]) <= 0
					loop
				EndIf
				lValor := If(aAux1[1]$"desired_price/capacity/par_level/alert_level",.T.,.F.)
				Aadd(aAux2,If(lValor,val(aAux1[2]),aAux1[2]))
				If nK == 3 
					cCodProt := Posicione("SB1",12,xFilial("SB1")+aAux3[1],"B1_COD")       
					If Empty(cCodProt)
						cCodProt := Alltrim(aAux3[1])
						cDesc	 := Alltrim(Posicione("SB1",1,xFilial("SB1")+cCodProt,"B1_DESC"))
					else
						cDesc	 := Alltrim(Posicione("SB1",12,xFilial("SB1")+aAux3[1],"B1_DESC"))
					EndIf
					Aadd(aAux2,cCodProt)
					Aadd(aAux2,cDesc)
	        	EndIf
			Next nK
			Aadd(aAux2,'')
			If len(aAux2) > 4
				Aadd(aList3,aAux2)
			EndIf
		Next nJ 
		
		If len(aList3) < 1
			Aadd(aList3,{.T.,'','','','','','','','','','','','','','','','','',''})
		EndIf
		
		oList3:SetArray(aList3)
		oList3:bLine := {||{ If(aList3[oList3:nAt,01],oOk,oNo),; 
		 					 Alltrim(aList3[oList3:nAt,02]),;
		 					 aList3[oList3:nAt,03],;
		 					 aList3[oList3:nAt,04],;
		 					 aList3[oList3:nAt,05],;
		 					 aList3[oList3:nAt,06],;
		 					 aList3[oList3:nAt,07],;
		 					 aList3[oList3:nAt,08],;
		 					 Transform(aList3[oList3:nAt,09],"@E 999,999.99")}}   
		
		oList3:refresh()
		oDlg1:refresh()
	Else
		
		cDtCriac := Dtos(dDtini)
		cDtCriac := substr(cDtCriac,1,4)+"-"+substr(cDtCriac,5,2)+"-"+substr(cDtCriac,7,2)
		// data/hora inicial de venda
		//cDtCriac += " 00:01:00"
		
		cDtCriac += "T" +"00:00-03:00"
		
		cDtCria2 := Dtos(dDtfim)
		cDtCria2 := substr(cDtCria2,1,4)+"-"+substr(cDtCria2,5,2)+"-"+substr(cDtCria2,7,2)
		// data/hora inicial de venda
		//cDtCriac += " 00:01:00"
		
		cDtCria2 += "T" +"00:00-03:00"

        Vendas(cDtCriac,aHeader[nPosMaq,01],nPosMaq,cDtCria2)
        Return(aHeader[nPosMaq])
	EndIf
EndIf
      		
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTWS03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca maquinas                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Maquinas()

oRestClient:setPath("/api/v1/machines?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB") 

If oRestClient:Get(aHeader)
	cValor := oRestClient:GetResult("GET")
	cValor := strtran(cValor,"[")
	cValor := strtran(cValor,"]")
	cValor := strtran(cValor,'"')
	
	aLinhas := strtokarr(cValor,"},{") 
	
	For nX := 1 to len(aLinhas)
		If "asset_number" $ Alltrim(aLinhas[nX])
			aAux1 := Strtokarr(aLinhas[nX],":")
			aAux2 := Strtokarr(aLinhas[nX-1],":")
			Aadd(aHeader,{aAux2[2],aAux1[2]})
		EndIf
	Next nX
EndIF

Return       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTWS03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca Instalacoes                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Instalacoes(cCod,nPos)

oRestClient:setPath("/api/v1/machines/"+Alltrim(cCod)+"/installations?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB") 

If oRestClient:Get(aHeader)
	cValor := oRestClient:GetResult("GET")
	cValor := strtran(cValor,"[")
	cValor := strtran(cValor,"]")
	cValor := strtran(cValor,'"')
	
	aLinhas := strtokarr(cValor,"},{") 
	If len(aLinhas) > 0 
		For nX := len(aLinhas) to 1 step -1
			If substr(aLinhas[nX],1,3) == "id:"
				Aadd(aHeader[nPos],substr(aLinhas[nX],4)) 
				exit
			EndIf
		Next nX
	EndIf
EndIf

Return            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTWS03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca planogramas                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Planograma(cMaq,cInst,nPos)

 ///planograms
oRestClient:setPath("/api/v1/machines/"+Alltrim(cMaq)+"/installations/"+cInst+"?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB") 
		
If oRestClient:Get(aHeader)
	cValor := oRestClient:GetResult("GET")
	cValor := strtran(cValor,"[")
	cValor := strtran(cValor,"]")
	cValor := strtran(cValor,'"')
	
	aLinhas := strtokarr(cValor,"},{")
	If len(aLinhas) > 0
 		//Aadd(aHeader[nPos],substr(aLinhas[1],4))
 		lInicio := .F.
		lFim	:= .F.
		aAux 	:=	{}
		
		For nJ := 1 to len(aLinhas)
			If "items:" $ aLinhas[nJ]
				lInicio := .T.
			EndIf
			
			/*If "unit_symbol:" $ aLinhas[nJ]
				//lInicio := .F.
				lFim 	:= .F.
			EndIf   */
			
			If lInicio
				If "id:" $ substr(aLinhas[nJ],1,3)  //.And. Ascan(aAux,{|x| substr(x,1,3) == substr(aLinhas[nJ],1,3)}) == 0
					//If !lFim
						Aadd(aAux,aLinhas[nJ])    
						//lFim := .T.
					//EndIf
					
				ElseIf "planogram_id:" $ aLinhas[nJ]
					Aadd(aAux,aLinhas[nJ])
				ElseIf "good_id:" $ aLinhas[nJ]
					Aadd(aAux,aLinhas[nJ])
				ElseIf "name:" $ aLinhas[nJ] 
					If val(substr(aLinhas[nJ],6)) > 0 .And. valtype(val(aLinhas[nJ+1])) == "N" .And. val(aLinhas[nJ+1]) > 0
						//CORRIGIR AQUI PARA QUANDO FOR MAIS DE 2 MOLAS PARA O MESMO PRODUTO.
						lFim := .F.
						nPing := nJ
						cMolas := Alltrim(aLinhas[nPing])
						cBarra := ','                   
						nPing++
						While !lFim
							If valtype(val(aLinhas[nPing])) == "N" .And. val(aLinhas[nPing]) > 0
								cMolas += cBarra + Alltrim(aLinhas[nPing])
								nPing++
							Else
								lFim := .T.
							EndIf
						EndDo
						//Aadd(aAux,Alltrim(aLinhas[nJ])+","+aLinhas[nJ+1])
						Aadd(aAux,cMolas)
					Else
						Aadd(aAux,aLinhas[nJ])
					EndIf
				ElseIf "capacity:" $ aLinhas[nJ]
					Aadd(aAux,aLinhas[nJ])
				ElseIf "par_level:" $ aLinhas[nJ]
					Aadd(aAux,aLinhas[nJ])
				ElseIf "alert_level:" $ aLinhas[nJ]
					Aadd(aAux,aLinhas[nJ])  
				ElseIf "desired_price:" $ aLinhas[nJ]
					Aadd(aAux,aLinhas[nJ])  
				EndIf
			EndIf
		Next nJ
		//unit_symbol: finaliza
		Aadd(aHeader[nPos],aAux)
	EndIf
EndIf

Return           


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTWS03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PlanoMaq(cMaq,cInst,cPlan,nPos)


oRestClient:setPath("/api/v1/machines/"+Alltrim(cMaq)+"/installations/"+cInst+"/planograms/"+cPlan+"?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB") 
		
If oRestClient:Get(aHeader)
	cValor := oRestClient:GetResult("GET")
	cValor := strtran(cValor,"[")
	cValor := strtran(cValor,"]")
	cValor := strtran(cValor,'"')
	
	aLinhas := strtokarr(cValor,"},{")
	If len(aLinhas) > 0
            //items: inicia
		lInicio := .F.
		lFim	:= .F.
		aAux 	:=	{}
		
		For nJ := 1 to len(aLinhas)
			If "items:" $ aLinhas[nJ]
				lInicio := .T.
			EndIf
			
			/*If "unit_symbol:" $ aLinhas[nJ]
				//lInicio := .F.
				lFim 	:= .F.
			EndIf   */
			
			If lInicio
				If "id:" $ substr(aLinhas[nJ],1,3)  //.And. Ascan(aAux,{|x| substr(x,1,3) == substr(aLinhas[nJ],1,3)}) == 0
					//If !lFim
						Aadd(aAux,aLinhas[nJ])    
						//lFim := .T.
					//EndIf
					
				ElseIf "planogram_id:" $ aLinhas[nJ]
					Aadd(aAux,aLinhas[nJ])
				ElseIf "good_id:" $ aLinhas[nJ]
					Aadd(aAux,aLinhas[nJ])
				ElseIf "name:" $ aLinhas[nJ]
					If val(substr(aLinhas[nJ],6)) > 0 .And. valtype(val(aLinhas[nJ+1])) == "N" .And. val(aLinhas[nJ+1]) > 0
						Aadd(aAux,Alltrim(aLinhas[nJ])+","+aLinhas[nJ+1])
					Else
						Aadd(aAux,aLinhas[nJ])
					EndIf
				ElseIf "capacity:" $ aLinhas[nJ]
					Aadd(aAux,aLinhas[nJ])
				ElseIf "par_level:" $ aLinhas[nJ]
					Aadd(aAux,aLinhas[nJ])
				ElseIf "alert_level:" $ aLinhas[nJ]
					Aadd(aAux,aLinhas[nJ])  
				ElseIf "desired_price:" $ aLinhas[nJ]
					Aadd(aAux,aLinhas[nJ])  
				EndIf
			EndIf
		Next nJ
		//unit_symbol: finaliza
		Aadd(aHeader[nPos],aAux)
    EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTWS03   ºAutor  ³Microsiga           º Data ³  04/14/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Produto                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Produto(cProd)

oRestClient:setPath("/api/v1/products/"+cProd+"?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB") 

If oRestClient:Get(aHeader)
	cValor := oRestClient:GetResult("GET")
	cValor := strtran(cValor,"[")
	cValor := strtran(cValor,"]")
	cValor := strtran(cValor,'"')
	
	aLinhas := strtokarr(cValor,"},{") 
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTWS03   ºAutor  ³Microsiga           º Data ³  05/31/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Vendas por maquina com data inicial                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Vendas(cDtCriac,cMaquina,nPos,cDtCria2)

Local cValor := 'res'
Local nPage	 := 1
///api/v1/vends/?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB&start_date=31-05-2017%2000:00:00&machine_id=227
aAux 	:=	{}
		
While nPage > 0
	oRestClient:setPath("/api/v1/vends/?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB&start_date="+cDtCriac+"&end_date="+cDtCria2+"&machine_id="+cMaquina+"&page="+cvaltochar(nPage)) 
	
	If oRestClient:Get(aHeader)
		cValor := oRestClient:GetResult("GET")
		cValor := strtran(cValor,"[")
		cValor := strtran(cValor,"]")
		cValor := strtran(cValor,'"')
		
		If !Empty(cValor)
			nPage++ 
		Else
			nPage := 0
		EndIF
		
		aLinhas := strtokarr(cValor,"},{")      
		For nX := 1 to len(aLinhas)     
			If "occurred_at:" $ aLinhas[nX]
				Aadd(aAux,stod(strtran(substr(alinhas[nX],13,10),"-")))
			Elseif "coil:" $ aLinhas[nX]
				Aadd(aAux,substr(aLinhas[nX],6))
			ElseIf "quantity:" $ aLinhas[nX]
				Aadd(aAux,substr(aLinhas[nX],10))
			ElseIf "value:" $ aLinhas[nX]
				Aadd(aAux,substr(aLinhas[nX],7))
			ElseIf "upc_code:" $ aLinhas[nX]
				Aadd(aAux,substr(aLinhas[nX],10))	
				Aadd(aHeader[nPos],aAux)
				aAux := {}
			EndIf 
		Next nX
	Else
		nPage := 0
	EndIf
EndDo 

Return