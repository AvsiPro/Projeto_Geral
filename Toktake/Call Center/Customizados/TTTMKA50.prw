#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA50  บAutor  ณMicrosiga           บ Data ณ  04/30/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao de NF de retorno no processo de omm de remocao.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMKA50(cCliente,omm)
            
Local aArea			:= GetArea()
Local cQuery                    
Local lRet			:= {} 
Local nItem			:=	1
Local aAux			:=	{} 

Private aCab		:= {}
Private aItensD1	:= {}
Private aIt			:= {}
Private lMsErroAuto	:= .F.    

Default cCliente := ""
Default omm	 	 := ""

If cEmpAnt <> "01"
	Return(.T.)
EndIf

//Prepare Environment Empresa "01" Filial "01" //Tables "ZZE"   

cDocto     := GetSx8Num("SF2","F2_DOC")

aCab := {  { "F1_FILIAL"	, cfilant					, Nil, Nil },;
			{ "F1_DOC"		, cDocto	 				, Nil, Nil },;
            { "F1_SERIE"	, '2'						, Nil, Nil },;
            { "F1_FORNECE"	, substr(cCliente,1,6)		, Nil, Nil },;
            { "F1_LOJA"		, substr(cCliente,7,4)		, Nil, Nil },;
            { "F1_EMISSAO"	, DDATABASE					, Nil, Nil },;
            { "F1_EST"		, SM0->M0_ESTENT			, Nil, Nil },;      
            { "F1_TIPO"		, 'D'						, Nil, Nil },;
            { "F1_FORMUL"	, 'S'						, Nil, Nil },;
            { "F1_ESPECIE"	, 'SPED'					, Nil, Nil }}
            
DbSelectArea("SUD")
DbSetOrder(1)
DbSeek(xFilial("SUD")+omm)

While !EOF() .AND. SUD->UD_CODIGO == omm


	aAux := tela(SUD->UD_PRODUTO,cCliente) 
	
	If len(aAux) > 0
		aItensD1 := {}
		
		AAdd( aItensD1, { "D1_ITEM"		, Strzero(nItem,2)		, Nil} )
		AAdd( aItensD1, { "D1_COD"		, SUD->UD_PRODUTO		, Nil} )
		AAdd( aItensD1, { "D1_QUANT"	, 1						, Nil} )			
		AAdd( aItensD1, { "D1_VUNIT"	, aAux[1,2]				, Nil} )			
		AAdd( aItensD1, { "D1_TOTAL"	, aAux[1,2]				, Nil} )			
		AAdd( aItensD1, { "D1_TES"		, aAux[1,3]				, Nil} ) 
		AAdd( aItensD1, { "D1_CC"		, ""					, Nil} )
		AAdd( aItensD1, { "D1_NFORI"	, aAux[1,1]				, Nil} )
		
		AAdd(aIt,aItensD1) 
	    nItem++
	EndIf	    
	DbSkip() 
EndDo

MsExecAuto({|x,y,z,w|Mata103(x,y,z,w)},aCab, aIt,3,.F.)

If lMsErroAuto
	MostraErro()
	lRet := .F.
Else
	lRet := .T.                                                                                  
	cMsg := "Nota Fiscal de Entrada gerada pelo processo de OMM numero "+SF1->F1_DOC+CHR(13)+CHR(10)+"Agora fa็a o procedimento de transmissใo da nota e impressใo"
	U_TTMAILN('microsiga@toktake.com.br',Alltrim(cusername)+'@toktake.com.br','NF Retorno OMM',cMsg,{},.F.)
Endif       

RestArea(aArea)

Return(lRet)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA50  บAutor  ณMicrosiga           บ Data ณ  04/30/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function tela(produto,cCliente)

Local aArea	:=	GetArea()
Local oDlg1,oGrp1,oBrw1,oBtn1,oList1
Local aList1 := {} 
Local aRet	:= {}
Local nOp	:= 0   
Local nLinha := 1

cQuery := "SELECT F4_TESDV,C5_MENNOTA,C6_XPATRIM,D2_PEDIDO,D2_ITEM,D2_QTDEDEV,D2_TES,D2_PRCVEN,D2_QUANT,D2_COD,D2_ITEM,D2_DOC,D2_EMISSAO"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_FILIAL=D2_FILIAL AND F4_CODIGO=D2_TES AND F4.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SC6")+" C6 ON C6_FILIAL=D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_ITEM=D2_ITEM AND C6.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5.D_E_L_E_T_=''"
cQuery += " WHERE D2_FILIAL='"+xFilial("SD2")+"' AND D2_COD='"+Alltrim(produto)+"' AND D2_CLIENTE='"+substr(cCliente,1,6)+"'  AND D2.D_E_L_E_T_=''" 
//--AND D2_LOJA='0326'"
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTTMKA50.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()

	Aadd(aList1,{TRB->D2_DOC,TRB->C6_XPATRIM,CVALTOCHAR(STOD(TRB->D2_EMISSAO)),TRB->C5_MENNOTA,TRB->D2_PRCVEN,TRB->F4_TESDV})
	Dbskip()
EndDo 

If len(aList1) > 1
	
	oDlg1      := MSDialog():New( 048,250,359,704,"Nota Fiscal de Origem",,,.F.,,,,,,.T.,,,.T. )
	
	oGrp1      := TGroup():New( 000,004,128,216,"Selecione a nota que sera utilizada para o retorno",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,008,124,212},,, oGrp1 )
		oList1 := TCBrowse():New(008,008,200,080,, {'NF Saida','Patrimonio','Emissใo','Obs NF'},{30,30,30,50},;
	                            oGrp1,,,,{|| nLinha := oList1:nAt },{|| /*If(oList1:nAt<6 .And. !lCxFech,editcol1(oList1:nAt),)*/},, ,,,  ,,.F.,,.T.,,.F.,,,.F.)
		oList1:SetArray(aList1)
		oList1:bLine := {||{ aList1[oList1:nAt,01],;
		 					  aList1[oList1:nAt,02],;
							  aList1[oList1:nAt,03],;
							  aList1[oList1:nAt,04]}} 
	 
	oBtn1      := TButton():New( 132,087,"Confirmar",oDlg1,{||oDlg1:end(nOp := 1)},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)  
	
	If nOp == 1
	//TRB->D2_DOC,TRB->C6_XPATRIM,CVALTOCHAR(STOD(TRB->D2_EMISSAO)),TRB->C5_MENNOTA,TRB->D2_PRCVEN,TRB->F4_TESDV}
		Aadd(aRet,{aList1[nLinha,01],aList1[nLinha,05],aList1[nLinha,06]}) 
	EndIf   
Else
	Aadd(aRet,{'000100000',2000,'302'})
EndIf

RestArea(aArea)

Return(aRet)