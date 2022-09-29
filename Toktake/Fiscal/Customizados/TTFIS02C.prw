#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFIS02C  บAutor  ณAlexandre Venancio  บ Data ณ  06/25/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFIS02C()

Local cQuery             
Local nCont			:=	0
Private lMsErroAuto	:=	.F.  
Private aMata240	:=	{}  
            
If cEmpAnt <> "01"
	Return
EndIf
            
cQuery := "SELECT B2_FILIAL,B2_COD,B1_UM,B2_LOCAL,B2_QATU,B2_RESERVA,B2_QTSEGUM,B2_CM1,B2_VATU1
cQuery += " FROM SB2010 B2"
cQuery += " INNER JOIN SB1010 B1 ON B1_COD=B2_COD AND B1.D_E_L_E_T_=''"
cQuery += " WHERE B2_COD IN('1002102','1002113','1002114','1002116','1002118','1002282','1002344','1002535','1002536','1002537','1002538','1002539','1002540','1002541','1002542','1002543','1002544','1002583','1002584','1002585','1002586','1002587','1002588','1002589','1002590','1002591','1002592','1002117','1002224','1002226','1002227','1002228','1002229','1002230','1002231','1002232','1002233','1002234','1002279','1002280','1002281','1002283','1002284','1002345','3000281','1001780','2100179','2100323','2100326','2100327')
cQuery += " AND B2_QATU>0 AND B2.D_E_L_E_T_='' ORDER BY B2_FILIAL"
 //'1002117','1002224','1002226','1002227','1002228','1002229','1002230','1002231','1002232','1002233','1002234','1002279','1002280','1002281','1002283','1002284','1002345','3000281',
If Select('TRB') > 0
	dbSelectArea('TRB')                 
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

DbSelectArea("TRB")

While !EOF()
     
	dbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(TRB->B2_FILIAL+Alltrim(TRB->B2_COD)+"PC"+space(15-len(Alltrim(TRB->B2_COD)+"PC"))+TRB->B2_LOCAL)
		DbselectArea("TRB")
		dbskip()
		loop
	EndIf
	aAdd(aMata240, {})
	aAdd(aMata240[1], {'D3_FILIAL' ,TRB->B2_FILIAL	,Nil})
	aAdd(aMata240[1], {'D3_TM'     ,"807"        	,Nil})
	aAdd(aMata240[1], {'D3_COD'    ,TRB->B2_COD	  	,Nil})
	aAdd(aMata240[1], {'D3_UM'     ,TRB->B1_UM	   	,Nil})
	aAdd(aMata240[1], {'D3_QUANT'  ,TRB->B2_QATU 	,Nil})
	aAdd(aMata240[1], {'D3_LOCAL'  ,TRB->B2_LOCAL	,Nil})
	aAdd(aMata240[1], {'D3_EMISSAO',dDataBase	  	,Nil})
	aAdd(aMata240[1], {'D3_DOC'    ,GETSX8NUM("SD3","D3_DOC")   ,Nil})
//	aAdd(aMata240[1], {'D3_CUSTO1',TRB->B2_CM1     ,Nil})
	aAdd(aMata240[1], {'D3_XCTADES',"N"            ,Nil})
	aAdd(aMata240[1], {'D3_XORIGEM',"TTFIS02C"  	,Nil})

	dbSelectArea("SB2")
	dbSetOrder(1)
	If !dbSeek(TRB->B2_FILIAL+TRB->B2_COD+TRB->B2_LOCAL)
		CriaSB2(TRB->B2_COD,TRB->B2_LOCAL)
	Endif                            
	
	lMsErroAuto := .F.
	MSExecAuto({|x,y| mata240(x,y)},aMata240[1],3)
	If lMsErroAuto
		//Mostraerro()   
		DbselectArea("TRB")  
		aMata240 := {}
		dbskip()
		LOOP
	EndIf
	DbSelectArea("TRB")
	aMata240 := {}
	 
	dbSelectArea("SB2")
	dbSetOrder(1)
	If !dbSeek(TRB->B2_FILIAL+Alltrim(TRB->B2_COD)+"PC"+space(15-len(Alltrim(TRB->B2_COD)+"PC"))+TRB->B2_LOCAL)
		CriaSB2(Alltrim(TRB->B2_COD)+"PC",TRB->B2_LOCAL)
	Endif                            
	
	aAdd(aMata240, {})
	aAdd(aMata240[1], {'D3_FILIAL' ,TRB->B2_FILIAL	,Nil})
	aAdd(aMata240[1], {'D3_TM'     ,"205"        	,Nil})
	aAdd(aMata240[1], {'D3_COD'    ,Alltrim(TRB->B2_COD)+"PC"	  	,Nil})
	aAdd(aMata240[1], {'D3_UM'     ,TRB->B1_UM	   	,Nil})
	aAdd(aMata240[1], {'D3_QUANT'  ,TRB->B2_QATU 	,Nil})
	aAdd(aMata240[1], {'D3_LOCAL'  ,TRB->B2_LOCAL	,Nil})
	aAdd(aMata240[1], {'D3_EMISSAO',dDataBase	  	,Nil})
	aAdd(aMata240[1], {'D3_DOC'    ,GETSX8NUM("SD3","D3_DOC")   ,Nil})
  //	aAdd(aMata240[1], {'D3_CUSTO1' ,TRB->B2_CM1     ,Nil})
	aAdd(aMata240[1], {'D3_XCTADES',"N"            ,Nil})
	aAdd(aMata240[1], {'D3_XORIGEM',"TTFIS02C"  	,Nil})
	
	lMsErroAuto := .F.
	MSExecAuto({|x,y| mata240(x,y)},aMata240[1],3)
	If lMsErroAuto
		//Mostraerro() 
		DbselectArea("TRB")
		aMata240 := {}
		dbskip()
		LOOP  
	EndIf 
	aMata240 := {}
	DbSelectArea("TRB")
 	DbSkip()  
 	nCont++
EndDo
                               //807 saida //205 entrada  
ALERT("FINALIZADO COM "+cvaltochar(nCont)+" REGISTROS ADICIONADOS")
                               
Return