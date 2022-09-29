#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AT460GRV  ºAutor  ³Jackson E. de Deus  º Data ³  01/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE executado apos a gravacao do Atendimento de OS           º±±
±±º          ³                                                            º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³01/05/14³01.01 |Criacao                                 ³±±
±±³Jackson       ³26/09/14³01.01 |Tratamento de patrimonio excluido da    ³±±
±±³								  base instalada.                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function AT460GRV()
                   
Local aArea := GetArea()
Local lOSFim := .F.       
Local cOSField := AB7->AB7_NUMOS
Local cChamadoTec := Substr(AB7->AB7_NRCHAM,1,8)
Local cSolucao := MSMM(AB9->AB9_MEMO1)

If cEmpAnt == "10"
	Return
EndIf

// Acerta status do item do atendimento - AB7
dbSelectArea("AB7")
If AllTrim(AB7->AB7_TIPO) <> "5"
	If RecLock("AB7",.F.)
		AB7->AB7_TIPO := "5"
		AB7->( MsUnLock() ) 
		MSMM(AB7->AB7_MEMO3,,,cSolucao,1,,,"AB7","AB7_MEMO3")
	EndIf	
EndIf

// verifica se finalizou a OS
lOSFim := U_TTTECC06(cOSField)
If lOSFim
	dbSelectArea("AB6")
	dbSetOrder(1)
	If dbSeek( xFilial("AB6") +AvKey( cOSField,"AB6_NUMOS") )
		If AllTrim(AB6->AB6_STATUS) <> "E"
			If RecLock("AB6",.F.) 
				AB6->AB6_STATUS := "E"
				AB6->( MsUnLock() )
			EndIf             
		EndIf
	EndIf
	If !Empty(cChamadoTEc)
		U_TTTECC07(cChamadoTec,Nil,AB9->AB9_DTFIM,AB9->AB9_HRFIM) // Verifica se tem atendimento no call center - fecha e dispara email para o operador
	EndIf
EndIf

// Ajuste para exluir novamente o patrimonio da base instalada - nos casos em que seja necessario recupera-lo
If Type("_nRecAA3") == "N"
	dbSelectArea("AA3")
	dbGoto(_nRecAA3)
	If Recno() == _nRecAA3
		RecLock("AA3",.F.)
		dbDelete()
		MsUnLock()
	EndIf
EndIf

MsUnLockAll()			
			                        
RestArea(aArea)

Return