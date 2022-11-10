#INCLUDE "rwmake.ch"
#INCLUDE "FONT.CH"

#DEFINE CRLF (chr(13)+chr(10))
#DEFINE _OPC_cGETFILE (GETF_RETDIRECTORY + GETF_LOCALHARD + GETF_NETWORKDRIVE)


/*/{Protheus.doc} RelPed
// Relatório para análise dos pedidos de compras, aprovações e classificação das notas fiscais
@author Jonas Gouveia
@since 11/07/11
@version 2.0
@history 05/06/2014, Jonas Gouveia, Incuído pergunta para pertimir filtrar pedidos em aberto ou já atendidos (Com a NF dígitada)  
@history 20/03/2015, Jonas Gouveia, Incluído no o número da medição, para pedidos gerado pelo SIGAGCT

@todo Criar campo F1_TKT006 (Tipo: Caracter, Tamanho: 8)
 
@type function
/*/
User Function RelPed()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Produtos não Faturados"
	Local titulo         := "Pedidos em aberto"
	Local nLin           := 132

	Local Cabec1         := "Filial   Pedido    Fornecedor                     Emissão    Comprador           Aprovador 1    Data Liberação 1  Aprovador 2    Data Liberação 2  Aprovador 3    Data Liberação 3  Aprovador 4    Data Liberação 4"
	Local Cabec2         := ""
	Local aOrd           := {}

	Private oExcelApp

	Private cDirDocs     := ""
	Private cPath		 := AllTrim(GetTempPath())

	Private nHandle
	Private nX
	Private _cArq		 := ""
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 80
	Private tamanho      := "G"
	Private nomeprog     := "RELPED" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cPerg        := "RELPED"
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RELPED" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString      := "SC7"
	Private lPrimeira    := .T.
	Private dDataLib     := ""
	
	dbSelectArea("SC7")
	dbSetOrder(1)

	AjustaSX1()
	If !Pergunte(cPerg,.T.)
		MsgAlert ("Operação Cancelada pelo usuário!","Atenção")
		Return
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

//Função Auxiliar
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local cLocArq 	:= ""
	Local cQry    	:= ""
	Local nCol    	:= 70
	Local aFilUser  := FWLoadSM0(.T.,.T.)
	Local cFilUser	:= ""
	Local nI 		:= 0
	Local cCodUsr	:=	RetCodUsr()
	Local cGrpUsr	:=	''
	Local aGrupos 	:=	UsrRetGrp(cCodUsr)
	Local aGrpPC	:=	{}

	Aeval(aGrupos,{|x| cGrpUsr += x + '/'})

	For nI:=1 to Len(aFilUser)
		If aFilUser[nI][11]
			cFilUser += Iif(nI>1,"|","")+AllTrim(aFilUser[nI][2])
		EndIf
	Next nI
	cFilUser := "('"+StrTran(cFilUser,"|","','")+"') "

	If Select("TRB") <> 0
		TRB->(dbCloseArea())
	Endif

	cQry:= " SELECT C7_FILIAL, C7_NUM, A2_COD, A2_NOME, C7_EMISSAO, SUM(C7_TOTAL) AS C7_TOTAL, C7_CONAPRO " + CRLF
	cQry+= "   , A2_USER , C7_USER" + CRLF
	cQry+= "   FROM " + RETSQLNAME("SC7") + " C7 " + CRLF
	cQry+= "  INNER JOIN " + RETSQLNAME("SA2") + " A2 " + CRLF
	cQry+= "     ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA " + CRLF
	/*cQry+= "  INNER JOIN " + RETSQLNAME("SY1") + " Y1 " + CRLF

	If SM0->M0_CODIGO == '02'
		cQry+= "     ON  C7_USER = Y1_USER AND C7_FILIAL = Y1_FILIAL " + CRLF
	Else
		cQry+= "     ON  C7_USER = Y1_USER " + CRLF
	Endif*/

	cQry+= "  WHERE C7_FILIAL IN "+cFilUser + CRLF
	cQry+= "    AND C7_FORNECE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'" + CRLF
	cQry+= "    AND C7_USER    BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'" + CRLF
	cQry+= "    AND C7_EMISSAO BETWEEN '" + DToS(MV_PAR05) + "' AND '" + DToS(MV_PAR06) + "'" + CRLF
	cQry+= "    AND C7_RESIDUO <> 'S' " + CRLF

	If MV_PAR08 == 2 // Atendidos
		cQry+= "    AND C7_ENCER <> '' " + CRLF
	Else             // Abertos
		cQry+= "    AND C7_ENCER = '' " + CRLF
	EndIf

	cQry+= "    AND C7.D_E_L_E_T_ <> '*' " + CRLF
	cQry+= "    AND A2.D_E_L_E_T_ <> '*' " + CRLF
	//cQry+= "    AND Y1.D_E_L_E_T_ <> '*' " + CRLF
	cQry+= "  GROUP BY C7_FILIAL,C7_NUM, A2_COD, A2_NOME, C7_EMISSAO, C7_CONAPRO , A2_USER , C7_USER" + CRLF

	MemowRite('C:\relped1.txt',cQry)
	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "TRB", .F., .T.)

	TRB->(DbGoTop())

	If mv_par07 == 1 // Impresso

		cCli := ""

		While TRB->(!EOF())
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif

			//"Filial   Pedido    Fornecedor                      Data de Emissão  Comprador  Aprovador 1  Data Liberação 1  Aprovador 2  Data Liberação 2  Aprovador 3  Data Liberação 3  Aprovador 4 Data Liberação 4"
			@nLin,00 PSAY TRB->C7_FILIAL
			@nLin,9  PSAY TRB->C7_NUM
			@nLin,19 PSAY Substr(TRB->A2_NOME,1,30)
			@nLin,50 PSAY Substr(TRB->C7_EMISSAO,7,2) + "/" + Substr(TRB->C7_EMISSAO,5,2) + "/" + Substr(TRB->C7_EMISSAO,1,4)
			//@nLin,61 PSAY Substr(TRB->Y1_NOME,1,19) //
			@nLin,61 PSAY Substr(UsrRetName(TRB->C7_USER),1,19)

			dbSelectArea('SCR')
			DbSetOrder(1)
			dbSeek(TRB->C7_FILIAL +"PC"+ TRB->C7_NUM)

			While SCR->(!EOF()) .AND. AllTrim(SCR->CR_NUM) == AllTrim(TRB->C7_NUM)
				@nLin,nCol += 11 PSAY Substr(Posicione("SAK",1,xFilial("SAK")+SCR->CR_APROV,"AK_NOME"),1,14)
				@nLin,nCol += 15 PSAY If(!Empty(SCR->CR_DATALIB), Substr(DToS(SCR->CR_DATALIB),7,2) + "/" + Substr(DToS(SCR->CR_DATALIB),5,2) + "/" + Substr(DToS(SCR->CR_DATALIB),1,4), " ")
				nCol+=7
				SCR->(DbSkip())
			EndDo

			nCol:= 70
			nLin ++
			TRB->(DbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo

		TRB->(DbCloseArea())
		SET DEVICE TO SCREEN

		If aReturn[5]==1
			dbCommitAll()
			SET PRINTER TO
			OurSpool(wnrel)
		Endif

		MS_FLUSH()

	Else

		cLocArq :=  cGetFile( "Selecione o Diretorio | " , OemToAnsi("Selecione Diretorio") , NIL , "" , .F. , _OPC_cGETFILE )

		IF Empty( cLocArq )
			MsgInfo( OemToAnsi( "Não foi possível encontrar o diretório para Exportação" ),"Atenção" )
			Return
		EndIF

		cDirDocs := cLocArq
		nHandle  := MsfCreate(cDirDocs+"\"+nomeprog+".csv",0)

		If nHandle > 0

			// Grava o cabecalho do arquivo
			//               1       2       3       4        5       6           7               8      9            10                                    11                                                     12                            13                 14         15           16              17           18              19           20              21           22              23           24
			fWrite(nHandle, "Filial; Pedido; Status; Medição; Código; Fornecedor; Emissão Pedido; Valor; Nota Fiscal; Data Digitação;" + IIF(MV_PAR08 == 2, "Emissão NF", "Emissão Pre NF") + IIF(MV_PAR08 == 2,"; Data Classificação", "") + "; Link do Documento; Comprador; Aprovador 1; Data Liberação; Aprovador 2; Data Liberação; Aprovador 3; Data Liberação; Aprovador 4; Data Liberação; Aprovador 5; Data Liberação")
			fWrite(nHandle, CRLF ) // Pula linha

			While TRB->(!EOF())

				If Select("TRB2") <> 0
					TRB2->(dbCloseArea())
				Endif

				cQry2:= " SELECT DISTINCT F1_DOC, F1_SERIE,F1_FORNECE,F1_LOJA, F1_EMISSAO, F1_DTLANC, F1_RECBMTO, F1_XLINK,F1_DTDIGIT " + CRLF		//,F1_USERLGI, F1_DATACLA " + CRLF
				cQry2+= "  FROM " + RETSQLNAME("SD1") + " D1 " + CRLF
				cQry2+= "     INNER JOIN " + RETSQLNAME("SF1") + " F1 " + CRLF
				cQry2+= "               ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA " + CRLF
				cQry2+= "  WHERE  D1_PEDIDO = '" + TRB->C7_NUM +  "'" + CRLF
				cQry2+= "  AND D1_FILIAL = '" + TRB->C7_FILIAL +  "'" + CRLF
				cQry2+= "  AND F1_FILIAL = '" + TRB->C7_FILIAL +  "'" + CRLF
				cQry2+= "  AND D1.D_E_L_E_T_ <> '*'" + CRLF
				cQry2+= "  AND F1.D_E_L_E_T_ <> '*'" + CRLF

				MemowRite('C:\relped2.txt',cQry2)
				DbUseArea( .T., "TOPCONN", TcGenQry(,,cQry2), "TRB2", .F., .T.)

				TRB2->(DbGoTop())

				If lAbortPrint
					@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					Exit
				Endif

				lPrimeira := .T.

				aGrpPC := UsrRetGrp(TRB->C7_USER)
				lPCGrp := .F.
				Aeval(aGrpPC,{|x| lPCGrp := If(x $ cGrpUsr,.T.,.F.)})

				If !lPCGrp
					TRB->(Dbskip())
					loop
				EndIf 

				/*If !Empty(TRB->A2_USER) .And. TRB->A2_USER <> cCodUsr
					TRB->(Dbskip())
					loop
				EndIf */

				If TRB->C7_CONAPRO == "B"
					cStatus := "Bloqueado"
				ElseIf TRB->C7_CONAPRO == "L"
					cStatus := "Liberado"
				Else
					cStatus := "Rejeitado"
				EndIf

				fWrite(nHandle, TRB->C7_FILIAL  + ";")		//1
				fWrite(nHandle, TRB->C7_NUM     + ";")		//2
				fWrite(nHandle, cStatus         + ";")		//3
				fWrite(nHandle, Posicione("SC7",1,TRB->C7_FILIAL + TRB->C7_NUM,"C7_MEDICAO") + ";")		//4
				fWrite(nHandle, TRB->A2_COD     + ";")		//5
				fWrite(nHandle, TRB->A2_NOME    + ";")		//6
				//fWrite(nHandle, Substr(TRB->C7_EMISSAO,7,2) + "/" + Substr(TRB->C7_EMISSAO,5,2) + "/" + Substr(TRB->C7_EMISSAO,1,4)+ ";")		//7
				fWrite(nHandle, DtoC(StoD(TRB->C7_EMISSAO))+ ";")		//7
				fWrite(nHandle, Transform(IIF(SM0->M0_CODIGO == '02' .AND. TRB->C7_FILIAL == '01', 0, TRB->C7_TOTAL),"@E 9999,999,999.99")   + ";")		//8


				fWrite(nHandle, TRB2->F1_DOC     + ";")		//9
				//fWrite(nHandle, Substr(TRB2->F1_RECBMTO,7,2) + "/" + Substr(TRB2->F1_RECBMTO,5,2) + "/" + Substr(TRB2->F1_RECBMTO,1,4)+ ";")

				/* DGJr - 08/11/2022 - campo não existe na tabela, substituido pela data da digitação, conforme definição do Henrique ** inicio
				UserLGI := POSICIONE("SF1",1,TRB->C7_FILIAL+ TRB2->F1_DOC + TRB2->F1_SERIE + TRB2->F1_FORNECE + TRB2->F1_LOJA, "F1_USERLGI")
				fWrite(nHandle, FWLeUserlg("F1_USERLGI",2) + ";")		//10 - data da digitação
				** fim */
				fWrite(nHandle, DtoC(StoD(TRB2->F1_DTDIGIT)) + ";")		//10 - data da digitação - incluido DGJr 08/11/2022

				//fWrite(nHandle, Substr(TRB2->F1_EMISSAO,7,2) + "/" + Substr(TRB2->F1_EMISSAO,5,2) + "/" + Substr(TRB2->F1_EMISSAO,1,4) + ";")		//11 - data da emissão/prenota
				fWrite(nHandle, DtoC(StoD(TRB2->F1_EMISSAO)) + ";")		//11 - data da emissão/prenota

				If MV_PAR08 == 2
					/* DGJr - 08/11/2022 - campo não existe na tabela, substituido pela data da digitação, conforme definição do Henrique ** inicio
					If EMPTY(TRB2->F1_DATACLA)
						UserLGI := POSICIONE("SE2",1,"  " + TRB2->F1_SERIE + TRB2->F1_DOC + "  " + "NF " + TRB2->F1_FORNECE + TRB2->F1_LOJA, "E2_USERLGI")
						fWrite(nHandle, FWLeUserlg("E2_USERLGI",2) + ";")		//12 - data da classificação
					Else
						fWrite(nHandle, Substr(TRB2->F1_DATACLA,7,2) + "/" + Substr(TRB2->F1_DATACLA,5,2) + "/" + Substr(TRB2->F1_DATACLA,1,4) + ";")		//12 - data da classificação
					EndIf
					** fim */
					fWrite(nHandle, DtoC(StoD(TRB2->F1_DTDIGIT)) + ";")		//10 - data da digitação - incluido DGJr 08/11/2022
				EndIf

				fWrite(nHandle, Alltrim(TRB2->F1_XLINK) + ";")		//13
				//fWrite(nHandle, TRB->Y1_NOME + ";")		//14 //
				fWrite(nHandle, UsrRetName(TRB->C7_USER) + ";")

				dbSelectArea('SCR')
				DbSetOrder(1)
				dbSeek(TRB->C7_FILIAL +"PC"+ TRB->C7_NUM)

				While SCR->(!EOF()) .AND. AllTrim(SCR->CR_NUM) == AllTrim(TRB->C7_NUM)
					cXNiv := AllTrim(SCR->CR_NIVEL)

					While SCR->(!EOF()) .AND. cXNiv == AllTrim(SCR->CR_NIVEL) .AND. AllTrim(SCR->CR_NUM) == AllTrim(TRB->C7_NUM)
						fWrite(nHandle,Alltrim(IIF(lPrimeira, " ","/") + UsrRetName(SCR->CR_USER)))		//15
						lPrimeira := .F.

						If Empty(dDataLib) .AND. !Empty(SCR->CR_DATALIB)
							dDataLib :=  Substr(DToS(SCR->CR_DATALIB),7,2) + "/" + Substr(DToS(SCR->CR_DATALIB),5,2) + "/" + Substr(DToS(SCR->CR_DATALIB),1,4)
						EndIf

						SCR->(DbSkip())
					EndDo

					//SCR->(DbSkip(-1))
					//fWrite(nHandle,If(!Empty(SCR->CR_DATALIB),";" + Substr(DToS(SCR->CR_DATALIB),7,2) + "/" + Substr(DToS(SCR->CR_DATALIB),5,2) + "/" + Substr(DToS(SCR->CR_DATALIB),1,4), ";")  + ";")

					fWrite(nHandle,If(!Empty(dDataLib),";" + dDataLib, ";")  + ";")		//16
					dDataLib := ""
					//SCR->(DbSkip())
					lPrimeira := .T.

				EndDo

				TRB->(DbSkip()) //Avanca o ponteiro do registro no arquivo
				fWrite(nHandle, CRLF ) //Pula linha
			EndDo

			TRB->(DbCloseArea())

			fClose(nHandle)

			//CpyS2T( cDirDocs+"\"+nomeprog+".CSV" , cPath, .T. )

			If !ApOleClient( 'MsExcel' )
				MsgAlert( "Arquivo gerado em:" + cDirDocs + nomeprog + ".csv" ,"Atenção")
				Return
			EndIf

			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirDocs+nomeprog + ".csv" ) // Abre uma planilha
			oExcelApp:SetVisible(.T.)
		Else
			MsgAlert("Falha na criação do arquivo","Atenção")
		Endif

	EndIf

Return()

Static Function AjustaSX1()
	PutSx1(cPerg, "01","Comprador De    ?","","","mv_ch1","C",06,0,0,"G","","USR","","","mv_par01","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02","Comprador Ate   ?","","","mv_ch2","C",06,0,0,"G","","USR","","","mv_par02","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03","Fornecedor de   ?","","","mv_ch3","C",06,0,0,"G","","SA2","","","mv_par03","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04","Fornecedor até  ?","","","mv_ch4","C",06,0,0,"G","","SA2","","","mv_par04","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05","Emissão De      ?","","","mv_ch5","D",08,0,0,"G","","   ","","","mv_par05","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "06","Emissão Ate     ?","","","mv_ch6","D",08,0,0,"G","","   ","","","mv_par06","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "07","Tipo            ?","","","mv_ch7","N",01,0,0,"C","","   ","","","mv_par07","Impresso",""      ,""      ,""    ,"Excel"	,""     ,""      ,""    	,""      ,""      ,""    		,""      ,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "08","Lista Quais     ?","","","mv_ch8","N",01,0,0,"C","","   ","","","mv_par08","Abertos", ""      ,""      ,""    ,"Atendidos"	,""     ,""      ,""    	,""      ,""      ,""    		,""      ,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
Return()
