#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC21  บAutor  ณAlexandre Venancio  บ Data ณ  08/23/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rotina responsavel pela criacao dos movimentos de prepara-บฑฑ
ฑฑบ          ณcao de rota para sangria.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFINC21(cRota,dData1)

Local aArea	:=	GetArea()
Local cQuery
Local aParambox := {}
Local aRet		:= {}
                    
//aAdd(aParamBox,{1,"Data",dData,"99/99/99",".T.","",".T.",0,.F.})			//[8]
//aAdd(aParamBox,{1,"Rota",cRota,"@!","","ZZ1","",0,.F.})
	       
//If ParamBox(aParambox,'Parametros',aRet)
	
	cQuery := "SELECT ZF_FILIAL,ZF_DATA,ZF_ROTA,ZF_PATRIMO,ZF_CLIENTE,ZF_LOJA"
	cQuery += " FROM "+RetSQLName("SZF")
	cQuery += " WHERE ZF_ROTA='"+cRota+"' AND ZF_DATA='"+dtos(dData1)+"' AND ZF_PATRIMO<>'' AND D_E_L_E_T_=''"
	
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf         
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	dbSelectArea("TRB")
	                                     
	While !EOF()
	    DbSelectArea("SZN")
	    DbSetOrder(1)
	    If !Dbseek(xFilial("SZN")+DTOC(stod(TRB->ZF_DATA))+TRB->ZF_PATRIMO+'SANGRIA')
		    Reclock("SZN",.T.)     
		    SZN->ZN_FILIAL	:=	xFilial("SZF")
		    SZN->ZN_DATA   	:=	stod(TRB->ZF_DATA)
		    SZN->ZN_ROTA	:=	TRB->ZF_ROTA
		    SZN->ZN_PATRIMO	:=	TRB->ZF_PATRIMO
		    SZN->ZN_CLIENTE	:=	TRB->ZF_CLIENTE
		    SZN->ZN_LOJA	:=	TRB->ZF_LOJA
		    SZN->ZN_TIPINCL	:= 	'SANGRIA'
		    
		    SZN->(Msunlock())
		    
		EndIf
		DbSelectArea("TRB")
		
		DbSkip()
	EndDo
//EndIf

RestArea(aArea)

Return