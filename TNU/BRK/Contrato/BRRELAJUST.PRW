#include "PROTHEUS.CH"
#include "rptdef.ch"


/*/{Protheus.doc} BRRELAJUST
Rotina de Relatório de Reajuste
de Contrato
@type function
@version 12.1.33
@author Roni, Atualizado por Valdemir Rabelo
@since 10/10/2023
@param aVetor, array, dados
@param xindice, variant, Indice
@return variant, Nil

	U_BRRELAJUST

/*/
user function BRRELAJUST(aVetor,xindice)
	local oReport
	local cPerg        := 'BRRELAJUST'
	local cAlias       := getNextAlias()
	Local _cArq_contr  := strtran(aVetor[1], "/", "")
	Local cPath_Temp   := GetTempPath()

	Private cFileOrige := cPath_Temp + "totvsprinter\" + alltrim(strtran(_cArq_contr, ".", ""))+".pdf"
	Private cFileDesti := "system\" + alltrim(strtran(_cArq_contr, ".", ""))+".pdf"
	Private ccontrato  := aVetor[1]
	Private crevisa    := aVetor[2]
	Private cfile      := alltrim(strtran(_cArq_contr, ".", ""))
	Private cCompet    := aVetor[3]

	m_EmisIni   := DTOS(_EmisIni)
	m_EmisFim   := DTOS(_EmisFim)
	lFile       := file( cFileOrige )
	_cArq_contr := alltrim(strtran(_cArq_contr, ".", ""))+".pdf"

	//criaSx1(cPerg)
	//Pergunte(cPerg, .T.)

	oReport := reportDef(cAlias, cPerg)

	//Para impressão em PDF
	oReport:setFile(cFile)
	oReport:nDevice := IMP_PDF

	//Já o trecho abaixo, já gera o arquivo pdf em uma pasta
	//  O relatório será gerado em %temp%/totvsprinter
	oReport:nDevice  := 6 // 6 = PDF
	oReport:cFile    := cfile   //"Contrato" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")
	oReport:lPreview := .F.
	oReport:lViewPDF := .F.
	oReport:Print()

	// Exclui arquivo destino
	If File(cFileDesti)
		FERASE(cFileDesti)
	Endif

	// Copia arquivo para o servidor
	lCopiou := __CopyFile( cFileOrige , cFileDesti )

	If File(cFileOrige)
	//	FERASE(cFileOrige)
	Endif

return

/*/{Protheus.doc} ReportPrint
Rotina para montagem dos dados do Relatório
@type function
@version 12.1.33
@author Roni, Atualizado por Valdemir Rabelo
@since 10/10/2023
@param oReport, object, Objeto Relatório
@param cAlias, character, Tabela Temporaria
@return variant, Nil
/*/
Static Function ReportPrint(oReport,cAlias)
	local oSecao1 := oReport:Section(1)

	oSecao1:BeginQuery()

	BeginSQL Alias cAlias

		SELECT CNB_CONTRA,CNB_NUMERO,CN9_XREDCL,CNB_PRODUT,CNB_DESCRI,CNA_PROXRJ,CNB_VLUNIT
		FROM %Table:CNB% CNB
		INNER JOIN %Table:CNA% CNA ON CNA.CNA_CONTRA+CNA.CNA_REVISA+CNA.CNA_NUMERO = CNB.CNB_CONTRA+CNB.CNB_REVISA+CNB.CNB_NUMERO
		INNER JOIN %Table:CN9% CN9 ON CN9.CN9_NUMERO+CN9.CN9_REVISA = CNB.CNB_CONTRA+CNB.CNB_REVISA
		WHERE CNB_CONTRA = %Exp:ccontrato%
		AND   CNB.CNB_REVISA = %Exp:crevisa%
		AND   CNB_XPCANC <> '1'
		AND   CNA_XATIVO <> '2'
		AND   CNA.CNA_PROXRJ BETWEEN %Exp:m_EmisIni% AND %Exp:m_EmisFim% 
		ORDER BY CNB.CNB_CONTRA,CNB.CNB_NUMERO,CNB_PRODUT

	EndSQL

	oSecao1:EndQuery()
	oReport:SetMeter((cAlias)->(RecCount()))
	oSecao1:Print()

return

/*/{Protheus.doc} ReportDef
Rotina para montagem da estrutura do relatório
@type function
@version 12.1.33
@author Atualizado por Valdemir Rabelo
@since 10/10/2023
@param cAlias, character, Tabela Temporaria
@param cPerg, character, Pergunte
@return variant, Objeto
/*/
Static Function ReportDef(cAlias,cPerg)
	local cTitle := "Relatório de Reajuste de Contrato"
	local cHelp  := "Permite gerar relatório de reajuste."
	local oReport
	local oSection1

	cCompet := SUBSTR(DTOS(cCompet),5,2) + "/" + SUBSTR(DTOS(cCompet),1,4) //SUBSTR(DTOS(CN9->CN9_DTINIC),5,2) + "/" + SUBSTR(DTOS(CN9->CN9_DTINIC),1,4)
	oReport := TReport():New('BRRELAJUST', cTitle, cPerg, {|oReport|ReportPrint(oReport,cAlias)}, cHelp)

	/*
	oReport:nRemoteType := NO_REMOTE        // FORMA DE GERAÇÃO DO RELATÓRIO
	oReport:nDevice     := 6                // 8 = ENVIO DE .PDF VIA E-MAIL 6 = PDF
	oReport:cEmail      := "roni.silva@totvspartners.com..br" // DESTINATÁRIO
	oReport:SetReportPortal("BRRELAJUST") // DEFINE O NOME DO RELATÓRIO
	*/

	//Primeira seção
	oSection1 := TRSection():New(oReport,"Contrato",{"CNB"})

	TRCell():New(oSection1,"CNB_CONTRA"      , "CNB", "CONTRATO")
	TRCell():New(oSection1,"CNB_NUMERO"      , "CNB", "PLANILHA")
	TRCell():New(oSection1,"CN9_XREDCL"      , "CN9", "FANTASIA")
	TRCell():New(oSection1,"CNB_PRODUT"      , "CNB", "COD.SERV.",PesqPict("CNB","CNB_PRODUT"),20,,)
	TRCell():New(oSection1,"CNB_DESCRI"      , "CNB", "DESCRIÇÃO DO SERVIÇO")
	TRCell():New(oSection1,"CNA_PROXRJ"      , "CNA", "DT.ULT.PR.",PesqPict("CNA","CNA_PROXRJ"),20,,)
	TRCell():New(oSection1,"CNB_VLUNIT"      , "CNB", "PREÇO ATUAL")

	TRCell():New(oSection1,"REAJUSTE (%)"    , "CNB",,,,,{|| IIF(MV_PAR01 == 2,POSICIONE("CN7",2,XFILIAL("CN7")+xindice+ALLTRIM(cCompet),'CN7_VLREAL'),MV_PAR03)})  //reajuste
	TRCell():New(oSection1,"PREÇO ATUALIZADO", "CNB",,PesqPict("CNB","CNB_VLUNIT"),,,{|| (cAlias)->CNB_VLUNIT*(1+(IIF(MV_PAR01 == 2,POSICIONE("CN7",2,XFILIAL("CN7")+xindice+ALLTRIM(cCompet),'CN7_VLREAL'),MV_PAR03)/100)) 		})    //Preço Atualizado

	//	TRCell():New(oImpostos,"aCodImps2"	,/*Tabela*/,STR0096,/*Picture*/			,13,/*lPixel*/,{|| aCodImps[nI][2] 		})	// "Imposto"
	//	TRCell():New(oImpostos,"NF_BASEICM"	,/*Tabela*/,STR0087,PesqPict("SF2","F2_BASEICM"),TamSx3("F2_BASEICM"		)[1],/*lPixel*/,{|| MaFisRet(,"NF_BASEICM") 	})	// "Base Icms"

	//TRCell():New(oSection1,"A1_COD", "SA1", "Codigo")
	//TRCell():New(oSection1,"A1_NOME", "SA1", "Nome")
	//TRCell():New(oSection1,"A1_MUN", "SA1", "Cidade")
	//TRCell():New(oSection1,"A1_EST", "SA1", "Estado")

Return(oReport)



/*/{Protheus.doc} criaSX1
Rotina para criação das perguntas (se não existirem) !
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 10/10/2023
@param cPerg, character, Pergunte
@return variant, Nil
/*/
static function criaSX1(cPerg)
	Local x := 0
	Local i
	Local j

	DBSelectArea("SX1")
	DBSetOrder(1)

	_sAlias := Alias()
	cPerg   := PADR(cPerg,10)
	aRegs   := {}

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,'01', 'Reajuste Padrão     ?' , '', '', 'mv_ch1', 'C', 06, 0, 0, 'G',"","mv_Par01","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,'02', 'Motivo              ?' , '', '', 'mv_ch2', 'C', 60, 0, 0, 'G',"","mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,'03', 'Índice negociado (%)?' , '', '', 'mv_ch3', 'N', 06, 2, 0, 'G',"","mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,'04', 'Mês da negociação   ?' , '', '', 'mv_ch4', 'C', 18, 0, 0, 'G',"","mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,'05', 'Edita e-mail        ?' , '', '', 'mv_ch5', 'C', 06, 0, 0, 'G',"","mv_Par05","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","",""})
	
	/*
	aAdd(aRegs,{cPerg,"01","Reajuste de:"         ,"","","mv_ch1","D",08,0,0 ,"G","","mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Reajuste ate:"        ,"","","mv_ch2","D",08,0,0 ,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Contrato de:"         ,"","","mv_ch3","C",15,0,0 ,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","CN9",""})
	aAdd(aRegs,{cPerg,"04","Contrato ate:"        ,"","","mv_ch4","C",15,0,0 ,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","CN9",""})
	aAdd(aRegs,{cPerg,"05","Cliente de:"          ,"","","mv_ch5","C",06,0,0 ,"G","","mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
	aAdd(aRegs,{cPerg,"06","Cliente ate:"         ,"","","mv_ch6","C",06,0,0 ,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
	*/

	//grava array no SX1
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Else
			For x:=1 to len(aRegs[i])
				If x<=fcount() .and. aRegs[i,x]<>&(fieldname(x))
					If !(alltrim(strzero(x,2))$'10;17;22;27;32;37')
						RecLock("SX1",.f.)
						FieldPut(x,aRegs[i,x])
						MsUnLock()
					Endif
				Endif
			Next
		Endif
	Next
		
	i:=len(aRegs)+1
	While dbSeek(cPerg+strzero(i,2))
		RecLock("SX1",.f.)
		DbDelete()        
		MsUnLock()
		i++
	End

	dbSelectArea(_sAlias)

Return
