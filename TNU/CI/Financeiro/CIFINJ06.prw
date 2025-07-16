#Include "PROTHEUS.CH"
#Include 'FILEIO.CH'
#Include 'TOPCONN.CH'
#INCLUDE "TOTVS.CH"
#include "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} CIFINP01
Rotina para leitura da Tabela ZPZ e baixa dos títulos a Pagar
@type function
@version  12.1.2210
@author Reinaldo Lima
@since 10/06/2025
/*/

/*
+-------------------------------------------------------------------+
|                Historico de Alteraçoes                            |
|                                                                   |
|          															|
|                                                                   |
+-------------------------------------------------------------------+
*/
User Function CIFINJ06( )


Local cCodEmp   := "01"
Local cCodFil   := "01"
//Local cQ    	:= ""
Local cAlitmp   := ""
//Local cTab      := ""
Local n1        := 0
Local n2        := 0
Local cMsg      := ""
Local _nVlrTit  := 0
Local _nValPgto := 0
Local _nValDesc := 0
Local _nValMulta := 0
Local aTit       := { }
Local _aMsg 	 := {}
Local _aMsgSuce  := {}
Local aLogAuto := {}
Local CidCnab := ''
Local cBordrei := ''
Local dDataBase := Date()
Local dDataBx := dDataBase
Local dDataCr := dDataBase
Local cQuery    := ""
Local nErro     := 0
//Local cQuery2   := ""
Local nTamBco   as Numeric
Local nTamAge   as Numeric
Local nTamCta   as Numeric

Private aDados := { }
Private lMsErroAuto    := .F.
Private lAutoErrNoFile := .T.
Private lMsHelpAuto    := .F.
Private cPath    := ''
Private MVPAR01  := ""
Private MVPAR02  := ""
Private MVPAR03  := ""



//Default aParam := {"01","000101","000101"} // VOLTAR DEPOIS

RpcClearEnv()
RpcSetType(3)
RpcSetEnv(cCodEmp, cCodFil)

nTamBco   := Tamsx3("A6_COD")[1]
nTamAge   := TamSx3("A6_AGENCIA")[1]
nTamCta   := Tamsx3("A6_NUMCON")[1]

aDados := { }

cQuery := "SELECT * " + CRLF
cQuery += "FROM " + RetSQLName("ZPZ")  + " T0" + CRLF
cQuery += "WHERE T0.ZPZ_STATUS = ''"   + CRLF
cQuery += "	AND  T0.ZPZ_BAIXA <> ''"   + CRLF
//cQuery += " AND  T0.ZPZ_BANCO <> ''"   + CRLF
cQuery += " AND  T0.ZPZ_VALOR <> ''"   + CRLF
cQuery += " AND  T0.ZPZ_OCORRE = '00'"   + CRLF
cQuery += "	AND  T0.D_E_L_E_T_ = ''"   + CRLF
cQuery += "ORDER BY T0.ZPZ_FILIAL, T0.ZPZ_IDCNAB" + CRLF

cAliTmp := MPSysOpenQuery(cQuery)
DbSelectArea((cAliTmp))
(cAliTmp)->(DbGoTop())

While (cAliTmp)->( !Eof() )

	If !Empty( (cAliTmp)->ZPZ_FILIAL + (cAliTmp)->ZPZ_NUM )
	
		DbSelectArea("SA2")
		SA2->( DbSetOrder( 1 ) )

		SA2->( DbSeek( xFilial("SA2") + (cAliTmp)->ZPZ_FORNEC + (cAliTmp)->ZPZ_LOJA ) )
		Aadd( aDados , {;
					cEmpAnt,;
					(cAliTmp)->ZPZ_FILIAL,;
					(cAliTmp)->ZPZ_PREFIX,;
					(cAliTmp)->ZPZ_NUM,;
					(cAliTmp)->ZPZ_PARCEL,;
					(cAliTmp)->ZPZ_TIPO,;
					(cAliTmp)->ZPZ_FORNEC,;
					(cAliTmp)->ZPZ_LOJA,;
					SA2->A2_CGC,;
					'N',;
					(cAliTmp)->ZPZ_BANCO,;
					(cAliTmp)->ZPZ_AGENCI,;
					(cAliTmp)->ZPZ_CONTA,;
					(cAliTmp)->ZPZ_BAIXA,;
					(cAliTmp)->ZPZ_EMISSA,;
					'HISTOR',;
					(cAliTmp)->ZPZ_VALOR,;
					(cAliTmp)->ZPZ_NUMBOR,;
					(cAliTmp)->ZPZ_IDCNAB,;
					(cAliTmp)->R_E_C_N_O_,;
					(cAliTmp)->ZPZ_DESCCN,;
					(cAliTmp)->ZPZ_JURCN,;
					(cAliTmp)->ZPZ_ARQUIV;
					})
	ENDIF
	(cAliTmp)->( DbSkip() )
EndDo

(cAliTmp)->(dbCloseArea())

If ( Len( aDados ) > 0 )
	For n1 := 1 To Len( aDados )
		If ( n1 > 1 )

			SA2->( DbGoTop( ) )
			SA2->( DbSetOrder( 1 ) )

			cFornece := PadL(aDados[n1,7] ,TamSx3("E2_FORNECE")[1],"0")
			cLojFor  := PadL(aDados[n1,8] ,TamSx3("E2_LOJA")[1],"0")

			DbSelectArea( 'SE2' )
			DbSetOrder(11)
					
			If SE2->(MsSeek(PadL(aDados[n1,2] ,TamSx3("E2_FILIAL")[1],"0")+;
							PadL(aDados[n1,19] ,TamSx3("E2_IDCNAB")[1],"0")))					
					   	    						
				IF SE2->E2_SALDO <> 0

					cFilTIT    := PadL(aDados[n1,2] ,TamSx3("E2_FILIAL")[1],"0")
					_nValPgto  := ROUND(aDados[n1,17] ,2)

					//_nVlrTit   := ROUND(SE2->E2_SALDO,2)
					
					//_nValDesc  := ROUND(aDados[n1,21] ,2)
					//_nValMulta := ROUND(aDados[n1,22] ,2)
	
					IF aDados[n1,18] <> ''

						cBordrei := AllTrim(aDados[n1,18])
						CidCnab  := PadL(aDados[n1,19] ,TamSx3("E2_IDCNAB")[1],"0")
								
								//ZeraBordero(Cfilrei,Cprefrei,cNumrei,cparcrei,ctiporei,cFornece,cLojFor,cBordrei,nErro)
								ZeraBordero(cBordrei,CidCnab,nErro)
								
						If nErro != 0
							cMsg := 'Erro para zerar Bordero: ' + Cfilrei + 'Documento: ' + cNumrei + Chr( 13 ) + Chr( 10 )
							Aadd(_aMsg,{Alltrim(Str(n1)),"SE2",Cfilrei, cMsg})
							Loop
						EndIf
					ENDIF

					DbSelectArea('SA6')
					SA6->(DbSetOrder(1))
					SA6->(DbGoTop())

					If SE2->E2_FILIAL <> cFilAnt
						//Cadastro de banco exclusivo, necessário posicionar na empresa correta para o dbseek
						//TNU - 10/07/25
						SM0->(DbSeek(cEmpAnt+SE2->E2_FILIAL))
						cFilAnt := SE2->E2_FILIAL
					EndIf 

					If SA6->( DbSeek( IIf( Empty( xFilial( 'SA6' ) ), xFilial( 'SA6' ), SE2->E2_FILIAL )+;
							    	PADR(Alltrim(cValtoChar(aDados[n1, 11])),TamSx3("A6_COD")[1])+;
									PADR(Alltrim(cValtoChar(aDados[n1, 12])),TamSx3("A6_AGENCIA")[1])+;
									PADR(Alltrim(aDados[n1,13]),TamSx3("A6_NUMCON")[1]) ) )

								MVPAR01 := PADR(Alltrim(cValtoChar(aDados[n1, 11])),TamSx3("A6_COD")[1])
								MVPAR02 := PADR(Alltrim(cValtoChar(aDados[n1, 12])),TamSx3("A6_AGENCIA")[1])
								MVPAR03 := PADR(Alltrim(aDados[n1,13]),TamSx3("A6_NUMCON")[1])

					Else
							    cMsg := 'Banco - [Filial: '+ SE2->E2_FILIAL 
								cMsg += ' Cod: ' + aDados[n1,11] + ' Agencia: '+ aDados[n1,12] + ' Conta: ' + aDados[n1,13] + '] - Nao cadastrado!' + Chr( 13 ) + Chr( 10 )
								Aadd(_aMsg,{Alltrim(Str(n1)),"SA6",SA6->A6_FILIAL,cMsg})
								Loop
					Endif

					cMsg := 'Banco - [Filial: '+ SE2->E2_FILIAL 
					cMsg += ' Cod: ' + MVPAR01 + ' Agencia: '+ MVPAR02 + ' Conta: ' + MVPAR03 + '] - Parametros!' + Chr( 13 ) + Chr( 10 )
					Aadd(_aMsg,{Alltrim(Str(n1)),"SA6",SA6->A6_FILIAL,cMsg})

					//dDataBx := IIF(!Empty(aDados[n1,14]),CtoD( StrTran( SubStr( aDados[n1, 14], 1, 10 ), '-', '' ) ),dDataBase) aqui
					//dDataCr := IIF(!Empty(aDados[n1,15]),CtoD( StrTran( SubStr( aDados[n1, 15], 1, 10 ), '-', '' ) ),dDataBase) aqui
					dDataBx := IIF(!Empty(aDados[n1,14]),stoD(aDados[n1, 14] ),dDataBase) 
					dDataCr := IIF(!Empty(aDados[n1,15]),stoD(aDados[n1, 15] ),dDataBase) 

					aTit := {}
					aAdd( aTit, { 'E2_FILIAL',    SE2->E2_FILIAL,	Nil } )
					aAdd( aTit, { 'E2_PREFIXO',   SE2->E2_PREFIXO,	Nil } )
					aAdd( aTit, { 'E2_NUM',       SE2->E2_NUM,	Nil } )
					aAdd( aTit, { 'E2_PARCELA',   SE2->E2_PARCELA,	Nil } )
					aAdd( aTit, { 'E2_TIPO',      SE2->E2_TIPO,	Nil } )
					aAdd( aTit, { 'E2_FORNECE',   SE2->E2_FORNECE,	Nil } )
					aAdd( aTit, { 'E2_LOJA',      SE2->E2_LOJA,	Nil } )
					aAdd( aTit, { 'AUTMOTBX',     'NOR',	Nil } )
					aAdd( aTit, { 'AUTBANCO',     MVPAR01,	Nil } )
					aAdd( aTit, { 'AUTAGENCIA',   MVPAR02,	Nil } )
					aAdd( aTit, { 'AUTCONTA',     MVPAR03,	Nil } )
					aAdd( aTit, { 'AUTDTBAIXA',   dDataBx, Nil } )
					aAdd( aTit, { 'AUTDTCREDITO', dDataCr, Nil } )
					aAdd( aTit, { 'AUTVLRPG',     _nValPgto, Nil } )

					dDtBkp := dDataBase
					dDataBase := dDataBx

					//aAdd( aTit, { 'AUTDESCONT',   _nValDesc  , Nil } )
					//aAdd( aTit, { 'AUTMULTA',     _nValMulta   , Nil } )

					MSExecAuto( { | x, y, a, b, c, d | FINA080( x, y, a, b, c, d ) }, aTit, 3,,, .F., .F. )

					dDataBase := dDtBkp

					If lMsErroAuto
						//MostraErro( )
						aLogAuto := GetAutoGRLog()
						For n2 := 1 To Len(aLogAuto)
							cMsg += Alltrim(aLogAuto[n2])+CRLF
						Next nAux
						Aadd(_aMsg,{Alltrim(Str(n1)),"",SE2->E2_FILIAL,cMsg})
						cMsg := ""
						lMsHelpAuto := .T.
						lMsErroAuto := .F.

						DbSelectArea("ZPZ")
						ZPZ->( DbGoTo( aDados[ n1, 20] ) )
						ZPZ->( RecLock("ZPZ" , .F. ) )
						ZPZ->ZPZ_STATUS := "E"
						ZPZ->ZPZ_HIST   := "[CIFINJ06] - ERRO BAIXA AUTOMATICA"
						//ZPZ->ZPZ_BAIXA	:= CtoD("")
						ZPZ->( MsUnLock() )
					Else

						cMsg := 'Título - [Filial: ' +PadL(aDados[n1,2],TamSx3("E2_FILIAL")[1],"0") + ' - Prefixo: '+Padr(aDados[n1,3],TamSx3('E2_PREFIXO')[1])
						cMsg += ' - Num: ' + Padl(AllTrim( aDados[n1,4] ),9,"0") + ' - Parcela: ' + PadL(aDados[n1,5],TamSx3("E2_PARCELA")[1],"")
						cMsg += ' - Tipo: ' + PadR(aDados[n1,6] ,TamSx3("E2_TIPO")[1],"") + ' - Fornecedor: ' + cFornece + ' BORDERO: '+AllTrim(aDados[n1,18])+ ' IDCNAB: '+PadL(aDados[n1,19] ,TamSx3("E2_IDCNAB")[1],"0") + '] Baixado com sucesso!'
						cMsg += ' - Arq: '+ aDados[n1,22] + Chr( 13 ) + Chr( 10 ) 
			    		Aadd(_aMsgSuce,{Alltrim(Str(n1)),"SE2",PadL(aDados[n1,2],TamSx3("E2_FILIAL")[1],"0"), cMsg})

						lMsHelpAuto := .T.
						lMsErroAuto := .F.
						cMsg := ""

						DbSelectArea("ZPZ")
						ZPZ->( DbGoTo( aDados[ n1, 20] ) )
						ZPZ->( RecLock("ZPZ" , .F. ) )
						ZPZ->ZPZ_STATUS := "B"
						ZPZ->ZPZ_BAIXA	:= SE2->E2_BAIXA
						ZPZ->ZPZ_HIST   := "[CIFINJ06] - BAIXADO COM SUCESSO"
						ZPZ->( MsUnLock() )
					EndIf

					aTit := { }
					_nValMulta := 0
					_nValDesc := 0
					_nValPgto := 0
				Else
					DbSelectArea("ZPZ")
					ZPZ->( DbGoTo( aDados[ n1, 20] ) )
					ZPZ->( RecLock("ZPZ" , .F. ) )
					ZPZ->ZPZ_STATUS := "B"
					ZPZ->ZPZ_BAIXA	:= SE2->E2_BAIXA
					ZPZ->ZPZ_HIST   := "[CIFINJ06] - TITULO JA ESTAVA BAIXADO"
					ZPZ->( MsUnLock() )
					
					cMsg := 'Título - [Filial: ' +PadL(aDados[n1,2],TamSx3("E2_FILIAL")[1],"0") + ' - Prefixo: '+Padr(aDados[n1,3],TamSx3('E2_PREFIXO')[1])
					cMsg += ' - Num: ' + Padl(AllTrim( aDados[n1,4] ),9,"0") + ' - Parcela: ' + PadL(aDados[n1,5],TamSx3("E2_PARCELA")[1],"")
					cMsg += ' - Tipo: ' + PadR(aDados[n1,6] ,TamSx3("E2_TIPO")[1],"") + ' - Fornecedor: ' + cFornece + ' BORDERO: '+AllTrim(aDados[n1,18])+ ' IDCNAB: '+PadL(aDados[n1,19] ,TamSx3("E2_IDCNAB")[1],"0") + '] Titulo Ja está baixado - Saldo zerado!'+ Chr( 13 ) + Chr( 10 )
			    //	cMsg += ' - Arq: '+ aDados[n1,22] + Chr( 13 ) + Chr( 10 )
					Aadd(_aMsg,{Alltrim(Str(n1)),"SE2",PadL(aDados[n1,2],TamSx3("E2_FILIAL")[1],"0"), cMsg})
					
					cMsg := ""
				Endif
			Else
				cMsg := 'Título - [Filial: ' +PadL(aDados[n1,2],TamSx3("E2_FILIAL")[1],"0") + ' - Prefixo: '+Padr(aDados[n1,3],TamSx3('E2_PREFIXO')[1])
				cMsg += ' - Num: ' + Padl(AllTrim( aDados[n1,4] ),9,"0") + ' - Parcela: ' + PadL(aDados[n1,5],TamSx3("E2_PARCELA")[1],"")
				cMsg += ' - Tipo: ' + PadR(aDados[n1,6] ,TamSx3("E2_TIPO")[1],"") + ' - Fornecedor: ' + cFornece + ' BORDERO: '+AllTrim(aDados[n1,18])+ ' IDCNAB: '+PadL(aDados[n1,19] ,TamSx3("E2_IDCNAB")[1],"0") + '] Nao Encontrado!'+ Chr( 13 ) + Chr( 10 )
			    //cMsg += ' - Arq: '+ aDados[n1,22] + Chr( 13 ) + Chr( 10 )
				Aadd(_aMsg,{Alltrim(Str(n1)),"SE2",PadL(aDados[n1,2],TamSx3("E2_FILIAL")[1],"0"), cMsg})
				cMsg := ""						
			EndIf
		EndIf
	Next
EndIf


If Len(_aMsg) > 0
	FGERALOG(_aMsg,cPath,"ERROS")
EndIf

If Len(_aMsgSuce) > 0
	FGERALOG(_aMsgSuce,cPath,"BAIXADOS")
EndIf

Return


/*/{Protheus.doc} FGERALOG
Log de Erros arquivo csv
@type function
@version  12.1.2210
@author Odair Junior
@since 06/09/2023
/*/
Static Function FGERALOG(_aMsg,cArquivo,cTitulo)
	Local cFileNom :='Log_'+cTitulo+"_"+dToS(Date())+StrTran(Time(),":")+".txt"
	Local cQuebra  := CRLF + "+=======================================================================+" + CRLF
	Local cTexto   := ""
	Local nX := 0
	Local cDirArq := "/nexxera/download/BAIXA_PAGAR_LOG/"
	Local nHdl := 0

	If !Empty(cFileNom)

		If !ExistDir(cDirArq)
			MakeDir(cDirArq)
		EndIf

		nHdl := FCreate(cDirArq+cFileNom, FC_NORMAL)

		if nHdl = -1
			alert("Erro ao criar arquivo de log " + Str(Ferror()))
		Else

			FWrite(nHdl,cQuebra)

			If  cTitulo == "PROCESSAMENTO - SUCESSO"
				cTexto := "LOG DE TITULOS BAIXADOS - "+cTitulo+CRLF
			Else
				cTexto := "LOG DE ERROS - "+cTitulo+CRLF
			EndIf

			cTexto += " Data - "+ dToC(dDataBase)
			cTexto += " Hora - "+ Time()+cQuebra

			For nX := 1 To Len(_aMsg)
                cTexto += " Linha: "+ _aMsg[nX] [1] + " Status: "+_aMsg[nX] [4]
                FWrite(nHdl,cTexto)
				cTexto := ""
			Next nX
			FClose(nHdl)
		EndIf
	EndIf

Return

Static Function ZeraBordero(cBordzera,CidCnab,nErro)
	
	aArea       := GetArea()
    cNovoStatus := ""
	cQryUpd    	:= ""
	cQryDel    	:= ""

	cQryUpd := " UPDATE " + RetSqlName("SE2") + " "
    cQryUpd += "     SET E2_NUMBOR =  '" + cNovoStatus + "' "
    cQryUpd += " WHERE  E2_NUMBOR  = '"  + cBordzera  + "' "
    cQryUpd += "   AND  E2_IDCNAB  = '"  + CidCnab    + "' "
	    
	//Tenta executar o update
    nErro := TcSqlExec(cQryUpd)
	
	RestArea(aArea)

Return

