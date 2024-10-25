#INCLUDE "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MSD2460
Ponto de entrada executado depois da gravação do item de Nota Fiscal de Saída (SD2)  
@author  Diego Donatti
@since   27/10/2022
@Alteração - Everton Rosa 24/10/2024 - Retirar a funcionalidade para o grupo de empresa 03
@version version
/*/
//-------------------------------------------------------------------
User Function MSD2460()

	Local cEmpNExc := SuperGetMV("TI_EMPNEXC",.F.,"03")
	Local aArea  := GetArea()
	Local cDescCC:= ""
	Local cDescCL:= ""

	IF !cEmpAnt $ cEmpNExc 
		RestArea(aArea)
		Return
	endif

    //Posiciona Centro de Custo e Classe de Valor
	cDescCC:= Posicione("CTT",1,xFilial("CTT")+M->D2_CCUSTO,"CTT_DESC01")
	cDescCL:= Posicione("CTH",1,xFilial("CTH")+M->D2_CLVL,"CTH_DESC01")

    // Atualiza o campo D2_XDESCCC 
	If !Empty(cDescCC)
		RecLock("SD2",.F.)
		SD2->D2_XDESCCC
		MsUnlock()
	EndIf

    // Atualiza o campo D2_XDESCCL 
	If !Empty(cDescCL)
		RecLock("SD2",.F.)
		SD2->D2_XDESCCL
		MsUnlock()
	EndIf

	RestArea(aArea)

Return
