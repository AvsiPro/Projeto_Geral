#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC26  บAutor  ณMicrosiga           บ Data ณ  10/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Encerrar os lancamentos de prestacao de contas da rota.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFINC26(aRet)

Local aArea	:=	GetArea()
Local aPergs	:=	{}
//Local aRet		:=	{}             
Local dDataE	:=	ctod('  /  /  ')
Local cQuery    
Local aAreaA6	:=	{}
Local dDiaB		:=	dDataBase 
Local nTot		:=	0

//aAdd(aPergs ,{1,"Rota"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",100,.F.})
//aAdd(aPergs ,{1,"Data",dDataE,"99/99/99","","","",0,.F.})

//If ParamBox(aPergs ,"Encerrar",@aRet)    

	cQuery := "SELECT (ZF_RETMOE1*0.05) + (ZF_RETMOE2*0.10) + (ZF_RETMOE3*0.25) + (ZF_RETMOE4*0.50) + (ZF_RETMOE5*1) AS TOTAL"
	cQuery += " FROM "+RetSQLName("SZF")
	cQuery += " WHERE ZF_FILIAL='"+xFilial("SZF")+"' AND ZF_ROTA='"+aRet[1]+"' AND ZF_DATA='"+dtos(aRet[2])+"'"
	cQuery += " AND (ZF_RETMOE1<>0 OR ZF_RETMOE2<>0 OR ZF_RETMOE3<>0 OR ZF_RETMOE4<>0 OR ZF_RETMOE5<>0)"
	cQuery += " AND D_E_L_E_T_=''" 
	
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	  
	MemoWrite("TTFINC26.SQL",cQuery)
	
	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	
	DbSelectArea("TRB") 
	
	nTot := TRB->TOTAL
	If nTot > 0        
		aAreaA6	:=	GetArea()
	//DbSelectArea("SZN")
	//DbSetOrder(3)
	//If DbSeek(xFilial("SZN")+aRet[1]+dtos(aRet[2]))
	//	While !EOF() .AND. SZN->ZN_ROTA == aRet[1] .AND. SZN->ZN_DATA == aRet[2] .AND. Alltrim(SZN->ZN_TIPINCL) == 'SANGRIA'
	//		If SZN->ZN_TROCO > 0
	//			
				/*DbSelectArea("SA6")
				DbSetOrder(1)
				If !DbSeek(xFilial("SA6")+"CXP000000"+Avkey(SZN->ZN_PATRIMO,"N1_CHAPA"))
					Reclock("SA6",.T.)
					SA6->A6_FILIAL	:=	xFilial("SA6")
					SA6->A6_COD		:=	"CXP"
					SA6->A6_AGENCIA	:=	"000000"
					SA6->A6_NUMCON	:=	SZN->ZN_PATRIMO
					SA6->A6_NOME	:=	"CAIXA SANGRIA PATRIMONIO "+SZN->ZN_PATRIMO
					SA6->(Msunlock())
				EndIf
				
				dDatabase := SZN->ZN_DATA

				aFINA100 := {   {"E5_DATA"			,dDataBase                    				,Nil},;
								{"E5_MOEDA" 		,"R$"                         				,Nil},;
				                {"E5_VALOR"			,SZN->ZN_TROCO  							,Nil},;
				                {"E5_NATUREZ"    	,"10101009"                   				,Nil},;
				                {"E5_BANCO"        	,"CXP"                        				,Nil},;
				                {"E5_AGENCIA"    	,"000001"                        			,Nil},;
				                {"E5_CONTA"        	,SZN->ZN_PATRIMO                        	,Nil},;
				                {"E5_NUMCHEQ"     	,dtos(dDataBase)+aRet[1]                   	,Nil},;
				                {"E5_BENEF"        	,"Transf R$ para Abastec Troco Rota "+aRet[1] ,Nil},;
				                {"E5_HISTOR"    	,"Transf R$ para Abastec Troco Rota "+aRet[1] ,Nil}}
				    
				MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)
				  
				If lMsErroAuto
					MostraErro()
				EndIf 
				*/
				lMsErroAuto := .F.
				
				aFINA100 := {  {"E5_DATA"        	,aRet[2]                    			,Nil},;
				 				{"E5_MOEDA"			,"R$"                            		,Nil},;
				     			{"E5_VALOR"         ,nTot						            ,Nil},;
				        		{"E5_NATUREZ"    	,"10101009"                   			,Nil},;
				          		{"E5_BANCO"        	,"CXT"                        			,Nil},;
				            	{"E5_AGENCIA"    	,"000000"                     			,Nil},;
				             	{"E5_CONTA"        	,aRet[1]                       			,Nil},;
				            	{"E5_NUMCHEQ"     	,dtos(aRet[2])+aRet[1]               	,Nil},;
				              	{"E5_HISTOR"    	,"Transf R$ da Rota para Tesouraria "	,Nil}}
				    
				MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)
				      
				If lMsErroAuto
					MostraErro()
				EndIf            
				
				lMsErroAuto := .F.
				
				aFINA100 := {  {"E5_DATA"        	,aRet[2]                    			,Nil},;
				 				{"E5_MOEDA"			,"R$"                            		,Nil},;
				     			{"E5_VALOR"         ,nTot						            ,Nil},;
				        		{"E5_NATUREZ"    	,"10101009"                   			,Nil},;
				          		{"E5_BANCO"        	,"CXG"                        			,Nil},;
				            	{"E5_AGENCIA"    	,"000001"                     			,Nil},;
				             	{"E5_CONTA"        	,If(cfilant="01","000000         ","0000"+strzero(val(cfilant),2)+space(9))             			,Nil},;
				            	{"E5_NUMCHEQ"     	,dtos(aRet[2])+aRet[1]               	,Nil},;
				              	{"E5_HISTOR"    	,"Transf R$ da Rota para Tesouraria "	,Nil}}
				    
				MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,4)
				    
				If lMsErroAuto
					MostraErro()
				EndIf   
				
				RestArea(aAreaA6)
				
	 //		EndIf
	 //		Reclock("SZN",.F.)
	 //		SZN->ZN_CONFERE	:=	"X"
	 //		SZN->(Msunlock())
	 //		DbSkip()
	 //	EndDo
	EndIf
//EndIf   

dDataBase := dDiab

RestArea(aArea)

Return