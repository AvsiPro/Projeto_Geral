#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTTPROC15 บAutor  ณMicrosiga           บ Data ณ  06/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  PE INCLUSAO DE REGISTROS PELA TESOURARIA.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PEPROC15()

Local aParam		:= PARAMIXB
Local xRet			:= .T.
Local oObj			:= ""
Local cIDPonto		:= ""
Local cIdModel		:= ""
Local lIsGrid		:= .F.
Local nLinha		:= 0
Local nQtdLinhas	:= 0
Local cQuery

If cEmpAnt <> "01"
	return
EndIF

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
	ElseIf cIdPonto == "MODELPOS"
	
	// Antes da alteracao de qualquer campo do formulario	                                                 
	ElseIf cIdPonto == "FORMPRE"

		// Na validacao total do formulario	
	ElseIf cIdPonto == "FORMPOS"
    	//aqui
    	If Type("aCols") != "U"
	    	For nX := 1 to len(aCols)
	    	
		    	nSomaM := 0
		    	nSomaC := 0 
	
	    		nSomaM += aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_MOEDA05"})] * 0.05
	    		nSomaM += aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_MOEDA10"})] * 0.10
	    		nSomaM += aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_MOEDA25"})] * 0.25
	    		nSomaM += aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_MOEDA50"})] * 0.50
	    		nSomaM += aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_MOEDA1R"})] * 1.00	             
	    		nSomaC += aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_NOTA01"})] * 1.00	             
	    	   /*	nSomaC += aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_NOTA02"})] * 2.00	             
	    		nSomaC += aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_NOTA03"})] * 4.00	             
	    		nSomaC += aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_NOTA04"})] * 10.00	             
	    		nSomaC += aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_NOTA05"})] * 20.00	             
	    		nSomaC += aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_NOTA06"})] * 50.00	             
	    		nSomaC += aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_NOTA07"})] * 100.00*/	             
		        
				nVlr := nSomaM+nSomaC	             
		    	
	    		//TST100(nVlr,aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_PATRIMO"})],aCols[nX,Ascan(aHeader,{|x| Alltrim(x[2]) == "ZN_DATA"})])
	
	    	Next nX
		EndIf
	    // Antes da alteracao da linha do formulario FWFORMGRID
	ElseIf cIdPonto == "FORMLINEPRE"
	                                                     
	// Na validacao total da linha do formulario FWFORMGRID
	ElseIf cIdPonto == "FORMLINEPOS"
	                                   
	// Apos a gravacao total do modelo e dentro da transacao
	ElseIf cIdPonto == "MODELCOMITTTS"

	// Apos a gravacao total do modelo e fora da transacao
	ElseIf cIdPonto == "MODELCOMMITNTTS"

	// Antes da gravacao da tabela do formulario
	ElseIf cIdPonto == "FORMCOMMITTTSPRE"
		                                        
	// Apos a gravacao da tabela do formulario
	ElseIf cIdPonto == "FORMCOMMITTTSPOS"
	                        
	// No cancelamento do botao
	ElseIf cIdPonto == "MODELCANCEL"
	
	// Na ativacao do modelo
	ElseIf cIdPonto == "MODELVLDACTIVE"
	                        
	// Para inclusao de botoes na ControlBar
	ElseIf cIdPonto == "BUTTONBAR"
		//xRet := { {'Carregar', 'Carregar', {||carregar()}, 'Carregar produtos desta PA'}} 
		xRet := { {'Carregar', 'Carregar', {||carregar()}, 'Carregar produtos desta PA'}} 
	EndIf
	
EndIf

Return xRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPEPROC15  บAutor  ณMicrosiga           บ Data ณ  08/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TST100(nVlr,cPat,dData)  
                    
Local aArea		:=	GetArea()
Local nOpc     := 0
Local aFINA100 := {}
Local dDat		:=	dDatabase
Private lMsErroAuto := .F.
                             
dDatabase := dData
    
aFINA100 := {	{"E5_DATA"		,dData                        ,Nil},;
                {"E5_MOEDA"     ,"M1"                         ,Nil},;
                {"E5_VALOR"     ,nVlr                         ,Nil},;
                {"E5_NATUREZ"   ,"10101009"                   ,Nil},;
                {"E5_BANCO"     ,"CXG"                        ,Nil},;
                {"E5_AGENCIA"   ,"000001"                     ,Nil},;
                {"E5_CONTA"     ,If(cfilant="01","000000         ","0000"+strzero(cfilant,2)+space(9))           ,Nil},;
                {"E5_HISTOR"    ,"SANGRIA PATRIMONIO "+cPat	  ,Nil}}
//                            {"E5_BENEF"     ,"CAIXA TESOURARIA"		   	  ,Nil},;

MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,4)
 
If lMsErroAuto
	MostraErro()
Else
	//MsgAlert("Movto. Bancario Receber incluido com sucesso !!!")
EndIf

dDatabase    := dDat   
/*        
    ElseIf nOpc == 2
        aFINA100 := {    {"E5_DATA"        ,dDataBase                    ,Nil},;
                            {"E5_MOEDA"        ,"M1"                            ,Nil},;
                            {"E5_VALOR"         ,1500                            ,Nil},;
                            {"E5_NATUREZ"    ,"001"                        ,Nil},;
                            {"E5_BANCO"        ,"001"                        ,Nil},;
                            {"E5_AGENCIA"    ,"001"                        ,Nil},;
                            {"E5_CONTA"        ,"001"                        ,Nil},;
                            {"E5_HISTOR"    ,"TESTE AUTO - AUTO"        ,Nil}}
    
        MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,4)
    
        If lMsErroAuto
            MostraErro()
        Else
            MsgAlert("Movto. Bancario Receber incluido com sucesso !!!")
        EndIf       
    
    ElseIf nOpc == 3
        dbSelectArea("SE5")
        SE5->(dbSetOrder(1))
        SE5->(dbSeek(xFilial("SE5")+DToS(dDataBase) ))
        aFINA100 := {    {"E5_DATA"             ,SE5->E5_DATA            ,Nil},;
                            {"E5_MOEDA"             ,SE5->E5_MOEDA            ,Nil},;
                            {"E5_VALOR"             ,SE5->E5_VALOR            ,Nil},;
                            {"E5_NATUREZ"        ,SE5->E5_NATUREZ        ,Nil},;
                            {"E5_BANCO"            ,SE5->E5_BANCO            ,Nil},;
                            {"E5_AGENCIA"         ,SE5->E5_AGENCIA        ,Nil},;
                            {"E5_CONTA"         ,SE5->E5_CONTA            ,Nil},;
                            {"E5_HISTOR"        ,SE5->E5_HISTOR        ,Nil},;
                            {"E5_TIPOLAN"        ,SE5->E5_TIPOLAN        ,Nil} }
    
        MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,5)
    
        If lMsErroAuto
            MostraErro()
        Else
            MsgAlert("Exclusใo realizada com sucesso !!!")
        EndIf       

    ElseIf nOpc == 4
        dbSelectArea("SE5")
        SE5->(dbSetOrder(1))
        SE5->(dbSeek(xFilial("SE5")+DToS(dDataBase) ))
        dbSkip() //colocado apenas para esta sequencia de testes
        aFINA100 := {    {"E5_DATA"             ,SE5->E5_DATA            ,Nil},;
                            {"E5_MOEDA"             ,SE5->E5_MOEDA            ,Nil},;
                            {"E5_VALOR"             ,SE5->E5_VALOR            ,Nil},;
                            {"E5_NATUREZ"        ,SE5->E5_NATUREZ        ,Nil},;
                            {"E5_BANCO"            ,SE5->E5_BANCO            ,Nil},;
                            {"E5_AGENCIA"         ,SE5->E5_AGENCIA        ,Nil},;
                            {"E5_CONTA"         ,SE5->E5_CONTA            ,Nil},;
                            {"E5_HISTOR"        ,SE5->E5_HISTOR        ,Nil},;
                            {"E5_TIPOLAN"        ,SE5->E5_TIPOLAN        ,Nil} }
    
        MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,6)
    
        If lMsErroAuto
            MostraErro()
        Else
            MsgAlert("Cancelamento realizada com sucesso !!!")
        EndIf       

    
    ElseIf nOpc == 5
        aFINA100 := {    {"CBCOORIG"             ,"001"                            ,Nil},;
                            {"CAGENORIG"        ,"001"                            ,Nil},;
                            {"CCTAORIG"             ,"001"                            ,Nil},;
                            {"CNATURORI"         ,"001"                            ,Nil},;
                            {"CBCODEST"            ,"002"                            ,Nil},;
                            {"CAGENDEST"         ,"002"                            ,Nil},;
                            {"CCTADEST"         ,"002"                            ,Nil},;
                            {"CNATURDES"        ,"002"                            ,Nil},;
                            {"CTIPOTRAN"        ,"CH"                                ,Nil},;
                            {"CDOCTRAN"            ,"123456"                        ,Nil},;
                            {"NVALORTRAN"        ,2500                                ,Nil},;
                            {"CHIST100"            ,"TESTE TRF VIA EXECAUTO"    ,Nil},;
                            {"CBENEF100"        ,"TESTE TRF VIA EXECAUTO"    ,Nil} }
    
        MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,7)
    
        If lMsErroAuto
            MostraErro()
        Else
            MsgAlert("Transfer๊ncia executada com sucesso !!!")
        EndIf       
                    
    //Estorno da Transferencia
    ElseIf nOpc == 6
        aFINA100 := {    {"AUTNRODOC"         ,"123456"                ,Nil},;
                            {"AUTDTMOV"            ,dDataBase                ,Nil},;
                            {"AUTBANCO"             ,"001"                    ,Nil},;
                            {"AUTAGENCIA"     ,"001"                    ,Nil},;
                            {"AUTCONTA"            ,"001"                    ,Nil} }
                    
        MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,8)
    
        If lMsErroAuto
            MostraErro()
        Else
            MsgAlert("Transfer๊ncia cancelada com sucesso !!!")
        EndIf       
    EndIf
    If nOpc == 0
        Exit
    Endif
Enddo
*/              
RestArea(aArea)

Return