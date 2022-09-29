#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTmkr034   บAutor  ณJackson E. de Deus  บ Data ณ  25/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de atendimentos - Call Center                     บฑฑ
ฑฑบ          ณBaseado no relatorio da Totvs - TMKR034                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Tmkr034()

Private lEnd := .f.

If !Pergunte("TMK034_2  ",.T.)
	Aviso("Criar a pergunta do relat๓rio: TMK034_2")
	Return(.F.)
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ Mv_Par01           // Entidade                               ณ
//ณ Mv_Par02           // Tipo Atendimento ATIVO RECEPTIVO AMBOS ณ
//ณ Mv_Par03           // Status Plan. Pend. Encerr. Todas       ณ
//ณ Mv_Par04           // Da Data                                ณ
//ณ Mv_Par05           // Ate a Data                             ณ
//ณ Mv_Par06           // Grava observacao                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa( { |lEnd| Relatorio(@lEnd) }, "Atendimento Telemarketing", "Pesquisando dados....")


Return(Nil)


// Gera o relatorio       
Static Function Relatorio()

Local aSetField		:= {}		// Parametros para SetField do alias principal
Local cCampos		:= ""		// Campos do alias principal para select
Local cQuery		:= ""		// Armazena a expressao da query para top
Local cStatus		:= ""
Local cDirLocal		:= "C:\TEMP\"
Local aDados		:= {}
lOCAL nCont			:= 0
Local ctipo			:= ""
Local cstat			:= ""
Local cNivel		:= ""
Local cDescNivel	:= ""
	
TkSelect("SUC", @cCampos, @aSetField)

cQuery :=	" SELECT DISTINCT	" + cCampos
If !Empty(Mv_Par01)
	If ALLTRIM(UPPER(Mv_par01)) == "SA1"
		cQuery +=	" , A1_NOME, A1_NREDUZ, A1_MUN, A1_EST "
	EndIf
EndIf

cQuery +=	", UD_ASSUNTO, UD_OCORREN, UD_DATA, UD_DTEXEC "
cQuery +=	" FROM " + RetSqlName("SUC") + " SUC"

If !Empty(Mv_Par01)
	If ALLTRIM(UPPER(Mv_par01)) == "SA1"
		cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1 ON "
		cQuery += " SA1.A1_COD = SUBSTRING(SUC.UC_CHAVE,1,6) "
		cQuery += " AND SA1.A1_LOJA = SUBSTRING(SUC.UC_CHAVE,7,4) "
		cQuery += " AND SA1.D_E_L_E_T_ = '' "
	EndIF
EndIf

// JOIN COM SUD 
cQuery += " LEFT JOIN " + RetSqlName("SUD") + " SUD ON "
cQuery += " SUD.UD_FILIAL = SUC.UC_FILIAL "
cQuery += " AND SUD.UD_CODIGO = SUC.UC_CODIGO "
cQuery += " AND SUD.D_E_L_E_T_ = '' "
	                   
cQuery +=	" WHERE	"
cQuery +=	" 		SUC.UC_DATA BETWEEN '" + DtoS(Mv_Par04) + "' AND '" + DtoS(Mv_Par05) + "' AND"
cQuery +=	" 		SUC.UC_CODCANC = '' AND"

If !Empty(Mv_Par01)
	cQuery += "		SUC.UC_ENTIDAD = '" + Mv_Par01 + "' AND"
Endif

If Mv_Par02 <> 3	// Ambos
	cQuery += "		(SUC.UC_OPERACA = '" + Str(Mv_Par02,1) + "' OR"		// Ativo ou Receptivo
	cQuery += "		SUC.UC_OPERACA = '') AND"
Endif

If Mv_Par03 <> 4	// Todas
	cQuery += "		SUC.UC_STATUS = '" + Str(Mv_Par03,1) + "' AND"		// Plan. Pend. Encerr.
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSeleciono somente chamados que nao sao compartilhamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery += " 	SUC.UC_CHAORIG = '' AND"


cQuery +=	" 		SUC.D_E_L_E_T_ = ' ' AND SUD.UD_ASSUNTO NOT IN ('000007') " +;
			" ORDER BY SUC.UC_FILIAL, SUC.UC_CODIGO" 

cQuery := ChangeQuery(cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRB"


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera o relatorio da operacao em excelณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
oExcel := FWMSEXCEL():New()

//Primeira aba - parametros
oExcel:AddworkSheet("Parametros")
oExcel:AddTable ("Parametros","Parametros")
oExcel:AddColumn("Parametros","Parametros","Parametros",1,1)
oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)

If mv_par02 == 1
	ctipo := "Ativo"
ElseIf mv_par02 == 2
	ctipo := "Receptivo"
Else 
	ctipo := "Ambos"
EndIf		        

If mv_par03 == 1
	cstat := "Planejada"
ElseIf mv_par03 == 2
	cstat := "Pendente"
Else 
	cstat := "Todas"
EndIf	
		

oExcel:AddRow("Parametros","Parametros",{"Entidade: ", mv_par01 } )
oExcel:AddRow("Parametros","Parametros",{"Tipo de atendimento: ", ctipo} )
oExcel:AddRow("Parametros","Parametros",{"Status: " , cstat} )
oExcel:AddRow("Parametros","Parametros",{"Data de: " , DtoC(mv_par04)} )
oExcel:AddRow("Parametros","Parametros",{"Data ate: " , DtoC(mv_par05)} )
   
//Segunda aba - patrimonios
oExcel:AddworkSheet("TMK")
oExcel:AddTable ("TMK","TMK")
oExcel:AddColumn("TMK","TMK","Filial",1,1)
oExcel:AddColumn("TMK","TMK","Ra",1,1)
oExcel:AddColumn("TMK","TMK","Contato",1,1)
oExcel:AddColumn("TMK","TMK","Nivel",1,1)
oExcel:AddColumn("TMK","TMK","Data",1,1)
oExcel:AddColumn("TMK","TMK","Cliente",1,1)
oExcel:AddColumn("TMK","TMK","Loja",1,1)
oExcel:AddColumn("TMK","TMK","Razao social",1,1)
oExcel:AddColumn("TMK","TMK","Nome fantasia",1,1)
oExcel:AddColumn("TMK","TMK","Midia",1,1)
oExcel:AddColumn("TMK","TMK","Comunicacao",1,1)
oExcel:AddColumn("TMK","TMK","Cidade",1,1)
oExcel:AddColumn("TMK","TMK","Estado",1,1)
oExcel:AddColumn("TMK","TMK","Departamento",1,1)
oExcel:AddColumn("TMK","TMK","Assunto",1,1)
oExcel:AddColumn("TMK","TMK","Ocorrencia",1,1)
IIF(mv_par06==1, oExcel:AddColumn("TMK","TMK","Observacao",1,1), ) 
oExcel:AddColumn("TMK","TMK","Status",1,1)
oExcel:AddColumn("TMK","TMK","Cod. encerramento",1,1)
oExcel:AddColumn("TMK","TMK","Descricao do encerramento",1,1)
oExcel:AddColumn("TMK","TMK","Operador",1,1)
oExcel:AddColumn("TMK","TMK","Data encerramento",1,1)
   

dbSelectArea("TRB")
dbGoTop()
While !EOF()
	nCont++
	dbskip()
End                

dbGotop()
procregua(nCont)
While !EOF()
	IncProc("Atendimento: " +TRB->UC_CODIGO )
	If AllTrim(TRB->UC_STATUS) == "1"
		cStatus := "PENDENTE"
	ElseIf AllTrim(TRB->UC_STATUS) == "2"
		cStatus := "PLANEJADA"
	ElseIf AllTrim(TRB->UC_STATUS) == "3"
		cStatus := "ENCERRADA"
	EndIf
	
	cNivel := Posicione("SU5",1,xFilial("SU5") +TRB->UC_CODCONT, "U5_NIVEL")
	cDescNivel := Posicione("SX5",1,xFilial("SX5") +"T6" +cNivel, "X5_DESCRI")                                                                             
	
	If mv_par06 == 1
		oExcel:AddRow("TMK","TMK",{TRB->UC_FILIAL,;
									TRB->UC_CODIGO,;
									Posicione("SU5",1,xFilial("SU5") +TRB->UC_CODCONT, "U5_CONTAT"),;	// contato
									cDescNivel,;	// nivel
									DTOC(STOD(TRB->UC_DATA)),;
									 SUBSTR(TRB->UC_CHAVE,1,6),;
									 SUBSTR(TRB->UC_CHAVE,7),;
									 TRB->A1_NOME,;
									 TRB->A1_NREDUZ,;
									 TRB->UC_MIDIA + " - " +Posicione("SUH",1,xFilial("SUH") + TRB->UC_MIDIA,"UH_DESC"),;
									 Posicione("SUL",1,xFilial("SUL") + TRB->UC_TIPO,"UL_DESC"),; // 
									 TRB->A1_MUN,;
									 TRB->A1_EST,;
									 Posicione("SQB",1,xFilial("SQB") +TRB->UC_XDEPTO,"QB_DESCRIC"),;
							 		 Posicione("SX5",1,xFilial("SX5")+"T1"+TRB->UD_ASSUNTO,"X5_DESCRI"),;			// ASSUNTO
									 Posicione("SU9",2,xFilial("SU9")+TRB->UD_OCORREN,"U9_DESC"),;  // ocorrencia 
									 MSMM(TRB->UC_CODOBS),;	//OBSERVACAO
								 	 cStatus,;	// status
									 TRB->UC_CODENCE,;	// cod encerramento
									 MSMM(TRB->UC_CODMOT),;	// descricao encerramento
									 TRB->UC_OPERADO + " - " +Posicione("SU7",1,xFilial("SU7")+TRB->UC_OPERADO,"U7_NOME"),; 	// operador
									 DTOC(STOD(TRB->UC_DTENCER))})
	Else
		oExcel:AddRow("TMK","TMK",{TRB->UC_FILIAL,;
									TRB->UC_CODIGO,;
									Posicione("SU5",1,xFilial("SU5") +TRB->UC_CODCONT, "U5_CONTAT"),;	// contato
									cDescNivel,;	// nivel
									DTOC(STOD(TRB->UC_DATA)),;
									 SUBSTR(TRB->UC_CHAVE,1,6),;
									 SUBSTR(TRB->UC_CHAVE,7),;
									 TRB->A1_NOME,;
									 TRB->A1_NREDUZ,;
									 TRB->UC_MIDIA + " - " +Posicione("SUH",1,xFilial("SUH") + TRB->UC_MIDIA,"UH_DESC"),;
									 Posicione("SUL",1,xFilial("SUL") + TRB->UC_TIPO,"UL_DESC"),; // 
									 TRB->A1_MUN,;
									 TRB->A1_EST,;
									 Posicione("SQB",1,xFilial("SQB") +TRB->UC_XDEPTO,"QB_DESCRIC"),;
							 		 Posicione("SX5",1,xFilial("SX5")+"T1"+TRB->UD_ASSUNTO,"X5_DESCRI"),;			// ASSUNTO
									 Posicione("SU9",2,xFilial("SU9")+TRB->UD_OCORREN,"U9_DESC"),;  // ocorrencia
								 	 cStatus,;	// status
									 TRB->UC_CODENCE,;	// cod encerramento
									 MSMM(TRB->UC_CODMOT),;	// descricao encerramento
									 TRB->UC_OPERADO + " - " +Posicione("SU7",1,xFilial("SU7")+TRB->UC_OPERADO,"U7_NOME"),; 	// operador
									 DTOC(STOD(TRB->UC_DTENCER))})
	EndIf									 							 
	dbSkip()
End
dbCloseArea()


oExcel:Activate()

// verifica existencia do local padrao para gravacao - C:\TEMP\
If !ExistDir(cDirLocal)
	MakeDir(cDirLocal)
EndIf
	
If !ExistDir(cDirLocal)
	Aviso("TMKR034","O diret๓rio padrใo para grava็ใo da planilha ้ C:\TEMP."+CRLF +"Houve problemas para gravar nesse local, por favor selecione outro caminho.",{"Ok"})
	cDirLocal := ""
	While AllTrim(cDirLocal) == ""                                                                                                                                   
		cDirLocal := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
	End 
EndIf

oExcel:GetXMLFile(cDirLocal+"atendimento_tmk.xml")

If File(cDirLocal +"atendimento_tmk.xml")
	Aviso("TMKR034","A planilha foi gerada em " +cDirLocal, {"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TMKR034", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDirLocal,{"Ok"} )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cDirLocal+"atendimento_tmk.xml")
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf

Return