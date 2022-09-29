#include "protheus.ch"
#INCLUDE "RWMAKE.CH"
#include "topconn.ch"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMK01G  บAutor  ณJackson E. de Deus   บ Data ณ  14/06/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de escolha da Tarefa.			                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function TTTMK01G()

Local alArea	:= GetArea()
Local oLbx
Local cTitulo	:= "Cadastro de Tarefas"
Local aDados
Local oButton
Local oButton2
Local oDlg
Local cTarefa	:= ""
Local cCoRelac	:= ""                                             
Local nPosAssu
Local nPosOCorr
Local cAssOMM	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK002",.T.,"000007"),"")
Local cOcoInst	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK003",.T.,"000139"),"")
Local cOcoRem	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK004",.T.,"000140"),"")
Local cTipo		:= ""	// Tipo - INSTALACAO ou REMOCAO
Local lIncluir	:= .f.
Local aFields	:= {}
Local lVldFields := .F.

If cEmpAnt <> "01"
	Return
EndIF
                
dbSelectArea("SUD")
nPosAssu	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_ASSUNTO"}) 
nPosOCorr	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_OCORREN"})

// Se o assunto nao for OMM sai fora da funcao
If !aCols[n][nPosAssu] $ cAssOMM
	Return
EndIf

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ•ฝ•ฝฟ
//ณVerifica existencia dos campos customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ•ฝ•ฝู
*/
AADD(aFields, {"SUD"})	//[1]
AADD(aFields, {"SZ8"})	//[2]
AADD(aFields, {"SZ9"})	//[3]

AADD(aFields[1], {"UD_XTAREF",;	//[1][2][1]
				"UD_XTARSEQ",;	//[1][2][2]
				"UD_XLOCFIS"})	//[1][2][3]

AADD(aFields[2], {"Z8_FILIAL",;
					"Z8_CLIENTE",;
					"Z8_LOJA",;
					"Z8_CODPA",;
					"Z8_LOCFIS1"})
					
AADD(aFields[3], {"Z9_COD",;
				"Z9_DESC"})

If FindFunction("U_TTTMKA06")
	lVldFields := U_TTTMKA06(aFields)
	If ValType(lVldFields) == "L"
		If !lVldFields
			Return
		EndIf
	EndIf	
EndIf


// instalacao
If aCols[n][nPosOcorr] $ cOcoInst
	cTipo := "INSTALACAO"                                    
// remocao
ElseIf aCols[n][nPosOcorr] $ cOcoRem
	cTipo := "REMOCAO"
EndIf

// Busca os dados             
aDados := RetDados(cTipo)       

 
If Len(aDados) == 0
	// Nao existem tarefas cadastradas
	ShowHelpDlg("TTTMK01G",{"Vazio."},5,{"Cadastre as tarefas na rotina de Cadastro de Tarefas."},5)
	Return
EndIf


DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 250,498 PIXEL
	
	@ 05, 05  Say "Selecione a tarefa"		Pixel Of oDlg
	@ 18,00 LISTBOX oLbx FIELDS HEADER "C๓digo", "Tarefa" SIZE 250,090 OF oDlg PIXEL
	
	oLbx:SetArray( aDados )
	oLbx:bLine := {|| {aDados[oLbx:nAt,1],;		// Codigo
						aDados[oLbx:nAt,2]} }	// Descricao
						
	// Na escolha, atribui o valor na variavel cProd
    	oLbx:bChange := {|| cTarefa := aDados[oLbx:nAt,1] }
        oLbx:blDblClick := { || AtuCampos(cTarefa), oDlg:End() }
        
	oButton2 := tButton():New(110,185,'Ok',oDlg,{ || AtuCampos(cTarefa), oDlg:End() },30,12,,,,.T.)
	oButton := tButton():New(110,220,'Cancelar',oDlg,{ || oDlg:End()},30,12,,,,.T.)
	
ACTIVATE MSDIALOG oDlg CENTER


oGetTmk:oBrowse:Refresh(.T.) 
oGetTmk:Refresh()  

RestArea(alArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetDados  บAutor  ณJackson E. de Deus   บ Data ณ  14/06/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca os dados do cadastro de tarefas                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetDados(cTipo)
      
Local cQuery := ""
Local aDados := {}
Local aFields := {}
Local lVldFields := .F.

//If cTipo == "INSTALACAO"
	cQuery := "SELECT DISTINCT " +CRLF 
	cQuery += "Z9_COD, Z9_DESC" +CRLF
	cQuery += "FROM "+RetSqlName("SZ9") +" " +CRLF
	cQuery += "WHERE " +CRLF                      
	cQuery += "Z9_FILIAL = '"+xFilial("SZ9")+"' " +CRLF 
	cQuery += "AND Z9_COD >'000059' "+CRLF
	cQuery += "AND D_E_L_E_T_ = '' "
	
	If Select("TRB") > 0 
		TRB->(dbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TRB"
	
	dbSelectArea("TRB")
	dbGoTop()
	While !EOF()
	   	AADD(aDados, {	TRB->Z9_COD,;		// Codigo da Tarefa
	   					TRB->Z9_DESC})		// Descricao
	   	TRB->(dbSkip())
	End
	TRB->(dbCloseArea())                                          
	
//EndIf

Return aDados



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuCampos บAutor  ณJackson E. de Deus   บ Data ณ  14/06/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAlimenta o campo de observacao e campos do grid.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuCampos(cTarefa)							

Local alArea
Local alAreaSUD
Local cQuery	:= ""                                                               
Local cDtDia	:= ""
Local cTime		:= ""
Local cHora		:= ""
Local cMin		:= ""
Local cSeg		:= ""
Local cString	:= ""
Local cMsgIni	:= ""
Local aDados	:= {}
Local cCoRelac	:= ""
Local cSeqNew	:= ""
Local aUser		:= {}
Local cCodUsr	:= ""
Local cNomeUsr	:= ""
Local cDtRet	:= ""
Local cCodOcorr := ""
Local cTabAssunto := "T1"
Local cMaskSeq	:= "#" 
Local cPrazo	:= ""
Local nDias		:= 0 
Local cLocFis	:= ""
Local aArea
Local nPosAcao
Local nPosDesc
Local nPosResp
Local nPosNome
Local nPosOCorr
Local nPosTar
Local nPosSeq
Local nPosLocUD
Local lUpd		:= .F.
Local lObsOk	:= .F.
Local cSeqAtu	:= IIF(INCLUI,"001","")
Local aFields := {}
Local lVldFields := .F.
                  
If AllTrim(cTarefa) == ""
	Return
EndIf

dbSelectArea("SUD")
alArea := GetArea()
         
nPosAcao	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_SOLUCAO"})	// solucao
nPosDesc	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_DESCSOL"})	// desc solucao
nPosResp	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_OPERADO"})	// responsavel
nPosNome	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_DESCOPE"})	// nome responsavel
nPosOCorr	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_OCORREN"})	// ocorrencia
nPosTar		:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XTAREF"})	// tarefa
nPosSeq		:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XTARSEQ"})	// sequencia
nPosLocUD	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XLOCFIS"})	// Local fisico da instalacao

If INCLUI	
	cMsgIni	:= cMaskSeq +"000 INICIO CHAMADO " +cDtDia +" " +cTime +" " +cUserName
	cString += cMsgIni +CRLF
EndIf

cDtDia := Date()
cDtDia := DtoC(cDtDia)
cTime := Time()
cHora := SubStr(cTime, 1, 2)
cMin := SubStr(cTime, 4, 2)
cSeg := SubStr(cTime, 7, 2)


// Query
cQuery := "SELECT " +CRLF 
cQuery += "Z9_FILIAL, Z9_COD, Z9_DESC, Z9_SEQ, Z9_TAREFA, Z9_AREA, Z9_SLA, Z9_CORELAC, " +CRLF
cQuery += "UQ_DESC, UQ_CODRESP, UQ_EMAIL " +CRLF
cQuery += "FROM "+RetSqlName("SZ9") +" SZ9 " +CRLF

cQuery += "INNER JOIN "+RetSqlName("SUQ") +" SUQ ON " +CRLF 
cQuery += "SZ9.Z9_CORELAC = SUQ.UQ_SOLUCAO " +CRLF
cQuery += "AND SZ9.D_E_L_E_T_ = SUQ.D_E_L_E_T_ " +CRLF

cQuery += "WHERE " +CRLF
cQuery += "SZ9.Z9_FILIAL = '"+xFilial("SZ9")+"' " +CRLF
cQuery += "AND SZ9.Z9_COD = '"+cTarefa+"' " +CRLF 
cQuery += "AND SZ9.D_E_L_E_T_ = '' "

cQuery += "ORDER BY SZ9.Z9_SEQ "

If Select("TRB") > 0 
	TRB->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()
While !EOF()
   	AADD(aDados, {TRB->Z9_COD,;			// [1] Codigo
				 TRB->Z9_SEQ,; 			// [2] Item da tarefa
   				 TRB->Z9_TAREFA,;		// [3] Descricao
   				 TRB->Z9_AREA,;			// [4] Area responsavel
   				 TRB->Z9_SLA,;			// [5] Prazo SLA
   				 TRB->Z9_CORELAC,;		// [6] CoRelacao
   				 TRB->UQ_DESC,;			// [7] Descricao
   				 TRB->UQ_CODRESP,;		// [8] Cod responsavel
   				 TRB->UQ_EMAIL})		// [9] Email responsavel
   			   				 
   	TRB->(dbSkip())
End
TRB->(dbCloseArea())                                          


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHฟ
//ณAtualiza informacoes do registro                            ณ
//ณPreenche a acao, descricao, responsavel, tarefa, sequencia  ณ
//ณe no cabecalho preenche a observacao, data de retorno e horaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHู
*/
//If INCLUI
	If Len(aDados) > 0
		For nI := 1 To Len(aDados)
			For nJ := 1 To Len(aDados[nI])
				
				/*
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVerifica o codigo da tarefa e grava dados no Gridณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				*/
				If nJ == 1
					If aDados[nI][1] == cTarefa .And. aDados[nI][2] == AllTrim(cSeqAtu)
						cCoRelac := aDados[nI][6]
						aCols[n,nPosAcao] := cCoRelac		// preenche a acao
						aCols[n,nPosDesc] := aDados[nI][7]	// preenche a descricao
						aCols[n,nPosResp] := aDados[nI][8]	// preenche o responsave0l
							
						
						/*
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณpreenche o nome do responsavelณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						*/
						PswOrder(1)
						If PswSeek(aCols[n,nPosResp])
							aUser := PswRet(1)
							If Len(aUser) > 0
								aCols[n][nPosNome] := aUser[1][2]
							Else
								aCols[n][nPosNome] := aUser[1][2] := ""
							Endif
						Endif
						
						aCols[n,nPosTar] := cTarefa			// preenche a tarefa
						aCols[n,nPosSeq] := aDados[nI][2] 	// preenche a sequencia
					EndIf
					Loop
				EndIf
		  
				/*
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤTฟ
				//ณVerifica os campos para preencher o campo de observacao - UC_OBS        ณ
				//ณIMPORTANTE:                                                             ณ
				//ณDe inicio foi desenvolvido na premissa de que todos os itens            ณ
				//ณusarao a mesma tarefa.                                                  ณ
				//ณPor isso o Campo Observacao do cabecalho vai levar somente uma sequenciaณ
				//ณde tarefa.                                                              ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤTู
				*/
		 		If nJ > 1 .And. nJ <= 5
					If ValType(aDados[nI][nJ]) == "N"
						cString += AllTrim(Str(aDados[nI][nJ])) +" " +"horas" +CRLF
					Else
						If nJ == 2 // Sequencia - adiciona mascara no inicio
							cString += cMaskSeq +AllTrim(aDados[nI][nJ]) +" "	
						Else
							cString += AllTrim(aDados[nI][nJ]) +" "	
						EndIf
					EndIf   
				EndIf
			Next nJ	
		Next nI                        
		                           
		cCodOcorr := aCols[n,nPosOCorr]
		cPrazo := Posicione("SU9",2,xFilial("SU9")+cCodOcorr,"U9_PRAZO")
		nDias := Val(cPrazo)/24
		cDtRet := dDatabase +nDias
		
		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤnฟ
		//ณAtribui valor aos campos Data de retorno, Hora de retorno e Observacaoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤnู
		*/
		If Len(aCols) == 1
			M->UC_PENDENT := cDtRet
			M->UC_HRPEND := "08:00"
			M->UC_OBS := ""
			M->UC_OBS += cString		
		EndIf
		
		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtribui o local fisicoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		*/
		cLocFis := fLocal()
		aCols[n,nPosLocUD] := cLocFis			
	EndIf
//EndIf
	     
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfLocal    บAutor  ณJackson E. de Deus   บ Data ณ  14/06/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para escolha do local fisico de instalacao.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fLocal()
                                                
Local alArea	:= GetArea()
Local nOpc		:= 2	//GD_INSERT+GD_DELETE+GD_UPDATE
Local aAlter	:= {"Z8_CLIENTE","Z8_CODPA"}
Local nPosCli
Local nPosLj
Local nPosPACli
Local nPosLoc
Local lVldFields := .F.
Local aFields	:= {}
//Local cLocFis	:= ""
Private aCols	:= {}
Private aHeader	:= {}
Private aDados	:= {}
Private noBrw1	:= 0
Private oDlg1
Private oSay1
Private oGrp1
Private oBrw1
Private oSBtn1
Private oSBtn2
		
LoadHead()
If Len(aHeader) == 0
	ShowHelpDlg("TTTMK01G",{"Array aHeader vazio."},5,{"Houve problema na gera็ใo do aHeader."},5)
	Return
EndIf

fSeekLoc()
If Len(aCols) == 0
	ShowHelpDlg("TTTMK01G",{"Array aCols vazio."},5,{"Houve problema na gera็ใo do aCols."},5)
	Return
EndIf

nPosCli		:= Ascan(aHeader,{|x|AllTrim(x[2])=="Z8_CLIENTE"})
nPosLj		:= Ascan(aHeader,{|x|AllTrim(x[2])=="Z8_LOJA"})
nPosPACli	:= Ascan(aHeader,{|x|AllTrim(x[2])=="Z8_CODPA"})
nPosLoc		:= Ascan(aHeader,{|x|AllTrim(x[2])=="Z8_LOCFIS1"})

oDlg1 := MSDialog():New( 178,247,503,885,"Locais fํsicos",,,.F.,,,,,,.T.,,,.T. )
oSay1 := TSay():New( 002,002,{||"Escolha o local fํsico para instala็ใo"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)
oGrp1 := TGroup():New( 012,002,144,319,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oBrw1 := MsNewGetDados():New(014,004,142,318,nOpc,'AllwaysTrue()','AllwaysTrue()','',aAlter,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp1,aHeader,aCols,{||oBrw1:aCols := aCols} )
oBrw1:bChange := {|| cLocFis := oBrw1:Acols[oBrw1:nAt,nPosLoc] }
oBrw1:OnChange()
oBrw1:Refresh(.T.)
oBrw1:ForceRefresh(.T.)

oSBtn1 := SButton():New( 148,256,1,{|| oDlg1:End()},oDlg1,.T.,"", )
oSBtn2 := SButton():New( 148,292,2,{|| oDlg1:End()},oDlg1,.T.,"", )

oDlg1:Activate(,,,.T.)

Return(oBrw1:Acols[oBrw1:nAt,nPosLoc])



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadHead  บAutor  ณJackson E. de Deus   บ Data ณ  14/06/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera o array aHeader.								          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LoadHead()

DbSelectArea("SX3")
DbSetOrder(1)
dbGoTop()
DbSeek("SZ8")
While !EOF() .and. SX3->X3_ARQUIVO == "SZ8"
   If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. AllTrim(SX3->X3_CAMPO) $ "Z8_CLIENTE|Z8_LOJA|Z8_CODPA|Z8_LOCFIS1"
      AADD(aHeader,{Trim(X3Titulo()),;
           SX3->X3_CAMPO,;
           SX3->X3_PICTURE,;
           SX3->X3_TAMANHO,;
           SX3->X3_DECIMAL,;
           "",;
           "",;
           SX3->X3_TIPO,;
           "",;
           SX3->X3_Context } )
   EndIf
   DbSkip()
End

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSeekLoc  บAutor  ณJackson E. de Deus   บ Data ณ  14/06/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera o array aCols.								          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fSeekLoc()

Local aAux		:= {}
Local cQuery	:= ""
Local cCliente	:= ""
Local cLoja		:= ""

If (M->UC_ENTIDAD == "SA1")			//Cliente
	cCliente   := SubStr(M->UC_CHAVE,1,TamSx3("A1_COD")[1])
	cLoja      := SubStr(M->UC_CHAVE,TamSx3("A1_COD")[1]+1,TamSx3("A1_LOJA")[1])
EndIf	


// Monta Query
cQuery += "SELECT Z8_CLIENTE, Z8_LOJA, Z8_CODPA, Z8_LOCFIS1 " +CRLF
cQuery += "FROM " +RetSqlName("SZ8") +" SZ8 " +CRLF
cQuery += "WHERE " +CRLF                           
cQuery += "Z8_CLIENTE = '"+cCliente+"' " +CRLF
cQuery += "AND Z8_LOJA = '"+cLoja+"' " +CRLF
cQuery += "AND D_E_L_E_T_ = '' " +CRLF
cQuery += "ORDER BY Z8_CLIENTE, Z8_LOJA "

cQuery := ChangeQuery(cQuery)
MemoWrite("fSeekLoc.sql",cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf           
                       
TCQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
	AADD(aDados,{TRB->Z8_CLIENTE,;		// [1] Cliente
				TRB->Z8_LOJA,;			// [2] Loja
				TRB->Z8_LOCFIS1,;		// [3] Descricao do Local
				TRB->Z8_CODPA})			// [4] Codigo da PA
				
	dbSkip()
End While
TRB->(dbCloseArea())

If Len(aDados) == 0
	AAdd(aCols, Array(Len(aHeader)+1))
	nLin := Len(aCols)
	For nCol := 1 To Len(aHeader)
		aCols[nLin][nCol] := CriaVar(aHeader[nCol][2], .T.)
	Next nCol                
	aCols[nLin][Len(aHeader)+1] := .F.	
Else	
	For nI := 1 To Len(aDados)
		AAdd(aCols, Array(Len(aHeader)+1))
		nLin := Len(aCols)
		For nCol := 1 To Len(aHeader)
			If aHeader[nCol][10] == "R"
				aCols[nLin][nCol] := aDados[nI][nCol]
			Else
				aCols[nLin][nCol] := CriaVar(aHeader[nCol][2], .T.)
			EndIf
		Next nCol                 
		// inicializa a ultima coluna para o controle da getdados: deletado ou nao
		aCols[nLin][Len(aHeader)+1] := .F.	
	Next nI
EndIf


Return