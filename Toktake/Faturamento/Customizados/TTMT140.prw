#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTMT140   บAutor  ณAlexandre Venancio  บ Data ณ  17/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criacao da nota de devolucao da rota.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTMT140(aAux,cMsgNF)

Local aArea			:=	GetArea()
Local nOpc 			:= 0
Local nVlrax		:= 0  
Local cTes			:= ''
Local cAliasXF		:= ""
Local cLocal		:= ""
Local cDocto		:= ""
Local nI
private aCabec		:= {}
private aItens		:= {}
private aLinha		:= {}
Private lMsErroAuto := .F.  

If cEmpAnt <> "01"
	Return
EndIf

cAliasXF := "2  " +xFilial("SF1") +"\system\SF2" +cEmpAnt +"0                               "
cDocto :=  GetSxeNum("NFF","F2_DOC",cAliasXF)
                   

aCabec := 	{	{'F1_TIPO'		,'D'			,NIL},;
				{'F1_FORMUL'	,'S'			,NIL},;
				{'F1_DOC'		,cDocto 		,NIL},;
				{'F1_SERIE'		,'2'	   		,NIL},;		
				{'F1_EMISSAO'	,dDataBase		,NIL},;		
				{'F1_FORNECE'	,'000001'  		,NIL},;		
				{'F1_LOJA'		,'0001'	   		,NIL},;
				{'F1_EST'		,'SP'	   		,NIL},;
				{'F1_ESPECIE'	,'SPED'	   		,NIL},; 
				{'F1_MENNOTA'	,cMsgNF			,NIL},;
				{'F1_COND'		,'001'	   		,NIL} }				
                                      

// produto qtd preco nota serie item tes local
For nI := 1 to len(aAux)

	nVlrax := aAux[nI][3]
	cTes := aAux[nI][7]
	cLocal := aAux[nI][8]
	If !Empty(cTes)
		cTes := Posicione("SF4",1,xFilial("SF4")+cTes,"F4_TESDV")
	Else
		cTes := '26F'
	EndIF                                   

	aItens :=	{	{'D1_COD'		,aAux[nI,01]			,NIL},; 
					{'D1_UM'		,Posicione("SB1",1,xFilial("SB1")+AvKey(aAux[nI,01],"B1_COD"),"B1_UM" )		,NIL},;				
					{'D1_QUANT'		,aAux[nI,02]			,NIL},;		
					{'D1_VUNIT'		,nVlrax					,NIL},;	   
					{'D1_TOTAL'		,NoRound(nVlrax*aAux[nI,02],TamSX3("D1_TOTAL")[2])	,NIL},;		
					{'D1_LOCAL'		,cLocal					,NIL},;
					{'D1_TES'		,cTes					,NIL},;					
					{'D1_NFORI'		,aAux[nI][4]			,NIL},;
					{'D1_SERIORI'	,aAux[nI][5]			,NIL},;
					{'D1_ITEMORI'	,aAux[nI][6]			,NIL}}
					
	AAdd(aLinha,aItens)
Next nI

nOpc := 3 


//MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aLinha, nOpc)     
MSExecAuto({|x,y,z| MATA103(x,y,z)}, aCabec, aLinha, nOpc)     

If lMsErroAuto
	Mostraerro()
	dbSelectArea("SF1")
	dbSetOrder(1)	// forn loja nf serie tipo
	If ! MSSeek( xFilial("SF1") +AvKey(cDocto,"F1_DOC") +AvKey("2","F1_SERIE") +AvKey("000001","F1_FORNECE") +AvKey("0001","F1_LOJA") +AvKey("D","F1_TIPO")  )
		cDocto := ""
		RollBackSx8()
	Else
		If Empty( SF1->F1_MENNOTA )
			Reclock("SF1",.F.)
			SF1->F1_MENNOTA := cMsgNf
			MsUnLock()
		EndIf	       
	EndIf
Else
	ConfirmSX8()
	If MSSeek( xFilial("SF1") +AvKey(cDocto,"F1_DOC") +AvKey("2","F1_SERIE") +AvKey("000001","F1_FORNECE") +AvKey("0001","F1_LOJA") +AvKey("D","F1_TIPO")  )
		If Empty( SF1->F1_MENNOTA )
			Reclock("SF1",.F.)
			SF1->F1_MENNOTA := cMsgNf
			MsUnLock()
		EndIf	       
	EndIf
EndIf

RestArea(aArea)

Return cDocto