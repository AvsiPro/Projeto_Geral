#INCLUDE "apwizard.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "GCTXDEF.ch"
#INCLUDE 'APWIZARD.CH'
#INCLUDE "TGCVA032.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PARMTYPE.CH"

Static oModelGCT
Static cProposta	:= "99999K"
Static cRevPropos	:= "01"

//-------------------------------------------------------------------
/*/{Protheus.doc} TINCWHCT
Migração de contratos utilizando Webhook.

@author Alexandre Venancio
@since 01/08/2024
@param cEmpMig
@version 1.0
/*/
//-------------------------------------------------------------------

User Function TINCWHCT(cEmpMig, aArray, cPathGCT, nTipoData,cLogMIGRATOTVS,cEmp,cFil,aLogP98)

	Local lGrid			:= .T.
	Local cRetSqlSA1	:= ""
	Local cRetSqlSB1	:= ""
	Local nPosFilial	:= 0
	Local aCN9			:= {}
	Local aCNA			:= {}
	Local aCNB			:= {}
	Local aCNC			:= {}
	Local aAOX			:= {}
	Local aPN0			:= {}
	Local aPH4			:= {}
	Local aPHG			:= {}
	Local aPHH			:= {}
	Local aPacCN9		:= {}
	Local aPacCNA		:= {}
	Local aPacCNB		:= {}
	Local aPacCNC		:= {}
	Local aPacPN0		:= {}
	Local aPacPH4		:= {}
	Local aPacPHG		:= {}
	Local aPacPHH		:= {}
	Local nH			:= 0
	Local nX			:= 0
	Local nCnt			:= 0
	Local cContrato		:= ""
	Local nPosPHG		:= 0
	Local aFilCn9		:= {}
	Local cAux			:= {}
	Local nCN9			:= 0
	Local lAlterCli		:= .F.
	Local lPacDel		:= .F.
	Local aAuxP98		:=	{}
	Local lSa1Blq 		:= .F.

	Private MV_PAR01	:= ""
	Private MV_PAR02	:= ""
	Private MV_PAR03	:= ""
	Private MV_PAR04	:= ""
	Private MV_PAR05	:= ""
	Private MV_PAR06	:= ""
	Private MV_PAR07	:= ""
	Private MV_PAR08	:= ""
	Private MV_PAR09	:= ""
	Private MV_PAR10	:= 1 //UTILIZADAS NO GeraGCT
	Private MV_PAR11	:= 2 //UTILIZADAS NO GeraGCT


	Default cPathGCT	:= ""
	Default aLogP98 	:= {}

	INCLUI		:= .F.
	ALTERA		:= .T.

	cRetSqlSB1	:= RetSqlName("SB1")
	cRetSqlSA1	:= RetSqlName("SA1")

	DbSelectArea("PN1")
	PN1->(DbSetOrder(1))

	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))

	DbSelectArea("PMV")
	PMV->(DbSetOrder(1))

	If lGrid

		aFilCN9	:= {}
		cAux	:= ""
		nCN9	:= 0
		aCabec  := {}
		aAuxC   := {}
		aAuxI   := {}

		nTot := Ascan(aArray,{|x| x[1] == "CN9"})
		If nTot > 0
			aAuxC := {}
			For nCnt := 2 to len(aArray[nTot])
				aAuxP98 := {}
				Aadd(aAuxP98,aArray[nTot,1])

				For nX := 1 to len(aArray[nTot,nCnt]) //to len(aArray[nTot,nCnt])-1
					If nCnt == 2 .And. len(aAuxC) < 1
						//For nH := 1 to len(aArray[nTot,nCnt])-1
						For nH := 1 to len(aArray[nTot,nCnt])
							 
							Aadd(aAuxC,aArray[nTot,nCnt,nH,1])
						Next nH
						Aadd(aCN9,aAuxC)
					EndIf


					If aArray[nTot,nCnt,nX,1] == "CN9_NUMERO"
						Aadd(aAuxP98,aArray[nTot,nCnt,nX,2])
					ENDif 

					Aadd(aAuxI,aArray[nTot,nCnt,nX,2])
				Next nX
				
				Aadd(aCN9,aAuxI)
				
				Aadd(aAuxP98,aArray[nTot,nCnt,len(aArray[nTot,nCnt]),2])
				Aadd(aAuxP98,'')
				Aadd(aLogP98,aAuxP98)
				
				aAuxI := {}
			Next nCnt
		EndIf

		nCN9 ++

		U_TINCLOGCT(cLogMIGRATOTVS,"MIGRATOTVS ########## Inicio: ########## " + Time())

		U_TINCLOGCT(cLogMIGRATOTVS,"#### PROCESSANDO CN9 ####")

		nTot := Ascan(aArray,{|x| x[1] == "CNB"})
		aCabec  := {}
		aAuxC   := {}
		aAuxI   := {}

		If nTot > 0
			aAuxC := {}
			For nCnt := 2 to len(aArray[nTot])
				aAuxP98 := {}
				cProd   := ""
				Aadd(aAuxP98,aArray[nTot,1])

				For nX := 1 to len(aArray[nTot,nCnt])
					If nCnt == 2 .And. len(aAuxC) < 1
						For nH := 1 to len(aArray[nTot,nCnt])
							Aadd(aAuxC,aArray[nTot,nCnt,nH,1])
						Next nH
						Aadd(aCNB,aAuxC)
					EndIf

					If aArray[nTot,nCnt,nX,1] $ "CNB_CONTRA" ///CNB_QUANT/CNB_VLUNIT/CNB_SITUAC"
						Aadd(aAuxP98,aArray[nTot,nCnt,nX,2])
					ENDif 
					If aArray[nTot,nCnt,nX,1] $ "CNB_PRODUT"
						cProd := aArray[nTot,nCnt,nX,2]
					ENDif 
					Aadd(aAuxI,aArray[nTot,nCnt,nX,2])
				Next nX
				
				Aadd(aCNB,aAuxI)
				
				Aadd(aAuxP98,cProd)
				Aadd(aAuxP98,aArray[nTot,nCnt,len(aArray[nTot,nCnt]),2])
				Aadd(aAuxP98,'')
				Aadd(aLogP98,aAuxP98)

				aAuxI := {}
			Next nCnt
		EndIf

		U_TINCLOGCT(cLogMIGRATOTVS,"#### PROCESSANDO CNB ####")

		nTot := 0

		aAOX := BuscAox()

		U_TINCLOGCT(cLogMIGRATOTVS,"#### PROCESSANDO AOX ####")


		nTot := Ascan(aArray,{|x| x[1] == "CNA"})
		aCabec  := {}
		aAuxC   := {}
		aAuxI   := {}

		If nTot > 0
			aAuxC := {}
			For nCnt := 2 to len(aArray[nTot])
				aAuxP98 := {}
				Aadd(aAuxP98,aArray[nTot,1])

				For nX := 1 to len(aArray[nTot,nCnt])
					If nCnt == 2 .And. len(aAuxC) < 1
						For nH := 1 to len(aArray[nTot,nCnt])
							Aadd(aAuxC,aArray[nTot,nCnt,nH,1])
						Next nH
						Aadd(aCNA,aAuxC)
					EndIf

					If aArray[nTot,nCnt,nX,1] $ "CNA_CONTRA"
						Aadd(aAuxP98,aArray[nTot,nCnt,nX,2])
					ENDif

					Aadd(aAuxI,aArray[nTot,nCnt,nX,2])
				Next nX

				Aadd(aCNA,aAuxI)
				
				Aadd(aAuxP98,aArray[nTot,nCnt,len(aArray[nTot,nCnt]),2])
				Aadd(aAuxP98,'')
				Aadd(aLogP98,aAuxP98)
				aAuxI := {}
			Next nCnt
		EndIf

		nTot := 0

		nTot := Ascan(aArray,{|x| x[1] == "CNC"})
		aCabec  := {}
		aAuxC   := {}
		aAuxI   := {}

		If nTot > 0
			aAuxC := {}
			For nCnt := 2 to len(aArray[nTot])
				aAuxP98 := {}
				Aadd(aAuxP98,aArray[nTot,1])

				For nX := 1 to len(aArray[nTot,nCnt])
					If nCnt == 2 .And. len(aAuxC) < 1
						For nH := 1 to len(aArray[nTot,nCnt])
							Aadd(aAuxC,aArray[nTot,nCnt,nH,1])
						Next nH
						Aadd(aCNC,aAuxC)
					EndIf

					If aArray[nTot,nCnt,nX,1] $ "CNC_NUMERO"
						Aadd(aAuxP98,aArray[nTot,nCnt,nX,2])
					ENDif
					Aadd(aAuxI,aArray[nTot,nCnt,nX,2])
				Next nX

				Aadd(aCNC,aAuxI)
				
				Aadd(aAuxP98,aArray[nTot,nCnt,len(aArray[nTot,nCnt]),2])
				Aadd(aAuxP98,'')
				Aadd(aLogP98,aAuxP98)
				aAuxI := {}
			Next nCnt
		EndIf

		nTot := 0

		U_TINCLOGCT(cLogMIGRATOTVS,"#### PROCESSANDO CNA ####")
		U_TINCLOGCT(cLogMIGRATOTVS,"#### PROCESSANDO CNC ####")

		nTot := Ascan(aArray,{|x| x[1] == "PH4"})
		aCabec  := {}
		aAuxC   := {}
		aAuxI   := {}

		Asort(aLogP98,,,{|x,y| x[1]+x[2]+cvaltochar(x[3]) < y[1]+y[2]+cvaltochar(y[3])})

		If nTot > 0
			aAuxC := {}
			For nCnt := 2 to len(aArray[nTot])


				For nX := 1 to len(aArray[nTot,nCnt])
					If nCnt == 2 .And. len(aAuxC) < 1
						For nH := 1 to len(aArray[nTot,nCnt])
							Aadd(aAuxC,aArray[nTot,nCnt,nH,1])
						Next nH
						Aadd(aPH4,aAuxC)
					EndIf
					Aadd(aAuxI,aArray[nTot,nCnt,nX,2])
				Next nX

				Aadd(aPH4,aAuxI)
				aAuxI := {}
			Next nCnt
		EndIf

		nTot := 0


		U_TINCLOGCT(cLogMIGRATOTVS,"#### PROCESSANDO PH4 ####")

		nTot := Ascan(aArray,{|x| x[1] == "PHG"})
		aCabec  := {}
		aAuxC   := {}
		aAuxI   := {}

		If nTot > 0
			aAuxC := {}
			For nCnt := 2 to len(aArray[nTot])


				For nX := 1 to len(aArray[nTot,nCnt])
					If nCnt == 2 .And. len(aAuxC) < 1
						For nH := 1 to len(aArray[nTot,nCnt])
							Aadd(aAuxC,aArray[nTot,nCnt,nH,1])
						Next nH
						Aadd(aPHG,aAuxC)
					EndIf
					Aadd(aAuxI,aArray[nTot,nCnt,nX,2])
				Next nX

				Aadd(aPHG,aAuxI)
				aAuxI := {}
			Next nCnt
		EndIf

		nTot := 0

		U_TINCLOGCT(cLogMIGRATOTVS,"#### PROCESSANDO PHG ####")

		nTot := Ascan(aArray,{|x| x[1] == "PHH"})
		aCabec  := {}
		aAuxC   := {}
		aAuxI   := {}

		If nTot > 0
			aAuxC := {}
			For nCnt := 2 to len(aArray[nTot])


				For nX := 1 to len(aArray[nTot,nCnt])
					If nCnt == 2 .And. len(aAuxC) < 1
						For nH := 1 to len(aArray[nTot,nCnt])
							Aadd(aAuxC,aArray[nTot,nCnt,nH,1])
						Next nH
						Aadd(aPHH,aAuxC)
					EndIf
					Aadd(aAuxI,aArray[nTot,nCnt,nX,2])
				Next nX

				Aadd(aPHH,aAuxI)
				aAuxI := {}
			Next nCnt
		EndIf

		nTot := 0

		U_TINCLOGCT(cLogMIGRATOTVS,"#### PROCESSANDO PHH ####")

		nPosFilial	:= aScan(aCNB[1], {|a| Alltrim(a) == "CNB_UNINEG" })


		lAlterCli := .T.
		lPacDel := .F.


		U_TINCLOGCT(cLogMIGRATOTVS,"#### EXISTEM " + cValToChar( (Len(aCN9)-1) ) + " CONTRATOS A SEREM MIGRADOS ####")

		//VerIfica se o cliente existe na migração do master
		nPosNum 	:= Ascan(aCN9[1], {|a| Alltrim(a) == "CN9_NUMERO"})
		nPosCCNB	:= Ascan(aCNB[1], {|a| Alltrim(a) == "CNB_CONTRA"})
		nPosCCNA	:= Ascan(aCNA[1], {|a| Alltrim(a) == "CNA_CONTRA"})
		nPosCCNC	:= Ascan(aCNC[1], {|a| Alltrim(a) == "CNC_NUMERO"})

		Asort(aCN9,,,{|x,y| x[nPosNum]  > y[nPosNum] })
		Asort(aCNA,,,{|x,y| x[nPosCCNA] > y[nPosCCNA]})
		Asort(aCNB,,,{|x,y| x[nPosCCNB] > y[nPosCCNB]})
		Asort(aCNC,,,{|x,y| x[nPosCCNC] > y[nPosCCNC]})

		For nH := 2 to len(aCN9)

			cHoraIni := Time()

			U_TINCLOGCT(cLogMIGRATOTVS, cHoraIni + " - Linha processada: " + Alltrim(Str(nH-1)) + "/" + cValToChar( (Len(aCN9)-1) ) )

			//Pego o contrato da CN9 que foi adicionado ao pacote.

			cContrato := Alltrim(aCN9[nH][nPosNum])

			lContrato := .F.
			U_TINCLOGCT(cLogMIGRATOTVS,"----------------------------------------------------------------------------------------------------------")
			U_TINCLOGCT(cLogMIGRATOTVS,"#### Processando Contrato " + cContrato + " ####")

			//VerIfica se o contrato ja foi migrado

			/* 
					VERIFICAR COMO TRATAR A PN1 DAQUI PRA FRENTE
			*/
			If PN1->(DbSeek(xFilial("PN1")+cEmpMig+"CN9"+AvKey(cContrato,"PN1_CHVFUL")))
				While Alltrim(PN1->PN1_CHVFUL) == cContrato
					//Pular contrato na migração de revenda ou corporativo
					If Empty(PN1->PN1_CPOCHV)
						cDetalhe := "Contrato ja existe ou foi migrado em base: "  + cContrato +" | PN1 : "+cvaltochar(PN1->(Recno()))
						lContrato := .T.
						U_TINCLOGCT(cLogMIGRATOTVS,"Erro-OK;" + cContrato + cDetalhe)
						GravarLog(aLogP98,'3',cContrato,aPacCNB,cDetalhe)
					EndIf

					PN1->(DbSkip())
				EndDo

				If lContrato
					Loop
				EndIf
			EndIf


			nPosCNB	:= aScan(aCNB, {|a| Alltrim(a[nPosCCNB]) == cContrato })
			nPosCNC	:= aScan(aCNC, {|a| Alltrim(a[nPosCCNC]) == cContrato })
			nPosCNA	:= aScan(aCNA, {|a| Alltrim(a[nPosCCNA]) == cContrato })

			//Adiciono os cabeçalho
			AADD(aPacCNB, aCNB[1])
			AADD(aPacCN9, aCN9[1])
			AADD(aPacCNA, aCNA[1])
			AADD(aPacCNC, aCNC[1])

			nCN9INDICE := aScan(aCN9[1] , "CN9_INDICE")

			nCNAINDICE := aScan(aCNA[1] , "CNA_INDICE")

			nCNCCLIENT := aScan(aCNC[1] , "CNC_CLIENT")
			nCNCTIPCLI := aScan(aCNC[1] , "CNC_TIPCLI")

			nCNBPRODUT := aScan(aCNB[1] , "CNB_PRODUT")

			nCNBQUANT	:= aScan(aCNB[1]	, "CNB_QUANT")
			nCNBVLUNIT	:= aScan(aCNB[1]	, "CNB_VLUNIT")
			nCNBVLTOT	:= aScan(aCNB[1]	, "CNB_VLTOT")

			nCNBSITUAC	:= aScan(aCNB[1]	, "CNB_SITUAC")
			nCNBSTATRM	:= aScan(aCNB[1]	, "CNB_STATRM")

			nCNBFLREAJ	:= aScan(aCNB[1]	, "CNB_FLREAJ")
			nCNBINDICE 	:= aScan(aCNB[1] 	, "CNB_INDICE")

			nCNBTIPREC	:= aScan(aCNB[1] 	, "CNB_TIPREC")

			nCNBDESCRI	:= aScan(aCNB[1] 	, "CNB_DESCRI")

			nCNBCONDPG	:= aScan(aCNB[1] 	, "CNB_CONDPG")
			nCNBXCOMPE  := aScan(aCNB[1]	, "CNB_XCOMPE")

			If Len(aPHG) > 0
				nPHGPRODUT := aScan(aPHG[1] , "PHG_PRODUT")
				nPHGCLIENT := aScan(aPHG[1] , "PHG_CLIENT")
			EndIf

			If Len(aPH4) > 0
				nPH4PRODUT := aScan(aPH4[1] , "PH4_PRODUT")
				nPH4CONTRA := aScan(aPH4[1] , "PH4_CONTRA")
			EndIf

			//Se existir a PN0
			If Len(aPN0) > 0
				nPosPN0	:= aScan(aPN0 , {|a| Alltrim(a[1]) == cContrato })
				If nPosPN0 > 0
					AADD(aPacPN0, aPN0[1])
				EndIf
			EndIf

			//Se existir a PH4
			If Len(aPH4) > 0
				nPosPH4	:= aScan(aPH4 , {|a| Alltrim(a[nPH4CONTRA]) == cContrato })
				If nPosPH4 > 0
					AADD(aPacPH4, aPH4[1])

				EndIf
			EndIf

			//Se existir a PHG
			If Len(aPHG) > 0
				nPosPHG	:= aScan(aPHG , {|a| Alltrim(a[1]) == cContrato })
				If nPosPHG > 0
					AADD(aPacPHG, aPHG[1])
				EndIf
			EndIf

			//Se existir a PHH
			If Len(aPHH) > 0
				nPosPHH	:= aScan(aPHH , {|a| Alltrim(a[1]) == cContrato })
				If nPosPHH > 0
					AADD(aPacPHH, aPHH[1])
				EndIf
			EndIf

			If nPosCnb == 0 .Or. nPosCnc == 0
				U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";CNB ou CNC não enviada para o contrato: " + cContrato)
				aPacCN9 := {}
				aPacCNA := {}
				aPacCNB := {}
				aPacCNC := {}
				aPacPN0 := {}
				aPacPH4 := {}
				aPacPHG := {}
				aPacPHH	:= {}
				Loop
			EndIf

			//Monto o pacote para CNA
			If nPosCNA > 0
				For nX := nPosCNA to Len(aCNA)

					If Alltrim(aCNA[nX][1]) == cContrato
						AADD(aPacCNA, aCNA[nX])
					Else
						Exit
					EndIf

				Next nX
			EndIf

			//Monto o pacote para CNB
			lGratuito := .F.
			For nX := nPosCNB to len(aCNB)

				If Alltrim(aCNB[nX][nPosCCNB]) == cContrato
					//--------------------------------------------------
					//TRATAMENTO PARA ADICIONAR OS PRODUTOS SMS
					//--------------------------------------------------
					aCNB[nX,nCNBXCOMPE] := If(len(aCNB[nX,nCNBXCOMPE])>7,substr(aCNB[nX,nCNBXCOMPE],4),aCNB[nX,nCNBXCOMPE])
					aCNBCDU := {}
					aCNBCDU := ACLONE(aCNB[nX])


					aCNB[nX][nCNBDESCRI] := ""


					If !Empty(aCNB[nX][nCNBPRODUT])
						AADD(aPacCNB, ACLONE(aCNB[nX]))
					EndIf

				Else

					Exit

				EndIf

			Next nX

			If nPosCnc > 0
				//Monta o pacote da CNC no caso de ter rateio.
				For nX := nPosCnc to len(aCNC)

					If Alltrim(aCNC[nX][nPosCCNC]) == cContrato
						AADD(aPacCNC, aCNC[nX])
					Else
						Exit
					EndIf

				Next nX
			EndIF

			If Len(aPacPH4) > 0

				//Monto o pacote para PH4
				For nX := nPosPH4 to len(aPH4)

					If Alltrim(aPH4[nX][nPH4CONTRA]) == cContrato

						Aadd( aPH4[nX] , "" ) //Status de Controle
						AADD(aPacPH4, aPH4[nX])

					Else
						Exit
					EndIf

				Next nX

			EndIf

			If nPosPHG > 0

				//Monto o pacote para PHG
				For nX := nPosPHG to len(aPHG)

					If Alltrim(aPHG[nX][1]) == cContrato

						AADD(aPacPHG, aPHG[nX])

						//Tratamento para adicionar o CGC na CNC.
						nScan := aScan(aPacCNC, {|a| Alltrim(UPPER(a[nCNCCLIENT])) == Alltrim(UPPER(aPHG[nX][nPHGCLIENT])) })
						If nScan == 0
							aExemplo := ACLONE(aPacCNC[2])

							aExemplo[nCNCCLIENT] := aPHG[nX][nPHGCLIENT]
							aExemplo[nCNCTIPCLI] := "04"
							Aadd( aPacCNC , ACLONE(aExemplo) )
						EndIf

					Else
						Exit
					EndIf

				Next nX

			EndIf

			If Len(aPacPN0) > 0

				//Monto o pacote para PN0
				For nX := nPosPN0 to len(aPN0)

					If Alltrim(aPN0[nX][1]) == cContrato
						AADD(aPacPN0, aPN0[nX])
					Else
						Exit
					EndIf

				Next nX

			EndIf

			If Len(aPacPHH) > 0

				If nPosPHH > 0

					//Monto o pacote para PHH
					For nX := nPosPHH to len(aPHH)

						If Alltrim(aPHH[nX][1]) == cContrato
							AADD(aPacPHH, aPHH[nX])
						Else
							Exit
						EndIf

					Next nX

				EndIf

			EndIf

			If Len(aPacCNB) > 1
				AADD(aPacCN9, aCN9[nH])
			EndIf

			lSa1Blq 		:= .F.
			DbSelectArea("SA1")
			DbSetOrder(3)
			Dbseek(xFilial("SA1")+cContrato)
			If SA1->A1_MSBLQL == "1"
				lSa1Blq := .T.
				Reclock("SA1",.F.)
				SA1->A1_MSBLQL := '2'
				SA1->(Msunlock())
			EndIf 

			If Len(aPacCN9) > 1 .AND. Len(aPacCNA) > 1 .AND. Len(aPacCNB) > 1 .AND. Len(aPacCNC) > 1

				GeraGCT({aPacCNA, aPacCNB, aPacCNC, aAOX, aPacCN9, nH, cRetSqlSB1, cRetSqlSA1, nPosFilial, cEmpMig, aArray, aPacPN0, aPacPH4, aPacPHG, aPacPHH, nTipoData,cLogMIGRATOTVS},nPosNum)
				cDetalhe := ''
								//rever esta semana
				GravarLog(aLogP98,'1',cContrato,aPacCNB,cDetalhe)
				
			Else
				U_TINCLOGCT(cLogMIGRATOTVS,"NAO IRA PROCESSAR" )
			EndIf
			
			If lSa1Blq
				DbSelectArea("SA1")
				DbSetOrder(3)
				Dbseek(xFilial("SA1")+cContrato)
				Reclock("SA1",.F.)
				SA1->A1_MSBLQL := '1'
				SA1->(Msunlock())
			EndIf 
			
			Sleep(1000)

			aPacCN9 := {}
			aPacCNA := {}
			aPacCNB := {}
			aPacCNC := {}
			aPacPN0 := {}
			aPacPH4 := {}
			aPacPHG := {}
			aPacPHH := {}

			cHoraFim := Time()

			U_TINCLOGCT(cLogMIGRATOTVS, cHoraFim + " (" + ElapTime ( cHoraIni, cHoraFim ) + ") - " + "Linha processada: " + Alltrim(Str(nH)) + "/" + cValToChar( (Len(aCN9)) ) )

		Next nH

	EndIf

	U_TINCLOGCT(cLogMIGRATOTVS,"MIGRATOTVS ########## Acabou: ########## " + Time())

Return


/*/{Protheus.doc} GravarLog
	(long_description)
	@type  Static Function
	@author user
	@since date
	@version version
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function GravarLog(aLogP98,nTipo,cContrato,aPacCNB,cDetalhe)

Local aArea := GetArea()
Local nX 
Default aPacCNB := {}
/*
	GRAVAÇÃO DA P98 E PWU APÓS FINALIZAR O CONTRATO
	RODAR A QUERY PARA BUSCAR NA CN9, CNA, CNB E CNC
*/
nPosP981 := ASCAN(aLogP98,{|x| x[1]+x[2] == 'CN9'+cContrato})
nPosP982 := ASCAN(aLogP98,{|x| x[1]+x[2] == 'CNA'+cContrato})
nPosP983 := ASCAN(aLogP98,{|x| x[1]+x[2] == 'CNC'+cContrato})

If nPosP981 > 0 .and. nPosP982 > 0 .and. nPosP983 > 0
	cQuery := " SELECT CN9.R_E_C_N_O_ AS CN9RECNO, CNA.R_E_C_N_O_ AS CNARECNO, CNC.R_E_C_N_O_ AS CNCRECNO        " 
	cQuery += " FROM   " + RetSQLName("CN9") + " CN9, " + RetSQLName("CNA") + " CNA, " + RetSQLName("CNC") + " CNC       " 
	cQuery += " WHERE  CN9_FILIAL = '" + FwxFilial("CN9") + "'                      " 
	cQuery += "        AND CNA.D_E_L_E_T_ = ' ' AND CNC.D_E_L_E_T_=' '                 " 
	cQuery += "             AND CN9_NUMERO = CNA_CONTRA                     " 
	cQuery += "             AND CN9_REVISA = CNA.CNA_REVISA                     " 
	cQuery += "             AND CN9_REVATU = ' '                     " 
	cQuery += "             AND CN9_ESPCTR = '2'                     " 
	cQuery += "             AND CN9.D_E_L_E_T_ = ' '                    " 
	cQuery += " AND CNA_CONTRA IN (SELECT 'CON'||A1_COD FROM " + RetSQLName("SA1") + " WHERE A1_FILIAL='" + FwxFilial("SA1") + "' AND A1_CGC IN('"+cContrato+"')) " 
	cQuery += " AND CNC_NUMERO = CN9_NUMERO AND CNC_REVISA = CN9_REVISA " 
	cQuery += " AND CNC_NUMERO IN (SELECT 'CON'||A1_COD FROM " + RetSQLName("SA1") + " WHERE A1_FILIAL='" + FwxFilial("SA1") + "' AND A1_CGC IN('"+cContrato+"')) " 
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

	DbSelectArea("TRB")
	
	If TRB->CN9RECNO > 0
		// aLogP98[nPosP981,3] recnop98 cn9
		cRet := If(nTipo=='1','#Sucesso','#Erro')
		cDetalhe := ''
		aLogP98[nPosP981,4] := cRet
		U_TINCGRLG(aLogP98[nPosP981,3],TRB->CN9RECNO,"CN9",cRet,cDetalhe,nTipo,.F.,cUsername)
	ElseIf nTipo=='3' .And. !Empty(cDetalhe)
		cRet := "#Aviso"
		U_TINCGRLG(aLogP98[nPosP981,3],0,"CN9",cRet,cDetalhe,nTipo,.F.,cUsername)
	EndIF 

	If TRB->CNARECNO > 0
		// aLogP98[nPosP982,3] recnop98 cna
		cRet := If(nTipo=='1','#Sucesso','#Erro')
		cDetalhe := ''
		aLogP98[nPosP982,4] := cRet
		U_TINCGRLG(aLogP98[nPosP982,3],TRB->CNARECNO,"CNA",cRet,cDetalhe,nTipo,.F.,cUsername)
	ElseIf nTipo=='3' .And. !Empty(cDetalhe)
		cRet := "#Aviso"
		U_TINCGRLG(aLogP98[nPosP982,3],0,"CNA",cRet,cDetalhe,nTipo,.F.,cUsername)
	EndIf 

	If TRB->CNCRECNO > 0
		cRet := If(nTipo=='1','#Sucesso','#Erro')
		cDetalhe := ''
		// aLogP98[nPosP983,3] recnop98 cnc
		aLogP98[nPosP983,4] := cRet
		U_TINCGRLG(aLogP98[nPosP983,3],TRB->CNCRECNO,"CNC",cRet,cDetalhe,nTipo,.F.,cUsername)
	ElseIf nTipo=='3' .And. !Empty(cDetalhe)
		cRet := "#Aviso"
		U_TINCGRLG(aLogP98[nPosP983,3],0,"CNC",cRet,cDetalhe,nTipo,.F.,cUsername)
	EndIF 

	

EndIf 

If len(aPacCNB) > 0
	nPosPCNB := Ascan(aPacCNB[1],{|x| x == "CNB_PRODUT"})

	For nX := 2 to len(aPacCNB)
		
		nPosP984 := ASCAN(aLogP98,{|x| x[1]+x[2]+cvaltochar(x[3]) == 'CNB'+cContrato+aPacCNB[nX,nPosPCNB]})

		If nPosP984 > 0
			cQuery := " SELECT CNB.R_E_C_N_O_ AS CNBRECNO,CNB_PRODUT,CNB_QUANT,CNB_VLUNIT   " 
			cQuery += " FROM   " + RetSQLName("CNB") + " CNB , " + RetSQLName("CN9") + " CN9   " 
			cQuery += " WHERE  CNB_FILIAL='" + FwxFilial("CNB") + "'   " 
			cQuery += "        AND CN9_FILIAL = '" + FwxFilial("CN9") + "'   " 
			cQuery += "        AND CNB_PRODUT = '"+aPacCNB[nX,nPosPCNB]+"'   " 
			cQuery += "        AND CNB.D_E_L_E_T_ = ' '   " 
			cQuery += "        AND CN9_NUMERO = CNB_CONTRA   " 
			cQuery += "        AND CN9_REVISA = CNB.CNB_REVISA   " 
			cQuery += "        AND CN9_REVATU = ' '   " 
			cQuery += "        AND CN9_ESPCTR = '2'   " 
			cQuery += "        AND CN9.D_E_L_E_T_ = ' '   " 
			cQuery += "        AND CNB_CONTRA IN (SELECT 'CON'||A1_COD FROM   " + RetSQLName("SA1") + " WHERE  A1_FILIAL='" + FwxFilial("SA1") + "' AND A1_CGC IN('"+cContrato+"'))   " 
			cQuery += "        AND CNB_UNINEG='"+cFilDest+"'   " 
			cQuery += " ORDER BY  CNB_CONTRA,CNB_ITEM   " 

			
			If Select('TRB') > 0
				dbSelectArea('TRB')
				dbCloseArea()
			EndIf

			DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

			DbSelectArea("TRB")

			If TRB->CNBRECNO > 0
				cRet := If(nTipo=='1','#Sucesso','#Erro')
				cDetalhe := ''
				// aLogP98[nPosP984,4] recnop98
				//TRB->CNBRECNO Recnocnb
				aLogP98[nPosP984,5] := cRet
				U_TINCGRLG(aLogP98[nPosP984,4],TRB->CNBRECNO,"CNB",cRet,cDetalhe,nTipo,.F.,cUsername)
			ElseIf nTipo=='3' .And. !Empty(cDetalhe)
				cRet := "#Aviso"
				U_TINCGRLG(aLogP98[nPosP983,3],0,"CNB",cRet,cDetalhe,nTipo,.F.,cUsername)
			EndIF 
		EndIf 
	Next nX 
Else 
	
	If nTipo=='3' .And. !Empty(cDetalhe)
		cRet := "#Aviso"
	Else
		nTipo 		:= '3'
		cRet 		:= '#Erro'
		cDetalhe 	:= ''
	EndIf

	For nX := 1 to len(aLogP98)

		If aLogP98[nX,01] == 'CNB' .And. aLogP98[nX,02] == cContrato
			aLogP98[nX,5] := cRet
			U_TINCGRLG(aLogP98[nX,4],0,"CNB",cRet,cDetalhe,nTipo,.F.,cUsername)
		EndIf 

	Next nX 
EndIf 

RestArea(aArea)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ProcGCT
Migração de dados de contratos quebrando no startjob.

@author Henrique Ghidini
@since 23/03/2017
@version P12
/*/
//-------------------------------------------------------------------



Static Function GeraGCT(aParams,nPosNum)//(aAuxCNA, aAuxCNB, aAuxCNC, aAuxAOX, aAuxCN9, nAuxG, cAuxSqlSB1, cAuxSqlSA1, nPosFil, cLockTdi,cEmpMig, nTipoData)

	Local cGerContra	:= ""
	Local cGerPed		:= ""
	Local clEmpFat 		:= ""
	Local clFilFat 		:= ""
	Local aItenGCT		:= {}
	Local aRateioAZG	:= {}
	Local aLinCN9		:= {}
	Local aLinCNC		:= {}
	Local aTpPlanGrd	:= {}
	Local aPedVenCRM	:= {}
	Local nTpManut		:= 0
	Local cChaveLock	:= ""
	Local cIdProcess	:= ""
	Local cMigInter		:= ""
	Local lAtuModel		:= .T.
	Local _clCtrGer		:= ""
	Local _clCtrRevGer	:= ""
	Local cProduto
	Local nH
	Local lOk			:= .T.
	Local lModel 		:= .F.
	//Local aAuxPN0		:= {}
	Local cLogMIGRATOTVS := ""

	Private aCNA
	Private aCNB
	Private aCNC
	Private aAOX
	Private aCN9
	Private aPN0
	Private aPH4
	Private aPHH
	Private aPHG
	Private nG
	Private cContrato	:= ""
	Private nX
	Private cRetSqlSB1	:= ""
	Private cRetSqlSA1	:= ""
	Private nPosFilial	:= aParams[9]
	Private cEmpresaGer	:= aParams[10]
	Private cSysImp		:= aParams[11]
	Private nTipoData	:= 1 //aParams[16]  formato DD/MM/AAAA
	Private nMvPar10	:= 1
	Private aMIGRATOTVS := {}
	Private lTemPH4 := .T.


	oModelGct := NIL
	//================================================
	// Inicializa variáveis de ambiente
	//================================================
	SetPrvt("INCLUI")
	SetPrvt("ALTERA")

	aCNA		:= aParams[1]
	aCNB		:= aParams[2]
	aCNC		:= aParams[3]
	aAOX		:= aParams[4]
	aCN9		:= aParams[5]
	nG			:= aParams[6]
	aPN0		:= aParams[12]
	aPH4		:= aParams[13]
	aPHG		:= aParams[14]
	aPHH		:= aParams[15]

	cLogMIGRATOTVS := aParams[17]

	cRetSqlSB1	:= aParams[7]
	cRetSqlSA1	:= aParams[8]

	cMigInter		:= alltrim(GetMV("TI_MIGINT",,"0169"))
	lAtuModel		:= GetMV("TI_V32AMDL",,.T.)

	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	DbSelectArea("PMV")
	PMV->(DbSetOrder(1))

	DbSelectArea("PN1")
	PN1->(DbSetOrder(1))

	cRetSqlSA1 := RetSqlName("SA1")

	nPosCli		:= nPosNum //1
	cCodCli		:= ""

	nH := nG

	nTamPMV := ""

	If nMvPar10 == 1
		//Para migrar o master usa o de-para na sa1 por cnpj
		SA1->(DbSetOrder(3))

		If !SA1->(DbSeek(xFilial("SA1")+ Alltrim(aCN9[2][nPosCli]) ))
			U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + Alltrim(aCN9[2][nPosCli]) + ";Cliente não localizado " + Alltrim(aCN9[2][nPosCli]))
			Return()
		EndIf

	Else
		If !PMV->(DbSeek(xFilial("PMV")+"000001"+"SA1"+AvKey(Substr(Alltrim(aCN9[2][nPosCli]),4,10),"PMV_IDESTR")))
			U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + Alltrim(aCN9[2][nPosCli]) + ";Cliente não localizado " + Alltrim(aCN9[2][nPosCli]))
			Return(.T.)
		EndIf
	EndIf

	cCodCli		:= IIf(nMvPar10 == 1, SA1->A1_COD, Alltrim(PMV->PMV_VAR1))
	cLojaCli	:= "00"
	cContrato	:= Alltrim(aCN9[2][nPosCli])

	//Busco as informações por planilha

	lOk := GV032LdDados(cCodCli , cLojaCli, cProposta , cRevPropos , @aPedVenCRM,  aRateioAZG , @aTpPlanGrd , @aLinCN9 , @aLinCNC , cLogMIGRATOTVS )

	If Len(aTpPlanGrd) == 0 .And. Len(aPedVenCRM) == 0 .And. lOk
		lOk := .F.
		U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Erro na importação do contrato pos produtos, problema no preenchimento dos itens: " + cContrato + CRLF)
	EndIf

	If lOk

		//Indico que o model foi ativo pela Thread
		lModel := .T.

		SetPrvt("ALTERA")
		SetPrvt("INCLUI")

		INCLUI	:= .T.
		ALTERA	:= .F.

		If oModelGct == Nil
			oModelGct := FWLoadModel("TGCVA002")
		EndIf

		U_GV002S0S("")
		U_GV002GH3S("")
		U_PGV300GL({})
		U_GV002GTL( .F. )
		U_GV002GAC({})
		U_GV002GP4({})
		U_GV002GP3({})
		U_A3SRevis(.F.)

		// Gera Contrato/ Carrega o Model
		If Len(aTpPlanGrd) > 0
			lOk	:=	GV032Gct( oModelGCT , cCodCli , cLojaCli , aTpPlanGrd,  aLinCN9 , aLinCNC , cProposta , cRevPropos , @cGerContra , clEmpFat , clFilFat ,@nTpManut  , @cChaveLock, cLogMIGRATOTVS)
		EndIf

		// Gravação do contrato
		If Len(aTpPlanGrd) > 0 .And. lOk
			lOk := Gv32VldGct(oModelGCT,nTpManut,cLogMIGRATOTVS)
			If lOk
				lOk	:=	GV32GrvCrt( oModelGCT ,@cGerContra , nTpManut, @_clCtrGer , @_clCtrRevGer  , cLogMIGRATOTVS)
				U_GV001X08(cCodCli,cLojaCli,cProposta)
				U_GV001X09(cCodCli,cLojaCli,cProposta)
				U_GV38STAC( .T. ) // Retorna o valor Original da Variavel Static

				If lOk
					lRet := GV32Vigen(oModelGCT,cLogMIGRATOTVS)

					u_FJ024Proc(oModelGCT:GetModel("CN9MASTER"):GetValue("CN9_NUMERO"),.F.,.F.)
					//GEAN - INCLUIR A GRAVAÇÃO DA PWU E ATUALIZAR A P98 AQUI
					
					U_TINCLOGCT(cLogMIGRATOTVS,"Sucesso;Contrato " + cContrato + " migrado corretamente.")
				EndIf

			Else
				aErroModel := oModelGct:GetErrorMessage()
				U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Erro na importação do contrato pós valid, problema no preenchiemnto do modelo do contrato: " + cContrato)
				U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Detalhe do erro: " + aErroModel[4] + " - " + aErroModel[5] + " - " + aErroModel[6] )
			EndIf
		Else
			aErroModel := oModelGct:GetErrorMessage()
			U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Erro na importação do contrato pos setvalue, problema no preenchiemnto do modelo do contrato: " + cContrato)
			U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Detalhe do erro: " + aErroModel[4] + " - " + aErroModel[6] )
		EndIf

	EndIf

	If !Empty(cChaveLock)
		U_GVFUNLOC(2,cChaveLock,"TGCVA032")
	EndIf

	If lModel

		//-----------------------------------------
		// Variaveis para o model TGCVA002
		//-----------------------------------------
		u_A3SATpRv("")
		U_A3STpRev("")
		U_A3SRevis(.F.)
		U_GV002S0S("")
		U_GV002GH3S("")
		U_PGV300GL({})
		U_GV002SOP(0)
		U_GV002GTL( .F. )
		U_GV002GAC({})
		U_GV002GP4({})
		U_GV002GP3({})
		U_GV002SVC(.F.)

		oModelGCT:DeActivate()

	EndIf

	cGerContra		:= ""
	cGerPed			:= ""
	clEmpFat 		:= ""
	clFilFat 		:= ""
	aItenGCT		:= {}
	aRateioAZG		:= {}
	aLinCN9			:= {}
	aLinCNC			:= {}
	aTpPlanGrd		:= {}
	aPedVenCRM		:= {}
	cChaveLock		:= ""
	cIdProcess		:= ""
	cMigInter		:= ""
	_clCtrGer		:= ""
	_clCtrRevGer	:= ""
	cProduto		:= ""
	aCNA			:= {}
	aCNB			:= {}
	aCNC			:= {}
	aAOX			:= {}
	aCN9			:= {}
	aPN0			:= {}
	aPH4			:= {}
	cRetSqlSB1		:= ""
	cRetSqlSA1		:= ""
	cEmpresaGer		:= ""
	cSysImp			:= ""

Return(.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} GV032LdDados
Valida os produtos da proposta, e agrupa pela linha de receita e
 Gera os dados para geração do contrato ou Pedido de Venda

@author Hermes
@since 10/11/2015
@version 1.0
@return ${return}, ${return_description}
/*/
//-------------------------------------------------------------------

Static Function GV032LdDados(cCodCli,cLojaCli,cPropost,cPreRevis,aPedVenCRM,aRateioAZG , aTpPlanGrd , aLinCN9 , aLinCNC ,cLogMIGRATOTVS)

	Local lRet 		:= .T.
	Local aAreaSBM	:= {}
	Local cCodAgrp	:= "" // Codigo Agrupador de integração CRM X Contratos
	Local cNilAgr	:= ""
	Local cCodRotInt:= ""
	Local lGctPedV	:= .T.
	Local nR		:= 0
	//Local nC		:= 0
	Local lNewCN9	:= .T.
	Local cTipPlan	:= ""
	Local aAux		:= {}
	Local aCliPart	:= {}
	Local cCNASAAS	:= "" //98 - Agrupador de linha de receita SAAS para identificar planilhas deste tipo no contrato
	Local lSAAS		:= .F.
	Local nD		:= 0
	Local nPosCont	:= 0

	aAreaSBM	:= SBM->(GetArea())
	cCodAgrp	:= GetMv("TI_AINCRCT")
	cCNASAAS	:= GetNewPar("TI_CNASAAS", "98")

	DbSelectArea("CN9")
	CN9->(dbSetOrder(8))

	SA1->(DbSeek(xFilial("SA1")+cCodCli))

	nPosProd	:= aScan(aCNB[1], {|a| Alltrim(a) == "CNB_PRODUT" })
	nPosCtr		:= aScan(aCNB[1], {|a| Alltrim(a) == "CNB_CONTRA" })
	nPosCn9		:= aScan(aCN9[1], {|a| Alltrim(a) == "CN9_NUMERO" })

	nPosCont	:= aScan(aCNB	, {|x| Alltrim(x[nPosCtr]) == cContrato  })

	If CN9->( dbSeek( xFilial("CN9")+ "CON"+ cCodCli ))
		lNewCN9		:= .F.
	EndIf

	aTpPlanGrd	:= {}
	aLinCN9		:= {}
	aLinCNC		:= {}

	For nD := nPosCont to len(aCNB)

		nX		:= nD
		cFilAnt := Alltrim(aCNB[nD][nPosFilial])

		If Alltrim(aCNB[nD][nPosCtr]) != cContrato
			Exit
		EndIf

		cProduto := aCNB[nD][nPosProd]

		//MONTO O ARRAY DA PLANILHA
		If SB1->( dbSeek(xFilial("SB1") + Alltrim(cProduto) ) )
			If SBM->( dbSeek( xFilial("SBM") + SB1->B1_GRUPO ) )
				If ! Empty(SBM->BM_XLINREC)
					cTipPlan := ""
					lGctPedV := .T.
					lSAAS	 := U_GVFUNSAAS(SB1->B1_GRUPO)
					cTipPlan := U_G32LRPVCV(Iif(lSAAS, cCNASAAS, SBM->BM_XLINREC),@lGctPedV, SBM->BM_XGRPREC )

					//--------------------------------------------------
					// Linha de Receita Gera Pedido
					//--------------------------------------------------
					If !lGctPedV
						U_TINCLOGCT(cLogMIGRATOTVS,"Produto de serviço enviado: " + cProduto)
					ElseIf lGctPedV .And. ! Empty(cTipPlan) // Se for para gerar Contrato, deve ter tipo de planilha
						// Carrega os dados do Contrato
						GV32LdGCT(cCodCli , cLojaCli, cCodAgrp,cNilAgr,cCodRotInt, @aTpPlanGrd,  aRateioAZG , cTipPlan , @aLinCNC , @aCliPart)
					Else
						lRet := .F.
						U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Não foi localizado o tipo de Planilha para a linha de receita " +  Alltrim(SBM->BM_XLINREC))
						Help(" ",1, 'Help','GV032Gprod_07', STR0023+ Alltrim(SBM->BM_XLINREC)+STR0024 , 3, 0 ) //"Não foi localizado o tipo de Planilha para a linha de receita ("###")."
					EndIf
				Else
					lRet := .F.
					U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Não foi informada a linha de receita do Grupo de Produto " + Alltrim(SB1->B1_GRUPO) + ". Verifique o cadastro de Grupo de Produtos")
					Help(" ",1, 'Help','GV032Gprod_03', STR0025+ Alltrim(SB1->B1_GRUPO) +STR0026 , 3, 0 ) //"Não foi informada a linha de receita do Grupo de Produto ("###"). Verifique o cadastro de Grupo de Produtos"
				EndIf
			Else
				lRet := .F.
				U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Grupo de Produto não localizado " + SB1->B1_GRUPO)
				Help(" ",1, 'Help','GV032Gprod_02', STR0027 + Alltrim(SB1->B1_COD) + STR0028 , 3, 0 ) //"Não foi localizado o cadastro do grupo de produtos, do produto ("###") da proposta."
			EndIf
		Else
			U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Produto não localizado: " + cProduto)
		EndIf
	Next nD

	If lRet

		If lNewCN9 // Se for contrato novo

			//--------------------------------------------------
			// Tratamento CN9
			//--------------------------------------------------
			aLinCN9 	:= {}
			G32LInt(@aLinCN9, "CN9", lNewCN9,,nPosCn9)
			aadd(aLinCNC,aClone(aLinCN9))

			//--------------------------------------------------
			// Tratamento CNC
			//--------------------------------------------------
			aLinCNC 	:= {}
			aAux		:= {}
			G32LInt(@aAux,"CNC",,,nPosCCNC) //nPosCNC
			aadd(aLinCNC,aClone(aAux))

		EndIf

		//--------------------------------------------------
		// Tratamento CNC
		//--------------------------------------------------
		If Len(aCNC) > 1

			nCncCli		:= aScan(aCNC[1], {|x| Alltrim(x) == "CNC_CLIENT"})
			nCncDtAtua	:= aScan(aCNC[1], {|x| Alltrim(x) == "CNC_DTATUA"})

			//Se utilizar CNPJ
			If nMvPar10 == 1
				SA1->(DbSetOrder(3))
			EndIf

			For nR := 2 To Len(aCNC)

				If nMvPar10 == 1
					//Se Utilizar CNPJ
					SA1->(MsSeek(xFilial("SA1")+aCNC[nR][nCncCli]))
				Else
					//Se usar codigo oracle
					PMV->(DbSeek(xFilial("PMV")+"000001SA1"+Alltrim(aCNC[nR][nCncCli])))
					SA1->(MsSeek(xFilial("SA1")+Alltrim(PMV->PMV_VAR1)))
				EndIf

				aadd(aLinCNC,{{"CNC","CNC_DTATUA",If(valtype(aCNC[nR][nCncDtAtua])=="D",aCNC[nR][nCncDtAtua],CTOD(aCNC[nR][nCncDtAtua]))} ,;
					{"CNC","CNC_CLIENT",SA1->A1_COD} ,;
					{"CNC","CNC_LOJACL",SA1->A1_LOJA} ,;
					{"CNC","CNC_TIPCLI","04"} ,;
					{"CNC","CNC_INADIM","N"} ,;
					{"CNC","CNC_ATENDE","S"} ,;
					{"CNC","CNC_MSBLQL","2"} ,;
					{"CNC","CNC_MSGNF","2"} ;
					})

			Next nR

			SA1->(DbSetOrder(1))

		EndIf

	EndIf

Return(lRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} GV32LdGCT
Monta o array para a geração do contrato

@author Hermes
@since 24/11/2015
@version 1.0
@param cCodCli, character, (codigo do cliente)
@param cLojaCli, character, (loja do cliente)
@param cCodAgrp, character, (Codigo agrupador)
@param cNilAgr, character, (Nivel agrupador)
@param cCodRotInt, character, (Rotina de integração)
@param aTpPlanGrd, array, (Array de contratos)
@param aRateioAZG, array, (Rateio)
@param cTipPlan, character, (Tipo de Planilha)
@param aLinCNC, array, (Clientes X Contrato)
@param aCliPart, array, (Cliente X Rateio para rateio PHG)
/*/
//-------------------------------------------------------------------
Static Function GV32LdGCT(cCodCli , cLojaCli, cCodAgrp,cNilAgr,cCodRotInt, aTpPlanGrd,  aRateioAZG , cTipPlan , aLinCNC , aCliPart,cLogMIGRATOTVS)

	Local nPTpPlan	:= 0
	//Local nR		:= 0
	Local nC		:= 0
	Local aLinCNB	:= {}
	Local aAux		:= {}
	Local aRatPHG	:= {}
	Local cCmpPrVnc := ""
	Local cPlaGrp	:= ""
	Local nLoop 	:= 0

	SA1->(MsSeek(xFilial("SA1")+cCodCli))

	If ( nPTpPlan := Ascan(aTpPlanGrd, { |x| alltrim(x[1]) == alltrim(cTipPlan) }) ) == 0

		aadd(aTpPlanGrd,{ cTipPlan 	,;	// Tipo da planilha
		{ {}		,;	// Array dados CNA
		{}		,;	// Array dados CNB
		{}		,;	// Array dados PHG
		{}		};	// Array dados PH4
		})

		nPTpPlan := Len(aTpPlanGrd)

	EndIf

	/*
	[1] - Tipo da planilha
	[2] - Array:
	[2][1]  - Array dados CNA
	[2][2]  - Array dados CNB
	[2][3]  - Array dados PHG
	[2][4]  - Array dados PH4
	*/
	//-------

	//--------------------------------------------------
	// Tratamento CNB
	//--------------------------------------------------
	aLinCNB := {}
	G32LInt(@aLinCNB,"CNB",,,nPosCtr)
	aadd(aTpPlanGrd[nPTpPlan][2][2], aClone(aLinCNB) )

	//--------------------------------------------------
	// Tratamento CNA
	//--------------------------------------------------
	If Len(aTpPlanGrd[nPTpPlan][2][1]) == 0
		aAux		:= {}
		G32LInt(@aAux,"CNA", nPTpPlan,,nPosCCNA) //nPosCNA
		aadd(aTpPlanGrd[nPTpPlan][2][1], aClone(aAux) )
	EndIf

	//--------------------------------------------------
	// Tratamento PHG - Rateio
	//--------------------------------------------------
	If Len(aPHG) > 0

		nPosItCnb	:= aScan(aLinCNB,{|x| Alltrim(x[2]) 			== "CNB_PROITN" 					})
		nPosCNBProd	:= aScan(aLinCNB,{|x| Alltrim(x[2]) 			== "CNB_PRODUT" 					})
		nPosCNBContra	:= aScan(aLinCNB,{|x| Alltrim(x[2]) 		== "CNB_CONTRA" 					})
		nPHGProd	:= aScan(aPHG[1],{|x| Alltrim(x)				== "PHG_PRODUT"						})
		nPHGPerRat	:= aScan(aPHG[1],{|x| Alltrim(x)				== "PHG_PERRAT"						})
		nPHGItProp	:= aScan(aPHG[1],{|x| Alltrim(x)				== "PHG_ITEM"						})
		nITMPro		:= aScan(aPHG[1],{|x| Alltrim(x)				== "PHG_ITMPRO"						})
		nPosProp 	:= aScan(aLinCNB,{|x| Alltrim(x[2])				== "CNB_PROPOS"						})
		nPHGCli		:= aScan(aPHG[1],{|x| Alltrim(x)				== "PHG_CLIENT"						})
		nPHGLin		:= aScan(aPHG	,{|x| Alltrim(x[nPHGProd])	== Alltrim(aLinCNB[nPosCNBProd][3])	})

		If nPHGLin > 0

			For nLoop := 1 To Len(aPHG)

				If Alltrim(aPHG[nLoop][nPHGProd]) == Alltrim(aLinCNB[nPosCNBProd][3])

					//Variaveis necessárias para garantir que vou adicionar o rateio na planilha correta.
					cCNASAAS := GetNewPar("TI_CNASAAS", "98")
					lGctPedV := .T.
					lSAAS	 := U_GVFUNSAAS(SB1->B1_GRUPO)

					SA1->(DbSetOrder(3))

					SB1->(DbSeek(xFilial("SB1") + Alltrim(aPHG[nLoop][nPHGProd])))
					SBM->(DbSeek(xFilial("SBM")+Alltrim(SB1->B1_GRUPO)))
					cPlaGrp := U_G32LRPVCV(Iif(lSAAS, cCNASAAS, SBM->BM_XLINREC),@lGctPedV, SBM->BM_XGRPREC )

					SA1->(MsSeek(xFilial("SA1")+aPHG[nLoop][nPHGCli]))

					nRecPos := aScan(aTpPlanGrd,{|x| Alltrim(x[1]) == cPlaGrp})

					If cPlaGrp == aTpPlanGrd[nRecPos][1]

						aRatPHG := {}
						aadd(aRatPHG,{				SA1->A1_COD						,;	// Cliente
						SA1->A1_LOJA					,;	// Loja
						SB1->B1_COD						,;	// Produto
						aPHG[nLoop][nPHGItProp]		,;	//Item Prop.
						cProposta						,;	// Proposta
						aPHG[nLoop][nPHGPerRat]		})	// Percentual de Rateio

						//--------------------------------------------------
						// Adiciona os Rateio
						//--------------------------------------------------
						aadd(aTpPlanGrd[nPTpPlan][2][3], aClone(aRatPHG) )

					EndIf

					SA1->(DbSetOrder(1))

				EndIf

			Next nLoop

		EndIf

	EndIf

	//--------------------------------------------------
	// Tratamento PH4 - Carencia
	//--------------------------------------------------
	//Se a competencia do primeiro vencimento for maior que a competência atual, gera Carencia

	If len(aPH4) > 0

		aAreaSA1 := SA1->(GetArea())

		nPosProp		:= aScan(aLinCNB,{|x| Alltrim(x[2]) == "CNB_PROPOS" 			})
		nPosCNBPRODUT	:= aScan(aLinCNB,{|x| Alltrim(x[2]) == "CNB_PRODUT" 			})
		nPH4ItCnb		:= aScan(aLinCNB,{|x| Alltrim(x[2]) == "CNB_PROITN"	 			})
		nPH4Prod		:= aScan(aPH4[1],{|x| Alltrim(x) 	== "PH4_PRODUT" 	 		})
		nPosCmpIni		:= aScan(aPH4[1],{|x| Alltrim(x) 	== "PH4_CMPINI" 	 		})
		nPosCmpFim		:= aScan(aPH4[1],{|x| Alltrim(x) 	== "PH4_CMPFIM" 	 		})
		nPH4ItSeq		:= aScan(aPH4[1],{|x| Alltrim(x) 	== "PH4_ITSEQ" 	 			})
		nPH4Item		:= aScan(aPH4[1],{|x| Alltrim(x) 	== "PH4_ITEM" 	 			})
		nPPDes			:= aScan(aPH4[1],{|x| Alltrim(x) 	== "PH4_PERDES" 			})
		nPVlDes			:= aScan(aPH4[1],{|x| Alltrim(x) 	== "PH4_VLRDES" 			})
		nPMotivo		:= aScan(aPH4[1],{|x| Alltrim(x) 	== "PH4_MOTBC" 				})
		nPTipo			:= aScan(aPH4[1],{|x| Alltrim(x) 	== "PH4_TIPO" 				})

		nPClient		:= aScan(aPH4[1],{|x| Alltrim(x) 	== "PH4_CLIENT" 				})
		nPLoja			:= aScan(aPH4[1],{|x| Alltrim(x) 	== "PH4_LOJA" 				})

		//nPosPH4			:= aScan(aPH4,{|x| Alltrim(x[4]) 	== Alltrim(SB1->B1_COD) 	})
		nPosPH4			:= aScan(aPH4,{|x| Alltrim(x[4]) 	== Alltrim(aLinCNB[nPosCNBPRODUT][3]) 	})

		//For nC := 2 to len(aPH4)
		If nPosPH4 > 0
			For nC := nPosPH4 to len(aPH4)

				cCmpPrVnc	:= Alltrim(aPH4[nC][nPosCmpIni])
				cDtCmpFim	:= Alltrim(aPH4[nC][nPosCmpFim])


				SA1->(dbSetOrder(3))
				If SA1->(dbSeek( xFilial("SA1") + Alltrim(aPH4[nC][nPClient]) ))
					cCliPH4 := SA1->A1_COD
					cLojaPH4 := SA1->A1_LOJA
				Else
					cCliPH4 := cCodCli
					cLojaPH4 := "00"
				EndIf


				aAux:={}

				If Alltrim(aLinCNB[nPosCNBPRODUT][3]) == Alltrim(aPH4[nC][nPH4Prod]) .AND. Empty(aPH4[nC][Len(aPH4[nC])])
					aPH4[nC][Len(aPH4[nC])] := "X"
					aadd(aAux,{	aPH4[nC][nPH4Prod]					,;	// 1-Produto
					cProposta  							,;	// 2-Proposta
					cCmpPrVnc  							,;	// 3-Competencia Final
					cDtCmpFim  							,;	// 4-Competencia Inicial
					cCmpPrVnc  							,;	// 5-Competencia Final de Carencia
					aPH4[nC][nPH4ItSeq]					,;	// 6-Item da PH4
					Iif(nPPDes==0,0,aPH4[nC][nPPDes])	,;	// 7-% de Desconto
					Iif(nPVlDes==0,0,aPH4[nC][nPVlDes])	,;	// 8-Valor do Desconto
					aPH4[nC][nPMotivo]					,;	//9- Motivo Bonificacao
					aPH4[nC][nPTipo]					,;
						cCliPH4								,;
						cLojaPH4							})	//10 - Tipo

					aadd(aTpPlanGrd[nPTpPlan][2][4], aClone(aAux) )

				EndIf

			Next nC
		EndIf

		RestArea(aAreaSA1)

	EndIf

Return

//-------------------------------------------------------------------------
/*/{Protheus.doc} GV32GrvCrt
Gravação do modelo do Contrato
@author Hermes
@since 06/06/2016
@version 1.0
@param oModel, objeto, Modelo do Contrato
@param cRegGerado, character, Numero do contrato Gerado
@param nTpManut, numérico, Tipo de Manutenção
@return lRet, se o contrato foi gravado
/*/
//-------------------------------------------------------------------------
Static Function GV32GrvCrt(oModel, cRegGerado , nTpManut , _clCtrGer , _clCtrRevGer ,cLogMIGRATOTVS)

	Local lRet			:= .T.
	// Local _cContraNew	:= ""
	// Local _cRevNew		:= ""
	// Local aErro			:= {}

	// Atualizar Variavel Static do cronograma financeiro
	U_GV002SVC(.T.)

	FWMonitorMsg("Gravando Contrato") //"Gravando Contrato"

	oModel:VldData()
	lRet := oModel:CommitData()

	//Gravo a PN1 para caso precisar rodar novamente o programa.
	If lRet

		PN1->(RecLock("PN1",.T.))

		PN1->PN1_CINTEG	:= cEmpresaGer
		PN1->PN1_ALIAS	:= "CN9"
		PN1->PN1_CHVFUL	:= cContrato
		PN1->PN1_TPEXIM	:= 'I' //cSysImp
		PN1->PN1_CPOCHV	:= ""//IIf(MV_PAR11 = 2, "", "Royalt")

		PN1->(MsUnlock())

	EndIf

	cRegGerado := STR0039+ Alltrim(oModel:GetModel("CN9MASTER"):GetValue("CN9_NUMERO"))+" / "+ Alltrim(oModel:GetModel("CN9MASTER"):GetValue("CN9_REVISA")) //"Contrato/Revisão: "

	_clCtrGer 	:= oModel:GetModel("CN9MASTER"):GetValue("CN9_NUMERO")
	_clCtrRevGer:= oModel:GetModel("CN9MASTER"):GetValue("CN9_REVISA")

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} G32LInt
Load de dados para integração, conforme cadastro regra de integração

@author Hermes
@since 10/11/2015
@version 1.0
@return ${return}, ${return_description}
/*/
//-------------------------------------------------------------------
Static Function G32LInt(aLinAux, cTabela, nPTpPlan, lNewCN9,nPosCta)

	Local uMacro	:= Nil
	Local nPos		:= 0
	Local nY		:= 0
	Local nPosCont	:= 0

	Default lNewCN9	:= .F.

	nPosCont := aScan(&("a" + cTabela + ""), {|x| Alltrim(x[nPosCta]) == cContrato  })

	//Forço o posicionamento da SA1
	If cTabela $ "CNC/CNA/CN9"
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+cCodCli))
	EndiF

	If nPosCont == 0
		cTeste := ""
	EndIf

	For nY := 1 to len(aAOX)

		If aAOX[nY][1] == cTabela .And. cTabela == "CNB"

			If Empty(aAOX[nY][3])

				nPos	:= ascan(&("a"+cTabela+ "[1]"), { |x| Alltrim(x) == Alltrim(aAOX[nY][2]) })

				If nPos > 0
					uMacro	:= "a"+cTabela+"[nX][nPos]"

					If aAOX[nY][4] == "D"
						/*If nTipoData == 1 //"1 = AAAAMMDD","2 = DD/MM/AA","3 = DD/MM/AAAA","4 = DDMMAAAA"
							uMacro := "STOD(Alltrim("+uMacro+"))"
						ElseIf nTipoData == 2
							uMacro := "CTOD(Left(Alltrim("+uMacro+"),2)" + "/" + "Substr(Alltrim("+uMacro+"),4,2)" + "/" + "Right(Alltrim("+uMacro+"),2))"
						ElseIf nTipoData == 3
							uMacro := "STOD(Right(Alltrim("+uMacro+"),4)" + "/"+ "Substr(Alltrim("+uMacro+"),4,2)" + "/"+ "Left(Alltrim("+uMacro+"),2))"
						Else
							uMacro := "STOD(Right(Alltrim("+uMacro+"),4)" + "/"+ "Substr(Alltrim("+uMacro+"),3,2)" + "/"+ "Left(Alltrim("+uMacro+"),2))"
						EndIf*/

						If valtype(&(uMacro)) == "C"
							uMacro := ctod(&(uMacro))
						ElseIf valtype(&(uMacro)) == "S"
							uMacro := stod(&(uMacro))
						Else 
							uMacro := &(uMacro)
						EndIF 

						//uMacro := uMacro
						
					ElseIf aAOX[nY][4] == "N"
						uMacro := "Valtype("+uMacro+")"
						If &(uMacro) <> "N"
							uMacro := "a"+cTabela+"[nX][nPos]"
							uMacro := "Val("+uMacro+")"
							uMacro := &(uMacro)
						Else
							uMacro := "a"+cTabela+"[nX][nPos]"
							uMacro := "("+uMacro+")"
							uMacro := &(uMacro)
						EndIf
					Else
						uMacro := "Valtype("+uMacro+")"
						If &(uMacro) <> "C"
							uMacro := "a"+cTabela+"[nX][nPos]"
							uMacro := "cvaltochar("+uMacro+")"
						Else
							uMacro := "a"+cTabela+"[nX][nPos]"
						EndIf
						uMacro := &(uMacro)
						uMacro := Alltrim(uMacro)
					EndIf

					Aadd(aLinAux,{ 	aAOX[nY][1],;
						aAOX[nY][2] ,;
						uMacro})
				EndIf

			ElseIf !( lNewCN9 .And.  Alltrim(aAOX[nY][2]) $ "CN9_TIPREV|CN9_JUSTIF")

				uMacro := If(aAOX[nY][4]=="C",cvaltochar(&(aAOX[nY][3])),&(aAOX[nY][3]))

				Aadd(aLinAux,{ 	aAOX[nY][1],;
					aAOX[nY][2] ,;
					uMacro})

			EndIf

		EndIf

		If aAOX[nY][1] == cTabela .And. cTabela $ "CNA/CNC/CN9"

			If Empty(aAOX[nY][3])

				nPos	:= ascan(&("a"+cTabela+ "[1]"), { |x| Alltrim(x) == Alltrim(aAOX[nY][2]) })

				If nPos == 0 .or. nPosCont == 0
					Loop
				EndIf

				uMacro	:= "a"+cTabela+"[nPosCont][nPos]"

				If aAOX[nY][4] == "D"
					If nTipoData == 1//"1 = AAAAMMDD","2 = DD/MM/AA","3 = DD/MM/AAAA","4 = DDMMAAAA"
						uMacro := "Valtype("+uMacro+")"
						If &(uMacro) <> "D"
							uMacro	:= "a"+cTabela+"[nPosCont][nPos]"
							uMacro := "CTOD("+uMacro+")"
						Else
							uMacro := "STOD(Alltrim("+uMacro+"))"
						EndIF
					ElseIf nTipoData == 2
						uMacro := "CTOD(Left(Alltrim("+uMacro+"),2)" + "/" + "Substr(Alltrim("+uMacro+"),4,2)" + "/" + "Right(Alltrim("+uMacro+"),2))"
					ElseIf nTipoData == 3
						uMacro := "STOD(Right(Alltrim("+uMacro+"),4)" + "/"+ "Substr(Alltrim("+uMacro+"),4,2)" + "/"+ "Left(Alltrim("+uMacro+"),2))"
					Else
						uMacro := "STOD(Right(Alltrim("+uMacro+"),4)" + "/"+ "Substr(Alltrim("+uMacro+"),3,2)" + "/"+ "Left(Alltrim("+uMacro+"),2))"
					EndIf
					uMacro := &(uMacro)
					//uMacro := "CTOD("+uMacro+")"
					//uMacro := &(uMacro)
				ElseIf aAOX[nY][4] == "N"
						/* uMacro := "Val("+uMacro+")"
						uMacro := &(uMacro) */
						uMacro := "Valtype("+uMacro+")"
						If &(uMacro) <> "N"
							uMacro := "a"+cTabela+"[nPosCont][nPos]"
							uMacro := "Val("+uMacro+")"
							uMacro := &(uMacro)
						Else 
							uMacro := "a"+cTabela+"[nPosCont][nPos]"
							uMacro := "("+uMacro+")"
							uMacro := &(uMacro)
						EndIf 
					Else
						uMacro := &(uMacro)
						uMacro := Alltrim(uMacro)
					EndIf

					Aadd(aLinAux,{ 	aAOX[nY][1],;
									aAOX[nY][2] ,;
									uMacro})

			ElseIf !( lNewCN9 .And.  Alltrim(aAOX[nY][2]) $ "CN9_TIPREV|CN9_JUSTIF")

				uMacro := &(aAOX[nY][3])
				Aadd(aLinAux,{ 	aAOX[nY][1],;
								aAOX[nY][2] ,;
								uMacro})

			EndIf

		EndIf

	Next nY

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GV032Gct
Gera o Contrato

@author Hermes
@since 10/11/2015
@version 1.0
@return ${return}, ${return_description}
/*/
//-------------------------------------------------------------------
Static Function GV032Gct( oModel, cCodCli , cLojaCli ,aTpPlanGrd,  aLinCN9 , aLinCNC , cProposta , cRevPropos , cRegGerado , clEmpFat , clFilFat ,nTpManut  , cChaveLock ,cLogMIGRATOTVS)
Local lRet 		:= .T.
Local lAux		:= .T.
Local aAreaCN9	:= {}
Local oMoldCN9	:= Nil
Local oMolAux	:= Nil
Local oObjCNB	:= Nil
Local cJustif	:= "Migracao GCT " + Alltrim(cProposta) + " Revisao: "+ Alltrim(cRevPropos) //"Integração CRM X GCT, gerada pela proposta: "###", revisão: "
Local nI		:= 0
Local nC		:= 0
Local nX		:= 0
Local alFields	:= {}
Local cContra	:= ""
Local aCliCnc	:= {}
Local aLinCNA	:= {}
Local aLinCNB	:= {}
Local aLinPHG	:= {}
Local aLinPH4	:= {}
Local nPosCli	:= 0
Local nPosLj	:= 0
Local nLinhaAtu	:= 0
Local nNewLine	:= 0
Local cSeqPh4	:= ""
Local cSeqCNB	:= ""
Local cSeqCNA	:= ""
// Local cRevCon	:= ""
Local cAuxErro	:= ""
Local cCodCar	:= "" // Codigo Motivo Carencia
Local cCodManGCT:= "" // Codigo motivo de manutenção do contrato, quando for manutenção do contrato for integração CRM
Local nPsa		:= 0
Local aDetPHG	:= {}
Local nNewPlan	:= .F.
// Local _aProdCorp := {}
// Local oMoldPH3 := Nil
// Local _aGrpCorp := {}
// Local _aProduto := {}
// Local _nExistC := 0
// Local _nExistCN := 0
// Local nCont := 0
// Local nCont1 := 0
// Local nContProc := 0
// Local aProdProc := {}
// Local lUsadoCorp := .F.
// Local lCorpFound := .F.
Local cObsCan := ""
// Local cPropRev := ""
Local cMotCan := ""
Local lValidCorp := .T.
// Local nLineIni := 0
// Local lCancel := .T.
Local dDtItem
// Local cCompAtu := ""
Local nPosLinCNA := 0
Local cDtCmpFim := ""
// Local cCompCanc := ""
// Local aCampos	:= {}
Local nA
Local oMolPHH	:= Nil
Local cRet		:= ""
Local aAuxPN0	:= {}
Local cObs		:= ""

Private aCliBkp	:=	{}
Default nTpManut	:= 3
Default cChaveLock	:=""

aAreaCN9	:= CN9->(GetArea())
cContra		:= Padr("CON"+ cCodCli, TamSx3("CN9_NUMERO")[1])
cCodCar		:= GETMV("TI_CMOTCAR") // Codigo Motivo Carencia
cCodManGCT	:= GETMV("TI_CMNTINT")
cObsCan		:= GETMV("TI_COOBSCA",," Cancelamento por geração de incremento/comprovação de métricas do Corporativo ")
cMotCan		:= GETMV("TI_COMOTCA",,"230")
lValidCorp	:= GETMV("TI_VLDCORP",,.T.)
dDtItem		:= cTod("  /  /    ")
cDtCmpFim	:= DtoS(LastDay(dDataBase) + 1)

nTpManut	:= 3
cChaveLock	:=""

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+cCodCli))

SB1->(DbSetOrder(1))

If xGVCMPOP() // Competencia em aberto

	dbSelectArea("CN9")
	CN9->(dbSetOrder(8)) // CN9_FILIAL+CN9_NUMERO+CN9_REVATU
	If CN9->( dbSeek( xFilial("CN9")+ cContra  ))

		If CN9->CN9_SITUAC == DEF_SVIGE //contrato Vigente
			nTpManut	:= 9
		ElseIf CN9->CN9_SITUAC == DEF_SELAB
			nTpManut	:= 4
		Else
			lRet := .F.
			nTpManut := 0
			U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";XXXSituação do contrato não permite integração com o CRM neste momento. Contrato deve estar vigente ou em elaboração (CN9_SITUAC).")
			Help(" ",1, 'Help','GV032GCT_02',"Situação do contrato não permite integração com o CRM neste momento. Contrato deve estar vigente ou em elaboração.", 3, 0 )
		EndIf

		If lRet
			FWMonitorMsg("Excluindo medições em aberto")
			lRet := U_GV027Exc(CN9->CN9_NUMERO,CN9->CN9_REVISA,,,,.T.)

			If lRet
				cChaveLock:= "CN9"+xFilial("CN9")+CN9->CN9_NUMERO
				lRet := U_GVFUNLOC(1,cChaveLock,"TGCVA032")
			EndIf
		EndIf

	EndIf

	If lRet

		If nTpManut == 9 .Or. CN9->CN9_SITUAC == DEF_SREVS
			U_GCTXSET(.T.)
			U_A3SRevis(.F.)
			U_GV002SVC(.T.)
			U_GV002SOP(OP_COPIA)

		Else
			U_GV002SOP(MODEL_OPERATION_UPDATE)
		EndIf

		aMIGRATOTVS := {}
		CNC->(dbSetOrder(5))
		If CNC->( dbSeek(xFilial("CNC") + CN9->CN9_NUMERO + CN9->CN9_REVISA + "01" ) )
			aMIGRATOTVS := { CNC->CNC_CODIGO , CNC->CNC_LOJA }
		Else
			aMIGRATOTVS := { SA1->A1_COD , SA1->A1_LOJA }
		EndIf

		FWMonitorMsg("Carregango modelo MVC") //

		If nTpManut == 9 .Or. CN9->CN9_SITUAC == DEF_SREVS
			U_A3STpRev(DEF_REV_RENOV)
		EndIf

		If nTpManut <> 9
			// Seta o cliente e loja, que será o cliente principal do contrato
			U_PSV300CP({cCodCli , cLojaCli})
		EndIf

		If nTpManut == 4
			oModel:SetOperation(MODEL_OPERATION_UPDATE)
		Else
			oModel:SetOperation(MODEL_OPERATION_INSERT)
		EndIf

		FWMonitorMsg("Ativando modelo") //
		aCliBkp := {cCodCli,cLojaCli}
		
		lRet := oModel:Activate( IIF( nTpManut == 9,.T.,) )

 		If lRet

			//-------------------------
			// Tratamento CN9
			//-------------------------
			FWMonitorMsg("Atualizando cabeçalho do contrato") //
			oMoldCN9:= oModel:GetModel("CN9MASTER")

			If nTpManut == 9
				oMoldCN9:SetValue( "CN9_TIPREV", U_GCTXTREV() )
				oMoldCN9:SetValue( "CN9_JUSTIF", cJustif )
				oMoldCN9:SetValue( "CN9_AUDITA", IIf( Empty( oMoldCN9:GetValue( "CN9_AUDITA" ) ), CriaVar( "CN9_AUDITA", .T.  ), oMoldCN9:GetValue( "CN9_AUDITA" ) ) )
				//CONDIÇÃO PAGTO (FIXAR)
				oMoldCN9:SetValue( "CN9_CONDPG", "F01" )
			Else
				MtBCMod(oModel , {oMoldCN9:CID} , {||.T.} )
				alFields 	:= oMoldCN9:GetStruct():GetFields()

				For nI := 1 To Len( aLinCN9 )
					// Verifica se os campos passados existem na estrutura do cabeçalho
					If   Alltrim(substr(alFields[1][3],1,3)) == AllTrim( aLinCN9[nI][1] )
						If AllTrim(aLinCN9[nI][2]) == "CN9_CONDPG"
							If !( lAux := oModel:SetValue( 'CN9MASTER', aLinCN9[nI][2], "F01" ) )
								lRet := .F.
								Exit
							EndIf
						Else
							If !( lAux := oModel:SetValue( 'CN9MASTER', aLinCN9[nI][2], IIF( ValType(aLinCN9[nI][3])<>"U" , aLinCN9[nI][3] , CriaVar(aLinCN9[nI][2]) )  ) )
								lRet := .F.
								Exit
							EndIf
						EndIf
					EndIf
				Next nI

			EndIf

			//-------------------------
			// Tratamento PHH
			//-------------------------
			If lRet .And. Len(aPHH) > 0

				oMolPHH	:= oModel:GetModel("PHHDETAIL")

				CNTA300BlMd(oMolPHH, .F.)

				cItSeq	:= "01"

				For nX := 2 to len(aPHH)
					nCpo := 1

					For nC := 1 to len(aPHH[nX])

						If Alltrim(aPHH[1][nCpo]) $ "PHH_CONTRT/PHH_SEQ/"
							nCpo++
							Loop
						EndIf

						If TamSx3(aPHH[1][nCpo])[3] == "D"
							aPHH[nX][nCPO] := CTOD(aPHH[nX][nCPO])
						ElseIf TamSx3(aPHH[1][nCpo])[3] == "N"
							aPHH[nX][nCPO] := Val(aPHH[nX][nCPO])
						EndIf

						lRet := oMolPHH:LoadValue(Alltrim(aPHH[1][nCpo]), aPHH[nX][nCPO])

						If !lRet
							cAuxErro += "Erro no preenchimento da PHH."
							Exit
						EndIf

						nCpo++

					Next nC

					//Verificação na adição de novas linhas, caso necessário.
					If nX < Len(aPHH)

						cItSeq := Soma1(cItSeq)

						nNewPHH := oMolPHH:AddLine()

						If nNewPHH == 1 .And. nX < Len(aPHH)
							cAuxErro += "Erro ao adicionar nova linha na PHH."
							Exit
						EndIf

					EndIf

					If !lRet
						Exit
					EndIf

				Next nX

			EndIf

			//-------------------------
			// Tratamento CNC
			//-------------------------
			If lRet

				FWMonitorMsg("Atualizando Clientes do contrato") //

				nI := 0
				oMolAux	:= oModel:GetModel('CNCDETAIL')
				alFields:= oMolAux:GetStruct():GetFields()

				For nI	:= 1 To Len(aLinCNC)

					nPosCli	:= ascan(aLinCNC[nI], { |x| x[2] == "CNC_CLIENT" })
					nPosLj	:= ascan(aLinCNC[nI], { |x| x[2] == "CNC_LOJACL" })
					aCliCnc := {}
					If nPosCli > 0 .And. nPosLj > 0
						aadd(aCliCnc,{"CNC_CLIENT", aLinCNC[nI][nPosCli][3] })
						aadd(aCliCnc,{"CNC_LOJACL", aLinCNC[nI][nPosLj][3] })

						If ! oMolAux:SeekLine(aCliCnc) .And. !Empty(aLinCNC[nI][nPosCli][3])// Verica se não existe o cliente

							CNTA300BlMd(oMolAux,.F.)
							MtBCMod(oModel , {oMolAux:CID} , {||.T.} )

							If !Empty(oMolAux:GetValue("CNC_CLIENT"))

								nLinhaAtu := oMolAux:GetLine()
								If( nNewLine := oMolAux:AddLine() ) == nLinhaAtu
									lRet := .F.
								EndIf
								oMolAux:GoLine( nNewLine )
							EndIf

							If lRet

								For nC := 1 To Len(aLinCNC[nI])

									If TamSx3(aLinCNC[nI][nC][2])[3] == "D"
										If ValType(aLinCNC[nI][nC][3])=="D"
											dData := aLinCNC[nI][nC][3]
										Else
											If ValType(aLinCNC[nI][nC][3] )<>"U"
												dData := StoD(aLinCNC[nI][nC][3])
											Else
												dData := Criavar(aLinCNC[nI][nC][2])
											EndIf
										EndIf
										lAux := oMolAux:SetValue( aLinCNC[nI][nC][2], dData )
									Else
										lAux := oMolAux:SetValue( aLinCNC[nI][nC][2], IIF( ValType(aLinCNC[nI][nC][3] )<>"U", aLinCNC[nI][nC][3] , Criavar(aLinCNC[nI][nC][2]) ) )
									EndIf

									If !lAux
										lRet := .F.
										Exit
									EndIf
								Next nC
							EndIf
						EndIf
					EndIf
				Next nI
			EndIf

			cSeqCNA	:= StrZero(0,TamSx3("CNA_NUMERO")[1])
			For nC := 1 To Len(aTpPlanGrd)

				//-------------------------
				// Tratamento CNA
				//-------------------------
				If lRet

					FWMonitorMsg("Atualizando planilhas do contrato") //

					oMolAux := oModel:GetModel('CNADETAIL')
					alFields:= oMolAux:GetStruct():GetFields()
					nNewPlan:= .F.

					MtBCMod(oModel , {oMolAux:CID} , {||.T.} )

					// Ve se existe o Tipo da Planilha no Contrato,  se não tiver inclui
					nPosLinCNA := 0
					nPosLinCNA := U_TGVFndMVC( oMolAux ,  {{"CNA_TIPPLA",aTpPlanGrd[nC][1]}}   , ,  )

					If nPosLinCNA <> 0
						oMolAux:GoLine(nPosLinCNA)
					Else
						aLinCNA := aClone(aTpPlanGrd[nC][2][1][1])

						CNTA300BlMd(oMolAux,.F.)
						MtBCMod(oModel , {oMolAux:CID} , {||.T.} )

						If !oMolAux:IsEmpty() .And. !Empty(oMolAux:GetValue("CNA_NUMERO"))

							oMolAux:GoLine(oMolAux:Length())
							cSeqCNA := oMolAux:GetValue("CNA_NUMERO")

							nLinhaAtu := oMolAux:GetLine()
							If( nNewLine := oMolAux:AddLine() ) == nLinhaAtu
								lRet := .F.
							EndIf
							oMolAux:GoLine( nNewLine )
							nNewPlan := .T.
						Endif

						If Empty(oMolAux:GetValue("CNA_NUMERO"))
							lRet := oMolAux:SetValue("CNA_NUMERO",Soma1(cSeqCNA))
						EndIf

						If lRet

							If !Empty(aLinCNA)

								nI := 0

								For nI := 1 To Len(alFields)
									nPsa := ascan(aLinCNA,{ |x| alltrim(x[2]) == alltrim(alFields[nI][3]) } )
									If nPsa > 0
										MtBCMod(oModel , {oMolAux:CID} , {||.T.} )

										If Alltrim(aLinCNA[nPsa][2]) == "CNA_TIPPLA"
											aLinCNA[nPsa][3] := aTpPlanGrd[nC][1]
										ElseIf Alltrim(aLinCNA[nPsa][2]) == "CNA_DTINI"
											If aLinCNA[nPsa][3] < oModel:GetModel("CN9MASTER"):GetValue("CN9_DTINIC")
												oModel:GetModel("CN9MASTER"):LoadValue("CN9_DTINIC", aLinCNA[nPsa][3] )
												oModel:GetModel("CN9MASTER"):LoadValue("CN9_ASSINA", aLinCNA[nPsa][3] )
												oModel:GetModel("CN9MASTER"):LoadValue("CN9_DTASSI", aLinCNA[nPsa][3] )
											EndIf
										ElseIf Alltrim(aLinCNA[nPsa][2]) == "CNA_CLIENT"
											SA1->(MsSeek(xFilial("SA1")+aLinCNA[nPsa][3]))
										EndIf

										lAux := oMolAux:SetValue(  aLinCNA[nPsa][2], IIF( ValType(aLinCNA[nPsa][3] )<>"U", aLinCNA[nPsa][3], Criavar(aLinCNA[nPsa][2])) )

										If !lAux
											lRet := .F.
											Exit
										EndIf
									Endif
								Next nI

							Endif

						EndIf

					EndIf

				EndIf

				//-------------------------
				// Tratamento CNB
				//-------------------------
				If lRet
					oObjCNB	:= oModel:GetModel('CNBDETAIL')
					aLinCNB := aClone(aTpPlanGrd[nC][2][2])
					alFields:= oObjCNB:GetStruct():GetFields()
					cSeqCNB	:= StrZero(0,TamSx3("CNB_ITEM")[1])
					nLinhaAtu := 0

					For nX := 1 To Len(aLinCNB)

						//PtInternal(1, "Atualizando itens [" + Alltrim(Str(nX)) + "] de [" + Alltrim(Str(Len(aLinCNB))) +"]") //"Atualizando itens do contrato. ["###"]de["

						cPtInternal := ""
						cPtInternal += "Planilha: " + cValToChar(nC) + "/" + cValToChar(Len(aTpPlanGrd))
						cPtInternal += " - "
						cPtInternal += "Itens: " + cValToChar(nX) + "/" + cValToChar(Len(aLinCNB))

						FWMonitorMsg(cPtInternal)

						CNTA300BlMd(oObjCNB,.F.)

						If !oObjCNB:IsEmpty()

							oObjCNB:GoLine(oObjCNB:Length())
							cSeqCNB := oObjCNB:GetValue("CNB_ITEM")

							If( nNewLine := oObjCNB:AddLine() ) == nLinhaAtu .And. nLinhaAtu > 0
								lRet := .F.
								cAuxErro += "Produto: "  + Alltrim(oObjCNB:GetValue("CNB_PRODUT")) //" - Produto: "
							EndIf
							oObjCNB:GoLine( nNewLine )
						Else
							If nNewPlan
								oObjCNB:ClearData()
							Endif
						Endif

						If lRet

							If Empty(oObjCNB:GetValue("CNB_ITEM"))
								CNTA300BlMd(oObjCNB,.F.)
								MtBCMod(oModel ,{ {oObjCNB:CID,{"CNB_ITEM"}} }, {||.T.} , '2' )
								lRet := oObjCNB:SetValue("CNB_ITEM",Soma1(cSeqCNB))
								If !lRet
									cAuxErro += "Erro ao inserir nova linha"  + Alltrim(cSeqCNB) //" - Erro ao inserir a nova linha: "
									Exit
								EndIf
							EndIf

							AADD(aLinCNB[nX],{"CNB","CNB_ITEM", oObjCNB:GetValue("CNB_ITEM") })
							AADD(aLinCNB[nX],{"CNA","CNA_NUMERO", oModel:GetModel("CNADETAIL"):GetValue("CNA_NUMERO") })

							If !Empty(aLinCNB[nX])

								nI := 0

								For nI := 1 To Len(alFields)
									nPsa := ascan(aLinCNB[nX],{ |x,y| alltrim(x[2]) == alltrim(alFields[nI][3]) } )

									If nPsa > 0
										MtBCMod(oModel ,{ {oObjCNB:CID,{Alltrim(aLinCNB[nX][nPsa][2])} } }, {||.T.} ,'2')

										MtBCMod(oModel , {oMolAux:CID} , {||.T.} )

										If aLinCNB[nX][nPsa][2] == "CNB_PRODUT"
											MtBCMod(oModel ,{ {oObjCNB:CID,{"BM_FLGREAJ"} }}, {||.T.} ,'2')
											MtBCMod(oModel ,{ {oObjCNB:CID,{"BM_DESC"} } }	, {||.T.} ,'2')
											MtBCMod(oModel ,{ {oObjCNB:CID,{"BM_GRUPO"} } }	, {||.T.} ,'2')
											MtBCMod(oModel ,{ {oObjCNB:CID,{"CNB_NUMERO"} }}, {||.T.} ,'2')
										ElseIf aLinCNB[nX][nPsa][2] ==  "CNB_IMPOST"
											MtBCMod(oModel ,{ {oObjCNB:CID,{"CNB_DESMTR"} }}, {||.T.} ,'2')
										EndIf

										If aLinCNB[nX][nPsa][2] == "CNB_STATRM"
											MtBCMod(oModel ,{ {oObjCNB:CID,{"CNB_STATRM"} }}, {||.T.} ,'2')
										EndIf

										If Alltrim(aLinCNB[nX][nPsa][2]) == "CNB_ITEM"
											aLinCNB[nX][nPsa][3] := oObjCNB:GetValue("CNB_ITEM")
										EndIf

										If Alltrim(aLinCNB[nX][nPsa][2]) == "CNB_ANTIMP"
											aLinCNB[nX][nPsa][3] := "1"
											oObjCNB:SetValue(  aLinCNB[nX][nPsa][2], IIF( ValType(aLinCNB[nX][nPsa][3] )<>"U" ,aLinCNB[nX][nPsa][3] , CriaVar(aLinCNB[nX][nPsa][2] )) )
										EndIf

										//Doc Entregue (CNB_DOCENT)
										If Alltrim(aLinCNB[nX][nPsa][2]) == "CNB_DOCENT"
											aLinCNB[nX][nPsa][3] := "N"
											oObjCNB:SetValue(  aLinCNB[nX][nPsa][2], IIF( ValType(aLinCNB[nX][nPsa][3] )<>"U" ,aLinCNB[nX][nPsa][3] , CriaVar(aLinCNB[nX][nPsa][2] )) )
										EndIf

										If Alltrim(aLinCNB[nX][nPsa][2]) == "CNB_PROPOS"
											//aLinCNB[nX][nPsa][3] := cProposta
											oObjCNB:SetValue(  aLinCNB[nX][nPsa][2], IIF( ValType(aLinCNB[nX][nPsa][3] )<>"U" ,aLinCNB[nX][nPsa][3] , CriaVar(aLinCNB[nX][nPsa][2] )) )
										EndIf

										If Alltrim(aLinCNB[nX][nPsa][2]) == "CNB_MODORJ"
											aLinCNB[nX][nPsa][3] := "1"
											oObjCNB:SetValue(  aLinCNB[nX][nPsa][2], IIF( ValType(aLinCNB[nX][nPsa][3] )<>"U" ,aLinCNB[nX][nPsa][3] , CriaVar(aLinCNB[nX][nPsa][2] )) )
										EndIf

										If AllTrim( aLinCNB[nX][nPsa][2] ) == "CNB_VIGINI"
											dDtAux := aLinCNB[nX][nPsa][3]
										EndIf

										If AllTrim( aLinCNB[nX][nPsa][2] ) == "CNB_OBSERV"
											cObs := SubStr( aLinCNB[nX][nPsa][3],10,6 )
										EndIf

										If Alltrim(aLinCNB[nX][nPsa][2]) $ "CNB_STATRM/CNB_INDICE"
											aLinCNB[nX][nPsa][3] := StrZero(Val(aLinCNB[nX][nPsa][3]),3)
										ElseIf Alltrim(aLinCNB[nX][nPsa][2]) $ "CNB_UNINEG"
											aLinCNB[nX][nPsa][3] := StrZero(Val(aLinCNB[nX][nPsa][3]),11)
										ElseIf Alltrim(aLinCNB[nX][nPsa][2]) $ "CNB_GRUPO"
											aLinCNB[nX][nPsa][3] := StrZero(Val(aLinCNB[nX][nPsa][3]),2)
										EndIf

										If Alltrim(aLinCNB[nX][nPsa][2]) $ "CNB_STATRM/CNB_SITUAC/CNB_ATIVO/CNB_FLREAJ"
											lAux := oObjCNB:LoadValue(  aLinCNB[nX][nPsa][2], IIF( ValType(aLinCNB[nX][nPsa][3] )<>"U" ,aLinCNB[nX][nPsa][3] , CriaVar(aLinCNB[nX][nPsa][2] )) )
										ElseIf Alltrim(aLinCNB[nX][nPsa][2]) $ "CNB_DESMTR"
											lAux := oObjCNB:LoadValue(  aLinCNB[nX][nPsa][2], 'NAO COBRA (INCLUSIVE ISS)' ) //ANDRE
										Else
											lAux := oObjCNB:SetValue(  aLinCNB[nX][nPsa][2], IIF( ValType(aLinCNB[nX][nPsa][3] )<>"U" ,aLinCNB[nX][nPsa][3] , CriaVar(aLinCNB[nX][nPsa][2] )) )
											//Ver com Sandro ou Kibino sobre o load
											If !lAux .and. Alltrim(aLinCNB[nX][nPsa][2]) $ "CNB_PRODUT/CNB_VLUNIT"
												lAux := oObjCNB:LoadValue(  aLinCNB[nX][nPsa][2], IIF( ValType(aLinCNB[nX][nPsa][3] )<>"U" ,aLinCNB[nX][nPsa][3] , CriaVar(aLinCNB[nX][nPsa][2] )) )
											EndIf 

										EndIf

										If Alltrim(aLinCNB[nX][nPsa][2]) $ "CNB_VLTOT"
											nValTot := oObjCNB:GetValue("CNB_QUANT") * oObjCNB:GetValue("CNB_VLUNIT")
											lAux := oObjCNB:SetValue(  aLinCNB[nX][nPsa][2], IIF( ValType(aLinCNB[nX][nPsa][3] )<>"U" , IIF( aLinCNB[nX][nPsa][3] <> nValTot .AND. nValTot > 0 , nValTot , aLinCNB[nX][nPsa][3] ) , CriaVar(aLinCNB[nX][nPsa][2] )) )
											If !lAux
												cTeste := ""
											EndIf
										EndIf

										If !lAux
											lRet := .F.
											nPsa := ascan(aLinCNB[nX],{ |x,y| alltrim(x[2]) == "CNB_PRODUT" } )
											cAuxErro += "Produto " + Alltrim(aLinCNB[nX][nPsa][3]) //" - Produto: "
											Exit
										EndIf
									Endif

									//Tratativa campos Bematech.
									If nI == Len(alFields)

										lRet := oObjCNB:SetValue("CNB_XINTAD", cEmpresaGer)

										If lRet

											cCEmpInt := U_TInPrdAdq( oObjCNB:GetValue("CNB_PRODUT") )

											If !Empty(cCEmpInt)

												// Se For portal Parceiros
												If U_IsPrpBPrt( cCEmpInt )  // Não precisa enviar o licenciamento, no retorno que foi gerado o contrato, é gerada a licença
													cRet := "2"

												// Se For Misterchef
												ElseIf u_IsPrpBMst(cCEmpInt)

													//  Somente produto licença, recorrencia não preenche o campo, pois não tem licenciamento externo, não deve ser enviado
													If U_GVPRODPON(oObjCNB:GetValue("CNB_PRODUT")) .Or. U_GVFUNSAAS( POSICIONE('SB1',1,FWXFILIAL('SB1')+oObjCNB:GetValue("CNB_PRODUT"),'B1_GRUPO')  )
														cRet := "2" // Iniciado com 2, pois inicialmente não temos que enviar nada. Somente quando tiver alguma manutenção de contrato
													EndIf

												EndIf

											EndIf

											lRet := oObjCNB:SetValue("CNB_XGERLC", cRet)

										Else
											U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Erro na tratativa da empresa integradora")
										EndIf

									EndIf
									//oObjCNB:LoadValue("CNB_IMPOST","9 ") //FGN
									//ANDRE.ALVES 03/07/19 oObjCNB:LoadValue("CNB_CTRRM",cObs)  //FGN
								Next nI

								If Len(aPn0) > 0
									AADD(aAuxPN0,aClone(aLinCNB[nX]))
								EndIf

							Endif
						EndIf

						If !lRet
							cAuxErro += "Inconsistencia planilha "  +oModel:GetModel('CNADETAIL'):GetValue("CNA_NUMERO") //" - inconsistência na Planilha: "
							Exit
						EndIf

						nLinhaAtu++

					Next nX

				EndIf

				//Se existir PH4.
				If lRet .And. Len(aPH4) > 0

					oMolAux	:= oModel:GetModel('PH4DETAIL')
					aLinPH4 := aClone(aTpPlanGrd[nC][2][4])
					cSeqPh4	:= StrZero(0,TamSx3("PH4_ITSEQ")[1])

					If Len(aLinPH4) == 0
						//lRet := .F.
						U_TINCLOGCT(cLogMIGRATOTVS,"ERRO-Mensagem;" + cContrato + ";Contrato com PH4 enviada mas não montou o pacote: " + cContrato)
					Else
						U_TINCLOGCT(cLogMIGRATOTVS,"SUCESSO-Mensagem;" + cContrato + ";PH4 enviada corretamente" + cContrato)
					EndIf

					For nX := 1 To Len(aLinPH4)

						FWMonitorMsg(STR0067+ Alltrim(Str(nX)) +STR0065+ Alltrim(Str(Len(aLinPH4))) +"]") //"Atualizando bonificação do contrato. ["###"]de["
						If !Empty(aLinPH4[nX])

							nI := 0
							For nI := 1 To Len(aLinPH4[nX])

								nPosCnb := MTFindMVC(oObjCNB,{	{"CNB_PRODUT",aLinPH4[nX][nI][1]},;
																{"CNB_PROPOS",cProposta},;
																{"CNB_PROREV",""},;
																{"CNB_PROITN",aLinPH4[nX][nI][6]},;
																{"CNB_XFLDPR","" } } )

								If nPosCnb > 0
									oObjCNB:GoLine(nPosCnb)

									CNTA300BlMd(oMolAux,.F.)
									MtBCMod(oModel , {oMolAux:CID} , {||.T.} )

									If !oMolAux:IsEmpty()

										oMolAux:GoLine(oMolAux:Length())
										cSeqPh4 := oMolAux:GetValue("PH4_ITSEQ")

										oMolAux:GoLine(oMolAux:Length())
										cSeqPh4 := oMolAux:GetValue("PH4_ITSEQ")
										nLinhaAtu := oMolAux:GetLine()
										If( nNewLine := oMolAux:AddLine() ) == nLinhaAtu
											lRet := .F.
										EndIf
										oMolAux:GoLine( nNewLine )
									Else
										If nNewPlan
											oMolAux:ClearData()
										Endif
									Endif

									If lRet
										If (lAux := oMolAux:SetValue(  "PH4_ITSEQ", Soma1(cSeqPh4) ))
											If (lAux := oMolAux:SetValue(  "PH4_ITEM", oObjCNB:GetValue("CNB_ITEM") ))
												If (lAux := oMolAux:SetValue(  "PH4_STATUS", "A" ))
													If (lAux := oMolAux:SetValue(  "PH4_TIPO", aLinPH4[nX][nI][10] ) .And. oMolAux:SetValue("PH4_TPDESC", "V" ) )
														If (lAux := oMolAux:SetValue(  "PH4_CMPINI", aLinPH4[nX][nI][3] ))
															If (lAux := oMolAux:SetValue(  "PH4_CMPFIM", aLinPH4[nX][nI][4] ))
																If (lAux := oMolAux:LoadValue(  "PH4_MOTBC", aLinPH4[nX][nI][9] ))
																	If (lAux := oMolAux:LoadValue(  "PH4_OBS", STR0038+ aLinPH4[nX][nI][3] +")" )) //"Inclusão de carência devido a competência do primeiro faturamento se Maior que a competência atual ("
																		If (lAux := oMolAux:LoadValue("PH4_PERDES", Iif(ValType(aLinPH4[nX][nI][7])=="C",Val(aLinPH4[nX][nI][7]),aLinPH4[nX][nI][7]) )/*oMolAux:SetValue(  "PH4_CMPFIM", aLinPH4[nX][nI][4] )*/)
																			If (lAux := oMolAux:LoadValue("PH4_VLRDES", Iif(ValType(aLinPH4[nX][nI][8])=="C",Val(aLinPH4[nX][nI][8]),aLinPH4[nX][nI][8]) )/*oMolAux:SetValue(  "PH4_CMPFIM", aLinPH4[nX][nI][4] )*/)
																				If (lAux := oMolAux:LoadValue("PH4_CLIENT", aLinPH4[nX][nI][11]))
																					If (lAux := oMolAux:LoadValue("PH4_LOJA", aLinPH4[nX][nI][12]))
																					EndIf
																				EndIf
																			EndIf
																		EndIf
																	EndIf
																EndIf
															EndIf
														EndIf
													EndIf
												EndIf
											EndIf
										EndIf
									EndIf
								Else
									lRet := .F.

									U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Contrato com PH4 enviada mas não montou o pacote: " + cContrato)
								EndIf

								If !lAux
									lRet := .F.
									cAuxErro += STR0037+ oObjCNB:GetValue("CNB_ITEM") //" - Numero Item: "
									Exit
								EndIf

							Next nI

						EndIf

						If !lRet
							cAuxErro += STR0036 +oModel:GetModel('CNADETAIL'):GetValue("CNA_NUMERO") //" - inconsistência na Planilha: "
							Exit
						EndIf

					Next nX

				EndIf

				//-------------------------
				// Tratamento PHG
				//-------------------------
				If lRet .And. Len(aPHG) > 0

					oMolAux	:= oModel:GetModel('PHGDETAIL')
					aDetPHG := aClone(aTpPlanGrd[nC][2][3])

					If Len(aDetPHG) == 0
						//lRet := .F.
						U_TINCLOGCT(cLogMIGRATOTVS,"ERRO-Mensagem;" + cContrato + ";Erro, foi enviado PHG para o contrato mas não foi possível montar o array deste model.")
					Else
						U_TINCLOGCT(cLogMIGRATOTVS,"SUCESSO-Mensagem;" + cContrato + ";PHG Enviado corretamente")
					EndIf

					For nX := 1 To Len(aDetPHG)

						FWMonitorMsg("Item"+ Alltrim(Str(nX)) +"Atualizando rateio do contrato. ['###']de["+ Alltrim(Str(Len(aDetPHG))) +"]")
						If !Empty(aDetPHG[nX])

							aLinPHG := aClone(aDetPHG[nX])
							nI := 0
							For nI := 1 To Len(aLinPHG)

								/*nPosCnb := MTFindMVC(oObjCNB,{	{"CNB_PRODUT",aLinPHG[nI][3]},;
									{"CNB_PROPOS",cProposta},;
									{"CNB_PROREV",""},;
									{"CNB_PROITN",aLinPHG[nI][4]},;
									{"CNB_XFLDPR","" } }  )*/
								nPosCnb := MTFindMVC(oObjCNB,{	{"CNB_PRODUT",aLinPHG[nI][3]},;
																{"CNB_PROPOS",cProposta} }  )
																

								If nPosCnb > 0
									CNTA300BlMd(oMolAux,.F.)
									MtBCMod(oModel , {oMolAux:CID} , {||.T.} )

									If !oMolAux:IsEmpty()

										oMolAux:GoLine(oMolAux:Length())
										nLinhaAtu := oMolAux:GetLine()
										If( nNewLine := oMolAux:AddLine() ) == nLinhaAtu
											lRet := .F.
										EndIf
										oMolAux:GoLine( nNewLine )
									Else
										If nNewPlan
											oMolAux:ClearData()
										Endif
									Endif

									If lRet

										oObjCNB:GoLine(nPosCnb)

										If (lAux := oMolAux:SetValue(  "PHG_CLIENT", IIF( ValType(aLinPHG[nI][1])<>"U", aLinPHG[nI][1], CriaVar("PHG_CLIENT")) ))
											If (lAux := oMolAux:SetValue(  "PHG_LOJA", IIF( ValType(aLinPHG[nI][2])<>"U", aLinPHG[nI][2], CriaVar("PHG_LOJA")) ))
												If (lAux := oMolAux:SetValue(  "PHG_ITEM", IIF( ValType(oObjCNB:GetValue("CNB_ITEM"))<>"U", oObjCNB:GetValue("CNB_ITEM"), CriaVar("PHG_ITEM")) ))
													If (lAux := oMolAux:SetValue(  "PHG_PERRAT", IIF( ValType(aLinPHG[nI][6])<>"U", Val(aLinPHG[nI][6]), CriaVar("PHG_PERRAT"))) )
													EndIf
												EndIf
											EndIf
										EndIf
									EndIf

								Else
									U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";PHG para o contrato: " + cContrato + " Não conseguiu localizar o produto na CNB")
									lRet := .F.
									Exit
								EndIf

								If !lAux
									cAuxErro += "Erro;" + cContrato + ";Item: "+ oObjCNB:GetValue("CNB_ITEM") //" - Numero Item: "
									lRet := .F.
									Exit
								EndIf

							Next nI

						EndIf

						If !lRet
							cAuxErro += " - inconsistência na Planilha: " +oModel:GetModel('CNADETAIL'):GetValue("CNA_NUMERO")
							Exit
						EndIf

					Next nX
				EndIf

				If !lRet
					Exit
				EndIf

			Next nC

			//Se existir PN0.
			If lRet .And. Len(aPN0) > 0

				oMolPN0 := oModel:GetModel("PN0DETAIL")

				CNTA300BlMd(oMolPN0,.F.)
				MtBCMod(oModel,{"PN0DETAIL"},{||.T.})

				nLinePn0	:= oMolPN0:GetLine()
				nNewPn0		:= 1

				nPosItCNB	:= aScan(aAuxPN0[1],{|x| Alltrim(x[2]) == "CNB_ITEM" })
				nPosItExt	:= aScan(aAuxPN0[1],{|x| Alltrim(x[2]) == "CNB_OUTITE" })
				nPosPlan	:= aScan(aAuxPN0[1],{|x| Alltrim(x[2]) == "CNA_NUMERO" })

				cItSeq := "000001"

				For nX := 2 to len(aPN0)
					nCpo := 1

					For nC := 1 to len(aPN0[nX])

						If Alltrim(aPN0[1][nCpo]) == "PN0_CONTRA"
							nCpo++
							Loop
						ElseIf Alltrim(aPN0[1][nCpo]) == "PN0_ITEM"

							//Tratativa para poder amarrar ao item correto.
							For nA := 1 to len(aAuxPN0)

								If Alltrim(aAuxPn0[nA][nPosItExt][3]) == Alltrim(aPN0[nX][nCPO])

									aPN0[nX][nCPO] := aAuxPN0[nA][nPosItCNB][3]

									lRet := oMolPN0:SetValue("PN0_NUMERO", Alltrim(aAuxPN0[nA][nPosPlan][3]))

									Exit

								EndIf

							Next nA

						ElseIf Alltrim(aPN0[1][nCpo]) == "PN0_SEQ"

							lRet := oMolPN0:SetValue("PN0_SEQ", cItSeq)

						EndIf

						If !lRet
							cAuxErro += "Erro no preenchimento da PN0, na mudança do número de planilha"
							Exit
						EndIf

						If TamSx3(aPN0[1][nCpo])[3] == "D"
							aPN0[nX][nCPO] := CTOD(aPN0[nX][nCPO])
						ElseIf TamSx3(aPN0[1][nCpo])[3] == "N"
							aPN0[nX][nCPO] := Val(aPN0[nX][nCPO])
						EndIf

						If Alltrim(aPN0[1][nCpo]) != "PN0_SEQ"
							lRet := oMolPN0:SetValue(Alltrim(aPN0[1][nCpo]), aPN0[nX][nCPO])
						EndIf

						If !lRet
							cAuxErro += "Erro no preenchimento da PN0."
							Exit
						EndIf

						nCpo++

					Next nC

					//Verificação na adição de novas linhas, caso necessário.
					If nX < Len(aPN0)

						cItSeq := Soma1(cItSeq)

						nNewPn0 := oMolPN0:AddLine()

						If nNewPn0 == 1 .And. nX < Len(aPN0)
							cAuxErro += "Erro ao adicionar nova linha na PN0."
							Exit
						EndIf

					EndIf

				Next nX

			EndIf

			// Gravação da PHB
			If lRet
				U_GV2EAPHB(__cUSerID,{cCodManGCT},cJustif,,"1",,cProposta)
			EndIf

		EndIf

	EndIf

Else
	U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Competência está fechada, e no momento não pode ser gerado contratos.")
	Help(" ",1, 'Help','GV032GCT_01',"Competência está fechada, e no momento não pode ser gerado contratos.", 3, 0 ) //
	lRet := .F.
EndIf

If lRet
	oMolAux:VldData()
Else
	U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Erro: " + oModel:GetErrorMessage()[6])
EndIf

RestArea(aAreaCN9)
FWMonitorMsg("Painel de Propostas.") //

Return(lRet)

//-----------------------------------------------------------
/*/{Protheus.doc} Gv32VldGct
//TODO Validação do modelo de contratos
@author Hermes
@since 24/08/2016

@param oModel, object, Modelo do contrato

/*/
//-----------------------------------------------------------
Static Function Gv32VldGct(oModel,nTpManut,cLogMIGRATOTVS)

	Local lOk 	:= .T.
	Local aErro	:= {}

	FWMonitorMsg(STR0068) //"Validando dados do contrato"

	//U_GV2SHLOG(.F.)

	lOk := oModel:VldData()

	If lOk .And. nTpManut <> 9
		oModel:GetModel("CN9MASTER"):SetValue("CN9_SITUAC", "05")
		//oModel:GetModel("CNBDETAIL"):SetValue("CNB_IMPOST", "9")
	Else
		aErro := oModel:GetErrorMessage()
		If Len(aErro) > 0

			AutoGrLog( AllToChar( Alltrim(aErro[1]) )			)	 //"Id do formulário de origem:"
			AutoGrLog( AllToChar( Alltrim(aErro[2]) )			)	 //"Id do campo de origem: "
			AutoGrLog( AllToChar( Alltrim(aErro[3]) )			)	 //"Id do formulário de erro: "
			AutoGrLog( AllToChar( Alltrim(aErro[4]) )			)	 //"Id do campo de erro: "
			AutoGrLog( AllToChar( Alltrim(aErro[5]) )			)	 //"Id do erro: "
			AutoGrLog( AllToChar( Alltrim(aErro[6]) ) 	        )	 //"Mensagem do erro: "
			AutoGrLog( AllToChar( Alltrim(aErro[7]) )  			)	 //"Mensagem da solução: "
			AutoGrLog( AllToChar( Alltrim(aErro[8]) )  			)	 //"Valor atribuído: "
			AutoGrLog( AllToChar( Alltrim(aErro[9]) ) 			) 	 //"Valor anterior: "

			If !IsInCallStack("_sGeraCont")  // Não deve mostrar erro quando é integração por tela do corporativo.
				cMensagemErro := MostraErro("\log-migratotvs\porcerro.LOG")
				cMensagemErro += CRLF
				If !Empty(aErro[1]) .AND. !(Alltrim(aErro[1]) $ cMensagemErro)
					cMensagemErro += Alltrim(aErro[1]) + CRLF
				EndIf

				If !Empty(aErro[2]) .AND. !(Alltrim(aErro[2]) $ cMensagemErro)
					cMensagemErro += Alltrim(aErro[2]) + CRLF
				EndIf

				If !Empty(aErro[3]) .AND. !(Alltrim(aErro[3]) $ cMensagemErro)
					cMensagemErro += Alltrim(aErro[3]) + CRLF
				EndIf

				If !Empty(aErro[4]) .AND. !(Alltrim(aErro[4]) $ cMensagemErro)
					cMensagemErro += Alltrim(aErro[4]) + CRLF
				EndIf

				If !Empty(aErro[5]) .AND. !(Alltrim(aErro[5]) $ cMensagemErro)
					cMensagemErro += Alltrim(aErro[5]) + CRLF
				EndIf

				If !Empty(aErro[6]) .AND. !(Alltrim(aErro[6]) $ cMensagemErro)
					cMensagemErro += Alltrim(aErro[6]) + CRLF
				EndIf

				If !Empty(aErro[7]) .AND. !(Alltrim(aErro[7]) $ cMensagemErro)
					cMensagemErro += Alltrim(aErro[7]) + CRLF
				EndIf

				If !Empty(aErro[8]) .AND. !(Alltrim(aErro[8]) $ cMensagemErro)
					cMensagemErro += Alltrim(aErro[8]) + CRLF
				EndIf

				If !Empty(aErro[9]) .AND. !(Alltrim(aErro[9]) $ cMensagemErro)
					cMensagemErro += Alltrim(aErro[9])
				EndIf

				U_TINCLOGCT(cLogMIGRATOTVS,cMensagemErro)
			EndIf

		EndIf

	EndIf

Return lOk

//-------------------------------------------------------------------
/*/{Protheus.doc} GV32Vigen
Função para deixar o contrato já em Vigência, sem necessidade de
aprovação manual por parte do usuário

@author Hermes
@since 10/11/2015
@version 1.0
@return ${return}, ${Se geraou a revisao do contrato}
/*/
//-------------------------------------------------------------------
Static Function GV32Vigen(oModel,cLogMIGRATOTVS)

	Local _cContraNew	:= oModel:GetModel("CN9MASTER"):GetValue("CN9_NUMERO")
	Local _cRevNew		:= oModel:GetModel("CN9MASTER"):GetValue("CN9_REVISA")
	Local lRet			:= .T.

	CN9->(dbSetOrder(1))
	If CN9->(dbSeek(FWxFilial('CN9')+ _cContraNew + _cRevNew ))

		Pergunte("CNT100",.F.)

		If CN9->CN9_SITUAC == DEF_SELAB
			CN100Situac('CN9',CN9->(Recno()),6,DEF_SVIGE)

			If CN9->CN9_SITUAC <> DEF_SVIGE
				lRet := .F.
				U_TINCLOGCT(cLogMIGRATOTVS,"Erro;" + cContrato + ";Não foi possível deixar o contrato vigente.")
				Help(" ",1, 'Help','GV32Vigen', "Não foi possível deixar o contrato vigente.", 3, 0 ) //"Não foi possível deixar o contrato vigente."
			Else
				//Ajuste Pre - ate atualizar release nao estava enviando com o U_
				U_GV001SIT(CN9->CN9_SITUAC)
			EndIf
		Else
			lRet := U_GCTXAPR(_cContraNew ,  _cRevNew )
		EndIf

	EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GVCMPOPEN
Verifica se a Competencia está aberta.
@author Hermes
@since 15/12/2015
@version 1.0
@return ${lRet}, ${True - Aberto / False - Fechado}
/*/
//-------------------------------------------------------------------
Static Function xGVCMPOP( cCompOpen , cUnidNeg )

	Local lRet		:=	.T.
	Local aAreaPHQ	:= PHQ->(GetArea())

	Default cCompOpen	:= Alltrim(StrZero( Month(MsDate()),2 )) +"/"+Alltrim(str(year(MsDate())))
	Default cUnidNeg	:= FWCodFil()

	If cFilAnt != '01101000100'
		dbSelectArea('PHQ')
		PHQ->(dbSetOrder(1)) // PHQ_FILIAL+PHQ_COMPET+PHQ_UNINEG
		If PHQ->(dbSeek(FWxFilial('PHQ')+ cCompOpen + cUnidNeg	))
			If Alltrim(PHQ->PHQ_STATUS) == '2'
				lRet := .F.
			EndIf
		EndIf
	EndIf
	RestArea(aAreaPHQ)

Return lRet

//--------------------------------------------------
/*/{Protheus.doc} TINCLOGCT
Função centralizadora de Log.

@author Irineu Filho
@since 02/04/2020
/*/
//--------------------------------------------------
User Function TINCLOGCT(cLocArq,cTextoLog)

	u_xAcaLog(cLocArq,cTextoLog)

Return

/*/{Protheus.doc} BuscAox()
	Preenche a AOX
	adicionado desta forma pois no migratotvs tinha um arquivo e é diferente do conteudo da tabela AOX
	@type  Static Function
	@author user
	@since 23/08/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function BuscAox(cTabelas)

Local aRet := {}	
Local cQueryT

Default cTabelas := "CN9/CNA/CNB/CNC"

cQueryT := "SELECT P96_TABELA,P96_CAMPO,P96_RELAOX,P96_TIPO"
cQueryT += " FROM "+RetSQLName("P96")
cQueryT += " WHERE P96_FILIAL='"+xFilial("P96")+"'"
cQueryT += " AND P96_TABELA IN('"+strtran(cTabelas,"/","','")+"')"
cQueryT += " AND D_E_L_E_T_=' ' AND P96_TEMAOX='1'"
cQueryT += " ORDER BY P96_TABELA,P96_CAMPO"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQueryT ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
	Aadd(aRet,{TRB->P96_TABELA,Alltrim(TRB->P96_CAMPO),Alltrim(TRB->P96_RELAOX),TRB->P96_TIPO})
	Dbskip()
Enddo 
/*
Aadd(aRet,{"CN9","CN9_NUMERO","'CON'+SA1->A1_COD","C"})
Aadd(aRet,{"CN9","CN9_UNVIGE","'4'","C"})
Aadd(aRet,{"CN9","CN9_DTFIM","","D"})
Aadd(aRet,{"CN9","CN9_MOEDA","1","C"})
Aadd(aRet,{"CN9","CN9_FLGREJ","","C"})
Aadd(aRet,{"CN9","CN9_INDICE","","C"})
Aadd(aRet,{"CN9","CN9_FLGCAU","'2'","C"})
Aadd(aRet,{"CN9","CN9_SITUAC","'05'","C"})
Aadd(aRet,{"CN9","CN9_EST","SA1->A1_EST","C"})
Aadd(aRet,{"CN9","CN9_VLDCTR","'2'","C"})
Aadd(aRet,{"CN9","CN9_FILORI","","C"})
Aadd(aRet,{"CN9","CN9_ESPCTR","'2'","C"})
Aadd(aRet,{"CN9","CN9_FILCTR","","C"})
Aadd(aRet,{"CN9","CN9_LOGDAT","MSDATE()","D"})
Aadd(aRet,{"CN9","CN9_LOGUSR","__CUSERID","C"})
Aadd(aRet,{"CN9","CN9_LOGHOR","TIME()","C"})
Aadd(aRet,{"CN9","CN9_PERI","1","N"})
Aadd(aRet,{"CN9","CN9_UNPERI","'3'","C"})
Aadd(aRet,{"CN9","CN9_MODORJ","'1'","C"})
Aadd(aRet,{"CN9","CN9_PRORAT","'2'","C"})
Aadd(aRet,{"CN9","CN9_MSBLQL","'2'","C"})
Aadd(aRet,{"CN9","CN9_XORIGE","'FATA600'","C"})
Aadd(aRet,{"CN9","CN9_TPCTO","'013'","C"})
Aadd(aRet,{"CN9","CN9_DTINIC","","D"})
Aadd(aRet,{"CN9","CN9_ASSINA","","D"})
Aadd(aRet,{"CN9","CN9_DTASSI","","D"})
Aadd(aRet,{"CN9","CN9_CONDPG","","C"})
Aadd(aRet,{"CN9","CN9_DATASS","","D"})
Aadd(aRet,{"CN9","CN9_SITUA","","C"})
Aadd(aRet,{"CN9","CN9_DTSITU","MSDATE()","D"})
Aadd(aRet,{"CN9","CN9_AUDITA","","C"})
Aadd(aRet,{"CNA","CNA_CLIENT","SA1->A1_COD","C"})
Aadd(aRet,{"CNA","CNA_LOJACL","SA1->A1_LOJA","C"})
Aadd(aRet,{"CNA","CNA_DTINI","","D"})
Aadd(aRet,{"CNA","CNA_TIPPLA","","C"})
Aadd(aRet,{"CNA","CNA_DTFIM","","D"})
Aadd(aRet,{"CNA","CNA_PERIOD","'4'","C"})
Aadd(aRet,{"CNA","CNA_QTDREC","9999","N"})
Aadd(aRet,{"CNA","CNA_DIASEM","'2'","C"})
Aadd(aRet,{"CNA","CNA_FLREAJ","","C"})
Aadd(aRet,{"CNA","CNA_INDICE","","C"})
Aadd(aRet,{"CNA","CNA_PERI","1","N"})
Aadd(aRet,{"CNA","CNA_UNPERI","'3'","C"})
Aadd(aRet,{"CNA","CNA_PROPAR","'2'","C"})
Aadd(aRet,{"CNA","CNA_MODORJ","'1'","C"})
Aadd(aRet,{"CNA","CNA_PRORAT","'2'","C"})
Aadd(aRet,{"CNA","CNA_MSBLQL","'2'","C"})
Aadd(aRet,{"CNA","CNA_DIAMES","","N"})
Aadd(aRet,{"CNB","CNB_IMPOST","","C"})
Aadd(aRet,{"CNB","CNB_NOTASE","","C"})
Aadd(aRet,{"CNB","CNB_ATIVO","'1'","C"})
Aadd(aRet,{"CNB","CNB_INDCTR","","C"})
Aadd(aRet,{"CNB","CNB_PRODUT","","C"})
Aadd(aRet,{"CNB","CNB_QUANT","","N"})
Aadd(aRet,{"CNB","CNB_VLUNIT","","N"})
Aadd(aRet,{"CNB","CNB_VLTOT","","N"})
Aadd(aRet,{"CNB","CNB_TS","'503'","C"})
Aadd(aRet,{"CNB","CNB_INDICE","","C"})
Aadd(aRet,{"CNB","CNB_SITUAC","","C"})
Aadd(aRet,{"CNB","CNB_DIAVEN","","N"})
Aadd(aRet,{"CNB","CNB_DATASS","","D"})
Aadd(aRet,{"CNB","CNB_VIGFIM","","D"})
Aadd(aRet,{"CNB","CNB_ITMPRO","","C"}) --
Aadd(aRet,{"CNB","CNB_CONDIC","","C"})
Aadd(aRet,{"CNB","CNB_DOCENT","","C"})
Aadd(aRet,{"CNB","CNB_ORIGEM","","C"})
Aadd(aRet,{"CNB","CNB_MOEDA","","C"})
Aadd(aRet,{"CNB","CNB_ANTIMP","","C"})
Aadd(aRet,{"CNB","CNB_SERMID","","C"})
Aadd(aRet,{"CNB","CNB_STATRM","","C"})
Aadd(aRet,{"CNB","CNB_DTSITU","","D"})
Aadd(aRet,{"CNB","CNB_QTDLIC","","N"})
Aadd(aRet,{"CNB","CNB_PROCAN","","C"})
Aadd(aRet,{"CNB","CNB_CONDPG","","C"})
Aadd(aRet,{"CNB","CNB_MODORJ","","C"})
Aadd(aRet,{"CNB","CNB_FLREAJ","","C"})
Aadd(aRet,{"CNB","CNB_MSBLQL","","C"})
Aadd(aRet,{"CNB","CNB_PROREV","","C"}) --
Aadd(aRet,{"CNB","CNB_PROITN","","C"}) --
Aadd(aRet,{"CNB","CNB_TIPREC","","C"})
Aadd(aRet,{"CNB","CNB_PROPOS","","C"})
Aadd(aRet,{"CNB","CNB_VIGINI","","D"})
Aadd(aRet,{"CNB","CNB_PROXRJ","","D"})
Aadd(aRet,{"CNB","CNB_UNINEG","","C"})
Aadd(aRet,{"CNB","CNB_GRUPO","","C"})
Aadd(aRet,{"CNB","CNB_XCOMPE","","C"})
Aadd(aRet,{"CNB","CNB_VENCTO","","D"})
Aadd(aRet,{"CNB","CNB_XDTIFI","","D"}) --
Aadd(aRet,{"CNB","CNB_XDTFFI","","D"}) --
Aadd(aRet,{"CNB","CNB_OBSERV","","C"}) --
Aadd(aRet,{"CNB","CNB_XNUMLI","","C"}) --
Aadd(aRet,{"CNB","CNB_XITEXT","","C"}) --
Aadd(aRet,{"CNB","CNB_OUTITE","","C"}) --
Aadd(aRet,{"CNB","CNB_PRIMED","","D"})
Aadd(aRet,{"CNB","CNB_XFANTS","","C"}) --
Aadd(aRet,{"CNB","CNB_XSLICM","","C"}) --
Aadd(aRet,{"CNB","CNB_CTRRM","","C"})  --
Aadd(aRet,{"CNB","CNB_PROPDT","","C"}) --
Aadd(aRet,{"CNB","CNB_XITPAI","","C"}) --
Aadd(aRet,{"CNB","CNB_XBILLI","","C"}) 
Aadd(aRet,{"CNB","CNB_XTPCNT","","C"}) --
Aadd(aRet,{"CNB","CNB_XAVPRE","","C"}) 
Aadd(aRet,{"CNC","CNC_DTATUA","","C"})
Aadd(aRet,{"CNC","CNC_CLIENT","SA1->A1_COD","C"})
Aadd(aRet,{"CNC","CNC_LOJACL","SA1->A1_LOJA","C"})
Aadd(aRet,{"CNC","CNC_TIPCLI","","C"})
Aadd(aRet,{"CNC","CNC_INADIM","'N'","C"})
Aadd(aRet,{"CNC","CNC_ATENDE","","C"})
Aadd(aRet,{"CNC","CNC_MSBLQL","","C"})
Aadd(aRet,{"CNC","CNC_MSGNF","","C"})
*/
Return(aRet) 
