
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#define DMPAPER_A4          9           /* A4 210 x 297 mm                    */
#define DMPAPER_A4SMALL     10          /* A4 Small 210 x 297 mm              */

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function boletos()

	Local   nOpc       := 0
	Local   aDesc      := "Este programa imprime os boletos de"+chr(13)+"cobranca bancaria de acordo com"+chr(13)+"os parametros informados"
	PRIVATE Exec       := .F.
	PRIVATE cIndexName := ''
	PRIVATE cIndexKey  := ''
	PRIVATE cFilter    := ''
	PRIVATE cPerg	   := "BOLY"
	Private _lBcoCorrespondente := .f.

	ValidPerg()

	//Parametros de BOLLSR:
	//MV_PAR01	 C3	 Do Prefixo:
	//MV_PAR02   C3  Ate o Prefixo:
	//MV_PAR03   C6  Do Titulo:
	//MV_PAR04   C6  Ate o Titulo:
	//MV_PAR05   C3  Do Banco:
	//MV_PAR06   C4  Agencia:
	//MV_PAR07   C6  Conta:
	//MV_PAR08   C2  SubConta:
	//MV_PAR09   C6  Do bordero
	//MV_PAR10   C6  Ate o Bordero
	//MV_PAR11   N1  Selecionar T�tulos? 1-Sim 2-N�o
	//MV_PAR12       TEXTO 1 DA INSTRUCAO
	//MV_PAR13       CONTINUACAO DO TEXTO1
	//MV_PAR14       TEXTO 2 DA INSTRUCAO
	//MV_PAR15       CONTINUACAO DO TEXTO2
	//MV_PAR16       TEXTO 3 DA INSTRUCAO
	//MV_PAR17       CONTINUACAO DO TEXTO3

	dbSelectArea("SE1")

	If !Pergunte (cPerg,.t.)
		Return
	Endif

	bDanfe:=.F.

	nOpc := Aviso("Impressao do Boleto Laser",aDesc,{"Config. Imp.","Sim","Nao"})

	If     nOpc == 1   //SE CONFIGURA IMPRESSAO

		U_ConfiguraPrt()

	ElseIf nOpc == 2   //SE IMPRIME

		cSql := "SELECT 'S' AS EE_X_BOL FROM " + RETSQLNAME('SEE') //EE_X_BOL
		cSql += " WHERE D_E_L_E_T_ <> '*'"
		cSql += "   AND EE_FILIAL  = '" + xFilial('SEE') + "'"
		cSql += "   AND EE_CODIGO  = '" + MV_PAR05 + "'"
		cSql += "   AND EE_AGENCIA = '" + MV_PAR06 + "'"
		cSql += "   AND EE_CONTA   = '" + MV_PAR07 + "'"
		cSql += "   AND EE_SUBCTA  = '" + MV_PAR08 + "'"

		If select('QRY') > 0
			QRY->(dbCloseArea())
		Endif

		TcQuery cSql new alias 'QRY'

		If eof()
			msgInfo('N�o h� parametros de banco definidos para o Banco/Agencia/Conta/Subconta informados.')
		Else
			If QRY->EE_X_BOL <> 'S'
				msgInfo('Os parametros definidos para o Banco n�o permite a impress�o de Boleto. Verifique')
			Else

				cIndexName := Criatrab(Nil,.F.)

				cIndexKey  := "E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"

				cFilter    := "E1_PREFIXO >= '" + MV_PAR01  + "' .And. E1_PREFIXO <= '" + MV_PAR02 + "' .And. " + ; // E1_EMISSAO <> E1_VENCTO .AND. " + ;
					"E1_NUM     >= '" + MV_PAR03  + "' .And. E1_NUM     <= '" + MV_PAR04 + "' .And. " + ;
					"E1_FILIAL  =  '" + xFilial('SE1') + "' .And. E1_SALDO   >     0 .And. " + ;
					"SubsTring(E1_TIPO,3,1) != '-' "

				If AllTrim(MV_PAR09)<>"" .And. AllTrim(MV_PAR10) <> ""
					cFilter += " .And. E1_NUMBOR  >= '" + MV_PAR09  + "' .And. E1_NUMBOR  <= '" + MV_PAR10 + "' "
				EndIf

				IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde, selecionando registros....")

				DbSelectArea("SE1")

				cMarca := GetMark( )

				dbGoTop()
				do while !eof()
					reclock('SE1',.f.)
					if mv_par11 == 1
						replace E1_OK with cMarca
					else
						replace E1_OK with space(01)
					endif
					msunlock()
					dbSkip()
				enddo

				dbGoTop()

				@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Titulos"
				oMark:=MsSelect():New("SE1","E1_OK",,,,cMarca,{02,1,170,350})
				oMark:oBrowse:lhasMark := .t.
				oMark:oBrowse:lCanAllmark := .t.
				oMark:oBrowse:bAllMark := {|| Inverte(cMarca,@oMark)}

				@ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
				@ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))
				ACTIVATE DIALOG oDlg CENTERED

				If Exec
					Processa({|lEnd|MontaRel()})  //MONTA RELATORIO DOS MARCADOS
				Endif

				DbSelectArea("SE1")
				RetIndex("SE1")

				FErase(cIndexName+OrdBagExt())

			Endif

		Endif

	EndIf

Return Nil

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ImprimeBOL(cxNFI,cxNFF,cxSER)

	PRIVATE Exec       := .F.
	PRIVATE cPerg2	   := "BOLDAN"
	Private xcBanco		:= Padr(GetMv("MV_X_BCOBOL"),tamsx3('EE_CODIGO')[1])
	Private xcAgenc		:= Padr(GetMv("MV_X_AGEBOL"),tamsx3('EE_AGENCIA')[1])
	Private xcConta		:= Padr(GetMv("MV_X_CTABOL"),tamsx3('EE_CONTA')[1])
	Private xcSubCt		:= Padr(GetMv("MV_X_SUBBOL"),tamsx3('EE_SUBCTA')[1])

	bDanfe:=.T.

	ValidPerg2()
	dbSelectArea("SE1")
	Pergunte (cPerg2,.t.)

	xcBanco		:= mv_par01
	xcAgenc		:= mv_par02
	xcConta		:= mv_par03
	xcSubCt		:= mv_par04

	cIndexName := Criatrab(Nil,.F.)
	cIndexKey  := "E1_PREFIXO+E1_NUM+E1_PARCELA+DTOS(E1_EMISSAO)+E1_CLIENTE"

	cFilter :=  "E1_PREFIXO >= '" + cxSER  + "' .And. E1_PREFIXO <= '" + cxSER + "' "
	cFilter += 	" .And. E1_NUM >= '" + cxNFI  + "' .And. E1_NUM <= '" + cxNFF + "' "
	cFilter += 	" .And. E1_EMISSAO <> E1_VENCTO "
	cFilter += 	" .And. E1_FILIAL  =  '" + xFilial('SE1')+"'"

	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde, selecionando registros....")

	DbSelectArea("SE1")

	cMarca := GetMark( )

	dbGoTop()
	do while !eof()
		reclock('SE1',.f.)
		replace E1_OK with cMarca
		msunlock()
		dbSkip()
	enddo

	dbGoTop()

	Processa({|lEnd|MontaRel()})  //MONTA RELATORIO DOS MARCADOS

	DbSelectArea("SE1")
	RetIndex("SE1")

	FErase(cIndexName+OrdBagExt())

Return Nil

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg2()
	Local _sAlias,i,j

	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg2 := PADR(cPerg2,6)
	aRegs:={}

	aAdd(aRegs,{cPerg2,"01","Do Banco            ","","","mv_ch1" ,"C", 3,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA6",""})
	aAdd(aRegs,{cPerg2,"02","Agencia             ","","","mv_ch2" ,"C", 5,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg2,"03","Conta               ","","","mv_ch3" ,"C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg2,"04","SubConta            ","","","mv_ch4" ,"C", 3,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg2,"05","Texto 1 da instrucao","","","mv_ch5" ,"C",50,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg2,"06","                    ","","","mv_ch6" ,"C",50,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg2,"07","Texto 2 da instrucao","","","mv_ch7" ,"C",50,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg2,"08","                    ","","","mv_ch8" ,"C",50,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg2,"09","Texto 3 da instrucao","","","mv_ch9" ,"C",50,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg2,"10","                    ","","","mv_ch10","C",50,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg2+'    '+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
			dbCommit()
		EndIf
	Next

	dbSelectArea(_sAlias)

Return

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Inverte(cMarca,oMark)

	Local nReg := SE1->(Recno())
	dbSelectArea("SE1")
	dbGoTop()
	While !Eof()
		RecLock("SE1")
		IF E1_OK == cMarca
			SE1->E1_OK := "  "
		Else
			SE1->E1_OK := cMarca
		Endif
		dbSkip()
	Enddo
	SE1->(dbGoto(nReg))
	oMark:oBrowse:Refresh(.t.)

Return Nil

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MontaRel()
	Local oPrint
	Local n := 0
	Local aBitmap      := {"" ,;                             //Banner publicit�rio
		"\Bitmaps\Logo_Siga.bmp"      }   //Logo da empresa

	Local aDadosEmp    := {SM0->M0_NOMECOM                                                           ,; //Nome da Empresa
		SM0->M0_ENDCOB                                                            ,; //Endere�o
		AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //Complemento
		"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //CEP
		"TELEFONE: "+SM0->M0_TEL                                                  ,; //Telefones
		"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+            ;
		Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ;
		Subs(SM0->M0_CGC,13,2)                                                    ,; //CGC
		"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ;
		Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //I.E

	Local aDadosTit
	Local aDadosBanco
	Local aDatSacado
	Local aBolText
	Local aBMP         := aBitMap
	Local i            := 1
	Local CB_RN_NN     := {}
	Local nRec         := 0
	Local _nVlrAbat    := 0
	Local bPermite	   :=.T.

	Private pNumero    := 0
	Private cNumbco    := ''
	Private cNNum      := ''
	Private cNNumSDig
	oPrint:= TMSPrinter():New( "Boleto Laser" )  //INSTANCIA O OBJETO
	oPrint:SetPage( DMPAPER_A4SMALL )
	oPrint:SetPortrait() // ou SetLandscape()

	nRec := reccount()

	DbSelectArea("SE1")
	dbGoTop()
	ProcRegua(nRec)
	Do While !EOF()

		DbSelectArea("SA6")        //Posiciona o SA6 (Bancos)
		DbSetOrder(1)

		If bDanfe==.F.
			if !DbSeek(xFilial("SA6")+MV_PAR05+MV_PAR06+MV_PAR07)
				alert('Banco n�o encontrado')
				loop
			endif

			//Posiciona o SEE (Parametros banco)
			DbSelectArea("SEE")
			DbSetOrder(1)
			if !DbSeek(xFilial("SEE")+MV_PAR05+MV_PAR06+MV_PAR07+MV_PAR08)
				alert('Banco n�o encontrado nos parametros')
				loop
			endif
		Else
			//POSICIONA NO BANCO
			If !DbSeek(xFilial("SA6")+xcBanco+xcAgenc+xcConta)
				Alert('Banco n�o encontrado')
				Loop
			EndIf

			//Posiciona o SEE (Parametros banco)
			DbSelectArea("SEE")
			DbSetOrder(1)
			If !DbSeek(xFilial("SEE")+xcBanco+xcAgenc+xcConta+xcSubCt)
				alert('Banco n�o encontrado nos parametros')
				Loop
			EndIf

		EndIf

		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		DbSetOrder(1)
		if !DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
			alert('Cliente n�o encontrado')
			loop
		endif

		//Posiciona o SE1 (Contas a Receber)
		DbSelectArea("SE1")
		bPermite:=.T.

		If bDanfe==.F.
			//Confere banco para n�o reimprimir um boleto que j� foi impresso por outro banco
			If(AllTrim(SE1->E1_PORTADO) <> "" .And. AllTrim(SE1->E1_PORTADO) <> AllTrim(MV_PAR05))
				SE1->(dbSkip())
				IncProc()
				i++
				Loop
			EndIf

			//Confere agencia para n�o reimprimir um boleto que j� foi impresso por outra agencia
			If(AllTrim(SE1->E1_AGEDEP) <> "" .And. AllTrim(SE1->E1_AGEDEP) <> AllTrim(MV_PAR06))
				SE1->(dbSkip())
				IncProc()
				i++
				Loop
			EndIf

			//Confere conta para n�o reimprimir um boleto que j� foi impresso por outra conta
			If(AllTrim(SE1->E1_CONTA) <> "" .And. AllTrim(SE1->E1_CONTA) <> AllTrim(MV_PAR07))
				SE1->(dbSkip())
				IncProc()
				i++
				Loop
			EndIf
		Else
			//Confere banco para n�o reimprimir um boleto que j� foi impresso por outro banco
			If(AllTrim(SE1->E1_PORTADO) <> "" .And. AllTrim(SE1->E1_PORTADO) <> AllTrim(xcBanco))
				SE1->(dbSkip())
				IncProc()
				i++
				Loop
			EndIf

			//Confere agencia para n�o reimprimir um boleto que j� foi impresso por outra agencia
			If(AllTrim(SE1->E1_AGEDEP) <> "" .And. AllTrim(SE1->E1_AGEDEP) <> AllTrim(xcAgenc))
				SE1->(dbSkip())
				IncProc()
				i++
				Loop
			EndIf

			//Confere conta para n�o reimprimir um boleto que j� foi impresso por outra conta
			If(AllTrim(SE1->E1_CONTA) <> "" .And. AllTrim(SE1->E1_CONTA) <> AllTrim(xcConta))
				SE1->(dbSkip())
				IncProc()
				i++
				Loop
			EndIf
		EndIf

		_lBcoCorrespondente := .f.

		aDadosBanco  := {SA6->A6_COD     ,;                        //1-Numero do Banco
			SA6->A6_NREDUZ  ,;                        //2-Nome do Banco
			Alltrim(SA6->A6_AGENCIA)+If(empty(SA6->A6_DVAGE),'','-')+Alltrim(SA6->A6_DVAGE) ,;   //3-Ag�ncia
			Alltrim(SA6->A6_NUMCON),;      //4-Conta Corrente
			Iif(SA6->A6_COD $ "479/389/033","",SA6->A6_DVCTA)  ,; //5-D�gito da conta corrente
			alltrim(SEE->EE_CODCART) ,;   //6-Carteira
			"",;
			"",;
			""}                //8-Reservado para o banco correspondente

		If Empty(Alltrim(SA1->A1_ENDCOB))  // Busca o endereco de cobranca
			aDatSacado   := {AllTrim(SA1->A1_NOME)                          ,;      //1-Raz�o Social
				AllTrim(SA1->A1_COD )                           ,;      //2-C�digo
				AllTrim(SA1->A1_END)+"-"+SA1->A1_BAIRRO 		,; 		//AllTrim(SA1->A1_END)+","+Alltrim(SA1->A1_X_NMEND)+"-"+SA1->A1_BAIRRO          ,;      //3-Endere�o
				AllTrim(SA1->A1_MUN )                           ,;      //4-Cidade
				SA1->A1_EST                                     ,;      //5-Estado
				SA1->A1_CEP                                     ,;      //6-CEP
				SA1->A1_CGC                                     }       //7-CGC/CPF
		Else    // Busca o endereco normal
			aDatSacado   := {AllTrim(SA1->A1_NOME)                            ,;      //1-Raz�o Social
				AllTrim(SA1->A1_COD )                            ,;      //2-C�digo
				AllTrim(SA1->A1_ENDCOB)+"-"+SA1->A1_BAIRROC      ,;      //3-Endere�o
				AllTrim(SA1->A1_MUNC )                           ,;      //4-Cidade
				SA1->A1_ESTC                                     ,;      //5-Estado/
				SA1->A1_CEPC                                     ,;      //6-CEP
				SA1->A1_CGC                                      }       //7-CGC/CPF
		Endif

		//VALOR DOS TITULOS TIPO "AB-"
		_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

		If Alltrim(SA6->A6_COD)=="084"
			//BANCO BRADESCO CORRESPONDENTE UNIPRIME
			cJurDia := 2/30 //GetMv("MV_LJJUROS")

			cInst0:= "AP�S O VENCIMENTO MORA DIA R$ " + transform(SE1->E1_SALDO*(cJurDia/100),'@E 999999.99')
			cInst1:= strtran(SEE->EE_FORMEN1,"'","")
			cInst2:= strtran(SEE->EE_FORMEN2,"'","")
			cInst3:= strtran(SEE->EE_FOREXT1,"'","")
		ElseIf Alltrim(SA6->A6_COD)=="033"
			cJurDia := 2/30 //GetMv("MV_LJJUROS")
			cMulta := 2
			cInst0:= "AP�S O VENCIMENTO MORA DIA R$ " + transform(SE1->E1_SALDO*(cJurDia/100),'@E 999999.99')
			cInst1:= "AP�S O VENCIMENTO MULTA DE R$ " + transform(SE1->E1_SALDO*(cMulta/100),'@E 999999.99') //strtran(SEE->EE_FORMEN1,"'","")
			//cInst2:= strtran(SEE->EE_FORMEN2,"'","")
			cInst2:= "TITULO REGISTRADO: PROTESTO AP�S 5 DIAS UTEIS DO VENCIMENTO." //strtran(SEE->EE_FORMEN2,"'","")
			cInst3:= "OBS.: N�O ACEITAMOS DEPOSITO EM CONTA CORRENTE." //strtran(SEE->EE_FOREXT1,"'","")
			cInst4:= "COBRAR JUROS DIARIOS DE R$ 4,03"
		Else
			cInst0:= strtran(SEE->EE_FORMEN1,"'","")
			cInst1:= strtran(SEE->EE_FORMEN2,"'","")
			cInst2:= strtran(SEE->EE_FOREXT1,"'","")
			cInst3:= ""
		EndIF

		/*		If alltrim(SE1->E1_TIPO) == 'NF'
			cInst3:= "Num. Nota Fiscal: " + AllTrim(SE1->E1_NUM) + " Serie: " + AllTrim(SE1->E1_PREFIXO)
		Endif
		*/
		cJurdia := ""

		If SA6->A6_COD == '422'
			nVlrDia := Round((SE1->E1_VALOR*(GETMV('MV_TXPER')/30)),2)
			nVlrDia := Transform(nVlrDia,"@E 9,999.99")
			cJurdia := 'Ap�s o vencimento cobrar juros de R$ '+nVlrDia+' ao dia'
		ENDIF

		aBolText    := { cJurdia+mv_par12+mv_par13,mv_par14+mv_par15,mv_par16+mv_par17}

		CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",Subs(aDadosBanco[3],1,4),aDadosBanco[4],aDadosBanco[5],;
			aDadosBanco[6],AllTrim(E1_NUM)+AllTrim(E1_PARCELA),(E1_SALDO-_nVlrAbat),SE1->E1_VENCREA,SEE->EE_CODEMP,SEE->EE_FAXATU,Iif(SE1->E1_DECRESC > 0,.t.,.f.),SE1->E1_PARCELA,aDadosBanco[3])

		aDadosTit    :=  {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)	    ,;  //1-N�mero do t�tulo
			E1_EMISSAO								,;  //2-Data da emiss�o do t�tulo
			dDataBase								,;  //3-Data da emiss�o do boleto
			E1_VENCREA								,;  //4-Data do vencimento
			(E1_SALDO - _nVlrAbat)		,;  //5-Valor do t�tulo
			AllTrim(CB_RN_NN[3])						,;  //6-Nosso n�mero (Ver f�rmula para calculo)
			SE1->E1_DESCFIN							,;  // 7-VAlor do Desconto do titulo
			SE1->E1_VALJUR }                             // 8-Valor dos juros do titulo


		//MONTAGEM DO BOLETO
		If SE1->E1_OK == cMarca
			Impress(oPrint,aBMP,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
			n++

			DbSelectArea("SEE")
			RecLock("SEE",.f.)
			If AllTrim(SA6->A6_COD)=="033"
				SEE->EE_FAXATU :=StrZero(pNumero,12)
			ElseIf AllTrim(SA6->A6_COD) $ "001/237/084"
				SEE->EE_FAXATU :=StrZero(pNumero,11)
			Else
				SEE->EE_FAXATU :=StrZero(pNumero,10)
			EndIf

			DbUnlock()

			DbSelectArea("SE1")

			RecLock("SE1",.f.)

			If SA6->A6_COD == "001"
				SE1->E1_NUMBCO := cNNumSDig
			ElseIf SA6->A6_COD == '033'  //GRAVA NOSSO NUMERO NO TITULO
				SE1->E1_NUMBCO := cNNum
				//itau
			ElseIf SA6->A6_COD == '341'
				SE1->E1_NUMBCO := strtran(SUBSTR(CB_RN_NN[3],1,15),"/")
			ElseIf SA6->A6_COD == '409'
				SE1->E1_NUMBCO := SUBSTR(CB_RN_NN[3],3,10)
			ElseIf SA6->A6_COD == "237"
				SE1->E1_NUMBCO := strtran(SUBSTR(CB_RN_NN[3],4,13),"-")
			Else
				SE1->E1_NUMBCO := cNumbco
			Endif

			If bDanfe==.F.
				SE1->E1_PORTADO	:= if(Alltrim(SE1->E1_PORTADO)="",AllTrim(MV_PAR05),Alltrim(SE1->E1_PORTADO))
				SE1->E1_AGEDEP	:= if(AllTrim(SE1->E1_AGEDEP)="",AllTrim(MV_PAR06),AllTrim(SE1->E1_AGEDEP))
				SE1->E1_CONTA		:= if(AllTrim(SE1->E1_CONTA)="",AllTrim(MV_PAR07),AllTrim(SE1->E1_CONTA))
			Else
				SE1->E1_PORTADO	:= if(Alltrim(SE1->E1_PORTADO)="",AllTrim(xcBanco),Alltrim(SE1->E1_PORTADO))
				SE1->E1_AGEDEP	:= if(AllTrim(SE1->E1_AGEDEP)="",AllTrim(xcAgenc),AllTrim(SE1->E1_AGEDEP))
				SE1->E1_CONTA		:= if(AllTrim(SE1->E1_CONTA)="",AllTrim(xcConta),AllTrim(SE1->E1_CONTA))
			EndIf

			DbUnlock()

		EndIf

		DbSelectArea("SE1")
		SE1->(dbSkip())
		IncProc()
		i++
	EndDo

	oPrint:EndPage()     // Finaliza a p�gina
	oPrint:Preview()     // Visualiza antes de imprimir

	oPrint:SaveAsHTML('c:\00\teste.html')

Return Nil
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)

	//oFont?? = tamanho da fonte usada
	Local oFont8
	Local oFont9
	Local oFont10
	Local oFont16
	Local oFont16n
	Local oFont20
	Local oFont24
	Local i := 0
	Local oBrush                            //fundo no valor do titulo

	//Par�metros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9  := TFont():New("Arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12	:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont20 := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

	oFontCN := TFont():New("Currier New",9,8,.T.,.T.,5,.T.,5,.T.,.F.)

	//oBrush := TBrush():New("",4)
	//oBrush := TBrush():New(,CLR_BLUE,,)
	oBrush := TBrush():New(,,,)

	oPrint:StartPage()   // Inicia uma nova p�gina

	oPrint:Line (150,100,150,2300)


	If aDadosBanco[1] == "001"
		oPrint:SayBitMap(750,100,"\system\bb.bmp",500,130)
		oPrint:SayBitMap(1870,100,"\system\bb.bmp",500,130)
	ElseIf aDadosBanco[1] == "341"
		oPrint:SayBitMap (750,100,"\system\itau.bmp",500,130)
		oPrint:SayBitMap (1870,100,"\system\itau.bmp",500,130)
	ElseIf aDadosBanco[1] == "033"
		oPrint:SayBitMap (750,100,"\system\santander.bmp",500,120)
		oPrint:SayBitMap (1870,100,"\system\santander.bmp",500,120)
	ElseIf aDadosBanco[1] == "237"
		oPrint:SayBitMap (750,100,"\system\bradesco.bmp",500,120)
		oPrint:SayBitMap (1870,100,"\system\bradesco.bmp",500,120)
	ElseIf aDadosBanco[1] == "422"
		oPrint:SayBitMap (750,100,"\system\safra.bmp",500,120)
		oPrint:SayBitMap (1870,100,"\system\safra.bmp",500,120)
	ElseIf aDadosBanco[1] == "084"
		oPrint:SayBitMap (750,100,"\system\prime.bmp",500,120)
		oPrint:SayBitMap (1870,100,"\system\prime.bmp",500,120)
	Endif

	oPrint:Say  (84,1850,"Comprovante de Entrega"                             ,oFont10)

	oPrint:Line (250,100,250,1300 )
	oPrint:Line (350,100,350,1300 )
	oPrint:Line (420,100,420,2300 )
	oPrint:Line (490,100,490,2300 )

	oPrint:Line (350,400,420,400)
	oPrint:Line (420,500,490,500)
	oPrint:Line (350,625,420,625)
	oPrint:Line (350,750,420,750)

	oPrint:Line (150,1300,490,1300 )
	oPrint:Line (150,2300,490,2300 )
	oPrint:Say  (150,1310 ,"MOTIVOS DE N�O ENTREGA (para uso do entregador)"  ,oFont8)
	oPrint:Say  (200,1310 ,"|   | Mudou-se"                                   ,oFont8)
	oPrint:Say  (270,1310 ,"|   | Recusado"                                   ,oFont8)
	oPrint:Say  (340,1310 ,"|   | Desconhecido"                               ,oFont8)

	oPrint:Say  (200,1580 ,"|   | Ausente"                                    ,oFont8)
	oPrint:Say  (270,1580 ,"|   | N�o Procurado"                              ,oFont8)
	oPrint:Say  (340,1580 ,"|   | Endere�o insuficiente"                      ,oFont8)

	oPrint:Say  (200,1930 ,"|   | N�o existe o N�mero"                        ,oFont8)
	oPrint:Say  (270,1930 ,"|   | Falecido"                                   ,oFont8)
	oPrint:Say  (340,1930 ,"|   | Outros(anotar no verso)"                    ,oFont8)

	oPrint:Say  (420,1310 ,"Recebi(emos) o bloqueto"                          ,oFont8)
	oPrint:Say  (450,1310 ,"com os dados ao lado."                            ,oFont8)
	oPrint:Line (420,1700,490,1700)
	oPrint:Say  (420,1705 ,"Data"                                             ,oFont8)
	oPrint:Line (420,1900,490,1900)
	oPrint:Say  (420,1905 ,"Assinatura"                                       ,oFont8)

	oPrint:Say  (150,100 ,"Benefici�rio"                                      ,oFont8)
	oPrint:Say  (180,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],AllTrim(aDadosEmp[1])),oFont9)
	oPrint:Say  (210,100 ,Iif(_lBcoCorrespondente,aDadosBanco[9],AllTrim(aDadosEmp[3])+"-"+AllTrim(aDadosEmp[4])+"-"+AllTrim(aDadosEmp[6])),oFont9)

	oPrint:Say  (250,100 ,"Pagador"                                           ,oFont8)
	oPrint:Say  (290,100 ,aDatSacado[1]+" ("+aDatSacado[2]+")"                ,oFont10)

	oPrint:Say  (350,100 ,"Data do Vencimento"                                ,oFont8)

	If aDadosBanco[1] $ "237/341"  //SE BRADESCO
		oPrint:Say  (380,100 ,Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)  ,oFont10)
	Else
		oPrint:Say  (380,100 ,DTOC(aDadosTit[4])                              ,oFont10)
	Endif

	oPrint:Say  (350,405 ,"Nro.Documento",oFont8)
	oPrint:Say  (380,405 ,AllTrim(Transform(aDadosTit[1],"@! 99999999999")),oFont10)

	oPrint:Say  (350,630,"Moeda"                                              ,oFont8)
	oPrint:Say  (380,655,"R$"     				                              ,oFont10)

	oPrint:Say  (350,755,"Valor/Quantidade"                                   ,oFont8)
	oPrint:Say  (380,765,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")) ,oFont10)

	oPrint:Say  (420,100 ,"Ag�ncia/Cod. Benefici�rio"                         ,oFont8)

	If     aDadosBanco[1] == "033"   //SE BANESPA
		oPrint:Say  (450,100,AllTrim(aDadosBanco[3])+"/"+alltrim(SEE->EE_CODEMP) /*+alltrim(aDadosBanco[4])*/,oFont10)
	ElseIf aDadosBanco[1] == "399"   //SE HSBC
		oPrint:Say  (450,100,aDadosBanco[3]+'-'+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
	ElseIf aDadosBanco[1] == "422"   //SE SAFRA
		oPrint:Say  (450,100,aDadosBanco[3]+' / '+aDadosBanco[4],oFont10)	//+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")
	Else
		oPrint:Say  (450,100,aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
	Endif

	oPrint:Say  (420,505,"Nosso N�mero"                                       ,oFont8)
	oPrint:Say  (450,525,aDadosTit[6]                                         ,oFont10)

	For i := 100 to 2300 step 50
		oPrint:Line( 520, i, 520, i+30)
	Next i

	For i := 100 to 2300 step 50
		oPrint:Line( 750, i, 750, i+30)
	Next i

	//���������������������������������������������������������������������Ŀ
	//� Ficha do Sacado                                                      �
	//�����������������������������������������������������������������������

	oPrint:Line (870,100,870,2300)
	oPrint:Line (870,650,770,650 )
	oPrint:Line (870,900,770,900 )

	oPrint:Say  (782,700,aDadosBanco[1]+"-"+If(aDadosBanco[1]<>'422',modulo11(aDadosBanco[1],aDadosBanco[1]),'7'),oFont20 )
	If aDadosBanco[1] == "001"
		//oPrint:Say  (782,100, "BANCO DO BRASIL",oFont14n )
	ElseIf aDadosBanco[1] == "341"
		//oPrint:Say  (782,100, "BANCO ITA�",oFont20 )
	ElseIf aDadosBanco[1] == "033"
		oPrint:Say  (782,100, "SANTANDER",oFont20 )
	ElseIf aDadosBanco[1] == "237"
		oPrint:Say  (782,100, "BRADESCO",oFont20 )
		//ElseIf aDadosBanco[1] == "422"
		//	oPrint:Say  (782,100, "SAFRA",oFont20 )
	Endif

	oPrint:Line (0970,100,0970,2300 )
	oPrint:Line (1070,100,1070,2300 )
	oPrint:Line (1140,100,1140,2300 )
	oPrint:Line (1210,100,1210,2300 )

	oPrint:Line (1070,500,1210,500)
	oPrint:Line (1140,750,1210,750)
	oPrint:Line (1070,1000,1210,1000)
	oPrint:Line (1070,1350,1140,1350)
	oPrint:Line (1070,1550,1210,1550)

	oPrint:Say  (870,100 ,"Local de Pagamento"                                         ,oFont8)

	If     aDadosBanco[1] == "237"
		oPrint:Say  (0910,100 ,"Pag�vel preferencialmente na rede Bradesco ou Bradesco Expresso" ,oFont10)
	ElseIf aDadosBanco[1] == "341"
		oPrint:Say  (0910,100 ,"PAG�VEL EM QUALQUER BANCO AT� O VENCIMENTO" ,oFont10)
	ElseIf aDadosBanco[1] == "409"
		oPrint:Say  (0910,100 ,"Pag�vel em qualquer banco at� o vencimento, ap�s somente no Unibanco" ,oFont10)
	ElseIf aDadosBanco[1] == "422"
		oPrint:Say  (0910,100 ,"Pag�vel em qualquer banco do sistema de compensa��o" ,oFont10)
	ElseIf aDadosBanco[1] == "399"
		oPrint:Say  (0910,100 ,"Pagar preferencialmente em ag�ncia HSBC" ,oFont10)
	ElseIf aDadosBanco[1] == "084"

		oPrint:Say  (0910,100 ,"Pag�vel em qualquer banco at� o vencimento"  ,oFont10)
	Endif


	oPrint:Say  (870,1910,"Vencimento"                                                 ,oFont8)

	If aDadosBanco[1] $ "237/341"  //SE BRADESCO
		oPrint:Say  (0910,2055,PadL(AllTrim(Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)),16," ")  ,oFont10)
	Else
		oPrint:Say  (0910,2055,PadL(AllTrim(DTOC(aDadosTit[4])),16)                     ,oFont10)
	Endif


	oPrint:Say  (0970,100 ,"Benefici�rio"                                               ,oFont8)
	oPrint:Say  (1000,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],AllTrim(aDadosEmp[1])+"-"+AllTrim(aDadosEmp[2])),oFont9)
	oPrint:Say  (1030,100 ,Iif(_lBcoCorrespondente,aDadosBanco[9],AllTrim(aDadosEmp[3])+"-"+AllTrim(aDadosEmp[4])+"-"+AllTrim(aDadosEmp[6])),oFont9)


	oPrint:Say  (0970,1910,"Ag�ncia/C�digo Benefici�rio"                                ,oFont8)

	if     aDadosBanco[1] = '001'
		nLbco := 2040
		nNoss := 2040
	elseif aDadosBanco[1] = '033'
		nLbco := 1975
		nNoss := 2040
	elseif aDadosBanco[1] = '224' .or. aDadosBanco[1] = '224'
		nLbco := 2035
		nNoss := 2070
	elseif aDadosBanco[1] = '237'
		nLbco := 2040
		nNoss := 2030
	elseif aDadosBanco[1] = '341'
		nLbco := 2068
		nNoss := 2035
	elseif aDadosBanco[1] = '356'
		nLbco := 2010
		nNoss := 2020
	elseif aDadosBanco[1] = '399'
		nLbco := 2010
		nNoss := 2040
	elseif aDadosBanco[1] = '409'
		nLbco := 2005
		nNoss := 1990
	elseif aDadosBanco[1] = '422'
		nLbco := 2000
		nNoss := 2055
	else
		nLbco := 2040
		nNoss := 2040
	endif

	If aDadosBanco[1]     == "033"   //SE BANESPA
		oPrint:Say  (1010,nLbco,AllTrim(aDadosBanco[3])+'/'+alltrim(SEE->EE_CODEMP)/*+alltrim(aDadosBanco[4])*/,oFont10)
	ElseIf aDadosBanco[1] == "399"   //SE HSBC
		oPrint:Say  (1010,nLbco,aDadosBanco[3]+'-'+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
	ElseIf aDadosBanco[1] == "422"   //SE SAFRA
		oPrint:Say  (1010,nLbco,aDadosBanco[3]+' / '+aDadosBanco[4],oFont10)	//+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")
	Else
		oPrint:Say  (1010,nLbco,AllTrim(aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")),oFont10)
	Endif

	oPrint:Say  (1070,100 ,"Data do Documento"                                          ,oFont8)

	If aDadosBanco[1] == "237"
		oPrint:Say  (1100,100 ,Substring(DTOS(aDadosTit[3]),7,2)+"/"+Substring(DTOS(aDadosTit[3]),5,2)+"/"+Substring(DTOS(aDadosTit[3]),1,4)  ,oFont10)
	Else
		oPrint:Say  (1100,100 ,DTOC(aDadosTit[3])                                       ,oFont10)
	Endif

	oPrint:Say  (1070,505 ,"Nro.Documento"                                              ,oFont8)
	oPrint:Say  (1100,595 ,AllTrim(Transform(aDadosTit[1],"@! 99999999999")),oFont10)

	oPrint:Say  (1070,1005,"Esp�cie Doc."                                               ,oFont8)

	If aDadosBanco[1] == "399"  //SE HSBC
		oPrint:Say  (1100,1105,"PD"                                                         ,oFont10)
	Else
		oPrint:Say  (1100,1105,"DM"                                                         ,oFont10)
	Endif

	oPrint:Say  (1070,1355,"Aceite"                                                     ,oFont8)
	oPrint:Say  (1100,1455,"N"                                                          ,oFont10)

	oPrint:Say  (1070,1555,"Data do Processamento"                                      ,oFont8)

	If aDadosBanco[1] == "237"
		oPrint:Say  (1100,1655,Substring(DTOS(aDadosTit[2]),7,2)+"/"+Substring(DTOS(aDadosTit[2]),5,2)+"/"+Substring(DTOS(aDadosTit[2]),1,4)  ,oFont10)
	Else
		oPrint:Say  (1100,1655,DTOC(aDadosTit[2])                                       ,oFont10)
	Endif

	oPrint:Say  (1070,1910,"Nosso N�mero"                                               ,oFont8)
	oPrint:Say  (1100,nNoss,AllTrim(aDadosTit[6])                                       ,oFont10)

	oPrint:Say  (1140,100 ,"Uso do Banco"                                               ,oFont8)

	If aDadosBanco[1] == "409"
		oPrint:Say  (1170,100,"cvt 5539-5",oFont10)
	Endif

	oPrint:Say  (1140, 505,"Carteira"                                                   ,oFont8)
	If     aDadosBanco[1] == "033"
		oPrint:Say  (1170, 520,"SIMPLES ECR"                                            ,oFont10)
	ElseIf aDadosBanco[1] == "399"
		oPrint:Say  (1170, 540,"CSB"                                                    ,oFont10)
	Else
		oPrint:Say  (1170, 540,aDadosBanco[6]+aDadosBanco[7]                            ,oFont10)
	Endif

	oPrint:Say  (1140, 755,"Esp�cie"                                                    ,oFont8)
	oPrint:Say  (1170, 805,"R$"                                                         ,oFont10)

	oPrint:Say  (1140,1005,"Quantidade"                                                 ,oFont8)
	oPrint:Say  (1140,1555,"Valor"                                                      ,oFont8)

	oPrint:Say  (1140,1910,"(=)Valor do Documento"                                      ,oFont8)

	If aDadosBanco[1] == "341"
		oPrint:Say  (1170,2060,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)
	else
		oPrint:Say  (1170,2045,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)
	endif

	If aDadosBanco[1] == "341"
		oPrint:Say  (1210,100 ,"Instru��es/Todos as informa��es deste bloqueto s�o de exclusiva responsabilidade do benefici�rio",oFont8)
	ElseIf aDadosBanco[1] == "001"
		oPrint:Say  (1210,100 ,"PAG�VEL EM QUALQUER BANCO",oFont8)
	Else
		oPrint:Say  (1210,100 ,"Instru��es/Texto de responsabilidade do benefici�rio"        ,oFont8)
	Endif

	If aDadosBanco[1] == "341"
		oPrint:Say  (1240,2060,PadL(AllTrim(Transform( aDadosTit[5] * (aDadosTit[7]/100),"@E 999,999,999.99")),16," "),oFont10)
	Else
		oPrint:Say  (1240,2045,PadL(AllTrim(Transform( aDadosTit[5] * (aDadosTit[7]/100),"@E 999,999,999.99")),16," "),oFont10)
	Endif

	//oPrint:Say  (1260,100 ,cInst0 ,oFontCN)
	oPrint:Say  (1260,100 ,cInst0 ,oFontCN)
	oPrint:Say  (1295,100 ,cInst1 ,oFontCN)
	oPrint:Say  (1330,100 ,cInst2 ,oFontCN)
	IF aDadosBanco[1] == "033"
		oPrint:Say  (1400,100 ,cInst3 ,oFontCN)
	ELSE
		oPrint:Say  (1380,100 ,aBolText[1],oFontCN)
	ENDIF
	//oPrint:Say  (1350,100 ,cInst3 ,oFontCN)
	oPrint:Say  (1365,100 ,cInst4 ,oFontCN)
	oPrint:Say  (1380,100 ,aBolText[1],oFontCN)
	oPrint:Say  (1410,100 ,aBolText[2],oFontCN)
	oPrint:Say  (1440,100 ,aBolText[3],oFontCN)

	oPrint:Say  (1210,1910,"(-)Desconto/Abatimento"                                     ,oFont8)
	oPrint:Say  (1280,1910,"(-)Outras Dedu��es"                                         ,oFont8)
	oPrint:Say  (1350,1910,"(+)Mora/Multa"                                              ,oFont8)
	oPrint:Say  (1420,1910,"(+)Outros Acr�scimos"                                       ,oFont8)
	oPrint:Say  (1490,1910,"(=)Valor Cobrado"                                           ,oFont8)

	oPrint:Say  (1560 ,100 ,"Pagador:"                                                  ,oFont8)
	oPrint:Say  (1588 ,210 ,aDatSacado[1]+" ("+aDatSacado[2]+")"                        ,oFont8)
	oPrint:Say  (1630 ,210 ,aDatSacado[3]                                               ,oFont8)
	oPrint:Say  (1670 ,210 ,aDatSacado[6]+"  "+aDatSacado[4]+" - "+aDatSacado[5]+"         CGC/CPF: "+Iif(Len(AllTrim(aDatSacado[7]))==14,Transform(aDatSacado[7],"@R 99.999.999/9999-99"),Transform(aDatSacado[7],"@R 999.999.999-99")) ,oFont8)

	If aDadosBanco[1] == "422"
		oPrint:Say  (1525,100 ,"Sacador/Avalista "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)
	Else
		oPrint:Say  (1525,100 ,"Pagador/Avalista "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)
	EndIf

	oPrint:Say  (1710,1500,"Autentica��o Mec�nica "                                     ,oFont8)
	oPrint:Say  (0804,1850,"Recibo do Pagador"                                          ,oFont10)

	oPrint:Line (0870,1900,1560,1900 )
	oPrint:Line (1280,1900,1280,2300 )
	oPrint:Line (1350,1900,1350,2300 )
	oPrint:Line (1420,1900,1420,2300 )
	oPrint:Line (1490,1900,1490,2300 )
	oPrint:Line (1560,100 ,1560,2300 )

	oPrint:Line (1705,100,1705,2300  )

	For i := 100 to 2300 step 50
		oPrint:Line( 1870, i, 1870, i+30)
	Next i


	//���������������������������������������������������������������������Ŀ
	//� Ficha de Compensacao                                                �
	//�����������������������������������������������������������������������
	oPrint:Line (1990,100,1990,2300)
	oPrint:Line (1990,650,1890,650 )
	oPrint:Line (1990,900,1890,900 )

	oPrint:Say  (1902,700,aDadosBanco[1]+"-"+If(aDadosBanco[1]<>'422',modulo11(aDadosBanco[1],aDadosBanco[1]),'7'),oFont20 )

	oPrint:Say  (1900,1004,CB_RN_NN[2],oFont12) //linha digitavel

	If aDadosBanco[1] == "001"
		//oPrint:Say  (1900,100, "BANCO DO BRASIL",oFont14n )
	ElseIf aDadosBanco[1] == "341"
		//oPrint:Say  (1900,100, "BANCO ITA�",oFont20 )
	ElseIf aDadosBanco[1] == "033"
		oPrint:Say  (1900,100, "SANTANDER",oFont20 )
	ElseIf aDadosBanco[1] == "237"
		oPrint:Say  (1900,100, "BRADESCO",oFont20 )
		//ElseIf aDadosBanco[1] == "422"
		//	oPrint:Say  (1900,100, "SAFRA",oFont20 )
	Endif

	oPrint:Line (2090,100,2090,2300 )
	oPrint:Line (2190,100,2190,2300 )
	oPrint:Line (2260,100,2260,2300 )
	oPrint:Line (2330,100,2330,2300 )

	oPrint:Line (2190,500,2330,500)
	oPrint:Line (2260,750,2330,750)
	oPrint:Line (2190,1000,2330,1000)
	oPrint:Line (2190,1350,2260,1350)
	oPrint:Line (2190,1550,2330,1550)

	oPrint:Say  (1990,100 ,"Local de Pagamento"                             ,oFont8)

	If aDadosBanco[1] == "237"
		oPrint:Say  (2030,100 ,"Pag�vel preferencialmente na rede Bradesco ou Bradesco Expresso"       ,oFont10)
	ElseIf aDadosBanco[1] == "341"
		oPrint:Say  (2030,100 ,"At� o vencimento, preferencialmente no Itau e Ap�s o vencimento, somente no Itau" ,oFont10)
	ElseIf aDadosBanco[1] == "409"
		oPrint:Say  (2030,100 ,"Pag�vel em qualquer banco at� o vencimento, ap�s somente no Unibanco" ,oFont10)
	ElseIf aDadosBanco[1] == "422"
		oPrint:Say  (2030,100 ,"Pag�vel em qualquer banco do sistema de compensa��o" ,oFont10)
	ElseIf aDadosBanco[1] == "399"
		oPrint:Say  (2030,100 ,"Pagar preferencialmente em ag�ncia HSBC" ,oFont10)
	Else
		oPrint:Say  (2030,100 ,"Pag�vel em qualquer banco at� o vencimento"       ,oFont10)
	Endif


	oPrint:Say  (1990,1910,"Vencimento"                                     ,oFont8)

	If aDadosBanco[1] $ "237/341"
		oPrint:Say  (2030,2055,PadL(AllTrim(Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)),16," ")  ,oFont10)
	Else
		oPrint:Say  (2030,2055,PadL(AllTrim(DTOC(aDadosTit[4])),16," ")                               ,oFont10)
	Endif


	oPrint:Say  (2090,100 ,"Benefici�rio"                                        ,oFont8)
	oPrint:Say  (2120,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],AllTrim(aDadosEmp[1])+"-"+AllTrim(aDadosEmp[2])),oFont9)
	oPrint:Say  (2150,100 ,Iif(_lBcoCorrespondente,aDadosBanco[9],AllTrim(aDadosEmp[3])+"-"+AllTrim(aDadosEmp[4])+"-"+AllTrim(aDadosEmp[6])),oFont9)

	oPrint:Say  (2090,1910,"Ag�ncia/C�digo Benefici�rio"                         ,oFont8)

	If     aDadosBanco[1] == "033"   //SE BANESPA
		oPrint:Say  (2130,nLbco,AllTrim(aDadosBanco[3])+"/"+alltrim(SEE->EE_CODEMP)/*+alltrim(aDadosBanco[4])*/,oFont10)
	ElseIf aDadosBanco[1] == "399"   //SE HSBC
		oPrint:Say  (2130,nLbco,aDadosBanco[3]+'-'+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
	ElseIf aDadosBanco[1] == "422"   //SE SAFRA
		oPrint:Say  (2130,nLbco,aDadosBanco[3]+' / '+aDadosBanco[4],oFont10)	 //+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")
	Else
		oPrint:Say  (2130,nLbco,AllTrim(aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")),oFont10)
	Endif

	oPrint:Say  (2190,100 ,"Data do Documento"                              ,oFont8)

	If aDadosBanco[1] == "237"
		oPrint:Say  (2220,100 ,Substring(DTOS(aDadosTit[3]),7,2)+"/"+Substring(DTOS(aDadosTit[3]),5,2)+"/"+Substring(DTOS(aDadosTit[3]),1,4)  ,oFont10)
	Else
		oPrint:Say  (2220,100 ,DTOC(aDadosTit[3])                               ,oFont10)
	Endif


	oPrint:Say  (2190,505 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (2220,605 ,AllTrim(Transform(aDadosTit[1],"@! 99999999999")),oFont10)

	oPrint:Say  (2190,1005,"Esp�cie Doc."                                   ,oFont8)

	If aDadosBanco[1] == "399"  //SE HSBC
		oPrint:Say  (2220,1105,"PD"                                             ,oFont10)
	Else
		oPrint:Say  (2220,1105,"DM"                                             ,oFont10)
	Endif

	oPrint:Say  (2190,1355,"Aceite"                                         ,oFont8)
	oPrint:Say  (2220,1455,"N"                                              ,oFont10)

	oPrint:Say  (2190,1555,"Data do Processamento"                          ,oFont8)

	If aDadosBanco[1] == "237"
		oPrint:Say  (2220,1655,Substring(DTOS(aDadosTit[2]),7,2)+"/"+Substring(DTOS(aDadosTit[2]),5,2)+"/"+Substring(DTOS(aDadosTit[2]),1,4)  ,oFont10)
	Else
		oPrint:Say  (2220,1655,DTOC(aDadosTit[2])                           ,oFont10)
	Endif


	oPrint:Say  (2190,1910,"Nosso N�mero"                                   ,oFont8)
	oPrint:Say  (2220,nNoss,AllTrim(aDadosTit[6])                            ,oFont10)

	oPrint:Say  (2260,100 ,"Uso do Banco"                                   ,oFont8)
	If aDadosBanco[1] == "409"
		oPrint:Say  (2290,100 ,"cvt 5539-5"  ,oFont10)
	Endif

	oPrint:Say  (2260,505 ,"Carteira"                                       ,oFont8)
	If     aDadosBanco[1] == "033"
		oPrint:Say  (2290,520,"SIMPLES ECR"                                 ,oFont10)
	ElseIf aDadosBanco[1] == "399"
		oPrint:Say  (2290, 540,"CSB"                                        ,oFont10)
	Else
		oPrint:Say  (2290,540 ,aDadosBanco[6]+aDadosBanco[7]                ,oFont10)
	Endif


	oPrint:Say  (2260,755 ,"Esp�cie"                                        ,oFont8)
	oPrint:Say  (2290,805 ,"R$"                                             ,oFont10)

	oPrint:Say  (2260,1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (2260,1555,"Valor"                                          ,oFont8)

	oPrint:Say  (2260,1910,"(=)Valor do Documento"                          ,oFont8)

	If aDadosBanco[1] == "341"
		oPrint:Say  (2290,2060,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)
	Else
		oPrint:Say  (2290,2045,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)
	Endif

	If aDadosBanco[1] == "341"
		oPrint:Say  (2330,100 ,"Instru��es/Todos as informa��es deste bloqueto s�o de exclusiva responsabilidade do benefici�rio",oFont8)
	Elseif aDadosBanco[1] == "001"
		oPrint:Say  (2330,100 ,"PAG�VEL EM QUALQUER BANCO",oFont8)
	Else
		oPrint:Say  (2330,100 ,"Instru��es/Texto de responsabilidade do benefici�rio",oFont8)
	Endif

	If aDadosBanco[1] == "341"
		oPrint:Say  (2360,2060,PadL(AllTrim(Transform( aDadosTit[5] * (aDadosTit[7]/100),"@E 999,999,999.99")),16," "),oFont10)
	Else
		oPrint:Say  (2360,2045,PadL(AllTrim(Transform( aDadosTit[5] * (aDadosTit[7]/100),"@E 999,999,999.99")),16," "),oFont10)
	Endif

	//oPrint:Say  (2370,100 ,cInst0 ,oFontCN)
	oPrint:Say  (2370,100 ,cInst0 ,oFontCN)
	oPrint:Say  (2405,100 ,cInst1 ,oFontCN)
	oPrint:Say  (2440,100 ,cInst2 ,oFontCN)
	IF aDadosBanco[1] == "033"
		oPrint:Say  (2510,100 ,cInst3 ,oFontCN)
	ELSE
		oPrint:Say  (2480,100 ,aBolText[1],oFontCN)
	ENDIF
	oPrint:Say  (2475,100 ,cInst4 ,oFontCN)
	oPrint:Say  (2480,100 ,aBolText[1],oFontCN)
	oPrint:Say  (2530,100 ,aBolText[2],oFontCN)
	oPrint:Say  (2580,100 ,aBolText[3],oFontCN)

	oPrint:Say  (2330,1910,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (2400,1910,"(-)Outras Dedu��es"                             ,oFont8)
	oPrint:Say  (2470,1910,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (2540,1910,"(+)Outros Acr�scimos"                           ,oFont8)
	oPrint:Say  (2610,1910,"(=)Valor Cobrado"                               ,oFont8)

	oPrint:Say  (2680,100 ,"Pagador"                                         ,oFont8)
	oPrint:Say  (2708,210 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)
	oPrint:Say  (2748,210 ,aDatSacado[3]                                    ,oFont8)
	oPrint:Say  (2788,210 ,aDatSacado[6]+"  "+aDatSacado[4]+" - "+aDatSacado[5]+"         CGC/CPF: "+Iif(Len(AllTrim(aDatSacado[7]))==14,Transform(aDatSacado[7],"@R 99.999.999/9999-99"),Transform(aDatSacado[7],"@R 999.999.999-99")) ,oFont8)

	If aDadosBanco[1] == "422"
		oPrint:Say  (1525,100 ,"Benefici�rio final "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)
		oPrint:Say  (2830,100 ,"Benefici�rio final "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)
	Else
		oPrint:Say  (1525,100 ,"Pagador/Avalista "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)
	EndIf

	oPrint:Say  (2830,1500,"Autentica��o Mec�nica -"                        ,oFont8)

	If aDadosBanco[1] == "341"
		oPrint:Say  (2830,1850,"Ficha de Compensa��o"                       ,oFont8)
	Else
		oPrint:Say  (2830,1850,"Ficha de Compensa��o"                       ,oFont10)
	Endif

	oPrint:Line (1990,1900,2680,1900 )
	oPrint:Line (2400,1900,2400,2300 )
	oPrint:Line (2470,1900,2470,2300 )
	oPrint:Line (2540,1900,2540,2300 )
	oPrint:Line (2610,1900,2610,2300 )
	oPrint:Line (2680,100 ,2680,2300 )

	oPrint:Line (2825,100,2825,2300  )

	MSBAR("INT25"  ,25.9,1.5,CB_RN_NN[1],oPrint,.F.,,,0.0253,1.6,,,,.F.)
	//MSBAR("INT25"  ,25,1.5,CB_RN_NN[1],oPrint,.F.,,,,1.6,,,,.F.)
	//MSBAR("INT25"  ,12.5,0.40,CB_RN_NN[1],oPrint,.F.,,,0.023,1.4,,,,.F.)


	/*
MSBAR("INT25"  , 21  ,  3 ,"123456789012",oPr,,,.t.)
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Parametros� 01 cTypeBar String com o tipo do codigo de barras          ���
���          �             "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"     ���
���          �             "INT25","MAT25,"IND25","CODABAR" ,"CODE3_9"    ���
���          � 02 nRow     Numero da Linha em centimentros                ���
���          � 03 nCol     Numero da coluna em centimentros               ���
���          � 04 cCode    String com o conteudo do codigo                ���
���          � 05 oPr      Objeto Printer                                 ���
���          � 06 lcheck   Se calcula o digito de controle                ���
���          � 07 Cor      Numero  da Cor, utilize a "common.ch"          ���
���          � 08 lHort    Se imprime na Horizontal                       ���
���          � 09 nWidth   Numero do Tamanho da barra em centimetros      ���
���          � 10 nHeigth  Numero da Altura da barra em milimetros        ���
���          � 11 lBanner  Se imprime o linha em baixo do codigo          ���
���          � 12 cFont    String com o tipo de fonte                     ���
���          � 13 cMode    String com o modo do codigo de barras CODE128  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
	/*/


	oPrint:EndPage() // Finaliza a p�gina

Return Nil
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Modulo10(cData)

	Local L,D,P := 0
	Local B     := .F.

	L := Len(cData)  //TAMANHO DE BYTES DO CARACTER
	B := .T.
	D := 0     //DIGITO VERIFICADOR
	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End

Return(D)
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
static Function Modulo11(cData,cBanc)

	Local L, D, P := 0

	cData:=alltrim(cData)

	If cBanc == "001"  // Banco do brasil
		L := Len(cdata)
		D := 0
		P := 10
		While L > 0
			P := P - 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 2
				P := 10
			End
			L := L - 1
		End
		D := mod(D,11)
		If len(cData) > 20
			If D == 10 .or. D == 11 .or. D == 0
				D := "1"
			Else
				D := AllTrim(Str(D))
			End
		Else
			If D == 10
				D := "X"
			Else
				D := AllTrim(Str(D))
			End
		Endif
	ElseIf cBanc == "341" .Or. cBanc == "453" .or. cBanc == "224" // Itau/Mercantil/Rural/Safra
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End

		D := 11 - (mod(D,11))

		If (D == 10 .Or. D == 11) .and. (cBanc == "341" .or. cBanc == "422" .or. cBanc == "224")
			D := 1
		End
		If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (cBanc == "289" .Or. cBanc == "453")
			D := 0
		End
		D := AllTrim(Str(D))
	ElseIf  cBanc == "422"
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End

		D := 11 - (mod(D,11))

		If (D == 10 .Or. D == 11) .and. (cBanc == "341" .or. cBanc == "422" .or. cBanc == "224")
			D := 1
		End
		If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (cBanc == "289" .Or. cBanc == "453")
			D := 0
		End
		D := AllTrim(Str(D))

	ElseIf cBanc == "237"
		Q := If(len(cData) > 20,9,7)
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = Q
				P := 1
			End
			L := L - 1
		End
		D := 11 - (mod(D,11))

		If     D == 10
			If Len(cData) > 20
				D := '1'
			Else
				D := 'P'
			Endif
		ElseIf D == 11
			If Len(cData) > 20
				D := '1'
			Else
				D := '0'
			Endif
		ElseIf D == 0
			If Len(cData) > 20
				D := '1'
			Else
				D := '0'
			Endif
		Else
			D := AllTrim(Str(D))
		End
	ElseIf cBanc == "389" //Mercantil
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := mod(D,11)
		If D == 1 .Or. D == 0
			D := 0
		Else
			D := 11 - D
		End
		D := AllTrim(Str(D))
	ElseIf cBanc == "479"  //BOSTON
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := Mod(D*10,11)
		If D == 10
			D := 0
		End
		D := AllTrim(Str(D))
	ElseIf cBanc == "409"  //UNIBANCO
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := Mod(D*10,11)
		If D == 10 .or. D == 0
			If Len(cData) > 20
				D := 1
			Else
				D := 0
			Endif
		End
		D := AllTrim(Str(D))
	ElseIf cBanc == "356"  //Real
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := Mod(D*10,11)
		If D == 10 .or. D == 0
			D := 0
		End
		D := AllTrim(Str(D))
	ElseIf  cBanc == "399"  //HSBC
		Q := If(len(cData) > 20,9,7)
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = Q
				P := 1
			End
			L := L - 1
		End
		D := (mod(D,11))        //Alterado em 13/04 - os digitos 0 e 1 estavam inconsistentes de acordo com o calculo
		If (D == 0 .Or. D == 1)
			If Len(cData) > 20
				D := 1
			Else
				D := 0
			Endif
		Else
			D := 11 - (mod(D,11))
		End
		D := AllTrim(Str(D))
	ElseIf cBanc == "084"  //UNIPRIME
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 7
				P := 1
			End
			L := L - 1
		End
		D := 11 - (mod(D,11))
		If (D == 10 .Or. D == 11)
			D := 1
		End
		D := AllTrim(Str(D))
	Else
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := 11 - (mod(D,11))
		If (D == 10 .Or. D == 11)
			D := 1
		End
		D := AllTrim(Str(D))
	Endif

Return(D)

//Retorna os strings para inpress�o do Boleto
//CB = String para o c�d.barras, RN = String com o n�mero digit�vel
//Cobran�a n�o identificada, n�mero do boleto = T�tulo + Parcela
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,cConvenio,cSequencial,_lTemDesc,_cParcela,_cAgCompleta)

	Local cCodEmp := StrZero(Val(SubStr(cConvenio,1,6)),6)
	Local cNumSeq := strzero(val(cSequencial),5)
	Local blvalorfinal := strzero(round(nValor*100,10),10)
	Local cCpoLivre := cCBSemDig := cCodBarra := cFatVenc := ''
	Local cNossoNum
	Local _cDigito := ""
	Local _cSuperDig := ""

	_cParcela := NumParcela(_cParcela)

	//Fator Vencimento - POSICAO DE 06 A 09
	cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)

	//Proximo numero da faixa
	pNumero := val(SEE->EE_FAXATU)

	//Campo Livre (Definir campo livre com cada banco)

	If Substr(cBanco,1,3) == "001"  // Banco do brasil

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			pNumero := val(SEE->EE_FAXATU) + 1

			cNNumSDig := strzero(pNumero,10)

		else

			cNNumSDig := alltrim(SE1->E1_NUMBCO)

		endif

		//Nosso Numero com digito
		cNumbco	:= Alltrim(cconvenio)+cNNumSDig
		//cNNumSDig := Alltrim(cconvenio)+cNNumSDig
		cNNum   := cNumbco  + modulo11(cNumbco,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		cNossoNum := cvaltochar(cNumbco) + "-" + modulo11(cNumbco,SubStr(cBanco,1,3))

		//cContNum := cNNumSDig //strzero(val(cNNumSDig),10)cContNum
		//cCpoLivre := substr(cconvenio,1,4)+strzero(val(cNNumSDig),7) + cAgencia + StrZero(Val(cConta),8) + cCarteira
		cCpoLivre := cNumbco + cAgencia + StrZero(Val(cConta),8) + cCarteira

		//cCpoLivre := Alltrim(cconvenio) + cAgencia + StrZero(Val(cConta),8) + cNNumSDig //cCarteira
		//cCpoLivre := strzero(val(cNNumSDig),11) + cAgencia + StrZero(Val(cConta),8) + cCarteira
		//cCpoLivre := strzero(val(cContNum),11) + cAgencia + StrZero(Val(cConta),8) + cCarteira


	ElseIf Substr(cBanco,1,3) == "033"  // Banespa

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			pNumero := val(SEE->EE_FAXATU) + 1

			//		cNNumSDig := AllTrim(cConvenio)+strzero(pNumero,10)
			cNNumSDig := strzero(pNumero,12)

		else

			cNNumSDig := substr(alltrim(SE1->E1_NUMBCO),1,12)  //alteracao 13-08-2014 erro nosso numero santander

		endif

		//Nosso Numero com digito
		cNumbco	:= cNNumSDig
		cNNum   := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		cNossoNum := cNNumSDig + "-" + modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//	cCpoLivre := cNNumSDig + cAgencia + StrZero(Val(cConta),8) + cCarteira

		cCpoLivre := "9" + strzero(val(substr(cConvenio,1,7)),7) + strzero(val(cNNumSDig),12) + modulo11(cNNumSDig,SubStr(cBanco,1,3)) + '0' + cCarteira


	Elseif Substr(cBanco,1,3) == "422"  // Banco Safra --- Ajustado nosso n�mero com 8 posi��es

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			pNumero := val(SEE->EE_FAXATU) + 1

			//cNNumSDig := alltrim(str(pNumero,10))
			cNNumSDig := STRZERO(pNumero,9)
		else

			//cNNumSDig := alltrim(str(val(SE1->E1_NUMBCO),10))
			cNNumSDig := STRZERO(val(SE1->E1_NUMBCO),9)
		endif

		//Nosso Numero
		cNumbco	:= cNNumSDig
		cNNum := cNNumSDig //+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		cNossoNum := cNNumSDig + "-" + modulo11(cNNumSDig,SubStr(cBanco,1,3))
		//cCpoLivre := "7"+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),10) + cDacCC + cNNum + "2"
		cCpoLivre := "7"+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),10) + cNNum + "2"

	Elseif Substr(cBanco,1,3) == "237" // Banco Bradesco    -- CARTEIRA + SEQUENCIAL COM 11 POSI��ES

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			//		pNumero   := val(cCarteira + bldocnufinal)
			//		cNNumSDig := cCarteira + bldocnufinal

			pNumero := val(SEE->EE_FAXATU) + 1

			cNNumSDig := strzero(pNumero,11)


		else

			cNNumSDig := alltrim(SE1->E1_NUMBCO)

		endif

		cCarteira := alltrim(cCarteira)

		//Nosso Numero sem digito
		cNumbco	:= cNNumSDig
		//	cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero
		//	cNNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
		cNNum := cCarteira + '/' + cNumbco + '-' + modulo11(cCarteira+cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		//	cNossoNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
		cNossoNum := cCarteira + '/' + cNumbco + '-' + modulo11(cCarteira+cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cAgencia + cCarteira + cNNumSDig + StrZero(Val(cConta),7) + "0"

	Elseif Substr(cBanco,1,3) == "084" // Banco Bradesco    -- CARTEIRA + SEQUENCIAL COM 11 POSI��ES

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			//		pNumero   := val(cCarteira + bldocnufinal)
			//		cNNumSDig := cCarteira + bldocnufinal

			pNumero := val(SEE->EE_FAXATU) + 1

			cNNumSDig := strzero(pNumero,11)


		else

			cNNumSDig := alltrim(SE1->E1_NUMBCO)

		endif

		cCarteira := alltrim(cCarteira)

		//Nosso Numero sem digito
		cNumbco	:= cNNumSDig
		//	cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero
		//	cNNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
		cNNum := cCarteira + '/' + cNumbco + '-' + modulo11(cCarteira+cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		//	cNossoNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
		cNossoNum := cCarteira + '/' + cNumbco + '-' + modulo11(cCarteira+cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cAgencia + cCarteira + cNNumSDig + StrZero(Val(cConta),7) + "0"

	Elseif Substr(cBanco,1,3) == "341"  // Banco Itau

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			//		pNumero   := val(cCarteira+strzero(val(cNroDoc),6)+ _cParcela)
			//		cNNumSDig := cCarteira+strzero(val(cNroDoc),6)+ _cParcela

			pNumero := val(SEE->EE_FAXATU) + 1

			cNNumSDig := alltrim(str(pNumero,10))

		else

			cNNumSDig := alltrim(str(val(SE1->E1_NUMBCO),10))

		endif

		//Nosso Numero
		cNumbco	:= strzero(val(cNNumSDig),8)
		cNNumSDig := cCarteira + cNumbco
		//	cNNum := cCarteira+strzero(val(cNroDoc),6) + _cParcela + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )

		//Nosso Numero para impressao
		//	cNossoNum := cCarteira+"/"+strzero(val(cNroDoc),6)+ _cParcela +'-' + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )
		cCalcDig      := AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )
		cNossoNum := cCarteira + '/' + cNumbco + '-' + cCalcDig

		cCpoLivre := cNNumSDig + cCalcDig + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cDacCC + "000"

	Elseif Substr(cBanco,1,3) == "356" // Banco REAL

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			pNumero := val(SEE->EE_FAXATU) + 1

			cNNumSDig := strzero(pNumero,13)

		else

			cNNumSDig := alltrim(SE1->E1_NUMBCO)

		endif

		//Nosso Numero
		cNumbco	:= cNNumSDig
		cNNum   := cNNumSDig

		//Nosso Numero para impressao
		cNossoNum := cNNum
		cCpoLivre := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + AllTrim(Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)+cNNumSDig ) ) ) + cNNumSDig

	Elseif Substr(cBanco,1,3) == "399"  // Banco HSBC

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			pNumero := val(SEE->EE_FAXATU) + 1

			cNNumSDig := strzero(pNumero,10)  //CODIGO CONVENIO COM 5 + SEQUENCIAL COM 5

		else

			cNNumSDig := alltrim(SE1->E1_NUMBCO)

		endif

		//Nosso Numero
		cNumbco	:= cNNumSDig
		cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cNNum + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),6) + cDacCC + "001"

	Elseif Substr(cBanco,1,3) == "389" // Banco mercantil

		pNumero := val(SEE->EE_FAXATU) + 1

		//Nosso Numero sem digito
		cNNumSDig := "09"+cCarteira+ strzero(val(cSequencial),6)
		//Nosso Numero
		cNNum := "09"+cCarteira+ strzero(val(cSequencial),6) + modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))
		//Nosso Numero para impressao
		cNossoNum := "09"+cCarteira+ strzero(val(cSequencial),6) +"-"+ modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cAgencia + cNNum + StrZero(Val(SubStr(cConvenio,1,9)),9)+Iif(_lTemDesc,"0","2")

	Elseif Substr(cBanco,1,3) == "453"  // Banco rural

		pNumero := val(SEE->EE_FAXATU) + 1

		//Nosso Numero sem digito
		cNNumSDig := strzero(val(cSequencial),7)
		//Nosso Numero
		cNNum := cNNumSDig + AllTrim( Str( modulo10( cNNumSDig ) ) )
		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ AllTrim( Str( modulo10( cNNumSDig ) ) )

		cCpoLivre := "0"+StrZero(Val(cAgencia),3) + StrZero(Val(cConta),10)+cNNum+"000"

	Elseif Substr(cBanco,1,3) == "479" // Banco Boston

		pNumero := val(SEE->EE_FAXATU) + 1

		cNumSeq := strzero(val(cSequencial),8)
		cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),9)
		//Nosso Numero sem digito
		cNNumSDig := strzero(val(cSequencial),8)
		//Nosso Numero
		cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cCodEmp+"000000"+cNNum+"8"

	Elseif Substr(cBanco,1,3) == "409" // Banco UNIBANCO

		if empty(SE1->E1_NUMBCO)

			cNNumSDig := strzero(val(SEE->EE_FAXATU) + 1,10)
			pNumero   := val(SEE->EE_FAXATU) + 1

		else

			cNNumSDig := alltrim(SE1->E1_NUMBCO)

		endif

		_cDigito := modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Calculo do super digito
		cSSu := '1'
		_cSuperDig := modulo11(cSSu+cNNumSDig + _cDigito,SubStr(cBanco,1,3))
		cNNum := cSSu+cNNumSDig + _cDigito + _cSuperDig

		//Nosso Numero para impressao
		cNossoNum := cSSu + "/" + cNNumSDig + "-" + _cDigito + "/" + _cSuperDig

		// O codigo fixo "04" e para a cobran�a com registro
		// O codigo fixo "06" e para a cau��o
		cCpoLivre := "04" + SubStr(DtoS(dvencimento),3,6) + StrZero(Val(StrTran(_cAgCompleta,"-","")),5) + cNNumSDig + _cDigito + _cSuperDig

	Endif

	//Dados para Calcular o Dig Verificador Geral
	ccalcg := ''
	If substr(cBanco,1,3) == '001'
		ccalcg := cBanco + cFatVenc + blvalorfinal + SUBSTR(cCpoLivre,1,4)+SUBSTR(CCPOLIVRE,11,7)+SUBSTR(CCPOLIVRE,18,4)+SUBSTR(CCPOLIVRE,22,10)//cCpoLivre
		cCBSemDig := cBanco + cFatVenc + blvalorfinal + '000000' + alltrim(cconvenio) + cNnumsdig + cCarteira
	else
		cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	endif
	//Codigo de Barras Completo
	If substr(cBanco,1,3) <> '084'
		If substr(cBanco,1,3) == '001'
			cCodBarra := cBanco + modulo11(cCBSemDig,substr(cBanco,1,3)) + cFatVenc + blvalorfinal + '000000' + alltrim(cconvenio) + cNnumsdig + cCarteira
		Else
			cCodBarra := cBanco + modulo11(cCBSemDig,substr(cBanco,1,3)) + cFatVenc + blvalorfinal + cCpoLivre
		EndIf
	Else
		cCodBarra := cBanco + modulo11(cCBSemDig,'999') + cFatVenc + blvalorfinal + cCpoLivre
	EndIf
	//Digito Verificador do Primeiro Campo
	//If substr(cBanco,1,3) <> '001'
	cPrCpo := cBanco + SubStr(cCodBarra,20,5)
	cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
	/*else
	cPrCpo := cBanco + SubStr(cCodBarra,10,5)
	cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
EndIf
	*/
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCodBarra,25,10)
	cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))

	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCodBarra,35,10)  //35,10
	cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))

	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)

	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
	//cLinDig += "  " + cFatVenc +blvalorfinal  // fator de vencimento e valor nominal do titulo

	If substr(cbanco,1,3) == "422"
		cNossoNum := substr(cNossoNum,1,9)
	ENDIF

Return({cCodBarra,cLinDig,cNossoNum})
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg

	Local _sAlias,i,j
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,06)
	aRegs:={}

	//(sx1) Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Do Prefixo:         ","","","mv_ch1" ,"C", 3,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Ate o Prefixo:      ","","","mv_ch2" ,"C", 3,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Do Titulo:          ","","","mv_ch3" ,"C", 9,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Ate o Titulo:       ","","","mv_ch4" ,"C", 9,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Do Banco            ","","","mv_ch5" ,"C", 3,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA6",""})
	aAdd(aRegs,{cPerg,"06","Agencia             ","","","mv_ch6" ,"C", 5,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Conta               ","","","mv_ch7" ,"C",10,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08","SubConta            ","","","mv_ch8" ,"C", 3,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"09","Do bordero          ","","","mv_ch9" ,"C", 6,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10","Ate o Bordero       ","","","mv_ch10","C", 6,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"11","Traz marcado        ","","","mv_ch11","N", 1,0,0,"C","","mv_par11","1-Sim","","","","","2-Nao","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"12","Texto 1 da instrucao","","","mv_ch12","C",50,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"13","                    ","","","mv_ch13","C",50,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"14","Texto 2 da instrucao","","","mv_ch14","C",50,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"15","                    ","","","mv_ch15","C",50,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"16","Texto 3 da instrucao","","","mv_ch16","C",50,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"17","                    ","","","mv_ch17","C",50,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+'    '+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
			dbCommit()
		EndIf
	Next

	dbSelectArea(_sAlias)

Return

//FUNCAO PARA CONFIGURAR SETUP DE IMPRESSAO (LOCAL OU SERVER)
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ConfiguraPrt()

	Local oPrint
	oPrint:= TMSPrinter():New( "Boleto Laser" )
	oPrint:SetPortrait() // ou SetLandscape()
	oPrint:Setup()       // setup de impressao

Return
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Agencia(_cBanco,_nAgencia)

	Local _cRet := ""

	If     _cBanco $ "479/389"
		_cRet := SubStr(StrZero(Val(AllTrim(_nAgencia)),5),1,4)+"-"+SubStr(StrZero(Val(AllTrim(_nAgencia)),5),5,1)
	ElseIF _cBanco == "341"
		_cRet := StrZero(Val(AllTrim(_nAgencia)),4)
	ElseIF _cBanco == "001"
		_cRet := SubStr(StrZero(Val(AllTrim(_nAgencia)),5),1,4)+"-"+SubStr(StrZero(Val(AllTrim(_nAgencia)),5),5,1)
	ElseIF _cBanco == "409"
		_cRet := SubStr(StrZero(Val(AllTrim(_nAgencia)),5),2,4)+"-0"
	ElseIF _cBanco == "399"
		_cRet := StrZero(Val(AllTrim(_nAgencia)),4)
	ElseIF _cBanco == "422"
		_cRet := StrZero(Val(AllTrim(_nAgencia)),5)
	ElseIF _cBanco == "033"
		_cRet := AllTrim(_nAgencia)
	ElseIF _cBanco == "237"
		_cRet := AllTrim(_nAgencia)
	Else
		_cRet := SubStr(StrZero(Val(AllTrim(_nAgencia)),5),1,4)+"-"+SubStr(StrZero(Val(AllTrim(_nAgencia)),5),5,1)
	Endif

Return(_cRet)
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Conta(_cBanco,_cConta)

	Local _cRet := ""

	If     _cBanco $ "479/389"
		_cRet := AllTrim(SEE->EE_CODEMP)
	ElseIf _cBanco $ "033"
		_cRet := substr(AllTrim(SEE->EE_CODEMP),9,7)

	ElseIf _cBanco $ "237"
		//_cRet := StrZero(Val(SubStr(AllTrim(_cConta),1,Len(AllTrim(_cConta))-1)),Len(AllTrim(_cConta))-1)
		_cRet := AllTrim(_cConta)

	ElseIf _cBanco $ "341"
		_cRet := Limpa(_cConta)
	ElseIf _cBanco $ "399"
		_cRet := SubStr(AllTrim(_cConta),1,Len(AllTrim(_cConta))-1)
	ElseIf _cBanco $ "422"
		_cRet := Strzero(val(_cConta),9)
	Else
		_cConta:=Limpa(_cConta)
		_cRet := SubStr(AllTrim(_cConta),1,Len(AllTrim(_cConta))-1)
	Endif

Return(_cRet)
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function NumParcela(_cParcela)

	Local _cRet := ""

	If ASC(_cParcela) >= 65 .or. ASC(_cParcela) <= 90
		_cRet := StrZero(Val(Chr(ASC(_cParcela)-16)),2)
	Else
		_cRet := StrZero(Val(_cParcela),2)
	Endif

Return(_cRet)
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Limpa(_Conta)
	Local i:=0
	local lRet:=''

	for i:=1 to len(_Conta)
		if substr(_Conta,i,1) $ '0123456789'
			lRet += substr(_Conta,i,1)
		endif
	next

return lRet

//Gera N�mero Sequencia para CNAB - ITAU(341) E SANTANDER(033) IMPRIME BOLETOS NA EMPRESA.
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function GeraUSeq(nTam)
	Local cFaixaA   := SEE->EE_FAXATU   //faixa atual
	Local aArea     := GetArea()
	Local cNNumSDig := ''
	Local cNumero   := ''
	Local nT        := if(SEE->EE_CODIGO $ '001/237/084',11,10)


	If Empty(SE1->E1_NUMBCO)
		cNNumSDig := strzero(val(cFaixaA) + 1,nT)

		reclock('SEE',.f.)
		replace EE_FAXATU with cNNumSDig
		msunlock()

		reclock('SE1',.f.)
		replace E1_NUMBCO with cNNumSDig
		//replace E1_X_NOSSO with cNNumSDig
		msunlock()
	Else
		cNNumSDig := alltrim(SE1->E1_NUMBCO)
	Endif

	If SEE->EE_CODIGO $ '341/356' //Itau / Real
		cNumero := strzero(val(cNNumSDig),nTam)
	Else
		If SEE->EE_CODIGO == '237' .OR. SEE->EE_CODIGO == '084' //Bradesco
			cDigito := modulo11(alltrim(SEE->EE_CODCOBE)+cNNumSDig,SEE->EE_CODIGO)
		Else
			cDigito := modulo11(cNNumSDig,SEE->EE_CODIGO)
		Endif

		cNumero := strzero(val(cNNumSDig),nTam - 1) + cDigito
	Endif

	RestArea(aArea)

Return(cNumero)
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function fSicoob(cNum, cPar)
	Local cCoop := '3214'
	Local cConv := '0003288927'
	Local cNumP := cNum
	Local cNum  := substr(cNum, 3, 7)
	Local cPar  := IF(EMPTY(cPar),'01',IF(ALLTRIM(cPar)=='A','10',IF(ALLTRIM(cPar)=='B','11',IF(ALLTRIM(cPar)=='C','12',STRZERO(VAL(cPar),2)))))

	cData := cCoop + cConv + cNum

	L := Len(cdata)
	C := '3791'
	D := 0
	P := 10

	xP:= 1

	While L > 0
		x1 := val(substr(C,xP,1))
		xP++
		if xP > 4
			xP := 1
		endif

		D := D + (Val(SubStr(cData, L, 1)) * x1)

		L := L - 1
	End

	D := mod(D,11)

	D := 11 - D

	if D == 10 .or. D == 11
		D := "0"
	Else
		D := AllTrim(Str(D))
	End

	cCod := cNumP + D + cPar + '01' + '3'

Return cCod

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  boletos � Autor � Datamanager           � Data �          ���
��+----------+------------------------------------------------------------���
���Descri��o � Rotinas Genericas                                          ���
��+----------+------------------------------------------------------------���
���Uso       � Especifico para Clientes Microsiga                         ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function BolSaf

	Local aRet 		:=	{}
	Local aPergs	:=	{}
	Local cSer		:=	space(3)
	Local cNota		:=	space(9)

	aAdd( aPergs ,{1,"Serie : ",cSer,"@!",'.T.',"",'.T.',40,.F.})
	aAdd( aPergs ,{1,"Nota De : ",cNota,"@!",'.T.',"",'.T.',50,.F.})
	aAdd( aPergs ,{1,"Nota Ate : ",cNota,"@!",'.T.',"",'.T.',50,.F.})

	If ParamBox(aPergs ,"Informe o local do arquivo",@aRet)
		cRet1 := aRet[1]
		cRet2 := aRet[2]
		cRet3 := aRet[2]
		U_ImprimeBOL(cRet2,cRet3,cRet1)
	EndIf


Return
