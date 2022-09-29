/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CAD_SB1  ³ Autor ³ Artur Nucci Ferrari    ³ Data ³ 17/11/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Controle para o cadastro de Produtos                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Tok-Take                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch"
                         
User Function CADVIP()
Local aArea	:= GetArea()
Local lRet  := .F.
Local cUserLib  := Upper(AllTrim(cusername))
Local cCADVIP   := AllTrim(SuperGetMv("MV_XCADVIP"))
IF cUserLib$(cCADVIP)
 lRet  := .T.
End            
RestArea(aArea)
Return(lRet)   

User Function CADFAT()
Local aArea	:= GetArea()
Local lRet  := .F.
Local cUserLib  := Upper(AllTrim(cusername))
Local cSB1FAT   := AllTrim(SuperGetMv("MV_XSB1FAT"))
IF cUserLib$(cSB1FAT)
 lRet  := .T.
End            
RestArea(aArea)
Return(lRet)

User Function CADFIS()
Local aArea	:= GetArea()
Local lRet  := .F.
Local cUserLib  := Upper(AllTrim(cusername))
Local cSB1FIS   := AllTrim(SuperGetMv("MV_XSB1FIS"))
IF cUserLib$(cSB1FIS)
 lRet  := .T.
End            
RestArea(aArea)
Return(lRet)

User Function CADCTB()
Local aArea	:= GetArea()
Local lRet  := .F.
Local cUserLib  := Upper(AllTrim(cusername))
Local cSB1CTB   := AllTrim(SuperGetMv("MV_XSB1CTB"))
IF cUserLib$(cSB1CTB)
 lRet  := .T.
End            
RestArea(aArea)
Return(lRet)

User Function CADFAB()
Local aArea	:= GetArea()
Local lRet  := .F.
Local cUserLib  := Upper(AllTrim(cusername))
Local cSB1FAB   := AllTrim(SuperGetMv("MV_XSB1FAB"))
IF cUserLib$(cSB1FAB)
 lRet  := .T.
End            
RestArea(aArea)
Return(lRet)

User Function CADFIN()
Local aArea	:= GetArea()
Local lRet  := .F.
Local cUserLib  := Upper(AllTrim(cusername))
Local cSB1FIN   := AllTrim(SuperGetMv("MV_XSB1FIN"))
IF cUserLib$(cSB1FIN)
 lRet  := .T.
End            
RestArea(aArea)
Return(lRet) 


User Function INCSE2()
Local aArea	:= GetArea()
Local lRet  := .F.
Local cUserLib  := Upper(AllTrim(cusername))
Local cCADSE2   := AllTrim(SuperGetMv("MV_XINCSE2"))
IF cUserLib$(cCADSE2)
 lRet  := .T.
End            
RestArea(aArea)
Return(lRet)     

User Function INCSE1()
Local aArea	:= GetArea()
Local lRet  := .F.
Local cUserLib  := Upper(AllTrim(cusername))
Local cCADSE2   := AllTrim(SuperGetMv("MV_XINCSE1"))
IF cUserLib$(cCADSE1)
 lRet  := .T.
End  
RestArea(aArea)
Return(lRet)                             

User Function CADPA01()
Local aArea		:=	GetArea()
Local lRet 		:= .F.
Local cCADPA   	:= AllTrim(SuperGetMv("MV_XTPA01"))


If Alltrim(upper(cusername)) $ cCADPA
	lRet := .T.
EndIf


RestArea(aArea)

Return(lRet)


User Function CADCOM()

Local aArea		:=	GetArea()
Local lRet 		:= .F.
Local cCADPA   	:= AllTrim(SuperGetMv("MV_XSB1COM"))

If Alltrim(upper(cusername)) $ cCADPA .or. Alltrim(cusername) == "AVENANCIO"
	lRet := .T.
EndIf        

RestArea(aArea)

Return(lRet) 