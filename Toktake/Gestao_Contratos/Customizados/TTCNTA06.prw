#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTA06  ºAutor  ³Jackson E. de Deus  º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Reajusta os valores dos patrimonios dos contratos.          º±±
±±º          ³CNA - Planilhas											  º±±
±±º          ³CNB - Itens das planilhas									  º±±
±±º          ³CN9 - Contrato											  º±±
±±º          ³CNF - Cronograma fisico									  º±±
±±º          ³SE1 - Titulos a receber									  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TTCNTA06(cEmp, cFil)

Local oDlg
Local nOpca			:= 0
Local cPerg			:= "TTCNTA06"
Private aContr		:= {}	//array usado no tcbrowse da tela dos contratos
Private aPatrim		:= {}	//array usado para guardar os patrimonios da tela dos patrimonios
Private aPatrim2	:= {}	//array usado para mostrar os patrimonios na tela dos patrimonios
Private aIndices	:= {}	//array usado para guardar o historico dos indices de cada contrato
Private lEnd		:= .F.
Private lJob		:= .F.	//controla execucao do programa - via tela ou via job
Private lGravou		:= .F.
Private cTpReajuste := ""
Private cTpCalc 	:= ""
Private cMsgIndice	:= "Não existem indices cadastrados para o período selecionado." +CRLF +"Cadastre os indices em Histórico de Indices."
Private cQueryOri	:= ""

Default cEmp		:= "01"
Default cFil		:= "01"

If cEmpAnt == "01"
	
	// verifica se a execucao foi feita via Job                 
	If Empty(FunName())
		lJob := .T.
		ConOut("## Iniciando rotina de reajuste de contratos.. ##")
	EndIf
	
	If !FindFunction("U_TTCNTA09")
		If !lJob
			Aviso("TTCNTA06","Função U_TTCNTA09 não compilada no repositório." +CRLF +"Essa função é necessária para a atualização do cronograma financeiro e títulos provisórios.",{"Ok"})
			Return
		Else
			ConOut("## TTCNTA06 - Função U_TTCNTA09 não compilada no repositório. ##")
			Return
		EndIf
	EndIf
	                        
	If !lJob
		AjustaSx1(cPerg)  
		DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Reajuste") PIXEL
			@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
			@ 29, 15 SAY OemToAnsi("Este programa permite o reajuste dos contratos.") SIZE 268, 8 OF oDlg PIXEL		//"Este programa permite o reajuste dos contratos."
			@ 38, 15 SAY OemToAnsi("Todos os contratos serao reajustados.") SIZE 268, 8 OF oDlg PIXEL    			//"Todos os contratos serao reajustados."
			@ 48, 15 SAY OemToAnsi("Configure os parametros..") SIZE 268, 8 OF oDlg PIXEL							//"Configure os parametros.."
			DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte("TTCNTA06",.T.) ENABLE OF oDlg
			DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
			DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg CENTER
		
		If nOpca == 1
			If mv_par01 <> ""
				MsAguarde({ || Dados()},"Verificando contratos, aguarde..")
				If Len(aContr) == 0
					Aviso("TTCNTA06","Não existem contratos para os parâmetros informados.", {"Ok"}) 
					Return
				EndIf
				If mv_par08 == 1
					If Len(aIndices) == 0
						Aviso("TTCNTA06",cMsgIndice,{"Ok"})
						Return
					EndIf
				EndIf
				Tela()
			EndIf
		EndIf
	//Execucao via Job	
	Else
		ConOut("# TTCNTA06 -> Iniciando empresa "+cEmp +" Filial " +cFil +" #")
		RpcSetType(3)
		RpcSetEnv(cEmp,cFil)
	    
		mv_par01 := Space(TamSx3("CN9_NUMERO")[1])			// contrato de
		mv_par02 := Replicate("Z",TamSx3("CN9_NUMERO")[1])	// contrato ate
		mv_par03 := CtoD("  /  /  ")						// data inicial considerada para calcular o indice - mes/ano de inicio da vigencia do contrato
		mv_par04 := dDatabase								// data final considerada para calcular o indice - mes/ano atual
		mv_par05 := 1										// tipo de reajuste - Aumento
		mv_par06 := 1										// tipo de calculo (percentual ou valor) - nesse caso, por percentual do indice do contrato
		mv_par07 := ctod("  /  /  ")						// data de inicio da vigencia dos contratos
		mv_par08 := 1										// considera INDICE para o calculo
		mv_par09 := 0										// valor para calculo
			
		cTpReajuste := "Aumento"
		cTpCalc := "Percentual"
		
		ConOut("# TTCNTA06 -> Carregando contratos.. #")
		Dados()
		If Len(aContr) > 0 .And. Len(aIndices) > 0
			Ajusta()
		EndIf
		RpcClearEnv()
	EndIf
EndIf


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tela ºAutor ³Jackson E. de Deus        º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mostra a tela principal                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Tela()

Local oDlg1
Local cTitulo		:= "Reajuste de Contratos"
Local aArea			:= GetArea()
Local aDimension	:= MsAdvSize()
Local aObjSize		:= Array(0)
Local oOk			:= LoadBitMap(GetResources(), "BR_VERDE")		// PROCESSADO OK
Local oNo			:= LoadBitMap(GetResources(), "BR_VERMELHO")	// NAO PROCESSADO
Local oAlt			:= LoadBitMap(GetResources(), "BR_AMARELO")		// ALTERADO (houve patrimonio desmarcado)     
Local aInfo 		:= Array(0)
Local aObjects		:= Array(0)             
Local aPosObj		:= Array(0)
Private oFont		:= TFont():New('Arial',,-12,.T.,.T.)
Private oList
Private oList2
Private cUsrPerm	:= SuperGetMV("MV_XGCT003",.T.,"ADMIN")

If mv_par05 == 1
	cTpReajuste := "Aumento"
Else
	cTpREajuste := "Redução"
EndIf

If mv_par06 == 1
	cTpCalc := "Percentual"
Else
	cTpCalc := "Valor"
EndIf

//aAdd(aObjects,{000, 020, .T., .F. })	
aAdd(aObjects,{000, 000, .T., .T. })

aInfo := {aDimension[1],aDimension[2],aDimension[3],aDimension[4], 3 /*distancia horizontal*/, 3 /*distancia vertical*/}
aPosObj := MsObjSize(aInfo,aObjects)
// Monta a janela
oDlg1	:= MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],cTitulo,,,.F.,,,,,,.T.,,,.T. )
	oDlg1:lMaximized := .T.
	
	oList := TCBrowse():New(aPosObj[1][1]+2,aPosObj[1][2]+2,aPosObj[1][4]-7,aPosObj[1][3]-30,,;
				{"","Contrato", "Data Inicio", "Data Fim", "Cliente", "Loja","Situação","Valor anterior","Valor atualizado","Volume Minimo","Data Ultimo reajuste","Ultimo Indice"},;
				{05,25,10,10,10,10,15,25,15,15,15,15},oDlg1,,,,/*{|| fHelp()}*/,{|| Patri()},/*{ || Marca() }*/,,,,,,.F.,,.T.,{ || Len(aContr) > 0},.F.,,.T.,.T.,)
	oList:SetArray(aContr)                                                      
	
	// Monta a linha a ser exibina no Browse
	oList:bLine := {||{  IIF(aContr[oList:nAt,01]=="ALT",oAlt,IIF(aContr[oList:nAt,01]=="OK",oOk,oNo)),; //Flag
							aContr[oList:nAt,02],;														//Contrato
							aContr[oList:nAt,03],;														//Data Inicio
							aContr[oList:nAt,04],;														//Data Fim
							aContr[oList:nAt,05],;														//Cliente
							aContr[oList:nAt,06],;														//Loja
							aContr[oList:nAt,07],;														//Situacao
							Transform(aContr[oList:nAt,08],PesqPict("CNA","CNA_VLTOT") ),;				//Valor total anterior
							Transform(aContr[oList:nAt,09],PesqPict("CNA","CNA_VLTOT") ),;				//Valor total atualizado
							Transform(aContr[oList:nAt,12],PesqPict("SN1","N1_XVOLMIN") ),;				//Volume minimo
							aContr[oList:nAt,15],;														//Data Ultimo reajuste
							aContr[oList:nAt,16]}}														//Media do ultimo indice aplicado
							
	oList:nScrollType := 1 //SCROLL VRC				
			
	// Painel rodape
	oPanel:= tPanel():New(aPosObj[1][3]-15,04,"",oDlg1,,,,,,100,030)
	oPanel:align:= CONTROL_ALIGN_BOTTOM

	If mv_par05 == 1
		oBmpUP := TBitmap():New(010,005,20,20,"PMSSETAUP",,.T.,oPanel,{||},,.F.,.F.,,,.F.,,.T.,,.F.)
	Else
		oBmpDOWN := TBitmap():New(010,005,20,20,"PMSSETADOWN",,.T.,oPanel,{||},,.F.,.F.,,,.F.,,.T.,,.F.)
	EndIf
	oSay2 := TSay():New( 010,030,{|| "Tipo de Reajuste: "+cTpReajuste} ,oPanel,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,,100,010)
		
	oBmpCalc := TBitmap():New(010,150,20,20,"RECALC",,.T.,oPanel,{||},,.F.,.F.,,,.F.,,.T.,,.F.)	   	
	oSay3	:= TSay():New( 010,175,{|| "Tipo do Cálculo: "+cTpCalc} ,oPanel,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,,100,010)

	oBmpVl := TBitmap():New(010,300,20,20,"PRECO",,.T.,oPanel,{||},,.F.,.F.,,,.F.,,.T.,,.F.)
	oSay4	:= TSay():New( 010,325,{|| IIF(mv_par06==1,"% "+CVALTOCHAR(MV_PAR09),"Valor: R$ "+cvaltochar(mv_par09)) }	,oPanel,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,,060,010)
							                                                                                                     
    oBtn1	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-90, 40, 40, 'BMPTRG' , , , ,{|| Reajusta() } , oDlg1, "Reajustar" , ,)
	oBtn2	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-50, 40, 40, 'CANCEL' , , , ,{|| oDlg1:End() } , oDlg1, "Sair" , ,)
	
	If !cUserName $ cUsrPerm
		oBtn1:lReadOnly := .T.
	EndIf
	
oDlg1:Activate(,,,.T.)

      
Return


      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Patri ºAutor ³Jackson E. de Deus       º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mostra a tela com os patrimonios do contrato selecionado   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Patri()

Local oDlg2
Local oBtn1
Local oBtn2
Local oBtn3
Local aDimension	:= MsAdvSize()
Local aInfo 		:= Array(0)
Local aObjects		:= Array(0)             
Local aPosObj		:= Array(0)
Local nTamTela		:= 0.70
Private oOk			:= LoadBitMap(GetResources(), "BR_VERDE")
Private oNo			:= LoadBitMap(GetResources(), "BR_VERMELHO")
Private oSim		:= LoadBitMap(GetResources(), "LBTIK")
Private oNao		:= LoadBitMap(GetResources(), "LBNO")
Private nPosMark	:= 2
Private nPosVlMin	:= 13 //array
Private nPosVlPat	:= 12 //array


aPatrim2 := {}

aAdd(aObjects,{000, 010, .T., .F. })	
aAdd(aObjects,{000, 000, .T., .T. })

aDimension[1] := aDimension[1] * nTamTela
aDimension[2] := aDimension[2] * nTamTela
aDimension[3] := aDimension[3] * nTamTela
aDimension[4] := aDimension[4] * nTamTela
aDimension[5] := aDimension[5] * nTamTela
aDimension[6] := aDimension[6] * nTamTela
aDimension[7] := aDimension[7] * nTamTela
                                
aInfo := {aDimension[1],aDimension[2],aDimension[3],aDimension[4], 3 /*distancia horizontal*/, 3 /*distancia vertical*/}
aPosObj := MsObjSize(aInfo,aObjects)


//Monta a janela
oDlg2	:= MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],"Patrimonios",,,.F.,,,,,,.T.,,,.T. )	

	oSay1 := TSay():New( aPosObj[1][1]+7,aPosObj[1][2]+2,{|| "Selecione os patrimonios que serão reajustados" },oDlg2,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,010)    
	oList2 := TCBrowse():New(aPosObj[2][1]+6,aPosObj[2][2]+2,aPosObj[2][4]-7,aPosObj[2][3]-60,;
						,{"","","Planilha","Patrimônio", "Descrição", "Produto", "Local Fisico","Dt Inst.","Volume Min.", "Valor anterior", "Valor novo",""},;
						{05,05,10,10,25,10,15,15,15,15,15,5},oDlg2,,,,/*{|| troca de linha*/,/*{|| duplo clique }*/,/*{ || Marca() }*/,,,,,,.F.,,.T.,{ || Len(aPatrim2) > 0},.F.,,.T.,.T.,)	
    
    // Monta a grid do tcbrowse
	Filtro()
	oList2:nScrollType := 1 //SCROLL VRC
	oList2:bLDblClick := {|| EditCol(),oList2:DrawSelect()}  					
										                                                                                                     
	oBtn2	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-90, 40, 40, 'SELECTALL' , , , ,{|| InvSel() } , oDlg2, "Inverte seleção" , ,)    
	oBtn3	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-50, 40, 40, 'SALVAR' , , , ,{|| ConfPatr(@oDlg2) } , oDlg2, "Confirmar" , ,)
		
oDlg2:Activate(,,,.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Filtro ºAutor ³Jackson E. de Deus      º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra os patrimonios que devem aparecer na tela		      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
Static Function Filtro()

aPatrim2 := aClone(aContr[oList:nAt][17])
oList2:SetArray(aPatrim2)
                                                      
	
// Monta a linha a ser exibina no Browse
oList2:bLine := {||{	IIF(aPatrim2[oList2:nAt,03],oOk,oNo),;									//[1] flag processado
						IIF(aPatrim2[oList2:nAt,04],oSim,oNao),;								//[2] Flag marcacao
						aPatrim2[oList2:nAt,11],;												//[3] Planilha
						aPatrim2[oList2:nAt,05],;												//[4] Patrimonio
						aPatrim2[oList2:nAt,06],;												//[5] Descricao
						aPatrim2[oList2:nAt,07],;												//[6] Produto
						aPatrim2[oList2:nAt,08],;												//[7] Local fisico
						aPatrim2[oList2:nAt,14],;												//[8] Data instalacao
						Transform(aPatrim2[oList2:nAt,13],PesqPict("SN1","N1_XVOLMIN") ),;		//[9] Volume minimo
						Transform(aPatrim2[oList2:nAt,09],PesqPict("CNB","CNB_VLUNIT") ),;		//[10] Valor anterior
						Transform(aPatrim2[oList2:nAt,12],PesqPict("CNB","CNB_VLUNIT") ),;		//[11] Valor atual
						" "}}

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ChkAll ºAutor ³Jackson E. de Deus      º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca todos os patrimonios							      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function InvSel()

Local nI

For nI := 1 To Len(aPatrim2)
	If !aPatrim2[nI][4]
		aPatrim2[nI][4] := .T.	
	Else                        
		aPatrim2[nI][4] := .F.	
	EndIf	
Next nI

Return        


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EditCol ºAutor ³Jackson E. de Deus    º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Edicao de campos.										  º±±
±±º          ³         													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EditCol()

Local nBkp
Local nI

//Coluna de marcacao
If oList2:ColPos() == nPosMark
	If aPatrim2[oList2:nAt][17][oList2:nat][4]
		aPatrim2[oList2:nAt][17][oList2:nat][4] := .F.
	Else
		aPatrim2[oList2:nAt][17][oList2:nat][4] := .T.
	EndIf
Else
	nBkp := aPatrim2[oList2:nAt][9]
	aPatrim2[oList2:nat][9] := aPatrim2[oList2:nAt][nPosVlMin]
	lEditCell(@aPatrim2,oList2,PesqPict("SN1","N1_XVOLMIN"),09)
	aPatrim2[oList2:nat][nPosVlMin]  := aPatrim2[oList2:nAt][9]
	aPatrim2[oList2:nat][9] := nBkp
	oList2:Refresh()
	
	nBkp := aPatrim2[oList2:nAt][11]
	aPatrim2[oList2:nAt][11] := aPatrim2[oList2:nAt][nPosVlPat]
	lEditCell(@aPatrim2,oList2,PesqPict("CNB","CNB_VLUNIT"),11)

	aPatrim2[oList2:nAt][nPosVlPat] := aPatrim2[oList2:nAt][11]
	aPatrim2[oList2:nAt][11] := nBkp
	//EndIf
	oList2:Refresh()
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ConfPatr ºAutor ³Jackson E. de Deus    º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Altera o status dos contratos onde houve alteracao.		  º±±
±±º          ³ A regra adotada é quando o patrimonio é desmarcado.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ConfPatr(oDlg2)

Local nI

If lGravou
	Return
EndIf

aContr[oList:nAt][17] := aClone(aPatrim2)	

oList:Refresh(.T.)
oDlg2:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Reajusta ºAutor ³Jackson E. de Deus    º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Reajusta os preços dos patrimonios selecionados.			  º±±
±±º          ³        													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  Reajusta()

Private lEnd := .F.

If MsgYesNo("Deseja realmente reajustar os preços dos patrimônios?")
	oProcess := MsNewProcess():New( {|lEnd| Ajusta(@oProcess, @lEnd) }, "Reajuste de preços", "Reajustando preços dos patrimônios", .T. )
	oProcess:Activate()                                                 
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ajusta ºAutor ³Jackson E. de Deus    	 º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Reajusta os preços dos patrimonios selecionados.			  º±±
±±º          ³        													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ajusta(oProcess, lEnd)

Local cUsrMail		:= SuperGetMV("MV_XGCT006",.T.,"",)
Local oExcel        				// objeto utilizado para impressao da planilha em excel
Local cContrato		:= ""			// contrato
Local cPlanilha		:= ""			// planilha
Local nSaldoCont	:= 0			// saldo do contrato
Local dIniCalc		:= mv_par03		// data de inicio do calculo - se for por indice, considera essa data como inicio, caso contrario, vigencia do contrato
Local dFimCalc		:= mv_par04		// data de fim do calculo - se for por indice, considera essa data como fim, caso contratio, termino da vigencia do contrato
Local nTpReaj		:= mv_par05		// tipo de reajuste
Local nTpCalc		:= mv_par06		// tipo de calculo
Local nValPar		:= mv_par09		// valor a ser utilizado
Local lUsaIndice	:= IIF(mv_par08==1,.T.,.F.)		// considera percentual do indice?
Local nTotMeses		:= 0			// total de meses para a media do indice
Local nPerc			:= 0			// variavel auxiliar para calculo do percentual
Local nPercPatr		:= 0			// percentual quebrado com base no valor do patrimonio
Local cPatrimo		:= ""			// patrimonio
Local nVal			:= 0			// valor do patrimonio
Local nValTotal		:= 0			// valor total da planilha
Local cPatrAux		:= ""			// variavel auxiliar que contera todos os patrimonios/valores
Local nTotPatr		:= 0			// total de patrimonios a serem considerados para cada contrato
Local nRecnoCNB		:= 0			// guarda o recno da planilha na tabela CNB
Local nTotCNB		:= 0			// guarda o valor total da tabela CNB (CNB->CNB_VLTOT)
Local lGrava		:= .F.			// variavel logica para controle de gravacao dos dados
Local lProximo		:= .F.			// variavel logica para controle do segundo laço (laço interno dos patrimonios (nj)) 
Local nPosIni		:= 0			// Posicao inicial do array dos patrimonios que devera ser considerada (o array de patrimonios possui todos os contratos)
Local nPosFim		:= 0			// Posicao inicial do array dos patrimonios que devera ser considerada
Local lCancelou		:= .F.			// controle de cancelamento da rotina - desarma a transacao
Local cDirServer	:= SuperGetMV("MV_XGCT004",.T.,"\system\contratos\",)	//diretorio no servidor onde as planilhas serao guardadas
Local cDirLocal		:= SuperGetMV("MV_XGCT005",.T.,"C:\TEMP\",)	//diretorio no cliente onde as planilhas serao guardadas
Local cPlanilha		:= ""
Local cDia			:= ""
Local cMes			:= ""
Local cAno			:= ""
Local nTotVol		:= 0			// Volume minimo total para ser atualizado na CN9 -> CN9_XVOLMI
Local dDtIniCont
Local dDtFimCont
Local dDtInstPat
Local cCompet		
Local nValIndice	:= 0
Local cIndice		:= ""
Local nRes			:= 0
Local aOcorren		:= {}			// grava as ocorrencias de erro no processamento do reajuste
Local aPatrSZQ		:= {}
Local nRecSN1		:= 0

Private nMediaInd	:= 0			// media do indice
Private dDtIniReaj	:= mv_par07		// periodo inicial do reajuste - o reajuste vai iniciar a partir dessa data
Private cpCliente	:= ""			// codigo do cliente
Private cpLoja		:= ""			// loja do cliente

Default oProcess	:= NIL			// valor default para o objeto da classe MsNewProcess
Default lEnd		:= .F.			// valor default para a variavel logica de controle da MsNewProcess
    
// reajuste a partir de? vazio     
If DTOS(dDtIniReaj) == ""
	dDtIniReaj := dDatabase     
EndIf

If !lJob
	If lGravou
		Aviso("TTCNTA06","O reajuste dos patrimônios já foi realizado.",{"Ok"})
		Return
	EndIf                                                                      
EndIf                                                                          
                               
BeginTran()

If !lJob
	If Len(aContr) == 1
		oProcess:SetRegua1(Len(aContr[1][17])) 
	Else
		oProcess:SetRegua1(Len(aContr))
	EndIf
EndIf

For nI := 1 To Len(aContr)
	nVal := 0
	aIndices := {}
	nTotMeses := 0
	nValIndice := 0
		
	If !lJob
		oProcess:IncRegua1("Contrato: " +aContr[nI][2])
		sleep(5)
	EndIf
		
	dDtIniCont	:= aContr[nI][3]
	dDtFimCont	:= aContr[nI][4]
	nTotVol		:= 0 		
	lProximo	:= .F.
	cpCliente	:= aContr[nI][5]
	cpLoja		:= aContr[nI][6]
	
	//Verifica se o contrato ja esta vencendo
	If lJob
		//Se data atual + 30 dias for menor que a data final do contrato, desconsidera
		If Day(dDatabase) +30 < Day(dDtFimCont)
		//	Loop
		EndIf
	EndIf
	
	If lEnd
		DisarmTransaction()
		lCancelou := .T.		
		Exit		
	EndIf
	
	// zera o totalizador de patrimonios por contrato
	nTotPatr := Len(aContr[nI][17])		
	
	// Caso seja executado pelo Job Periodo inicial/Periodo final estejam vazios
	// considera como data inicial e final do indice, as datas do contrato
	If lJob
		//dIniCalc := dDtIniCont
		dIniCalc := MonthSub( dFimCalc , 12 )
		dFimCalc := dDtFimCont  
    Else
    	If DtoS(mv_par03)== "" .And. DtoS(mv_par04)== ""
	    	dIniCalc := dDtIniCont
			dFimCalc := dDtFimCont
    	EndIf
	EndIf
	
	
	// Calcula a media do indice cheio
	If lJob .Or. lUsaIndice .And. aContr[nI][10] == "A"
		aIndices := AcLone( aContr[nI][18] )          
		For nK := 1 To Len(aIndices)	
			cCompet := CtoD("01/" +aIndices[nK][3])
			If cCompet >= dIniCalc .And. cCompet <= dFimCalc
				nValIndice += aIndices[nK][4]
				nTotMeses++               
			EndIf
		Next nK
				                                  
		// define a media do indice ( valor dos meses/total de meses )
		If nValIndice > 0 .And. nTotMeses > 0
			nValIndice := nValIndice/nTotMeses
			nMediaInd := nValIndice              
		EndIf
	EndIf

	// processa
	If !lJob
		oProcess:SetRegua2(nTotPatr)	  
	EndIf

	aPatrim := aClone(aContr[nI][17])

	For nJ := 1 To Len(aPatrim)
		nRecPlan	:= aPatrim[nJ][2]	// recno da planilha	
		//nValIndice	:= 0
		nVal		:= 0
		nTotMeses	:= 0
		nPerc		:= 0
		nPercPatr	:= 0

		If !lJob
			oProcess:IncRegua2("Patrimônio: " +aPatrim[nJ][5])
			sleep(5)                                          
		EndIf
		
		If lEnd
			DisarmTransaction()
			lCancelou := .T.		
			Exit		
		EndIf
				
		// considera somente patrimonios marcados para processamento E ainda nao reajustados E com data de instalacao
		If aPatrim[nJ][4] .And. !aPatrim[nJ][10] // .And. aPatrim[nJ][14] <> ctod("")
			cPatrimo := aPatrim[nJ][5]
			nVal := aPatrim[nJ][9]
			dDtInstPat := aPatrim[nJ][14]
			
			/*
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se a execucao for via Job, considera o calculo atraves do indice do contrato³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			*/
			If lJob .Or. lUsaIndice //.And. aContr[nI][10] == "A"		
				// Caso utilize o percentual do indice, deve fazer o calculo da media do indice - soma os meses e divide pela quantidade de meses somados
				//Tipo do Reajuste do Contrato ANUAL - considera somente contrato com reajuste do tipo ANUAL
				//If aContr[nI][10] == "A"
					/*																                                 	
					//Patrimonio foi instalado apos a vigencia do contrato - considera periodo proporcional
					If Month(dDtInstPat) > Month(dDtIniCont) .And. Year(dDtInstPat) >= Year(dDtIniCont)
						//Procura o indice do contrato no historico de indices
						For nK := 1 To Len(aIndices)
							//If aIndices[nK][1] == aContr[nI][11]
								cCompet := CtoD("01/" +aIndices[nK][3])
							
								//considera apenas competencia de indice que estejam dentro do periodo do contrato
								If cCompet >= dIniCalc .And. cCompet <= dFimCalc
									//Ignora competencia menor que a data de instalacao do patrimonio
									//If Month(cCompet) < Month(dDtInstPat) .And. Year(cCompet) <= Year(dDtInstPat)
									If cCompet < dDtInstPat
										Loop
									EndIf
									
									nValIndice += aIndices[nK][4]
									nTotMeses++               
								EndIf
							//EndIf
						Next nK
								
						// define a media do indice ( valor dos meses/total de meses )
						If nValIndice > 0 .And. nTotMeses > 0
							nValIndice := nValIndice/nTotMeses       
						EndIf
						
						If nValIndice == 0
							AADD(aOcorren, "Contrato "+aContr[nI][2] +"-" +"Indice: "+aContr[nI][14] +"-" +"Sem Indice cadastrado para o periodo.")
						Else
							If Positivo(nValIndice)           
								//se for aumento
								If nTpReaj == 1  
									nPerc := nVal/100
									nPercPatr := nPerc * nValIndice 
									nVal := nVal + nPercPatr
								// se for reducao
								Else
									nPerc := nVal/100
									nPercPatr := nPerc * nValIndice 
									nVal := nVal - nPercPatr
								EndIf
							Else
								AADD(aOcorren, "Contrato "+aContr[nI][2] +"-" +"Indice: "+aContr[nI][14] +"-" +"Valor negativo não pode ser considerado para o cálculo." +"Patrimonio: " +cPatrimo)	
							EndIf
							    
							If nVal <> 0
								aPatrim[nJ][10] := .T.			// O valor foi atualizado no array
								aPatrim[nJ][3] := .T.			// processado
								aPatrim[nJ][16] := nValIndice	// Media do indice para o patrimonio
							Else
								aPatrim[nJ][3] := .T.	// processado
								// naopode ser zerado - considera o valor atual entao
								nVal := aPatrim[nJ][9]            
								AADD(aOcorren, "Contrato "+aContr[nI][2] +"-" +"Indice: "+aContr[nI][14] +"-" +"O valor não pode ser zero. Será considerado o valor anterior." +"Patrimonio: " +cPatrimo)	
							EndIf
						EndIf                                                          
									
					Else // Considera periodo cheio - inicio/termino do periodo considerado do indice
					*/						
						If nValIndice == 0
							AADD(aOcorren, "Contrato "+aContr[nI][2] +"-" +"Indice: "+aContr[nI][14] +"-" +"Sem Indice cadastrado para o periodo.")
						Else
							If Positivo(nValIndice)
								//se for aumento
								If nTpReaj == 1  
									nPerc := nVal/100
									nPercPatr := nPerc * nValIndice 
									nVal := nVal + nPercPatr
								// se for reducao
								Else
									nPerc := nVal/100
									nPercPatr := nPerc * nValIndice 
									nVal := nVal - nPercPatr
								EndIf
							Else
								AADD(aOcorren, "Contrato "+aContr[nI][2] +"-" +"Indice: "+aContr[nI][14] +"-" +"Valor negativo não pode ser considerado para o cálculo." +" -> Patrimonio: " +cPatrimo)	
							EndIf
							
							If nVal <> 0
								aPatrim[nJ][10] := .T.			// O valor foi atualizado no array
								aPatrim[nJ][3] := .T.			// processado
								aPatrim[nJ][16] := nValIndice	// Media do indice para o patrimonio
							Else
								aPatrim[nJ][3] := .T.			// processado
								// naopode ser zerado - considera o valor atual entao
								nVal := aPatrim[nJ][9]
								AADD(aOcorren, "Contrato "+aContr[nI][2] +"-" +"Indice: "+aContr[nI][14] +"-" +"O valor não pode ser zero. Será considerado o valor anterior." +"Patrimonio: " +cPatrimo)
							EndIf
						EndIf
					//EndIf
				//EndIf
					
			/*
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso contrario, faz o calculo com base no percentual ou valor digitado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			*/
			Else
				//caso o novo valor tenha sido 'digitado' na tela de patrimonios, considera o valor digitado
				If aPatrim[nJ][12] > 0
					nVal := aPatrim[nJ][12]
					
					aPatrim[nJ][10] := .T.	// O valor foi atualizado
					aPatrim[nJ][3] := .T.	// processado
				Else	
					//Calcula somente se foi preenchido valor maior que 0 no parametro
					If nValPar <> 0	
						//se for aumento
						If nTpReaj == 1    
							// se for por percentual
							If nTpCalc == 1
								nPerc := nVal/100
								nPercPatr := nPerc * nValPar 
								nVal := nVal + nPercPatr
							// se for por valor
							Else
								nVal := nVal + nValPar	// valor do patrimonio + valor informado no parametro
							EndIf
						// se for reducao
						Else
							// se for por percentual
							If nTpCalc == 1
								nPerc := nVal/100
								nPercPatr := nPerc * nValPar 
								nVal := nVal - nPercPatr
							// se for por valor
							Else
								nVal := nVal - nValPar	// valor do patrimonio - valor informado no parametro
							EndIf
						EndIf
							
						If nVal <> 0
							aPatrim[nJ][10] := .T.	// O valor foi atualizado
							aPatrim[nJ][3] := .T.	// processado
						Else
							aPatrim[nJ][3] := .T.	// processado
							// naopode ser zerado - considera o valor atual entao
							nVal := aPatrim[nJ][9]
							AADD(aOcorren, "Contrato "+aContr[nI][2] +"-" +"Indice: "+aContr[nI][14] +"-" +"O valor não pode ser zero. Será considerado o valor anterior." +"Patrimonio: " +cPatrimo)
						EndIf
					EndIf	
				EndIf
			EndIf			
		// Caso contrario mantem valor original
		Else
			cPatrimo := aPatrim[nJ][5]
			nVal := aPatrim[nJ][9]		
		EndIf

		aPatrim[nJ][12] := nVal			//adiciona no array o valor atualizado
		nValTotal += nVal				// valor total
		
		// Prepara o array para gravacao dos patrimonios na tabela SZQ
		AADD( aPatrSZQ, { aPatrim[nJ][1], aPatrim[nJ][11], cPatrimo, nVal, aPatrim[nJ][17] } )
		
		//Verifica a posicao do Array pra saber se vai para o proximo ou se vai ativar a gravacao
		If nJ <> Len(aPatrim)
			If aPatrim[nJ+1][2] <> nRecPlan
				lGrava := .T.
			EndIf
		Else
			If nJ == Len(aPatrim)
				lGrava := .T.
			EndIf
		EndIf
		      
		// Atualiza tabelas
		If lGrava .And. nValTotal <> 0
			nValTotal := Round(nValTotal,2)
			nRecnoCNB := nRecPlan
			cContrato := aPatrim[nJ][1]
			cPlanilha := aPatrim[nJ][11]
			
			// grava o volume minimo ?? verificar se realmente precisa disso na locacao 
			dbSelectArea("SN1")
			For nK := 1 To Len(aPatrim)
				nRecSN1 := U_TTTMKA19(aPatrim[nK][5])
				If nRecSN1 > 0
					SN1->( dbGoTo(nRecSN1) )
					If RecLock("SN1",.F.)
						SN1->N1_XVOLMIN := aPatrim[nK][13]
						SN1->(MsUnLock())
					EndIf
				EndIf
			Next nK
			
			// Atualiza valor de locacao dos patrimonios
		   	For nK := 1 To Len(aPatrSZQ)
		   		nRecZQ := aPatrSZQ[nK][5] //ChkSZQ(cContrato,cPlanilha,aPatrSZQ[nK][3])
		   		//If dbSeek( xFilial("SZQ") +cContrato +cPlanilha +aPatrSZQ[nK][3] )
		   		If nRecZQ > 0                
		   			dbSelectArea("SZQ")
		   			dbGoTo(nRecZQ)
		   			If Recno() == nRecZQ
		   				If SZQ->ZQ_VALOR <> aPatrSZQ[nK][4]
				   			RecLock("SZQ",.F.)
				   			SZQ->ZQ_VALOR := aPatrSZQ[nK][4]
				   			MsUnLock()
			   			EndIf
		   			EndIf
		   		EndIf	
		   	Next nK

			// Tabela CNB
   			dbSelectArea("CNB")
   			CNB->( dbGoTo(nRecnoCNB) )
   			If RecLock("CNB",.F.)
   				CNB->CNB_VLUNIT := nValTotal
   				CNB->CNB_VLTOT := nValTotal * CNB->CNB_SLDMED
   				nTotCNB := CNB->CNB_VLTOT
   				CNB->( MsUnLock() )
   			EndIf
   			 
			// Tabela CNA
			If nTotCNB > 0
	   			dbSelectArea("CNA")
	   			dbSetOrder(1)	//CNA_FILIAL + CNA_CONTRA + CNA_REVISA + CNA_NUMERO
	   			If dbSeek(xFilial("CNA")+cContrato+AvKey("","CNB_REVISA")+cPlanilha)
	   				If RecLock("CNA",.F.)
	   					CNA->CNA_VLTOT := nTotCNB
	   					CNA->CNA_VLCOMS := nTotCNB
	   					CNA->CNA_SALDO := nTotCNB
	   					CNA->(MSUnLock())
	   				EndIf
	   			EndIf
	   			
   				//Atualiza o saldo do contrato
				RetSldCont(cContrato,@nSaldoCont)
				If nSaldoCont <> 0
					dbSelectArea("CN9")
					dbSetOrder(1) //FILIAL+CONTRATO+REVISAO [CN9_FILIAL+CN9_NUMERO+CN9_REVISA]
					If dbSeek(xFilial("CN9")+AvKey(cContrato,"CN9_NUMERO"))
						If RecLock("CN9",.F.)   
							CN9->CN9_SALDO := nSaldoCont
							CN9->(MsUnLock())
						EndIf
					EndIf
				EndIf
				
				//Atualiza titulos provisorios no financeiro SE1 e parcelas do cronograma financeiro CNF
				U_TTCNTA09(cpCliente, cpLoja, cContrato, cPlanilha, nValTotal, CNA->CNA_CRONOG, dDtIniReaj )
				
				U_TTGENC01(xFilial("CN9"),"TTCNTA06","REAJUSTE DE CONTRATO","",cContrato,"",cusername,dtos(date()),time(),,"CONTRATO REAJUSTADO",cpCliente,cpLoja,"CN9")	
   			EndIf
   			
   			cPatrAux := ""
   			nValTotal := 0
   			nTotCNB := 0
   			lGrava := .F.
  			nVal := 0
			aPatrSZQ := {}
		EndIf
		
		//Incrementa a variavel totalizadora de volume minimo do contrato
		nTotVol += aPatrim[nJ][13]
	Next nJ
			                      
	aPatrSZQ := {}
	aContr[nI][17] := aclone(aPatrim)
	aContr[nI][1] := "OK"		// altera o flag do contrato para processado
	aContr[nI][13] := nTotVol	//Novo volume minimo do contrato                    
Next nI

MsUnLockAll()

If !lCancelou
	EndTran()
	lGravou := .T.
	//Atualiza o valor total dos contratos
	TotContr()
	If !lJob
		oList:Refresh(.T.)
	EndIf
Else
	Return
EndIf



/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera o relatorio da operacao em excel³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
oExcel := FWMSEXCEL():New()

//Primeira aba - parametros
oExcel:AddworkSheet("Parametros")
oExcel:AddTable ("Parametros","Parametros")
oExcel:AddColumn("Parametros","Parametros","Parametros",1,1)
oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)

oExcel:AddRow("Parametros","Parametros",{"Contrato de: ", mv_par01 } )
oExcel:AddRow("Parametros","Parametros",{"Contrato ate: ", mv_par02} )
oExcel:AddRow("Parametros","Parametros",{"Periodo de: ", DtoC(mv_par03)} )
oExcel:AddRow("Parametros","Parametros",{"Periodo ate: ", DtoC(mv_par04)} )
oExcel:AddRow("Parametros","Parametros",{"Tipo de Reajuste: ", cTpReajuste} )
oExcel:AddRow("Parametros","Parametros",{"Tipo de Calculo: ", cTpCalc} )
oExcel:AddRow("Parametros","Parametros",{"A partir de: " , DtoC(mv_par07)} )
oExcel:AddRow("Parametros","Parametros",{"Considera Indice: " , IIF(lUsaIndice,"SIM","NAO") } )
oExcel:AddRow("Parametros","Parametros",{"Valor: " , Transform(nValPar,"@E 9,999,999.99")} ) 

   
//Segunda aba - patrimonios
oExcel:AddworkSheet("Reajuste")
oExcel:AddTable ("Reajuste","Reajuste")
oExcel:AddColumn("Reajuste","Reajuste","Contrato",1,1)
oExcel:AddColumn("Reajuste","Reajuste","Indice",1,1)
oExcel:AddColumn("Reajuste","Reajuste","Planilha",1,1)
oExcel:AddColumn("Reajuste","Reajuste","Patrimonio",1,1)
oExcel:AddColumn("Reajuste","Reajuste","Descricao",1,1)
oExcel:AddColumn("Reajuste","Reajuste","Produto",1,1)
oExcel:AddColumn("Reajuste","Reajuste","Local fisico",1,1)
oExcel:AddColumn("Reajuste","Reajuste","Data instalacao",1,4)
oExcel:AddColumn("Reajuste","Reajuste","Valor",1,2)
oExcel:AddColumn("Reajuste","Reajuste","Reajustado",1,1)
oExcel:AddColumn("Reajuste","Reajuste","Novo valor",1,2)
oExcel:AddColumn("Reajuste","Reajuste","Media Indice",1,2)


// Grava na tabela de LOG
If FindFunction("U_TTGENC01")
	U_TTGENC01(xFilial("CN9"),"TTCNTA06","Reajuste de contratos","",mv_par01+"-"+mv_par02,"",cusername,dtos(date()),time(),,"Reajuste de contratos","","","CN9")	
EndIf
           

For nX := 1 To Len(aContr)                                   
	For nY := 1 To Len(aContr[nX][17])
		oExcel:AddRow("Reajuste","Reajuste",{aContr[nX][2],;
											aContr[nX][14],;
											aContr[nX][17][nY][11],;
											aContr[nX][17][nY][5],;
											aContr[nX][17][nY][6],;
											aContr[nX][17][nY][7],;
											aContr[nX][17][nY][8],;
											aContr[nX][17][nY][14],;
											Transform(aContr[nX][17][nY][9],"@E 9,999,999.99"),;
											IIF(aContr[nX][17][nY][10],"SIM","NAO"),;
											Transform(aContr[nX][17][nY][12],"@E 9,999,999.99"),;
											Transform(aContr[nX][17][nY][16],"@E 9,999,999.99") })

	Next nY										
Next nX


oExcel:Activate()


If !lJob
	// verifica existencia do local padrao para gravacao - C:\TEMP\
	If !ExistDir(cDirLocal)
		MakeDir(cDirLocal)
	EndIf
	
	If !ExistDir(cDirLocal)
		Aviso("TTCNTA06","O diretório padrão para gravação da planilha é C:\TEMP."+CRLF +"Houve problemas para gravar nesse local, por favor selecione outro caminho.",{"Ok"})
		cDirLocal := ""
		While Empty(cDirLocal)
			cDirLocal := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
		End 
	EndIf
	
	oExcel:GetXMLFile(cDirLocal+"reajustes.xml")

	If File(cDirLocal +"reajustes.xml")
		Aviso("TTCTAC02","A planilha foi gerada em " +cDirLocal, {"Ok"})
		If !ApOleClient( 'MsExcel' )
			Aviso("TTCNTA06", 'MsExcel não instalado. ' +CRLF +'O arquivo está em: '+cDirLocal,{"Ok"} )
		Else
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open(cDirLocal+"reajustes.xml")
			oExcelApp:SetVisible(.T.)         
			oExcelApp:Destroy()
		EndIf
	EndIf
Else
	If !ExistDir(cDirServer)
		MakeDir(cDirServer)
	EndIf
	
	If ExistDir(cDirServer)
		cDia := SubStr(DToC(Date()),1,2)
		cMes := SubStr(DToC(Date()),4,2)
		cAno := CValToChar(Year(Date()))
		cPlanilha := "reajuste_" +cAno +cMes +cDia +"_" +SubStr(Time(),1,2) +SubStr(Time(),4,2) +SubStr(Time(),7,2) +".xml"
		oExcel:GetXMLFile(cDirServer +cPlanilha)
	EndIf
	
	If File(cDirServer +cPlanilha)
		If AllTrim(cUsrMail) == ""
			ConOut("# TTCNTA06 -> Atencao: Email do destinatario invalido. #")
		Else
			If !FindFunction("U_TTMAILN")
				ConOut("# TTCNTA06 -> Funcao U_TTMAILN nao compilada no repositorio. O email nao sera enviado. #")
			Else 
				U_TTMailN("microsiga",cUsrMail,"reajuste","Em anexo a planilha com os dados do reajuste de contratos que foi efetuado.",{ { cDirServer+cPlanilha ,'Content-ID: <ID_reajuste.xml>'} },.F.)
			EndIf
		EndIf
	Else     
		Conout("# TTCNTA06 -> Houve erro ao gerar a planilha no diretorio " +cDirServer +" #")
	EndIf	  
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Dados ºAutor ³Jackson E. de Deus    	 º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca os dados dos contratos e patrimonios.				  º±±
±±º          ³        													  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Dados() 

Local cQuery
lOCAL cDescIndice	:= ""
Local aDados		:= {}
Local cSituacao		:= ""
Local cContratos	:= ""
Local aAux			:= {}
Local aAux2			:= {}
Local cPatrimo		:= ""
Local cProduto		:= ""
Local cDescProd		:= ""
Local cLocFis		:= ""
Local cLoja			:= ""
Local nVal			:= 0
Local nVolMin		:= 0
Local dDtInst		:= ""
Local cIndices		:= ""
Private cCliente	:= ""

cQuery := "SELECT CN9_NUMERO, CN9_SITUAC, CN9_DTINIC, CN9_DTFIM, CN9_CLIENT, CN9_LOJACL, CN9_XPREAJ PERIODO, CN9_INDICE INDICE, CN9_XVOLMI, SUM(CNA_VLTOT) VALOR, CN9_XREAJU, CN9_XINDIC "
cQuery += "FROM " +RetSqlName("CN9") + " CN9 "

cQuery += "INNER JOIN " +RetSqlName("CNA") + " CNA ON "
cQuery += "CNA_CONTRA = CN9_NUMERO "
cQuery += "AND CNA.D_E_L_E_T_ = CN9.D_E_L_E_T_ "

cQuery += "INNER JOIN " +RetSqlName("CNB") +" CNB ON "
cQuery += "CNA_NUMERO = CNB_NUMERO "
cQuery += "AND CNB_CONTRA = CNA_CONTRA "
cQuery += "AND CNB.D_E_L_E_T_ = CN9.D_E_L_E_T_ "

cQuery += "WHERE "
cQuery += "CN9.D_E_L_E_T_  = '' " 
cQuery += "AND CN9.CN9_NUMERO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuery += "AND CN9.CN9_UNVIGE = '2' "	// unidade de vigencia mensal
cQuery += "AND CN9_TPCTO = '002' " 

//Se for execucao via Job, considerar somente contratos com Reajuste automatico
If lJob
	cQuery += "AND CN9.CN9_XAUTRJ = 'S' "
	cQuery += "AND CN9.CN9_DTFIM = '"+DTOS(dDatabase)+"' "	
EndIf

cQuery += "GROUP BY CN9_NUMERO, CN9_SITUAC, CN9_DTINIC, CN9_DTFIM, CN9_CLIENT, CN9_LOJACL,CN9_XPREAJ,CN9_INDICE, CN9_XVOLMI, CN9_XREAJU, CN9_XINDIC "
cQuery += "ORDER BY CN9.CN9_NUMERO"

cQueryOri := cQuery

If Select("TRBCN9") > 0
	TRBCN9->(dbCloseArea())
EndIf
                           
tcquery cquery new alias "TRBCN9"

dbSelectArea("TRBCN9")
dbGoTop()
While !EOF()
	cDescIndice := Posicione("CN7",1,xFilial("CN7")+TRBCN9->INDICE,"CN7_DESCRI")
	
	//Tratamento Situacao do Contrato
	If TRBCN9->CN9_SITUAC == "01"
		cSituacao := "Cancelado"
	ElseIf TRBCN9->CN9_SITUAC == "02"
		cSituacao := "Em Elaboração"
	ElseIf TRBCN9->CN9_SITUAC == "03"
		cSituacao := "Emitido"
	ElseIf TRBCN9->CN9_SITUAC == "04"
		cSituacao := "Em Aprovação"
	ElseIf TRBCN9->CN9_SITUAC == "05"
		cSituacao := "Vigente"
	ElseIf TRBCN9->CN9_SITUAC == "06"
		cSituacao := "Paralisado"
	ElseIf TRBCN9->CN9_SITUAC == "07"
		cSituacao := "Sol. Finalização"
	ElseIf TRBCN9->CN9_SITUAC == "08"
		cSituacao := "Finalizado"
	ElseIf TRBCN9->CN9_SITUAC == "09"
		cSituacao := "Revisão"
	ElseIf TRBCN9->CN9_SITUAC == "10"
		cSituacao := "Revisado"
	EndIf 
	
	AADD(aContr, {"NOK",;				   		//[1] Flag de controle - processados [NOK - nao processado | OK - processado | ALT - alterado e nao processado]
					TRBCN9->CN9_NUMERO,;		//[2] Numero
					StoD(TRBCN9->CN9_DTINIC),;	//[3] Data Inicio
					StoD(TRBCN9->CN9_DTFIM),;	//[4] Data Fim
					TRBCN9->CN9_CLIENT,;		//[5] Cliente
					TRBCN9->CN9_LOJACL,;		//[6] Loja
					cSituacao,;					//[7] Situacao
					TRBCN9->VALOR,;				//[8] Valor anterior (total de todas as planilhas)
					0,;							//[9] Valor atualizado (total de todas as planilhas) 
					TRBCN9->PERIODO,;			//[10] Periodo de Reajuste
					TRBCN9->INDICE,;			//[11] Indice de reajuste
					TRBCN9->CN9_XVOLMI,;		//[12] Volume minimo
					0,;							//[13] Novo Volume minimo apos atualizacao
					cDescIndice,;				//[14] Descricao do Indice
					stod(TRBCN9->CN9_XREAJU),;	//[15] Data do Ultimo reajuste
					TRBCN9->CN9_XINDIC}) 		//[16] Media do Ultimo indice aplicado
	dbSkip()
End
dbCloseArea()                          

If Len(aContr) == 0
	Return
EndIf  
   
For nI := 1 To Len(aContr)
	If nI <> Len(aContr)
		cContratos += aContr[nI][2] +"','"
	Else
		cContratos += aContr[nI][2]	
	EndIf
Next nI


If lJob
	ConOut("# TTCNTA06 -> Carregando patrimonios.. #")
EndIf

// montar array aPatrim
For nI := 1 To Len(aContr)
	cContra := aContr[nI][2]
	cCliente := Posicione("CN9",1,xFilial("CN9")+aContr[nI][5],"CN9_CLIENT")
	aAux := RetPatr(cContra)	// patrimonios
	For nX := 1 to Len(aAux)
		cPatrimo := aAux[nX][3]
		nVal := aAux[nX][4]                   
		cProduto := aAux[nX][8]
		cDescProd := aAux[nX][9]
		cLoja := aAux[nX][10] 
		nVolMin := aAux[nX][11]
		cLocFis := aAux[nX][12]
		dDtInst := aAux[nX][5]
		
		If Empty(cPatrimo)
			Loop
		EndIf
		
		//RetInfPatr(cPatrimo,@cProduto,@cDescProd,@cLoja,@cLocFis,@nVolMin,@dDtInst)			 		
		AADD(aPatrim, {cContra,;			//[1] contrato
						aAux[nX][6],;		//[2] recno da planilha na CNB		
						.F.,;				//[3] flag processado
						.T.,;				//[4] flag marcacao [por default traz marcados todos, o usuario pode desmarcar se quiser] 
						cPatrimo,;			//[5] patrimonio
						cDescProd,;			//[6] descricao patrimonio
						cProduto,;			//[7] produto
						cLocFis,;			//[8] local fisico
						nVal,;				//[9] valor
						.F.,;				//[10] Foi Reajustado o valor? -> usado no relatorio
						aAux[nX][2],;		//[11] Numero da planilha na CNB
						0,;					//[12] Novo valor apos atualizacao
						nVolMin,;			//[13] Volume minimo
						dDtInst,;			//[14] Data instalacao
						nVolMin,;			//[15] Volume minimo original
						0,;					//[16] Media do Indice aplicado
						aAux[nX][7]})		//[17] recno na SZQ
	Next nX
	
	AADD( aContr[nI], aPatrim )	
Next nI

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se for execucao via Job ou calculo por Indice, se torna obrigatorio a existencia de Indice³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
If lJob .Or. mv_par08 == 1
	ConOut("# TTCNTA06 -> Carregando indices dos contratos.. #")
	
	For nI := 1 To Len(aContr)
		cQuery := "SELECT * FROM " +RetSqlName("CN7") + " CN7 "
		cQuery += "WHERE "
		cQuery += "CN7_FILIAL = '"+xFilial("CN7")+"' "
		cQuery += "AND CN7_CODIGO = '"+aContr[nI][11]+"' "
		cQuery += "AND D_E_L_E_T_ = '' "
		cQuery += "ORDER BY CN7_COMPET"
		
		If Select("TRB") > 0
			TRB->(dbCloseArea())
		EndIf
	                           
		tcquery cquery new alias "TRB"
		
		dbSelectArea("TRB")
		dbGoTop()
		While !EOF()
				AADD(aIndices, {TRB->CN7_CODIGO,;	//[1] Indice
								TRB->CN7_DESCRI,;	//[2] Descricao
								TRB->CN7_COMPET,;	//[3] Competencia
								TRB->CN7_VLREAL})	//[4] Valor
			dbSkip()
		End
		dbCloseArea()
		
		If Len(aIndices) > 0
			AADD( aContr[nI], aIndices )
		Else
			aDel(aContr,nI)
			Asize(aContr, Len(aContr)-1)
		EndIf                           
		
		aIndices := {}
	Next nI
EndIf	

Return                                                                                                                  
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetSldCont ºAutor  ³Jackson E. de Deus º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o saldo do contrato (saldo a medir)                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//Valor total das planilhas - valor total ja medido   
Static Function RetSldCont(cContrato, nSaldoCont)

Local cQuery := ""

cQuery += "SELECT SUM(CNA_VLTOT) - "
cQuery += "( "
cQuery += "SELECT SUM(CND_VLTOT) FROM " +RetSqlName("CND") "
cQuery += "WHERE CND_CLIENT = '"+cpCliente+"' "
cQuery += "AND CND_LOJACL = '"+cpLoja+"' "
cQuery += "AND CND_CONTRA = '"+cContrato+"') SALDO "

cQuery += "FROM " +RetSqlName("CNA") "
cQuery += "WHERE CNA_CLIENT = '"+cpCliente+"' "
cQuery += "AND CNA_LOJACL = '"+cpLoja+"' "
cQuery += "AND CNA_CONTRA = '"+cContrato+"' "

cQuery := ChangeQuery(cQuery)

If Select("TCN9") > 0
	TCN9->(dbCloseArea())
EndIf                    

TcQuery cQuery New Alias "TCN9"

dbSelectArea("TCN9")
dbGoTop()
While !EOF()
	nSaldoCont := TCN9->SALDO
	dbSkip()
End
dbCloseArea()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TotContr  ºAutor  ³Jackson E. de Deus  º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TotContr()

Local cQuery := cQueryOri

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                           
TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()              	
While !EOF()
	For nI := 1 To Len(aContr)
		If aContr[nI][2] == TRB->CN9_NUMERO
			aContr[nI][9] := TRB->VALOR
			aContr[nI][15] := Date()
			aContr[nI][16] := nMediaInd
			
			dbSelectArea("CN9")   
			dbSetOrder(1)
			If dbSeek(xFilial("CN9")+aContr[nI][2]+AvKey("","CN9_REVISA"))
				RecLock("CN9",.F.) 
				CN9->CN9_XREAJU := Date()
				
				If nMediaInd <> 0
					CN9->CN9_XINDIC := nMediaInd
				EndIf
				
				If aContr[nI][12] <> aContr[nI][13]
					CN9->CN9_XVOLMI := aContr[nI][13]
				EndIf
				
				MsUnLock()
			EndIf
			dbSelectArea("TRB")
			Exit
		EndIf
	Next nI	                 
	dbSkip()
End
dbCloseArea()

Return


// Busca os patrimonios do contrato
Static Function RetPatr(cContra)

Local cQuery := ""
Local aArea := GetArea()              
Local aAux := {}

cQuery := "SELECT ZQ_CONTRA, ZQ_PLAN, ZQ_PATRIM, ZQ_VALOR, ZQ_DATAINS, ZQ_DATAREM, CNB.R_E_C_N_O_ CNBREC, "
cQuery += " SZQ.R_E_C_N_O_ ZQREC, N1_DESCRIC, N1_XLOCINS, N1_XLOJA, N1_PRODUTO, N1_XVOLMIN "
cQuery += "FROM " +RetSqlName("SZQ")  + " SZQ "
         
cQuery += "INNER JOIN " + RetSqlName("CNB") + " CNB ON "
cQuery += "CNB.CNB_NUMERO = SZQ.ZQ_PLAN "
cQuery += "AND CNB.CNB_CONTRA = SZQ.ZQ_CONTRA "
cQuery += "AND CNB.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " +RetSqlName("SN1") +" SN1 ON "
cQuery += "N1_CHAPA = ZQ_PATRIM AND SN1.D_E_L_E_T_ = '' "

cQuery += "WHERE ZQ_CONTRA = '"+cContra+"' "
cQuery += "AND ZQ_DATAREM = '' "
cQuery += "AND SZQ.D_E_L_E_T_ = '' "
cQuery += "ORDER BY ZQ_PLAN "


If Select("TRBP") > 0
	TRBP->( dbCloseArea() )
EndIf

Tcquery cQuery New alias "TRBP"

dbSelectArea("TRBP")
While !EOF()
	AADD(aAux, { TRBP->ZQ_CONTRA,;
				TRBP->ZQ_PLAN,;
				TRBP->ZQ_PATRIM,;
				TRBP->ZQ_VALOR,;
				DTOC(STOD(TRBP->ZQ_DATAINS)),;
				TRBP->CNBREC,;
				TRBP->ZQREC,;
				TRBP->N1_PRODUTO,;
				TRBP->N1_DESCRIC,;
				TRBP->N1_XLOJA,;
				TRBP->N1_XVOLMIN,;
				TRBP->N1_XLOCINS})
	dbSkip()
End
dbCloseArea()

RestArea(aArea)                      
      
Return aAux


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ AjustaSX1³ Autor ³Jackson E. de Deus     ³ Data ³ 17/09/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta as perguntas do SX1                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TTCNTA06		                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg)

Local aHlpmv01 := {"Contrato inicial"}
Local aHlpmv02 := {"Contrato final"}
Local aHlpmv03 := {"Periodo inicial do reajuste"}
Local aHlpmv04 := {"Periodo final do reajuste"}
Local aHlpmv05 := {"Tipo de reajuste: Aumento ou Redução"}
Local aHlpmv06 := {"Tipo de calculo: Percentual ou Valor"}
Local aHlpmv07 := {"A partir de qual data sera reajustado?"}
Local aHlpmv08 := {"Considera percentual do indice ou digitado?"}
Local aHlpmv09 := {"Valor do reajuste (em percentual ou valor)"}
                         
PutSX1(cPerg,"01","Contrato de:"			,"","","mv_ch0","C",TamSx3("CN9_NUMERO")[1],0,0,"G","","CN9","","","mv_par01","","","","","","","","","","","","","","","","",aHlpmv01,,)
PutSX1(cPerg,"02","Contrato ate:"			,"","","mv_ch1","C",TamSx3("CN9_NUMERO")[1],0,0,"G","","CN9","","","mv_par02","","","","","","","","","","","","","","","","",aHlpmv02,,)
PutSX1(cPerg,"03","Reajuste de"				,"","","mv_ch2","D",8,0,0,"G","","","","","mv_par03","","","",,"","","","","","","","","","","","",aHlpmv03,,)
PutSX1(cPerg,"04","Reajuste ate"			,"","","mv_ch3","D",8,0,0,"G","","","","","mv_par04","","","",,"","","","","","","","","","","","",aHlpmv04,,)
PutSX1(cPerg,"05","Tipo de Reajuste"		,"","","mv_ch4","N",1,0,0,"C","","","","","mv_par05","Aumento","Aumento","Aumento","Redução","Redução","Redução","","","","","","","","","","",aHlpmv05,,)
PutSX1(cPerg,"06","Tipo do Cálculo"			,"","","mv_ch5","N",1,0,0,"C","","","","","mv_par06","Percentual","Percentual","Percentual","Valor","Valor","Valor","","","","","","","","","","",aHlpmv06,,)
PutSX1(cPerg,"07","Reajuste a partir de"	,"","","mv_ch6","D",8,0,0,"G","","","","","mv_par07","","","",,"","","","","","","","","","","","",aHlpmv07,,)
PutSX1(cPerg,"08","Considera indice"		,"","","mv_ch7","N",1,0,0,"C","","","","","mv_par08","Sim","Sim","Sim","Não","Não","Não","","","","","","","","","","",aHlpmv08,,)
PutSX1(cPerg,"09","Valor"					,"","","mv_ch8","N",7,2,0,"G","","","","S","mv_par09","","","",,"","","","","","","","","","","","",aHlpmv09,,)

Return