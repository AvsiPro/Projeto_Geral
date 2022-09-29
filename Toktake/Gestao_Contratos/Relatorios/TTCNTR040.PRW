#INCLUDE "CNTR040.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE ATOTAL   1
#DEFINE ADESCONT 2
#DEFINE AMULTAS  3
#DEFINE AVLBRUT  4
#DEFINE ARETENC  5
#DEFINE AIRRF    6
#DEFINE AISS     7
#DEFINE AINSS    8
#DEFINE APIS     9
#DEFINE ACOFIN   10
#DEFINE ACSLL    11
#DEFINE AVLLIQ   12
#DEFINE ABONIF   13

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |CNTR040   บAutor  ณMarcelo Custodio    บ Data ณ  21/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime boletim da medicao de acordo com o layout acordado  บฑฑ
ฑฑบ          ณcom a Galvao Engenharia                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR040                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TTCNTR040()
local cMens := ""
Local nOpca := 0

Private cTitRel := OemToAnsi(STR0001) //Medicoes
Private lEnd	:= .F.

If cEmpAnt == "01"
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ajustar perguntas do SX1	    			  				 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AjustaSX1()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ajustar consulta padrao da medicao              		     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AjustaSXB()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ajustar perguntas do SXB									 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If FindFunction("CliConsPad")
		CliConsPad() 
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variaveis utilizadas para parametros                         |
	//| mv_par01     // Medicao de:                                  |
	//| mv_par02     // Medicao ate:	                             |
	//ณ mv_par03     // Contrato de:                                 ณ
	//ณ mv_par04     // Contrato ate:                                ณ
	//ณ mv_par05     // Data Inicio:                                 ณ
	//ณ mv_par06     // Data Fim:                                    ณ
	//ณ mv_par07     // Situacao de:                                 ณ
	//ณ mv_par08     // Situacao ate:                                ณ
	//ณ mv_par09     // Fornecedor de:                               ณ
	//ณ mv_par10     // Fornecedor ate:                              ณ
	//ณ mv_par11     // Tipo de Contrato?:                           ณ
	//ณ mv_par12     // Exibir Desconto: Sim/Nao                     ณ
	//ณ mv_par13     // Exibir Multas/Bonificacoes: Sim/Nao          ณ
	//ณ mv_par14     // Exibir Caucoes Retidas: Sim/Nao              ณ  
	//ณ mv_par15     // Cliente de:  					             ณ
	//ณ mv_par16     // Cliente ate: 				                 ณ
	//ณ mv_par17     // Revisใo de:  					             ณ
	//ณ mv_par18     // Revisใo ate: 				                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Pergunte("TTCNR040",.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tela de configuracao do Relatorio			         	     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi(STR0001) PIXEL    //"Medicoes"
	@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
	@ 29, 15 SAY OemToAnsi(STR0002) SIZE 268, 8 OF oDlg PIXEL    //"Este relatorio ira emitir uma relacao de medicoes, exibindo suas respectivas"
	@ 38, 15 SAY OemToAnsi(STR0003) SIZE 268, 8 OF oDlg PIXEL    //"multas/bonificacoes, descontos e caucoes retidas. Favor verificar os  "
	@ 48, 15 SAY OemToAnsi(STR0004) SIZE 268, 8 OF oDlg PIXEL    //"parametros do relatorio.."
	DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte("CNR040",.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
	
	If nOpca == 1
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Processamento do Relatorio							         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		RptStatus({|lEnd| CNR040Imp(@lEnd)})
	EndIf
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |AjustaSXB บAutor  ณFabio Alves Silva   บ Data ณ  28/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjustar consulta padrao da medicao                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR040                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSXB()
Local i,j
Local aSXB
Local aEstrut

dbSelectArea("SXB")
dbSetOrder(1)

If !SXB->(dbSeek("CND"))
	aSXB := {}
	aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}
	Aadd(aSXB,{"CND   ","1","01","DB","Medi็๕es"   ,""           ,""            ,"CND"            })
	Aadd(aSXB,{"CND   ","2","01","01","Nr Medicao" ,"Nr Medicion","Measur. Nbr.",""               })
	Aadd(aSXB,{"CND   ","4","01","01","Nr Contrato","Nr Contrato","Contract Nr" ,"CND_CONTRA"     })
	Aadd(aSXB,{"CND   ","4","01","02","Nr Medicao" ,"Nr Medicao" ,"Nr Medicao"  ,"CND_NUMMED"     })
	Aadd(aSXB,{"CND   ","5","01",""  ,""           ,""           ,""            ,"CND->CND_NUMMED"})
	
	For i:= 1 To Len(aSXB)
		If !Empty(aSXB[i][1])
			If !dbSeek(aSXB[i,1]+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
				RecLock("SXB",.T.)
				
				For j:=1 To Len(aSXB[i])
					If !Empty(FieldName(FieldPos(aEstrut[j])))
						FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
					EndIf
				Next j
				
				dbCommit()
				MsUnLock()
			EndIf
		EndIf
	Next i
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFunao    ณ AjustaSX1ณ Autor ณ 					    ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Ajusta as perguntas do SX1                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ CNTR040		                                              ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustaSX1()
Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
Local cPerg	   := "TTCNR040"
Local nTamSX1  := Len(SX1->X1_GRUPO)
Local nTamCli  := TamSx3('A1_COD')[1]
Local nTamFor  := TamSx3('A2_COD')[1]

//---------------------------------------MV_PAR01--------------------------------------------------
aHelpPor := {"Numero inicial da Medicao"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"01","Medicao de:","","","mv_ch1","C",6,0,0,"G","","CND","","S","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor := {"Numero final da Medicao"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"02","Medicao ate:","","","mv_ch2","C",6,0,0,"G","","CND","","S","mv_par02","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor := {"Numero inicial do Contrato"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"03","Contrato de:","","","mv_ch3","C",15,0,0,"G","","CN9","","S","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR04--------------------------------------------------
aHelpPor := {"Numero final do Contrato"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"04","Contrato ate:","","","mv_ch4","C",15,0,0,"G","","CN9","","S","mv_par04","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor := {"Data de inicio da Vigencia"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"05","Vigencia de:","","","mv_ch5","D",08,0,0,"G","","","","S","mv_par05","","","","01/01/06","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR06--------------------------------------------------
aHelpPor := {"Data de termino da Vigencia"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"06","Vigencia ate:","","","mv_ch6","D",08,0,0,"G","","","","S","mv_par06","","","","31/12/49","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR07--------------------------------------------------
aHelpPor := {"Codigo inicial da Situacao"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"07","Situacao de:","","","mv_ch7","C",2,0,0,"G","","","","S","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR08--------------------------------------------------
aHelpPor := {"Codigo final da Situacao"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"08","Situacao ate:","","","mv_ch8","C",2,0,0,"G","","","","S","mv_par08","","","","99","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR09--------------------------------------------------
aHelpPor := {"Codigo inicial do Fornecedor"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"09","Fornecedor de:","","","mv_ch9","C",nTamFor,0,0,"G","CNR040ClFr('1')","SA2","","S","mv_par09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR10--------------------------------------------------
aHelpPor := {"Codigo final do Fornecedor"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"10","Fornecedor ate:","","","mv_cha","C",nTamFor,0,0,"G","CNR040ClFr('1')","SA2","","S","mv_par10","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR11--------------------------------------------------
aHelpPor := {"Codigo do Tipo de Contrato"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"11","Tipo de Contrato ?","","","mv_chb","C",3,0,0,"G","","CN1","","S","mv_par11","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR12--------------------------------------------------
aHelpPor := {"Percentual de cแlculo do IRRF"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"12","% IRRF ?","","","mv_chc","N",5,2,0,"G","","","","S","mv_par12","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR13--------------------------------------------------
aHelpPor := {"Percentual de cแlculo do ISS"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"13","% ISS ?","","","mv_chd","N",5,2,0,"G","","","","S","mv_par13","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR14--------------------------------------------------
aHelpPor := {"Percentual de cแlculo do INSS"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"14","% INSS ?","","","mv_che","N",5,2,0,"G","","","","S","mv_par14","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR15--------------------------------------------------
If !SX1->(dbSeek(PADR(cPerg,nTamSX1)+"15"))
	aHelpPor := {"Codigo inicial do Cliente"}
	aHelpSpa := {"Codigo inicio del Cliente"}
	aHelpEng := {"Client initial Code"}
	
	PutSX1(cPerg,"15","Cliente de:","","","mv_chf","C",nTamCli,0,0,"G","CNR040ClFr('2')","SA1GCT","","S","mv_par15","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf	

//---------------------------------------MV_PAR16--------------------------------------------------
If !SX1->(dbSeek(PADR(cPerg,nTamSX1)+"16"))
	aHelpPor := {"Codigo final do Cliente"}
	aHelpSpa := {"Codigo final del Cliente"}
	aHelpEng := {"Client final Code"}
	
	PutSX1(cPerg,"16","Cliente ate:","","","mv_chg","C",nTamCli,0,0,"G","CNR040ClFr('2')","SA1GCT","","S","mv_par16","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf	
                                                                                       
//---------------------------------------MV_PAR17--------------------------------------------------
If !SX1->(dbSeek(PADR(cPerg,nTamSX1)+"17"))
	aHelpPor := {"Codigo inicial da Revisใo do Contrato"}
	aHelpSpa := {"Codigo inicio del Revision del Contrato"}
	aHelpEng := {"Review of Contract initial Code"}
	
	PutSX1(cPerg,"17","Revisao de:","","","mv_chh","C",3,0,0,"G","","","","S","mv_par17","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf	

//---------------------------------------MV_PAR18--------------------------------------------------
If !SX1->(dbSeek(PADR(cPerg,nTamSX1)+"18"))
	aHelpPor := {"Codigo final da Revisใo do Contrato"}
	aHelpSpa := {"Codigo final del Revision del Contrato"}
	aHelpEng := {"Review of Contract final Code"}
	
	PutSX1(cPerg,"18","Revisao ate:","","","mv_chi","C",3,0,0,"G","","","","S","mv_par18","","","","ZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf	                                             

//---------------------------------------MV_PAR19--------------------------------------------------
If !SX1->(dbSeek(PadR(cPerg,nTamSX1)+"19")) 	
	aHelpPor := {"Data de refer๊ncia para conversใo","dos valores entre moedas."}
	aHelpEng := {"Fecha de referencia para conversi๓n","de los valores entre monedas."}
	aHelpSpa := {"Reference date for values","convertion between currency."}
	
	PutSX1(cPerg,"19","Data de referencia","Fecha de referencia","Reference date","mv_chj","D",8,0,0,"G","","","","S","mv_par19","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf
      
//---------------------------------------MV_PAR20--------------------------------------------------
If !SX1->(dbSeek(PadR(cPerg,nTamSX1)+"20")) 	
	aHelpPor := {"M๊s/Ano de Compet๊ncia"}
	aHelpEng := {"Fecha de referencia para conversi๓n","de los valores entre monedas."}
	aHelpSpa := {"Reference date for values","convertion between currency."}
	
	PutSX1(cPerg,"20","M๊s/Ano Compet๊ncia","Fecha de referencia","Reference date","mv_chj","C",7,0,0,"G","","","","S","mv_par20","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInclui valida็ใo no parโmetro MV_PAR09 - Fornecedor de ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If SX1->( dbSeek(PadR(cPerg,nTamSX1)+"09",.T.) ) 
	If  SX1->X1_VALID != "CNR040ClFr('1')"
		RecLock("SX1",.F.)
		SX1->X1_VALID := "CNR040ClFr('1')"
		MsUnlock()
	EndIf  

	If  SX1->X1_TAMANHO!= nTamFor
		RecLock("SX1",.F.)
		SX1->X1_TAMANHO := nTamFor
		MsUnlock()
	EndIf            
EndIf	                                              
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInclui valida็ใo e tamanho no parโmetro MV_PAR10 - Fornecedor para ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If SX1->( dbSeek(PadR(cPerg,nTamSX1)+"10",.T.) ) 
	If  SX1->X1_VALID != "CNR040ClFr('1')"
		RecLock("SX1",.F.)
		SX1->X1_VALID := "CNR040ClFr('1')"
		MsUnlock()
	EndIf  
		
	If  SX1->X1_TAMANHO!= nTamFor
		RecLock("SX1",.F.)
		SX1->X1_TAMANHO := nTamFor
		MsUnlock()
	EndIf          
EndIf
             
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInclui valida็ใo no parโmetro MV_PAR15 - Cliente    de ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If SX1->( dbSeek(PadR(cPerg,nTamSX1)+"15",.T.) ) 
	If  SX1->X1_VALID != "CNR040ClFr('2')"
		RecLock("SX1",.F.)
		SX1->X1_VALID := "CNR040ClFr('2')"
		MsUnlock()
	EndIf  

	If  SX1->X1_TAMANHO!= nTamCli
		RecLock("SX1",.F.)
		SX1->X1_TAMANHO := nTamCli
		MsUnlock()
	EndIf         
	
	If SX1->X1_F3!= "SA1GCT"
		RecLock("SX1",.F.)
		SX1->X1_F3 := "SA1GCT"
		MsUnlock()
	EndIf     
EndIf	                                              
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInclui valida็ใo e tamanho no parโmetro MV_PAR16 - Cliente para    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If SX1->( dbSeek(PadR(cPerg,nTamSX1)+"16",.T.) ) 
	If  SX1->X1_VALID != "CNR040ClFr('2')"
		RecLock("SX1",.F.)
		SX1->X1_VALID := "CNR040ClFr('2')"
		MsUnlock()
	EndIf  
		
	If  SX1->X1_TAMANHO!= nTamCli
		RecLock("SX1",.F.)
		SX1->X1_TAMANHO := nTamCli
		MsUnlock()
	EndIf          
	
	If SX1->X1_F3!= "SA1GCT"
		RecLock("SX1",.F.)
		SX1->X1_F3 := "SA1GCT"
		MsUnlock()
	EndIf  	
EndIf

RestArea(aAreaAnt)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |CNR040Imp บAutor  ณFabio Alves Silva   บ Data ณ  28/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao do Relatorio de Medicao                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR040                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CNR040Imp(lEnd)

Local cQuery       := ""
Local cAliasCNE    := ""
Local cMedicao     := ""
Local cContra      := ""
Local cRevisa      := ""
Local cDescri      := ""  
Local cUM          := ""
Local aStrucCND    := CND->(dbStruct())
Local aStrucCNE    := CNE->(dbStruct())
Local aStrucCNB    := CNB->(dbStruct())
Local aTot         := Array(13)
Local aTotINMO     := {}
Local aTotINME     := {}

Local cDirSpool    := GetMv("MV_RELT")

Local nTotAcm      := 0
Local nTot         := 0
Local nBruto       := 0
Local nMultAcm     := 0
Local nTotMult     := 0
Local nBonifAcm	 := 0
Local nTotBonif	 := 0
Local nDescAcm     := 0
Local nRetAcm      := 0
Local nBrAcumulado := 0
Local nBrMedicao   := 0
Local nBrTotal     := 0
Local nLinBck      := 0
Local nX           := 0
Local nDescMe	   := 0
Local nRetCac	   := 0
Local cPer1
Local cPer2
Local aAux2			:= {}
Local nVlrPatri		:= 0
Local cTxtDescri	:= ""
Local nQtdDias		:= 0
Local nQtdComp		:= 0
Local nVlDia		:= 0
Local nTotPRata		:= 0
Local cCompet		:= ""
Local cAuxMes		:= ""
Local cTpFat		:= ""
Local cCodCli		:= ""
Local cLoja			:= ""
Local cNomeCli		:= ""
Local lInsumo		:= .t.
Local cProduto		:= ""
Local cDescProd		:= ""
Local cLojaSN1		:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Recupera Picture dos Campos								     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cPtVLMEAC := PesqPict("CND","CND_VLMEAC")
Local cPtVLSALD := PesqPict("CND","CND_VLSALD")
Local cPtVLTOT1 := PesqPict("CND","CND_VLTOT" )
Local cPtQTDSOL := PesqPict("CNE","CNE_QTDSOL")
Local cPtQTAMED := PesqPict("CNE","CNE_QTAMED")
Local cPtQUANT  := PesqPict("CNE","CNE_QUANT" )
Local cPtPERC   := PesqPict("CNE","CNE_PERC"  )
Local cPtVLUNIT := PesqPict("CNE","CNE_VLUNIT")
Local cPtVLTOT  := PesqPict("CNE","CNE_VLTOT" )   
Local cPtQTMED  := PesqPict("CNB","CNB_QTDMED")
Local cPtCNBTOT := PesqPict("CNB","CNB_VLTOT" )
Local cPtDESC   := PesqPict("CND","CND_DESCME")
Local cPtMULT   := PesqPict("CNR","CNR_VALOR" )
Local cPtRETC   := PesqPict("CND","CND_RETCAC")
Local cPtVLCTR  := PesqPict("CN9","CN9_VLATU" )
Local cPtINSMO  := PesqPict("CN9","CN9_INSSMO")
Local cPtINSME  := PesqPict("CN9","CN9_INSSME")

Local cProduto1 := ""
Local cProduto2 := ""
Local cDescri1  := ""
Local cDescri2  := ""
Local nCNETamPrd:= TamSX3("CNE_PRODUT")[1]
Local nCNETamDsc:= TamSX3("CNB_DESCRI")[1]

Local nTipo     := 2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CNR040RES - Ponto de entrada para desenvolvimento do resumo de medicao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lResumo   := ExistBlock("CNR040RES")

Local lFiltForn := !Empty(mv_par09) .Or. (!Empty(mv_par10) .And. UPPER(mv_par10) != REPLICATE("Z",TamSx3("CND_FORNEC")[1]))
Local lFixo     := .T.

Local dDataRef  := If(Empty(mv_par19),dDataBase,mv_par19)

Private cAliasCND    := GetNextAlias()
Private nTotfat		:= 0	// total faturamento (medicoes + insumos)
Private nTotMed := 0		// total medicao - valor unitario planilha
Private nTotInsumo := 0		// total insumo
Private nlin	 := 2900
Private nPagina := 0
Private oPrint

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa Fontes											           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private oFont06	:= TFont():New("Arial",06,08,,.T.,,,,.T.,.F.)
Private oFont07	:= TFont():New("Arial",06,08,,.F.,,,,.F.,.F.)
Private oFont08 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa ponto de entrada	           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ExistBlock("CNR040IMP")
	ExecBlock("CNR040IMP",.F.,.F.)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa Objeto TMSPrinter								 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:= TMSPrinter():New(STR0001)
oPrint:Setup()
oPrint:SetLandscape()

aStrucCND := CND->(dbStruct())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta query para selecao das medicoes      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "SELECT * FROM " + RetSQLName("CND")+ " CND," + RetSQLName("CN9") + " CN9 "
cQuery += "WHERE CND.CND_FILIAL = '"+xFilial("CND")+"'"
cQuery += "  AND CN9.CN9_FILIAL = '"+xFilial("CN9")+"'"
cQuery += "  AND CND.CND_CONTRA = CN9.CN9_NUMERO "
cQuery += "  AND CND.CND_REVISA = CN9.CN9_REVISA "
cQuery += "  AND CND.CND_NUMMED >= '"+mv_par01+"'"
cQuery += "  AND CND.CND_NUMMED <= '"+mv_par02+"'"
cQuery += "  AND CND.CND_CONTRA >= '"+mv_par03+"'"
cQuery += "  AND CND.CND_CONTRA <= '"+mv_par04+"'" 
cQuery += "  AND CND.CND_REVISA >= '"+mv_par17+"'"
cQuery += "  AND CND.CND_REVISA <= '"+mv_par18+"'"
cQuery += "  AND CN9.CN9_DTINIC >= '"+dtos(mv_par05)+"'"
cQuery += "  AND CN9.CN9_DTFIM  <= '"+dtos(mv_par06)+"'"
cQuery += "  AND CN9.CN9_SITUAC >= '"+mv_par07+ "'"
cQuery += "  AND CN9.CN9_SITUAC <= '"+mv_par08+ "'"
cQuery += "  AND "
If lFiltForn
	cQuery += " CND.CND_FORNEC >= '"+mv_par09+"' AND "
	cQuery += " CND.CND_FORNEC <= '"+mv_par10+"' AND "
Else
	cQuery += " CND.CND_CLIENT >= '"+mv_par15+"' AND "
	cQuery += " CND.CND_CLIENT <= '"+mv_par16+"' AND "
EndIf
If !Empty(mv_par11)
	cQuery += " CN9.CN9_TPCTO   = '"+mv_par11 + "' AND "
EndIf
cQuery += "      CND.D_E_L_E_T_ = ' ' "
cQuery += "  AND CN9.D_E_L_E_T_ = ' ' "                

cQuery += " AND CND_COMPET='"+mv_par20 +"'"

cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasCND,.F.,.T.)},STR0005) //-- Processando

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza estrutura do CND           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 to Len(aStrucCND)
	If aStrucCND[nX,2] != 'C' .And. (cAliasCND)->( FieldPos( aStrucCND[nx,1] ) ) > 0
		TCSetField(cAliasCND,aStrucCND[nX,1], aStrucCND[nX,2],aStrucCND[nX,3],aStrucCND[nX,4])
	EndIf
Next nX

While !(cAliasCND)->(Eof())
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Armazena o codigo da medicao, contrato e revisao  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cMedicao := (cAliasCND)->CND_NUMMED
	cContra  := (cAliasCND)->CND_CONTRA 
	cRevisa  := (cAliasCND)->CND_REVISA
	
	cTpFat := alltrim((cAliasCND)->CN9_XTPFAT)
	cCodCli := (cAliasCND)->CN9_CLIENT
	cLoja := IIF(cTpFat=="2",(cAliasCND)->CN9_LOJACL,"")
	lInsumo := .t.
	
	dbSelectArea("CN9")
	dbSetOrder(1)
	
	If dbSeek(xFilial("CN9")+(cAliasCND)->CND_CONTRA+(cAliasCND)->CND_REVISA)
		lFixo := Posicione("CN1",1,xFilial("CN1")+(cAliasCND)->CN9_TPCTO,"CN1_CTRFIX") == "1"
	
		If nLin >= 2350
			CNRCabec(Nil,Nil,cTitRel,,.T.) //-- Impressao do Cabecalho da pagina
		EndIf
		
		CNRBox(0050,3180,STR0016,,.T.,1)								//"BOLETIM DE MEDIวรO DE SERVIวOS"
		CNRBox(0050,0295,STR0017,(cAliasCND)->CND_NUMMED,.F.,,oFont08)	//"Medi็ใo"
		CNRBox(0300,0595,STR0018,(cAliasCND)->CND_CONTRA,.F.,,oFont08)	//"Contrato"
		CNRBox(0600,0750,STR0073,(cAliasCND)->CND_REVISA,.F.,,oFont08)	//"Revisใo"
		CNRBox(0755,0910,STR0019,(cAliasCND)->CND_NUMERO,.F.,,oFont08)	//"Planilha"
		If !Empty((cAliasCND)->CND_FORNEC)
			CNRBox(0915,1800,STR0020,AllTrim((cAliasCND)->CND_FORNEC)+" - "+Posicione("SA2",1,xFilial("SA2")+(cAliasCND)->CND_FORNEC+(cAliasCND)->CND_LJFORN,"A2_NOME" ),.F.,,oFont08)//"Fornecedor"
		Else
			CNRBox(0915,1800,STR0072,AllTrim((cAliasCND)->CND_CLIENT)+" - "+Posicione("SA1",1,xFilial("SA1")+(cAliasCND)->CND_CLIENT+(cAliasCND)->CND_LOJACL,"A1_NOME" ),.F.,,oFont08)//"Cliente"		
		EndIf
		
		// Verifica se a planilha considera Insumos
 		dbSelectArea("CNA")
  		dbSetOrder(1) //CNA_FILIAL+CNA_CONTRA+CNA_REVISA+CNA_NUMERO (filial+contrato+revisao+planilha)
   		If dbSeek(xFilial("CNA")+cContra +AvKey("","CNA_REVISA")+(cAliasCND)->CND_NUMERO)
    		If aLLtRIM(CNA->CNA_XINSUM) == "2"
    			lInsumo := .F.
    		EndIf
    	EndIf
		
		// monta o total do faturamento (medicoes + insumos)
		If (cAliasCND)->CND_NUMERO == "000001"
			If lInsumo
				ftotInsumo()
			EndIf
		EndIf
		
		nTotfat := (cAliasCND)->CND_VLTOT+nTotInsumo
		
		CNRBox(1805,2200,'Valor do Faturamento',TransForm(nTotFat,cPtVLCTR),.F.,,oFont08)	//"Valor do Medicao"
		CNRBox(2205,2380,'Vencimento',DTOC(CN9->CN9_DTFIM),.F.,,oFont08)					//"Venc. do Contrato" MEDICAO CN9->CN9_CONDPG + DDATABASE AQUI
		
		cAuxMes := Val(SubStr((cAliasCND)->CND_COMPET,1,2))-1 //MONTH((cAliasCND)->CND_COMPET)-1
		If cAuxMes <= 9
			cAuxMes := "0" +cValTochar(cAuxMes)
		Else
			cAuxMes := cValTochar(cAuxMes)
		EndIf
		
		
		// Define a variavel da competencia
		cCompet := SUBSTR(CN9->CN9_XPCOMP,1,2) +"/" +cAuxMes  +" A " +SUBSTR(CN9->CN9_XPCOMP,4,2) +"/" +cAuxMes
		
		CNRBox(2385,2650,'Perํodo',cCompet,.F.,,oFont08)						//"Periodo"
		CNRBox(2655,2930,'Compet๊ncia',(cAliasCND)->CND_COMPET,.F.,,oFont08)	//"Periodo"		
		CNRBox(2935,3180,STR0024,DTOC((cAliasCND)->CND_DTFIM),.T.,,oFont08)		//"Data" DATAMEDICAO AQUI
	
		dbSelectArea("CNE")
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Cabecalho dos Itens da Medicao						 		  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		CNRBox(0050,0150,STR0025,,.T.,5,oFont06)	//"Item"
		CNRBox(0155,0370,STR0026,,.T.,5,oFont06)	//"Produto"
		CNRBox(0375,1090,STR0027,,.T.,5,oFont06)	//"Descri็ใo"
//		CNRBox(1015,1090,STR0028,,.F.,2,oFont06)	//"Unid."
		CNRBox(1095,1300,STR0029,,.T.,5,oFont06)	//"Vl. Unit."
		CNRBox(1305,1500,"Patrimonios",,.T.,5,oFont06)	//"Patrimonios"
		CNRBox(1505,1600,"Loja",,.T.,5,oFont06)		// Loja 
		CNRBox(1605,2200,"Cliente",,.T.,5,oFont06)	// Nome cliente
//		CNRBox(1625,1880,STR0031,,.F.,2,oFont06)	//"Acum. Anter."
//		CNRBox(1885,2145,STR0032,,.F.,2,oFont06)	//"Qtd. Med."
//		CNRBox(2150,2410,STR0033,,.F.,2,oFont06)	//"Acum. Tot."
//		CNRBox(2415,2660,STR0034,,.F.,2,oFont06)	//"Vl. Acum."
//		CNRBox(2665,2930,STR0035,,.F.,2,oFont06)	//"Vl. Medicao"
//		CNRBox(2935,3180,STR0036,,.T.,2,oFont06)	//"Vl. Acum. Tot."
	
	    If lFixo
			cQuery := "SELECT CNE.CNE_ITEM,    CNE.CNE_PRODUT, CNB.CNB_DESCRI, CNB.CNB_UM,     CNB.CNB_VLUNIT, CNE.CNE_QTDSOL, "
			cQuery += "       CNE.CNE_QTAMED,  CNE.CNE_QUANT,  CNE.CNE_PERC,   CNE.CNE_VLUNIT, CNE.CNE_VLTOT,  CNB.CNB_QUANT,  "
			cQuery += "       CNB.CNB_QTDMED, (CNE.CNE_QTDSOL-CNE.CNE_QTAMED) AS CNE_QTDACM, ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), CNB_XPATRI)),'') AS CHAPA, ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), CNB_XPRORA)),''), CNB.R_E_C_N_O_ CNBREC "
			cQuery += "  FROM "+ RetSQLName("CNE")+" CNE, "+RetSQLName("CNB")+" CNB "
			cQuery += " WHERE CNE.CNE_FILIAL = '"+xFilial("CNE")+"'"
			cQuery += "   AND CNB.CNB_FILIAL = '"+xFilial("CNB")+"'"
			cQuery += "   AND CNE.CNE_NUMMED = '"+cMedicao+"'" 
			cQuery += "   AND CNE.CNE_CONTRA = '"+cContra +"'"
			cQuery += "   AND CNE.CNE_REVISA = '"+cRevisa +"'"
			cQuery += "   AND CNB.CNB_CONTRA = CNE.CNE_CONTRA "
			cQuery += "   AND CNB.CNB_REVISA = CNE.CNE_REVISA "
			cQuery += "   AND CNB.CNB_NUMERO = CNE.CNE_NUMERO "
			cQuery += "   AND CNB.CNB_ITEM   = CNE.CNE_ITEM   "
			cQuery += "   AND CNB.D_E_L_E_T_ = ' ' "
			cQuery += "   AND CNE.D_E_L_E_T_ = ' ' "
		Else  
			cQuery := "SELECT CNE.CNE_ITEM,    CNE.CNE_PRODUT, CNE.CNE_QTDSOL, "
			cQuery += "       CNE.CNE_QTAMED,  CNE.CNE_QUANT,  CNE.CNE_PERC,   "
			cQuery += "       CNE.CNE_VLUNIT, CNE.CNE_VLTOT, (CNE.CNE_QTDSOL-CNE.CNE_QTAMED) AS CNE_QTDACM "
			cQuery += "  FROM "+ RetSQLName("CNE")+" CNE "
			cQuery += " WHERE CNE.CNE_FILIAL = '"+xFilial("CNE")+"'"
			cQuery += "   AND CNE.CNE_NUMMED = '"+cMedicao+"'" 
			cQuery += "   AND CNE.CNE_CONTRA = '"+cContra +"'"  
			cQuery += "   AND CNE.CNE_REVISA = '"+cRevisa +"'"
			cQuery += "   AND CNE.D_E_L_E_T_ = ' ' "		
		EndIf
		
		cAliasCNE := GetNextAlias()
		cQuery := ChangeQuery(cQuery)
		MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasCNE,.F.,.T.)},STR0005) //-- Processando

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza estrutura dos itens da medicao  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		For nX := 1 to Len(aStrucCNE)
			If aStrucCNE[nX,2] != 'C' .And. (cAliasCNE)->( FieldPos( aStrucCNE[nx,1] ) ) > 0
				TCSetField(cAliasCNE,aStrucCNE[nX,1], aStrucCNE[nX,2],aStrucCNE[nX,3],aStrucCNE[nX,4])
			EndIf
		Next nX

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza estrutura dos itens da planilha ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		For nX := 1 to Len(aStrucCNB)
			If aStrucCNB[nX,2] != 'C' .And. (cAliasCNE)->( FieldPos( aStrucCNB[nx,1] ) ) > 0
				TCSetField(cAliasCNE,aStrucCNB[nX,1], aStrucCNB[nX,2],aStrucCNB[nX,3],aStrucCNB[nX,4])
			EndIf
		Next nX

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza campo calculado na query ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		TCSetField(cAliasCNE,"CNE_QTDACM", "N",TamSx3("CNE_QUANT")[1],TamSx3("CNE_QUANT")[2])

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Inicializa as variaveis de totalizacao		  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		nTotAcm := 0
		nTot    := 0
		nBruto  := 0
		cDescri := ''
	
		While !(cAliasCNE)->(Eof())
            
			// Define o valor total da medicao (Valor unitario da planilha - CNB)
			nTotMed := (cAliasCNE)->CNE_VLUNIT //(cAliasCNE)->CNB_VLUNIT
			
			If nLin >= 2350
				CNRCabec(Nil,Nil,cTitRel,,.T.) //-- Impressao do Cabecalho da pagina
			EndIf   
			//Limpa as descricoes e produto
			cDescri1  := ""
			cDescri2  := ""
			cProduto1 := ""
			cProduto2 := ""
			cPatrimo  := (cAliasCNE)->CHAPA
			// Descricao das medicoes
			If lFixo
				cDescri  := AllTrim((cAliasCNE)->CNB_DESCRI)   
			Else
		   		cDescri :=  Posicione("SB1",1,xFilial("SB1")+(cAliasCNE)->CNE_PRODUT,"B1_DESC")
		   		cUM     :=  Posicione("SB1",1,xFilial("SB1")+(cAliasCNE)->CNE_PRODUT,"B1_UM")
			EndIf
		   
			cDescri1 := cDescri
			If nCNETamDsc> 40 .And. !Empty(SubStr(cDescri,41,nCNETamDsc))
				nTipo := 5      
			   	cDescri1 := SubStr(cDescri,1,40)           
			   	cDescri2 := SubStr(cDescri,41,nCNETamDsc)     
			 Else
				nTipo    := 5
				cDescri2 :=""  		 
			 EndIf
					 
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica o conteudo do campo Produtoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cProduto1 := (cAliasCNE)->CNE_PRODUT  
			
			If nCNETamPrd> 15 .And. !Empty(SubStr((cAliasCNE)->CNE_PRODUT,16,nCNETamPrd)) 
				nTipo := 5           
			   	cProduto1 := SubStr((cAliasCNE)->CNE_PRODUT,1,15)           
			   	cProduto2 := SubStr((cAliasCNE)->CNE_PRODUT,16,nCNETamPrd) 			   
			Else  
				If Empty(cDescri2)           
					nTipo    := 5
					cProduto2:=""					 
				EndIf
			EndIf
				
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao dos Itens da Medicao						   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If "|" $ cPatrimo
				aAux := strtokarr(cPatrimo,"|")
				For nX := 1 to len(aAux)
					If !Empty(aAux[nX])
						cPatrimo := SubStr( aAux[nX],1,At("=",aAux[nX])-1 )
						RetInfPatr(cPatrimo,@cProduto,@cDescProd,@cLojaSN1)
						
						//-- Item da Medicao                                               
						CNRBox(0050,0150,,(cAliasCNE)->CNE_ITEM,.F.,nTipo,oFont06)
						//-- Produto
						CNRBox(0155,0370,'',cProduto,.F.,nTipo,oFont06)
						If lFixo
							//-- Descricao                                            
							CNRBox(0375,1090,'',cDescProd,.F.,nTipo,oFont06)
							//-- Unidade de Medida
							//CNRBox(1015,1090,(cAliasCNE)->CNB_UM,,.F.,nTipo,oFont06)       //AQUI
						Else  
							//-- Descricao                                            
							CNRBox(0375,1090,'',cDescProd,.F.,nTipo,oFont06)
							//-- Unidade de Medida
							//CNRBox(1015,1090,cUM,,.F.,nTipo,oFont06)		
						EndIf
						//-- Valor Unitario
						aVlr := strtokarr(aAux[nX],"=")
						If len(aVlr) > 1
							CNRBox(1095,1300,,Transform(val(aVlr[2]),"@E 999,999,999.99"),.F.,nTipo,oFont06,.T.)
							CNRBox(1305,1500,,Alltrim(aVlr[1]),.F.,nTipo,oFont06)
						Else
							CNRBox(1095,1300,,TransForm(xMoeda((cAliasCNE)->CNE_VLUNIT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNE_VLUNIT")[2]),cPtVLUNIT),.F.,nTipo,oFont06,.T.)
				  		    //Patrimonios                                                                                            
				  			CNRBox(1305,1500,,Alltrim(aAux[nX]),.F.,nTipo,oFont06)
						EndIf
						//loja - se for faturamento por CLIENTE, busca na SN1
			  			If cTpFat == "1"
			  				cLoja := cLojaSN1
			  			EndIf                                                             
			  			cNomeCli := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLoja,"A1_NREDUZ")
			  			CNRBox(1505,1600,,cLoja,.F.,nTipo,oFont06) 
			  			//nome reduzido
			  			CNRBox(1605,2200,,cNomeCli,.F.,nTipo,oFont06)   	
				  			
		  				nLin += 110
		  			EndIf
			  	Next nX

		  	Else 
		  		cPatrimo := SubStr( cPatrimo,1,At("=",cPatrimo)-1 )
		  		RetInfPatr(cPatrimo,@cProduto,@cDescProd,@cLojaSN1)
		  		
				//-- Item da Medicao                                               
				CNRBox(0050,0150,,(cAliasCNE)->CNE_ITEM,.F.,nTipo,oFont06)
				//-- Produto
				CNRBox(0155,0370,'',cProduto,.F.,nTipo,oFont06)
				If lFixo
					//-- Descricao                                            
					CNRBox(0375,1090,'',cDescProd,.F.,nTipo,oFont06)
					//-- Unidade de Medida
					//CNRBox(1015,1090,(cAliasCNE)->CNB_UM,,.F.,nTipo,oFont06)       //AQUI
				Else  
					//-- Descricao                                            
					CNRBox(0375,1090,'',cDescProd,.F.,nTipo,oFont06)
					//-- Unidade de Medida
					//CNRBox(1015,1090,cUM,,.F.,nTipo,oFont06) 			
				EndIf
				//-- Valor Unitario
				CNRBox(1095,1300,,TransForm(xMoeda((cAliasCNE)->CNE_VLUNIT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNE_VLUNIT")[2]),cPtVLUNIT),.F.,nTipo,oFont06,.T.)
	  		    //Patrimonios
	  			CNRBox(1305,1500,,cPatrimo,.F.,nTipo,oFont06)
				//-- Quantidade Solicitada
				//CNRBox(1350,1620,TransForm((cAliasCNE)->CNE_QTDSOL,cPtQTDSOL),,.F.,nTipo,oFont06,.T.)
	  	        //-- Quantidade Acumulada
				//CNRBox(1625,1880,TransForm((cAliasCNE)->CNE_QTDACM,cPtQTMED),,.F.,nTipo,oFont06,.T.)
				//-- Quantidade
				//CNRBox(1885,2145,TransForm((cAliasCNE)->CNE_QUANT,cPtQUANT),,.F.,nTipo,oFont06,.T.)
				//-- Quantidade Total
				//CNRBox(2150,2410,TransForm((cAliasCNE)->CNE_QTDACM+(cAliasCNE)->CNE_QUANT,cPtQTMED),,.F.,nTipo,oFont06,.T.)		
		 		//-- Valor Acumulado
				//CNRBox(2415,2660,TransForm(xMoeda(((cAliasCNE)->CNE_QTDACM*(cAliasCNE)->CNE_VLUNIT),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNB_VLTOT")[2]),cPtCNBTOT),,.F.,nTipo,oFont06,.T.)
				//-- Valor do Periodo
				//CNRBox(2665,2930,TransForm(xMoeda((cAliasCNE)->CNE_VLTOT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNE_VLTOT")[2]),cPtVLTOT),,.F.,nTipo,oFont06,.T.)	
				//-- Valor Total
				//CNRBox(2935,3180,TransForm(xMoeda(((cAliasCNE)->CNE_QTDACM+(cAliasCNE)->CNE_QUANT)*(cAliasCNE)->CNE_VLUNIT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNB_QTDMED")[2]),cPtQTMED),,.T.,nTipo,oFont06,.T.)				

	  			//loja - se for por CLIENTE, busca na SN1
	  			If cTpFat == "1"
	  				cLoja := cLojaSN1
	  			EndIf                                                             
  				cNomeCli := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLoja,"A1_NREDUZ")
	  			CNRBox(1505,1600,,cLoja,.F.,nTipo,oFont06) 
	  			//nome re duzido
	  			CNRBox(1605,2200,,cNomeCli,.F.,nTipo,oFont06)   
	        	nLin += 110
	        EndIf
	        
	        dDtAssi := CN9->CN9_DTASSI
	        
	        // PRO RATA
	 		// Formato do Array aAux2 com TODOS os valores do Pro Rata
			// [x][1] - Tipo - Remocao ou Instalacao [R|I]
			// [x][2] - Patrimonio - Numero do patrimonio
			// [x][3] - Valor - Valor do aluguel do patrimonio
			// [x][4] - Data da remocao/instalacao
			dbSelectArea("CN9")
			cPer1	:=	CTOD(SUBSTR(CN9->CN9_XPCOMP,1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+CND->CND_COMPETE)-1)),3))
			cPer2	:=	CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+CND->CND_COMPETE))),3))
			
			If Select("CNB") <> 0
   				dbSelectArea("CNB")
       			dbGoTo((cAliasCNE)->CNBREC)  
          	EndIf
			If AllTrim(CNB->CNB_XPRORA) <> ""
				aAux := StrToKarr(CNB->CNB_XPRORA,"|")
				// se encontrou somente 1 item no pro rata
				If Len(aAux) == 1                 
					aAux2 := StrtoKarr(aAux[1],",")			
					If CtoD(aAux2[4]) >= cPer1 .And. CtoD(aAux2[4]) <= cPer2
						cDescri1 := AllTrim(aAux2[2])	//adiciona o patrimonio     
						nVlrPatri := Val(aAux2[3])		//adiciona o valor pro rata
						nTotPRata += nVlrPatri			//incrementa o totalizador de valores Pro Rata
						
						RetInfPatr(cDescri1,@cProduto,@cDescProd,@cLojaSN1)
						
						// calculo do valor Pro Rata
						// remocao
						If AllTrim(aAux2[1]) == "R" 
							nQtdDias := cTod(aAux2[4]) - cPer1	// Dia da remocao - dia inicial
							nQtdComp := Val(SUBSTR(CN9->CN9_XPCOMP,4,2)) - Val(SUBSTR(CN9->CN9_XPCOMP,1,2)) +1	// Total Dias do mes
							nVlDia := nVlrPatri / nQtdComp		// Valor da locacao por dia 
							nVlrPatri := nVlDia * nQtdDias		// Valor Pro Rata do patrimonio
							nVlrPatri := Transform(nVlrPatri,"@E 999,999,999.99")
						// instalacao
						ElseIf AllTrim(aAux2[1]) == "I"
							nQtdDias := cPer2 - cTod(aAux2[4])	// Data final - dia da instalacao
							nQtdComp := Val(SUBSTR(CN9->CN9_XPCOMP,4,2)) - Val(SUBSTR(CN9->CN9_XPCOMP,1,2)) +1						// Total de dias do mes
							nVlDia := nVlrPatri / nQtdComp		// Valor da locacao por dia
							nVlrPatri := nVlDia * nQtdDias		// Valor Pro Rata do patrimonio
							nVlrPatri := Transform(nVlrPatri,"@E 999,999,999.99")
						EndIf
						
						//-- Item da Medicao                                               
						CNRBox(0050,0150,,(cAliasCNE)->CNE_ITEM,.F.,nTipo,oFont06)
						
						//-- Produto
						CNRBox(0155,0370,'',cProduto1,.F.,nTipo,oFont06)
			  			
			  			//-- Descricao                                            
						If AllTrim(aAux2[1]) == "R"
							cTxtDescri := "Ref Pro Rata Remo็ใo de patrim๔nio na data: "+aAux2[4]
						ElseIf AllTrim(aAux2[1]) == "I"
							cTxtDescri := "Ref Pro Rata Instala็ใo de patrim๔nio na data: "+aAux2[4]
						EndIf
						CNRBox(0375,1090,cTxtDescri,cDescProd,.F.,nTipo,oFont06)
						
						// Vl Unit
						CNRBox(1095,1300,,nVlrPatri,.F.,nTipo,oFont06,.T.)
			
						//Patrimonios                                                                                            
						CNRBox(1305,1500,,cDescri1,.F.,nTipo,oFont06)
						//loja - se for por CLIENTE, busca na SN1
			  			If cTpFat == "1"
			  				cLoja := cLojaSN1
			  			EndIf                                                             
  						cNomeCli := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLoja,"A1_NREDUZ")
			  			CNRBox(1505,1600,,cLoja,.F.,nTipo,oFont06) 
			  			//nome re duzido
			  			CNRBox(1605,2200,,cNomeCli,.F.,nTipo,oFont06)   
						nLin += 110
					EndIf
				// mais de um item
				Else
					// Passa por cada Pro RAta
					For nI := 1 to Len(aAux)
						aAux2 := StrToKarr(aAux[nI],",")
						If AllTrim(aAux2[2]) <> "" .And. AllTrim(aAux2[3]) <> "" .And. AllTrim(aAux2[4]) <> ""
							If CtoD(aAux2[4]) >= cPer1 .And. CtoD(aAux2[4]) <= cPer2
								cDescri1 := AllTrim(aAux2[2])	//adiciona o patrimonio     
								nVlrPatri := Val(aAux2[3])		//adiciona o valor pro rata
								nTotPrata += nVlrPatri			//incrementa o totalizador de valores Pro Rata
								
								RetInfPatr(cDescri1,@cProduto,@cDescProd,@cLojaSN1)
								
								// calculo do valor Pro Rata
								// remocao
								If AllTrim(aAux2[1]) == "R" 
									nQtdDias := cTod(aAux2[4]) - cPer1	// Dia da remocao - dia inicial
									nQtdComp := Val(SUBSTR(CN9->CN9_XPCOMP,4,2)) - Val(SUBSTR(CN9->CN9_XPCOMP,1,2)) +1						// Total Dias do mes
									nVlDia := nVlrPatri / nQtdComp		// Valor da locacao por dia 
									nVlrPatri := nVlDia * nQtdDias		// Valor Pro Rata do patrimonio
									nVlrPatri := Transform(nVlrPatri,"@E 999,999,999.99")
								// instalacao
								ElseIf AllTrim(aAux2[1]) == "I"
									nQtdDias := cPer2 - cTod(aAux2[4])	// Data final - dia da instalacao
									nQtdComp := Val(SUBSTR(CN9->CN9_XPCOMP,4,2)) - Val(SUBSTR(CN9->CN9_XPCOMP,1,2)) +1						// Total de dias do mes
									nVlDia := nVlrPatri / nQtdComp		// Valor da locacao por dia
									nVlrPatri := nVlDia * nQtdDias		// Valor Pro Rata do patrimonio
									nVlrPatri := Transform(nVlrPatri,"@E 999,999,999.99")
								EndIf
								
								//-- Item da Medicao                                               
								CNRBox(0050,0150,,(cAliasCNE)->CNE_ITEM,.F.,nTipo,oFont06)
								
								//-- Produto
								CNRBox(0155,0370,'',cProduto1,.F.,nTipo,oFont06)
					  			
					  			//-- Descricao                                            
								If AllTrim(aAux2[1]) == "R"
									cTxtDescri := "Ref Pro Rata Remo็ใo de patrim๔nio na data: "+aAux2[4]
								ElseIf	AllTrim(aAux2[1]) == "I"
									cTxtDescri := "Ref Pro Rata Instala็ใo de patrim๔nio na data: "+aAux2[4]
								EndIf
								CNRBox(0375,1090,cTxtDescri,cDescProd,.F.,nTipo,oFont06)
								
								// Vl Unit
								CNRBox(1095,1300,,nVlrPatri,.F.,nTipo,oFont06,.T.)
					
								//Patrimonios                                                                                            
								CNRBox(1305,1500,,cDescri1,.F.,nTipo,oFont06)
								//loja - se for por CLIENTE, busca na SN1
					  			If cTpFat == "1"
					  				cLoja := cLojaSN1
					  			EndIf                                                             
					  			cNomeCli := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLoja,"A1_NREDUZ")
					  			CNRBox(1505,1600,,cLoja,.F.,nTipo,oFont06) 
					  			//nome re duzido
					  			CNRBox(1605,2200,,cNomeCli,.F.,nTipo,oFont06)   
								nLin += 110
							EndIf
						EndIf
					Next nI
				EndIf
			EndIf
        	dbSelectArea(cAliasCNE) 
	        	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Atualiza totalizadores 	       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			nTotAcm += xMoeda((cAliasCNE)->CNE_QTDACM*(cAliasCNE)->CNE_VLUNIT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNE_VLUNIT")[2])
			nTot    += xMoeda(((cAliasCNE)->CNE_QTDACM+(cAliasCNE)->CNE_QUANT)*(cAliasCNE)->CNE_VLUNIT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNE_VLUNIT")[2])
			nBruto  += xMoeda((cAliasCNE)->CNE_VLTOT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNE_VLUNIT")[2])

			//If (nCNETamPrd> 15 .Or. nCNETamDsc> 20) .And. (!Empty(cProduto2).Or.!Empty(cDescri2))
				//nLin += 110 //-- Salta Linha
			//EndIf
	
			(cAliasCNE)->(dbSkip())		
		EndDo
		
		/*
			INICIO DA PARTE DESTINADA PARA RELATORIOS DE INSUMOS REMETIDOS PARA O CLIENTE		
		*/	 
		If (cAliasCND)->CND_NUMERO == "000001"
			If lInsumo
				nBkL := Insumos()
				nLin += 110
				nBkL := Insumosd2()
			Else
				nBkL := nLin	
			EndIf
		Else
			nBkL := nLin
		EndIf
		/*
		  	FINAL DA PARTE DESTINA PARA RELATORIOS DE INSUMOS REMETIDOS PARA O CLIENTE
		*/
		nDescMe := xMoeda((cAliasCND)->CND_DESCME,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CND_DESCME")[2])
		nRetCac := xMoeda((cAliasCND)->CND_RETCAC,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CND_RETCAC")[2])

		//Calcula valor acumulado das multas
		nMultAcm     := xMoeda(CNR040VlMt((cAliasCND)->CND_NUMMED,.T.,(cAliasCND)->CND_CONTRA,(cAliasCND)->CND_REVISA,(cAliasCND)->CND_NUMERO,"1"),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNR_VALOR")[2])
		//Calcula valor total das multas
		nTotMult     := xMoeda(CNR040VlMt((cAliasCND)->CND_NUMMED,.F.,(cAliasCND)->CND_CONTRA,(cAliasCND)->CND_REVISA,(cAliasCND)->CND_NUMERO,"1"),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNR_VALOR")[2])
		//Calcula valor acumulado das multas
		nBonifAcm     := xMoeda(CNR040VlMt((cAliasCND)->CND_NUMMED,.T.,(cAliasCND)->CND_CONTRA,(cAliasCND)->CND_REVISA,(cAliasCND)->CND_NUMERO,"2"),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNR_VALOR")[2])
		//Calcula valor total das multas
		nTotBonif     := xMoeda(CNR040VlMt((cAliasCND)->CND_NUMMED,.F.,(cAliasCND)->CND_CONTRA,(cAliasCND)->CND_REVISA,(cAliasCND)->CND_NUMERO,"2"),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNR_VALOR")[2])
		//Calcula valor acumulado dos descontos
		nDescAcm     := xMoeda(CNR040VlDc((cAliasCND)->CND_NUMMED,.T.),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNQ_VALOR")[2])
		//Calcula valor acumulado da retencao
		nRetAcm      := xMoeda(CNR040VlRet((cAliasCND)->CND_NUMMED),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CND_RETCAC")[2])
		//Calcula valores acumulados
		nBrAcumulado := nTotAcm - nDescAcm - nMultAcm
		nBrMedicao   := nBruto - nDescMe + nTotMult - nTotBonif
		nBrTotal     := nTot - nDescAcm - nDescMe + nTotMult + nMultAcm - nTotBonif - nBonifAcm
	
		aTot[ATOTAL]  := {nTotAcm,nBruto,nTot}//Total
		aTot[ADESCONT]:= {nDescAcm,nDescMe,nDescAcm + nDescMe}//Descontos
		aTot[AMULTAS] := {nMultAcm,nTotMult,nTotMult + nMultAcm}//Multas
		aTot[ABONIF]  := {nBonifAcm,nTotBonif,nTotBonif + nBonifAcm}//Bonifica็๕es
		aTot[AVLBRUT] := {nTotAcm - nDescAcm + nMultAcm - nBonifAcm,nBruto - nDescMe + nTotMult - nTotBonif,nTot - nDescAcm - nDescMe + nTotMult + nMultAcm - nTotBonif - nBonifAcm}//Vl Bruto
		aTot[ARETENC] := {nRetAcm,nRetCac,nRetCac + nRetAcm}//Vl Bruto
		
		dbSelectArea("CN1")
		dbSetOrder(1)
		
		If dbSeek(xFilial("CN1")+CN9->CN9_TPCTO)
			aTotInMO := {((aTot[ATOTAL,1]*CN9->CN9_INSSMO)/100),((aTot[ATOTAL,2]*CN9->CN9_INSSMO)/100),((aTot[ATOTAL,3]*CN9->CN9_INSSMO)/100)}
			aTotInME := {((aTot[ATOTAL,1]*CN9->CN9_INSSME)/100),((aTot[ATOTAL,2]*CN9->CN9_INSSME)/100),((aTot[ATOTAL,3]*CN9->CN9_INSSME)/100)}

			//Impostos
			aTot[AIRRF]   := {((aTot[ATOTAL,1]*CN1->CN1_ALQTIR)/100),((aTot[ATOTAL,2]*CN1->CN1_ALQTIR)/100),((aTot[ATOTAL,3]*CN1->CN1_ALQTIR)/100)}
			aTot[AISS]    := {((aTot[ATOTAL,1]*CN9->CN9_ALCISS)/100),((aTot[ATOTAL,2]*CN9->CN9_ALCISS)/100),((aTot[ATOTAL,3]*CN9->CN9_ALCISS)/100)}
			aTot[APIS]    := {((aTot[ATOTAL,1]*CN1->CN1_ALQPIS)/100),((aTot[ATOTAL,2]*CN1->CN1_ALQPIS)/100),((aTot[ATOTAL,3]*CN1->CN1_ALQPIS)/100)}
			aTot[ACOFIN]  := {((aTot[ATOTAL,1]*CN1->CN1_ALCOFI)/100),((aTot[ATOTAL,2]*CN1->CN1_ALCOFI)/100),((aTot[ATOTAL,3]*CN1->CN1_ALCOFI)/100)}
			aTot[ACSLL]   := {((aTot[ATOTAL,1]*CN1->CN1_ALCSLL)/100),((aTot[ATOTAL,2]*CN1->CN1_ALCSLL)/100),((aTot[ATOTAL,3]*CN1->CN1_ALCSLL)/100)}
			aTot[AINSS]   := {((aTotInMO[1]*CN1->CN1_ALINSS)/100),((aTotInMO[2]*CN1->CN1_ALINSS)/100),((aTotInMO[3]*CN1->CN1_ALINSS)/100)}
			aTot[AVLLIQ]  := {aTot[AVLBRUT,1],aTot[AVLBRUT,2],aTot[AVLBRUT,3]}
		EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Calculo valor liquido    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For nx:=ARETENC to ACSLL
			aTot[AVLLIQ,1] -= aTot[nx,1]
			aTot[AVLLIQ,2] -= aTot[nx,2]
			aTot[AVLLIQ,3] -= aTot[nx,3]
		Next

		If nLin+600 >= 2350
			nLin := 2350
			CNRCabec(Nil,Nil,cTitRel,,.T.) //-- Impressao do Cabecalho da pagina
		EndIf		

		If (nCNETamPrd> 15 .Or. nCNETamDsc> 20) .And. (!Empty(SubStr((cAliasCNE)->CNE_PRODUT,16,nCNETamPrd)).Or.!Empty(SubStr(cDescri,21,nCNETamDsc)))
			nLin += 150 //-- Salta Linha
		Else
			nLin    += 50
		EndIf
		nLin :=  nBkL // aqui
		nLinBck := nLin
	
		CNRBox(2415,2930,"Total Loca็ใo",,.F.,2,oFont06)//Total da medicao
		//CNRBox(2415,2660,TransForm(aTot[ATOTAL,1],cPtVLTOT1),,.F.,2,oFont06,.T.)
		//CNRBox(2665,2930,TransForm(aTot[ATOTAL,2],cPtVLTOT1),,.F.,2,oFont06,.T.)
		CNRBox(2935,3180,TransForm(nTotMed,cPtVLTOT1),,.T.,2,oFont06,.T.)

		CNRBox(2415,2930,STR0038,,.F.,2,oFont06)//Descontos
		//CNRBox(2415,2660,TransForm(aTot[ADESCONT,1],cPtDESC),,.F.,2,oFont06,.T.)
		//CNRBox(2665,2930,TransForm(aTot[ADESCONT,2],cPtDESC),,.F.,2,oFont06,.T.)
		CNRBox(2935,3180,TransForm(aTot[ADESCONT,3],cPtDESC),,.T.,2,oFont06,.T.)

		CNRBox(2415,2930,STR0039,,.F.,2,oFont06)//"Multas"
		//CNRBox(2415,2660,TransForm(aTot[AMULTAS,1],cPtMULT),,.F.,2,oFont06,.T.)	
		//CNRBox(2665,2930,TransForm(aTot[AMULTAS,2],cPtMULT),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[AMULTAS,3],cPtMULT),,.T.,2,oFont06,.T.)
		
		CNRBox(2415,2930,STR0011,,.F.,2,oFont06)//"Bonifica็๕es"
		//CNRBox(2415,2660,TransForm(aTot[ABONIF,1],cPtMULT),,.F.,2,oFont06,.T.)	
		//CNRBox(2665,2930,TransForm(aTot[ABONIF,2],cPtMULT),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[ABONIF,3],cPtMULT),,.T.,2,oFont06,.T.)	
	   
		CNRBox(2415,2930,"Pro-Rata",,.F.,2,oFont06)//"Pro-Rata"
		//CNRBox(2415,2660,TransForm(nTotPRata,cPtRETC),,.F.,2,oFont06,.T.)	
		//CNRBox(2665,2930,TransForm(aTot[ARETENC,2],cPtRETC),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(nTotPRata,cPtRETC),,.T.,2,oFont06,.T.)	
	
		CNRBox(2415,2930,"Sub-Total",,.F.,2,oFont06)//"Vl Bruto/Sub-Total"
		//CNRBox(2415,2660,TransForm(aTot[AVLBRUT,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		//CNRBox(2665,2930,TransForm(aTot[AVLBRUT,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[AVLBRUT,3],cPtVLTOT1),,.T.,2,oFont06,.T.)

		nLin+=30	


		CNRBox(2415,2930,"Insumos",,.F.,2,oFont06)//"Insumos"
		//CNRBox(2415,2660,TransForm(nTotInsumo,cPtVLTOT1),,.F.,2,oFont06,.T.)	
		//CNRBox(2665,2930,TransForm(aTot[AIRRF,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(nTotInsumo,cPtVLTOT1),,.T.,2,oFont06,.T.)	
        
		CNRBox(2415,2930,"Vl Liq.",,.F.,2,oFont06)//"Vl. Liq."
		//CNRBox(2415,2660,TransForm(aTot[AVLLIQ,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		//CNRBox(2665,2930,TransForm(aTot[AVLLIQ,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(nTotfat,cPtVLTOT1),,.T.,2,oFont06,.T.)	
		
		//CNRBox(1885,2410,STR0043,,.F.,2,oFont06)//"ISS"
		//CNRBox(2415,2660,TransForm(aTot[AISS,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		//CNRBox(2665,2930,TransForm(aTot[AISS,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		//CNRBox(2935,3180,TransForm(aTot[AISS,3],cPtVLTOT1),,.T.,2,oFont06,.T.)	
        /*
		CNRBox(1885,2410,STR0044,,.F.,2,oFont06)//"INSS"
		CNRBox(2415,2660,TransForm(aTot[AINSS,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[AINSS,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[AINSS,3],cPtVLTOT1),,.T.,2,oFont06,.T.)	

		CNRBox(1885,2410,STR0066,,.F.,2,oFont06)//"PIS"
		CNRBox(2415,2660,TransForm(aTot[APIS,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[APIS,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[APIS,3],cPtVLTOT1),,.T.,2,oFont06,.T.)	

		CNRBox(1885,2410,STR0067,,.F.,2,oFont06)//"COFINS"
		CNRBox(2415,2660,TransForm(aTot[ACOFIN,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[ACOFIN,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[ACOFIN,3],cPtVLTOT1),,.T.,2,oFont06,.T.)	
		
		CNRBox(1885,2410,STR0068,,.F.,2,oFont06)//"CSLL"
		CNRBox(2415,2660,TransForm(aTot[ACSLL,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[ACSLL,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[ACSLL,3],cPtVLTOT1),,.T.,2,oFont06,.T.)	
        */
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Finaliza a consulta aos itens ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		(cAliasCNE)->(dbCloseArea())	
	EndIf

	nLin := 2350 //-- Forca a Quebra da pagina por Medicao
   
	// Impressao do Resumo para faturamento
	If lResumo
		ExecBlock("CNR040RES",.F.,.F.,{(cAliasCND)->CND_CONTRA,(cAliasCND)->CND_NUMMED,(cAliasCND)->CND_FORNEC,(cAliasCND)->CND_LJFORN,cDescri,aTot[AISS][2],aTot[AINSS][2],aTot[ATOTAL,2],aTot[AIRRF,2],aTot[APIS,2],aTot[ACOFIN,2],aTot[ACSLL,2],aTotInMO[2],aTotInME[2]})
	EndIf

	(cAliasCND)->(dbSkip())
	
EndDo

(cAliasCND)->(dbCloseArea())

//-- Grava Imagem em Disco
If !Empty(cDirSpool)
	oPrint:SaveAllAsJPEG(cDirSpool+"TTCNTR040",875,1170,140)
EndIF
                                                        
//-- Visualiza antes de Imprimir
oPrint:Preview()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |CNTR040   บAutor  ณMarcelo Custodio    บ Data ณ  23/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTotaliza valores da retencao                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcNumMed    - Codigo da medicao                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR040                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CNR040VlRet(cNumMed)
Local cQuery := ""
Local cAlias := GetNextAlias()
Local aArea  := GetArea()
Local nTot   := 0

dbSelectArea("CND")
dbSetOrder(4)

If dbSeek(xFilial("CND")+cNumMed)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Seleciona as medicoes para calculo dos valores retidos   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := "SELECT SUM(CND.CND_RETCAC) AS TOTRET "
	cQuery += "  FROM "+RetSQLName("CND")+" CND "
	cQuery += " WHERE CND.CND_FILIAL = '"+xFilial("CND")+"'"
	cQuery += "   AND CND.CND_NUMMED < '"+CND->CND_NUMMED+"'"
	cQuery += "   AND CND.CND_CONTRA = '"+CND->CND_CONTRA+"'"
	cQuery += "   AND CND.CND_REVISA = '"+CND->CND_REVISA+"'"
	cQuery += "   AND CND.CND_NUMERO = '"+CND->CND_NUMERO+"'"
	cQuery += "   AND CND.D_E_L_E_T_ = ' '"

	cAlias := GetNextAlias()
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza estrutura do total   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	TCSetField(cAlias,"TOTRET", "N",TamSx3("CND_RETCAC")[1],TamSx3("CND_RETCAC")[2])
	
	nTot := (cAlias)->TOTRET
	
	(cAlias)->(dbCloseArea())

EndIf

RestArea(aArea)

Return nTot

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |CNTR040   บAutor  ณMarcelo Custodio    บ Data ณ  23/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTotaliza valores das multas                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcNumMed    - Codigo da medicao                              บฑฑ
ฑฑบ          ณlAcumulado - Informa se busca as medicoes anteriores        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR040                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CNR040VlMt(cNumMed,lAcumulado,cContra,cRevisa,cNumero,cTipo)
Local cQuery     := ""
Local cAlias    := GetNextAlias()
Local aArea     := GetArea()
Local nTot      := 0  
Local lCtMulBoni:= !Empty( CNR->( FieldPos( "CNR_CONTRA" ) ) )

Default cTipo := "1" 

dbSelectArea("CND")
dbSetOrder(1)

If dbSeek(xFilial("CND")+cContra+cRevisa+cNumero+cNumMed)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Seleciona as medicoes para calculo das multas    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := "SELECT CNR.CNR_VALOR AS TOTMULT, CNR.CNR_TIPO " 
	If lCtMulBoni
		cQuery += ", CNR.CNR_CONTRA "
	EndIf
	cQuery += "  FROM "+RetSQLName("CNR")+" CNR, "+RetSQLName("CND")+" CND"
	cQuery += " WHERE CNR.CNR_FILIAL = '"+xFilial("CNR")+"'"
	cQuery += "   AND CNR.CNR_TIPO = '"+cTipo+"'"
	cQuery += "   AND CND.CND_FILIAL = '"+xFilial("CND")+"'"
	cQuery += "   AND CNR.CNR_NUMMED = CND.CND_NUMMED"      
	cQuery += "   AND "
	If lAcumulado
		cQuery += " CND.CND_NUMMED < '"+ CND->CND_NUMMED +"' AND "//Busca as medicoes anteriores
	Else
		cQuery += " CND.CND_NUMMED = '"+CND->CND_NUMMED+"' AND "//Busca medicao atual
	EndIf
	cQuery += "      CND.CND_CONTRA = '"+CND->CND_CONTRA+"'"
	cQuery += "  AND CND.CND_REVISA = '"+CND->CND_REVISA+"'"
	cQuery += "  AND CND.CND_NUMERO = '"+CND->CND_NUMERO+"'"
	cQuery += "  AND CND.D_E_L_E_T_ = ' '"
	cQuery += "  AND CNR.D_E_L_E_T_ = ' '"

	cAlias := GetNextAlias()
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza estrutura do total   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	TCSetField(cAlias,"TOTMULT", "N",TamSx3("CNR_VALOR")[1],TamSx3("CNR_VALOR")[2])
	
	While !( cAlias )->( Eof() ) 
		If lCtMulBoni
			If !Empty(( cAlias )->CNR_CONTRA) .And. (( cAlias )->CNR_CONTRA) <> CND->CND_CONTRA 
				( cAlias )->( dbSkip() )
				Loop  
			EndIf
		EndIf

		nTot += (cAlias)->TOTMULT
		
		( cAlias )->( dbSkip() )
	EndDo
	
	
	(cAlias)->(dbCloseArea())

EndIf

RestArea(aArea)

Return nTot

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |CNTR040   บAutor  ณMarcelo Custodio    บ Data ณ  23/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTotaliza valores dos descontos                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcNumMed    - Codigo da medicao                              บฑฑ
ฑฑบ          ณlAcumulado - Informa se busca as medicoes anteriores        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR040                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CNR040VlDc(cNumMed,lAcumulado)
Local cQuery := ""
Local cAlias := GetNextAlias()
Local aArea  := GetArea()
Local nTot   := 0

dbSelectArea("CND")
dbSetOrder(4)

If dbSeek(xFilial("CND")+cNumMed)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Seleciona as medicoes para calculo dos descontos ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := "SELECT SUM(CNQ.CNQ_VALOR) AS TOTDESC "
	cQuery += "  FROM "+RetSQLName("CNQ")+" CNQ, "+RetSQLName("CND")+" CND "
	cQuery += " WHERE CNQ.CNQ_FILIAL = '"+xFilial("CNQ")+"'"
	cQuery += "   AND CND.CND_FILIAL = '"+xFilial("CND")+"'"
	cQuery += "   AND CNQ.CNQ_NUMMED = CND.CND_NUMMED"   
	cQuery += "   AND CNQ.CNQ_CONTRA = CND.CND_CONTRA"
	cQuery += "   AND "
	If lAcumulado
		cQuery += "  CND.CND_NUMMED < '"+ CND->CND_NUMMED +"' AND "//Busca as medicoes anteriores
	Else
		cQuery += "  CND.CND_NUMMED = '"+CND->CND_NUMMED+"' AND "//Busca a medicao atual
	EndIf
	cQuery += "      CND.CND_CONTRA = '"+CND->CND_CONTRA+"'"
	cQuery += "  AND CND.CND_REVISA = '"+CND->CND_REVISA+"'"
	cQuery += "  AND CND.CND_NUMERO = '"+CND->CND_NUMERO+"'"
	cQuery += "  AND CND.D_E_L_E_T_ = ' '"
	cQuery += "  AND CNQ.D_E_L_E_T_ = ' '"

	cAlias := GetNextAlias()
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza estrutura do total   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
	TCSetField(cAlias,"TOTDESC", "N",TamSx3("CNQ_VALOR")[1],TamSx3("CNQ_VALOR")[2])
	
	nTot := (cAlias)->TOTDESC
	
	(cAlias)->(dbCloseArea())

EndIf

RestArea(aArea)

Return nTot

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณCNR040ClFrณ Autor ณ Aline Sebrian         ณ Data ณ 11.04.11 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณValida os parametro do Cliente e Fornecedor no relatorio.   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณCNR040ClFr()                                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณCNR040ClFr()                                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function CNR040ClFr(cTipo)
Local aSaveArea	:= GetArea()

If cTipo=="1"    
	If !Empty(mv_par09) .Or. (!Empty(mv_par10) .And. UPPER(mv_par10) != REPLICATE("Z",TamSx3("A2_COD")[1]))
		MV_PAR15	:= Space(6)
		MV_PAR16	:= REPLICATE("Z",TamSx3("A1_COD")[1])	 
	EndIf
Else
	If !Empty(mv_par15) .Or. (!Empty(mv_par16) .And. UPPER(mv_par16) != REPLICATE("Z",TamSx3("A1_COD")[1]))
		MV_PAR09	:= Space(6)
		MV_PAR10	:= REPLICATE("Z",TamSx3("A2_COD")[1])    
	EndIf
EndIf   

	    
RestArea(aSaveArea)

Return    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCNTR040 บAutor  ณAlexandre Venancio  บ Data ณ  08/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relacao de insumos enviados para o cliente que devem ser   บฑฑ
ฑฑบ          ณcobrados junto com as locacoes                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Insumos()
      
Local aArea	:=	GetArea()
Local cQuery
Local nBkl	:=	nLin
Local cPer1	:=	CTOD(SUBSTR(CN9->CN9_XPCOMP,1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+(cAliasCND)->CND_COMPETE)-1)),3))
Local nTot	:=	0
Local nQtd	:=	0
Local nSub	:=	0
Local nQSb	:=	0
Local cArm	:=	''

cQuery := "SELECT D3_COD,B1_DESC,D3_LOCAL,ZZ1_DESCRI,SUM(D3_QUANT) AS QTD,SUM(D2_TOTAL) AS VALOR"
cQuery += " FROM "+RetSQLName("SD3")+" D3"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=D3_COD AND B1.D_E_L_E_T_='' AND B1_XSECAO='007'"
cQuery += " INNER JOIN "+RetSQLName("ZZ1")+" Z1 ON ZZ1_COD=D3_LOCAL AND Z1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=D3_FILIAL AND D2_DOC=D3_XNUMNF AND D2_SERIE=D3_XSERINF AND D2_ITEM=D3_XITEMNF AND D2.D_E_L_E_T_=''"
cQuery += " AND D2_TES IN(SELECT F4_CODIGO FROM " +RetSqlName("SF4") +" SF4 "
cQuery += "             WHERE F4_FILIAL='01' AND (F4_FINALID LIKE 'REM%' AND F4_FINALID LIKE '%FUTU%') AND D_E_L_E_T_='') "

cQuery += " WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_EMISSAO BETWEEN '"+dtos(cPer1)+"' AND '"+dtos(cPer1+30)+"' "  

If CN9->CN9_XTPFAT != '1'
	cQuery += " AND D3_LOCAL IN(SELECT ZZ1_COD FROM "+RetSQLName("ZZ1")+" WHERE SUBSTRING(ZZ1_ITCONT,1,10)='"+CN9->CN9_CLIENTE+CN9->CN9_LOJACL+"' AND D_E_L_E_T_='')"
Else
	cQuery += " AND D3_LOCAL IN(SELECT ZZ1_COD FROM "+RetSQLName("ZZ1")+" WHERE SUBSTRING(ZZ1_ITCONT,1,6)='"+CN9->CN9_CLIENTE+"' AND D_E_L_E_T_='')"
EndIf

cQuery += " AND D3.D_E_L_E_T_=''"
cQuery += " GROUP BY D3_COD,B1_DESC,D3_LOCAL,ZZ1_DESCRI"
cQuery += " ORDER BY D3_LOCAL"
 

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTCNTR040_D3.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

cArm	:=	TRB->D3_LOCAL

If !Empty(cArm)
	CNRBox(0050,0160,STR0026,,.F.,2,oFont06)	//"Produto"
	CNRBox(0165,0900,STR0027,,.F.,2,oFont06)	//"Descri็ใo"
	CNRBox(0910,1020,"Armazem",,.F.,2,oFont06)	//   ARMAZEM
	CNRBox(1025,1500,STR0027,,.F.,2,oFont06)	//"Descri็ใo arm"
	CNRBox(1505,1620,"Qtde.",,.F.,2,oFont06)	//qtd
	CNRBox(1625,1760,"Valor",,.F.,2,oFont06)	//"Vl. Unit."
	nLin += 055
	
	While !EOF()
		If nLin >= 2350
			CNRCabec(Nil,Nil,cTitRel,,.T.) //-- Impressao do Cabecalho da pagina
		EndIf   
	    If cArm <> TRB->D3_LOCAL
		    CNRBox(0050,0160,'',,.F.,5,oFont06)	//"Produto"
			CNRBox(0165,0900,'Sub-Total',,.F.,5,oFont06)	//"Descri็ใo"   
			CNRBox(0910,1020,'',,.F.,5,oFont06)	//
			CNRBox(1025,1500,'',,.F.,5,oFont06)	//"Descri็ใo arm"
			
			CNRBox(1505,1620,Transform(nQSb,"@E 999,999"),,.F.,5,oFont06)	//qtd
			CNRBox(1625,1760,Transform(nSub,"@E 999,999.99"),,.F.,5,oFont06)	//"Vl. Unit." 
			nQSb	:=	0//TRB->QTD
			nSub	:=	0//TRB->VALOR 
			cArm	:=	TRB->D3_LOCAL
			nLin += 055	
		EndIf
	
			CNRBox(0050,0160,TRB->D3_COD,,.F.,5,oFont06)	//"Produto"
			CNRBox(0165,0900,TRB->B1_DESC,,.F.,5,oFont06)	//"Descri็ใo"
			CNRBox(0910,1020,TRB->D3_LOCAL,,.F.,5,oFont06)	//
			CNRBox(1025,1500,TRB->ZZ1_DESCRI,,.F.,5,oFont06)	//"Descri็ใo arm"
			CNRBox(1505,1620,Transform(TRB->QTD,"@E 999,999"),,.F.,5,oFont06)	//qtd
			CNRBox(1625,1760,Transform(TRB->VALOR,"@E 999,999.99"),,.F.,5,oFont06)	//"Vl. Unit." 
			nTot	+=	TRB->VALOR
			nQtd	+=	TRB->QTD 
			nQSb	+=	TRB->QTD
			nSub	+=	TRB->VALOR
	
	
		nLin += 055
		DbSkip()
	EndDo                                   
	
	//nTotInsumo := nTot
		
	CNRBox(0050,0160,'',,.F.,5,oFont06)	//"Produto"
	CNRBox(0165,0900,'Totais',,.F.,5,oFont06)	//"Descri็ใo"   
	CNRBox(0910,1020,'',,.F.,5,oFont06)	//
	CNRBox(1025,1500,'',,.F.,5,oFont06)	//"Descri็ใo arm"
	
	CNRBox(1505,1620,Transform(nQtd,"@E 999,999"),,.F.,5,oFont06)	//qtd
	CNRBox(1625,1760,Transform(nTot,"@E 999,999.99"),,.F.,5,oFont06)	//"Vl. Unit." 

EndIf
			
RestArea(aArea)

Return(nBkl)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCNTR040 บAutor  ณMicrosiga           บ Data ณ  08/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ftotInsumo()

Local cQuery := ""
Local cPer1	:=	CTOD(SUBSTR(CN9->CN9_XPCOMP,1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+(cAliasCND)->CND_COMPETE)-1)),3))

nTotInsumo := 0

cQuery := "SELECT SUM(D2_TOTAL) AS VALOR"
cQuery += " FROM "+RetSQLName("SD3")+" D3"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=D3_COD AND B1.D_E_L_E_T_='' AND B1_XSECAO='007'"
cQuery += " INNER JOIN "+RetSQLName("ZZ1")+" Z1 ON ZZ1_COD=D3_LOCAL AND Z1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=D3_FILIAL AND D2_DOC=D3_XNUMNF AND D2_SERIE=D3_XSERINF AND D2_ITEM=D3_XITEMNF AND D2.D_E_L_E_T_=''"
cQuery += " WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_EMISSAO BETWEEN '"+DTOS(cPer1)+"' AND '"+DTOS(cPer1+30)+"' "  

If CN9->CN9_XTPFAT != '1'
	cQuery += " AND D3_LOCAL IN(SELECT ZZ1_COD FROM "+RetSQLName("ZZ1")+" WHERE SUBSTRING(ZZ1_ITCONT,1,10)='"+CN9->CN9_CLIENTE+CN9->CN9_LOJACL+"' AND D_E_L_E_T_='')"
Else
cQuery += " AND D3_LOCAL IN(SELECT ZZ1_COD FROM "+RetSQLName("ZZ1")+" WHERE SUBSTRING(ZZ1_ITCONT,1,6)='"+CN9->CN9_CLIENTE+"' AND D_E_L_E_T_='')"	
EndIf

cQuery += " AND D3.D_E_L_E_T_=''"
cQuery += " GROUP BY D3_COD,B1_DESC,D3_LOCAL,ZZ1_DESCRI"
cQuery += " ORDER BY D3_LOCAL"

If Select("TOTINSUMO") > 0
	dbSelectArea("TOTINSUMO")
	dbCloseArea()
EndIf
  
MemoWrite("TTCNTR040_TOTINSUMO.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TOTINSUMO',.F.,.T.)   

DbSelectArea("TOTINSUMO")

While !EOF()
	nTotInsumo += TOTINSUMO->VALOR
	DbSkip()
EndDo                                   


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCNTR040 บAutor  ณMicrosiga           บ Data ณ  08/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function insumosd2()

Local aArea	:=	GetArea()
Local nBkl	:=	nlin
Local cQuery
Local cPer1	:=	CTOD(SUBSTR(CN9->CN9_XPCOMP,1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+(cAliasCND)->CND_COMPETE)-1)),3))
Local nTot	:=	0
Local nQtd	:=	0
Local nSub	:=	0
Local nQSb	:=	0
Local cArm	:=	''

cQuery := "SELECT D2_COD,B1_DESC,SUM(D2_QUANT) AS QTD,SUM(D2_TOTAL) AS VALOR"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=D2_COD AND B1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_FILIAL=D2_FILIAL AND F4_CODIGO=D2_TES AND F4.D_E_L_E_T_=''"
cQuery += " WHERE D2_FILIAL='"+xFilial("SD2")+"' AND D2_CLIENTE='"+CN9->CN9_CLIENTE+"' AND D2_EMISSAO BETWEEN '"+dtos(cPer1)+"' AND '"+dtos(cPer1+30)+"'"
cQuery += " AND D2_TES IN(SELECT F4_CODIGO FROM "+RetSQLName("SF4")+" WHERE F4_FILIAL='"+xFilial("SF4")+"' AND F4_FINALID LIKE 'REM%' AND D_E_L_E_T_='')"
cQuery += " AND D2.D_E_L_E_T_='' AND D2_TES NOT IN('781')"
cQuery += " GROUP BY D2_COD,B1_DESC"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTCNTR040_D2.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

If !Empty(TRB->D2_COD)
	CNRBox(0050,0160,STR0026,,.F.,2,oFont06)	//"Produto"
	CNRBox(0165,0900,STR0027,,.F.,2,oFont06)	//"Descri็ใo"
	//CNRBox(0910,1020,"Armazem",,.F.,2,oFont06)	//   ARMAZEM
	//CNRBox(1025,1500,STR0027,,.F.,2,oFont06)	//"Descri็ใo arm"
	//CNRBox(1505,1620,"Qtde.",,.F.,2,oFont06)	//qtd
	//CNRBox(1625,1760,"Valor",,.F.,2,oFont06)	//"Vl. Unit."
	CNRBox(0905,1010,"Qtde.",,.F.,2,oFont06)	//qtd
	CNRBox(1015,1130,"Valor",,.F.,2,oFont06)	//"Vl. Unit."
	
	nLin += 055
	
	//cArm	:=	TRB->D3_LOCAL
	
	While !EOF()
		If nLin >= 2350
			CNRCabec(Nil,Nil,cTitRel,,.T.) //-- Impressao do Cabecalho da pagina
		EndIf   
	  /*  If cArm <> TRB->D3_LOCAL
		    CNRBox(0050,0160,'',,.F.,5,oFont06)	//"Produto"
			CNRBox(0165,0900,'Sub-Total',,.F.,5,oFont06)	//"Descri็ใo"   
			CNRBox(0910,1020,'',,.F.,5,oFont06)	//
			CNRBox(1025,1500,'',,.F.,5,oFont06)	//"Descri็ใo arm"
			
			CNRBox(1505,1620,Transform(nQSb,"@E 999,999"),,.F.,5,oFont06)	//qtd
			CNRBox(1625,1760,Transform(nSub,"@E 999,999.99"),,.F.,5,oFont06)	//"Vl. Unit." 
			nQSb	:=	0
			nSub	:=	0
			cArm	:=	TRB->D3_LOCAL
			nLin += 055	
		EndIf */
	
			CNRBox(0050,0160,TRB->D2_COD,,.F.,5,oFont06)	//"Produto"
			CNRBox(0165,0900,TRB->B1_DESC,,.F.,5,oFont06)	//"Descri็ใo"
			//CNRBox(0910,1020,TRB->D3_LOCAL,,.F.,5,oFont06)	//
			//CNRBox(1025,1500,TRB->ZZ1_DESCRI,,.F.,5,oFont06)	//"Descri็ใo arm"
			//CNRBox(1505,1620,Transform(TRB->QTD,"@E 999,999"),,.F.,5,oFont06)	//qtd
			//CNRBox(1625,1760,Transform(TRB->VALOR,"@E 999,999.99"),,.F.,5,oFont06)	//"Vl. Unit." 
			CNRBox(0905,1010,Transform(TRB->QTD,"@E 999,999"),,.F.,5,oFont06)	//qtd
			CNRBox(1015,1130,Transform(TRB->VALOR,"@E 999,999.99"),,.F.,5,oFont06)	//"Vl. Unit."
	
			nTot	+=	TRB->VALOR
			nQtd	+=	TRB->QTD 
			nQSb	+=	TRB->QTD
			nSub	+=	TRB->VALOR
	
	
		nLin += 055
		DbSkip()
	EndDo                                   
	
	CNRBox(0050,0160,'',,.F.,5,oFont06)	//"Produto"
	CNRBox(0165,0900,'Totais',,.F.,5,oFont06)	//"Descri็ใo"   
	//CNRBox(0910,1020,'',,.F.,5,oFont06)	//
	//CNRBox(1025,1500,'',,.F.,5,oFont06)	//"Descri็ใo arm"
	
	//CNRBox(1505,1620,Transform(nQtd,"@E 999,999"),,.F.,5,oFont06)	//qtd
	//CNRBox(1625,1760,Transform(nTot,"@E 999,999.99"),,.F.,5,oFont06)	//"Vl. Unit." 
	CNRBox(0905,1010,Transform(nQtd,"@E 999,999"),,.F.,5,oFont06)	//qtd
	CNRBox(1015,1130,Transform(nTot,"@E 999,999.99"),,.F.,5,oFont06)	//"Vl. Unit." 

EndIf	

RestArea(aArea)

Return(nBkl)


//Busca informacoes do patrimonio
Static Function RetInfPatr(cNumChapa,cProduto,cDescProd,cLoja)

Local cQuery

cQuery := "SELECT N1_PRODUTO, N1_DESCRIC, N1_XLOJA FROM " +RetSqlName("SN1") + " SN1 "
cQuery += "WHERE N1_CHAPA = '"+cNumChapa+"' AND D_E_L_E_T_ = '' "

If Select("TRBSN1") > 0
	TRBSN1->(dbCloseArea())
EndIf                     

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBSN1',.F.,.T.)   

dbSelectArea("TRBSN1")

cProduto := TRBSN1->N1_PRODUTO
cDescProd := TRBSN1->N1_DESCRIC
cLoja := TRBSN1->N1_XLOJA

dbCloseArea()


Return                                            