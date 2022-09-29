#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RH_CONTAB ³ Autor ³ Equipe Microsiga     ³ Data ³ 20.08.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para busca de Contas Contabeis a partir do cadastro ³±±
±±³          ³ de Verbas.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ 			                                      			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CTA_CONTABIL(cTipoCta)

Local cConta  := ""
Local cCampo  := ""
DEFAULT cTipoCta := ""

If cEmpAnt <> "10"
	Return(cConta)
EndIf

cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_XTPCUS")

If cTipoCta == "D"
	
	If cGrupo == "1"
		cCampo := "RV_DEBITO"
	ElseIf cGrupo == "2"
		cCampo := "RV_DEBITOF"
	ElseIf cGrupo == "3"
		cCampo := "RV_DEBITOP"
	ElseIf cGrupo == "4"
		cCampo := "RV_DEBITOA"
	EndIf
	
	
ElseIf cTipoCta == "C"
	
	If cGrupo == "1"
		cCampo := "RV_CREDITO"
	ElseIf cGrupo == "2"
		cCampo := "RV_CREDITF"
	ElseIf cGrupo == "3"
		cCampo := "RV_CREDITP"
	ElseIf cGrupo == "4"
		cCampo := "RV_CREDITA"
	EndIf
	
EndIf

cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,cCampo)


Return(cConta)  

/*
////////////////////////////////////////////////////////
//             CENTRO DE CUSTO                       //
///////////////////////////////////////////////////////
*/

User Function cCC(cTipoCC)

Local  cGrupo := ""  
Local cCamp := "" 
Local cCC := ""
DEFAULT cTipoCC := "" 


cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_XTPCUS")

If cTipoCC == "D"
	
	If cGrupo == "1"
		cCamp := "RV_DEBITO"
	ElseIf cGrupo == "2"
		cCamp := "RV_DEBITOF"
	ElseIf cGrupo == "3"
		cCamp := "RV_DEBITOP"
	ElseIf cGrupo == "4"
		cCamp := "RV_DEBITOA"
	EndIf
	
	
ElseIf cTipoCC == "C"
	
	If cGrupo == "1"
		cCamp := "RV_CREDITO"
	ElseIf cGrupo == "2"
		cCamp := "RV_CREDITF"
	ElseIf cGrupo == "3"
		cCamp := "RV_CREDITP"
	ElseIf cGrupo == "4"
		cCamp := "RV_CREDITA"
	EndIf
	
EndIf

cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,cCamp) 

If cTipoCC == "D" .And. !(SUBSTR(cConta,1,1) $ "12")

	cCC := SRZ->RZ_CC

ElseIf cTipoCC == "C" .And. !(SUBSTR(cConta,1,1) $ "12")
        
	cCC := SRZ->RZ_CC

Else
    
    cCC := Space(09)

EndIf

Return(cCC)


/*
////////////////////////////////////////////////////////
//                 ITEM CONTABIL                     //
///////////////////////////////////////////////////////
*/

User Function cItem(cTipItem)

Local  cGrupo := ""  
Local cCamp_ := ""    
Local cItem := ""
DEFAULT cTipItem := "" 


cGrupo := POSICIONE("CTT",1,xFILIAL("CTT") + SRZ->RZ_CC, "CTT_XTPCUS")

If cTipItem == "D"
	
	If cGrupo == "1"
		cCamp_ := "RV_DEBITO"
	ElseIf cGrupo == "2"
		cCamp_ := "RV_DEBITOF"
	ElseIf cGrupo == "3"
		cCamp_ := "RV_DEBITOP"
	ElseIf cGrupo == "4"
		cCamp_ := "RV_DEBITOA"
	EndIf
	
	
ElseIf cTipItem == "C"
	
	If cGrupo == "1"
		cCamp_ := "RV_CREDITO"
	ElseIf cGrupo == "2"
		cCamp_ := "RV_CREDITF"
	ElseIf cGrupo == "3"
		cCamp_ := "RV_CREDITP"
	ElseIf cGrupo == "4"
		cCamp_ := "RV_CREDITA"
	EndIf
	
EndIf

cConta := PosSrv(SRZ->RZ_PD,SRZ->RZ_FILIAL,cCamp_) 

If cTipItem == "D" .And. !(SUBSTR(cConta,1,1) $ "12")

	cItem := SRZ->RZ_ITEM

ElseIf cTipItem == "C" .And. !(SUBSTR(cConta,1,1) $ "12")
        
	cItem := SRZ->RZ_ITEM

Else
    
    cItem := Space(09)

EndIf

Return(cItem)
		