#INCLUDE "PROTHEUS.CH"
/*
    Ponto de entrada inclusão itens cabeçalho Solicitação de compras
    MIT 44_COMPRAS_COM011 _ Tipos de solicitação de compras

    Doc Mit
    https://docs.google.com/document/d/1ESMwrvQ37rSRT1_DmEgjO9yVyINOCblA/edit
    Doc Entrega
    https://docs.google.com/document/d/1WLVRJPTqv6ou7Q4bhUW5dIJZCuDqy2v8/edit
    
*/
user function MT110TEL    

Local oNewDialog := PARAMIXB[1]
Local aPosGet    := PARAMIXB[2]
Local aStatusP   := {}

Private aCombo   := RetSX3Box(GetSX3Cache("C1_XTIPCOT", "X3_CBOX"),,,1)

Public cJCACC     := IF(INCLUI,space(20),SC1->C1_CC)
Public nEditS     := IF(INCLUI,1,VAL(SC1->C1_XTIPCOT))

Aeval(aCombo,{|x| Aadd(aStatusP,x[1]) })

aadd(aPosGet[1],0) 
aadd(aPosGet[1],0)

aPosGet[1,7]:= (aPosGet[1,4]+((aPosGet[1,5]-aPosGet[1,4])/2)) - 30 //380
aPosGet[1,8]:=aPosGet[1,7]+50 //430

aadd(aPosGet[1],0) 
aadd(aPosGet[1],0)

aPosGet[1,9]:= (aPosGet[1,2]+((aPosGet[1,3]-aPosGet[1,2])/2)) - 50 //380
aPosGet[1,10]:=aPosGet[1,9]+50 //430

@ 51,aPosGet[1,9] SAY 'Centro de Custo' PIXEL SIZE 60,9 Of oNewDialog
@ 50, aPosGet[1,10] MSGET oEdit1 VAR cJCACC SIZE 60, 009 OF oNewDialog PIXEL COLORS 0, 16777215 F3 "CTT"

@ 51,aPosGet[1,7] SAY 'Tipo de Solicitação' PIXEL SIZE 60,9 Of oNewDialog
@ 50, aPosGet[1,8] COMBOBOX oEdit1 VAR nEditS ITEMS aStatusP SIZE 60, 013 OF oNewDialog PIXEL COLORS 0, 16777215

nEditS := cvaltochar(nEditS)
cJCACC := cJCACC

RETURN 

