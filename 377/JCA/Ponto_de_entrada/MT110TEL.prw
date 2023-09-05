#INCLUDE "PROTHEUS.CH"
/*
    Ponto de entrada inclusão itens cabeçalho Solicitação de compras
    MIT 44_COMPRAS_COM011 _ Tipos de solicitação de compras
    https://docs.google.com/document/d/1ESMwrvQ37rSRT1_DmEgjO9yVyINOCblA/edit
    
*/
user function MT110TEL      
Local oNewDialog := PARAMIXB[1]
Local aPosGet    := PARAMIXB[2]
Local aStatusP   := {}
Private aCombo   := RetSX3Box(GetSX3Cache("C1_XTIPCOT", "X3_CBOX"),,,1)
Public nEditS     := IF(INCLUI,1,VAL(SC1->C1_XTIPCOT))
//Public cEx	     := SPACE(5)   

Aeval(aCombo,{|x| Aadd(aStatusP,x[1]) })

aadd(aPosGet[1],0) 
aadd(aPosGet[1],0)

aPosGet[1,7]:=400
aPosGet[1,8]:=450

@ 51,aPosGet[1,7] SAY 'Tipo de Solicitação' PIXEL SIZE 60,9 Of oNewDialog
@ 50, aPosGet[1,8] COMBOBOX oEdit1 VAR nEditS ITEMS aStatusP SIZE 60, 013 OF oNewDialog PIXEL COLORS 0, 16777215

nEditS := cvaltochar(nEditS)

RETURN 

