#Include "Protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA03  บAutor  ณMicrosiga           บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina responsavel por gerar o pedido de venda para a mov- บฑฑ
ฑฑบ          ณimentacao da maquina (OMM)                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMKA03()     

Local aArea		:=	GetArea()
Local aCab		:=	{}   
Local lVldPedido := .F.
Local cMail := ""
Private cNumPed := ""
Private aItens	:=	{}               
Private lMsErroAuto	:=	.F.

If cEmpAnt <> "01"
	Return(cNumPed)
EndIf

aCab	:=	Cabecalho()
Itens()

aAreaC5 := GetArea()
cNumPed := GetSxenum("SC5","C5_NUM")	

// Gera o pedido de venda
While !lVldPedido	
	lVldPedido := VldNumPed(cNumPed,cFilAnt)
	If !lVldPedido
		//RollBackSx8()
		cNumPed := Soma1(cNumPed)
	EndIf
End


aCab[2,2] := cNumPed

For nZ := 1 to len(aItens)
	aItens[nZ,02,02] := cNumPed
Next nZ

MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)                    

If lMsErroAuto
	MostraErro()  
EndIF   


cMail := UsrRetMail(__cUserId)
If !Empty(cMail)
	U_TTMAILN('microsiga@toktake.com.br',cMail,'Pedido Gerado pela OMM','Pedido '+SC5->C5_NUM,{},.F.)
EndIf


ConfirmSX8()

RestArea(aArea)

Return(cNumPed)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC25  บAutor  ณMicrosiga           บ Data ณ  04/23/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldNumPed(cNumPed,cFilAnt)

Local lRet := .T.
Local cQuery := ""

cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SC5")
cQuery += " WHERE C5_FILIAL = '"+cFilAnt+"' AND C5_NUM = '"+cNumPed+"' AND D_E_L_E_T_ = '' "

If Select("TRBC5") > 0
	TRBC5->( dbCloseArea() )
EndIf                       

TcQuery cQuery New Alias "TRBC5"
                               
dbSelectArea("TRBC5")
If !EOF()
	If TRBC5->TOTAL > 0
		lRet := .F.
	EndIf
EndIf

dbCloseArea()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA03  บAutor  ณMicrosiga           บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cabecalho()

Local aArea		:=	GetArea()
Local aCabec	:= {}            
Local cMenota	:= ''

DbSelectArea("SUD")
DbSetOrder(1)
If DbSeek(xFilial("SUD")+SUC->UC_CODIGO)
	While !EOF() .AND. SUD->UD_CODIGO==SUC->UC_CODIGO .AND. SUD->UD_FILIAL==SUC->UC_FILIAL
	 	cMenota += "Patrimonio "+SUD->UD_XNPATRI+" Local Instalacao "+Alltrim(SUD->UD_XLOCFIS)+" / "
		Dbskip()
	EndDo
EndIf

Aadd(aCabec,{"C5_FILIAL"	,xFilial("SC5") 					,Nil})    
Aadd(aCabec,{"C5_NUM"		,''    								,Nil})
Aadd(aCabec,{"C5_TIPO"		,'N'			 					,Nil})   
Aadd(aCabec,{"C5_CLIENTE"	,substr(SUC->UC_CHAVE,1,6)			,Nil})  
Aadd(aCabec,{"C5_LOJACLI"	,substr(SUC->UC_CHAVE,7,4)	  		,Nil})  
Aadd(aCabec,{"C5_CLIENT"	,substr(SUC->UC_CHAVE,1,6)	  		,Nil})  
Aadd(aCabec,{"C5_LOJAENT"	,substr(SUC->UC_CHAVE,7,4)			,Nil}) 
Aadd(aCabec,{"C5_XIDPCA"	,''    								,Nil})                
Aadd(aCabec,{"C5_XDTENTR"	,DDATABASE+1						,Nil})  
Aadd(aCabec,{"C5_XNFABAS"	,'2'			 					,Nil})   
Aadd(aCabec,{"C5_XCODPA"	,SPACE(6)							,Nil}) 
Aadd(aCabec,{"C5_XFINAL"	,'H'			 					,Nil})          
Aadd(aCabec,{"C5_XFLDEST"	,''				   					,Nil})
Aadd(aCabec,{"C5_TRANSP"	,'000019'		 					,Nil})          
Aadd(aCabec,{"C5_XTPCARG"	,''				 					,Nil})
Aadd(aCabec,{"C5_XHRPREV"	,'00:00'		 					,Nil})
Aadd(aCabec,{"C5_CONDPAG"	,'001'			 					,Nil})
Aadd(aCabec,{"C5_TABELA"	,SPACE(3) 							,Nil})
Aadd(aCabec,{"C5_XCCUSTO"	,''		  						   	,Nil})
Aadd(aCabec,{"C5_XITEMCC"	,''									,Nil})
Aadd(aCabec,{"C5_MOEDA"		,1 									,Nil})
Aadd(aCabec,{"C5_FRETE"		,0 									,Nil})
Aadd(aCabec,{"C5_TXMOEDA"	,1 									,Nil})
Aadd(aCabec,{"C5_EMISSAO"	,ddatabase		 					,Nil})
Aadd(aCabec,{"C5_XGPV"		,'TEC'			 					,Nil})
Aadd(aCabec,{"C5_MENNOTA"	,cMenota							,Nil})
Aadd(aCabec,{"C5_ESPECI1"	,'UN'	 		  					,Nil})
Aadd(aCabec,{"C5_XHRINC" 	,cvaltochar(TIME())					,Nil})
Aadd(aCabec,{"C5_XDATINC"	,DATE()								,Nil})
Aadd(aCabec,{"C5_XLOCAL" 	,''				,Nil})        //DE ACORDO COM O PRODUTO
Aadd(aCabec,{"C5_XNOMUSR"	,cUserName 							,Nil})
Aadd(aCabec,{"C5_XCODUSR"	,__cUserId 		   					,Nil})
Aadd(aCabec,{"C5_TPFRETE"	,"C" 								,Nil})
Aadd(aCabec,{"C5_TIPOCLI"	,"R" 								,Nil})
Aadd(aCabec,{"C5_TIPLIB" 	,'1'			  					,Nil})
Aadd(aCabec,{"C5_VEND1"  	,'000023' 		  					,Nil})
Aadd(aCabec,{"C5_XTPPAG" 	,'BOL'				  				,Nil})

RestArea(aArea)

Return(aCabec)             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA03  บAutor  ณMicrosiga           บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                          	              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Itens()
 
Local aArea	:=	GetArea()

DbSelectArea("SUD")
DbSetOrder(1)
If DbSeek(xFilial("SUD")+SUC->UC_CODIGO)
	While !EOF() .AND. SUD->UD_CODIGO==SUC->UC_CODIGO .AND. SUD->UD_FILIAL==SUC->UC_FILIAL
		
		Aadd(aItens,{{"C6_FILIAL"	,xFilial("SC6")	 						,Nil},;
						{"C6_NUM"	,'' 									,Nil},; 
						{"C6_ITEM"	,SUD->UD_ITEM			 				,Nil},; 
						{"C6_PRODUTO",SUD->UD_PRODUTO 						,Nil},;
						{"C6_XPRDORI",SUD->UD_PRODUTO 						,Nil},;
						{"C6_QTDVEN",1										,Nil},;
						{"C6_XQTDORI",1										,Nil},;
						{"C6_TPOP"	,"F" 									,Nil},;
						{"C6_PRCVEN",round(Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_CUSTD"),4)				,Nil},;
						{"C6_VALOR"	,round(Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_CUSTD"),4) 			,Nil},;
						{"C6_PRUNIT",round(Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_CUSTD"),4)				,Nil},;
						{"C6_TES"	,If(xFilial("SC6")=="01",'781','665')	,Nil},;
						{"C6_CLI"	,substr(SUC->UC_CHAVE,1,6)				,Nil},;
						{"C6_LOJA"	,substr(SUC->UC_CHAVE,7,4)				,Nil},;
						{"C6_LOCAL"	,Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_LOCPAD") 					,Nil},;
						{"C6_CCUSTO",'' 									,Nil},;
						{"C6_ITEMCC",'' 									,Nil},;
						{"C6_XGPV"	,'TEC'			 						,Nil},;
						{"C6_ENTREG",ddatabase+1							,Nil},;
						{"C6_XDTEORI",1							 			,Nil},;
						{"C6_UM"	,Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_UM")				 			,Nil},;
						{"C6_XPATRIM",SUD->UD_XNPATRI						,Nil},;
						{"C6_XHRINC" ,TIME() 								,Nil},;
						{"C6_XDATINC",DATE()		 						,Nil},;
						{"C6_XUSRINC",cUsername 	 						,Nil}})
		DBskip()
	Enddo
EndIf

RestArea(aArea)

Return(aItens)