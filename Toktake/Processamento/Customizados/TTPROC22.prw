#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC22  บAutor  ณAlexandre Venancio  บ Data ณ  10/29/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao de Pedido de Venda para faturamento de Cafe.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC22()

Local aArea			:=	GetArea()
Local aCab			:=	{} 
Local cRet	   		:=	''  
Local nRet			:=	0
Local cOpcCmp		    
Local aAuxPr		:=	{}
Local aAuxPr2		:=	{} 
Local cPtAux		:=	''  
Local aAjuste		:=	{}
Local _aSelec		:=	{}
Local _aPaCn		:=	{} 
Local _aItenSl		:=	{} 
Local _BkaProd		:=	{} 
Local _xaProd		:=	{}
Local _FilFat		:=	Posicione("SA1",1,xFilial("SA1")+aContr[Ascan(aContr,{|x| x[1] == aProd[1,7]}),05]+aContr[Ascan(aContr,{|x| x[1] == aProd[1,7]}),06],"A1_EST")
Local _BkFilant		:=	cfilant
Private aItens		:=	{}               
Private lMsErroAuto	:=	.F.
Private cCliente	:=	''
Private cLoja		:=	''
Private cPa			:=	''
Private cItCc		:=	''
Private cCompSep	:=	'N'  
Private lPP			:=	.F.
 
If cEmpAnt <> "01"
	return
EndIF

//Validacao para qual filial o pedido sera faturado.
If _FilFat != SM0->M0_ESTCOB
	DbSelectArea("SM0")
	_aAreaSM0:= GetArea()
	DBSETORDER(1)
	While !EOF()
        If SM0->M0_ESTCOB == _FilFat
			If MsgYesNo("O Cliente do contrato ้ do Estado "+_FilFat+CHR(13)+CHR(10)+"Deseja faturar o pedido pela Filial "+SM0->M0_CODFIL+"-"+SM0->M0_ESTCOB+"?","TTPROC22")
				cfilant := SM0->M0_CODFIL
				exit
			EndIf    
		EndIf
		DbSkip()
	Enddo
	RestArea(_aAreaSM0)  
	//return
EndIf

//Faturamento de Contrato do Tipo Selecionado.
If aContr[Ascan(aContr,{|x| x[1] == aProd[1,7]}),11] == "3" 
	_BkaProd := aClone(aProd)
	_aSelec := Strtokarr(Posicione("CN9",1,_BkFilant+aContr[Ascan(aContr,{|x| x[1] == aProd[1,7]}),01],"CN9_XCNSEL"),"/")
	For nX := 1 to len(_aSelec) 
		If !Empty(_aSelec[nX])
			Aadd(_aPaCn,Strtokarr(_aSelec[nX],"="))
		EndIf
	Next nX
	Asort(_aPaCn,,,{|x,y| x[1] < y[1]})
	_aItenSl := FatSelec(_aPaCn)
	
	cAuxS	:=	_aItenSl[1,1]
	For nP := 1 to len(_aItenSl)
		If _aItenSl[nP,01] != cAuxS
			cAuxS := _aItenSl[nP,01] 
			aProd := aClone(_xaProd)   
			
			_FilFat		:=	Posicione("SA1",1,xFilial("SA1")+substr(aProd[1,6],1,6)+substr(aProd[1,6],8,4),"A1_EST")
			If _FilFat != SM0->M0_ESTCOB
				DbSelectArea("SM0")
				_aAreaSM0:= GetArea()
				DBSETORDER(1)
				While !EOF()
			        If SM0->M0_ESTCOB == _FilFat
						If MsgYesNo("O Cliente do contrato ้ do Estado "+_FilFat+CHR(13)+CHR(10)+"Deseja faturar o pedido pela Filial "+SM0->M0_CODFIL+"-"+SM0->M0_ESTCOB+"?","TTPROC22")
							cfilant := SM0->M0_CODFIL
							exit
						EndIf    
					EndIf
					DbSkip()
				Enddo
				RestArea(_aAreaSM0)  
				//return
			EndIf 
			
			cCliente	:=	substr(aProd[1,6],1,6) 
			cLoja 	 	:=	substr(aProd[1,6],7,4)
			cPa		    :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_COD")
			cItCc       :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_ITCONT")     //AQUI
			aCab		:=	{}
			aItens		:=	{}
			aCab		:=	Cabecalho(1)
			Itens(1,'')
			
			For nX := 1 to len(aProd)
				If aProd[nX,10] > 0 .AND. aProd[nX,03] > 0
					lPP := .T.
					exit
				EndIf
			Next nX
		
			aAreaC5 := GetArea()
			cNumPed := GetSx8num("SC5","C5_NUM")	
			
			aCab[2,2] := cNumPed
			aAux := {} 
			aAjuste		:=	{}
			For nZ := 1 to len(aItens)
				aItens[nZ,02,02] := cNumPed
				
				aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
				If len(aAux) > 1
					If len(aAux[2]) > 2
				   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
				   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
				   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
				   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
				 	EndIf
				EndIf
		        If aItens[nZ,10,2] == 0 .OR. aItens[nZ,6,2] == 0
		        	ADEL(aItens,nZ)
					ASIZE(aItens,Len(aItens)-1)
				EndIf
		
			Next nZ
		
							
			lMsErroAuto := .F.
			MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
			
			If lMsErroAuto
				MostraErro() 
			EndIF   
			
			If len(aAjuste) > 0  
				DbSelectArea("SC6")
				DbSetOrder(1)    
				For nX := 1 to len(aAjuste)
					If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
						Reclock("SC6",.F.)
						SC6->C6_PRCVEN := aAjuste[nX,5]
						SC6->C6_VALOR  := aAjuste[nX,6]
						SC6->C6_PRUNIT := aAjuste[nX,7]
						SC6->(Msunlock())
					EndIf
				Next nX 
				DbSelectArea("SC9")
				DbSetOrder(1)
				For nX := 1 to len(aAjuste)
					If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
						Reclock("SC9",.F.)
						SC9->C9_PRCVEN := aAjuste[nX,5]
						SC9->(Msunlock())
					EndIf
				Next nX 
			EndIf
			
			If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
	   			cRet := "/"+SC5->C5_NUM
				ConfirmSX8()    
   			EndIf
   		
			
			//cRet := "/"+SC5->C5_NUM
			//ConfirmSX8()
			
			RestArea(aAreaC5)
			
			If cCompSep == "S"
				
				aCab 		:= 	{}
				aItens 		:= 	{}
				cCliente	:=	substr(aProd[1,6],1,6) 
				cLoja 	 	:=	substr(aProd[1,6],7,4)
				aCab		:=	Cabecalho(3)
				Itens(3,'')   
				aAreaC5 := GetArea()
				cNumPed := GetSx8num("SC5","C5_NUM")	
				
				aCab[2,2] := cNumPed
				aAjuste		:=	{}
				For nZ := 1 to len(aItens)
					aItens[nZ,02,02] := cNumPed 
					//Acerto 4 casas decimais
					aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
					If len(aAux) > 1
						If len(aAux[2]) > 2
					   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
					   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
					   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
					   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
					 	EndIf
					EndIf
			        If aItens[nZ,10,2] == 0 .OR. aItens[nZ,6,2] == 0
			        	ADEL(aItens,nZ)
						ASIZE(aItens,Len(aItens)-1)
					EndIf
				Next nZ
				lMsErroAuto := .F.
				MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
				
				If lMsErroAuto
					MostraErro() 
				EndIF   
				//Acerto 4 casas decimais
				If len(aAjuste) > 0  
					DbSelectArea("SC6")
					DbSetOrder(1)    
					For nX := 1 to len(aAjuste)
						If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
							Reclock("SC6",.F.)
							SC6->C6_PRCVEN := aAjuste[nX,5]
							SC6->C6_VALOR  := aAjuste[nX,6]
							SC6->C6_PRUNIT := aAjuste[nX,7]
							SC6->(Msunlock())
						EndIf
					Next nX 
					DbSelectArea("SC9")
					DbSetOrder(1)
					For nX := 1 to len(aAjuste)
						If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
							Reclock("SC9",.F.)
							SC9->C9_PRCVEN := aAjuste[nX,5]
							SC9->(Msunlock())
						EndIf
					Next nX 
				EndIf
				
				If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
	   				cRet += "/"+ SC5->C5_NUM  
					ConfirmSX8()    
   				EndIf    
				
				//cRet += "/"+ SC5->C5_NUM  
				//ConfirmSX8()
				RestArea(aAreaC5)		
				
			EndIf
			
			If lPP
				aCab 		:= 	{}
				aItens 		:= 	{}
				cCliente 	:=	'000001'
				cLoja		:=	strzero(val(cfilant),4)
				aCab		:=	Cabecalho(2)
				Itens(2,'') 
				
				aAreaC5 := GetArea()
				cNumPed := GetSx8num("SC5","C5_NUM")	
				
				aCab[2,2] := cNumPed
				aAjuste		:=	{}
				For nZ := 1 to len(aItens)
					aItens[nZ,02,02] := cNumPed 
					//Acerto 4 casas decimais
					aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
					If len(aAux) > 1
						If len(aAux[2]) > 2
					   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
					   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
					   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
					   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
					 	EndIf
					EndIf
			        If aItens[nZ,10,2] == 0
			        	ADEL(aItens,nZ)
						ASIZE(aItens,Len(aItens)-1)
					EndIf
				Next nZ
				lMsErroAuto := .F.
				MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
				
				If lMsErroAuto
					MostraErro() 
				EndIF   
				
						//Acerto 4 casas decimais
				If len(aAjuste) > 0  
					DbSelectArea("SC6")
					DbSetOrder(1)    
					For nX := 1 to len(aAjuste)
						If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
							Reclock("SC6",.F.)
							SC6->C6_PRCVEN := aAjuste[nX,5]
							SC6->C6_VALOR  := aAjuste[nX,6]
							SC6->C6_PRUNIT := aAjuste[nX,7]
							SC6->(Msunlock())
						EndIf
					Next nX 
					DbSelectArea("SC9")
					DbSetOrder(1)
					For nX := 1 to len(aAjuste)
						If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
							Reclock("SC9",.F.)
							SC9->C9_PRCVEN := aAjuste[nX,5]
							SC9->(Msunlock())
						EndIf
					Next nX 
				EndIf
				
				If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
	   				cRet += "/"+ SC5->C5_NUM  
					ConfirmSX8()    
   				EndIf   
				
				//cRet += "/"+ SC5->C5_NUM  
				//ConfirmSX8()
				RestArea(aAreaC5)      
			EndIf
			
			_xaProd := {}
		Endif
        //Monta um novo Aprod por patrimonio informado na selecao do contrato.
		For nTT := 7 to 50 step 4
			If !Empty(_aItenSl[nP,nTT]) .And. _aItenSl[nP,01] == cAuxS
				If Ascan(_xaProd,{|x| x[1] == _aItenSl[nP,nTT]}) == 0
					Aadd(_xaProd,{_aItenSl[nP,nTT],_aItenSl[nP,05],_aItenSl[nP,nTT-1],_aItenSl[nP,nTT+1],_aItenSl[nP,nTT-1]*_aItenSl[nP,nTT+1],;
									_aItenSl[nP,03]+"-"+_aItenSl[nP,04],aProd[1,7],aProd[1,8],_aItenSl[nP,02],;
									_aItenSl[nP,nTT+2],_aItenSl[nP,nTT-1]*_aItenSl[nP,nTT+2],;
									aProd[1,12],aProd[1,13],aProd[1,14],aProd[1,15],aProd[1,16],''})                                      
				Else
					_xaProd[Ascan(_xaProd,{|x| x[1] == _aItenSl[nP,nTT]}),03] +=  _aItenSl[nP,nTT-1]
					_xaProd[Ascan(_xaProd,{|x| x[1] == _aItenSl[nP,nTT]}),05] :=	_xaProd[Ascan(_xaProd,{|x| x[1] == _aItenSl[nP,nTT]}),03]*_xaProd[Ascan(_xaProd,{|x| x[1] == _aItenSl[nP,nTT]}),04]
					_xaProd[Ascan(_xaProd,{|x| x[1] == _aItenSl[nP,nTT]}),09] :=	_xaProd[Ascan(_xaProd,{|x| x[1] == _aItenSl[nP,nTT]}),09]+"/"+_aItenSl[nP,02]
					_xaProd[Ascan(_xaProd,{|x| x[1] == _aItenSl[nP,nTT]}),11] :=	_xaProd[Ascan(_xaProd,{|x| x[1] == _aItenSl[nP,nTT]}),03]*_xaProd[Ascan(_xaProd,{|x| x[1] == _aItenSl[nP,nTT]}),10]
				EndIf
			EndIf
		Next nTT
	Next nP
	
	If len(_xaProd) > 0
		_FilFat		:=	Posicione("SA1",1,xFilial("SA1")+substr(aProd[1,6],1,6)+substr(aProd[1,6],8,4),"A1_EST")
		If _FilFat != SM0->M0_ESTCOB
			DbSelectArea("SM0")
			_aAreaSM0:= GetArea()
			DBSETORDER(1)
			While !EOF()
		        If SM0->M0_ESTCOB == _FilFat
					If MsgYesNo("O Cliente do contrato ้ do Estado "+_FilFat+CHR(13)+CHR(10)+"Deseja faturar o pedido pela Filial "+SM0->M0_CODFIL+"-"+SM0->M0_ESTCOB+"?","TTPROC22")
						cfilant := SM0->M0_CODFIL
						exit
					EndIf    
				EndIf
				DbSkip()
			Enddo
			RestArea(_aAreaSM0)  
			//return
		EndIf 
		//AQUI	
		cCliente	:=	substr(aProd[1,6],1,6) 
		cLoja 	 	:=	substr(aProd[1,6],7,4)
		cPa		    :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_COD")
		cItCc       :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_ITCONT")  
		aCab		:=	{}
		aItens		:=	{}
		aProd		:=	Aclone(_xaProd)
		aCab	:=	Cabecalho(1)
		Itens(1,'')
		
		For nX := 1 to len(aProd)
			If aProd[nX,10] > 0 .AND. aProd[nX,03] > 0
				lPP := .T.
				exit
			EndIf
		Next nX
	
		aAreaC5 := GetArea()
		cNumPed := GetSx8num("SC5","C5_NUM")	
		
		aCab[2,2] := cNumPed
		aAux := {} 
		aAjuste		:=	{}
		For nZ := 1 to len(aItens)
			aItens[nZ,02,02] := cNumPed
			
			aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
			If len(aAux) > 1
				If len(aAux[2]) > 2
			   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
			   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
			   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
			   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
			 	EndIf
			EndIf
	        If aItens[nZ,10,2] == 0
	        	ADEL(aItens,nZ)
				ASIZE(aItens,Len(aItens)-1)
			EndIf
	
		Next nZ
	
						
		lMsErroAuto := .F.
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
		
		If lMsErroAuto
			MostraErro() 
		EndIF   
		
		If len(aAjuste) > 0  
			DbSelectArea("SC6")
			DbSetOrder(1)    
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
					Reclock("SC6",.F.)
					SC6->C6_PRCVEN := aAjuste[nX,5]
					SC6->C6_VALOR  := aAjuste[nX,6]
					SC6->C6_PRUNIT := aAjuste[nX,7]
					SC6->(Msunlock())
				EndIf
			Next nX 
			DbSelectArea("SC9")
			DbSetOrder(1)
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
					Reclock("SC9",.F.)
					SC9->C9_PRCVEN := aAjuste[nX,5]
					SC9->(Msunlock())
				EndIf
			Next nX 
		EndIf
		
		If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
   			cRet += "/"+ SC5->C5_NUM  
			ConfirmSX8()    
   		EndIf
		
		//cRet += "/"+SC5->C5_NUM  
		//ConfirmSX8()
		
		RestArea(aAreaC5)
		
		If cCompSep == "S"
			
			aCab 		:= 	{}
			aItens 		:= 	{}
			cCliente	:=	substr(aProd[1,6],1,6) 
			cLoja 	 	:=	substr(aProd[1,6],7,4)
			aCab		:=	{}
			aItens		:=	{}
			aCab		:=	Cabecalho(3)
			Itens(3,'')   
			aAreaC5 := GetArea()
			cNumPed := GetSx8num("SC5","C5_NUM")	
			
			aCab[2,2] := cNumPed
			aAjuste		:=	{}
			For nZ := 1 to len(aItens)
				aItens[nZ,02,02] := cNumPed 
				//Acerto 4 casas decimais
				aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
				If len(aAux) > 1
					If len(aAux[2]) > 2
				   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
				   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
				   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
				   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
				 	EndIf
				EndIf
		        If aItens[nZ,10,2] == 0
		        	ADEL(aItens,nZ)
					ASIZE(aItens,Len(aItens)-1)
				EndIf
			Next nZ
			lMsErroAuto := .F.
			MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
			
			If lMsErroAuto
				MostraErro() 
			EndIF   
			//Acerto 4 casas decimais
			If len(aAjuste) > 0  
				DbSelectArea("SC6")
				DbSetOrder(1)    
				For nX := 1 to len(aAjuste)
					If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
						Reclock("SC6",.F.)
						SC6->C6_PRCVEN := aAjuste[nX,5]
						SC6->C6_VALOR  := aAjuste[nX,6]
						SC6->C6_PRUNIT := aAjuste[nX,7]
						SC6->(Msunlock())
					EndIf
				Next nX 
				DbSelectArea("SC9")
				DbSetOrder(1)
				For nX := 1 to len(aAjuste)
					If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
						Reclock("SC9",.F.)
						SC9->C9_PRCVEN := aAjuste[nX,5]
						SC9->(Msunlock())
					EndIf
				Next nX 
			EndIf
			
			If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
	   			cRet += "/"+ SC5->C5_NUM  
				ConfirmSX8()    
	   		EndIf
   		    
			
			//cRet += "/"+ SC5->C5_NUM  
			//ConfirmSX8()
			RestArea(aAreaC5)		
			
		EndIf
		
		If lPP
			aCab 		:= 	{}
			aItens 		:= 	{}
			cCliente 	:=	'000001'
			cLoja		:=	strzero(val(cfilant),4)
			aCab		:=	{}
			aItens		:=	{}
			aCab		:=	Cabecalho(2)
			Itens(2,'') 
			
			aAreaC5 := GetArea()
			cNumPed := GetSx8num("SC5","C5_NUM")	
			
			aCab[2,2] := cNumPed
			aAjuste		:=	{}
			For nZ := 1 to len(aItens)
				aItens[nZ,02,02] := cNumPed 
				//Acerto 4 casas decimais
				aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
				If len(aAux) > 1
					If len(aAux[2]) > 2
				   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
				   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
				   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
				   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
				 	EndIf
				EndIf
		        If aItens[nZ,10,2] == 0
		        	ADEL(aItens,nZ)
					ASIZE(aItens,Len(aItens)-1)
				EndIf
			Next nZ
			lMsErroAuto := .F.
			MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
			
			If lMsErroAuto
				MostraErro() 
			EndIF   
			
					//Acerto 4 casas decimais
			If len(aAjuste) > 0  
				DbSelectArea("SC6")
				DbSetOrder(1)    
				For nX := 1 to len(aAjuste)
					If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
						Reclock("SC6",.F.)
						SC6->C6_PRCVEN := aAjuste[nX,5]
						SC6->C6_VALOR  := aAjuste[nX,6]
						SC6->C6_PRUNIT := aAjuste[nX,7]
						SC6->(Msunlock())
					EndIf
				Next nX 
				DbSelectArea("SC9")
				DbSetOrder(1)
				For nX := 1 to len(aAjuste)
					If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
						Reclock("SC9",.F.)
						SC9->C9_PRCVEN := aAjuste[nX,5]
						SC9->(Msunlock())
					EndIf
				Next nX 
			EndIf
			
			If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
	   			cRet += "/"+ SC5->C5_NUM  
				ConfirmSX8()    
	   		EndIf 
			
			//cRet += "/"+ SC5->C5_NUM  
			//ConfirmSX8()
			RestArea(aAreaC5)      
		EndIf
	EndIf
	
	U_TTMAILN('microsiga@toktake.com.br',Alltrim(cusername)+'@toktake.com.br','Pedido SC','Pedido gerado '+cRet+' referente faturamento de caf้',{},.F.)
    RestArea(aArea)
    Cfilant	:=	_BkFilant
	Return(cRet)
EndIf

nRet := FormaFat(aContr[Ascan(aContr,{|x| x[1] == aProd[1,7]}),10])

If nRet == 0
	cOpcCmp := aContr[Ascan(aContr,{|x| x[1] == aProd[1,7]}),10]
ElseIf nRet == 1
	cOpcCmp := '1'
ElseIf nRet == 2  
	cOpcCmp := '2'
ElseIf nRet == 3
	cOpcCmp := '3'
EndIf
/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTipo de Faturamento - Posicao 10 do array Acontr       ณ
//ณ                                                       ณ
//ณ1 = Cliente                                            ณ
//ณ   Sera gerado um unico pedido de venda para todos     ณ
//ณ   os patrimonios contra o cliente que esta cadastrado ณ
//ณ   no contrato.                                        ณ
//ณ                                                       ณ
//ณ2 - Loja                                               ณ
//ณ   Sera gerado um pedido de venda por loja para cada   ณ
//ณ   patrimonio com este tipo de servico apontado nos    ณ
//ณ   contadores.                                         ณ
//ณ                                                       ณ
//ณ3 - Patrimonio                                         ณ
//ณ	  Sera gerado um pedido de venda por patrimonio       ณ
//ณ   contra a loja do mesmo                              ณ
//ณ                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ENDDOC*/

For nX := 1 to len(aProd)
	If aProd[nX,17] == "C"
		If MsgYesNo("Deseja faturar o complemento separado?","TTPROC22")
			cCompSep := 'S'
			exit
		Else
			cCompSep := If(cOpcCmp=="3",'S','N'	)
			exit
		EndIf   
	EndIf
Next nX

If cOpcCmp == "1" 
//Tipo de Faturamento por Cliente
	cCliente	:=	substr(aProd[1,6],1,6) 
	cLoja 	 	:=	substr(aProd[1,6],7,4)
	cPa		    :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_COD")
	cItCc       :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_ITCONT")
	
	//Possibilidade de se alterar o cliente+loja ou PA de faturamento no momento da geracao do pedido
	//Mais uma alteracao que o pessoal passou depois da rotina pronta. - Alexandre 19/02/14
	//aDif	:=	U_TTPROC26(cCliente,cLoja,aProd)
/*	
	If len(aDif) > 0
		cCliente := aDif[1,1]
		cLoja := aDif[1,2]
		For nX := 1 to len(aDif)
			If !empty(aDif[nX,04])
				cPa 	:= aDif[nX,04]
				cItCC	:= Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_ITCONT")
				exit
			EndIF   
		Next nX
	EndIf
*/	
	aCab	:=	Cabecalho(1)
	Itens(1,'')
	
	For nX := 1 to len(aProd)
		If aProd[nX,10] > 0
			lPP := .T.
			exit
		EndIf
	Next nX
    
	If len(aItens) > 0
		aAreaC5 := GetArea()
		cNumPed := GetSx8num("SC5","C5_NUM")	
		
		aCab[2,2] := cNumPed
		aAux := {} 
		aAjuste		:=	{}
		For nZ := 1 to len(aItens)
			aItens[nZ,02,02] := cNumPed
			
			aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
			If len(aAux) > 1
				If len(aAux[2]) > 2
			   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
			   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
			   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
			   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
			 	EndIf
			EndIf
	        If aItens[nZ,10,2] == 0
	        	ADEL(aItens,nZ)
				ASIZE(aItens,Len(aItens)-1)
			EndIf
	
		Next nZ
	
						
		lMsErroAuto := .F.
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
		
		If lMsErroAuto
			MostraErro() 
		EndIF   
		
		If len(aAjuste) > 0  
			DbSelectArea("SC6")
			DbSetOrder(1)    
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
					Reclock("SC6",.F.)
					SC6->C6_PRCVEN := aAjuste[nX,5]
					SC6->C6_VALOR  := aAjuste[nX,6]
					SC6->C6_PRUNIT := aAjuste[nX,7]
					SC6->(Msunlock())
				EndIf
			Next nX 
			DbSelectArea("SC9")
			DbSetOrder(1)
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
					Reclock("SC9",.F.)
					SC9->C9_PRCVEN := aAjuste[nX,5]
					SC9->(Msunlock())
				EndIf
			Next nX 
		EndIf
		
		If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
   			cRet := SC5->C5_NUM
			ConfirmSX8()    
   		EndIf
		//cRet := SC5->C5_NUM  
		//ConfirmSX8()
		
		RestArea(aAreaC5)
	EndIf
	
	If cCompSep == "S"
		
		aCab 		:= 	{}
		aItens 		:= 	{}
		cCliente	:=	substr(aProd[1,6],1,6) 
		cLoja 	 	:=	substr(aProd[1,6],7,4)
		aCab		:=	Cabecalho(3)
		Itens(3,'')   
		aAreaC5 := GetArea()
		cNumPed := GetSx8num("SC5","C5_NUM")	
		
		aCab[2,2] := cNumPed
		aAjuste		:=	{}
		For nZ := 1 to len(aItens)
			aItens[nZ,02,02] := cNumPed 
			//Acerto 4 casas decimais
			aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
			If len(aAux) > 1
				If len(aAux[2]) > 2
			   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
			   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
			   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
			   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
			 	EndIf
			EndIf
	        If aItens[nZ,10,2] == 0
	        	ADEL(aItens,nZ)
				ASIZE(aItens,Len(aItens)-1)
			EndIf
		Next nZ
		lMsErroAuto := .F.
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
		
		If lMsErroAuto
			MostraErro() 
		EndIF   
		//Acerto 4 casas decimais
		If len(aAjuste) > 0  
			DbSelectArea("SC6")
			DbSetOrder(1)    
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
					Reclock("SC6",.F.)
					SC6->C6_PRCVEN := aAjuste[nX,5]
					SC6->C6_VALOR  := aAjuste[nX,6]
					SC6->C6_PRUNIT := aAjuste[nX,7]
					SC6->(Msunlock())
				EndIf
			Next nX 
			DbSelectArea("SC9")
			DbSetOrder(1)
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
					Reclock("SC9",.F.)
					SC9->C9_PRCVEN := aAjuste[nX,5]
					SC9->(Msunlock())
				EndIf
			Next nX 
		EndIf    
		
		If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
   			cRet += If(!empty(cRet),"/",'')+ cNumPed 
   			ConfirmSX8()       
   		EndIf
   		
		//cRet += "/"+ SC5->C5_NUM  
		//ConfirmSX8()
		RestArea(aAreaC5)		
		
	EndIf
	
	If lPP
		aCab 		:= 	{}
		aItens 		:= 	{}
		cCliente 	:=	'000001'
		cLoja		:=	strzero(val(cfilant),4)
		aCab		:=	Cabecalho(2)
		Itens(2,'') 
		
		aAreaC5 := GetArea()
		cNumPed := GetSx8num("SC5","C5_NUM")	
		
		aCab[2,2] := cNumPed
		aAjuste		:=	{}
		For nZ := 1 to len(aItens)
			aItens[nZ,02,02] := cNumPed 
			//Acerto 4 casas decimais
			aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
			If len(aAux) > 1
				If len(aAux[2]) > 2
			   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
			   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
			   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
			   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
			 	EndIf
			EndIf
	        If aItens[nZ,10,2] == 0
	        	ADEL(aItens,nZ)
				ASIZE(aItens,Len(aItens)-1)
			EndIf
		Next nZ
		lMsErroAuto := .F.
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
		
		If lMsErroAuto
			MostraErro() 
		EndIF   
		
				//Acerto 4 casas decimais
		If len(aAjuste) > 0  
			DbSelectArea("SC6")
			DbSetOrder(1)    
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
					Reclock("SC6",.F.)
					SC6->C6_PRCVEN := aAjuste[nX,5]
					SC6->C6_VALOR  := aAjuste[nX,6]
					SC6->C6_PRUNIT := aAjuste[nX,7]
					SC6->(Msunlock())
				EndIf
			Next nX 
			DbSelectArea("SC9")
			DbSetOrder(1)
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
					Reclock("SC9",.F.)
					SC9->C9_PRCVEN := aAjuste[nX,5]
					SC9->(Msunlock())
				EndIf
			Next nX 
		EndIf
		If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
   			cRet += If(!empty(cRet),"/",'')+ cNumPed
			ConfirmSX8()           
   		EndIf 
		
		//cRet += "/"+ SC5->C5_NUM  
		//ConfirmSX8()
		RestArea(aAreaC5)      
	EndIf


		
	
	U_TTMAILN('microsiga@toktake.com.br',Alltrim(cusername)+'@toktake.com.br','Pedido SC','Pedido gerado '+cRet+' referente faturamento de caf้',{},.F.)
		
	
ElseIf cOpcCmp == "2"  
//Tipo de Faturamento por Loja   
	If cCompSep == "S"
		
		aCab 		:= 	{}
		aItens 		:= 	{}
		cCliente	:=	substr(aProd[1,6],1,6) 
		cLoja 	 	:=	substr(aProd[1,6],7,4) 
		cPa		    :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_COD")
		cItCc       :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_ITCONT")

		aCab		:=	Cabecalho(3)
		Itens(3,'')   
		aAreaC5 := GetArea()
		cNumPed := GetSx8num("SC5","C5_NUM")	
		
		aCab[2,2] := cNumPed
		aAjuste		:=	{}
		For nZ := 1 to len(aItens)
			aItens[nZ,02,02] := cNumPed
			//Acerto 4 casas decimais
			aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
			If len(aAux) > 1
				If len(aAux[2]) > 2
			   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
			   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
			   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
			   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
			 	EndIf
			EndIf
	        If aItens[nZ,10,2] == 0
	        	ADEL(aItens,nZ)
				ASIZE(aItens,Len(aItens)-1)
			EndIf
		Next nZ
		lMsErroAuto := .F.
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
		
		If lMsErroAuto
			MostraErro() 
		EndIf   
		
				//Acerto 4 casas decimais
		If len(aAjuste) > 0  
			DbSelectArea("SC6")
			DbSetOrder(1)    
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
					Reclock("SC6",.F.)
					SC6->C6_PRCVEN := aAjuste[nX,5]
					SC6->C6_VALOR  := aAjuste[nX,6]
					SC6->C6_PRUNIT := aAjuste[nX,7]
					SC6->(Msunlock())
				EndIf
			Next nX 
			DbSelectArea("SC9")
			DbSetOrder(1)
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
					Reclock("SC9",.F.)
					SC9->C9_PRCVEN := aAjuste[nX,5]
					SC9->(Msunlock())
				EndIf
			Next nX 
		EndIf
		
		aCab 		:= 	{}
		aItens 		:= 	{}
		
		If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
	   		cRet += If(!empty(cRet),"/",'')+ SC5->C5_NUM  
			ConfirmSX8()           
   		EndIf 
		
		cRet += If(!empty(cRet),"/",'')+ SC5->C5_NUM  
		//ConfirmSX8()
		RestArea(aAreaC5)		
		
	EndIf
	/* 
	COMENTADO ESTA PARTE POIS TODO O TRATAMENTO DAS DOSES FOI MODIFICADO DIRETO NA FUNCAO TTPROC20
	aAuxPr2 := FatPaLj()
	aAuxPr := aClone(aProd)  
	dxDt1 := aProd[1,18]
	dxDt2 := aProd[1,19]
    aProd := {}
	For nX := 1 to len(aAuxPr2)
        If !empty(aAuxPr2[nX,02])
        	Aadd(aProd,{aAuxPr2[nX,02],aAuxPr2[nX,03],aAuxPr2[nX,04],aAuxPr2[nX,05],;
        				Transform(aAuxPr2[nX,04]*aAuxPr2[nX,05],"@E 999,999,999.9999"),aAuxPr[1,6],aAuxPr[1,7],aAuxPr[1,8],;
        				aAuxPr2[nX,01],aAuxPr2[nX,06],Transform(aAuxPr2[nX,04]*aAuxPr2[nX,06],"@E 999,999,999.9999"),;
        				aAuxPr[1,12],aAuxPr[1,13],aAuxPr[1,14],aAuxPr[1,15],aAuxPr[1,16],aAuxPr[1,17],dxDt1,dxDt2}) 
        EndIf
	Next nX 
	*/
	cPtr := substr(aProd[1,6],8,4)
	cCliente	:=	substr(aProd[1,6],1,6) 
	cLoja 	 	:=	substr(aProd[1,6],7,4)
	cPa		    :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_COD")
	cItCc       :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_ITCONT")
	aCab	:=	Cabecalho(1)
	
	For nX := 1 to len(aProd)
		If cPtr != substr(aProd[nX,6],8,4)
			aAreaC5 := GetArea()
			cNumPed := GetSx8num("SC5","C5_NUM")	
			
			aCab[2,2] := cNumPed
			aAjuste		:=	{}
			For nZ := 1 to len(aItens)
				aItens[nZ,02,02] := cNumPed
				//Acerto 4 casas decimais
				aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
				If len(aAux) > 1
					If len(aAux[2]) > 2
				   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
				   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
				   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
				   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
				 	EndIf
				EndIf
		        If aItens[nZ,10,2] == 0
		        	ADEL(aItens,nZ)
					ASIZE(aItens,Len(aItens)-1)
				EndIf
			Next nZ
			lMsErroAuto := .F.
			MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
			
			If lMsErroAuto
				MostraErro() 
			EndIF   
			
							//Acerto 4 casas decimais
			If len(aAjuste) > 0  
				DbSelectArea("SC6")
				DbSetOrder(1)    
				For nX := 1 to len(aAjuste)
					If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
						Reclock("SC6",.F.)
						SC6->C6_PRCVEN := aAjuste[nX,5]
						SC6->C6_VALOR  := aAjuste[nX,6]
						SC6->C6_PRUNIT := aAjuste[nX,7]
						SC6->(Msunlock())
					EndIf
				Next nX 
				DbSelectArea("SC9")
				DbSetOrder(1)
				For nX := 1 to len(aAjuste)
					If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
						Reclock("SC9",.F.)
						SC9->C9_PRCVEN := aAjuste[nX,5]
						SC9->(Msunlock())
					EndIf
				Next nX 
			EndIf
			
			If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
			   	cRet += If(!empty(cRet),"/",'') + SC5->C5_NUM  
				ConfirmSX8()           
   			EndIf 
   		
			
			//cRet += If(!empty(cRet),"/",'') + SC5->C5_NUM  
			aItens := {}
			aCab   := {}
			
			RestArea(aAreaC5)
		
			cPtr := substr(aProd[nX,6],8,4)
			cCliente	:=	substr(aProd[nX,6],1,6) 
			cLoja 	 	:=	substr(aProd[nX,6],7,4)
			cPa		    :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_COD")
			cItCc       :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_ITCONT")
			aCab	:=	Cabecalho(1)
		EndIf
		
		If !cPtr $ cPtAux
			Itens(4,'')
			cPtAux += "/" + cPtr
		EndIf
		
	Next nX
	
	If len(aItens) > 0
		aAreaC5 := GetArea()
		cNumPed := GetSx8num("SC5","C5_NUM")	
		
		aCab[2,2] := cNumPed
		aAjuste		:=	{}
		For nZ := 1 to len(aItens)
			aItens[nZ,02,02] := cNumPed  
			//Acerto 4 casas decimais
			aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
			If len(aAux) > 1
				If len(aAux[2]) > 2
			   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
			   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
			   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
			   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
			 	EndIf
			EndIf
	        If aItens[nZ,10,2] == 0
	        	ADEL(aItens,nZ)
				ASIZE(aItens,Len(aItens)-1)
			EndIf

		Next nZ
		lMsErroAuto := .F.
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
		
		If lMsErroAuto
			MostraErro() 
		EndIF   
		
						//Acerto 4 casas decimais
		If len(aAjuste) > 0  
			DbSelectArea("SC6")
			DbSetOrder(1)    
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
					Reclock("SC6",.F.)
					SC6->C6_PRCVEN := aAjuste[nX,5]
					SC6->C6_VALOR  := aAjuste[nX,6]
					SC6->C6_PRUNIT := aAjuste[nX,7]
					SC6->(Msunlock())
				EndIf
			Next nX 
			DbSelectArea("SC9")
			DbSetOrder(1)
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
					Reclock("SC9",.F.)
					SC9->C9_PRCVEN := aAjuste[nX,5]
					SC9->(Msunlock())
				EndIf
			Next nX 
		EndIf
		If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
			cRet += If(!empty(cRet),"/",'') +cNumPed 
			ConfirmSX8() 
		EndIf
		//ConfirmSX8()
		
		RestArea(aAreaC5) 
	EndIf
	
	For nX := 1 to len(aProd)
		If aProd[nX,10] > 0
			lPP := .T.
			exit
		EndIf
	Next nX

	If lPP
		aCab 		:= 	{}
		aItens 		:= 	{}
		cCliente 	:=	'000001'
		cLoja		:=	strzero(val(cfilant),4)
		aCab		:=	Cabecalho(2)
		Itens(2,'')
		
		aAreaC5 := GetArea()
		cNumPed := GetSx8num("SC5","C5_NUM")	
		
		aCab[2,2] := cNumPed
		aAjuste		:=	{}
		For nZ := 1 to len(aItens)
			aItens[nZ,02,02] := cNumPed
				//Acerto 4 casas decimais
				aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
				If len(aAux) > 1
					If len(aAux[2]) > 2
				   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
				   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
				   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
				   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
				 	EndIf
				EndIf
		        If aItens[nZ,10,2] == 0
		        	ADEL(aItens,nZ)
					ASIZE(aItens,Len(aItens)-1)
				EndIf
	
		Next nZ
		lMsErroAuto := .F.
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
		
		If lMsErroAuto
			MostraErro() 
		EndIF   
	
					//Acerto 4 casas decimais
		If len(aAjuste) > 0  
			DbSelectArea("SC6")
			DbSetOrder(1)    
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
					Reclock("SC6",.F.)
					SC6->C6_PRCVEN := aAjuste[nX,5]
					SC6->C6_VALOR  := aAjuste[nX,6]
					SC6->C6_PRUNIT := aAjuste[nX,7]
					SC6->(Msunlock())
				EndIf
			Next nX 
			DbSelectArea("SC9")
			DbSetOrder(1)
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
					Reclock("SC9",.F.)
					SC9->C9_PRCVEN := aAjuste[nX,5]
					SC9->(Msunlock())
				EndIf
			Next nX 
		EndIf
		If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
   			cRet += If(!empty(cRet),"/",'')+ cNumPed
   			ConfirmSX8()        
   		EndIf
	EndIf

 
	//ConfirmSX8()
	RestArea(aAreaC5)
		
	
	U_TTMAILN('microsiga@toktake.com.br',Alltrim(cusername)+'@toktake.com.br','Pedido SC','Pedido gerado '+cRet+' referente faturamento de caf้',{},.F.)
		    
	 
ElseIf cOpcCmp == "3"
//Tipo de Faturamento por Patrimonio  	
	If cCompSep == "S"
		
		aCab 		:= 	{}
		aItens 		:= 	{}
		cCliente	:=	substr(aProd[1,6],1,6) 
		cLoja 	 	:=	substr(aProd[1,6],7,4) 
		cPa		    :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_COD")
		cItCc       :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_ITCONT")

		aCab		:=	Cabecalho(3)
		Itens(3,'')   
		aAreaC5 := GetArea()
		cNumPed := GetSx8num("SC5","C5_NUM")	
		
		aCab[2,2] := cNumPed
		aAjuste		:=	{}
		For nZ := 1 to len(aItens)
			aItens[nZ,02,02] := cNumPed
						//Acerto 4 casas decimais
			aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
			If len(aAux) > 1
				If len(aAux[2]) > 2
			   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
			   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
			   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
			   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
			 	EndIf
			EndIf
	        If aItens[nZ,10,2] == 0
	        	ADEL(aItens,nZ)
				ASIZE(aItens,Len(aItens)-1)
			EndIf

		Next nZ
		lMsErroAuto := .F.
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
		
		If lMsErroAuto
			MostraErro() 
		EndIF   
 
					//Acerto 4 casas decimais
		If len(aAjuste) > 0  
			DbSelectArea("SC6")
			DbSetOrder(1)    
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
					Reclock("SC6",.F.)
					SC6->C6_PRCVEN := aAjuste[nX,5]
					SC6->C6_VALOR  := aAjuste[nX,6]
					SC6->C6_PRUNIT := aAjuste[nX,7]
					SC6->(Msunlock())
				EndIf
			Next nX 
			DbSelectArea("SC9")
			DbSetOrder(1)
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
					Reclock("SC9",.F.)
					SC9->C9_PRCVEN := aAjuste[nX,5]
					SC9->(Msunlock())
				EndIf
			Next nX 
		EndIf
			
		aCab 		:= 	{}
		aItens 		:= 	{}
		
		If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
	   		cRet += If(!empty(cRet),"/",'')+ SC5->C5_NUM 
   			ConfirmSX8()        
   		EndIf
		
		//cRet += If(!empty(cRet),"/",'')+ SC5->C5_NUM  
		//ConfirmSX8()
		RestArea(aAreaC5)		
		
	EndIf
	
	aAuxPr2 := FatPaLj()
	aAuxPr := aClone(aProd)
    aProd := {}
	For nX := 1 to len(aAuxPr2)
        If !empty(aAuxPr2[nX,02])
        	Aadd(aProd,{aAuxPr2[nX,02],aAuxPr2[nX,03],aAuxPr2[nX,04],aAuxPr2[nX,05],;
        				Transform(aAuxPr2[nX,04]*aAuxPr2[nX,05],"@E 999,999,999.9999"),aAuxPr[1,6],aAuxPr[1,7],aAuxPr[1,8],;
        				aAuxPr2[nX,01],aAuxPr2[nX,06],Transform(aAuxPr2[nX,04]*aAuxPr2[nX,06],"@E 999,999,999.9999"),;
        				aAuxPr[1,12],aAuxPr[1,13],aAuxPr[1,14],aAuxPr[1,15],aAuxPr[1,16],aAuxPr[1,17]}) 
        EndIf
	Next nX 
	
	cPtr := aProd[1,9]
	cCliente	:=	substr(aProd[1,6],1,6) 
	cLoja 	 	:=	substr(aProd[1,6],7,4)
	cPa		    :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_COD")
	cItCc       :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_ITCONT")
	aCab	:=	Cabecalho(1)
	
	For nX := 1 to len(aProd)
		If cPtr != aProd[nX,09]
			aAreaC5 := GetArea()
			cNumPed := GetSx8num("SC5","C5_NUM")	
			
			aCab[2,2] := cNumPed
			aAjuste		:=	{}
			For nZ := 1 to len(aItens)
				aItens[nZ,02,02] := cNumPed
							//Acerto 4 casas decimais
				aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
				If len(aAux) > 1
					If len(aAux[2]) > 2
				   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
				   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
				   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
				   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
				 	EndIf
				EndIf
		        If aItens[nZ,10,2] == 0
		        	ADEL(aItens,nZ)
					ASIZE(aItens,Len(aItens)-1)
				EndIf
	
			Next nZ
			lMsErroAuto := .F.
			MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
			
			If lMsErroAuto
				MostraErro() 
			EndIF   
			
							//Acerto 4 casas decimais
			If len(aAjuste) > 0  
				DbSelectArea("SC6")
				DbSetOrder(1)    
				For nX := 1 to len(aAjuste)
					If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
						Reclock("SC6",.F.)
						SC6->C6_PRCVEN := aAjuste[nX,5]
						SC6->C6_VALOR  := aAjuste[nX,6]
						SC6->C6_PRUNIT := aAjuste[nX,7]
						SC6->(Msunlock())
					EndIf
				Next nX 
				DbSelectArea("SC9")
				DbSetOrder(1)
				For nX := 1 to len(aAjuste)
					If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
						Reclock("SC9",.F.)
						SC9->C9_PRCVEN := aAjuste[nX,5]
						SC9->(Msunlock())
					EndIf
				Next nX 
			EndIf
			
			If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
   				cRet += If(!empty(cRet),"/",'') + SC5->C5_NUM  
   				ConfirmSX8()        
   			EndIf
   		
			
	
			aItens := {}
			aCab   := {}
			
			RestArea(aAreaC5)
		
			cPtr := aProd[nX,09]
			cCliente	:=	substr(aProd[nX,6],1,6) 
			cLoja 	 	:=	substr(aProd[nX,6],7,4)
			cPa		    :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_COD")
			cItCc       :=	Posicione("ZZ1",3,xFilial("ZZ1")+cCliente+cLoja,"ZZ1_ITCONT")
			aCab	:=	Cabecalho(1)
		EndIf
		
		If !cPtr $ cPtAux
			Itens(1,cPtr)
			cPtAux += "/" + cPtr
		EndIf
		
	Next nX
	
	If len(aItens) > 0
		aAreaC5 := GetArea()
		cNumPed := GetSx8num("SC5","C5_NUM")	
		
		aCab[2,2] := cNumPed
		aAjuste		:=	{}
		For nZ := 1 to len(aItens)
			aItens[nZ,02,02] := cNumPed  
						//Acerto 4 casas decimais
			aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
			If len(aAux) > 1
				If len(aAux[2]) > 2
			   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
			   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
			   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
			   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
			 	EndIf
			EndIf
	        If aItens[nZ,10,2] == 0
	        	ADEL(aItens,nZ)
				ASIZE(aItens,Len(aItens)-1)
			EndIf

		Next nZ
		lMsErroAuto := .F.
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
		
		If lMsErroAuto
			MostraErro() 
		EndIF   
		
						//Acerto 4 casas decimais
		If len(aAjuste) > 0  
			DbSelectArea("SC6")
			DbSetOrder(1)    
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
					Reclock("SC6",.F.)
					SC6->C6_PRCVEN := aAjuste[nX,5]
					SC6->C6_VALOR  := aAjuste[nX,6]
					SC6->C6_PRUNIT := aAjuste[nX,7]
					SC6->(Msunlock())
				EndIf
			Next nX 
			DbSelectArea("SC9")
			DbSetOrder(1)
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
					Reclock("SC9",.F.)
					SC9->C9_PRCVEN := aAjuste[nX,5]
					SC9->(Msunlock())
				EndIf
			Next nX 
		EndIf
		
				
		If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
   			cRet += If(!empty(cRet),"/",'')+SC5->C5_NUM  
   			ConfirmSX8()        
   		EndIf
		
		//cRet += If(!empty(cRet),"/",'')+SC5->C5_NUM  
		//ConfirmSX8()
		
		RestArea(aAreaC5) 
	EndIf
	
	For nX := 1 to len(aProd)
		If aProd[nX,10] > 0
			lPP := .T.
			exit
		EndIf
	Next nX

	If lPP
		aCab 		:= 	{}
		aItens 		:= 	{}
		cCliente 	:=	'000001'
		cLoja		:=	strzero(val(cfilant),4)
		aCab		:=	Cabecalho(2)
		Itens(2,'')       
	EndIf

	aAreaC5 := GetArea()
	cNumPed := GetSx8num("SC5","C5_NUM")	
	
	aCab[2,2] := cNumPed
	aAjuste		:=	{}
	For nZ := 1 to len(aItens)
		aItens[nZ,02,02] := cNumPed     
					//Acerto 4 casas decimais
			aAux := StrtokArr(cvaltochar(aItens[nZ,10,2]),".")
			If len(aAux) > 1
				If len(aAux[2]) > 2
			   		Aadd(aAjuste,{aItens[nZ,1,2],aItens[nZ,2,2],aItens[nZ,3,2],aItens[nZ,4,2],aItens[nZ,10,2],aItens[nZ,11,2],aItens[nZ,12,2]}) 
			   		aItens[nZ,10,2] := Round(aItens[nZ,10,2],2)  
			   		aItens[nZ,11,2] := Round(aItens[nZ,10,2]*aItens[nZ,6,2],2)
			   		aItens[nZ,12,2] := Round(aItens[nZ,12,2],2)
			 	EndIf
			EndIf
	        If aItens[nZ,10,2] == 0
	        	ADEL(aItens,nZ)
				ASIZE(aItens,Len(aItens)-1)
			EndIf

	Next nZ
	lMsErroAuto := .F.
	MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    
	
	If lMsErroAuto
		MostraErro() 
	EndIF   
	
	//Acerto 4 casas decimais
	If len(aAjuste) > 0  
		DbSelectArea("SC6")
		DbSetOrder(1)    
		For nX := 1 to len(aAjuste)
			If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
				Reclock("SC6",.F.)
				SC6->C6_PRCVEN := aAjuste[nX,5]
				SC6->C6_VALOR  := aAjuste[nX,6]
				SC6->C6_PRUNIT := aAjuste[nX,7]
				SC6->(Msunlock())
			EndIf
		Next nX 
		DbSelectArea("SC9")
		DbSetOrder(1)
		For nX := 1 to len(aAjuste)
			If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
				Reclock("SC9",.F.)
				SC9->C9_PRCVEN := aAjuste[nX,5]
				SC9->(Msunlock())
			EndIf
		Next nX 
	EndIf
	
	If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM")  )
		cRet += If(!empty(cRet),"/",'')+ SC5->C5_NUM  
   		ConfirmSX8()        
   	EndIf
	
	//cRet += If(!empty(cRet),"/",'')+ SC5->C5_NUM  
	//ConfirmSX8()
	RestArea(aAreaC5)
			
	U_TTMAILN('microsiga@toktake.com.br',Alltrim(cusername)+'@toktake.com.br','Pedido SC','Pedido gerado '+cRet+' referente faturamento de caf้',{},.F.)
		    	
EndIf

RestArea(aArea)

cfilant := _BkFilant

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA03  บAutor  ณMicrosiga           บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Cabecalho do pedido                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cabecalho(nOpcao)

Local aArea		:=	GetArea()
Local aCabec	:= {}            
Local cMenota	:= '' 
Local cP1		:= aProd[1,18] //aProRa[Ascan(aProra,{|x| x[1] == aProd[1,7]}),04] + 1		
Local cP2		:= aProd[1,19] //aProRa[Ascan(aProra,{|x| x[1] == aProd[1,7]}),05]    


Aadd(aCabec,{"C5_FILIAL"	,xFilial("SC5") 					,Nil})    
Aadd(aCabec,{"C5_NUM"		,''    								,Nil})
Aadd(aCabec,{"C5_TIPO"		,'N'			 					,Nil})   
Aadd(aCabec,{"C5_CLIENTE"	,cCliente							,Nil})  
Aadd(aCabec,{"C5_LOJACLI"	,cLoja						  		,Nil})  
Aadd(aCabec,{"C5_CLIENT"	,cCliente					  		,Nil})  
Aadd(aCabec,{"C5_LOJAENT"	,cLoja								,Nil}) 
//Aadd(aCabec,{"C5_XIDPCA"	,''    								,Nil})                
Aadd(aCabec,{"C5_XDTENTR"	,DDATABASE+3						,Nil})  
Aadd(aCabec,{"C5_XNFABAS"	,'2'			 					,Nil})   
Aadd(aCabec,{"C5_XCODPA"	,If(nOpcao==2 .and. cCliente<>'000001',cPa,SPACE(6))		,Nil}) 
Aadd(aCabec,{"C5_XFINAL"	,If(nOpcao!=3,'J','S')	 			,Nil})          
//Aadd(aCabec,{"C5_XFLDEST"	,''				   					,Nil})
Aadd(aCabec,{"C5_TRANSP"	,'000019'		 					,Nil})          
Aadd(aCabec,{"C5_XTPCARG"	,'1'			 					,Nil})
Aadd(aCabec,{"C5_XHRPREV"	,'00:00'		 					,Nil})
Aadd(aCabec,{"C5_CONDPAG"	,If(cCliente=="000001","118",aContr[Ascan(aContr,{|x| x[1] == aProd[1,7]}),04])			 					,Nil})
Aadd(aCabec,{"C5_TABELA"	,aProd[1,16] 						,Nil})
Aadd(aCabec,{"C5_XCCUSTO"	,'70500001'						   	,Nil})
Aadd(aCabec,{"C5_XITEMCC"	,cItCc								,Nil})
Aadd(aCabec,{"C5_MOEDA"		,1 									,Nil})
Aadd(aCabec,{"C5_FRETE"		,0 									,Nil})
Aadd(aCabec,{"C5_TXMOEDA"	,0 									,Nil})
Aadd(aCabec,{"C5_EMISSAO"	,ddatabase		 					,Nil})
Aadd(aCabec,{"C5_XGPV"		,'PRO-A'		 					,Nil})
Aadd(aCabec,{"C5_MENNOTA"	,'REFERENTE AO PERIODO DE '+cvaltochar(cP1)+" A "+cvaltochar(cP2)+substr(aProd[1,6],12,20)					,Nil})
Aadd(aCabec,{"C5_ESPECI1"	,'UN'	 		  					,Nil})
Aadd(aCabec,{"C5_XHRINC" 	,cvaltochar(TIME())					,Nil})
Aadd(aCabec,{"C5_XDATINC"	,DATE()								,Nil})
Aadd(aCabec,{"C5_XLOCAL" 	,cPa								,Nil})
Aadd(aCabec,{"C5_XNOMUSR"	,cUserName 							,Nil})
Aadd(aCabec,{"C5_XCODUSR"	,__cUserId 		   					,Nil})
Aadd(aCabec,{"C5_TPFRETE"	,"C" 								,Nil})
Aadd(aCabec,{"C5_TIPOCLI"	,Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_TIPO") 								,Nil})
Aadd(aCabec,{"C5_TIPLIB" 	,'1'			  					,Nil})
Aadd(aCabec,{"C5_VEND1"  	,'000023' 		  					,Nil})
Aadd(aCabec,{"C5_XTPPAG" 	,If(cCliente=="000001","TOK",'BOL')				  				,Nil})

RestArea(aArea)

Return(aCabec)             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA03  บAutor  ณMicrosiga           บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Itens do pedido.                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                          	              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Itens(nOpcao,cPatr)
 
Local aArea		:=	GetArea()
Local nX		:=	0 
Local nCont		:=	1
Local cTes		:=	space(3)
Local aAreaC6   :=	{}   
Local nCustoD	:=	0
Local nCsv		:=	0

cTpCli  := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_TIPO")
cxFinal := If(nOpcao!=3,'J','S') //'J'
cEPP    := Posicione("SA1",1,xFilial("SA1") +cCliente+cLoja," A1_XEPP")   

cOpera  := U_TTOPERA('PRO-A',cTpCli,cxFinal,cEPP)  

If Empty(cOpera)
	cOpera := '21'
EndIf


			
For nX := 1 to len(aProd)
	//Faturar os complementos separados.
	If (cCompSep == "S" .AND. aProd[nX,17] == "C" .AND. nOpcao != 3) .OR. (nOpcao == 2 .AND. aProd[nX,10] == 0)
		LOOP
	EndIf
	//Faturamento de complemento
	If nOpcao == 3 .AND. aProd[nX,17] != "C"
		Loop
	EndIf       
	//Faturamento por patrimonio
	If !empty(cPatr)
		If nOpcao == 1 .AND. aProd[nX,09] != cPatr
			Loop
		EndIf
	EndIf 
	//Faturamento por loja
	If nOpcao == 4 .And. substr(aProd[nX,06],7,4) != cLoja
		Loop
	EndIf
	If (nOpcao==1 .Or. nOpcao==3 .Or. nOpcao==4) .And. aProd[nX,04] == 0 
		Loop
	EndIf
	
	DbSelectArea("SB2")
	DbSetOrder(1)
	If !DbSeek(xFilial("SB2")+AvKey(aProd[nX,01],"B2_COD")+cPa)
		Reclock("SB2",.T.)
		SB2->B2_FILIAL	:=	xFilial("SB2")	
		SB2->B2_COD		:=	aProd[nX,01]
		SB2->B2_LOCAL	:=	cPa
		SB2->(Msunlock())
	EndIf
		    

	If !Empty(cOpera)
		//Buscando a TES a ser informada no item do pv.
		aAreaF4 := GetArea()
		cQueryX := "SELECT FM_TS,F4_CF"
		cQueryX += " FROM "+RetSQLName("SFM")+" FM"
		cQueryX += "	INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_FILIAL=FM_FILIAL AND F4_CODIGO=FM_TS AND F4.D_E_L_E_T_=''"
		cQueryX += " WHERE FM_TIPO='"+cOpera+"' AND FM_FILIAL='"+xFilial("SFM")+"' AND FM_GRPROD='"+Posicione("SB1",1,xFilial("SB1")+aProd[nX,01],"B1_GRTRIB")+"' AND FM.D_E_L_E_T_=''"
		cQueryX += " AND FM_EST='"+Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_EST")+"'"
	
		If Select('TRB2') > 0
			dbSelectArea('TRB2')
			dbCloseArea()
		EndIf       
		
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryX),"TRB2",.F.,.T.)
		dbSelectArea("TRB2")
		cTes := If(Empty(TRB2->FM_TS),space(3),TRB2->FM_TS) 
	EndIf
	If Empty(cTes)
		cTes := TesInf()
	EndIf  
	
	nCustoD	:=	Custodose(aProd[nX,01])   
   	aAreaC6 := GetArea()
	aMata240 := {}
	aAdd(aMata240, {})
	aAdd(aMata240[1], {'D3_TM'     ,'010'          ,Nil})
	aAdd(aMata240[1], {'D3_COD'    ,aProd[nX,01]	,Nil})
	aAdd(aMata240[1], {'D3_UM'     ,Posicione("SB1",1,xFilial("SB1")+aProd[nX,01],"B1_UM")     ,Nil})
	aAdd(aMata240[1], {'D3_QUANT'  ,aProd[nX,03]	,Nil})
	aAdd(aMata240[1], {'D3_CUSTO1' ,nCustoD			,Nil})
	aAdd(aMata240[1], {'D3_LOCAL'  ,cPa				,Nil})
	aAdd(aMata240[1], {'D3_EMISSAO',ddatabase		,Nil})
	aAdd(aMata240[1], {'D3_DOC'    ,NextNumero("SD3",2,"D3_DOC",.T.)    ,Nil})
	aAdd(aMata240[1], {'D3_CC'     ,'70500001'		,Nil})
	aAdd(aMata240[1], {'D3_ITEMCTA',cItCc		 	,Nil})
	aAdd(aMata240[1], {'D3_XORIGEM',"TTPROC22" 		,Nil}) 
		
	lMsErroAuto := .F.
	
	MSExecAuto({|x,y| mata240(x,y)},aMata240[1],3)
	
	If lMsErroAuto
		MostraErro()
	EndIf
	
	RestArea(aAreaC6)
	
	If Posicione("SB1",1,xFilial("SB1")+aProd[nX,01],"B1_TIPCONV") =="M"
		nCsv := aProd[nX,03] * Posicione("SB1",1,xFilial("SB1")+aProd[nX,01],"B1_CONV")
	Else
		nCsv := aProd[nX,03] / Posicione("SB1",1,xFilial("SB1")+aProd[nX,01],"B1_CONV")
	EndIf
	                                
	Aadd(aItens,{{"C6_FILIAL"		,xFilial("SC6")	 						,Nil},;
					{"C6_NUM"		,'' 									,Nil},; 
					{"C6_ITEM"		,Strzero(nCont,2)		 				,Nil},; 
					{"C6_PRODUTO"	,aProd[nX,01]	 						,Nil},;
					{"C6_XPRDORI"	,aProd[nX,01]	 						,Nil},;
					{"C6_QTDVEN"	,aProd[nX,03]							,Nil},;
					{"C6_XQTDORI"	,aProd[nX,03]							,Nil},;
					{"C6_TPOP"		,"F" 									,Nil},;
					{"C6_UNSVEN"	,nCsv 				   					,Nil},;
					{"C6_PRCVEN"	,round(If(nOpcao==1 .Or. nOpcao==3 .Or. nOpcao==4,aProd[nX,04],aProd[nX,10]),4)					,Nil},;
					{"C6_VALOR"		,round(If(nOpcao==1 .Or. nOpcao==3 .Or. nOpcao==4,aProd[nX,04],aProd[nX,10])*aProd[nX,03],4)	,Nil},;
					{"C6_PRUNIT"	,round(If(nOpcao==1 .Or. nOpcao==3 .Or. nOpcao==4,aProd[nX,04],aProd[nX,10]),4)					,Nil},;
					{"C6_TES"		,cTes									,Nil},;
					{"C6_VALDESC"	,0										,Nil},;
					{"C6_CLI"		,cCliente								,Nil},;
					{"C6_LOJA"		,cLoja									,Nil},;
					{"C6_LOCAL"		,cPa									,Nil},;
					{"C6_CCUSTO"	,'70500001'								,Nil},;
					{"C6_ITEMCC"	,cItCc 									,Nil},;
					{"C6_XGPV" 		,'PRO-A'								,Nil},;
					{"C6_ENTREG"	,ddatabase+3							,Nil},;
					{"C6_XDTEORI"	,ddatabase+3							,Nil},;
					{"C6_UM"		,Posicione("SB1",1,xFilial("SB1")+aProd[nX,01],"B1_UM")	,Nil},;
					{"C6_SEGUM"		,Posicione("SB1",1,xFilial("SB1")+aProd[nX,01],"B1_SEGUM")	,Nil},;
					{"C6_XPATRIM"	,aProd[nX,09]					   		,Nil},;
					{"C6_XHRINC" 	,TIME() 								,Nil},;
					{"C6_XDATINC"	,DATE()		 							,Nil},;
					{"C6_XUSRINC"	,cUsername 	 							,Nil}})
	nCont++
//
							
Next nX


RestArea(aArea)

Return(aItens)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC22  บAutor  ณMicrosiga           บ Data ณ  10/29/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TesInf()

Local cTes	:=	space(3)

Local oDlg1,oSay1,oGet1,oBtn1

oDlg1      := MSDialog():New( 091,232,226,498,"TES nใo encontrada",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 016,008,{||"Informe a TES"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGet1      := TGet():New( 016,056,{|u| If(PCount()>0,cTes:=u,cTes)},oDlg1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF4","",,)
oBtn1      := TButton():New( 036,044,"Confirmar",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.) 

Return(cTes)                               


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC22  บAutor  ณMicrosiga           บ Data ณ  11/13/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Forma a ser faturado o cliente.                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FormaFat(nOpc)

Local aArea	:=	GetArea()
Local oDlgf,oGrpf,oSay1f,oRMenu1,oBtn1f
Local aItens := {"0 - Mant้m como esta no contrato","1 - Faturar por Cliente","2 - Faturar por Loja","3 - Faturar por Patrim๔nio."}
Local aForCnt	:=	{"Faturado por Cliente","Faturado por Loja","Faturado por Patrim๔nio"}
Local nRadio := val(nOpc)

oDlgf      := MSDialog():New( 091,232,368,766,"Forma de Faturamento",,,.F.,,,,,,.T.,,,.T. )
oGrpf      := TGroup():New( 004,036,032,220,"Contrato",oDlgf,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1f      := TSay():New( 016,048,{||aForCnt[val(nOpc)]},oGrpf,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,160,008)
GoRMenu1   := TGroup():New( 044,064,096,184,"Op็๕es",oDlgf,CLR_BLACK,CLR_WHITE,.T.,.F. )
oRadio := TRadMenu():Create (oDlgf,,054,070,aItens,,,,,,,,100,12,,,,.T.) 
oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}

oBtn1f      := TButton():New( 108,100,"Confirmar",oDlgf,{||oDlgf:end()},037,012,,,,.T.,,"",,,,.F. )

oDlgf:Activate(,,,.T.)

RestArea(aArea)

Return(nRadio-1)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC22  บAutor  ณMicrosiga           บ Data ณ  11/13/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Faturamento por loja ou patrimonio.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FatPaLj()
                       
Local aArea		:=	GetArea() 
Local aSheAn	:=	{} 
Local aAux		:=	strtokarr(aProd[1,09],"/") 

For nX := 1 to len(aAux)
	
	cQuery := "SELECT DISTINCT ZN_CLIENTE,ZN_LOJA,ZN_PATRIMO"+chr(13)+chr(10)
	cQuery += " ,ZN_BOTAO01 - (SELECT TOP 1 ZN_BOTAO01 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO01"+chr(13)+chr(10)
	cQuery += " ,ZN_BOTAO02 - (SELECT TOP 1 ZN_BOTAO02 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO02"+chr(13)+chr(10)  
	cQuery += " ,ZN_BOTAO03 - (SELECT TOP 1 ZN_BOTAO03 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO03"+chr(13)+chr(10)  
	cQuery += " ,ZN_BOTAO04 - (SELECT TOP 1 ZN_BOTAO04 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO04"+chr(13)+chr(10)  
	cQuery += " ,ZN_BOTAO05 - (SELECT TOP 1 ZN_BOTAO05 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO05"+chr(13)+chr(10)  
	cQuery += " ,ZN_BOTAO06 - (SELECT TOP 1 ZN_BOTAO06 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO06"+chr(13)+chr(10)  
	cQuery += " ,ZN_BOTAO07 - (SELECT TOP 1 ZN_BOTAO07 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO07"+chr(13)+chr(10)  
	cQuery += " ,ZN_BOTAO08 - (SELECT TOP 1 ZN_BOTAO08 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO08"+chr(13)+chr(10)  
	cQuery += " ,ZN_BOTAO09 - (SELECT TOP 1 ZN_BOTAO09 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO09"+chr(13)+chr(10)  
	cQuery += " ,ZN_BOTAO10 - (SELECT TOP 1 ZN_BOTAO10 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO10"+chr(13)+chr(10)  
	cQuery += " ,ZN_BOTAO11 - (SELECT TOP 1 ZN_BOTAO11 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO11"+chr(13)+chr(10)  
	cQuery += " ,ZN_BOTAO12 - (SELECT TOP 1 ZN_BOTAO12 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO12"+chr(13)+chr(10) 
	            
	For nTT := 1 to 12
		cQuery += " ,N1_XP"+cvaltochar(nTT)+",D"+cvaltochar(nTT)+".DA1_PRCVEN AS PE"+cvaltochar(nTT)+",D"+cvaltochar(nTT)+".DA1_XPRCPP AS PP"+cvaltochar(nTT)+chr(13)+chr(10)
	Next nTT
	
	cQuery += " FROM "+RetSQLName("SZN")+" ZN"+chr(13)+chr(10)
	cQuery += " INNER JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZN_PATRIMO AND N1.D_E_L_E_T_=''"+chr(13)+chr(10)
	cQuery += " LEFT JOIN "+RetSQLName("DA0")+" DA0 ON DA0_XCLIEN=ZN_CLIENTE AND DA0_XLOJA=ZN_LOJA AND DA0.D_E_L_E_T_='' AND DA0_ATIVO='1'"+chr(13)+chr(10)
	
	For nTT := 1 to 12                                                                                                       
		cQuery += " LEFT JOIN "+RetSQLName("DA1")+" D"+cvaltochar(nTT)+" ON D"+cvaltochar(nTT)+".DA1_CODTAB=DA0_CODTAB AND D"+cvaltochar(nTT)+".DA1_CODPRO=N1_XP"+cvaltochar(nTT)+" AND D"+cvaltochar(nTT)+".D_E_L_E_T_=''"+chr(13)+chr(10)
	Next nTT
	
	cQuery += " WHERE ZN_TIPINCL<>'SANGRIA' AND ZN.D_E_L_E_T_='' AND ZN_DATA='"+dtos(aProd[1,19])+"'"//AND (ZN_DATA BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' OR ZN_CONFERE='1')"+chr(13)+chr(10)
	cQuery += " AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"'"+chr(13)+chr(10)
	cQuery += " ORDER BY 7 DESC"+chr(13)+chr(10)
	

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTPRO20.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	While !EOF()	
            IF Ascan(aSheAn,{|x| x[1] == TRB->ZN_PATRIMO}) == 0
			Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP1,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP1,"B1_DESC")),TRB->UF_BOTAO01,TRB->PE1,TRB->PP1,'1'})
			Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP2,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP2,"B1_DESC")),TRB->UF_BOTAO02,TRB->PE2,TRB->PP2,'2'})
			Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP3,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP3,"B1_DESC")),TRB->UF_BOTAO03,TRB->PE3,TRB->PP3,'3'})
			Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP4,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP4,"B1_DESC")),TRB->UF_BOTAO04,TRB->PE4,TRB->PP4,'4'})
			Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP5,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP5,"B1_DESC")),TRB->UF_BOTAO05,TRB->PE5,TRB->PP5,'5'})
			Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP6,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP6,"B1_DESC")),TRB->UF_BOTAO06,TRB->PE6,TRB->PP6,'6'})
			Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP7,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP7,"B1_DESC")),TRB->UF_BOTAO07,TRB->PE7,TRB->PP7,'7'})
			Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP8,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP8,"B1_DESC")),TRB->UF_BOTAO08,TRB->PE8,TRB->PP8,'8'})
			Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP9,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP9,"B1_DESC")),TRB->UF_BOTAO09,TRB->PE9,TRB->PP9,'9'})
			Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP10,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP10,"B1_DESC")),TRB->UF_BOTAO10,TRB->PE10,TRB->PP10,'10'})
			Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP11,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP11,"B1_DESC")),TRB->UF_BOTAO11,TRB->PE11,TRB->PP11,'11'})
			Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP12,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP12,"B1_DESC")),TRB->UF_BOTAO12,TRB->PE12,TRB->PP12,'12'})
		Else
		 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[7] == TRB->ZN_PATRIMO+'1'}),04] -= TRB->UF_BOTAO01 
		 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[7] == TRB->ZN_PATRIMO+'2'}),04] -= TRB->UF_BOTAO02
		 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[7] == TRB->ZN_PATRIMO+'3'}),04] -= TRB->UF_BOTAO03
		 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[7] == TRB->ZN_PATRIMO+'4'}),04] -= TRB->UF_BOTAO04
		 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[7] == TRB->ZN_PATRIMO+'5'}),04] -= TRB->UF_BOTAO05
		 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[7] == TRB->ZN_PATRIMO+'6'}),04] -= TRB->UF_BOTAO06
		 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[7] == TRB->ZN_PATRIMO+'7'}),04] -= TRB->UF_BOTAO07
		 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[7] == TRB->ZN_PATRIMO+'8'}),04] -= TRB->UF_BOTAO08
		 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[7] == TRB->ZN_PATRIMO+'9'}),04] -= TRB->UF_BOTAO09
		 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[7] == TRB->ZN_PATRIMO+'10'}),04] -= TRB->UF_BOTAO10
		 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[7] == TRB->ZN_PATRIMO+'11'}),04] -= TRB->UF_BOTAO11
		 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[7] == TRB->ZN_PATRIMO+'12'}),04] -= TRB->UF_BOTAO12
		 	
		EndIf			                      
		dbskip()
	Enddo	
Next nX            

Return(aSheAn)                                                                                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC22  บAutor  ณMicrosiga           บ Data ณ  11/25/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Custodose(codigo)

Local aArea	:=	GetArea()
Local nCusto	:=	0

cQuery := "SELECT SUM(ROUND((G1_QUANT/100)/B2_CM1,4)) AS CUSTO"
cQuery += " FROM "+RetSQLName("SB2")+" B2"
cQuery += " INNER JOIN "+RetSQLName("SG1")+" G1 ON G1_COMP=B2_COD AND G1_COD='"+codigo+"' AND G1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=B2_COD AND B1.D_E_L_E_T_='' AND B1_LOCPAD=B2_LOCAL "
cQuery += " WHERE B2_FILIAL='"+xFilial("SB2")+"' AND B2.D_E_L_E_T_=''"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTPRO20.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

nCusto := TRB->CUSTO

RestArea(aArea)

Return(If(nCusto==0,0.01,nCusto))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC22  บAutor  ณMicrosiga           บ Data ณ  12/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Faturamento de Contrato do Tipo Selecionado.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FatSelec(aAux)

Local aArea	:=	GetArea()
Local aRet	:=	{}      
Local cQuery

For nX := 1 to len(aAux)
	cQuery := "SELECT DISTINCT ZN_CLIENTE,ZN_LOJA,ZN_PATRIMO,N1_DESCRIC,DA0_CODTAB"+chr(13)+chr(10)
	
	For nTT := 1 to 12
		cQuery += " ,ZN_BOTAO"+Strzero(nTT,2)+" - (SELECT TOP 1 ZN_BOTAO"+StrZero(nTT,2)+" FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CONFERE<>'1' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX,02]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO"+StrZero(nTT,2)+chr(13)+chr(10)
	Next nTT
		            
	For nTT := 1 to 12
		cQuery += " ,N1_XP"+cvaltochar(nTT)+",D"+cvaltochar(nTT)+".DA1_PRCVEN AS PE"+cvaltochar(nTT)+",D"+cvaltochar(nTT)+".DA1_XPRCPP AS PP"+cvaltochar(nTT)+chr(13)+chr(10)
	Next nTT
	
	cQuery += " FROM "+RetSQLName("SZN")+" ZN"+chr(13)+chr(10)
	cQuery += " INNER JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZN_PATRIMO AND N1.D_E_L_E_T_=''"+chr(13)+chr(10)
	cQuery += " LEFT JOIN "+RetSQLName("SZD")+" ZD ON ZD_PATRIMO=ZN_PATRIMO AND ZD.D_E_L_E_T_='' AND ZD_CLIENTE=ZN_CLIENTE  AND ZD_LOJA=ZN_LOJA AND ZD_IDSTATU='1'"+chr(13)+chr(10)
	cQuery += " LEFT JOIN "+RetSQLName("DA0")+" DA0 ON DA0_XCLIEN=ZN_CLIENTE AND DA0_XLOJA=ZN_LOJA AND DA0.D_E_L_E_T_='' AND DA0_ATIVO='1'"+chr(13)+chr(10)
	
	For nTT := 1 to 12                                                                                                       
		cQuery += " LEFT JOIN "+RetSQLName("DA1")+" D"+cvaltochar(nTT)+" ON D"+cvaltochar(nTT)+".DA1_CODTAB=DA0_CODTAB AND D"+cvaltochar(nTT)+".DA1_CODPRO=N1_XP"+cvaltochar(nTT)+" AND D"+cvaltochar(nTT)+".D_E_L_E_T_=''"+chr(13)+chr(10)
	Next nTT
	
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=ZN_CLIENTE AND A1_LOJA=ZN_LOJA AND A1.D_E_L_E_T_=''"+chr(13)+chr(10)
	cQuery += " WHERE ZN_TIPINCL<>'SANGRIA' AND ZN.D_E_L_E_T_='' AND (ZN_DATA BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' OR ZN_CONFERE='1')"+chr(13)+chr(10)
	cQuery += " AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX,02]+"'"+chr(13)+chr(10)
	cQuery += " ORDER BY 2 DESC"+chr(13)+chr(10)
	

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTPRO20.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	While !EOF()
	    AAdd(aRet,{aAux[nX,01],aAux[nX,02],TRB->ZN_CLIENTE,TRB->ZN_LOJA,TRB->N1_DESCRIC,;
	    			TRB->UF_BOTAO01,TRB->N1_XP1,TRB->PE1,TRB->PP1,;
	    			TRB->UF_BOTAO02,TRB->N1_XP2,TRB->PE2,TRB->PP2,;
	    			TRB->UF_BOTAO03,TRB->N1_XP3,TRB->PE3,TRB->PP3,;
	    			TRB->UF_BOTAO04,TRB->N1_XP4,TRB->PE4,TRB->PP4,;
	    			TRB->UF_BOTAO05,TRB->N1_XP5,TRB->PE5,TRB->PP5,;
	    			TRB->UF_BOTAO06,TRB->N1_XP6,TRB->PE6,TRB->PP6,;
	    			TRB->UF_BOTAO07,TRB->N1_XP7,TRB->PE7,TRB->PP7,;
	    			TRB->UF_BOTAO08,TRB->N1_XP8,TRB->PE8,TRB->PP8,;
	    			TRB->UF_BOTAO09,TRB->N1_XP9,TRB->PE9,TRB->PP9,;
	    			TRB->UF_BOTAO10,TRB->N1_XP10,TRB->PE10,TRB->PP10,;
	    			TRB->UF_BOTAO11,TRB->N1_XP11,TRB->PE11,TRB->PP11,;
	    			TRB->UF_BOTAO12,TRB->N1_XP12,TRB->PE12,TRB->PP12,;
	    			TRB->DA0_CODTAB})
		DbSkip()
	EndDo
Next nX
	
RestArea(aArea)

Return(aRet)