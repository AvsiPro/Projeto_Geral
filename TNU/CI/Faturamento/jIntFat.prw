#include 'protheus.ch'
#include 'rwmake.ch'
#include 'totvs.ch'
#include 'parmtype.ch'
#include 'restful.ch'
#include 'topconn.ch'
#include "tbiconn.ch"

/*/{Protheus.doc} jIntNF
Job jIntNF
@type function
@author DWC
@since 11/04/2022
/*/

User Function jIntFat(aParam)
	Local lRet      := .T.
	Local cCodEmp   := "01"
	Local cCodFil   := "01"
	Local cQuery    := ""
	Local cTab      := ""
	Local nRecno    := 0
	Local lContinua := .T.
	Local cNota     := ""
	Local cSerie    := ""
	Local aPvlNfs   := {}
	Local aBloqueio := {}
	Local nRegs 	:= 0
	Local lOperadora:= .F.
	
	//Local cFilNao := ""
	Local cCliOpera := ""
	Local cLojaOpera:= ""
	Local cSeq		:= "00"
	
	
	Private cSerieRPS := ""
	Private cSerieNO  := ""
	Private lMsErroAuto := .F.

	Default aParam := {"01","000101",'000101'}


 	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(cCodEmp, cCodFil)

	Conout("[JINTNF] - Iniciando ambiente " + cCodEmp + "/ " + cCodFil + "")

	nRegs := GetMv("MV_XRGPRFT",,3) // quantidade de registros a serem processados em cada execucao, no processo de faturamento

	
	Conout("[JINTNF] - Iniciando Modo Exclusivo " + cCodEmp + "")

	cQuery := "SELECT TOP "+Alltrim(Str(nRegs))+" T0.R_E_C_N_O_" + CRLF
	cQuery += "FROM " + RetSQLName("ZPC") + " T0" + CRLF
	cQuery += "WHERE T0.ZPC_STATUS = '3'" + CRLF
	cQuery += "	AND T0.ZPC_EXEC = ''" + CRLF
	cQuery += " AND ( "
	cQuery += " ZPC_PROC = ' ' OR "
	cQuery += " (ZPC_PROC <> ' ' AND ZPC_DTPROC < '"+dTos(dDataBase)+"') OR "
	cQuery += " (ZPC_PROC <> ' ' AND ZPC_DTPROC = '"+dTos(dDataBase)+"' AND ZPC_HRPROC <= '"+StrTran(StrZero((SubHoras(Time(),"1")),5,2),".",":")+":00"+"') "
	cQuery += " ) "
	
	cQuery += " AND ZPC_FILIAL BETWEEN '"+aParam[2]+"' AND '"+aParam[3]+"' "
	
	If !Empty(cFilNao)
		cQuery += " AND ZPC_FILIAL NOT IN "+FormatIn(cFilNao,"/")+" "
	Endif
	
	cQuery += "	AND T0.D_E_L_E_T_ = ''" + CRLF
	cQuery += "ORDER BY T0.ZPC_DTINI" + CRLF
	cQuery += "	,T0.ZPC_HRINI" + CRLF
	cQuery += "	,T0.ZPC_FILIAL" + CRLF

	cTab := MPSysOpenQuery(cQuery)

	DbSelectArea((cTab))
	(cTab)->(DbGoTop())

	While ((cTab)->(!Eof()))

		nRecno    := (cTab)->R_E_C_N_O_

		DbSelectArea("ZPC")
		ZPC->(DbGoTo(nRecno))

		If !Empty(ZPC->ZPC_PROC)
			(cTab)->(dbSkip())
			Loop
		Endif

		ZPC->(RecLock("ZPC",.F.))
		ZPC->ZPC_PROC := "X"
		ZPC->ZPC_DTPROC := dDataBase
		ZPC->ZPC_HRPROC := Time()
		ZPC->(MsUnlock())
		(cTab)->(dbSkip())

		lContinua := .T.

		DbSelectArea("ZPC")
		ZPC->(DbGoTo(nRecno))

		If !(Empty(ZPC->ZPC_NOTA))
			RecLock("ZPC", .F.)
			ZPC->ZPC_STATUS := "4"
			ZPC->ZPC_EXEC   := ""
			ZPC->(MsUnlock())

			lContinua := .F.
		Endif

		If (lContinua)	
			cCliOpera := ""
			cLojaOpera := ""
			
			IF Empty(ZPC->ZPC_IDPVTR)
				cFilAnt := ZPC->ZPC_FILIAL
			Else
				cFilAnt := ZPC->ZPC_IDPVTR
			EndIf

			DbSelectArea("ZPI")
			ZPI->(DbSeek(ZPC->ZPC_FILIAL + ZPC->ZPC_CODIGO))

			U_chkSerNF()

			cSerieRPS := SuperGetMv("ES_RPSERIE",,"1  ")
			cSerieNO  := SuperGetMv("ES_RPSNO"  ,,"S  ")

			DbSelectArea("SC5")
			SC5->(DbSetOrder(3))
			SC5->(DbSeek(xFilial("SC5") + ZPC->ZPC_CLIENT+ZPC->ZPC_LOJA+ZPC->ZPC_PEDIDO))

			DbSelectArea("SC6")
			SC6->(DbSetOrder(1))
			SC6->(DbSeek(xFilial("SC6") + SC5->C5_NUM))

			If ((!Empty(SC5->C5_NOTA)) .And. (!Empty(SC5->C5_SERIE)))
				cNota  := SC5->C5_NOTA
				cSerie := SC5->C5_SERIE

				RecLock("ZPC", .F.)
				ZPC->ZPC_NOTA   := cNota
				ZPC->ZPC_SERIE  := cSerie
				ZPC->ZPC_STATUS := "4"
				ZPC->ZPC_DTFIM  := Date()
				ZPC->ZPC_HRFIM  := Time()
				ZPC->ZPC_EXEC   := ""
				ZPC->ZPC_ERRO   := ""
				ZPC->ZPC_ERRLNG := ""
				ZPC->ZPC_PROC   := ""
				ZPC->(MsUnlock())
			Else

				aPvlNfs   := {}
				aBloqueio := {}

				Ma410LbNfs(2, @aPvlNfs, @aBloqueio)

				Ma410LbNfs(1, @aPvlNfs, @aBloqueio)

				cSerie := IIF(GetAdvFVal("SB1","B1_XEMITE",xFilial("SB1")+SC6->C6_PRODUTO,1,"") == "N",cSerieNO,cSerieRPS)

				If ((Empty(aBloqueio)) .And. (!Empty(aPvlNfs)))
					Pergunte("MT460A", .F.)

					cNota := MaPvlNfs(aPvlNfs, cSerie, Iif(mv_par01 == 1, .T., .F.), Iif(mv_par02 == 1, .T., .F.), Iif(mv_par03 == 1, .T., .F.),;
						Iif(mv_par04 == 1, .T., .F.), Iif(mv_par05 == 1, .T., .F.), 1, 1, .F., Iif(mv_par16 == 1, .F., .T.))
				Endif

				If (Empty(cNota))
					RecLock("ZPC", .F.)
					ZPC->ZPC_STATUS := "F"
					ZPC->ZPC_DTFIM  := Date()
					ZPC->ZPC_HRFIM  := Time()
					ZPC->ZPC_EXEC   := ""
					ZPC->ZPC_ERRO   := "Erro de Faturamento, verifique pedido: " + ZPC->ZPC_PEDIDO
					ZPC->ZPC_ERRLNG := ""
					ZPC->ZPC_PROC   := ""
					ZPC->(MsUnlock())
				Else
					ConfirmSX8()

					RecLock("ZPC", .F.)
					ZPC->ZPC_NOTA   := cNota
					ZPC->ZPC_SERIE  := cSerie
					ZPC->ZPC_STATUS := "4"
					ZPC->ZPC_DTFIM  := Date()
					ZPC->ZPC_HRFIM  := Time()
					ZPC->ZPC_EXEC   := ""
					ZPC->ZPC_ERRO   := ""
					ZPC->ZPC_ERRLNG := ""
					ZPC->ZPC_PROC   := ""
					ZPC->(MsUnlock())
				Endif

			Endif

			cOper := ZPC->ZPC_OPER

			DbSelectArea("ZPP")
			dbSetOrder(1)
			If cOper == "I"
				ZPP->(DbSeek(ZPC->ZPC_FILIAL + ZPC->ZPC_CODIGO))
				If (Empty(ZPC->ZPC_CONDPG))
					aParcelas := {}
					cDias     := ""

					While ZPP->(!Eof()) .And. ZPP->ZPP_FILIAL + ZPP->ZPP_CODIGO == ZPC->ZPC_FILIAL + ZPC->ZPC_CODIGO

						// para pagamentos em dinheiro/pix/debito, ajustar a database para o dia do movimento financeiro
						U_TipoPag(ZPP->ZPP_TPPAG,@cTipoPag)
						If cTipoPag $ "CD/DH"
							dDataBase := Min(dDataBase,ZPP->ZPP_DATA)
						Endif	
						cTipoPag := ""

						If !Empty(ZPP->ZPP_CNPJOP)
							lOperadora := .T.
						Endif
						If (Upper(AllTrim(ZPP->ZPP_TPPAG)) == "DINHEIRO")
							dVencto := dDataBase
						Elseif (ZPP->ZPP_VENCTO < dDataBase)
							dVencto := dDataBase
						Else
							dVencto := ZPP->ZPP_VENCTO
						Endif

						aAdd(aParcelas, dVencto - dDataBase)
						cDias += Iif(Empty(cDias), "", ",") + cValToChar(dVencto - dDataBase)

						ZPP->(DbSkip())
					Enddo

					If (Len(aParcelas) == 0)
						ZPC->(RecLock("ZPC", .F.))
						ZPC->ZPC_STATUS := "P"
						ZPC->ZPC_DTFIM  := Date()
						ZPC->ZPC_HRFIM  := Time()
						ZPC->ZPC_EXEC   := ""
						ZPC->ZPC_ERRO   := "Erro: sem parcelas"
						ZPC->ZPC_ERRLNG := "Precisa adicionar parcelas ou informar uma condição de pagamento ao registro"
						ZPC->(MsUnlock())
						
						lContinua := .F.
					Elseif ((Len(aParcelas) == 1) .And. (aParcelas[1] == 0))
						ZPC->(RecLock("ZPC", .F.))
						ZPC->ZPC_CONDPG := SuperGetMV("ES_AVISTA",,"001")
						ZPC->(MsUnlock())
					Else
						If !(criaCond(cDias))
							lContinua := .F.
						Endif
					Endif
				EndIf 


				If cOper == "I"
					If lOperadora
						cCliOpera := GetAdvfVal("SA1","A1_COD",xFilial("SA1")+Alltrim(ZPP->ZPP_CNPJOP),3,"")
						cLojaOpera := GetAdvfVal("SA1","A1_LOJA",xFilial("SA1")+Alltrim(ZPP->ZPP_CNPJOP),3,"")
					Endif	

					If Empty(cCliOpera) .or. Empty(cLojaOpera)
						
						// SA1->(DbSetOrder(1)) // RETIRAR DEPOIS
						// SA1->(dbSeek(xFilial("SA1")))
						cCliOpera := ZPC->ZPC_CLIENTE //SA1->A1_COD
						cLojaOpera := ZPC->ZPC_LOJA //SA1->A1_LOJA
						If Empty(cCliOpera) .or. Empty(cLojaOpera)
							// ---- ate aqui
							
							lErro := .T.
							cErro := "Não encontrado cadastro da Operadora com o CNPJ: "+ZPP->ZPP_CNPJOP
							DisarmTransaction()
							Exit
						Endif
					Endif	

					cTipoPag := 'NF'
					
					// valida de/para de bandeiras
					If !Empty(ZPP->ZPP_BANDEI) .and. !(Alltrim(Upper(ZPP->ZPP_BANDEI)) == "NULL")
						cQ := "SELECT X5_CHAVE "
						cQ += "FROM "+RetSqlName("SX5")+" SX5 (NOLOCK) "
						cQ += "WHERE X5_FILIAL = ' ' "
						cQ += "AND X5_TABELA = 'ZZ' "
						cQ += "AND X5_DESCRI = '"+Alltrim(Upper(ZPP->ZPP_BANDEI))+"' "
						cQ += "AND SX5.D_E_L_E_T_ = ' ' "

						cAliasTrb := MPSysOpenQuery(cQ)

						If (cAliasTrb)->(!Eof())
							cBandeira := (cAliasTrb)->X5_CHAVE
						Endif	

						(cAliasTrb)->(dbCloseArea())
						If Empty(cBandeira)
							lErro := .T.
							cErro := "Não cadastrado de/para da Bandeira (arquivo: SX5, tabela: ZZ): "+Upper(ZPP->ZPP_BANDEI)
							DisarmTransaction()
							Exit
						Endif									
					Endif	

					//If lIncTit
						lOk := .F.
						While !lOk 
							cSeq := Soma1(cSeq)
							DbSelectArea("SE1")
							DbSetOrder(1)
							If !DbSeek(xFilial("SE1")+Avkey("","E1_PREFIXO")+Avkey(Subs(dTos(dDataBase),3)+cSeq ,"E1_NUM")+StrZero(Val(ZPP->ZPP_PARC),TamSX3("E1_PARCELA")[1])+"NF ")
								lOk := .T.
							EndIf 
						EndDo 
					//	lIncTit := .F.
					//Endif	
					
					//Pergunte("FIN040", .F.) // RETIRAR DEPOIS
					//mv_par03 := 2 // nao contabiliza
					//SetMVValue("FIN040","MV_PAR03",2)
					// ATE AQUI
					cNat := SuperGetMV("TI_XNATE1",.F.,"10001")
					aTit := {}	
					aAdd(aTit, {"E1_FILIAL"	,xFilial("SE1")					, Nil})
					aAdd(aTit, {"E1_PREFIXO",""								, Nil})
					aAdd(aTit, {"E1_NUM"	,Subs(dTos(dDataBase),3)+cSeq  	, Nil})
					aAdd(aTit, {"E1_PARCELA",StrZero(Val(ZPP->ZPP_PARC),TamSX3("E1_PARCELA")[1])        	, Nil})
					aAdd(aTit, {"E1_TIPO"	,cTipoPag	 					, Nil})
					aAdd(aTit, {"E1_NATUREZ",cNat			    	    	, Nil})
					If lOperadora
						aAdd(aTit, {"E1_CLIENTE",cCliOpera		  	 			, Nil})
						aAdd(aTit, {"E1_LOJA"	,cLojaOpera		  		   		, Nil})
					Else
						aAdd(aTit, {"E1_CLIENTE",ZPC->ZPC_CLIENT  	 			, Nil})
						aAdd(aTit, {"E1_LOJA"	,ZPC->ZPC_LOJA	  		   		, Nil})
					Endif	
					aAdd(aTit, {"E1_EMISSAO",IIf(ZPP->ZPP_DATA>ZPP->ZPP_VENCTO,ZPP->ZPP_VENCTO,If(!Empty(ZPP->ZPP_DATA),ZPP->ZPP_DATA,ZPP->ZPP_VENCTO))  				, Nil})
					aAdd(aTit, {"E1_VENCTO"	,ZPP->ZPP_VENCTO				, Nil})
					aAdd(aTit, {"E1_VALOR"  ,ZPP->ZPP_VALOR		           	, Nil})
					aAdd(aTit, {"E1_HIST"	,ZPP->ZPP_HISTOR	            , Nil})
					aAdd(aTit, {"E1_XIDTRAN",ZPP->ZPP_IDTRAN	            , Nil})
					
					If lOperadora
						aAdd(aTit, {"E1_NSUTEF" ,ZPP->ZPP_NSU	            , Nil})
						aAdd(aTit, {"E1_CARTAUT",ZPP->ZPP_CODAUT            , Nil})
						aAdd(aTit, {"E1_XCARTHR",ZPP->ZPP_HORA	            , Nil})
						aAdd(aTit, {"E1_NUMCART",ZPP->ZPP_CARTAO            , Nil})
						aAdd(aTit, {"E1_XIDPIX" ,ZPP->ZPP_IDPIX	            , Nil})
						aAdd(aTit, {"E1_XBANDEI",cBandeira		            , Nil})
					Endif	
			
					MSExecAuto({|x,y| FINA040(x,y)},aTit,3)

					If lMsErroAuto
						TrataErro(@cErro,@cMsgErro,@aLog,@lErro)
						Exit
					Else
						GrvZP0(SC5->(Recno()),SE1->(Recno()),cOper)
						// aAdd(aRegTitInc,SE1->(Recno()))
						// If cTipoPag == "DH"
							
						// 	SA6->(dbSetOrder(1)) // RETIRAR DEPOIS
						// 	If SA6->(dbSeek(xFilial("SA6")))
						// 		cBcoDH := SA6->A6_COD 
						// 		cAgeDH := SA6->A6_AGENCIA
						// 		cContaDH := SA6->A6_NUMCON
						// 	Endif	

						// 	If Empty(cBcoDH) .or. Empty(cAgeDH) .or. Empty(cContaDH) // RETIRAR DEPOIS
						// 		lErro := .T.
						// 		cErro := "Não encontrado dados bancarios de baixa por Dinheiro nos parametros."
						// 		DisarmTransaction()
						// 		Exit
						// 	Endif	

						// 	Pergunte("FIN070", .F.)

						// 	aBaixa := {}
						// 	aAdd(aBaixa, {"E1_FILIAL"   ,SE1->E1_FILIAL							,Nil})
						// 	aAdd(aBaixa, {"E1_PREFIXO"  ,SE1->E1_PREFIXO						,Nil})
						// 	aAdd(aBaixa, {"E1_NUM"      ,SE1->E1_NUM							,Nil})
						// 	aAdd(aBaixa, {"E1_PARCELA"  ,SE1->E1_PARCELA						,Nil})
						// 	aAdd(aBaixa, {"E1_TIPO"     ,SE1->E1_TIPO							,Nil})
						// 	aAdd(aBaixa, {"AUTMOTBX"    ,"NOR"                  				,Nil})
						// 	aAdd(aBaixa, {"AUTBANCO"    ,PADR(cBcoDH,TamSX3("A6_COD")[1])     	,Nil})
						// 	aAdd(aBaixa, {"AUTAGENCIA"  ,PADR(cAgeDH,TamSX3("A6_AGENCIA")[1])   ,Nil})
						// 	aAdd(aBaixa, {"AUTCONTA"    ,PADR(cContaDH,TamSX3("A6_NUMCON")[1])  ,Nil})
						// 	aAdd(aBaixa, {"AUTDTBAIXA"  ,dDataBase		           				,Nil})
						// 	aAdd(aBaixa, {"AUTDTCREDITO",dDataBase		           				,Nil})
						// 	aAdd(aBaixa, {"AUTHIST"     ,"VALOR RECEBIDO S/TITULO"      		,Nil})
						// 	aAdd(aBaixa, {"AUTVALREC"   ,SE1->E1_VALOR                     		,Nil})

						// 	MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)

						// 	If lMsErroAuto
						// 		TrataErro(@cErro,@cMsgErro,@aLog,@lErro)
						// 		Exit
						// 	Endif
						// Endif
					Endif
				Endif
			EndIf 

		Endif

		(cTab)->(DbSkip())
	Enddo

	(cTab)->(DbCloseArea())

	//UnlockByName("JINTNF", .T., .F.)

	Conout("[JINTNF] - Finalizando Modo Exclusivo " + cCodEmp + "")

Return(lRet)

Static Function GrvZP0(nRecnoSC5,nRecnoSE1,cOper)

ZP0->(dbSetOrder(1))
If ZP0->(dbSeek(xFilial("ZP0")+Alltrim(Str(nRecnoSC5))))
	While ZP0->(!Eof()) .and. xFilial("ZP0")+Alltrim(Str(nRecnoSC5)) == ZP0->ZP0_FILIAL+Alltrim(Str(ZP0->ZP0_RECPED))
		If !(Alltrim(Str(nRecnoSE1)) == Alltrim(Str(ZP0->ZP0_RECTIT)))
			ZP0->(RecLock("ZP0",.T.))
			ZP0->ZP0_FILIAL := xFilial("ZP0")
			ZP0->ZP0_RECPED := nRecnoSC5
			ZP0->ZP0_RECTIT := nRecnoSE1
			ZP0->(MsUnlock())
		Endif
		ZP0->(dbSkip())
	Enddo
Else
	ZP0->(RecLock("ZP0",.T.))
	ZP0->ZP0_FILIAL := xFilial("ZP0")
	ZP0->ZP0_RECPED := nRecnoSC5
	ZP0->ZP0_RECTIT := nRecnoSE1
	ZP0->(MsUnlock())
Endif			

Return()
