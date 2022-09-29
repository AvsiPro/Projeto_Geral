#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFATG03  ºAutor  ³Alexandre Venancio  º Data ³  03/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao para exibir apenas os armazens ao qual o usuario º±±
±±º          ³tenha permissao de visualizar                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Permissao e concedida no campo ZZ1_XGPV                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTFATG03(nopc)  

Local lRet	:=	.F.
Local nPos	:=	Ascan(aHeader,{|x| x[2] = "C6_LOCAL"})  

Default nopc := 0

// Tratamento para AMC
If cEmpAnt == "10"
	Return .T.
EndIf

                    
If nopc == 0
	IF Alltrim(M->C5_XGPV) $ Alltrim(POSICIONE("ZZ1",1,xFilial("ZZ1")+M->C6_LOCAL,"ZZ1_XGPV")) .OR. "*" $ Alltrim(POSICIONE("ZZ1",1,xFilial("ZZ1")+M->C6_LOCAL,"ZZ1_XGPV")) 
		lRet := .T. 
	Else
		MsgALert("O Grupo contido no pedido não tem permissão para movimentar mercadorias neste estoque","TTFATG03")
	EndIF	
Else
	If Alltrim(M->C5_XGPV) $ Alltrim(POSICIONE("ZZ1",1,xFilial("ZZ1")+aCols[n,nPos],"ZZ1_XGPV"))
		lRet := aCols[n,nPos]
	Else
		lRet := ""
	EndIf
EndIf

Return(lRet)              