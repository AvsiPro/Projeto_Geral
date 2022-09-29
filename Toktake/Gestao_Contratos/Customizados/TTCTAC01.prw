#include "protheus.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCTAC01  ºAutor  ³Jackson E. de Deus  º Data ³  08/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Mostra o relacionamento entre contratos.                    º±±
±±º          ³Executado pelo PE CTA100MNU                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao de Contratos                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTCTAC01()

Local cTitulo		:= "Relacionamento Contrato Pai - Contratos Filhos"
Local aArea			:= GetArea()
Local aDimension	:= MsAdvSize()
Local aObjSize		:= Array(0)
Local cNumCont		:= AllTrim(CN9->CN9_NUMERO)
Local cNomeCli		:= AllTrim(GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+CN9->CN9_CLIENT+CN9->CN9_LOJACL,1,0))
Local cTpContrato	:= CN9->CN9_XTPCNT
Local cDataIni		:= DTOC(CN9->CN9_DTINIC)
Local cDataFim		:= DTOC(CN9->CN9_DTFIM)
Local nValFat		:= Transform(0, PESQPICT("SF2","F2_VALBRUT"))
Local oFont
Local cCabec		:= "Contratos Filhos"

Private aInfo 		:= Array(0)
Private aObjects	:= Array(0)
Private aPosObj		:= Array(0)

Private aDados		:= {}
Private aBrowse 	:= {} 
Private nPosRecno	:= 1  

Private lExistPai	:= .F.
Private cContPai	:= ""

If cEmpAnt == "01"
	Return
EndIf

If AllTrim(CN9->CN9_XCNTPA) <> ""
	cContPai := CN9->CN9_XCNTPA
	cCabec := "Contrato Pai"
	lExistPai := .T.
EndIf

If cTpContrato == "1"
	cTpContrato := "Individual"
ElseIf cTpContrato == "2"
	cTpContrato := "Agrupado"
ElseIf cTpContrato == "3"
	cTpContrato := "Selecionado"	
EndIf

// busca os dados
RetDados(cNumCont)

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
oGrp1		:= TGroup():New(aPosObj[1][1],aPosObj[1][2],aPosObj[1][3],aPosObj[1][4]		,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
                             
// Textos do cabecalho
oSay1		:= TSay():New( 005,010,{|| "Nr. Contrato: "}				,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
oSay2		:= TSay():New( 005,042,{|| cNumCont}						,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,075,008)

oSay3		:= TSay():New( 005,105,{|| "Cliente: "}						,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
oSay4		:= TSay():New( 005,125,{|| cNomeCli}						,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,300,008)
     
oSay5		:= TSay():New( 020,010,{|| "Tp. Contrato: "}				,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
oSay6		:= TSay():New( 020,042,{|| cTpContrato}						,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,040,008)

oSay7		:= TSay():New( 020,105,{|| "Data Inicio: "}					,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
oSay8		:= TSay():New( 020,132,{|| cDataIni}						,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,030,008)
     
oSay9		:= TSay():New( 020,170,{|| "Data Final: "}					,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
oSay10		:= TSay():New( 020,197,{|| cDataFim}						,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,030,008)

//oSay11		:= TSay():New( 020,260,{|| "Último valor faturado: "}		,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
//oSay12		:= TSay():New( 020,300,{|| nValFat}							,oGrp1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,030,008)

// Grupo 2                      
oGrp2		:= TGroup():New(aPosObj[2][1],aPosObj[2][2],aPosObj[2][3]-15,aPosObj[2][4]	,cCabec,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )                                                                                             

oTcBrowse := TCBrowse():New(aPosObj[2][1]+6,aPosObj[2][2]+2,aPosObj[2][4]-7,aPosObj[2][3]-58,,{"Nr Contrato", "Data Inicio", "Dt Assinatura", "Data Final", "Cliente", "Loja","Nome"},{15,10,10,15,15,10,25},oGrp2,,,,,{|| Visual() },/*{ || Marca() }*/,,,,,,.F.,,.T.,{ || Len(aBrowse) > 0},.F.,,.T.,.F.,)
oTcBrowse:SetArray(aBrowse)

// Monta a linha a ser exibina no Browse
oTcBrowse:bLine := {||{ aBrowse[oTcBrowse:nAt,02],;					// Nr Contrato
						aBrowse[oTcBrowse:nAt,03],;					// Data Inicio
						aBrowse[oTcBrowse:nAt,04],;					// Dt Assinatur
						aBrowse[oTcBrowse:nAt,05],;					// Data Final
						aBrowse[oTcBrowse:nAt,06],;					// Cliente
						aBrowse[oTcBrowse:nAt,07],;					// Loja
						aBrowse[oTcBrowse:nAt,08]}}					// Nome
						
// Botoes Visualizar Contrato e Cancelar no rodape                                                                                             
oBtn	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-90, 40, 40, 'VERNOTA', , , ,{|| Visual() } , oDlg1, "Visualizar" , ,)
oBtn2	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-50, 40, 40, 'CANCEL' , , , ,{|| oDlg1:End() } , oDlg1, "Sair" , ,)

oDlg1:Activate(,,,.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Visual  ºAutor  ³Jackson E. de Deus    º Data ³  08/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualiza o contrato posicionado.                           º±±
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

dbSelectArea("CN9")
dbGoto(nRecno)
AxVisual("CN9",nRecno,2)

RestArea(aArea)

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
Static Function RetDados(cNumCont)

Local cQuery	:= ""

// monta query
cQuery += "SELECT CN9.R_E_C_N_O_ CN9REC, CN9.CN9_NUMERO, CN9.CN9_DTINIC, CN9.CN9_DTASSI, CN9.CN9_DTFIM, CN9.CN9_CLIENT, CN9.CN9_LOJACL, SA1.A1_NOME  "
cQuery += "FROM " +RetSqlName("CN9") +" CN9 "

cQuery += "INNER JOIN " +RetSqlName("SA1") + " SA1 ON "
cQuery += "CN9.CN9_CLIENT = SA1.A1_COD "
cQuery += "AND CN9.CN9_LOJACL = SA1.A1_LOJA "

cQuery += "WHERE "

cQuery += "CN9.D_E_L_E_T_ = '' "

// verifica se busca o contrato pai ou os filhos
If lExistPai
	cQuery += "AND CN9.CN9_NUMERO = '"+cContPai+"' "
Else
	cQuery += "AND CN9.CN9_XCNTPA = '"+cNumCont+"' "	
EndIf

cQuery := ChangeQuery(cQuery)

If Select("TRBCN9") > 0
	TRBCN9->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRBCN9"

dbSelectArea("TRBCN9")
dbGoTop()
While !eof()
	AADD(aDados, {TRBCN9->CN9REC,;				//[1] Recno
					TRBCN9->CN9_NUMERO,;		//[2] Numero Contrato
					StoD(TRBCN9->CN9_DTINIC),;	//[3] Data Inicio
					StoD(TRBCN9->CN9_DTASSI),;	//[4] Data assinatura
					StoD(TRBCN9->CN9_DTFIM),;	//[5] Data Final
					TRBCN9->CN9_CLIENT,;		//[6] Cliente
					TRBCN9->CN9_LOJACL,;		//[7] Loja
					TRBCN9->A1_NOME})			//[8] Nome Cliente
	TRBCN9->(dbSkip())
End
TRBCN9->(dbCloseArea())


If Len(aDados) == 0
	AADD(aDados,{0,;
				Space(TamSX3("CN9_NUMERO")[1]),;
				StoD("  /  /  "),;
				StoD("  /  /  "),;
				StoD("  /  /  "),;
				Space(TamSX3("CN9_CLIENT")[1]),;
				Space(TamSX3("CN9_LOJACL")[1]),;
				Space(TamSX3("A1_NOME")[1])})
EndIf

Return