#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA30  บAutor  ณMicrosiga           บ Data ณ  09/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Visualizacao de chamados call center e tecnico atraves da บฑฑ
ฑฑบ          ณrotina de monitoramento de chamados.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMKA30(cGeog,cChamado,nOper)

Local aArea	:=	GetArea()
Local nRecuc	:=	0
Private aRotina	:=	{}
Private ALTERA	:= .F.            

If nOper == 1                  
      aRotina	:= {	{ "Pesquisar"  ,"AxPesqui"        ,0,1 },; 	//
					{ "Visualizar"  ,"TK271CallCenter" ,0,2 },; 	//
					{ "Incluir"  ,"TK271CallCenter" ,0,3 },; 	//
						{ "Alterar"  ,"TK271CallCenter" ,0,4 }} 	// 
	DbSelectArea("SUC")
	DbSetOrder(1)
	DbSeek(cGeog+cChamado)
	nRecuc := recno()
	
	DbSelectArea("SUD")
	DbSetOrder(1)
	DbSeek(cGeog+cChamado)
	
	 INCLUI := .T.
	   
	TK271CallCenter('SUC',nRecuc,2)   
Else
                        
	aRotina := { 	{ "Pesquisar"	,"AxPesqui" 	,0	,1	,0	,.F.	}	,;	//
						{ "Visualizar"	,"At300Visua"	,0	,2	,0	,.T.	}	,;	//
						{ "Incluir"	,"At300Inclu"	,0	,3	,0	,.T.	}	,;	//
						{ "Alterar"	,"At300Alter"	,0	,4	,0	,.T.	}	,;	//
						{ "Excluir"	,"At300Exclu"	,0	,5	,0	,.T.	}	,;	//
						{ "eFetivar"	,"At300Efet" 	,0	,4	,0	,.T.	}	,;	//
						{ "Legenda"	,"At300Leg" 	,0	,2	,0	,.T.	}	}	//
	DbSelectArea("AB1")
	DbSetOrder(5)
	//DbSetOrder(1) 
	If DbSeek( cGeog+cChamado)
	 	nRecuc := recno()
	 	
	 	
	 	
		At300Visua('AB1',nRecuc,2)
	EndIf
	
EndIf

RestArea(aArea)

Return