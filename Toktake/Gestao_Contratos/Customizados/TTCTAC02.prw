#include "protheus.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCTAC02  ºAutor  ³Jackson E. de Deus  º Data ³  08/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta patrimonios no cliente.		                      º±±
±±º          ³Executado pelo PE CTA100MNU                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao de Contratos                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTCTAC02()

Local cTitulo		:= "Consulta de Patrimônios"
Local aArea			:= GetArea()
Local aDimension	:= MsAdvSize()
Local aObjSize		:= Array(0)
Local oFont			:= TFont():New('Arial',,-12,.T.,.T.)
Local cNumChapa		:= Space(TamSx3("N1_CHAPA")[1])                                                               
Private cTpFat		:= AllTrim(CN9->CN9_XTPFAT)                    
Private cNomeCli	:= AllTrim(GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+CN9->CN9_CLIENT+CN9->CN9_LOJACL,1,0))
Private cEndCli		:= AllTrim(GetAdvFVal("SA1","A1_END",xFilial("SA1")+CN9->CN9_CLIENT+CN9->CN9_LOJACL,1,0))
Private aInfo 		:= Array(0)
Private aObjects	:= Array(0)             
Private aPosObj		:= Array(0)
Private aDados		:= {}
Private aBrowse 	:= {} 
Private nPosRecno	:= 14  

If cEmpAnt <> "01"
	Return
EndIf

// busca os dados
Processa({|| RetDados()()   },"Buscando registros, aguarde..")

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt¿
//³Array com tamanho em largura e altura dos objetos.	- Chave: TAMANHO                                     ³
//³Parametros                                                                                              ³
//³1 - largura em pixels                                                                                   ³
//³2 - altura em pixels                                                                                    ³
//³3 - se for verdadeiro, ignora a largura preenchida no parametro 1 e utiliza a largura disponivel da tela³
//³4 - se for verdadeiro, ignora a altura preenchida no parametro 2 e utiliza a altura disponivel da tela  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄtÙ
*/
aAdd(aObjects,{000, 030, .T., .F. })	
aAdd(aObjects,{000, 000, .T., .T. })

aInfo := {aDimension[1],aDimension[2],aDimension[3],aDimension[4], 3 /*distancia horizontal*/, 3 /*distancia vertical*/}
aPosObj := MsObjSize(aInfo,aObjects)

aBrowse := aCLone(aDados)

oDlg1	:= MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],cTitulo,,,.F.,,,,,,.T.,,,.T. )
oDlg1:lMaximized := .T.

// Grupo 1
oGrp1		:= TGroup():New(aPosObj[1][1],aPosObj[1][2],aPosObj[1][3],aPosObj[1][4]		,"Dados do Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1		:= TSay():New( aPosObj[1][1]+7,aPosObj[1][2]+2,{|| "Cliente: "}			,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
oSay2		:= TSay():New( aPosObj[1][1]+7,032,{|| CN9->CN9_CLIENT}					,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,075,008)

oSay3		:= TSay():New( aPosObj[1][1]+7,105,{|| "Nome: "}						,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
oSay4		:= TSay():New( aPosObj[1][1]+7,125,{|| cNomeCli}						,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,300,008)
     
oSay5		:= TSay():New( aPosObj[1][1]+7,aPosObj[1][2]+280,{|| "Endereço: "}		,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
oSay6		:= TSay():New( aPosObj[1][1]+7,aPosObj[1][2]+315,{|| ""}				,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,200,008)

oSay7		:= TSay():New( aPosObj[1][1]+16,aPosObj[1][2]+2,{|| "Contrato: "}					,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
oSay8		:= TSay():New( aPosObj[1][1]+16,aPosObj[1][2]+30,{|| CN9->CN9_NUMERO}					,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,200,008)


// Grupo 2                      
oGrp2		:= TGroup():New(aPosObj[2][1],aPosObj[2][2],aPosObj[2][3]-15,aPosObj[2][4],"Patrimônios",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )                                                                                             

oTcBrowse := TCBrowse():New(aPosObj[2][1]+6,aPosObj[2][2]+2,aPosObj[2][4]-7,aPosObj[2][3]-60,,{"Patrimonio", "Produto", "Descrição", "OMM inst.","OMM rem.","Data Instalação","Data Remoção","Status","Loja","Tipo de Contrato","Local Físico","Valor"},{10,15,10,10,10,10,10,10,10,10,10},oGrp2,,,,{|| fHelp()},{|| Visual()},/*{ || Marca() }*/,,,,,,.F.,,.T.,{ || Len(aBrowse) > 0},.F.,,.T.,.T.,)
oTcBrowse:SetArray(aBrowse)

// Monta a linha a ser exibina no Browse
oTcBrowse:bLine := {||{ aBrowse[oTcBrowse:nAt,04],;	// [1] Patrimonio
						aBrowse[oTcBrowse:nAt,14],;		// [2] Cod Produto
						aBrowse[oTcBrowse:nAt,05],;		// [3] Descricao Patrimonio
						aBrowse[oTcBrowse:nAt,06],;		// [4] Omm instalacao
						aBrowse[oTcBrowse:nAt,07],;		// [5] Omm instalacao
						aBrowse[oTcBrowse:nAt,08],;		// [6] Data instalacao
						aBrowse[oTcBrowse:nAt,09],;		// [7] Data remocao
						aBrowse[oTcBrowse:nAt,10],;		// [8] Status
						aBrowse[oTcBrowse:nAt,02],;		// [9] Loja
						aBrowse[oTcBrowse:nAt,16],;		// [10] Tipo contrato/servico
						aBrowse[oTcBrowse:nAt,13],;		// [11] Local fisico
						aBrowse[oTcBrowse:nAt,12] }}	// [12] Valor

oTcBrowse:nScrollType := 1 //SCROLL VRC                     

// Painel
oPanel:= tPanel():New(aPosObj[2][3]-15,04,"",oDlg1,,,,,,100,030)
oPanel:align:= CONTROL_ALIGN_BOTTOM

oSay9	:= TSay():New( 001,004,{|| "Procurar:"}				,oPanel,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,,060,008)
@ 010,004 MSGET cNumChapa	PICTURE "@!"		OF oPanel SIZE 040,008 PIXEL						                                                                                          
oBtn1		:= TBtnBmp2():New( 010, 090, 40, 40, 'SDUFIND' , , , ,{|| FindPatri(cNumChapa) } , oPanel, "Buscar Patrimônio" , ,)
oBtnExcel	:= TBtnBmp2():New( 010, 140, 40, 40, 'PMSEXCEL' , , , ,{|| If(MsgYesNO('Deseja exportar para planilha?'),Planilha(),) } , oPanel, "Exportar dados" , ,)
oBtnDiv		:= TBtnBmp2():New( 010, 190, 40, 40, 'BMPEMERG' , , , ,{|| U_TTCNTR02() } , oPanel, "Patrimônios fora da planilha de locação" , ,)
oBtn2		:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-50, 40, 40, 'CANCEL' , , , ,{|| oDlg1:End() } , oDlg1, "Sair" , ,)

oDlg1:Activate(,,,.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetDados  ºAutor  ³Jackson E. de Deus  º Data ³  08/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca os contratos.				                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetDados()

Local cQuery	:= ""
Local aOMMs		:= {}
Local nRes		:= 0
Local cPatr		:= ""
Local aPatrim	:= {}
Local ladicionou := .F.
Local cNumChapas := ""
Local nPatVal := 0
Local aAux := {}
Local aContr := {}
Local cTpServ := ""

// Tipos de contrato/servico
aContr := {"Locação",;			//[1]
			"Serv.Café",;		//[2]
			"LA",;				//[3]
			"S.A",;				//[4]
			"Kit Lanche",;		//[5]
			"Café + Locação",;	//[6]
			"LA + Locação",;	//[7]
			"SA + Locação"}		//[8]
			

procregua(3) // 4 passos

// monta query
cQuery := "SELECT SZD.ZD_CLIENTE CLIENTE, SZD.ZD_LOJA LOJA, SA1.A1_NOME NOME, SA1.A1_END ENDERECO, SN1.N1_CHAPA CHAPA, SN1.N1_PRODUTO, "
cQuery += "SN1.N1_DESCRIC DESCRIC, SN1.N1_XTPSERV TPSERVICO, SZD.ZD_NROOMM OMM, "
cQuery += "SN1.N1_XLOCINS LOCFIS, SN1.R_E_C_N_O_ REC, SZD.ZD_DATAINS DATAINS, SZD.ZD_DATAREM DATAREM, SZQ.ZQ_VALOR, SZD.ZD_IDSTATU STATUS, SZD.ZD_NROOMMR OMMREM "
cQuery += "FROM " +RetSqlName("SZD") +" SZD "
                                                                                                                                                              
cQuery += "LEFT JOIN " +RetSqlName("SN1") +" SN1 ON "
cQuery += "SN1.N1_CHAPA = SZD.ZD_PATRIMO "
cQuery += "AND SN1.D_E_L_E_T_ = SZD.D_E_L_E_T_ "

cQuery += "LEFT JOIN " +RetSqlName("SZQ") +" SZQ ON "
cQuery += "SZQ.ZQ_PATRIM = SZD.ZD_PATRIMO "
cQuery += "AND SZQ.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " +RetSqlName("SA1") +" SA1 ON "
cQuery += "SZD.ZD_CLIENTE = SA1.A1_COD "
cQuery += "AND SZD.ZD_LOJA = SA1.A1_LOJA "
cQuery += "AND SN1.D_E_L_E_T_ = SA1.D_E_L_E_T_ "

cQuery += "WHERE SZD.ZD_CLIENTE = '"+CN9->CN9_CLIENT+"' "

// Busca a loja somente se for faturamento por Loja
If cTpFat == "2"
	cQuery += "AND SZD.ZD_LOJA = '"+CN9->CN9_LOJACL+"' "
EndIf

cQuery += "AND SZD.D_E_L_E_T_ = '' "
cQuery += "ORDER BY SZD.ZD_IDSTATU DESC "

cQuery := ChangeQuery(cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()
incproc("-> Salvando registros..")
While !eof()
	cTpServ := ""
	//Busca o tipo de contrato/servico
	If AllTrim(TRB->TPSERVICO) <> ""
		For nI := 1 To Len(aContr)
			If cvaltochar(nI) == AllTrim(TRB->TPSERVICO)
				cTpServ := aContr[nI]
				Exit
			EndIf
		Next nI
	EndIf
	                   
	If !ladicionou
		// adiciona linha em branco para separar os patrimonios ativos dos inativos
		If TRB->STATUS == "0"
			AADD(aDados, {PADR("",TamSx3("A1_COD")[1]," "),;			//[1] Cliente
						PADR("",TamSx3("A1_LOJA")[1]," "),;			//[2] Loja
						PADR("",TamSx3("A1_NOME")[1]," "),;			//[3] Nome
						PADR("",TamSx3("N1_CHAPA")[1]," "),;			//[4] Patrimonio
						PADR("",TamSx3("N1_DESCRIC")[1]," "),;			//[5] Descricao
						PADR("",TamSx3("UC_CODIGO")[1]," "),;			//[6] OMM
						PADR("",TamSx3("UC_CODIGO")[1]," "),;			//[7] OMM rem						
						StoD("  /  /  "),;								//[7] Data Inst.
						StoD("  /  /  "),;								//[8] Data Rem.
						Space(7),;										//[9] Status
						PADR("",TamSx3("A1_END")[1]," "),;				//[10] Endereco
						Transform(0,PesqPict("CNB","CNB_VLUNIT")),;	//[11] Valor 
						Space(TamSX3("Z8_LOCFIS1")[1]),;				//[12] Local instalacao
						Space(TamSx3("B1_COD")[1]),;					//[13] Cod Produto
						0,;												//[14] Recno
						Space(10)})										//[15] Tipo de contrato/servico
						                                                           
						ladicionou := .T.	
		EndIf
	EndIf
	
	
	AADD(aDados, {TRB->CLIENTE,;															//[1] Cliente
				TRB->LOJA,;																	//[2] Loja
				TRB->NOME,;																	//[3] Nome
				TRB->CHAPA,;																//[4] Patrimonio
				TRB->DESCRIC,;																//[5] Descricao
				IF(AllTrim(TRB->OMM)=="NULL",Space(TamSx3("ZD_NROOMM")[1]),TRB->OMM),;	//[6] OMM
				IF(AllTrim(TRB->OMM)=="NULL",Space(TamSx3("ZD_NROOMM")[1]),TRB->OMMREM),;	//[7] OMM REM
				StoD(TRB->DATAINS),;														//[8] Data Inst.		
				StoD(TRB->DATAREM),;														//[9] Data Rem.
				IF(AllTrim(TRB->STATUS)=="1","Ativo","Inativo"),;							//[10] Status
				TRB->ENDERECO,;			  													//[11] Endereco
				IF(AllTrim(TRB->STATUS)=="1",Transform(TRB->ZQ_VALOR,PesqPict("CNB","CNB_VLUNIT")),Transform(0,PesqPict("CNB","CNB_VLUNIT"))) ,;					//[12] Valor 
				TRB->LOCFIS,;																//[13] Local instalacao
				TRB->N1_PRODUTO,;															//[14] Cod Produto
				TRB->REC,;																	//[15] Recno do patrimonio
				cTpServ})																	//[16] Tipo de contrato/servico
			
	TRB->(dbSkip())
End
TRB->(dbCloseArea())


If Len(aDados) == 0
	AADD(aDados, {PADR("",TamSx3("A1_COD")[1]," "),;					//[1] Cliente
						PADR("",TamSx3("A1_LOJA")[1]," "),;			//[2] Loja
						PADR("",TamSx3("A1_NOME")[1]," "),;			//[3] Nome
						PADR("",TamSx3("N1_CHAPA")[1]," "),;			//[4] Patrimonio
						PADR("",TamSx3("N1_DESCRIC")[1]," "),;			//[5] Descricao
						PADR("",TamSx3("UC_CODIGO")[1]," "),;			//[6] OMM 
						PADR("",TamSx3("UC_CODIGO")[1]," "),;			//[7] OMM Rem 
						StoD("  /  /  "),;								//[8] Data Inst.
						StoD("  /  /  "),;								//[9] Data Rem.
						Space(7),;										//[10] Status
						PADR("",TamSx3("A1_END")[1]," "),;				//[11] Endereco
						Transform(0,PesqPict("CNB","CNB_VLUNIT")),;	//[12] Valor 
						Space(TamSX3("Z8_LOCFIS1")[1]),;				//[13] Local instalacao
						Space(TamSx3("B1_COD")[1]),;					//[14] Cod Produto
						0,;												//[15] Recno
						Space(10)})										//[16] Tipo de contrato/servico
EndIf					


Return



// Filtra pelo patrimonio escolhido
Static Function FindPatri(cNumChapa)

Local nRes := 0

abrowse := {}

For nI := 1 To Len(aDados)
	//ignora o registro separador
	If aDados[nI][15] == 0
		Loop
	EndIf
	If alltrim(adados[nI][4]) == AllTrim(cNumChapa)
		aadd(abrowse, adados[nI])
	EndIf
Next nI

if len(abrowse) == 0
	abrowse := aclone(adados)
endIf                        

oTcBrowse:SetArray(aBrowse)
oTcBrowse:bLine := {||{ aBrowse[oTcBrowse:nAt,04],;	// [1] Patrimonio
						aBrowse[oTcBrowse:nAt,14],;		// [2] Cod Produto
						aBrowse[oTcBrowse:nAt,05],;		// [3] Descricao Patrimonio
						aBrowse[oTcBrowse:nAt,06],;		// [4] Omm instalacao
						aBrowse[oTcBrowse:nAt,07],;		// [5] Omm remocao
						aBrowse[oTcBrowse:nAt,08],;		// [6] Data instalacao
						aBrowse[oTcBrowse:nAt,09],;		// [7] Data remocao
						aBrowse[oTcBrowse:nAt,10],;		// [8] Status
						aBrowse[oTcBrowse:nAt,02],;		// [9] Loja
						aBrowse[oTcBrowse:nAt,16],;		// [10] Tipo contrato/servico
						aBrowse[oTcBrowse:nAt,13],;		// [11] Local fisico
						aBrowse[oTcBrowse:nAt,12] }}	// [12] Valor


otcbrowse:refresh(.t.) 
oTcBrowse:SetFocus()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Visual  ºAutor  ³Jackson E. de Deus    º Data ³  08/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualiza o registro posicionado.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Visual()

Local aArea := GetArea()
Local nRecno := aBrowse[oTcBrowse:nAt][nPosRecno]

If nRecno == 0
	Return
EndIf

dbSelectArea("SN1")
dbGoto(nRecno)
AxVisual("SN1",nRecno,2)

RestArea(aArea)

Return


//Atualiza o texto referente ao endereco do cliente
Static Function fHelp()

oSay6:SetText(aBrowse[oTcBrowse:nAt][11]) 
oSay8:SetText(CN9->CN9_NUMERO) 
    
oDlg1:Refresh()


return



// Gera a planilha em Excel
Static Function Planilha()

Local oExcel := FWMSEXCEL():New()
Local cDir := ""
Local cArqXls := "Patrimonios.xml"

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet("Patrimonios") 

oExcel:AddTable ("Patrimonios","Patrimonios")

oExcel:AddColumn("Patrimonios","Patrimonios","Patrimonio",1,1)
oExcel:AddColumn("Patrimonios","Patrimonios","Produto",2,1)
oExcel:AddColumn("Patrimonios","Patrimonios","Descrição",3,1)
oExcel:AddColumn("Patrimonios","Patrimonios","OMM inst.",1,1)
oExcel:AddColumn("Patrimonios","Patrimonios","OMM rem.",1,1)
oExcel:AddColumn("Patrimonios","Patrimonios","Data inst.",1,1)                                                                 
oExcel:AddColumn("Patrimonios","Patrimonios","Data rem.",1,1)
oExcel:AddColumn("Patrimonios","Patrimonios","Status",1,1)
oExcel:AddColumn("Patrimonios","Patrimonios","Loja",1,1)
oExcel:AddColumn("Patrimonios","Patrimonios","Tipo Contrato",1,1)
oExcel:AddColumn("Patrimonios","Patrimonios","Local Fisico",1,1)                                                                                                                                                                                                                                                                                                                                      
oExcel:AddColumn("Patrimonios","Patrimonios","Valor",1,2)                                                                 

For nI := 1 To Len(aBrowse)
	oExcel:AddRow("Patrimonios","Patrimonios",{aBrowse[nI][4],; 	//patrimonio
											aBrowse[nI][13],;		//produto
											aBrowse[nI][5],;		//descricao
											aBrowse[nI][6],;		//OMM inst
											aBrowse[nI][7],;		//OMM rem
											dtoc(aBrowse[nI][8]),;	//Data inst
											dtoc(aBrowse[nI][9]),;	//Data rem
											aBrowse[nI][10],;		//Status
											aBrowse[nI][2],;		//Loja
											aBrowse[nI][16],;		//Tipo Contrato/servico											
											aBrowse[nI][13],;		//Local fisico
											aBrowse[nI][12]})		//valor
Next nI

oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTCTAC02","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTCTAC02", 'MsExcel não instalado. ' +CRLF +'O arquivo está em: '+cDir )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  


Return