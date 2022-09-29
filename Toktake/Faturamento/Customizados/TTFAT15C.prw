#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFAT15C  ºAutor  ³Jackson E. de Deus  º Data ³  06/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Baixa do canhoto                                           º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³06/11/14³01.00 |Criacao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TTFAT15C(nRecno,dData,cHora,cEntregue,cAssinado,cNome,cRG,nKm,lNfSaida)

Default nRecno := Nil
Default dData := Nil
Default cHora := Nil
Default cEntregue := Nil
Default cAssinado := Nil
Default nKm := 0
Default lNfsaida := .T.

If nRecno == Nil .Or. dData == Nil .Or. cHora == Nil .Or. cEntregue == Nil .Or. cAssinado == Nil
	Return
EndIf 

If cEmpAnt <> "01"
	Return
EndIf

If lNfsaida
	dbSelectArea("SF2")
	dbGoTo(nRecno)
	If Recno() == nRecno
		If RecLock("SF2",.F.)
			SF2->F2_XDTENTR := dData
			SF2->F2_XHRENTR := cHora
			SF2->F2_XRECENT := cEntregue
			SF2->F2_XRECASS := cAssinado
			SF2->F2_XENTNOM := cNome
			SF2->F2_XENTRG := cRG
			SF2->F2_XENTKM := nKm	
			MsUnlock()
		EndIf
	EndIf   
	
	
	DbSelectArea("SE1")
	DbsetOrder(1)
	If DbSeek( xFilial("SE1")+SF2->F2_FILIAL+Alltrim(SF2->F2_SERIE)+SF2->F2_DOC )
		While !EOF() .And. SE1->E1_NUM == SF2->F2_DOC .AND. SE1->E1_PREFIXO == SF2->F2_FILIAL+Alltrim(SF2->F2_SERIE)
			Reclock("SE1",.F.)
			SE1->E1_XRECENT := cEntregue
			SE1->E1_XRECASS := cAssinado
			SE1->E1_XHRENTR := cHora
			SE1->E1_XDTENTR := dData
			SE1->(Msunlock())
			dbSkip()
		EndDo
	EndIf 
// nota devolucao
Else
	dbSelectArea("SF1")
	dbGoTo(nRecno)
	If Recno() == nRecno
		If RecLock("SF1",.F.)
			SF1->F1_XDTENTR := dData
			SF1->F1_XHRENTR := cHora
			SF1->F1_XRECENT := cEntregue
			SF1->F1_XRECASS := cAssinado
			SF1->F1_XENTNOM := cNome 
			SF1->F1_XENTRG := cRG       
			SF1->F1_XENTKM := nKm        
			MsUnlock()
		EndIf
	EndIf   
EndIf  

Return