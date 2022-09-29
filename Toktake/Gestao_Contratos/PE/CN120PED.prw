#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN120PED  ºAutor  ³Alexandre Venancio  º Data ³  05/13/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE utilizado para incluir informacoes no pedido de  venda  º±±
±±º          ³que sera gerado pela planilha do Modulo Contratos.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN120PED()

Local aArea := GetArea()
Local ExpA1 := PARAMIXB[1]
Local ExpA2 := PARAMIXB[2]
Local ExpC3 := PARAMIXB[3]    
Local nPos := 0
Local nPosIt := 0
Local nPosQ := 0
Local nPosQS := 0
Local nPosQSUM := 0
Local nPosP := 0
Local nPosT := 0
Local nQtd := 0 
Local cItem := ""
Local nX
Local aRet := {}
	
If cEmpAnt == "01"
	
	              //cn9->cn9_xtpfat
	If POSICIONE("CN1",1,XFILIAL("CN9")+CN9->CN9_TPCTO,"CN1_ESPCTR") == "2"              
		If CN9->CN9_XTPFAT == "1" .AND. !EMPTY(CN9->CN9_XCNTPA)
			aRet	:=	ContPai(CN9->CN9_XCNTPA)
			ExpA1[3,2] :=	aRet[1]
			ExpA1[4,2] :=	aRet[2]
			ExpA1[5,2] :=	aRet[2]
			ExpA2[len(ExpA2),10,2] :=	aRet[1]
			ExpA2[len(ExpA2),11,2] :=	aRet[2]
		EndIf
		              
		Aadd(ExpA1,{"C5_XFINAL"		,CND->CND_XFINAL	,NIL})
		Aadd(ExpA1,{"C5_XCCUSTO"	,CND->CND_XCC		,Nil})
		Aadd(ExpA1,{"C5_XITEMCC"	,CND->CND_XITEMC	,Nil})
		Aadd(ExpA1,{"C5_MENNOTA"	,'Periodo faturamento '+SUBSTR(CN9->CN9_XPCOMP,1,2)+'/'+SUBSTR(CVALTOCHAR(CTOD('01/'+CNF->CNF_COMPETE)-1),4,8)+' A '+cvaltochar(CTOD(SUBSTR(CN9->CN9_XPCOMP,1,2)+'/'+SUBSTR(CVALTOCHAR(CTOD('01/'+CNF->CNF_COMPETE)-1),4,8))+30)+Alltrim(CND->CND_OBS)+Alltrim(CN9->CN9_XOBSNF),Nil})
		Aadd(ExpA1,{"C5_XDTENTR"	,DDATABASE+3		,Nil})
		//Validações do usuário.  
		//EXPA1[16,2] :=   
	else
		nPos := ascan(PARAMIXB[2,1],{|x| ALLTRIM(x[1]) == "C7_CC"}) 
		
		For nX := 1 to len(ExpA2)
			ExpA2[nX,nPos,2] := CND->CND_XCC
		Next nX
		
		
		// ajuste quantidade preco
		For nX := 1 To Len(ExpA2)
			nPosIt := ascan(ExpA2[nX],{|x| ALLTRIM(x[1]) == "C7_ITEM"})
			nPosQ := ascan(ExpA2[nX],{|x| ALLTRIM(x[1]) == "C7_QUANT"})
			nPosQS := ascan(ExpA2[nX],{|x| ALLTRIM(x[1]) == "C7_QTDSOL"})
			nPosQSUM := ascan(ExpA2[nX],{|x| ALLTRIM(x[1]) == "C7_QTSEGUM"})
			nPosP := ascan(ExpA2[nX],{|x| ALLTRIM(x[1]) == "C7_PRECO"}) 
			nPosT := ascan(ExpA2[nX],{|x| ALLTRIM(x[1]) == "C7_TOTAL"})
			
			nQtd := ExpA2[nX][nPosQ][2]
			If nQtd < 1
				cItem := StrZero(Val(ExpA2[nX][nPosIt][2]),3,0)
				dbSelectArea("CNE")
				dbSetOrder(1)
				dbSeek( xFilial("CNE") +CND->CND_CONTRA +CND->CND_REVISA +CND->CND_NUMERO +CND->CND_NUMMED +cItem )
				nQtd := 1
				//nVal := CNE->CNE_VLTOT
				
				ExpA2[nX][nPosQ][2] := nQtd
				ExpA2[nX][nPosQS][2] := nQtd
				ExpA2[nX][nPosQSUM][2] := nQtd
				
				ExpA2[nX][nPosP][2] := CNE->CNE_VLTOT
				ExpA2[nX][nPosT][2] := CNE->CNE_VLTOT
			EndIf		
		Next nX	
	EndIf
EndIF

RestArea(aArea)
 
Return {ExpA1,ExpA2}  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN120PED  ºAutor  ³Microsiga           º Data ³  08/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE UTILIZADO PARA MANIPULAR OS ITENS DO PEDIDO DE VENDA NA º±±
±±º          ³GERACAO ATRAVES DO MODULO DE CONTRATOS.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN120ITM()

Local ExpA1 := PARAMIXB[1]
Local ExpA2 := PARAMIXB[2]
Local ExpC1 := PARAMIXB[3]

Return {ExpA1,ExpA2}                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN120PED  ºAutor  ³Microsiga           º Data ³  08/22/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ContPai(contr)

Local aArea	:= GetArea()
Local cQuery
Local aRet	:=	{}

cQuery := "SELECT CN9_CLIENT,CN9_LOJACL FROM "+RetSQLName("CN9")+" WHERE CN9_NUMERO='"+contr+"' AND CN9_FILIAL='"+xFilial("CN9")+"' AND D_E_L_E_T_=''

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("CN120PED.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

Aadd(aRet,TRB->CN9_CLIENT)
Aadd(aRet,TRB->CN9_LOJACL)   

RestArea(aArea)

Return(aRet)