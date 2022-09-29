#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPEFINC20  บAutor  ณMicrosiga           บ Data ณ  06/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  PE INCLUSAO DE REGISTROS PELA TESOURARIA.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PEFINC20()

Local aParam		:= PARAMIXB
Local xRet			:= .T.
Local oObj			:= ""
Local cIDPonto		:= ""
Local cIdModel		:= ""
Local lIsGrid		:= .F.
Local nLinha		:= 0
Local nQtdLinhas	:= 0
Local cQuery

If cEmpAnt == "01"
	If aParam <> NIl
	
		oObj		:= aParam[1]
		cIdPonto	:= aParam[2]
		cIDModel	:= aParam[3]
		lIsGrid		:= ( Len(aParam)>3 )
	
		If lIsGrid
			//nQtdLinhas := oObj:GetQtdLine()
			//nLinha := oObj:nLine
		EndIf
		
		// Antes da alteracao de qualquer campo do modelo
		If cIdPonto == "MODELPRE"
		
		// Na validacao total do modelo	
		ElseIf cIdPonto == "MODELPOS"     //
		    //Operacao de exclusao do registro de preparacao da rota
		    //Ao excluir tem que estornar a trasferencia de sangria
			If oObj:nOperation == 5
				estorna(SZF->ZF_DATA,SZF->ZF_ROTA)
			EndIf
		
		// Antes da alteracao de qualquer campo do formulario	                                                 
		ElseIf cIdPonto == "FORMPRE"
	
			// Na validacao total do formulario	
		ElseIf cIdPonto == "FORMPOS"
		    // Antes da alteracao da linha do formulario FWFORMGRID
		ElseIf cIdPonto == "FORMLINEPRE"
		                                                     
		// Na validacao total da linha do formulario FWFORMGRID
		ElseIf cIdPonto == "FORMLINEPOS"
		                                   
		// Apos a gravacao total do modelo e dentro da transacao
		ElseIf cIdPonto == "MODELCOMITTTS"
	
		// Apos a gravacao total do modelo e fora da transacao
		ElseIf cIdPonto == "MODELCOMMITNTTS"
	
		// Antes da gravacao da tabela do formulario
		ElseIf cIdPonto == "FORMCOMMITTTSPRE"       //
			                                        
		// Apos a gravacao da tabela do formulario
		ElseIf cIdPonto == "FORMCOMMITTTSPOS"
			                        
		// No cancelamento do botao
		ElseIf cIdPonto == "MODELCANCEL"
		
		// Na ativacao do modelo
		ElseIf cIdPonto == "MODELVLDACTIVE"
		                        
		// Para inclusao de botoes na ControlBar
		ElseIf cIdPonto == "BUTTONBAR"
			//xRet := { {'Carregar', 'Carregar', {||carregar()}, 'Carregar produtos desta PA'}} 
		EndIf
		
	EndIf
EndIF

Return xRet                             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC15  บAutor  ณMicrosiga           บ Data ณ  10/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Estorna a transferencia realizada para o caixa da rota    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function estorna(dData,cRota)

Local aArea	:=	GetArea()

Private lMsErroAuto	:=	.F.

//E5_FILIAL+DTOS(E5_DATA)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ
dbSelectArea("SE5")
SE5->(dbSetOrder(1))
If SE5->(dbSeek(xFilial("SE5")+DToS(dData)+"CXG000001000000         "+Dtos(dData)+cRota))
	aFINA100 := {   {"E5_DATA" 		,SE5->E5_DATA            	,Nil},;
					{"E5_MOEDA"     ,SE5->E5_MOEDA            	,Nil},;
	                {"E5_VALOR"     ,SE5->E5_VALOR            	,Nil},;
	                {"E5_NATUREZ"   ,SE5->E5_NATUREZ        	,Nil},;
	                {"E5_BANCO"     ,SE5->E5_BANCO            	,Nil},;
	                {"E5_AGENCIA"   ,SE5->E5_AGENCIA        	,Nil},;
	                {"E5_CONTA"     ,SE5->E5_CONTA            	,Nil},;
	                {"E5_HISTOR"    ,SE5->E5_HISTOR        		,Nil},;
	                {"E5_TIPOLAN"   ,SE5->E5_TIPOLAN       	 	,Nil} }
	    
	MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,5)
	    
	If lMsErroAuto
		MostraErro()
	EndIf
EndIf

SE5->(dbSetOrder(1))
If SE5->(dbSeek(xFilial("SE5")+DToS(dData)+"CXT000000"+cRota+"         "+Dtos(dData)+cRota))
	aFINA100 := {   {"E5_DATA" 		,SE5->E5_DATA            	,Nil},;
					{"E5_MOEDA"     ,SE5->E5_MOEDA            	,Nil},;
	                {"E5_VALOR"     ,SE5->E5_VALOR            	,Nil},;
	                {"E5_NATUREZ"   ,SE5->E5_NATUREZ        	,Nil},;
	                {"E5_BANCO"     ,SE5->E5_BANCO            	,Nil},;
	                {"E5_AGENCIA"   ,SE5->E5_AGENCIA        	,Nil},;
	                {"E5_CONTA"     ,SE5->E5_CONTA            	,Nil},;
	                {"E5_HISTOR"    ,SE5->E5_HISTOR        		,Nil},;
	                {"E5_TIPOLAN"   ,SE5->E5_TIPOLAN       	 	,Nil} }
	    
	MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,5)
	    
	If lMsErroAuto
		MostraErro()
	EndIf
EndIf

RestArea(aArea)
      
Return