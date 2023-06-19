#include 'protheus.ch'
#include 'parmtype.ch'
#include 'tbiconn.ch'
#Include "TopConn.ch"
#include "fileio.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± ºPrograma ³ JUBRSE1   ºAutor³ AVSIPRO Rodrigo Barreto	    º Data Ini³ 14/04/2020       º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± ºDesc.    ³ Relatorio de Contas a RECEBER AGING                                            ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± ºUso      ³ ADT MONIT    	                                            		  		  ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

user function JUBRSE1()

	//Local aArea := GetArea()
	Local aPergs   := {}
	Local cFilDe    := space(4)
	Local cFilAt    := space(4)
	Local dEmiIni  	:= SToD('')
	Local dEmiFin   := SToD('')
	//Local dRefe		:= StoD('')
	Local dVenDe	:= StoD('')
	Local dVenAt	:= StoD('')
	Local nTipo		:= 0
	//Local nAdia	   := Space(1)


	//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

	aAdd(aPergs, {1, "Filial de ",			 		cFilDe,  "",  ".T.",   "",  ".T.", 40,  .F.})
	aAdd(aPergs, {1, "Filial até ",			 		cFilAt,  "",  ".T.",   "",  ".T.", 40,  .T.})
	aAdd(aPergs, {1, "Emissao de ",			 		dEmiIni,  "",  ".T.",   "",  ".T.", 60,  .T.})
	aAdd(aPergs, {1, "Emissao até ",			 	dEmiFin,  "",  ".T.",   "",  ".T.", 60,  .T.})
	aAdd(aPergs, {1, "Vencimento de ",  			dVenDe, "",  ".T.",   "",  ".T.", 60,  .T.})
	aAdd(aPergs, {1, "Vencimento até ",  			dVenAt, "",  ".T.",   "",  ".T.", 60,  .T.})
	aAdd(aPergs, {2, "Situação",             nTipo, {"1=Título em aberto", "2=Baixados","3=Todos"},     123, ".T.", .F.})


	If ParamBox(aPergs, "Informe os paarametros")
		MsAguarde({|| GeraExcel()},,"O arquivo Excel está sendo gerado...")
	EndIf

	//restArea(aArea)
Return Nil


Static Function GeraExcel()

	Local oExcel  := FWMSEXCEL():New()
	Local lOK 	  := .F.
	Local cArq 	  := ""
	Local cQuery  := ""
	Local cPar1   := MV_PAR01
	Local cPar2   := MV_PAR02
	Local cPar3   := MV_PAR03
	Local cPar4   := MV_PAR04
	Local cPar5   := MV_PAR05
	Local cPar6   := MV_PAR06
	Local cPar7   := MV_PAR07
	Local cDirTmp

	Private dDataGer  := Date()
	Private cHoraGer  := Time()

	SetPrvt("MV_PAR01","MV_PAR02","MV_PAR03","MV_PAR04","MV_PAR05","MV_PAR06","MV_PAR07")

	cQuery := " SELECT E5_HISTOR AS HISTORICO,"
	cQuery += " E1_ACRESC AS ACRESCIMO,"
	cQuery += " E1_MULTA AS MULTA,"
	cQuery += " E1_FILORIG AS FILORIG,"
	cQuery += " E1_PREFIXO AS PREFI,"
	cQuery += " E1_NUM AS NUMERO,"
	cQuery += " E1_TIPO AS TIPO,"
	cQuery += " E1_PARCELA AS PARCELA,"
	cQuery += " E1_NUMBCO AS NUMBCO,"
	cQuery += " E1_NUMBOR AS NUMBOR,"
	cQuery += " E1_PORTADO AS BANCO,"
	cQuery += " E1_SALDO AS SALDO,"
	cQuery += " E1_CLIENTE AS CODCLI,"
	cQuery += " E1_LOJA AS LOJCLI,"
	cQuery += " E1_BAIXA,"
	cQuery += " A1_NOME AS NREDUZ,"
	cQuery += " A1_NREDUZ AS FANTASIA,"
	cQuery += " A1_VEND AS COD_REPRES,"
	cQuery += " A3_NOME AS REPRESENTATE,"
	cQuery += " A1_CONTATO AS CONTATO,"
	cQuery += " A1_EMAIL AS EMAIL, A1_EST AS UF, A1_MUN AS MUNICIPIO,"
	cQuery += " A1_TEL AS TELEFONE, A1_CGC AS CNPJ, "
	cQuery += " CONVERT(VARCHAR(10), CAST(E1_EMISSAO AS DATE),103) AS EMISSAO,"
	cQuery += " CONVERT(VARCHAR(10), CAST(E1_VENCTO AS DATE),103) AS VENCT,"
	cQuery += " CONVERT(VARCHAR(10), CAST(E1_VENCREA AS DATE),103) AS VENCTR,"
	cQuery += " E1_VALOR AS VALOR, "
	//cQuery += " CASE WHEN E1_BAIXA <> '' THEN E1_VALOR ELSE E1_SALDO END AS CSALDO, "
	cQuery += " CONVERT(VARCHAR(10), CAST(E1_BAIXA AS DATE),103) AS BAIXA "
	cQuery += " FROM "+ RetSQLName('SE1')+" E1 "

	cQuery += " LEFT JOIN "+RetSqlName('SE5')+" E5 ON E5_FILORIG = E1_FILORIG AND E5_NATUREZ = E1_NATUREZ AND E5_PREFIXO = E1_PREFIXO AND E5_NUMERO = E1_NUM AND E5_PARCELA = E1_PARCELA AND E5_TIPO = E1_TIPO  AND E5_RECPAG = 'R' AND E5.R_E_C_N_O_>0 "

	cQuery += " INNER JOIN "+RetSQLName('SA1')+" A1 ON A1_FILIAL='' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1.D_E_L_E_T_='' AND A1.R_E_C_N_O_>0 "
	cQuery += "	LEFT JOIN "+RetSQLName('SA3')+" A3 ON A3_FILIAL='' AND A3_COD=A1_VEND AND A3.D_E_L_E_T_=''"
	cQuery += " WHERE "
	cQuery += " E1.D_E_L_E_T_= ''"
	cQuery += " AND E1_FILORIG BETWEEN '"+ cPar1 + "' AND '"+ cPar2 +"' "
	cQuery += " AND E1_EMISSAO BETWEEN '"+ DtoS(cPar3) +"' AND '"+ DtoS(cPar4) +"' "
	cQuery += " AND E1_VENCREA BETWEEN '"+ DtoS(cPar5) +"' AND '"+ DtoS(cPar6) +"' "
	//cQuery += " AND (E1_BAIXA >= '"+ DtoS(cPar3) +"' OR  E1_BAIXA = '' ) "
	//cQuery += " AND E1_TIPO NOT IN ('IS-','PIS','CSL','COF','IR','IR-') "
	cQuery += " AND E1_NUM BETWEEN '' AND 'ZZZZZZZZZ' AND E1_PREFIXO BETWEEN '' AND 'ZZZ' AND E1_PARCELA BETWEEN '' AND 'ZZZ' "
	If cPar7 == "1"
		cQuery += " AND E1_SITUACA <> '' AND E1_SALDO > 0 " 
		cQuery += " AND E1.R_E_C_N_O_>0 "
	elseif cPar7 == "2"
		cQuery += " AND E1_BAIXA <> '' AND E5_TIPODOC NOT IN ('JR') "
		cQuery += " AND E1.R_E_C_N_O_>0 "
	Else
		cQuery += " AND E1.R_E_C_N_O_>0 AND E5_TIPODOC NOT IN ('JR') "
	EndIf

	If Select("TMP")<>0
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

	dbSelectArea("TMP")
	TMP->(dbGoTop())

	oExcel:SetLineFrColor("#000")
	oExcel:SetTitleFrColor("#000")
	oExcel:SetFrColorHeader("#000")

	oExcel:AddWorkSheet("Contas a Receber")
	oExcel:AddTable("Contas a Receber","Titulos em Aberto")
	//, , , , , , , , , , ,, , , , , ,
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","FILIAL ORIGEM"         		,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","PREFIXO"       				,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","TITULO"       				,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","TIPO"       				,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","PARCELA"       				,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","COD CLIENTE"       				,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","LOJA CLIENTE"       				,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","RAZAO SOCIAL"     				,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","FANTASIA"     				,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","EMISSAO"     				,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","VENCIMENTO"     		,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","VENCIMENTO REAL"         		,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","VALOR ORIGINAL"       				,3,3)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","ACRESCIMO"       				,3,3)	
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","MULTA"       				,3,3)	
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","SALDO"       				,3,3)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","DATA DA BAIXA"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","HISTORICO"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","STATUS"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","CNPJ/CPF"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","NUM BCO"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","NUMERO BORDERO"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","BANCO"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","COD_REPRE"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","REPRESENTANTE"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","CONTATO"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","EMAIL"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","TELEFONE"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","UF"         	,1,1)
	oExcel:AddColumn("Contas a Receber","Titulos em Aberto","MUNICIPIO"         	,1,1)

	While TMP->(!EOF())

		cStatus := ""

		If EMPTY(TMP->E1_BAIXA) .and. CTOD(TMP->VENCTR) < date()
			cStatus := "VENCIDO"
		EndIf

		oExcel:AddRow("Contas a Receber","Titulos em Aberto",{TMP->FILORIG,;
			TMP->PREFI,;
			TMP->NUMERO,;
			TMP->TIPO,;
			TMP->PARCELA,;
			TMP->CODCLI,;
			TMP->LOJCLI,;
			TMP->NREDUZ,;
			TMP->FANTASIA,;
			TMP->EMISSAO,;
			TMP->VENCT,;
			TMP->VENCTR,;
			TMP->VALOR,;
			TMP->MULTA,;
			TMP->ACRESCIMO,;
			TMP->SALDO,;
			DtoC(StoD(TMP->E1_BAIXA)),;
			TMP->HISTORICO,;
			cStatus,;
			TMP->CNPJ,;
			TMP->NUMBCO,;
			TMP->NUMBOR,;
			TMP->BANCO,;
			TMP->COD_REPRES,;
			TMP->REPRESENTANTE,;
			TMP->CONTATO,;
			TMP->EMAIL,;
			TMP->TELEFONE,;
			TMP->UF,;
			TMP->MUNICIPIO})

		lOK := .T.
		TMP->(dbSkip())
	EndDo

	dbSelectArea("TMP")
	dbCloseArea()

	cDirTmp:= cGetFile( '*.csv|*.csv' , 'Selecionar um diretório para salvar', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

	oExcel:Activate()

	cArq := CriaTrab(NIL, .F.) +"_Contas a Receber_"+dToS(dDataGer) + "_" + StrTran(cHoraGer, ':', '-')+ ".xml"
	oExcel:GetXMLFile(cArq)

	If __CopyFile(cArq,cDirTmp + cArq)
		If lOK
			oExcelApp := MSExcel():New()
			oExcelApp:WorkBooks:Open(cDirTmp + cArq)
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
			MsgInfo("O arquivo Excel foi gerado no dirtório: " + cDirTmp + cArq + ". ")
		EndIf
	Else
		MsgAlert("Erro ao criar o arquivo Excel!")
	EndIf

return
