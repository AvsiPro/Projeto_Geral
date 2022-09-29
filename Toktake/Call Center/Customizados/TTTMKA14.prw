#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA14  บAutor  ณJackson E. de Deus  บ Data ณ  19/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela de atualizacao de OMM.                                 บฑฑ
ฑฑบ          ณMostra somente a OMM pendente para o grupo do usuario.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMKA14()

Local aDimension	:= MsAdvSize()
Local cTitulo		:= "Atualiza็ใo - OMM"
Local oOk			:= LoadBitMap(GetResources(), "BR_VERDE")
Local oNo			:= LoadBitMap(GetResources(), "BR_VERMELHO")
Local oVazio		:= LoadBitMap(GetResources(), "BR_PRETO")
Private nNumRecno	:= 0
Private oTcBrowse	     
Private oDlg1 
Private aBrowse
Private aDados		:= {}
Private cNumTMK		:= Space(TamSx3("UC_CODIGO")[1])

If cEmpAnt <> "01"
	Return
EndIf

// Busca os dados
Processa({|| fRetDados()   },"Buscando registros, aguarde..")

aBrowse := aCLone(aDados)

oDlg1 := MSDialog():New(110,234,470,890,cTitulo,,,.F.,,,,,,.T.,,,.T. ) 

	oSay  := TSay():New(002,002,{|| "Atendimentos de OMM Pendentes"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	
	oGroup := TGroup():New(015,002,148,330,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F.)
	
	oTcBrowse := TCBrowse():New(017,005,322,130,,,{5,10,5,5,5,5,15,5},oGroup,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.F.,)
	oTcBrowse:SetArray(aBrowse)
	
	oTcBrowse:AddColumn(TCColumn():New(' '			,{|| IF(aBrowse[oTcBrowse:nAt,09]<>0,If(aBrowse[oTcBrowse:nAt,01],oOk,oNo),oVazio) },"@BMP",,,,,.T.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('Atendimento',{|| aBrowse[oTcBrowse:nAt,02]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('Data'		,{|| aBrowse[oTcBrowse:nAt,03]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('Cliente'	,{|| aBrowse[oTcBrowse:nAt,04]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('Loja'		,{|| aBrowse[oTcBrowse:nAt,05]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('Nome'		,{|| aBrowse[oTcBrowse:nAt,06]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('Uf'			,{|| aBrowse[oTcBrowse:nAt,10]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	
	oTcBrowse:bWhen			:= { || Len(aBrowse) > 0 }     
	oTcBrowse:bLDblClick	:= {|| Executa()}
	
	oTcBrowse:nScrollType := 1 //SCROLL VRC	  
		
	
	@ 160,005 MSGET cNumTMK	PICTURE "@!"	OF oDlg1 SIZE 040,008 PIXEL
	oSBtn3 := TButton():New( 015,012,"Pesquisar",oDlg1,{|| Busca()},45,18 )
	
	oSBtn1 := TButton():New( 015,057,"Atender",oDlg1,{|| Executa()},45,18 )
	oSBtn2 := TButton():New( 015,070,"Sair",oDlg1,{|| oDlg1:End()},45,18 )
	
	oDlg1:Refresh()
oDlg1:Activate(,,,.T.)                                                                                                                                                                   

Return

// Busca a OMM informada
Static Function Busca()

For nI := 1 To Len(aBrowse) 
	If AllTrim(aBrowse[nI][2]) == AllTrim(cNumTMK)
		oTcBrowse:GoPosition(nI)
	EndIf
Next nI

Return
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecuta  บAutor  ณJackson E. de Deus   บ Data ณ  19/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta a funcao de atualizacao da OMM - U_TTTMKA04()       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Executa()

Local lRetOper := .F.

nNumRecno := aBrowse[oTcBrowse:nAt][9]

If nNumRecno == 0
	Return
EndIf

dbSelectArea("SUC")
dbGoTo(nNumRecno)

lRetOper := U_TTTMKA04()

If Valtype(lRetOper) == "L"
	If lRetOper
		oTcBrowse:aArray[oTcBrowse:nAt][1] := .T.	
		oTcBrowse:Refresh()
	EndIf
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRetDados  บAutor  ณJackson E. de Deus บ Data ณ  19/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca os dados das OMMs                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fRetDados()

Local cQuery := ""
Local cAssOMM := SuperGetMV("MV_XTMK002",.T.,"")
Local aGrpResp := {}
Local aGrpUsr := {}
Local nCount := 0

//aGrpUsr := UsrRetGRP(__cUserID)
PswOrder(1)	// ordem de pesquisa - por usuario
If PswSeek(__cUserID, .T.)
	aGrpUsr := PswRet(1)[1][10]	// grupos do usuario
EndIf	
		
// monta query
cQuery += "SELECT DISTINCT " +CRLF
cQuery += "SUC.UC_CODIGO CODIGO,  " +CRLF
cQuery += "SUC.UC_DATA DATA,   " +CRLF
cQuery += "SUBSTRING(SUC.UC_CHAVE,1,6) CLIENTE, " +CRLF
cQuery += "SUBSTRING(SUC.UC_CHAVE,7,4) LOJA, " +CRLF

cQuery += "( " +CRLF
cQuery += "		SELECT  " +CRLF
cQuery += "		A1_NOME  " +CRLF
cQuery += "		FROM " +RetSqlName("SA1") +" SA1  " +CRLF
cQuery += "		WHERE A1_COD = SUBSTRING(SUC.UC_CHAVE,1,6)  " +CRLF
cQuery += "		AND A1_LOJA = SUBSTRING(SUC.UC_CHAVE,7,4)  " +CRLF
cQuery += " 	AND D_E_L_E_T_ = '' " +CRLF
cQuery += "	) NOME, " +CRLF

cQuery += "	(" +CRLF
cQuery += "		SELECT " +CRLF
cQuery += "		A1_EST " +CRLF
cQuery += "		FROM " +RetSqlName("SA1") +" SA1 " +CRLF
cQuery += "		WHERE A1_COD = SUBSTRING(SUC.UC_CHAVE,1,6) " +CRLF
cQuery += "		AND A1_LOJA = SUBSTRING(SUC.UC_CHAVE,7,4) " +CRLF
cQuery += " 	AND D_E_L_E_T_ = '' " +CRLF
cQuery += "	) ESTADO," +CRLF

cQuery += "SUC.UC_CODCONT CONTATO, " +CRLF
cQuery += "SUC.UC_INICIO INICIO, " +CRLF
cQuery += "SUC.R_E_C_N_O_ REC, " +CRLF   
cQuery += "SUD.UD_OPERADO RESP " +CRLF

cQuery += "FROM " +RetSqlName("SUC") +" SUC " +CRLF

cQuery += "INNER JOIN " +RetSqlName("SUD") +" SUD ON " +CRLF
cQuery += "SUC.UC_FILIAL = SUD.UD_FILIAL " +CRLF
cQuery += "AND SUC.UC_CODIGO = SUD.UD_CODIGO " +CRLF
cQuery += "AND SUC.D_E_L_E_T_ = SUD.D_E_L_E_T_ " +CRLF

cQuery += "WHERE " +CRLF
//cQuery += "SUC.UC_FILIAL = '"+xFilial("SUC") +"' " +CRLF
cQuery += "SUD.UD_ASSUNTO = '"+cAssOMM+"' " +CRLF		// somente OMM
//cQuery += "AND SUD.UD_SOLUCAO = '"+cGrpFilial+"' "+CRLF
cQuery += "AND SUC.UC_STATUS = '2' " +CRLF					// somente pendente
cQuery += "AND SUC.D_E_L_E_T_ = '' " +CRLF
cQuery += "AND SUC.UC_CODCANC = '' " +CRLF					// Nao trazer os cancelados


cQuery += "ORDER BY UC_DATA DESC "

cQuery := ChangeQuery(cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                   

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()
While !EOF()
	nCount++
	dbSkip()
End

            
dbGoTop()
ProcRegua(nCount)
While !EOF()
	IncProc("Verificando atendimentos")
	// Grupo do responsavel da OMM
	//aGrpResp := UsrRetGRP(TRB->RESP)
	PswOrder(1)	// ordem de pesquisa - por usuario
	If PswSeek(TRB->RESP, .T.)
		aGrpResp := PswRet(1)[1][10]	// grupos do usuario
	EndIf	
		
	If Len(aGrpUsr) > 0 .And. Len(aGrpResp) > 0            
		For nI := 1 To Len(aGrpResp)
			For nJ := 1 To Len(aGrpUsr)                                   
				If aGrpUsr[nJ] == aGrpResp[nI]
					AADD(aDados, {.F.,;
									TRB->CODIGO,;
									StoD(TRB->DATA),;
									TRB->CLIENTE,;
									TRB->LOJA,;
									TRB->NOME,;
									TRB->CONTATO,;
									TRB->INICIO,;
									TRB->REC,;
									TRB->ESTADO,;
									TRB->RESP})
				EndIf
			Next nJ                     
		Next nI
	EndIf
	
	dbSkip()
End
dbCloseArea()


If Len(aDados) == 0
	AADD(aDados, {.F.,;
					"",;
					StoD(""),;
					"",;
					"",;
					"",;
					"",;
					"",;
					0,;
					"",;
					""})
EndIf


Return