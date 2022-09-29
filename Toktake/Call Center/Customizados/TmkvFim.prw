#Include 'rwmake.ch'

User Function TmkvFim()               
Local _aRecSC5	:= {}
Local _aRecSC6	:= {}
Local _aArea	:= GetArea()
Local _cEmpAnt	:= cEmpAnt
Local _cFilAnt	:= cFilAnt   

If cEmpAnt <> "10"
	If !Empty(SUA->UA_NUMSC5) .And. !Empty(SUA->UA_XFILSAI)
		
		DbSelectArea("SC5")
		DbSetOrder(1)
		DbGotop()
		
		If DbSeek(xFilial("SC5")+SUA->UA_NUMSC5)
		
	//		If SC5->C5_FILIAL # SUA->UA_XFILSAI     
			
				AADD(_aRecSC5,Recno())
				
				DbSelectArea("SC6")
				DbSetOrder(1)
				DbGotop()
				
				DbSeek(xFilial("SC6")+SUA->UA_NUMSC5)
				
				Do While 	SC6->C6_FILIAL	=	xFilial("SC6")	.And.;
							SC6->C6_NUM		=	SUA->UA_NUMSC5	.And. !Eof()
							
					AADD(_aRecSC6,Recno())
					DbSkip()
					
				Enddo   
				
				cFilAnt	:= SUA->UA_XFILSAI                                       
				
				_cPedido := GetSx8Num("SC5","C5_NUM") 
				
				DbSelectArea("SC5")
				
				DbGoTo(_aRecSC5[1])
				
				RecLock("SC5",.F.)
				SC5->C5_FILIAL	:= "  "
				SC5->C5_NUM		:= _cPedido
				SC5->C5_FILIAL	:= SUA->UA_XFILSAI
				SC5->C5_XNFABAS	:= SUA->UA_XNFABA
				SC5->C5_XFINAL	:= SUA->UA_XFINAL
				SC5->C5_TIPOCLI	:= "F"
				SC5->C5_XCODUSR	:= SUA->UA_OPERADO
				SC5->C5_XNOMUSR	:= cusername
				SC5->C5_XCODPA	:= SUA->UA_XCODPA
				SC5->C5_XDCODPA	:= SUA->UA_XDCODP
				SC5->C5_XTPPAG  := SUA->UA_XTPPAG
				SC5->C5_XCCUSTO := SUA->UA_XCCUS
				MsUnlock()
				
				DbSelectArea("SC6")
				
				For _n := 1 to Len(_aRecSC6)
				   
					DbGoTo(_aRecSC6[_n])
					
					RecLock("SC6",.F.)
					SC6->C6_FILIAL	:= "  "
					SC6->C6_NUM		:= _cPedido
					SC6->C6_FILIAL	:= SUA->UA_XFILSAI
					SC6->C6_CCUSTO  := SUB->UB_CCUS
					SC6->C6_ITEMCC  := SUB->UB_ITEMC
					SC6->C6_CLVL  	:= SUB->UB_CLVL				
					MsUnlock()
				
				Next     
				 
				cFilAnt	:= _cFilAnt          
			
	//		Endif
		
			DbSelectArea("SUA")
			
			RecLock("SUA",.F.)
			SUA->UA_NUMSC5	:= _cPedido
			MsUnlock()
			
		Endif	
		
	Endif	                       
EndIf

RestArea(_aArea)

Return .T.
