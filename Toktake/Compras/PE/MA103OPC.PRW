/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MA103OPC ³ Autor ³ Artur Nucci Ferrari   ³ Data ³ 06/07/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de entrada para incluir rotinas no MATA103           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TOK TAKE                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 

#INCLUDE "RWMAKE.CH"

User Function MA103OPC()
Local _aRet:= {}

If cEmpAnt == "01"
	aAdd(_aRet,{'NF Complementar','U_NFE_Compl',0,1,0,.F.})
EndIF

Return _aRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ NFE_Compl ³ Autor ³ Artur Nucci Ferrari  ³ Data ³ 06/07/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para geracao da NF complementar                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TOK TAKE                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NFE_Compl()
Local aArea	    := GetArea()
Local _EOL	    := CHR(13)
Local a_Cabec	:= {}
Local a_Itens	:= {}
Local _cFilial  := SF1->F1_FILIAL
Local _cDoc     := SF1->F1_DOC
Local _cSerie   := SF1->F1_SERIE
Local _cFornece := SF1->F1_FORNECE
Local _cLoja    := SF1->F1_LOJA
Local _cTipo    := SF1->F1_TIPO
Local _dDtDigit := SF1->F1_DTDIGIT
Local _dEmissao := SF1->F1_EMISSAO
Local _cUF      := SF1->F1_EST
Local _cEspecie := SF1->F1_ESPECIE
Local _nValMerc := SF1->F1_VALMERC
Local _cRazao   := GetAdvFval("SA2","A2_NOME",xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,1)
Local _cNomExib := _cFornece+"/"+_cLoja+"-"+AllTrim(_cRazao)
Local _nValComp := CriaVar("F1_VALBRUT" ,.F.)
If Upper(AllTrim(GetEnvServer())) == "JWXC9C"
	MsgInfo("Função em desenvolvimento, a NF Complementar não gerada.","ATENÇÃO!!!")
	RestArea(aArea)
	Return()
End
If _nValMerc=0
	MsgInfo("Valor das Mercadorias zerado, a NF Complementar não gerada.","ATENÇÃO!!!")
	RestArea(aArea)
	Return()
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transportadora                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

While .T.
	@ 127,112 To 450,730 DIALOG _oObjeto1 TITLE "NF - Complementar"
	
	@ 010,005 Say "NF : "
	@ 010,100 GET _cDoc Picture '@!' When .F. Size 70,12
	
	@ 030,005 Say "Serie : "
	@ 030,100 GET _cSerie Picture '@!' When .F. Size 70,12
	
	@ 050,005 Say "Data Emissao : "
	@ 050,100 GET _dEmissao  When .F. Size 70,12
	
	@ 070,005 Say "Data Entrada : "
	@ 070,100 GET _dDtDigit  When .F. Size 70,12
	
	@ 090,005 Say "Fornecedor : "
	@ 090,100 GET _cRazao Picture '@!' When .F. Size 200,12
	
	@ 110,005 Say "Valor Complementar: "
	@ 110,100 GET _nValComp Picture '@E 999,999,999.99'  Size 70,12
	
	@ 040,260 BMPBUTTON TYPE 1 ACTION Close(_oObjeto1)   // Botao de confirmacao
	ACTIVATE DIALOG _oObjeto1 CENTERED
	Exit                                       
End
If _nValComp=0
	MsgInfo("Valor complementar zerado, a NF Complementar não gerada.","ATENÇÃO!!!")
	RestArea(aArea)
	Return()
End
cQuery := "SELECT  " + _EOL
cQuery += "F1_VALMERC " + _EOL
cQuery += ",F1_FILIAL " + _EOL
cQuery += ",F1_DOC " + _EOL
cQuery += ",F1_SERIE " + _EOL
cQuery += ",F1_FORNECE " + _EOL
cQuery += ",F1_LOJA " + _EOL
cQuery += ",F1_EMISSAO " + _EOL
cQuery += ",F1_EST " + _EOL
cQuery += ",F1_TIPO " + _EOL
cQuery += ",F1_DTDIGIT " + _EOL
cQuery += ",F1_ESPECIE " + _EOL
cQuery += ",F1_RECBMTO " + _EOL
cQuery += ",D1_ITEM " + _EOL
cQuery += ",D1_COD " + _EOL
cQuery += ",D1_UM " + _EOL
cQuery += ",D1_VUNIT " + _EOL
cQuery += ",D1_TOTAL " + _EOL
cQuery += ",D1_LOCAL " + _EOL
cQuery += ",D1_TES " + _EOL
cQuery += ",D1_SEGUM " + _EOL
cQuery += ",D1_CONTA " + _EOL
cQuery += ",D1_FORNECE " + _EOL
cQuery += ",D1_LOJA " + _EOL
cQuery += ",D1_DOC " + _EOL
cQuery += ",D1_EMISSAO " + _EOL
cQuery += ",D1_DTDIGIT " + _EOL
cQuery += ",D1_SERIE " + _EOL
cQuery += ",D1_GRUPO " + _EOL
cQuery += ",D1_TIPO " + _EOL
cQuery += ",D1_TP  " + _EOL
cQuery += ",((((D1_TOTAL*100)/F1_VALMERC))/100) AS  'PERCENTUAL' " + _EOL
cQuery += "FROM " + RetSqlName("SF1") + _EOL
cQuery += "INNER JOIN " + RetSqlName("SD1") + _EOL
cQuery += "ON D1_FILIAL=F1_FILIAL " + _EOL
cQuery += "AND D1_DOC=F1_DOC " + _EOL
cQuery += "AND D1_SERIE=F1_SERIE " + _EOL
cQuery += "AND D1_FORNECE=F1_FORNECE " + _EOL
cQuery += "AND D1_LOJA=F1_LOJA " + _EOL
cQuery += "AND D1_DTDIGIT=F1_DTDIGIT " + _EOL
cQuery += "AND D1_TIPO=F1_TIPO " + _EOL
cQuery += "AND " + RetSqlName("SD1") + ".D_E_L_E_T_='' " + _EOL
cQuery += "WHERE " + RetSqlName("SF1") + ".D_E_L_E_T_='' " + _EOL
cQuery += "AND F1_FILIAL='" + _cFilial + "' " + _EOL
cQuery += "AND F1_DOC='" +_cDoc+ "' " + _EOL
cQuery += "AND F1_SERIE='" +_cSerie+ "' " + _EOL
cQuery += "AND F1_DTDIGIT='" +DTOS(_dDtDigit)+ "' " + _EOL
cQuery += "AND F1_FORNECE='" +_cFornece+ "' " + _EOL
cQuery += "AND F1_LOJA='" +_cLoja+ "' " + _EOL
MemoWrite('NFE_Compl.SQL',cQuery)
If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")
dbGotop()
While !Eof()
	RecLock("SD1",.T.)
	SD1->D1_FILIAL  := TRB->F1_FILIAL
	SD1->D1_ITEM    := TRB->D1_ITEM
	SD1->D1_COD     := TRB->D1_COD
	SD1->D1_UM      := TRB->D1_UM
	SD1->D1_VUNIT   := 0
	SD1->D1_TOTAL   := (TRB->D1_TOTAL*TRB->PERCENTUAL)
	SD1->D1_LOCAL   := TRB->D1_LOCAL
	SD1->D1_TES     := ''
	SD1->D1_SEGUM   := TRB->D1_SEGUM
	SD1->D1_CONTA   := TRB->D1_CONTA
	SD1->D1_FORNECE := TRB->F1_FORNECE
	SD1->D1_LOJA    := TRB->F1_LOJA
	SD1->D1_DOC     := TRB->F1_DOC                      
	SD1->D1_EMISSAO := ddatabase
	SD1->D1_DTDIGIT := ddatabase
	SD1->D1_SERIE   := "CPL"
	SD1->D1_GRUPO   := TRB->D1_GRUPO
	SD1->D1_TIPO    := "C"
	SD1->D1_TP      := TRB->D1_TP
	SD1->D1_ITEMORI := TRB->D1_ITEM
	SD1->D1_NFORI   := TRB->F1_DOC
	SD1->D1_SERIORI := TRB->F1_SERIE
	MsUnLock()
	dbSelectArea("TRB")
	dbSkip()
	Loop
End                                                      

//[15:13:44] Ricardo Souza "Gomes da Costa": MSExecAuto({|x,y,z|Mata103(x,y,z)}, aCabec, aItens, 3)

RecLock("SF1",.T.)
SF1->F1_FILIAL  := _cFilial
SF1->F1_DOC     := _cDoc
SF1->F1_SERIE   := "CPL"
SF1->F1_FORNECE := _cFornece
SF1->F1_LOJA    := _cLoja
SF1->F1_EMISSAO := ddatabase
SF1->F1_EST     := _cUF
SF1->F1_TIPO    := "C"
SF1->F1_DTDIGIT := ddatabase
SF1->F1_ESPECIE := _cEspecie
SF1->F1_RECBMTO := ddatabase
MsUnLock()  
MsgInfo("Foi gerada a NF complemtar ["+_cDoc+"]","ATENÇÃO!!!")
RestArea(aArea)
Return()            

/*
	//INICIO A INCLUSAO DA NF DE ENTRADA
	Begin Transaction

	lMsErroAuto := .F.
	a_Cabec	:= {}
	a_Itens	:= {}  
	                                                                
	//Inicio - Felipe A. Reis - 19/05/2011 - Tratamento para importacao da especie
	//If AllTrim(TR700->CDTIPONC) $ "CT"
	//	c_Especie := "CTR"		
	//Else
		c_Especie := TR700->CDTIPONC 
	//EndIf
	//Fim - Felipe A. Reis - 19/05/2011
	
	//Carregar os array com os dados da CAPA da NF
	If !l_NFServ //Tratamento para Notas Fiscais de Servico
		aAdd(a_Cabec,{"F1_TIPO"   		, "C"  					})
		aAdd(a_Cabec,{"F1_FORMUL" 		, "N"					})
		aAdd(a_Cabec,{"F1_DOC"    		, c_NumCon				})
		aAdd(a_Cabec,{"F1_SERIE"  		, c_SerCon				})
		aAdd(a_Cabec,{"F1_EMISSAO"		, TR700->DTEMISNC		})
		aAdd(a_Cabec,{"F1_FORNECE"		, C_FORN_F1				})
		aAdd(a_Cabec,{"F1_LOJA"   		, C_LOJA_F1				})
		aAdd(a_Cabec,{"F1_ESPECIE"		, c_Especie				})
		aAdd(a_Cabec,{"F1_HIST"			, "CONH. TRANSPORTE"	})
		aAdd(a_Cabec,{"F1_MENS"			, "FATURA: "+AllTrim(TR700->CDFATURA)		})
		aAdd(a_Cabec,{"F1_DESPESA"		, 0						})		
		aAdd(a_Cabec,{"F1_DESPESA"		, 0						})		
		aAdd(a_Cabec,{"F1_DESPESA"		, 0						})		
		aAdd(a_Cabec,{"F1_FRETE"		, 0						})		
		aAdd(a_Cabec,{"F1_SEGURO"		, 0						})		
		aAdd(a_Cabec,{"F1_DESCONT"		, 0						})		
		//Carregar os array com os dados do ITEM da NF
		a_Linha := {}
		aAdd(a_Linha, {"D1_COD"			, c_CodFre							,Nil } )
		aAdd(a_Linha, {"D1_TOTAL"		, TR700->VRNC						,Nil } )
		aAdd(a_Linha, {"D1_TES"			, c_CodTES							,Nil } )
		aAdd(a_Linha, {"D1_LOCAL"		, "10"								,Nil } )
		aAdd(a_Linha, {"D1_NFORI"		, StrZero(Val(TR740->CDNOTA), 9)	,Nil } )
		aAdd(a_Linha, {"D1_SERIORI"		, TR740->CDSERIE					,Nil } )
		aAdd(a_Linha, {"D1_CONTA"		, c_CtaDesp							,Nil } )
		aAdd(a_Linha, {"D1_PICM"		, n_AliqICMS						,Nil } )
		aAdd(a_Linha, {"D1_VALICM"		, n_ValICMS							,Nil } )
	//	aAdd(a_Linha, {"D1_CC"			, "1320302"							,Nil } )
    Else
		C_TIPO_F1 	:= "N"
				
		aAdd(a_Cabec,{"F1_TIPO"   		, "N"  					})
		aAdd(a_Cabec,{"F1_FORMUL" 		, "N"					})
		aAdd(a_Cabec,{"F1_DOC"    		, c_NumCon				})                              '
		aAdd(a_Cabec,{"F1_SERIE"  		, c_SerCon				})
		aAdd(a_Cabec,{"F1_EMISSAO"		, TR700->DTEMISNC		})
		aAdd(a_Cabec,{"F1_FORNECE"		, C_FORN_F1				})
		aAdd(a_Cabec,{"F1_LOJA"   		, C_LOJA_F1				})
		aAdd(a_Cabec,{"F1_ESPECIE"		, c_Especie				})
		aAdd(a_Cabec,{"F1_HIST"			, ""					})
		aAdd(a_Cabec,{"F1_MENS"			, ""					})
		aAdd(a_Cabec,{"F1_DESPESA"		, 0						})		
		aAdd(a_Cabec,{"F1_DESPESA"		, 0						})		
		aAdd(a_Cabec,{"F1_DESPESA"		, 0						})		
		aAdd(a_Cabec,{"F1_FRETE"		, 0						})		
		aAdd(a_Cabec,{"F1_SEGURO"		, 0						})		
		aAdd(a_Cabec,{"F1_DESCONT"		, 0						})		
		//aAdd(a_Cabec,{"F1_COND"			, c_CondPag				})			
			
		//Carregar os array com os dados do ITEM da NF
		a_Linha 	:= {}
		c_CodFre 	:= Getmv("MV_XCODSRV") //Produto utilizado para nota fiscal de servico de frete 
		c_CtaDesp 	:= Getmv("MV_XCTACTB") //Conta Contabil para contabilizar o item de servico
		
		aAdd(a_Linha, {"D1_COD"			, c_CodFre							,Nil } )
		aAdd(a_Linha, {"D1_TOTAL"		, TR700->VRNC						,Nil } )
		aAdd(a_Linha, {"D1_TES"			, c_CodTES							,Nil } )
		aAdd(a_Linha, {"D1_LOCAL"		, "MO"								,Nil } )
		aAdd(a_Linha, {"D1_CONTA"		, c_CtaDesp							,Nil } )
		aAdd(a_Linha, {"D1_PICM"		, n_AliqICMS						,Nil } )
		aAdd(a_Linha, {"D1_VALICM"		, n_ValICMS							,Nil } )
		aAdd(a_Linha, {"D1_QUANT"		, 1									,Nil } )
		aAdd(a_Linha, {"D1_VUNIT"		, TR700->VRNC						,Nil } )
				
    EndIf
    
	aAdd(a_Itens, a_Linha)
	
	//Chamar a rotina automatica para inclusao da NFE 
	MSExecAuto({|x,y,z| MATA103(x,y,z)}, a_Cabec, a_Itens, 3)
	
	If lMsErroAuto
		aAdd(a_RelAna, {c_Arquivo, c_FilCon, c_NumCon, c_SerCon, "Ocorreu um erro dentro da rotina automática. Será necessário analisar o log."})
		MostraErro()
	Else
		//Atualizo o flag para que essa NF não seja contabilizada
		SF1->(RecLock("SF1", .F.))
		SF1->F1_DTLANC	:= MsDate()
		SF1->(MsUnLock())

		//Atualizo a mensagem no Livro Fiscal
		DbSelectArea("SF3")
		DbSetOrder(1) //F3_FILIAL, F3_ENTRADA, F3_NFISCAL, F3_SERIE, F3_CLIEFOR, F3_LOJA, F3_CFO, F3_ALIQICM, R_E_C_N_O_, D_E_L_E_T_
		DbGoTop()
		
		DbSeek(SF1->(F1_FILIAL+DTOS(F1_DTDIGIT)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA), .F.)
		
		While SF3->(!Eof()) .And. SF1->(F1_FILIAL+DTOS(F1_DTDIGIT)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == ;
								SF3->(F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)
		
			If Left(SF3->F3_OBSERV, 11) == "COMPL.N.F.:" //COMPL.N.F.: 000087186/4
				SF3->(RecLock("SF3", .F.))
				SF3->F3_OBSERV := Replace(SF3->F3_OBSERV, "COMPL.N.F.: ", "FRETE REF NF")
				SF3->(MsUnLock())
			Endif
		
			SF3->(DbSkip())
		Enddo              
		
		//Log das NFs pertencentes ao conhecimento posicionado
		DbSelectArea("TR740")
		DbSetOrder(1)
		DbGoTop()
		DbSeek(TR700->IDNC, .F.)
		
		c_NfsConh := ""
		
		While TR740->(!EOF()) .and. TR740->IDNC == TR700->IDNC
			
			If !Empty(c_NfsConh)
				c_NfsConh += ", "
			Endif

			c_NfsConh += AllTrim(TR740->CDNOTA)+"/"+Alltrim(TR740->CDSERIE)
			
			RecLock("SZJ", .T.)
			SZJ->ZJ_FILIAL	:= c_FilCon				//Filial
			SZJ->ZJ_CNPJTRA	:= TR700->CNPJTRANS		//CNPJ da Transportadora
			SZJ->ZJ_CONHECI	:= TR700->CDNC			//No. Conhecimento
			SZJ->ZJ_SERIE	:= TR700->CDSERIENC		//Serie Conhecimento
			SZJ->ZJ_EMISSAO	:= TR700->DTEMISNC		//Emissao Conhecimento
			SZJ->ZJ_ENTRADA	:= dDataBase			//Entrada no Siga do Conhecimento
			SZJ->ZJ_NFISCAL	:= TR740->CDNOTA		//Nota Fiscal
			SZJ->ZJ_SERIENF	:= TR740->CDSERIE		//Serie da Nota Fiscal
			MsUnLock()
			
			TR740->(DbSkip())
		Enddo

		aAdd(a_RelAna, {c_Arquivo, c_FilCon, c_NumCon, c_SerCon, "Conhecimento importado com sucesso! NFs: "+c_NfsConh})

	EndIf

	End Transaction
	*/
