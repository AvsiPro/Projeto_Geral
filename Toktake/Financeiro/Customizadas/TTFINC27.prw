#include "protheus.ch"
#include "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC27     ºAutor  ³Jackson E. de Deus Data ³  11/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Estorno das compensações dos títulos a receber.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTFINC27()

Local aPergs := {}
Local aRet := {}
Local cSerie := ""
Local oDlg2
Local oBtn1
Local oBtn2
Local oBtn3
Local aDimension	:= MsAdvSize()
Local aInfo 		:= Array(0)
Local aObjects		:= Array(0)             
Local aPosObj		:= Array(0)
Local oFont			:= TFont():New('Arial',,-12,.T.,.T.)
Local oAtv			:= LoadBitMap(GetResources(), "BR_VERDE")
Local oExcl			:= LoadBitMap(GetResources(), "BR_PRETO")
Local oNF			:= LoadBitMap(GetResources(), "BR_PINK")
Local oSim			:= LoadBitMap(GetResources(), "LBTIK")
Local oNao			:= LoadBitMap(GetResources(), "LBNO")

private cPrefixo := ""
private cValor := ""
PRIVATE aTitulos := {}
Private cNumNF := ""
Private cParcela := ""
Private cParcelas := ""
Private nSaldo := 0			// valor total do titulo
Private nSaldoProv := 0
Private nAbatimento := 0	// valor total dos NCC que sera considerado para abatimento
Private lAtualizou	:= .F.

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Parambox³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
aAdd(aPergs ,{1,"Nota Fiscal"	,space(TamSx3("F2_DOC")[1]),"@!",".T.","SF2",".T.",70,.F.})
aAdd(aPergs ,{1,"Serie"			,space(TamSx3("F2_SERIE")[1]),"@!",".T.","",".T.",70,.F.})

If !ParamBox(aPergs ,"Estorno de Compensação",@aRet)
	Return
EndIf
                 
cNumNF := aRet[1]
cSerie := aRet[2]


If AllTrim(cNumNF) == "" .OR. AllTrim(cSerie) == ""   
	Aviso("TTFINC27","Preencha todos os parâmetros corretamente.",{"Ok"})          
EndIf

cPrefixo := cFilAnt + Alltrim(cSerie)


cQuery := "SELECT * FROM " +RetSqlName("SE1") + " WHERE E1_NUM = '"+cNumNF+"' AND D_E_L_E_T_ = '' AND (E1_PREFIXO = '"+cPrefixo+"' OR E1_PREFIXO = 'VRC') ORDER BY E1_PREFIXO, E1_PARCELA "

If Select("TRBSE1") > 0
	TRBSE1->(dbClosearea())
EndIf

tcquery cquery new alias "TRBSE1" 

dbSelectArea("TRBSE1")
While !EOF()
	If AllTrim(TRBSE1->E1_PREFIXO) == cPrefixo .And. AllTrim(TRBSE1->E1_TIPO) == "NF"
		nSaldo := TRBSE1->E1_SALDO
	EndIf
	AADD(aTitulos, {.f.,; 							//[1] processado
					.f.,; 							//[2] marcacao
					ALLTRIM(TRBSE1->E1_PREFIXO),;	//[3]
					TRBSE1->E1_NUM,;				//[4]
					ALLTRIM(TRBSE1->E1_PARCELA),;	//[5]
					aLLTRIM(TRBSE1->E1_TIPO),;		//[6]
					TRBSE1->E1_CLIENTE,;			//[7]
					TRBSE1->E1_LOJA,;				//[8]
					TRBSE1->E1_NOMCLI,;				//[9]
					StoD(TRBSE1->E1_EMISSAO),;		//[10]
					TRBSE1->E1_VALOR,;				//[11]
					TRBSE1->E1_SALDO,;				//[12]
					TRBSE1->E1_VALLIQ})				//[13]
	dbSkip()
End

If Len(aTitulos) == 0
	AADD(aTitulos, {.f.,.f.,"","","","","","",Ctod("  /  /  "),0})
EndIf         

//nValor := aTitulos[1][11] // valor do titulo

aAdd(aObjects,{000, 010, .T., .F. })	
aAdd(aObjects,{000, 000, .T., .T. })

// Dimensiona a janela - 70% da tela
aDimension[1] := aDimension[1] * 0.70
aDimension[2] := aDimension[2] * 0.70
aDimension[3] := aDimension[3] * 0.70
aDimension[4] := aDimension[4] * 0.70
aDimension[5] := aDimension[5] * 0.70
aDimension[6] := aDimension[6] * 0.70
aDimension[7] := aDimension[7] * 0.70

                                
aInfo := {aDimension[1],aDimension[2],aDimension[3],aDimension[4], 3 /*distancia horizontal*/, 3 /*distancia vertical*/}
aPosObj := MsObjSize(aInfo,aObjects)


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a janela com os titulos a serem marcados para exclusao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
oDlg2	:= MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],"Estorno de compensação",,,.F.,,,,,,.T.,,,.T. )	
	
	oSay1 := TSay():New( aPosObj[1][1],aPosObj[1][2]+2,{|| "Marque os títulos que serão excluídos" },oDlg2,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,010)    
	oSay2 := TSay():New( aPosObj[1][1]+7,aPosObj[1][2]+2,{|| "Saldo após estorno: R$"+CVALTOCHAR(nSaldo) },oDlg2,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,010)    
	
	oList2 := TCBrowse():New(aPosObj[2][1]+6,aPosObj[2][2]+1,aPosObj[2][4]-3,aPosObj[2][3]-40,,{" "," ", "Prefixo","Titulo","Parcela","Tipo","Cliente", "Loja", "Nome","Emissão", "Valor","Saldo","Valor Liquido"},{05,05,10,10,15,15,10,15,20,10,10,10,10},oDlg2,,,,/*{|| AtuValor() }*/,{|| Marca() },/*{ || Marca() }*/,,,,,,.F.,,.T.,{ || Len(aTitulos) > 0},.F.,,.T.,.T.,)	
	oList2:nScrollType := 1 //SCROLL VRC
	oList2:SetArray(aTitulos)                                                      
	
	// Monta a linha a ser exibida no Browse                                                                                                                      
	oList2:bLine := {||{	IIF(aTitulos[oList2:nAt,06]=="NF" .And. aTitulos[oList2:nAt,03]==cPrefixo,oNF, IIF(aTitulos[oList2:nAt,01],oExcl,oAtv)  ),;		//[1] status
							IIF(aTitulos[oList2:nAt,02],oSim,oNao),;	//[1] marcado
							aTitulos[oList2:nAt,03],;					//[3] prefixo
							aTitulos[oList2:nAt,04],;					//[4] titulo
							aTitulos[oList2:nAt,05],;					//[5] parcela
							aTitulos[oList2:nAt,06],;					//[5] tipo
							aTitulos[oList2:nAt,07],;					//[6] cliente
							aTitulos[oList2:nAt,08],;					//[7] loja
							aTitulos[oList2:nAt,09],;					//[8] nome
							aTitulos[oList2:nAt,10],;					//[9] emissao
							Transform(aTitulos[oList2:nAt,11],PesqPict("SE1","E1_VALOR") ),;					//[10] valor
							Transform(aTitulos[oList2:nAt,12],PesqPict("SE1","E1_SALDO") ),;					//[10] saldo
							Transform(aTitulos[oList2:nAt,13],PesqPict("SE1","E1_VALLIQ") )	}}					//[10] valor liquido
							
	
	oBtn2	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-90, 40, 40, 'OK' , , , ,{|| Atualiza() } , oDlg2, "Atualizar" , ,)			 
	oBtn3	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-50, 40, 40, 'CANCEL' , , , ,{|| oDlg2:End() } , oDlg2, "Sair" , ,)
	
oDlg2:Activate(,,,.T.)
																	
Return



Static Function Marca()

// Considera somente os NCC
If aTitulos[oList2:nAt][06] <> "NF" .And. aTitulos[oList2:nAt,03]=="VRC"	
	If aTitulos[oList2:nAt][2]
		aTitulos[oList2:nAt][2] := .F.
		nAbatimento := nAbatimento - aTitulos[oList2:nAt][11]
	Else
		aTitulos[oList2:nAt][2] := .T.
		nAbatimento := nAbatimento + aTitulos[oList2:nAt][11]
	EndIf
EndIf                        
                                                               
nSaldoProv := nSaldo + nAbatimento
oSay2:settext("Saldo após estorno: R$"+CVALTOCHAR(nSaldoProv)) 

Return


// Atualiza os titulos
Static Function Atualiza()
nSaldo := nSaldoProv
If lAtualizou
	Aviso("TTFINC27","O estorno já foi efetuado.",{"Ok"})
	Return
EndIf

// trabalha as parcelas que serao excluidas
For nI := 1 To Len(aTitulos)
	If aTitulos[nI][06] == "NF" .And. aTitulos[nI][03]<>"VRC"	
		Loop
	EndIf
	If aTitulos[nI][02]
		cParcelas += "'" +aTitulos[nI][5] +"'" +","
	EndIf
Next nI

If SubStr(cParcelas,Len(cParcelas),1) == ","
	cParcelas := SubStr(cParcelas,1,Len(cParcelas)-1)
EndIf

                                               
BeginTran()
                              
cQuery := "UPDATE "+RetSqlName("SE1") 
cQuery += " SET D_E_L_E_T_='*', R_E_C_D_E_L_=R_E_C_N_O_ "
cQuery += " WHERE E1_NUM='"+cNumNF+"' "
cQuery += " AND D_E_L_E_T_='' "
cQuery += " AND E1_PREFIXO='VRC' AND E1_PARCELA IN ("+cParcelas+") "

If (TcSqlExec(cQuery) < 0)
	msginfo(TCSQLError())
	DisarmTransaction()
Else
	cQuery := "UPDATE " +RetSqlName("SE1") "
	cQuery += " SET E1_SALDO='"+cValToChar(nSaldo)+"',E1_VALLIQ='"+CValtochar(nSaldo)+"',E1_MOVIMEN='',E1_BAIXA='' "
	cQuery += " WHERE E1_NUM='"+cNumNF+"' AND D_E_L_E_T_='' AND E1_PREFIXO<>'VRC' AND E1_PREFIXO='"+cPrefixo+"' "
	
	If (TcSqlExec(cQuery) < 0)
		msginfo(TCSQLError())
		DisarmTransaction()
	Else
		cQuery := "UPDATE " +RetSqlName("SE5") 
		cQuery += " SET D_E_L_E_T_='*' WHERE E5_NUMERO='"+cNumNF+"' AND D_E_L_E_T_='' "
	                                     
		If (TcSqlExec(cQuery) < 0)
			msginfo(TCSQLError())
			DisarmTransaction()
		Else
			dbCommitAll()
			EndTran()
			
			For nI := 1 To Len(aTitulos)
				If aTitulos[nI][2]
					aTitulos[nI][1] := .T.
				EndIf
			Next nI
			
			lAtualizou := .T.
			
			// Salva Log na tabela SZL
			If FindFunction("U_TTGENC01")
				U_TTGENC01(xFilial(),"SIGAFIN","ESTORNO COMPENSACAO","",cNumNF,"",cusername,dtos(dATE()),time(),,"ESTORNO DA COMPENSACAO EFETUADO","","","SE1")	
				U_TTGENC01(xFilial(),"SIGAFIN","ESTORNO COMPENSACAO","",cNumNF,"",cusername,dtos(dATE()),time(),,"ESTORNO DA COMPENSACAO EFETUADO","","","SE5")	
			EndIf
			Aviso("TTFINC27","Estorno efetuado com sucesso.",{"Ok"})	
		EndIf  
	EndIf  
EndIf  

MsUnLockAll()

Return